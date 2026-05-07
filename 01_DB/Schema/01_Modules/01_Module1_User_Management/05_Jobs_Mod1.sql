--=========================================================
-- JOB 1: auto_close_clock_in_midnight
-- Executes daily at 00:00 to automatically close open
-- clock-in records from previous days.
--=========================================================

select cron.schedule(
    'auto_close_clockin_midnight',
    '0 0 * * *',  -- every day at 00:00
    $$ call prc_auto_close_clock_in_midnight(); $$
);



--=========================================================
-- JOB 2: auto_cancel_expired_absences
-- Executes daily at 00:05 to automatically cancel
-- pending absences whose end date has already passed.
--=========================================================

select cron.schedule(
    'auto_cancel_expired_absences',
    '5 0 * * *',  -- every day at 00:05
    $$ call prc_auto_cancel_expired_absences(); $$
);
