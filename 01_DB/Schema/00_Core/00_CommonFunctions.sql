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