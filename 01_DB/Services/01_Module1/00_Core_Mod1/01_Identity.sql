--=========================================================
-- MODULE 1 - IDENTITY FUNCTIONS
--=========================================================
-- Description:
-- Shared identity and lookup helper functions used across:
--
-- - authentication
-- - account creation
-- - RBAC
-- - scheduling
-- - auditing
-- - operational workflows
-- - cross-module logic
--
-- Scope:
-- - user lookup
-- - employee lookup
-- - client lookup
-- - identity existence validation
-- - active employment retrieval
--
-- Notes:
-- - lightweight helper functions only
-- - no business workflow logic
-- - no authorization logic
-- - functions return NULL when no result exists
--=========================================================

--=========================================================
-- function: fn_is_employee_email
--=========================================================
-- description:
-- determines whether a given email belongs to an employee
-- based on its domain.
--
-- purpose:
-- - centralizes domain-based user type logic
-- - avoids duplication across multiple functions
--=========================================================
drop function if exists fn_is_employee_email(varchar);

create function fn_is_employee_email(p_email varchar)
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
-- function: fn_get_user_by_email
--=========================================================
-- description:
-- retrieves the user identifier associated with a given email.
--
-- purpose:
-- - supports both employee and client
-- - navigates correctly through the data model
--=========================================================
drop function if exists fn_get_user_by_email(varchar);

create function fn_get_user_by_email(p_email varchar)
returns integer as $$
declare
    v_user_id integer;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. RETRIEVE USER ID
    --=====================================================

    if fn_is_employee_email(p_email) then

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
-- function: fn_get_user_by_nif
--=========================================================
-- description:
-- retrieves a user identifier from a nif.
--
-- returns:
-- - id_usr if found
-- - null if not found
--=========================================================

create or replace function fn_get_user_by_nif(
    p_nif varchar
)
returns int as $$

declare
    v_id_usr int;

begin

    --=====================================================
    -- 1. NORMALIZE NIF
    --=====================================================

    p_nif := trim(p_nif);

    --=====================================================
    -- 2. RETRIEVE USER
    --=====================================================

    select u.id_usr
    into v_id_usr
    from user_account u
    where u.nif_usr = p_nif;

    --=====================================================
    -- 3. RETURN RESULT
    --=====================================================

    return v_id_usr;

end;

$$ language plpgsql;



--=========================================================
-- function: fn_get_user_by_employee
--=========================================================
-- description:
-- retrieves the user associated with an employee record.
--
-- returns:
-- - id_usr if found
-- - null if not found
--=========================================================

create or replace function fn_get_user_by_employee(
    p_id_emp int
)
returns int as $$

declare
    v_id_usr int;

begin

    --=====================================================
    -- 1. RETRIEVE USER
    --=====================================================

    select e.id_usr
    into v_id_usr
    from employee e
    where e.id_emp = p_id_emp;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_id_usr;

end;

$$ language plpgsql;



--=========================================================
-- function: fn_get_user_by_client
--=========================================================
-- description:
-- retrieves the user associated with a client.
--
-- returns:
-- - id_usr if found
-- - null if not found
--=========================================================

create or replace function fn_get_user_by_client(
    p_id_cli int
)
returns int as $$

declare
    v_id_usr int;

begin

    --=====================================================
    -- 1. RETRIEVE USER
    --=====================================================

    select c.id_usr
    into v_id_usr
    from client c
    where c.id_cli = p_id_cli;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_id_usr;

end;

$$ language plpgsql;



--=========================================================
-- function: fn_get_active_employee_by_user
--=========================================================
-- description:
-- retrieves the currently active employee record associated
-- with a user.
--
-- business meaning:
-- - a user may have multiple historical employee records
-- - only one active employment instance should exist
--
-- active employee:
-- - dea_dat_emp is null
--
-- returns:
-- - active id_emp if found
-- - null if no active employment exists
--=========================================================

create or replace function fn_get_active_employee_by_user(
    p_id_usr int
)
returns int as $$

declare
    v_id_emp int;

begin

    --=====================================================
    -- 1. RETRIEVE ACTIVE EMPLOYEE
    --=====================================================

    select e.id_emp
    into v_id_emp
    from employee e
    where e.id_usr = p_id_usr
      and e.dea_dat_emp is null
    limit 1;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_id_emp;

end;

$$ language plpgsql;



--=========================================================
-- function: fn_get_client_by_user
--=========================================================
-- description:
-- retrieves the client associated with a user.
--
-- returns:
-- - id_cli if found
-- - null if not found
--=========================================================

create or replace function fn_get_client_by_user(
    p_id_usr int
)
returns int as $$

declare
    v_id_cli int;

begin

    --=====================================================
    -- 1. RETRIEVE CLIENT
    --=====================================================

    select c.id_cli
    into v_id_cli
    from client c
    where c.id_usr = p_id_usr;

    --=====================================================
    -- 2. RETURN RESULT
    --=====================================================

    return v_id_cli;

end;

$$ language plpgsql;



create or replace function fn_user_exists_by_email(
    p_email varchar
)
returns boolean as $$

begin

    -- normalize email
    p_email := normalize_email(p_email);

    -- validate existence in:
    -- - personal accounts
    -- - active employee accounts

    return exists (

        select 1
        from user_account u
        where u.ema_usr = p_email

    )

    or exists (

        select 1
        from employee e
        where e.ema_emp = p_email
          and e.dea_dat_emp is null

    );

end;

$$ language plpgsql;



--=========================================================
-- function: fn_user_exists_by_nif
--=========================================================
-- description:
-- determines whether a user exists by nif.
--=========================================================

create or replace function fn_user_exists_by_nif(
    p_nif varchar
)
returns boolean as $$

begin

    --=====================================================
    -- 1. NORMALIZE NIF
    --=====================================================

    p_nif := trim(p_nif);

    --=====================================================
    -- 2. VALIDATE EXISTENCE
    --=====================================================

    return exists (

        select 1
        from user_account u
        where u.nif_usr = p_nif

    );

end;

$$ language plpgsql;



--=========================================================
-- function: fn_client_exists
--=========================================================
-- description:
-- determines whether a user already has a client account.
--=========================================================

create or replace function fn_client_exists(
    p_id_usr int
)
returns boolean as $$

begin

    --=====================================================
    -- 1. VALIDATE CLIENT EXISTENCE
    --=====================================================

    return exists (

        select 1
        from client c
        where c.id_usr = p_id_usr

    );

end;

$$ language plpgsql;



--=========================================================
-- function: fn_has_active_employee
--=========================================================
-- description:
-- determines whether a user currently has an active
-- employment record.
--
-- active employee:
-- - dea_dat_emp is null
--=========================================================

create or replace function fn_has_active_employee(
    p_id_usr int
)
returns boolean as $$

begin

    --=====================================================
    -- 1. VALIDATE ACTIVE EMPLOYMENT
    --=====================================================

    return exists (

        select 1
        from employee e
        where e.id_usr = p_id_usr
          and e.dea_dat_emp is null

    );

end;

$$ language plpgsql;



--=========================================================
-- function: fn_is_veterinarian
--=========================================================
-- description:
-- determines whether an employee is a veterinarian.
--=========================================================

create or replace function fn_is_veterinarian(
    p_id_emp int
)
returns boolean as $$

begin

    --=====================================================
    -- 1. VALIDATE VETERINARIAN ROLE
    --=====================================================

    return exists (

        select 1
        from veterinarian v
        where v.id_emp = p_id_emp

    );

end;

$$ language plpgsql;



--=========================================================
-- function: fn_is_assistant
--=========================================================
-- description:
-- determines whether an employee is an assistant.
--=========================================================

create or replace function fn_is_assistant(
    p_id_emp int
)
returns boolean as $$

begin

    --=====================================================
    -- 1. VALIDATE ASSISTANT ROLE
    --=====================================================

    return exists (

        select 1
        from assistant a
        where a.id_emp = p_id_emp

    );

end;

$$ language plpgsql;

