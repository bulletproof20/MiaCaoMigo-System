-- =========================================================
-- Module: Authentication - Login
-- Function: login_user
-- =========================================================
-- Description:
-- Handles user login attempts by validating credentials and
-- enforcing session rules.
--
-- Responsibilities:
-- - Validates user existence
-- - Verifies password correctness
-- - Checks for active sessions (single-session policy)
-- - Registers all login attempts (successful and failed)
--
-- Behavior:
-- - Login fails if email does not exist
-- - Login fails if password is incorrect
-- - Login fails if there is an active session
-- - All attempts are recorded in login_record
--
-- Returns:
-- - email
-- - password_ok (boolean)
-- - has_active_session (boolean)
-- - user_id (integer)
-- - login_success (boolean)
--
-- Dependencies:
-- - user_exists(varchar)
-- - validate_password(varchar, varchar)
-- - get_user_by_email(varchar)
-- - has_active_sessions(varchar)
--
-- Notes:
-- - Implements single active session per user
-- - No password encryption applied (direct comparison)
--
-- Authors: Ivo Sá, João Ramalho, João Navarro, Tiago Mendes
-- Version: 1.2 (Login Logic Module)
-- Date: 2026-04-15
-- =========================================================

--=========================================================
-- function: login_user
--=========================================================
-- description:
-- validates login and determines success based on:
-- - valid email
-- - correct password
-- - no active sessions
--=========================================================
drop function if exists login_user(varchar, varchar, inet);

create function login_user(
    p_email varchar,
    p_password varchar,
    p_ip inet
)
returns table (
    email varchar,
    password_ok boolean,
    has_active_session boolean,
    user_id integer,
    login_success boolean
) as $$
declare
    v_user_id integer;
    v_password_ok boolean;
    v_has_session boolean;
    v_login_success boolean;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. VALIDATE USER EXISTENCE
    --=====================================================

    if not user_exists(p_email) then

        insert into login_record (
            sig_tim_log, suc_log, ip_add_log, eml_usr
        )
        values (
            now(), false, p_ip, p_email
        );

        return query
        select null::varchar, false::boolean, false::boolean, null::integer, false::boolean;

        return;
    end if;

    --=====================================================
    -- 2. VALIDATE PASSWORD
    --=====================================================

    v_password_ok := validate_password(p_email, p_password);

    if not v_password_ok then

        insert into login_record (
            sig_tim_log, suc_log, ip_add_log, eml_usr
        )
        values (
            now(), false, p_ip, p_email
        );

        return query
        select p_email::varchar, false::boolean, false::boolean, null::integer, false::boolean;

        return;
    end if;

    --=====================================================
    -- 3. GET USER ID
    --=====================================================

    v_user_id := get_user_by_email(p_email);

    --=====================================================
    -- 4. CHECK ACTIVE SESSION
    --=====================================================

    v_has_session := has_active_sessions(p_email);

    --=====================================================
    -- 5. DETERMINE LOGIN SUCCESS
    --=====================================================

    -- success only if NO active sessions
    v_login_success := not v_has_session;

    --=====================================================
    -- 6. REGISTER ATTEMPT
    --=====================================================

    insert into login_record (
        sig_tim_log,
        suc_log,
        ip_add_log,
        eml_usr,
        id_usr
    )
    values (
        now(),
        v_login_success, -- only true if no active session
        p_ip,
        p_email,
        v_user_id
    );

    --=====================================================
    -- 7. RETURN RESULT
    --=====================================================

    return query
    select 
        p_email::varchar,
        true::boolean,
        v_has_session::boolean,
        v_user_id::integer,
        v_login_success::boolean;

end;
$$ language plpgsql;


