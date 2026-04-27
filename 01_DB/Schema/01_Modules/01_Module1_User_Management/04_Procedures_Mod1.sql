--=========================================================
-- FUNCTION 5: fn_auto_close_clock_in_midnight
-- Closes open clock-in records from previous days by setting
-- the end time to midnight (00:00) of the current day.
--=========================================================

create or replace function fn_auto_close_clock_in_midnight()
returns void as $$
begin
    -- Update all open clock-in records from previous days
    update clock_in
    set end_dat_clk = date_trunc('day', now())  -- current day at 00:00
    where end_dat_clk is null
      and sta_dat_clk < date_trunc('day', now()); -- started before today
end;
$$ language plpgsql;
