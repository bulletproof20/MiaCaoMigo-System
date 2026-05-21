-- =========================================================
-- STRESS — MODULE 3 — RETURN STORM
-- =========================================================
-- OBJECTIVE: mass returns after bulk sale (restock trigger load)
-- VOLUME:    200 sale lines then 200 return rows (1 unit each)
-- EXPECTED:  returns accepted; stock increases; no qty_sto < 0
-- METRICS:   returns processed, duration, final stock
-- REQUIRES:  00_Setup/01_Commercial_Stress_Fixture.sql
-- =========================================================

do $$
declare
    v_pro int;
    v_id_inv int;
    v_lines int := 200;
    v_ret int := 0;
    v_rec record;
    v_stock int;
    v_neg int;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    select id_pro into v_pro from product where ref_pro = 'STRESS-M3';

    insert into invoice (dat_inv, bod_inv, sta_inv)
    values (current_timestamp, 'STRESS-M3 return storm', 'pending')
    returning id_inv into v_id_inv;

    insert into invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
    select v_id_inv, v_pro, 1, 10.00, 23.00
      from generate_series(1, v_lines);

    for v_rec in
        select id_inv_lin
          from invoice_line
         where id_inv = v_id_inv
         order by id_inv_lin
         limit v_lines
    loop
        begin
            insert into "return" (id_inv_lin, qty_ret, mot_ret)
            values (v_rec.id_inv_lin, 1, 'STRESS return');
            v_ret := v_ret + 1;
        exception
            when others then
                null;
        end;
    end loop;

    select coalesce(sum(qty_sto), 0) into v_stock from stock where id_pro = v_pro;
    select count(*) into v_neg from stock where id_pro = v_pro and qty_sto < 0;

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M3-04 — Return Storm';
    raise notice 'Sale lines: %', v_lines;
    raise notice 'Returns processed: %', v_ret;
    raise notice 'Final aggregate stock: %', v_stock;
    raise notice 'Negative stock rows: %', v_neg;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(returns/sec): %', round(v_ret / nullif(v_ms / 1000.0, 0), 2);

    if v_neg = 0 then
        raise notice 'RESULT: no negative stock after return storm';
    else
        raise notice 'RESULT: negative stock rows detected';
    end if;
end;
$$;
