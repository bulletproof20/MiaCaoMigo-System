-- =========================================================
-- INTEGRITY — MODULE 4 — APPOINTMENT LIFECYCLE
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     sp_cancel_appointment, sp_start_appointment, sp_end_appointment,
--           trg_prevent_completed_appointment_modification
-- CONTRACT: qa_client_active_id, qa_animal_adopted_id, qa_vet_primary_id, qa_specialty_general_id
-- =========================================================
-- expected:
-- - cancel within 24h blocked; cancel beyond 24h allowed
-- - start/end transitions enforced
-- - terminal appointment update blocked
-- =========================================================

-- TEST 01 — cancel within 24h window blocked
do $$
declare
    v_id int;
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, (now() + interval '12 hours')::timestamp);

    select id_app into v_id
      from appointment
     where id_cli = v_cli
     order by id_app desc
     limit 1;

    call sp_cancel_appointment(v_id);
    raise notice 'FAIL: cancel within 24h should be blocked';
exception
    when others then
        if sqlerrm like '%24 horas%' or sqlerrm like '%antecedência%' then
            raise notice 'PASS: cancel within 24h blocked';
        else
            raise notice 'FAIL: unexpected cancel window error — %', sqlerrm;
        end if;
end;
$$;

-- TEST 02 — cancel beyond 24h allowed
do $$
declare
    v_id int;
    v_status appointment_status;
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, (now() + interval '3 days')::timestamp);

    select id_app into v_id
      from appointment
     where id_cli = v_cli
       and status_app = 'scheduled'
     order by id_app desc
     limit 1;

    call sp_cancel_appointment(v_id);

    select status_app into v_status from appointment where id_app = v_id;

    if v_status = 'cancelled' then
        raise notice 'PASS: cancel beyond 24h succeeded';
    else
        raise notice 'FAIL: expected cancelled status, got %', v_status;
    end if;
exception
    when others then
        raise notice 'FAIL: cancel beyond 24h — %', sqlerrm;
end;
$$;

-- TEST 03 — start and end transitions (dedicated appointment)
do $$
declare
    v_id_app int;
    v_status appointment_status;
    v_sta timestamp;
    v_end timestamp;
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, (now() + interval '14 days')::timestamp);

    select id_app into v_id_app
      from appointment
     where id_cli = v_cli
       and status_app = 'scheduled'
     order by id_app desc
     limit 1;

    call sp_start_appointment(v_id_app);

    select status_app, sta_dat_app into v_status, v_sta
      from appointment where id_app = v_id_app;

    if v_status <> 'in_progress' or v_sta is null then
        raise notice 'FAIL: sp_start_appointment — status=% sta=%', v_status, v_sta;
        return;
    end if;

    -- ck_appointment_flow requires sta_dat_app < end_dat_app (strict)
    update appointment
       set sta_dat_app = sta_dat_app - interval '3 seconds'
     where id_app = v_id_app;

    call sp_end_appointment(v_id_app, 'Integrity diagnosis', 'Integrity comments');

    select status_app, sta_dat_app, end_dat_app
      into v_status, v_sta, v_end
      from appointment where id_app = v_id_app;

    if v_status = 'completed' and v_sta < v_end then
        raise notice 'PASS: start and end appointment lifecycle';
    else
        raise notice 'FAIL: after end — status=% sta=% end=%', v_status, v_sta, v_end;
    end if;
exception
    when others then
        raise notice 'FAIL: appointment lifecycle — %', sqlerrm;
end;
$$;

-- TEST 04 — modify completed appointment blocked
do $$
declare
    v_id_app int;
begin
    select id_app into v_id_app
      from appointment
     where id_cli = qa_client_active_id()
       and status_app = 'completed'
     order by id_app desc
     limit 1;

    if v_id_app is null then
        raise notice 'FAIL: no completed appointment for terminal modification test';
        return;
    end if;

    update appointment set com_app = 'integrity tamper' where id_app = v_id_app;
    raise notice 'FAIL: update on completed appointment should be blocked';
exception
    when others then
        if sqlerrm ilike '%concluída%' or sqlerrm ilike '%cancelada%' or sqlerrm ilike '%comparência%' or sqlerrm ilike '%comparencia%' then
            raise notice 'PASS: completed appointment modification blocked';
        else
            raise notice 'FAIL: unexpected terminal modification error — %', sqlerrm;
        end if;
end;
$$;
