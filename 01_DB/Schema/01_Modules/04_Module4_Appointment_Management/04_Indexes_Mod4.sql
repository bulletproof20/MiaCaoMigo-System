--=========================================================
-- INDEXES - MODULE 4
-- Optimizes query performance for appointment management.
--=========================================================

--=========================================================
-- INDEX 1: idx_appointment_status_for_jobs
-- Speeds up jobs that frequently check for 'Scheduled' appointments.
--=========================================================
create index idx_appointment_status_for_jobs
on appointment (sch_dat_app)
where status_app = 'Scheduled';

--=========================================================
-- INDEX 2: idx_appointment_foreign_keys
-- Speeds up lookups and joins based on client, employee, and animal.
--=========================================================
create index idx_appointment_id_cli on appointment (id_cli);
create index idx_appointment_id_emp on appointment (id_emp);
create index idx_appointment_id_animal on appointment (id_animal);

--=========================================================
-- INDEX 3: idx_appointment_sch_dat_app
-- Speeds up general queries filtering or ordering by scheduled date,
-- such as historical reports.
--=========================================================
create index idx_appointment_sch_dat_app on appointment (sch_dat_app);

--=========================================================
-- INDEX 4: idx_notification_client_read_status
-- Speeds up fetching unread notifications for a specific client.
-- This is a composite index, optimized for queries like:
-- SELECT * FROM appointment_notification WHERE id_cli = X AND is_read = false;
--=========================================================
create index idx_notification_client_read_status on appointment_notification (id_cli, is_read);