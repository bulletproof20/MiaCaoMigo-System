-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 07_Views_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Reporting views for workforce directory, attendance, and
-- absence monitoring. Encapsulates recurring joins between
-- employee records and shared user identities.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 00_Tables_Mod1.sql, 01_ForeignKeys_Mod1.sql
-- - 02_Functions_Mod1.sql (no direct dependency)
--
-- Must load before:
-- - 05_Procedures_Mod1.sql / 06_Jobs_Mod1.sql (optional consumers)
-- =========================================================

-- =========================================================
-- Active employees with shared identity attributes
-- =========================================================
-- Entities: employee, user_account
-- Purpose: operational directory of staff with active contracts

drop view if exists vw_active_employee_directory;
create view vw_active_employee_directory as
select
    e.id_emp,
    e.id_usr,
    u.nam_usr,
    e.ema_emp,
    e.pho_emp,
    e.pho_emg,
    e.reg_dat_emp
from employee e
inner join user_account u on u.id_usr = e.id_usr
where e.dea_dat_emp is null;


-- =========================================================
-- Open attendance sessions (clock-in without clock-out)
-- =========================================================
-- Entities: clock_in, employee, user_account
-- Purpose: supports attendance hygiene and open-shift monitoring

drop view if exists vw_open_clock_in_sessions;
create view vw_open_clock_in_sessions as
select
    c.id_clk,
    c.id_emp,
    u.nam_usr,
    e.ema_emp,
    c.sta_dat_clk,
    c.end_dat_clk
from clock_in c
inner join employee e on e.id_emp = c.id_emp
inner join user_account u on u.id_usr = e.id_usr
where c.end_dat_clk is null;


-- =========================================================
-- Operationally relevant absences
-- =========================================================
-- Entities: absence, employee, user_account
-- Purpose: pending, approved, and detected absences for staffing

drop view if exists vw_operational_absences;

create view vw_operational_absences as
select
    a.id_abs,
    a.id_emp,
    u.nam_usr,
    e.ema_emp,
    a.sta_dat_tim_abs,
    a.end_dat_tim_abs,
    a.mot_abs,
    a.sta_abs,
    a.res_abs,
    a.cre_tim_abs
from absence a
inner join employee e on e.id_emp = a.id_emp
inner join user_account u on u.id_usr = e.id_usr
where a.sta_abs in ('pending', 'approved', 'detected'); 
