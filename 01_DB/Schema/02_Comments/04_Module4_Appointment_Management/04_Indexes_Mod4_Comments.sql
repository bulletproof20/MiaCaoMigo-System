-- =========================================================
-- comments: indexes - module 4
-- =========================================================
-- metadata documentation for btree indexes supporting reporting
-- and scheduled jobs.
-- =========================================================

comment on index idx_appointment_status_for_jobs is
'partial index accelerating cron queries over scheduled visits';

comment on index idx_appointment_id_cli is
'supports client-centric appointment lookups';

comment on index idx_appointment_id_emp is
'supports veterinarian workload queries';

comment on index idx_appointment_id_animal is
'supports animal medical history navigation';

comment on index idx_appointment_vet_schedule is
'supports filtering and analytics by consultation specialty';

comment on index idx_appointment_sch_dat_app is
'optimizes sorts and filters on scheduled timestamps';

comment on index idx_notification_client_read_status is
'composite index for unread notification feeds per client';
