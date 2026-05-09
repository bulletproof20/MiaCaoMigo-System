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

-- daily_appointment_warnings — issues client notifications for visits on the next business day.
-- opened_appointments_auto_close — reuses prc_auto_close_clock_in_midnight for nightly hygiene.

comment on function cron.schedule(text, text, text) is
'registers scheduled pg_cron jobs responsible for automated database task execution';
