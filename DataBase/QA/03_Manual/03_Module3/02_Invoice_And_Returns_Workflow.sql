-- =========================================================
-- MANUAL TEST — MODULE 3
-- WORKFLOW: Invoice lifecycle and returns
-- =========================================================
-- PURPOSE:
--   Create invoice + lines (triggers: stock check, FIFO, total),
--   partial return, inspect aggregates.
--
-- EXPECTED:
--   - val_inv matches line totals
--   - Stock decreases then partial restock on return
--   - qty_ret <= qty sold enforced
--
-- REQUIRES: INT-P001 with stock (run 01_Procurement first or existing stock)
-- =========================================================

do $$
declare
    v_pro int;
    v_inv int;
    v_lin int;
begin
    raise notice 'MANUAL M3-02 — Invoice and returns';

    select id_pro into v_pro from product where ref_pro = 'INT-P001';

    insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
    values (v_pro, 'MANUAL-INV-BATCH', 30, current_date, current_date + 90);

    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'MANUAL QA invoice', 'pending')
    returning id_inv into v_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    values (v_inv, v_pro, 5, 14.50, 6.00)
    returning id_inv_lin into v_lin;

    raise notice 'Invoice % line % — inspect val_inv and stock below', v_inv, v_lin;
end $$;

select id_inv, bod_inv, sta_inv, val_inv
from invoice
where bod_inv = 'MANUAL QA invoice'
order by id_inv desc
limit 1;

select il.id_inv_lin, il.qty_inv_lin, il.uni_pri_inv_lin, p.ref_pro
from invoice_line il
join product p on p.id_pro = il.id_pro
join invoice i on i.id_inv = il.id_inv
where i.bod_inv = 'MANUAL QA invoice'
order by il.id_inv_lin desc
limit 3;

select bat_sto, qty_sto
from stock s
join product p on p.id_pro = s.id_pro
where p.ref_pro = 'INT-P001'
order by val_dat_sto nulls last;

insert into "return" (id_inv_lin, qty_ret, mot_ret)
select il.id_inv_lin, 2, 'manual qa partial return'
from invoice_line il
join invoice i on i.id_inv = il.id_inv
where i.bod_inv = 'MANUAL QA invoice'
order by il.id_inv_lin desc
limit 1;

select r.id_ret, r.qty_ret, r.mot_ret, il.qty_inv_lin
from "return" r
join invoice_line il on il.id_inv_lin = r.id_inv_lin
join invoice i on i.id_inv = il.id_inv
where i.bod_inv = 'MANUAL QA invoice';

select bat_sto, qty_sto
from stock s
join product p on p.id_pro = s.id_pro
where p.ref_pro = 'INT-P001'
order by val_dat_sto nulls last;
