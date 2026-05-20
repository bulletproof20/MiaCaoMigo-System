-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- =========================================================
-- FILE: 02_Functions_Mod3.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Database functions for stock, invoicing, returns, and sales validation.
--
-- This file contains:
-- - Available stock calculations and FIFO consumption
-- - Invoice total maintenance
-- - Sale and return guards
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 3 tables (product, stock, invoice, invoice_line, return)
-- - fn_get_available_stock before triggers that reference it
--
-- Must load before:
-- - 03_Triggers_Mod3.sql
-- =========================================================

-- =========================================================
-- Returns total available units for a product across stock rows
-- =========================================================

create or replace function fn_get_available_stock(p_id_pro int)
returns int
language plpgsql
as $$
begin
    return coalesce(
        (
            select sum(qty_sto)
            from stock
            where id_pro = p_id_pro
              and qty_sto > 0
        ),
        0
    );
end;
$$;

-- =========================================================
-- Raises a notice when post-sale stock falls at or below minimum
-- =========================================================

create or replace function fn_warn_low_stock()
returns trigger
language plpgsql
as $$
declare
    v_stock_atual int;
    v_min_sto int;
    v_nam_pro varchar;
begin
    select fn_get_available_stock(new.id_pro) into v_stock_atual;

    select min_sto, nam_pro
      into v_min_sto, v_nam_pro
    from product
    where id_pro = new.id_pro;

    if v_stock_atual <= v_min_sto then
        raise notice
            'STOCK BAIXO: O produto "%" (ID: %) tem apenas % unidades. (Mínimo: %). Consulte a view vw_produtos_para_encomendar.',
            v_nam_pro, new.id_pro, v_stock_atual, v_min_sto;
    end if;

    return new;
end;
$$;

-- =========================================================
-- Blocks invoice lines when requested quantity exceeds available stock
-- =========================================================

create or replace function fn_check_stock_before_sale()
returns trigger
language plpgsql
as $$
declare
    v_stock_atual int;
begin
    select fn_get_available_stock(new.id_pro) into v_stock_atual;

    if v_stock_atual < new.qty_inv_lin then
        raise exception
            'Stock insuficiente para o produto % (disponível: %, solicitado: %)',
            new.id_pro, v_stock_atual, new.qty_inv_lin;
    end if;

    return new;
end;
$$;

-- =========================================================
-- Applies FIFO stock reductions after an invoice line insert
-- =========================================================

create or replace function fn_stock_after_sale()
returns trigger
language plpgsql
as $$
declare
    v_stock_record record;
    v_remaining_qty int;
begin
    v_remaining_qty := new.qty_inv_lin;

    for v_stock_record in
        select id_sto, qty_sto
        from stock
        where id_pro = new.id_pro
          and qty_sto > 0
        order by val_dat_sto nulls last
    loop
        if v_remaining_qty <= v_stock_record.qty_sto then
            update stock
            set qty_sto = v_stock_record.qty_sto - v_remaining_qty
            where id_sto = v_stock_record.id_sto;
            exit;
        else
            update stock
            set qty_sto = 0
            where id_sto = v_stock_record.id_sto;
            v_remaining_qty := v_remaining_qty - v_stock_record.qty_sto;
        end if;
    end loop;

    return new;
end;
$$;

-- =========================================================
-- Recalculates invoice total from persisted invoice lines
-- =========================================================

create or replace function fn_update_invoice_total()
returns trigger
language plpgsql
as $$
declare
    v_id_inv int;
begin
    v_id_inv := coalesce(new.id_inv, old.id_inv);

    update invoice
    set val_inv = (
        select coalesce(
            sum(il.qty_inv_lin * il.uni_pri_inv_lin * (1 + il.iva_inv_lin / 100)),
            0
        )
        from invoice_line il
        where il.id_inv = v_id_inv
    )
    where id_inv = v_id_inv;

    return coalesce(new, old);
end;
$$;

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
begin
    select il.id_pro, il.qty_inv_lin
      into v_id_pro, v_qty_sold
    from invoice_line il
    where il.id_inv_lin = new.id_inv_lin;

    if new.qty_ret > v_qty_sold then
        raise exception
            'Quantidade devolvida (%) excede a quantidade vendida (%)',
            new.qty_ret, v_qty_sold;
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
        new.qty_ret,
        current_date,
        null
    );

    return new;
end;
$$;

-- =========================================================
-- Blocks sales lines targeting inactive products
-- =========================================================

create or replace function fn_prevent_inactive_product_sale()
returns trigger
language plpgsql
as $$
declare
    v_is_inactive boolean;
begin
    select ina_dat_pro is not null
      into v_is_inactive
    from product
    where id_pro = new.id_pro;

    if v_is_inactive then
        raise exception 'Produto % está inativo e não pode ser vendido', new.id_pro;
    end if;

    return new;
end;
$$;

-- =========================================================
-- Defaults return inactivation timestamp when omitted on insert
-- =========================================================

create or replace function fn_set_return_inactivation_date()
returns trigger
language plpgsql
as $$
begin
    if new.ina_dat_ret is null then
        new.ina_dat_ret := now();
    end if;
    return new;
end;
$$;
