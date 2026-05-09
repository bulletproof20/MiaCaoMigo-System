-- Stock disponível de um produto (todos os lotes juntos)
create or replace function fn_get_available_stock(p_product_id int)
returns int as $$
begin
    return coalesce(
        (select sum(qty_sto) from stock where id_pro = p_product_id and qty_sto > 0),
        0
    );
end;
$$ language plpgsql;


-- Impede venda acima do stock disponível (invoice_line)
create or replace function trg_check_stock_before_sale_func()
returns trigger as $$
declare
    stock_atual int;
begin
    select fn_get_available_stock(new.id_pro) into stock_atual;

    if stock_atual < new.qty_inv_lin then
        raise exception 'Stock insuficiente para o produto % (disponível: %, solicitado: %)',
                         new.id_pro, stock_atual, new.qty_inv_lin;
    end if;

    return new;
end;
$$ language plpgsql;


-- Atualiza stock após venda (FIFO por data de validade)
create or replace function trg_stock_after_sale_func()
returns trigger as $$
declare
    stock_record record;
    remaining_quantity int;
begin
    remaining_quantity := new.qty_inv_lin;

    for stock_record in
        select id_sto, qty_sto from stock
        where id_pro = new.id_pro and qty_sto > 0
        order by val_dat_sto nulls last
    loop
        if remaining_quantity <= stock_record.qty_sto then
            update stock set qty_sto = stock_record.qty_sto - remaining_quantity
            where id_sto = stock_record.id_sto;
            exit;
        else
            update stock set qty_sto = 0
            where id_sto = stock_record.id_sto;
            remaining_quantity := remaining_quantity - stock_record.qty_sto;
        end if;
    end loop;

    return new;
end;
$$ language plpgsql;


-- Atualiza total da fatura após alteração em invoice_line
create or replace function trg_update_invoice_total_func()
returns trigger as $$
declare
    inv_id int;
begin
    if tg_op = 'DELETE' then
        inv_id := old.id_inv;
    else
        inv_id := new.id_inv;
    end if;

    update invoice set val_inv = (
        select coalesce(sum(qty_inv_lin * uni_pri_inv_lin * (1 + iva_inv_lin / 100)), 0)
        from invoice_line
        where id_inv = inv_id
    )
    where id_inv = inv_id;

    return coalesce(new, old);
end;
$$ language plpgsql;


-- Devolução: repõe stock com base na linha de fatura
create or replace function trg_return_restock_func()
returns trigger as $$
declare
    prod_id int;
    qty_sold int;
begin
    if new.id_inv_lin is null then
        return new;
    end if;

    select id_pro, qty_inv_lin into prod_id, qty_sold
    from invoice_line where id_inv_lin = new.id_inv_lin;

    if prod_id is null then
        raise exception 'Linha de fatura % inválida para devolução', new.id_inv_lin;
    end if;

    if new.qty_ret > qty_sold then
        raise exception 'Quantidade devolvida (%) excede a quantidade vendida (%)',
                         new.qty_ret, qty_sold;
    end if;

    insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
    values (
        prod_id,
        (select bat_sto from stock where id_pro = prod_id order by ent_dat_sto desc nulls last limit 1),
        new.qty_ret,
        now(),
        null
    );

    return new;
end;
$$ language plpgsql;


-- Impede venda de produto inativo
create or replace function trg_prevent_inactive_product_sale_func()
returns trigger as $$
declare
    is_inactive boolean;
begin
    select ina_dat_pro is not null into is_inactive
    from product where id_pro = new.id_pro;

    if is_inactive then
        raise exception 'Produto % está inativo e não pode ser vendido', new.id_pro;
    end if;

    return new;
end;
$$ language plpgsql;


-- Data de inativação da devolução: preenche ina_dat_ret se não vier preenchida
create or replace function trg_set_return_return_date_func()
returns trigger as $$
begin
    if new.ina_dat_ret is null then
        new.ina_dat_ret := now();
    end if;
    return new;
end;
$$ language plpgsql;
