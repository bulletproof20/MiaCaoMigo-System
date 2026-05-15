-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 06_Jobs_Mod4.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- pg_cron schedules aligned with appointment notification and hygiene procedures.
--
-- This file contains:
-- - Morning client reminder sweep
-- - Post-midnight no-show synchronization
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - pg_cron extension
-- - 05_Procedures_Mod4.sql (warning + no-show routines)
--
-- Cron format reference: minute hour day-of-month month day-of-week
-- =========================================================

-- =========================================================
-- Sends next-day appointment reminders every morning
-- =========================================================

select cron.schedule(
    'daily_appointment_warnings',
    '0 8 * * *',  -- Executes daily at 8:00 AM
    $$ CALL sp_generate_appointment_warnings(); $$
);

-- =========================================================
-- Flags missed scheduled appointments after midnight
-- =========================================================

select cron.schedule(
    'daily_no_show_appointment_updater',
    '5 0 * * *', -- Executes daily at 00:05 AM
    $$ CALL sp_auto_update_no_show_appointments(); $$
);
