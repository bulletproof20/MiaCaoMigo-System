-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 05_Procedures_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Operational procedures supporting HR attendance hygiene and
-- absence lifecycle automation.
--
-- This file contains:
-- - Midnight closure for dangling clock-ins
-- - Automatic cancellation of stale pending absences
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 02_Functions_Mod1.sql / related tables populated
--
-- Must load before:
-- - 06_Jobs_Mod1.sql (pg_cron call targets)
-- =========================================================

-- =========================================================
-- Closes overnight clock-ins still missing an end timestamp
-- =========================================================

create or replace procedure sp_auto_close_clock_in_midnight()
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


-- =========================================================
-- Marks expired pending absences as cancelled
-- =========================================================

create or replace procedure sp_auto_cancel_expired_absences()
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
