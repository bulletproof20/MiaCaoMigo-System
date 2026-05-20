-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod4.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Integrity GiST exclusion, scheduling partial indexes, FK
-- lookup aids, and notification inbox support. Avoids broad
-- redundant indexes on sch_dat_app alone.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - appointment, appointment_notification tables
-- - btree_gist extension
-- =========================================================

drop index if exists ix_appointment_status_for_jobs;
drop index if exists ix_appointment_id_cli;
drop index if exists ix_appointment_id_emp;
drop index if exists ix_appointment_id_ani;
drop index if exists ix_appointment_vet_schedule;
drop index if exists ix_appointment_sch_dat_app;
drop index if exists ix_appointment_operational_day;
drop index if exists ix_notification_client_read_status;
alter table appointment drop constraint if exists ex_appointment_vet_overlap;


-- =========================================================
-- INTEGRITY — veterinarian slot overlap prevention
-- =========================================================
-- Optimizes:
--   - double-booking prevention for scheduled visits
--   - fn_block_overlapping_appointments validation
--
-- GiST exclusion on 30-minute slots per id_emp (scheduled only).
-- =========================================================

alter table appointment
add constraint ex_appointment_vet_overlap
exclude using gist (
    id_emp with =,
    tsrange(sch_dat_app, sch_dat_app + interval '30 minutes') with &&
) where (status_app = 'scheduled');


-- =========================================================
-- SCHEDULING — cron jobs on scheduled appointments
-- =========================================================
-- Optimizes:
--   - sp_auto_update_no_show_appointments
--   - sp_generate_appointment_warnings (scheduled + date filter)
--   - partial scans on status_app = scheduled ordered by time
--
-- Replaces a generic sch_dat_app index for job-shaped queries.
-- =========================================================

create index ix_appointment_status_for_jobs
on appointment (sch_dat_app)
where status_app = 'scheduled';


-- =========================================================
-- SCHEDULING — veterinarian calendar (scheduled)
-- =========================================================
-- Optimizes:
--   - overlap checks and vet schedule queries
--   - filters on (id_emp, sch_dat_app) for scheduled rows
--
-- Leading id_emp supports vet-centric dashboards; partial
-- narrows to bookable visits only.
-- =========================================================

create index ix_appointment_vet_schedule
on appointment (id_emp, sch_dat_app)
where status_app = 'scheduled';


-- =========================================================
-- SCHEDULING — daily operational board
-- =========================================================
-- Optimizes:
--   - vw_appointments_today
--   - same-day filters on sch_dat_app for active visit states
--
-- Partial index covers scheduled and in-progress same-day loads.
-- =========================================================

create index ix_appointment_operational_day
on appointment (sch_dat_app)
where status_app in ('scheduled', 'in_progress');


-- =========================================================
-- OPERATIONAL — client appointment history
-- =========================================================
-- Optimizes:
--   - vw_appointment_detail client joins
--   - client-centric appointment listings
--
-- FK child index on appointment.id_cli.
-- =========================================================

create index ix_appointment_id_cli
on appointment (id_cli);


-- =========================================================
-- OPERATIONAL — veterinarian workload (all statuses)
-- =========================================================
-- Optimizes:
--   - appointment lookups by id_emp outside scheduled-only paths
--   - in_progress and completed visit queries per vet
--
-- Complements ix_appointment_vet_schedule (scheduled partial).
-- =========================================================

create index ix_appointment_id_emp
on appointment (id_emp);


-- =========================================================
-- OPERATIONAL — animal medical history navigation
-- =========================================================
-- Optimizes:
--   - vw_appointment_detail animal joins
--   - animal-centric appointment history
--
-- FK child index on appointment.id_ani.
-- =========================================================

create index ix_appointment_id_ani
on appointment (id_ani);


-- =========================================================
-- OPERATIONAL — client notification inbox
-- =========================================================
-- Optimizes:
--   - unread notification feeds (id_cli, rea_not)
--   - client notification panels
--
-- Composite index matches typical inbox filter order.
-- =========================================================

create index ix_notification_client_read_status
on appointment_notification (id_cli, rea_not);
