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



--=========================================================
-- FUNCTION: fn_block_inactivate_if_clock_active
-- Prevents employee inactivation if there is an active clock-in
--=========================================================

create or replace function fn_block_inactivate_if_clock_active()
returns trigger as $$
begin
    -- Check if employee is being inactivated (dea_dat_emp is being set)
    if new.dea_dat_emp is not null and old.dea_dat_emp is null then

        -- Verify if there is an open clock-in (no end time)
        if exists (
            select 1
            from clock_in c
            where c.id_emp = old.id_emp      -- same employee
              and c.end_dat_clk is null      -- active clock-in
        ) then
            -- Block update if active clock-in exists
            raise exception 'Cannot inactivate employee with active clock-in';
        end if;

    end if;

    -- Allow update if no conflict
    return new;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION: fn_check_user_has_mandatory_role
-- Prevents creation of a user without at least one role
-- (employee and/or client)
--=========================================================

create or replace function fn_check_user_has_mandatory_role()
returns trigger as $$
begin
    -- Verify if the user has no associated roles
    if not exists (
        select 1
        from employee e
        where e.id_usr = new.id_usr      -- same user
    )
    and not exists (
        select 1
        from client c
        where c.id_usr = new.id_usr      -- same user
    ) then
        -- Block transaction if user has no roles
        raise exception 
        'User % must be associated with at least one role (employee or client)',
        new.id_usr;
    end if;

    -- Allow operation if at least one role exists
    return null;
end;
$$ language plpgsql;