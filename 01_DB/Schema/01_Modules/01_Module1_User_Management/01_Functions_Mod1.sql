--=========================================================
-- FUNCTIONS - MODULE 1 (USER MANAGEMENT / ATTENDANCE)
-- Contains trigger-support functions and business logic
--=========================================================

--=========================================================
-- FUNCTION 1: fn_block_clock_in_if_absent
-- Prevents clock-in during absence by blocking inserts
-- that overlap with an absence period.
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
-- FUNCTION 2: fn_block_inactivate_if_clock_active
-- Prevents employee inactivation if there is an active
-- clock-in record (without end time).
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
-- FUNCTION 3: fn_block_assistant_if_veterinarian_exists
-- Ensures role disjunction by preventing assignment as
-- assistant when the employee is already a veterinarian.
--=========================================================

create or replace function fn_block_assistant_if_veterinarian_exists()
returns trigger as $$
begin
    -- Check if employee is being assigned as assistant
    if exists (
        select 1
        from veterinarian v
        where v.id_emp = new.id_emp   -- same employee
    ) then
        -- Block insert/update if already veterinarian
        raise exception 
        'Cannot assign employee % as assistant: already veterinarian',
        new.id_emp;
    end if;

    -- Allow operation if no conflict
    return new;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION 4: fn_block_veterinarian_if_assistant_exists
-- Ensures role disjunction by preventing assignment as
-- veterinarian when the employee is already an assistant.
--=========================================================

create or replace function fn_block_veterinarian_if_assistant_exists()
returns trigger as $$
begin
    -- Check if employee is being assigned as veterinarian
    if exists (
        select 1
        from assistant a
        where a.id_emp = new.id_emp   -- same employee
    ) then
        -- Block insert/update if already assistant
        raise exception 
        'Cannot assign employee % as veterinarian: already assistant',
        new.id_emp;
    end if;

    -- Allow operation if no conflict
    return new;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION 5: fn_block_absence_overlap_by_user
-- Prevents overlapping absences for the same user,
-- even across multiple employee records associated
-- with that user.
--=========================================================

create or replace function fn_block_absence_overlap_by_user()
returns trigger as $$
begin

    -- Only validate operationally active absence states
    if new.sta_abs in ('pending', 'approved', 'detected') then

        -- Check if another overlapping absence exists
        -- for any employee record associated with the same user
        if exists (

            select 1

            from absence a

            inner join employee e_existing
                on e_existing.id_emp = a.id_emp

            inner join employee e_new
                on e_new.id_emp = new.id_emp

            where e_existing.id_usr = e_new.id_usr
            -- Same user

              and (
                    tg_op = 'INSERT'
                    or a.id_abs <> new.id_abs
                  )
            -- Ignore same absence during updates 

              and a.sta_abs in (
                    'pending',
                    'approved',
                    'detected'
                  )
            -- Only validate operationally active absences

              and new.sta_dat_tim_abs < a.end_dat_tim_abs
              and new.end_dat_tim_abs > a.sta_dat_tim_abs
            -- Temporal overlap validation

        ) then

            -- Block insert/update if overlap exists
            raise exception
            'Cannot create overlapping absences for the same user';

        end if;

    end if;

    -- Allow operation if no conflict
    return new;

end;
$$ language plpgsql;


