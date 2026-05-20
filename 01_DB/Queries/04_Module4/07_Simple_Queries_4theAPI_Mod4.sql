-- =========================================================
-- QUERIES — MODULE 4 (API REFERENCE)
-- =========================================================
-- DEPRECATED: prefer Services/04_Module4/01_Appointment_Read.sql
-- and reporting views (vw_appointment_detail, vw_appointments_today).
-- =========================================================

-- Upcoming schedule for a veterinarian (from today)
select *
from vw_appointment_detail d
where d.id_emp = 1  -- replace with veterinarian id
  and d.sch_dat_app::date >= current_date
  and d.status_app = 'scheduled'
order by d.sch_dat_app;


-- Medical history for an animal
select
    d.id_app,
    d.sch_dat_app,
    d.veterinarian_name,
    d.appointment_specialty,
    d.status_app,
    d.dia_app as diagnosis,
    d.com_app as comments
from vw_appointment_detail d
where d.id_ani = 1  -- replace with animal id
order by d.sch_dat_app desc;


-- Single appointment detail
select *
from vw_appointment_detail
where id_app = 1;  -- replace with appointment id


-- Today's operational board
select * from vw_appointments_today
order by sch_dat_app;


-- Tomorrow reminders
select * from vw_scheduled_appointments_tomorrow
order by sch_dat_app;
