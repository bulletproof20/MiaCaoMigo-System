-- =========================================================
-- MANUAL TEST — MODULE 4
-- WORKFLOW: Operational reads and notification job
-- =========================================================
-- PURPOSE:
--   Explore appointment views and service list functions;
--   run sp_generate_appointment_warnings (side-effect: notifications).
--
-- EXPECTED:
--   - fn_list_appointments_today / tomorrow return rows or empty sets
--   - vw_appointment_detail usable for vet/client filters
--   - Warnings procedure completes without error
--
-- REQUIRES: TestData + optional scheduled rows for tomorrow
-- =========================================================

do $$ begin
    raise notice 'MANUAL M4-02 — Operational appointment exploration';
end $$;

select * from fn_list_appointments_today();

select * from fn_list_appointments_tomorrow();

select * from fn_list_vet_appointments_from(8, current_date);

select * from fn_list_animal_appointment_history(3);

select id_app, status_app, sch_dat_app, client_name, veterinarian_name
from vw_appointment_detail
where id_emp = 8
  and sch_dat_app::date >= current_date
order by sch_dat_app
limit 10;

do $$ begin
    raise notice '--- JOB: sp_generate_appointment_warnings ---';
end $$;

call sp_generate_appointment_warnings();

select id_not, id_cli, id_app, left(msg_not, 60) as msg_preview, cre_tim_not
from appointment_notification
order by cre_tim_not desc
limit 5;

call sp_auto_update_no_show_appointments();
