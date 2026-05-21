-- =========================================================
-- STRESS — MODULE 3 — CONCURRENT SALES (serial contention)
-- =========================================================
-- OBJECTIVE: many sale attempts against fixed stock (race simulation)
-- VOLUME:    80 transactions x 1 unit (stock pool = 100)
-- EXPECTED:  successes <= initial stock; no negative qty_sto; no oversell
-- METRICS:   attempts, successes, blocks, final stock, duration, rows/sec
-- REQUIRES:  00_Setup/01_Commercial_Stress_Fixture.sql
-- NOTE:      true parallel sessions need multiple psql clients (see README)
-- =========================================================

do $$
declare
    v_pro int;
    v_id_inv int;
    v_initial int;
    v_final int;
    v_attempts int := 80;
    v_ok int := 0;
    v_block int := 0;
    v_i int;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    select id_pro into v_pro from product where ref_pro = 'STRESS-M3';
    select coalesce(sum(qty_sto), 0) into v_initial from stock where id_pro = v_pro;

    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'STRESS-M3 concurrent sales', 'pending')
    returning id_inv into v_id_inv;

    for v_i in 1..v_attempts loop
        begin
            insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
            values (v_id_inv, v_pro, 1, 10.00, 23.00);
            v_ok := v_ok + 1;
        exception
            when others then
                v_block := v_block + 1;
        end;
    end loop;

    select coalesce(sum(qty_sto), 0) into v_final from stock where id_pro = v_pro;
    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M3-01 — Concurrent Sales';
    raise notice 'Initial stock: %', v_initial;
    raise notice 'Attempts: %', v_attempts;
    raise notice 'Successful lines: %', v_ok;
    raise notice 'Blocked attempts: %', v_block;
    raise notice 'Final stock: %', v_final;
    raise notice 'Expected max sales: %', v_initial;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(lines/sec): %', round(v_ok / nullif(v_ms / 1000.0, 0), 2);

    if v_final < 0 then
        raise notice 'ANOMALY: negative stock detected';
    elsif v_ok > v_initial then
        raise notice 'ANOMALY: oversell (successes > initial stock)';
    else
        raise notice 'RESULT: stock guard consistent under contention';
    end if;
end;
$$;
