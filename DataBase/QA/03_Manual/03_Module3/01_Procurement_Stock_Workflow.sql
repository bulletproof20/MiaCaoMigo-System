-- =========================================================
-- MANUAL TEST — MODULE 3
-- WORKFLOW: Purchase receive and inventory exploration
-- =========================================================
-- PURPOSE:
--   Ensure INT-P001 exists, create pending purchase, fn_receive_purchase,
--   explore stock views and restock advisory.
--
-- EXPECTED:
--   - Purchase moves to received; stock rows linked on purchase_line
--   - fn_list_product_stock_levels / fn_get_available_stock updated
--   - fn_check_restock_needs emits notice if below min_sto
--
-- REQUIRES: Schema + services; TestData optional
-- =========================================================

do $$
declare
    v_fam int;
    v_pro int;
    v_pur int;
begin
    raise notice 'MANUAL M3-01 — Procurement and stock';

    if not exists (select 1 from product where ref_pro = 'INT-P001') then
        insert into family (nam_fam, des_fam)
        values ('Manual Commercial', 'manual QA')
        returning id_fam into v_fam;

        insert into product (ref_pro, bar_pro, nam_pro, des_pro, pri_pro, iva_pro, id_fam, min_sto)
        values ('INT-P001', '9000000000001', 'Manual Integrity Product', 'QA', 14.50, 6.00, v_fam, 5)
        returning id_pro into v_pro;
    else
        select id_pro into v_pro from product where ref_pro = 'INT-P001';
    end if;

    insert into purchase (pur_dat_pur, sta_pur, id_emp)
    values (current_timestamp, 'pending', 1)
    returning id_pur into v_pur;

    insert into purchase_line (id_pur, id_pro, bat_pln, qty_pln, uni_cos_pln)
    values (v_pur, v_pro, 'MANUAL-BATCH-001', 25, 8.50);

    raise notice 'Created pending purchase id_pur=% for product %', v_pur, v_pro;
end $$;

select pl.id_pur, p.sta_pur, pl.bat_pln, pl.qty_pln, pl.id_sto
from purchase p
join purchase_line pl on pl.id_pur = p.id_pur
order by p.id_pur desc
limit 3;

do $$
declare
    v_pur int;
begin
    select id_pur into v_pur from purchase where sta_pur = 'pending' order by id_pur desc limit 1;
    if v_pur is not null then
        perform fn_receive_purchase(v_pur);
        raise notice 'Received purchase %', v_pur;
    end if;
end $$;

select * from fn_get_product_stock_level(
    (select id_pro from product where ref_pro = 'INT-P001')
);

select v.*
from fn_list_product_stock_levels() v
where v.ref_pro = 'INT-P001';

select fn_get_available_stock(
    (select id_pro from product where ref_pro = 'INT-P001')
) as available_units;

select fn_check_restock_needs() as restock_check;

select * from fn_list_products_to_reorder();
