-- =========================================================
-- VALIDATIONS (MODULE 1 — CORE)
-- FILE: Services/01_Module1/00_Core_Mod1/02_Validations.sql
-- =========================================================
-- PURPOSE:   Account and password hash checks for auth flows
-- DOMAIN:    Module 1 — User Management
-- LOADED BY: Bootstrap/Loaders/06_Services.sql (before authentication)
-- See:       ../../../PASSWORD_AUTH.md
-- =========================================================

-- --- fn_is_account_active ---
-- PURPOSE: true when email maps to an active employee or client row

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


-- --- validate_password ---
-- PURPOSE: compare stored hash (pas_emp / pas_cli) with API-supplied hash string
-- NOTE: p_password parameter carries the bcrypt hash from the API, not plaintext

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

    -- compares stored hash with API-supplied hash (equality; no hashing in DB)
    return v_password_db = p_password;

end;
$$ language plpgsql;