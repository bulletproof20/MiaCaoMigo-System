-- =========================================================
-- INTEGRITY — MODULE 3 — RETURN QUANTITY
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: Bootstrap init_demo (DemoData Mod3)
-- RULE:     trg_return_restock / fn_return_restock
-- FIXTURES: Demo product id_pro 2
-- =========================================================
-- expected:
-- - return quantity greater than sold quantity blocked
-- =========================================================

insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
select id_pro, 'INT-STOCK-03', 20, current_date, current_date + interval '1 year'
  from product where ref_pro = 'INT-P001';

do $$
declare
    v_id_inv int;
    v_id_lin int;
begin
    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'integrity return test', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    select v_id_inv, id_pro, 2, 10.00, 23.00 from product where ref_pro = 'INT-P001'
    returning id_inv_lin into v_id_lin;

    insert into "return" (id_inv_lin, qty_ret, mot_ret)
    values (v_id_lin, 99, 'integrity excessive return');

    raise notice 'FAIL: excessive return quantity should be blocked';
exception
    when others then
        if sqlerrm like '%devolvida%' or sqlerrm like '%vendida%' or sqlerrm like '%excede%' then
            raise notice 'PASS: excessive return quantity blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected return quantity error — %', sqlerrm;
        end if;
end;
$$;
