-- =========================================================
-- INTEGRITY — MODULE 3 — INVOICE TOTAL UPDATE
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: Bootstrap init_demo (DemoData Mod3)
-- RULE:     trg_update_invoice_total / fn_update_invoice_total
-- FIXTURES: Demo product id_pro 2 (unit price 14.50, iva 6%)
-- =========================================================
-- expected:
-- - invoice.val_inv matches sum of lines after insert
-- =========================================================

insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
select id_pro, 'INT-STOCK-04', 20, current_date, current_date + interval '1 year'
  from product where ref_pro = 'INT-P001';

do $$
declare
    v_id_inv int;
    v_total numeric(10, 2);
    v_expected numeric(10, 2);
begin
    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'integrity invoice total test', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    select v_id_inv, id_pro, 2, 14.50, 6.00 from product where ref_pro = 'INT-P001';

    select val_inv into v_total from invoice where id_inv = v_id_inv;

    v_expected := round(2 * 14.50 * (1 + 6.00 / 100), 2);

    if v_total = v_expected then
        raise notice 'PASS: invoice total updated (val_inv=% expected=%)', v_total, v_expected;
    else
        raise notice 'FAIL: invoice total mismatch — val_inv=% expected=%', v_total, v_expected;
    end if;
exception
    when others then
        raise notice 'FAIL: invoice total test — %', sqlerrm;
end;
$$;
