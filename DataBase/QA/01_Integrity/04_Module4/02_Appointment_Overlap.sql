-- =========================================================
-- INTEGRITY — MODULE 4 — APPOINTMENT OVERLAP (GiST)
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/04_Module4_Appointment_Slots.sql (qa_appt_overlap_slot)
-- RULE:     ex_appointment_vet_overlap
-- CONTRACT: qa_client_active_id, qa_animal_adopted_id, qa_vet_primary_id, qa_specialty_general_id
-- =========================================================

do $$
declare
    v_slot timestamp := qa_appt_overlap_slot();
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    if v_slot is null then
        raise notice 'FAIL: qa_appt_overlap_slot fixture missing — run run_fixtures.ps1';
        return;
    end if;

    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, v_slot);
    raise notice 'FAIL: overlapping appointment should be blocked';
exception
    when others then
        if sqlerrm like '%sobreposta%' or sqlerrm like '%overlap%' or sqlerrm like '%ex_appointment%' then
            raise notice 'PASS: overlapping appointment blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected overlap error — %', sqlerrm;
        end if;
end;
$$;
