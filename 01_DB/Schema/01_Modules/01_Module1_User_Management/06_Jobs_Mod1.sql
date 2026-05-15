-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 06_Jobs_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- pg_cron schedules invoking Module 1 maintenance procedures.
--
-- This file contains:
-- - Daily clock-in hygiene
-- - Daily absence cancellation pass
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - pg_cron extension and rights to schedule jobs
-- - 05_Procedures_Mod1.sql deployed
--
-- Must load before:
-- - Production cutover (ensure database timezone expectation matches cron)
-- =========================================================

-- =========================================================
-- Closes lingering clock-in rows at midnight
-- =========================================================

select cron.schedule(
    'auto_close_clockin_midnight',
    '0 0 * * *',  -- every day at 00:00
    $$ call sp_auto_close_clock_in_midnight(); $$
);


-- =========================================================
-- Cancels stale pending absences shortly after midnight
-- =========================================================

select cron.schedule( 
    'auto_cancel_expired_absences',
    '5 0 * * *',  -- every day at 00:05
    $$ call sp_auto_cancel_expired_absences(); $$
);
