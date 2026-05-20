-- =========================================================
-- QUERIES — MODULE 4 APPOINTMENTS (REFERENCE ONLY)
-- =========================================================
-- Prefer Services/04_Module4/01_Appointment_Read.sql:
--   fn_list_vet_appointments_from(id_emp, from_date)
--   fn_list_animal_appointment_history(id_ani)
--   fn_get_appointment_detail(id_app)
-- Or views: vw_appointment_detail, vw_appointments_today
-- =========================================================

-- Veterinarian schedule (from today)
select *
from vw_appointment_detail d
where d.id_emp = 1
  and d.sch_dat_app::date >= current_date
  and d.status_app = 'scheduled'
order by d.sch_dat_app;

-- Client upcoming visits
select *
from vw_appointment_detail d
where d.id_cli = 1
  and d.sch_dat_app >= current_date
  and d.status_app = 'scheduled'
order by d.sch_dat_app;
