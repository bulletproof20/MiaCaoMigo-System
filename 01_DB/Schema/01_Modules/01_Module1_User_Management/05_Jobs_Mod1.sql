create extension pg_cron; 

--=========================================================
-- JOB 1: auto_close_clock_in_midnight
-- Executes daily at 00:00 to automatically close open
-- clock-in records from previous days.
--=========================================================

select cron.schedule(
    'auto_close_clockin_midnight',
    '0 0 * * *',  -- every day at 00:00
    $$ select fn_auto_close_clock_in_midnight(); $$
);