--=========================================================
-- function: login_user
--=========================================================
-- description:
-- validates login attempts based on:
-- - existing account
-- - valid password
-- - active account
-- - no active sessions
--
-- behavior:
-- - all attempts are registered in login_record
-- - only one active session allowed per user
--=========================================================

create or replace function login_user(
    p_email varchar,
    p_password varchar,
    p_ip inet
)
returns table (
    email varchar,
    password_ok boolean,
    account_active boolean,
    has_active_session boolean,
    user_id integer,
    login_success boolean
) as $$

declare

    v_user_id integer;
    v_password_ok boolean;
    v_account_active boolean;
    v_has_session boolean;
    v_login_success boolean;

begin

    --=====================================================
    -- 1. NORMALIZE EMAIL
    --=====================================================

    p_email := normalize_email(p_email);

    --=====================================================
    -- 2. VALIDATE USER EXISTENCE
    --=====================================================

    if not fn_user_exists_by_email(p_email) then

        -- register failed attempt
        insert into login_record (
            sig_tim_log, suc_log, ip_add_log, ema_log
        )
        values (
            now(), false, p_ip, p_email
        );

        -- return failed result
        return query
        select
            null::varchar,
            false::boolean,
            false::boolean,
            false::boolean,
            null::integer,
            false::boolean;

        return;

    end if;

    --=====================================================
    -- 3. VALIDATE PASSWORD
    --=====================================================

    v_password_ok := validate_password(
        p_email,
        p_password
    );

    if not v_password_ok then

        -- register failed password attempt
        insert into login_record (
            sig_tim_log, suc_log, ip_add_log, ema_log
        )
        values (
            now(), false, p_ip, p_email
        );

        -- return failed result
        return query
        select
            p_email::varchar,
            false::boolean,
            false::boolean,
            false::boolean,
            null::integer,
            false::boolean;

        return;

    end if;

    --=====================================================
    -- 4. VALIDATE ACCOUNT STATUS
    --=====================================================

    v_account_active := fn_is_account_active(
        p_email
    );

    -- retrieve associated user
    v_user_id := fn_get_user_by_email(
        p_email
    );

    if not v_account_active then

        -- register inactive account attempt
        insert into login_record (
            sig_tim_log,
            suc_log,
            ip_add_log,
            ema_log,
            id_usr
        )
        values (
            now(),
            false,
            p_ip,
            p_email,
            v_user_id
        );

        -- return inactive account result
        return query
        select
            p_email::varchar,
            true::boolean,
            false::boolean,
            false::boolean,
            v_user_id::integer,
            false::boolean;

        return;

    end if;

    --=====================================================
    -- 5. VALIDATE ACTIVE SESSION
    --=====================================================

    v_has_session := has_active_sessions(
        p_email
    );

    -- login only succeeds without active session
    v_login_success := not v_has_session;

    --=====================================================
    -- 6. REGISTER LOGIN ATTEMPT
    --=====================================================

    insert into login_record (
        sig_tim_log,
        suc_log,
        ip_add_log,
        ema_log,
        id_usr
    )
    values (
        now(),
        v_login_success,
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
        true::boolean,
        v_has_session::boolean,
        v_user_id::integer,
        v_login_success::boolean;

end;

$$ language plpgsql;