-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 07_Views_Mod4.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Reporting views for clinical scheduling, reminders, and
-- daily operational boards. Encapsulates cross-module joins
-- across appointments, clients, staff, and animals.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 4 tables and 01_ForeignKeys_Mod4.sql
-- - Module 1 (client, employee, user_account, specialty)
-- - Module 2 (animal, species, breed)
--
-- Must load before:
-- - 05_Procedures_Mod4.sql / 06_Jobs_Mod4.sql (optional consumers)
-- =========================================================

-- =========================================================
-- Appointment schedule with client, clinician, and animal
-- =========================================================
-- Entities: appointment, client, user_account, employee, animal,
--           specialty, species, breed
-- Purpose: canonical join pattern for scheduling reports

drop view if exists vw_appointments_today;
drop view if exists vw_scheduled_appointments_tomorrow;
drop view if exists vw_appointment_detail;

create view vw_appointment_detail as
select
    a.id_app,
    a.sch_dat_app,
    a.sta_dat_app,
    a.end_dat_app,
    a.status_app,
    a.id_cli,
    u_cli.nam_usr as client_name,
    u_cli.ema_usr as client_email,
    a.id_emp,
    u_emp.nam_usr as veterinarian_name,
    e.ema_emp as veterinarian_email,
    a.id_ani,
    an.reg_id_ani,
    an.nam_ani as animal_name,
    sp.nam_spc,
    br.nam_bre,
    a.id_spe,
    s.nam_spe as appointment_specialty,
    a.id_inv,
    a.dia_app,
    a.com_app
from appointment a
inner join client c on c.id_cli = a.id_cli
inner join user_account u_cli on u_cli.id_usr = c.id_usr
inner join employee e on e.id_emp = a.id_emp
inner join user_account u_emp on u_emp.id_usr = e.id_usr
inner join animal an on an.id_ani = a.id_ani
inner join specialty s on s.id_spe = a.id_spe
inner join species sp on sp.id_spc = an.id_spc
left join breed br on br.id_bre = an.id_bre;


-- =========================================================
-- Scheduled appointments occurring tomorrow
-- =========================================================
-- Entities: vw_appointment_detail (appointment core)
-- Purpose: supports reminder generation and daily batch jobs

drop view if exists vw_scheduled_appointments_tomorrow;

create view vw_scheduled_appointments_tomorrow as
select
    d.id_app,
    d.id_cli,
    d.client_name,
    d.client_email,
    d.id_emp,
    d.veterinarian_name,
    d.id_ani,
    d.animal_name,
    d.sch_dat_app,
    d.status_app
from vw_appointment_detail d
where d.status_app = 'scheduled'
  and d.sch_dat_app::date = current_date + interval '1 day';


-- =========================================================
-- Appointments scheduled for the current calendar day
-- =========================================================
-- Entities: vw_appointment_detail
-- Purpose: front-desk and clinical daily operational board

drop view if exists vw_appointments_today;

create view vw_appointments_today as
select
    d.id_app,
    d.sch_dat_app,
    d.sta_dat_app,
    d.end_dat_app,
    d.status_app,
    d.client_name,
    d.veterinarian_name,
    d.animal_name,
    d.appointment_specialty
from vw_appointment_detail d
where d.sch_dat_app::date = current_date
  and d.status_app in ('scheduled', 'in_progress');
