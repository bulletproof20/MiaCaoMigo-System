-- =========================================================
-- comments: indexes - module 4
-- =========================================================

comment on constraint ex_appointment_vet_overlap on appointment is
'gist exclusion: prevents overlapping 30-minute scheduled slots per veterinarian';

comment on index idx_appointment_status_for_jobs is
'partial b-tree: scheduled appointments by sch_dat_app for cron jobs';

comment on index idx_appointment_vet_schedule is
'partial b-tree: veterinarian scheduled visits by id_emp and sch_dat_app';

comment on index idx_appointment_operational_day is
'partial b-tree: same-day board for scheduled and in-progress visits';

comment on index idx_appointment_id_cli is
'b-tree: client-centric appointment history and joins';

comment on index idx_appointment_id_emp is
'b-tree: veterinarian workload across all appointment statuses';

comment on index idx_appointment_id_ani is
'b-tree: animal medical history and appointment navigation';

comment on index idx_notification_client_read_status is
'composite b-tree: client notification inbox filtered by read flag';
