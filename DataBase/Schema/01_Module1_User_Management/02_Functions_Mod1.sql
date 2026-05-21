-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 02_Functions_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Database functions for validation, automation support, and
-- business-rule encapsulation (attendance, roles, absences).
--
-- This file contains:
-- - Clock-in and absence overlap guards
-- - Employee / role disjunction checks
-- - Default setup provisioning for new accounts
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 1 tables and foreign keys
-- - Central types (00_Core/01_Types.sql) where referenced
--
-- Must load before:
-- - 03_Triggers_Mod1.sql
-- =========================================================

-- =========================================================
-- Blocks clock-in when the timestamp falls inside an absence window
-- =========================================================

drop function if exists fn_block_clock_in_if_absent();
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


-- =========================================================
-- Blocks employee inactivation while an open clock-in exists
-- =========================================================

drop function if exists fn_block_inactivate_if_clock_active();
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


-- =========================================================
-- Blocks assistant assignment when the employee is already a veterinarian
-- =========================================================

drop function if exists fn_block_assistant_if_veterinarian_exists();
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


-- =========================================================
-- Blocks veterinarian assignment when the employee is already an assistant
-- =========================================================

drop function if exists fn_block_veterinarian_if_assistant_exists();
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


-- =========================================================
-- Prevents overlapping absences for the same user across employee rows
-- =========================================================

drop function if exists fn_block_absence_overlap_by_user();
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


-- =========================================================
-- Creates default setup row after user_account insert (1:1 initialization)
-- =========================================================

drop function if exists fn_create_default_setup();
create function fn_create_default_setup()
returns trigger as $$
begin

    --=====================================================
    -- 1. CREATE DEFAULT SETUP
    --=====================================================

    insert into setup ( id_usr)
    values ( new.id_usr );

    --=====================================================
    -- 2. RETURN NEW ROW
    --=====================================================

    return new;

end;
$$ language plpgsql;
