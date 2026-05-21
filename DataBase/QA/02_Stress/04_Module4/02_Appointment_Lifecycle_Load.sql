-- =========================================================
-- STRESS — MODULE 4 — APPOINTMENT LIFECYCLE LOAD
-- =========================================================
-- OBJECTIVE: mass start/end transitions (state + ck_appointment_flow)
-- VOLUME:    30 appointments cycled start -> end
-- EXPECTED:  completed rows; sta_dat_app < end_dat_app
-- METRICS:   cycles, failures, duration, throughput
-- REQUIRES:  04_Loaders/03_TestData.sql
-- =========================================================

do $$
declare
    v_cli int := 4;
    v_ani int := 3;
    v_emp int := 8;
    v_cycles int := 30;
    v_ok int := 0;
    v_fail int := 0;
    v_id_app int;
    v_i int;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    for v_i in 1..v_cycles loop
        begin
            call sp_create_appointment(
                v_cli, v_ani, v_emp, 1,
                (timestamp '2099-06-01 08:00:00' + (v_i * interval '2 hours'))::timestamp
            );

            select id_app into v_id_app
              from appointment
             where id_cli = v_cli
               and status_app = 'scheduled'
             order by id_app desc
             limit 1;

            call sp_start_appointment(v_id_app);

            update appointment
               set sta_dat_app = sta_dat_app - interval '3 seconds'
             where id_app = v_id_app;

            call sp_end_appointment(v_id_app, 'STRESS', 'lifecycle load');

            v_ok := v_ok + 1;
        exception
            when others then
                v_fail := v_fail + 1;
        end;
    end loop;

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M4-02 — Appointment Lifecycle Load';
    raise notice 'Cycles requested: %', v_cycles;
    raise notice 'Completed cycles: %', v_ok;
    raise notice 'Failed cycles: %', v_fail;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(cycles/sec): %', round(v_ok / nullif(v_ms / 1000.0, 0), 2);
    raise notice 'RESULT: lifecycle load finished (inspect failures if > 0)';
end;
$$;
