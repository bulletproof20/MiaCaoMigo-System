-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- =========================================================
-- FILE: 05_Procedures_Mod3.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Procedures supporting procurement receiving and consolidated
-- low-stock monitoring notices.
--
-- This file contains:
-- - Purchase-to-stock materialization
-- - Advisory scan of reorder candidates
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - purchase / purchase_line / stock schema
-- - vw_products_to_reorder view
--
-- Must load before:
-- - Manual or scheduled inventory review jobs
-- =========================================================

-- =========================================================
-- Marks a purchase as received and mirrors lines into stock rows
-- =========================================================

create or replace procedure sp_receive_purchase(p_id_pur int)
language plpgsql
as $$
declare
    v_line record;
    v_id_sto int;
    v_dummy purchase_status;
begin
    select sta_pur
    into v_dummy
    from purchase
    where id_pur = p_id_pur
    for update;

    if not found then
        raise exception 'Encomenda com ID % não encontrada.', p_id_pur;
    end if;

    if not exists (
        select 1
        from purchase_line
        where id_pur = p_id_pur
    ) then
        raise exception 'Encomenda com ID % não tem linhas para receção.', p_id_pur;
    end if;

    update purchase
    set sta_pur = 'received'
    where id_pur = p_id_pur;

    for v_line in
        select *
        from purchase_line
        where id_pur = p_id_pur
    loop
        insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
        values (v_line.id_pro, v_line.bat_pln, v_line.qty_pln, current_date, null)
        returning id_sto into v_id_sto;

        update purchase_line
        set id_sto = v_id_sto
        where id_pur_lin = v_line.id_pur_lin;
    end loop;

exception
    when others then
        raise exception 'Falha ao receber encomenda %: %', p_id_pur, sqlerrm;
end;
$$;

-- =========================================================
-- Emits notices when products fall below minimum stock thresholds
-- =========================================================

create or replace procedure sp_check_restock_needs()
language plpgsql
as $$
declare
    v_total_products int;
begin
    select count(*) into v_total_products
    from vw_products_to_reorder;

    if v_total_products > 0 then
        raise notice
            'WARNING: % products are at or below minimum stock and need replenishment.',
            v_total_products;
        raise notice
            'See view vw_products_to_reorder for the detailed list.';
    else
        raise notice
            'Stock em conformidade: Nenhum produto necessita de encomenda no momento.';
    end if;
end;
$$;
