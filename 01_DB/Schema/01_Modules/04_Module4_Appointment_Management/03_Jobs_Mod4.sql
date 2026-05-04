--=========================================================
-- JOBS - MODULE 4
-- Scheduled tasks for appointment management
--=========================================================

--=========================================================
-- JOB 1: daily_appointment_warnings
-- Executes daily to generate warnings for appointments on the next day.
--=========================================================


-- ┌───────────── min (0 - 59)
-- │ ┌────────────── hour (0 - 23)
-- │ │ ┌─────────────── day of month (1 - 31) or last day of the month ($)
-- │ │ │ ┌──────────────── month (1 - 12)
-- │ │ │ │ ┌───────────────── day of week (0 - 6) (0 to 6 are Sunday to
-- │ │ │ │ │                  Saturday, or use names; 7 is also Sunday)
-- │ │ │ │ │
-- │ │ │ │ │
-- * * * * *


-- select cron.schedule(
--     'daily_appointment_warnings',
--     '0 8 * * *',  -- Executa todos os dias às 08:00 [A ser alterado ~ João]
--     $$ select fn_appointment_warning_next_day(); $$
-- );
