--=========================================================
-- PROCEDURE: prc_auto_close_clock_in_midnight
-- Closes open clock-in records from previous days by setting
-- the end time to midnight (00:00) of the current day.
--=========================================================

create or replace procedure prc_auto_close_clock_in_midnight()
language plpgsql
as $$
begin

    -- Update all open clock-in records from previous days
    update clock_in
    set end_dat_clk = date_trunc('day', now())  -- current day at 00:00
    where end_dat_clk is null
      and sta_dat_clk < date_trunc('day', now()); -- started before today

end;
$$;



--=========================================================
-- PROCEDURE: prc_auto_cancel_expired_absences
-- Automatically cancels pending absences whose end date
-- has already passed, preserving historical records.
--=========================================================

create or replace procedure prc_auto_cancel_expired_absences()
language plpgsql
as $$
begin

    -- Update expired pending absences
    update absence
    set sta_abs = 'cancelled'
    where sta_abs = 'pending'
      and end_dat_tim_abs < current_timestamp;

end;
$$;
