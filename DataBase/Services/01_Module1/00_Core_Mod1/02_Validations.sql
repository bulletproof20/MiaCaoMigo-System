create or replace function fn_is_account_active(
    p_email varchar
)
returns boolean as $$

begin

    p_email := normalize_email(p_email);

    -- active employee
    if fn_is_employee_email(p_email) then

        return exists (

            select 1
            from employee e
            where e.ema_emp = p_email
              and e.dea_dat_emp is null

        );

    end if;

    -- active client
    return exists (

        select 1
        from client c
        join user_account u
            on u.id_usr = c.id_usr
        where u.ema_usr = p_email
          and c.ina_dat_cli is null

    );

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

    if fn_is_employee_email(p_email) then

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