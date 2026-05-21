-- =========================================================
-- STRESS — MODULE 3 — FIFO CONSUMPTION UNDER LOAD
-- =========================================================
-- OBJECTIVE: validate fn_stock_after_sale FIFO ordering at scale
-- VOLUME:    sell 60 units across 3 batches (40+35+25 = 100)
-- EXPECTED:  FIFO by val_dat_sto asc — C (30d) then B (90d); A (180d) untouched
-- METRICS:   per-batch qty after sale, duration
-- REQUIRES:  00_Setup/01_Commercial_Stress_Fixture.sql
-- =========================================================

do $$
declare
    v_pro int;
    v_id_inv int;
    v_qty_a int;
    v_qty_b int;
    v_qty_c int;
    v_sell int := 60;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    select id_pro into v_pro from product where ref_pro = 'STRESS-M3';

    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'STRESS-M3 FIFO', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    values (v_id_inv, v_pro, v_sell, 10.00, 23.00);

    select qty_sto into v_qty_a from stock where id_pro = v_pro and bat_sto = 'STRESS-BATCH-A';
    select qty_sto into v_qty_b from stock where id_pro = v_pro and bat_sto = 'STRESS-BATCH-B';
    select qty_sto into v_qty_c from stock where id_pro = v_pro and bat_sto = 'STRESS-BATCH-C';

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M3-03 — FIFO Consumption';
    raise notice 'Units sold: %', v_sell;
    raise notice 'Batch A qty (expect 40): %', v_qty_a;
    raise notice 'Batch B qty (expect 0): %', v_qty_b;
    raise notice 'Batch C qty (expect 0): %', v_qty_c;
    raise notice 'Duration(ms): %', v_ms;

    if v_qty_a = 40 and v_qty_b = 0 and v_qty_c = 0 then
        raise notice 'RESULT: FIFO order preserved';
    else
        raise notice 'RESULT: FIFO deviation — inspect batch quantities';
    end if;
end;
$$;
