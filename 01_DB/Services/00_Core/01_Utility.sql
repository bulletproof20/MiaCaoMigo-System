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
        where lr.ema_log = p_email
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