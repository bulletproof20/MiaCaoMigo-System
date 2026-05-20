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
-- - vw_produtos_para_encomendar view
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
begin
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
end;
$$;

-- =========================================================
-- Emits notices when products fall below minimum stock thresholds
-- =========================================================

create or replace procedure sp_check_restock_needs()
language plpgsql
as $$
declare
    v_total_produtos int;
begin
    select count(*) into v_total_produtos
    from vw_produtos_para_encomendar;

    if v_total_produtos > 0 then
        raise notice
            'ATENÇÃO: Existem % produtos que atingiram o stock mínimo e precisam de reposição!',
            v_total_produtos;
        raise notice
            'Consulte a view vw_produtos_para_encomendar para ver a lista detalhada.';
    else
        raise notice
            'Stock em conformidade: Nenhum produto necessita de encomenda no momento.';
    end if;
end;
$$;
