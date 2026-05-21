-- =========================================================
-- QA FIXTURE — MODULE 4 — DETERMINISTIC APPOINTMENT SLOTS
-- =========================================================
-- TYPE:     fixture (data only)
-- REQUIRES: contracts + fixtures/02_Module2
-- PROVIDES: overlap slot 2099-06-15, notification date 2099-07-11
-- =========================================================

do $$
declare
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_emp int := qa_vet_primary_id();
    v_spe int := qa_specialty_general_id();
begin
    if v_cli is null or v_ani is null or v_emp is null or v_spe is null then
        raise exception 'QA Mod4 fixture: missing contract prerequisites (client/vet/animal/specialty).';
    end if;

    delete from appointment_notification
     where id_app in (
         select id_app from appointment where sch_dat_app >= timestamp '2099-01-01'
     );

    delete from appointment where sch_dat_app >= timestamp '2099-01-01';

    insert into appointment (id_cli, id_ani, id_emp, id_spe, sch_dat_app, status_app)
    values
        (v_cli, v_ani, v_emp, v_spe, qa_appt_overlap_slot(), 'scheduled'),
        (v_cli, v_ani, v_emp, v_spe, (qa_appt_notification_date()::timestamp + time '09:30'), 'scheduled');
end;
$$;
