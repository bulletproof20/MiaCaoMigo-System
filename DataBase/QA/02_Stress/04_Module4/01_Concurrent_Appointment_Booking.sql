-- =========================================================
-- STRESS — MODULE 4 — CONCURRENT APPOINTMENT BOOKING
-- =========================================================
-- OBJECTIVE: contention on same vet slot (ex_appointment_vet_overlap)
-- VOLUME:    50 booking attempts, same id_emp + 30-minute window
-- EXPECTED:  1 scheduled success; overlaps blocked by GiST EXCLUDE
-- METRICS:   attempts, successes, conflicts, duration
-- REQUIRES:  04_Loaders/03_TestData.sql (client 4, animal 3, emp 8)
-- =========================================================

do $$
declare
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
    v_slot timestamp := timestamp '2099-05-15 14:00:00';
    v_attempts int := 50;
    v_ok int := 0;
    v_conflict int := 0;
    v_other int := 0;
    v_i int;
    v_scheduled int;
    v_t0 timestamptz := clock_timestamp();
    v_t1 timestamptz;
    v_ms numeric;
begin
    delete from appointment_notification
     where id_app in (
        select id_app from appointment
         where id_emp = v_emp
           and (sch_dat_app, sch_dat_app + interval '30 minutes')
               overlaps (v_slot, v_slot + interval '30 minutes')
     );
    delete from prescription
     where id_app in (
        select id_app from appointment
         where id_emp = v_emp
           and (sch_dat_app, sch_dat_app + interval '30 minutes')
               overlaps (v_slot, v_slot + interval '30 minutes')
     );
    delete from appointment
     where id_emp = v_emp
       and (sch_dat_app, sch_dat_app + interval '30 minutes')
           overlaps (v_slot, v_slot + interval '30 minutes');

    for v_i in 1..v_attempts loop
        begin
            call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, v_slot);
            v_ok := v_ok + 1;
        exception
            when others then
                if sqlerrm ilike '%sobreposta%'
                   or sqlerrm ilike '%overlap%'
                   or sqlerrm ilike '%ex_appointment%' then
                    v_conflict := v_conflict + 1;
                else
                    v_other := v_other + 1;
                end if;
        end;
    end loop;

    select count(*) into v_scheduled
      from appointment
     where id_emp = v_emp
       and sch_dat_app = v_slot
       and status_app = 'scheduled';

    v_t1 := clock_timestamp();
    v_ms := round(extract(epoch from (v_t1 - v_t0)) * 1000, 2);

    raise notice 'STRESS M4-01 — Concurrent Appointment Booking';
    raise notice 'Slot: %', v_slot;
    raise notice 'Attempts: %', v_attempts;
    raise notice 'Successful inserts: %', v_ok;
    raise notice 'Overlap conflicts: %', v_conflict;
    raise notice 'Other errors: %', v_other;
    raise notice 'Scheduled rows at slot: %', v_scheduled;
    raise notice 'Duration(ms): %', v_ms;
    raise notice 'Throughput(attempts/sec): %', round(v_attempts / nullif(v_ms / 1000.0, 0), 2);

    if v_scheduled <= 1 and v_ok >= 1 then
        raise notice 'RESULT: EXCLUDE constraint prevents double booking';
    else
        raise notice 'RESULT: review scheduling counts (scheduled=% ok=%)', v_scheduled, v_ok;
    end if;
end;
$$;
