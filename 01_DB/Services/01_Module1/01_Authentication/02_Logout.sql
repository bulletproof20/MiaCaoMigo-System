-- =========================================================
-- Module: Authentication - Logout
-- Function: logout_user
-- =========================================================
-- Description:
-- Terminates the active session associated with a given user
-- email address.
--
-- Responsibilities:
-- - Verifies existence of an active session
-- - Closes the active session by setting logout timestamp
-- - Preserves session history in login_record
--
-- Behavior:
-- - Returns false if no active session exists
-- - Returns true after successfully closing a session
--
-- Returns:
-- - boolean (true if logout performed, false otherwise)
--
-- Dependencies:
-- - has_active_sessions(varchar)
--
-- Notes:
-- - Only active and successful sessions are terminated
-- - Supports API-level logout operations
--
-- Authors: Ivo Sá, João Ramalho, João Navarro, Tiago Mendes
-- Version: 1.2 (Logout Module)
-- Date: 2026-04-15
-- =========================================================

--=========================================================
-- function: logout_user
--=========================================================
-- description:
-- terminates the active session of a user based on email.
--
-- purpose:
-- - closes current active session
-- - supports API logout operation
-- - maintains session history
--=========================================================
drop function if exists logout_user(varchar);

create function logout_user(p_email varchar)
returns boolean as $$
declare
    v_has_session boolean;
begin

    p_email := normalize_email(p_email);
    --=====================================================
    -- 1. CHECK IF ACTIVE SESSION EXISTS
    --=====================================================

    v_has_session := has_active_sessions(p_email);

    if not v_has_session then
        return false; -- nothing to logout
    end if;

    --=====================================================
    -- 2. CLOSE ACTIVE SESSION
    --=====================================================
	--raise notice '%', p_email;
    update login_record
    set sou_tim_log = now() -- set logout timestamp
    where ema_log = p_email
      and sou_tim_log is null
      and suc_log = true;

    --=====================================================
    -- 3. RETURN SUCCESS
    --=====================================================

    return true;

end;
$$ language plpgsql;