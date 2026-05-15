-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod4.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Performance indexes and GiST exclusion enforcing veterinarian
-- schedule spacing for active appointments.
--
-- This file contains:
-- - Filtered B-tree indexes for dashboards and jobs
-- - Composite notification lookup index
-- - Exclusion constraint preventing double-booked vets
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - appointment, appointment_notification tables
-- - btree_gist extension (install externally if not present)
--
-- Must load before:
-- - 06_Jobs_Mod4.sql (queries assume supporting indexes)
-- =========================================================

-- =========================================================
-- Drops prior module indexes/constraints for idempotent reloads
-- =========================================================

drop index if exists idx_appointment_status_for_jobs;
drop index if exists idx_appointment_id_cli;
drop index if exists idx_appointment_id_emp;
drop index if exists idx_appointment_id_ani;
drop index if exists idx_appointment_vet_schedule;
drop index if exists idx_appointment_sch_dat_app;
drop index if exists idx_notification_client_read_status;
alter table appointment drop constraint if exists ex_appointment_vet_overlap;

-- =========================================================
-- Accelerates job queries over scheduled future appointments
-- =========================================================

create index idx_appointment_status_for_jobs
on appointment (sch_dat_app)
where status_app = 'scheduled';

-- =========================================================
-- Speeds up joins and filters on foreign keys + vet schedules
-- =========================================================

create index idx_appointment_id_cli on appointment (id_cli);
create index idx_appointment_id_emp on appointment (id_emp);
create index idx_appointment_id_ani on appointment (id_ani);
create index idx_appointment_vet_schedule on appointment(id_emp, sch_dat_app) where status_app = 'scheduled';

-- =========================================================
-- Supports chronological reporting and ad hoc range scans
-- =========================================================

create index idx_appointment_sch_dat_app on appointment (sch_dat_app);

-- =========================================================
-- Optimizes unread notifications per client inbox
-- =========================================================

create index idx_notification_client_read_status on appointment_notification (id_cli, rea_not);

-- =========================================================
-- Prevents overlapping 30-minute slots per veterinarian
-- =========================================================

alter table appointment
add constraint ex_appointment_vet_overlap
exclude using gist (
    id_emp with =,
    tsrange(sch_dat_app, sch_dat_app + interval '30 minutes') with &&
) where (status_app = 'scheduled');
