-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Partial unique indexes and exclusion constraints enforcing
-- operational uniqueness for logins, employees, clock-ins, and schedules.
--
-- This file contains:
-- - Partial UNIQUE indexes on hot tables
-- - GiST-backed schedule overlap protection
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 1 tables created and typed
-- - GiST exclusion support (install btree_gist where the instance requires it)
--
-- Must load before:
-- - Data seeding relying on uniqueness guarantees
-- =========================================================

-- =========================================================
-- Drops legacy objects before recreating module indexes
-- =========================================================

drop index if exists uq_login_single_active_session_email;
drop index if exists uq_employee_active_per_user;
drop index if exists uq_clock_in_active_per_employee;
alter table schedule drop constraint if exists ex_schedule_overlap;


-- =========================================================
-- Enforces a single active successful login session per email
-- =========================================================

create unique index uq_login_single_active_session_email
on login_record(ema_log)
where sou_tim_log is null 
  and suc_log = true
  and ema_log is not null;


-- =========================================================
-- Enforces a single active employee profile per user account
-- =========================================================

create unique index uq_employee_active_per_user
on employee(id_usr)
where dea_dat_emp is null;


-- =========================================================
-- Enforces a single open clock-in row per employee
-- =========================================================

create unique index uq_clock_in_active_per_employee
on clock_in(id_emp)
where end_dat_clk is null;


-- =========================================================
-- Prevents overlapping weekly schedule windows per employee
-- =========================================================

alter table schedule
add constraint ex_schedule_overlap
exclude using gist (

    id_emp with =,

    day_wee_sch with =,

    tsrange(
        ('2000-01-01'::date + sta_tim_sch)::timestamp,
        ('2000-01-01'::date + fin_hou_sch)::timestamp
    ) with &&
);
