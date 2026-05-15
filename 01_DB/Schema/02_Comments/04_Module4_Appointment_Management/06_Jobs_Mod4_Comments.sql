-- =========================================================
-- comments: jobs - module 4
-- =========================================================
-- metadata documentation for scheduled automation tied to
-- appointment reminders and housekeeping routines.
--
-- important:
-- pg_cron jobs are not native relational schema objects.
-- postgresql does not allow comment on job entries; keep the
-- narrative beside cron.schedule in 06_Jobs_Mod4.sql.
-- =========================================================

comment on function cron.schedule(text, text, text) is
'Executes scheduled pg_cron jobs responsible for automated database task execution';

comment on procedure prc_generate_appointment_warnings() is
'(Job: daily_appointment_warnings) — issues client notifications for visits on the next business day.';

comment on procedure prc_auto_update_no_show_appointments() is
'(Job: daily_no_show_appointment_updater) — marks missed appointments as No-Show for nightly hygiene.';
