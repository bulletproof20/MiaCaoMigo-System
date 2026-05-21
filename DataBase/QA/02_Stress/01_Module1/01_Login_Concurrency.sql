-- =========================================================
-- STRESS — MODULE 1 — LOGIN CONCURRENCY (session race)
-- =========================================================
-- OBJECTIVE: repeated login while active session exists
-- VOLUME:    100 login_user calls on 12@miacaomigo.pt (open session in CreationStress)
-- EXPECTED:  login_success = false when session active; no duplicate open sessions
-- METRICS:   attempts, blocked logins, open sessions count, duration
-- REQUIRES:  04_Loaders/03_TestData.sql
-- =========================================================

do $$
declare
    v_attempts int := 100;
    v_blocked int := 0;
    v_success int := 0;
    v_open int;
    v_i int;
    v_login_success boolean;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    for v_i in 1..v_attempts loop
        select login_success
          into v_login_success
          from login_user(
              '12@miacaomigo.pt',
              '$2b$12$cstress_u12_active',
              '127.0.0.1'::inet
          );

        if v_login_success then
            v_success := v_success + 1;
        else
            v_blocked := v_blocked + 1;
        end if;
    end loop;

    select count(*) into v_open
      from login_record
     where ema_log = '12@miacaomigo.pt'
       and sou_tim_log is null
       and suc_log = true;

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M1-01 — Login Concurrency';
    raise notice 'Attempts: %', v_attempts;
    raise notice 'login_success=true: %', v_success;
    raise notice 'login_success=false: %', v_blocked;
    raise notice 'Open successful sessions (expect <=1): %', v_open;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(attempts/sec): %', round(v_attempts / nullif(v_ms / 1000.0, 0), 2);

    if v_open <= 1 then
        raise notice 'RESULT: single active session invariant held';
    else
        raise notice 'RESULT: multiple open sessions detected — %', v_open;
    end if;
end;
$$;
