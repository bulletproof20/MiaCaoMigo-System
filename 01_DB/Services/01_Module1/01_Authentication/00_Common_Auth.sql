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
        where ema_log = p_email -- match email
          and sou_tim_log is null -- only active sessions
          and suc_log = true; -- only valid sessions

    end if;

    --=====================================================
    -- 3. END FUNCTION
    --=====================================================

end;
$$ language plpgsql;


