-- =========================================================
-- Project: MiaCaoMigo
-- UC: Database Programming
-- Group: Group 4 - EIM
-- Description: Set of auxiliary PL/pgSQL functions for 
--              authentication, validation and session 
--              management based on user email.
-- 
-- Scope:
-- - Email domain classification (employee vs client)
-- - User existence and identification
-- - Password validation
-- - Active session control and termination
--
-- Authors: Ivo Sá, João Ramalho, João Navarro, Tiago Mendes
-- Version: 1.2 (Updated Functions Module)
-- Date: 2026-04-15
-- =========================================================

--=========================================================
-- function: normalize_email
--=========================================================
-- description:
-- normalizes an email address by trimming whitespace
-- and converting to lowercase
--
-- purpose:
-- - ensure consistency across all authentication functions
-- - avoid duplicated normalization logic
--=========================================================
drop function if exists normalize_email(varchar);

create function normalize_email(p_email varchar)
returns varchar as $$
begin
    -- return nullif(lower(trim(p_email)), '');
    return lower(trim(p_email));
end;
$$ language plpgsql;

--=========================================================
-- function: is_employee_email
--=========================================================
-- description:
-- determines whether a given email belongs to an employee
-- based on its domain.
--
-- purpose:
-- - centralizes domain-based user type logic
-- - avoids duplication across multiple functions
--=========================================================
drop function if exists is_employee_email(varchar);

create function is_employee_email(p_email varchar)
returns boolean as $$
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. CHECK EMAIL DOMAIN
    --=====================================================

    return p_email ~ '^[^@\s]+@miacaomigo\.pt$';

end;
$$ language plpgsql;

--=========================================================
-- function: user_exists
--=========================================================
-- description:
-- verifies whether a user exists in the system based on email.
--
-- purpose:
-- - supports both employee and client validation
-- - ensures correct lookup depending on user type
--=========================================================
drop function if exists user_exists(varchar);

create function user_exists(p_email varchar)
returns boolean as $$
declare
    v_exists boolean;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. CHECK USER EXISTENCE
    --=====================================================

    if is_employee_email(p_email) then

        -- employee email validation
        select exists (
            select 1
            from employee e
            where e.ema_emp = p_email
        ) into v_exists;

    else

        -- client email validation
        select exists (
            select 1
            from user_account u
            where u.ema_usr = p_email
        ) into v_exists;

    end if;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_exists;

end;
$$ language plpgsql;

--=========================================================
-- function: get_user_by_email
--=========================================================
-- description:
-- retrieves the user identifier associated with a given email.
--
-- purpose:
-- - supports both employee and client
-- - navigates correctly through the data model
--=========================================================
drop function if exists get_user_by_email(varchar);

create function get_user_by_email(p_email varchar)
returns integer as $$
declare
    v_user_id integer;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. RETRIEVE USER ID
    --=====================================================

    if is_employee_email(p_email) then

        -- employee → user_account
        select e.id_usr
        into v_user_id
        from employee e
        where e.ema_emp = p_email;

    else

        -- client → user_account
        select u.id_usr
        into v_user_id
        from user_account u
        where u.ema_usr = p_email;

    end if;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_user_id;

end;
$$ language plpgsql;

--=========================================================
-- function: validate_password
--=========================================================
-- description:
-- validates a user's password based on their email.
--
-- purpose:
-- - retrieves password from correct table
-- - supports both employee and client
-- - uses direct comparison (no encryption)
--=========================================================
drop function if exists validate_password(varchar, varchar);

create function validate_password(p_email varchar, p_password varchar)
returns boolean as $$
declare
    v_password_db varchar;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. RETRIEVE STORED PASSWORD
    --=====================================================

    if is_employee_email(p_email) then

        -- employee password
        select e.pas_emp
        into v_password_db
        from employee e
        where e.ema_emp = p_email;

    else

        -- client password
        select c.pas_cli
        into v_password_db
        from client c
        join user_account u on u.id_usr = c.id_usr
        where u.ema_usr = p_email;

    end if;

    --=====================================================
    -- 2. VALIDATE PASSWORD
    --=====================================================

    return v_password_db = p_password;

end;
$$ language plpgsql;

--=========================================================
-- function: has_active_sessions
--=========================================================
-- description:
-- checks whether there are active sessions associated with
-- a given email address.
--
-- purpose:
-- - independent of user type
-- - relies on login_record only
--=========================================================
drop function if exists has_active_sessions(varchar);

create function has_active_sessions(p_email varchar)
returns boolean as $$
declare
    v_exists boolean;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. CHECK ACTIVE SESSIONS
    --=====================================================

    select exists (
        select 1
        from login_record lr
        where lr.eml_usr = p_email
          and lr.sou_tim_log is null
          and lr.suc_log = true
    )
    into v_exists;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_exists;

end;
$$ language plpgsql;


--=========================================================
-- function: close_active_sessions_by_email
--=========================================================
-- description:
-- terminates all active sessions associated with a given email.
--
-- purpose:
-- - enforces single-session policy
-- - avoids unnecessary updates by checking active sessions first
-- - reuses existing session validation logic
--=========================================================
drop function if exists close_active_sessions_by_email(varchar);

create function close_active_sessions_by_email(p_email varchar)
returns void as $$
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. CHECK FOR ACTIVE SESSIONS
    --=====================================================

    if has_active_sessions(p_email) then

        --=================================================
        -- 2. CLOSE ACTIVE SESSIONS
        --=================================================

        update login_record
        set sou_tim_log = now() -- mark logout timestamp
        where eml_usr = p_email -- match email
          and sou_tim_log is null -- only active sessions
          and suc_log = true; -- only valid sessions

    end if;

    --=====================================================
    -- 3. END FUNCTION
    --=====================================================

end;
$$ language plpgsql;

