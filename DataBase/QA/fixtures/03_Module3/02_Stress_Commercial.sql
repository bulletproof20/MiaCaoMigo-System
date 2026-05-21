-- =========================================================
-- QA FIXTURE — MODULE 3 — STRESS COMMERCIAL (optional)
-- =========================================================
-- TYPE:     fixture (data only)
-- PROVIDES: STRESS-M3 product and FIFO batches
-- LOADED:   run_stress_all.ps1 only (not regression)
-- =========================================================

do $$
declare
    v_fam int;
    v_pro int;
begin
    if not exists (select 1 from product where ref_pro = 'STRESS-M3') then
        insert into family (nam_fam, des_fam)
        values ('Stress Commercial', 'stress tier commercial isolation')
        returning id_fam into v_fam;

        insert into product (ref_pro, bar_pro, nam_pro, des_pro, pri_pro, iva_pro, id_fam, min_sto)
        values ('STRESS-M3', '9000000000999', 'Stress Product M3', 'stress', 10.00, 23.00, v_fam, 0)
        returning id_pro into v_pro;
    else
        select id_pro into v_pro from product where ref_pro = 'STRESS-M3';
    end if;

    delete from "return" where id_inv_lin in (
        select il.id_inv_lin from invoice_line il
        join invoice i on i.id_inv = il.id_inv
        where i.bod_inv like 'STRESS-M3%'
    );
    delete from invoice_line where id_inv in (
        select id_inv from invoice where bod_inv like 'STRESS-M3%'
    );
    delete from invoice where bod_inv like 'STRESS-M3%';
    delete from stock where id_pro = v_pro;

    insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto) values
        (v_pro, 'STRESS-BATCH-A', 40, current_date - 30, current_date + 180),
        (v_pro, 'STRESS-BATCH-B', 35, current_date - 15, current_date + 90),
        (v_pro, 'STRESS-BATCH-C', 25, current_date, current_date + 30);
end;
$$;
