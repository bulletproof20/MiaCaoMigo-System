-- =========================================================
-- INTEGRITY — MODULE 4 — APPOINTMENT SCHEDULING
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql + fixtures/04_Module4_Appointment_Slots.sql
-- RULE:     trg_block_past_appointments; trg_validate_appointment_vet_specialty;
--           trg_validate_animal_client_relationship; sp_create_appointment
-- CONTRACT: qa_client_active_id, qa_animal_adopted_id, qa_vet_primary_id,
--           qa_specialty_general_id, qa_specialty_mismatch_id, qa_client_secondary_id
-- =========================================================

do $$
declare
    v_cli int := qa_client_active_id();
    v_cli_other int := qa_client_secondary_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
    v_spe_bad int := qa_specialty_mismatch_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, timestamp '2099-08-01 10:00');
    raise notice 'PASS: sp_create_appointment succeeded for valid case';
exception
    when others then
        raise notice 'FAIL: valid appointment should succeed — %', sqlerrm;
end;
$$;

do $$
declare
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, timestamp '2020-01-01 10:00');
    raise notice 'FAIL: past appointment should be blocked';
exception
    when others then
        if sqlerrm like '%passado%' then
            raise notice 'PASS: past appointment blocked';
        else
            raise notice 'FAIL: unexpected past appointment error — %', sqlerrm;
        end if;
end;
$$;

do $$
declare
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe_bad int := qa_specialty_mismatch_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe_bad, timestamp '2099-08-02 10:00');
    raise notice 'FAIL: vet specialty mismatch should be blocked';
exception
    when others then
        if sqlerrm like '%especialidade%' or sqlerrm like '%associado%' then
            raise notice 'PASS: vet specialty mismatch blocked';
        else
            raise notice 'FAIL: unexpected specialty error — %', sqlerrm;
        end if;
end;
$$;

do $$
declare
    v_cli int := qa_client_secondary_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, timestamp '2099-08-03 10:00');
    raise notice 'FAIL: animal/client mismatch should be blocked';
exception
    when others then
        if sqlerrm like '%não pertence%' or sqlerrm like '%pertence%' then
            raise notice 'PASS: animal/client relationship blocked';
        else
            raise notice 'FAIL: unexpected animal/client error — %', sqlerrm;
        end if;
end;
$$;
