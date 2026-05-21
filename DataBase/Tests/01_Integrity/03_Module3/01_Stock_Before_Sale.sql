-- =========================================================
-- INTEGRITY — MODULE 3 — STOCK BEFORE SALE
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/03_Module3_Commercial.sql (INT-P001)
-- RULE:     trg_check_stock_before_sale / fn_check_stock_before_sale
-- CONTRACT: qa_product_int_p001_id
-- =========================================================

insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
select qa_product_int_p001_id(), 'INT-STOCK-01', 50, current_date, current_date + interval '1 year'
where not exists (
    select 1 from stock
    where id_pro = qa_product_int_p001_id() and bat_sto = 'INT-STOCK-01'
);

do $$
declare
    v_id_inv int;
    v_id_pro int := qa_product_int_p001_id();
begin
    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'integrity stock test', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    values (v_id_inv, v_id_pro, 999, 10.00, 23.00);

    raise notice 'FAIL: insufficient stock sale should be blocked';
exception
    when others then
        if sqlerrm like '%Stock insuficiente%' or sqlerrm like '%stock%' then
            raise notice 'PASS: insufficient stock blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected stock error — %', sqlerrm;
        end if;
end;
$$;
