-- =========================================================
-- STRESS — MODULE 3 — HIGH VOLUME INVOICE LINES
-- =========================================================
-- OBJECTIVE: measure trigger chain under many invoice_line inserts
-- VOLUME:    500 lines (adjust v_lines for heavier runs)
-- EXPECTED:  all lines persist; val_inv recalculated; stock reduced
-- METRICS:   lines, duration, lines/sec, final invoice total
-- REQUIRES:  00_Setup/01_Commercial_Stress_Fixture.sql
-- =========================================================

do $$
declare
    v_pro int;
    v_id_inv int;
    v_lines int := 500;
    v_stock_before int;
    v_stock_after int;
    v_total numeric(10,2);
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    select id_pro into v_pro from product where ref_pro = 'STRESS-M3';

    insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
    values (v_pro, 'STRESS-BULK-VOL', v_lines + 50, current_date, current_date + 365);

    select coalesce(sum(qty_sto), 0) into v_stock_before from stock where id_pro = v_pro;

    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'STRESS-M3 high volume', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    select v_id_inv, v_pro, 1, 10.00, 23.00
      from generate_series(1, v_lines);

    select val_inv into v_total from invoice where id_inv = v_id_inv;
    select coalesce(sum(qty_sto), 0) into v_stock_after from stock where id_pro = v_pro;

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M3-02 — High Volume Invoice Lines';
    raise notice 'Lines inserted: %', v_lines;
    raise notice 'Stock before: %  after: %', v_stock_before, v_stock_after;
    raise notice 'Invoice total (val_inv): %', v_total;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(lines/sec): %', round(v_lines / nullif(v_ms / 1000.0, 0), 2);
    raise notice 'RESULT: bulk insert completed (review trigger cost above)';
end;
$$;
