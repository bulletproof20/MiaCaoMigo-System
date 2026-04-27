--=========================================================
-- FUNCTIONS - MODULE 1 (USER MANAGEMENT / ATTENDANCE)
-- Contains trigger-support functions and business logic
--=========================================================

--=========================================================
-- FUNCTION: fn_block_clock_in_if_absent
-- Prevents clock-in during absence (used by trigger)
--=========================================================

create or replace function fn_block_clock_in_if_absent()
returns trigger as $$
begin
    -- Check if there is any absence overlapping the clock-in time
    if exists (
        select 1
        from absence a
        where a.id_emp = new.id_emp                -- same employee
          and a.sta_dat_tim_abs <= new.sta_dat_clk -- absence starts before or at clock-in
          and a.end_dat_tim_abs >= new.sta_dat_clk -- absence ends after or at clock-in
    ) then
        -- Block insert if overlap exists
        raise exception 'Employee cannot clock in during an absence period';
    end if;

    -- Allow insert if no conflict
    return new;
end;
$$ language plpgsql;


