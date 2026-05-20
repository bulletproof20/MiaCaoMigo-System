-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Integrity partial uniques, GiST exclusion, and a small set
-- of operational B-tree indexes aligned with jobs, triggers,
-- and reporting views.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 1 tables and 00_Core/01_Types.sql
-- - btree_gist (see 03_Loaders/00_Extensions.sql)
-- =========================================================

-- =========================================================
-- Drops legacy objects before recreating module indexes
-- =========================================================

drop index if exists uq_login_single_active_session_email;
drop index if exists uq_employee_active_per_user;
drop index if exists uq_clock_in_active_per_employee;
drop index if exists ix_absence_id_emp;
drop index if exists ix_absence_pending_expiry;
drop index if exists ix_clock_in_open_by_start;
alter table schedule drop constraint if exists ex_schedule_overlap;


-- =========================================================
-- INTEGRITY — single active successful login per email
-- =========================================================
-- Optimizes:
--   - authentication session uniqueness
--   - concurrent login prevention per ema_log
--
-- Partial UNIQUE enforces at most one open successful session
-- per email snapshot.
-- =========================================================

create unique index uq_login_single_active_session_email
on login_record (ema_log)
where sou_tim_log is null
  and suc_log = true
  and ema_log is not null;


-- =========================================================
-- INTEGRITY — single active employee row per user
-- =========================================================
-- Optimizes:
--   - employee onboarding and rehire validation
--   - vw_active_employee_directory active contract filter
--
-- Complements table lifecycle rules; active rows are keyed by id_usr.
-- =========================================================

create unique index uq_employee_active_per_user
on employee (id_usr)
where dea_dat_emp is null;


-- =========================================================
-- INTEGRITY — single open clock-in per employee
-- =========================================================
-- Optimizes:
--   - attendance open-session checks
--   - vw_open_clock_in_sessions
--   - inactivation guard when end_dat_clk is null
--
-- Partial UNIQUE on id_emp for rows without clock-out.
-- =========================================================

create unique index uq_clock_in_active_per_employee
on clock_in (id_emp)
where end_dat_clk is null;


-- =========================================================
-- INTEGRITY — non-overlapping weekly schedule windows
-- =========================================================
-- Optimizes:
--   - schedule overlap validation (GiST exclusion)
--
-- Prevents intersecting shift intervals per employee and weekday.
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


-- =========================================================
-- OPERATIONAL — absence rows by employee
-- =========================================================
-- Optimizes:
--   - fn_block_absence_overlap_by_user (absence ↔ employee join)
--   - vw_operational_absences
--   - absence maintenance by id_emp
--
-- Supports FK lookups on absence.id_emp without scanning the table.
-- =========================================================

create index ix_absence_id_emp
on absence (id_emp);


-- =========================================================
-- OPERATIONAL — pending absence expiry (job)
-- =========================================================
-- Optimizes:
--   - sp_auto_cancel_expired_absences
--   - pending rows filtered by end_dat_tim_abs
--
-- Narrow partial index for the daily cancellation sweep.
-- =========================================================

create index ix_absence_pending_expiry
on absence (end_dat_tim_abs)
where sta_abs = 'pending';


-- =========================================================
-- OPERATIONAL — open clock-in batch close (job)
-- =========================================================
-- Optimizes:
--   - sp_auto_close_clock_in_midnight
--   - rows with end_dat_clk is null and sta_dat_clk before today
--
-- Complements uq_clock_in_active_per_employee (unique per employee).
-- =========================================================

create index ix_clock_in_open_by_start
on clock_in (sta_dat_clk)
where end_dat_clk is null;
