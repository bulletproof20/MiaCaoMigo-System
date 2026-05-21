-- =========================================================
-- STRESS — MODULE 2 — CONCURRENT ADOPTION
-- =========================================================
-- OBJECTIVE: many adoption attempts on same internal animal
-- VOLUME:    40 sp_assign_ownership on animal 1 (internal after lifecycle tests may vary)
-- EXPECTED:  at most one success; rest blocked by procedure or triggers
-- METRICS:   attempts, successes, blocks, active ownerships
-- REQUIRES:  04_Loaders/03_TestData.sql + contracts/01_QA_Functions.sql
-- =========================================================

do $$
declare
    v_ani int := qa_animal_stress_internal_id();
    v_cli int := qa_client_secondary_id();
    v_attempts int := 40;
    v_ok int := 0;
    v_block int := 0;
    v_active int;
    v_i int;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    update animal set sta_ani = 'Interno', ina_dat_ani = null where id_ani = v_ani;
    update ownership
       set end_dat_own = current_date,
           mot_own = coalesce(mot_own, '') || ' [stress reset]'
     where id_ani = v_ani
       and end_dat_own is null;

    for v_i in 1..v_attempts loop
        begin
            call sp_assign_ownership(v_ani, v_cli, qa_registrar_emp_id(), 'STRESS adoption race');
            v_ok := v_ok + 1;
        exception
            when others then
                v_block := v_block + 1;
        end;
    end loop;

    select count(*) into v_active
      from ownership
     where id_ani = v_ani
       and end_dat_own is null;

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M2-01 — Concurrent Adoption';
    raise notice 'Animal id_ani: %', v_ani;
    raise notice 'Attempts: %', v_attempts;
    raise notice 'Successful assigns: %', v_ok;
    raise notice 'Blocked assigns: %', v_block;
    raise notice 'Active ownership rows (expect 1): %', v_active;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(attempts/sec): %', round(v_attempts / nullif(v_ms / 1000.0, 0), 2);

    if v_active <= 1 and v_ok <= 1 then
        raise notice 'RESULT: single active ownership under contention';
    else
        raise notice 'RESULT: review ownership state (active=% ok=%)', v_active, v_ok;
    end if;
end;
$$;
