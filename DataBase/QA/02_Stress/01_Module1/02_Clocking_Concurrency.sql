-- =========================================================
-- STRESS — MODULE 1 — CLOCKING CONCURRENCY
-- =========================================================
-- OBJECTIVE: repeated clock-in attempts on employee with open session
-- VOLUME:    50 fn_clock_employee calls on id_emp 6 (open clock in stress data)
-- EXPECTED:  uq_clock_in_active_per_employee holds; toggles clock-out after first
-- METRICS:   attempts, outcomes, open clock-ins, duration
-- REQUIRES:  04_Loaders/03_TestData.sql
-- =========================================================

do $$
declare
    v_emp int := 6;
    v_attempts int := 50;
    v_clock_in int := 0;
    v_clock_out int := 0;
    v_errors int := 0;
    v_result varchar(50);
    v_i int;
    v_open int;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    for v_i in 1..v_attempts loop
        begin
            v_result := fn_clock_employee(v_emp);
            if v_result = 'CLOCK_IN' then
                v_clock_in := v_clock_in + 1;
            elsif v_result = 'CLOCK_OUT' then
                v_clock_out := v_clock_out + 1;
            end if;
        exception
            when others then
                v_errors := v_errors + 1;
        end;
    end loop;

    select count(*) into v_open
      from clock_in
     where id_emp = v_emp
       and end_dat_clk is null;

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M1-02 — Clocking Concurrency';
    raise notice 'Employee id_emp: %', v_emp;
    raise notice 'Attempts: %', v_attempts;
    raise notice 'CLOCK_IN results: %', v_clock_in;
    raise notice 'CLOCK_OUT results: %', v_clock_out;
    raise notice 'Errors: %', v_errors;
    raise notice 'Open clock-ins (expect <=1): %', v_open;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(attempts/sec): %', round(v_attempts / nullif(v_ms / 1000.0, 0), 2);

    if v_open <= 1 then
        raise notice 'RESULT: partial unique clock-in invariant held';
    else
        raise notice 'RESULT: multiple open clock-ins — %', v_open;
    end if;
end;
$$;
