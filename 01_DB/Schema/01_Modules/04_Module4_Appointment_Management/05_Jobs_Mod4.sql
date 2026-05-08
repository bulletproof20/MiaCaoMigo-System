--=========================================================
-- JOBS - MODULE 4
-- Scheduled tasks for appointment management
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

--=========================================================
-- JOB 1: daily_appointment_warnings
-- Executes daily to generate warnings for appointments on the next day.
--=========================================================
select cron.schedule(
    'daily_appointment_warnings',
    '0-30 9-19 * * 1-5',  -- Executa de meia em meia hora, das 08:00 às 19:30, de segunda a sexta-feira
    --A assumir que a clinica só está aberta das 09:00 às 20:00
    $$ CALL prc_generate_appointment_warnings(); $$
);
--=========================================================
-- JOB 1: opened_appointments_auto_close
-- Executes daily to close opened appointments on the previous day.
--=========================================================
selecr cron.schedule(
    'opened_appointments_auto_close',
    '30 22 * * 1-5',      -- Executa de meia em meia hora, das 08:00 às 19:30, de segunda a sexta-feira
    $$ CALL prc_auto_close_clock_in_midnight(); $$
);
--=========================================================