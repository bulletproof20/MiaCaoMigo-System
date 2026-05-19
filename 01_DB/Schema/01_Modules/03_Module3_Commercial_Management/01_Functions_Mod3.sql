-- stock disponível de um produto (todos os lotes juntos)
CREATE OR REPLACE FUNCTION fn_get_available_stock(p_product_id INT)
RETURNS INT AS $$
BEGIN
    RETURN COALESCE(
        (SELECT SUM(qty_sto) FROM stock WHERE id_pro = p_product_id AND qty_sto > 0),
        0
    );
END;
$$ LANGUAGE plpgsql;


-- function that is called by the trigger that checks for low stock 
-- after a sale and raises a notice if the stock is below the minimum

CREATE OR REPLACE FUNCTION fn_warn_low_stock()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_atual INT;
    v_min_sto INT;
    v_nam_pro VARCHAR;

BEGIN

    -- 1. Ver stock após abate
    SELECT fn_get_available_stock(new.id_product) INTO v_stock_atual;
    
    -- 2. Buscar dados do produto específico
    SELECT min_sto, nam_pro INTO v_min_sto, v_nam_pro
    FROM product 
    WHERE id_pro = new.id_product;
    
    -- 3. Aviso se atingir o limite individual
    IF v_stock_atual <= v_min_sto THEN
        RAISE NOTICE ' stock BAIXO: O produto "%" (ID: %) tem apenas % unidades. (Mínimo: %). Consulte a View vw_produtos_para_encomendar.', 
                     v_nam_pro, new.id_product, v_stock_atual, v_min_sto;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- ====================================================================
-- Blocks invoice lines when requested quantity exceeds available stock
-- ====================================================================
--

CREATE OR REPLACE FUNCTION fn_check_stock_before_sale()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_atual INT;
BEGIN
    SELECT fn_get_available_stock(new.id_product) INTO v_stock_atual;
    
    IF v_stock_atual < new.quantity THEN
        RAISE EXCEPTION 'stock insuficiente para o produto % (disponível: %, solicitado: %)',
                         new.id_product, v_stock_atual, new.quantity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ==========================================================
-- Applies FIFO stock reductions after an invoice line insert
-- ==========================================================

CREATE OR REPLACE FUNCTION fn_stock_after_sale()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_record RECORD;
    v_remaining_quantity INT;
BEGIN
    v_remaining_quantity := new.quantity;
    
    -- Percorre lotes FIFO (primeiro a expirar primeiro)
    FOR v_stock_record IN
        SELECT id_sto, qty_sto 
            FROM stock
        WHERE id_pro = new.id_product 
            AND qty_sto > 0
        ORDER BY val_dat_sto NULLS LAST
    LOOP
        IF v_remaining_quantity <= v_stock_record.qty_sto THEN
            UPDATE stock SET qty_sto = v_stock_record.qty_sto - v_remaining_quantity
            WHERE id_sto = v_stock_record.id_sto;
            exit;
        ELSE
            UPDATE stock 
                SET qty_sto = 0
            WHERE id_sto = v_stock_record.id_sto;
            v_remaining_quantity := v_remaining_quantity - v_stock_record.qty_sto;
        END IF;
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



-- =========================================================
-- Recalculates invoice total from persisted invoice lines
-- =========================================================

CREATE OR REPLACE FUNCTION fn_update_invoice_total()
RETURNS TRIGGER AS $$
declare
    v_id_inv int;
BEGIN

    v_id_inv := coalesce(new.id_invoice, old.id_invoice);

    update invoice
    set val_inv = (
        select coalesce(
            sum(il.quantity * il.unit_price * (1 + il.iva / 100)),
            0
        )
        from invoice_line il
        where il.id_invoice = v_id_inv
    )
    where id_inv = v_id_inv;

    return coalesce(new, old);
end;
$$ LANGUAGE plpgsql;

-- =========================================================
-- Restocks inventory when a return row is recorded
-- =========================================================
create or replace function fn_return_restock()
returns trigger
language plpgsql
as $$
declare
    v_id_pro int;
    v_qty_sold int;
BEGIN

    select il.id_product, il.quantity
      into v_id_pro, v_qty_sold
    from invoice_line il
    where il.id_invoice_line = new.id_invoice_line;

    if new.quant_ret > v_qty_sold then
        raise exception
            'Quantidade devolvida (%) excede a quantidade vendida (%)',
            new.quant_ret, v_qty_sold;
    end if;

    insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
    values (
        v_id_pro,
        (
            select bat_sto
            from stock
            where id_pro = v_id_pro
            order by ent_dat_sto desc
            limit 1
        ),
        new.quant_ret,
        now(),
        null
    );

    return new;
end;
$$;



--function for not seeling products that are not ative 

CREATE OR REPLACE FUNCTION fn_prevent_inactive_product_sale()
RETURNS TRIGGER AS $$
DECLARE
    v_is_inactive BOOLEAN;
BEGIN
    SELECT ina_dat_pro IS NOT NULL INTO v_is_inactive
    FROM product WHERE id_pro = new.id_product;
    
    IF v_is_inactive THEN
        RAISE EXCEPTION 'Produto % está inativo e não pode ser vendido', new.id_product;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- function for setting return date to current timestamp if not provided

CREATE OR REPLACE FUNCTION fn_set_return_date()
RETURNS TRIGGER AS $$
BEGIN
    if new.return_date is null then
        new.return_date := now();
    end if;
    return new;
END;
$$ LANGUAGE plpgsql;



-- function to start a new purchase and automatically return the new ID
CREATE OR REPLACE FUNCTION fn_create_purchase(
    p_id_emp INT DEFAULT NULL,
    p_id_cli INT DEFAULT NULL
)
RETURNS INT AS $$
DECLARE
    v_new_purchase_id INT;
BEGIN
    -- Usufrui dos valores DEFAULT criados na tabela para o pur_dat_pur e sta_pur
    INSERT INTO purchase (id_emp, id_cli)
    VALUES (p_id_emp, p_id_cli)
    RETURNING id_pur INTO v_new_purchase_id;
    
    RETURN v_new_purchase_id;
END;
$$ LANGUAGE plpgsql;


-- function for updating purchase total after inserting/updating/deleting a purchase line
CREATE OR REPLACE FUNCTION trg_update_purchase_total_func()
RETURNS TRIGGER AS $$
DECLARE
    v_id_pur INT;
BEGIN
    -- Garante que funciona tanto para INSERT/UPDATE (NEW) como para DELETE (OLD)
    IF TG_OP = 'DELETE' THEN
        v_id_pur := old.id_purchase;
    ELSE
        v_id_pur := new.id_purchase;
    END IF;

    UPDATE Purchase SET tot_val_pur = (
        SELECT COALESCE(SUM(QUANTITY * UNIT_COST), 0)
        FROM purchase_line
        WHERE id_purchase = v_id_pur
    )
    WHERE id_pur = v_id_pur;
    
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$ LANGUAGE plpgsql;
