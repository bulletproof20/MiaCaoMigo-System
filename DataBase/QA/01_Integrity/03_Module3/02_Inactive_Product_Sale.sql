-- =========================================================
-- INTEGRITY — MODULE 3 — INACTIVE PRODUCT SALE
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: Bootstrap init_demo (DemoData Mod3)
-- RULE:     trg_prevent_inactive_product_sale
-- FIXTURES: Demo product id_pro 1
-- =========================================================
-- expected:
-- - sale line for inactive product blocked
-- =========================================================

insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
select id_pro, 'INT-STOCK-02', 20, current_date, current_date + interval '1 year'
  from product where ref_pro = 'INT-P001';

do $$
declare
    v_id_inv int;
    v_id_pro int;
begin
    select id_pro into v_id_pro from product where ref_pro = 'INT-P001';
    update product set ina_dat_pro = current_timestamp where id_pro = v_id_pro;

    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'integrity inactive product test', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    values (v_id_inv, v_id_pro, 1, 5.00, 23.00);

    raise notice 'FAIL: inactive product sale should be blocked';

    update product set ina_dat_pro = null where id_pro = v_id_pro;
exception
    when others then
        update product set ina_dat_pro = null where id_pro = v_id_pro;

        if sqlerrm like '%inativo%' or sqlerrm like '%inactive%' then
            raise notice 'PASS: inactive product sale blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected inactive product error — %', sqlerrm;
        end if;
end;
$$;
