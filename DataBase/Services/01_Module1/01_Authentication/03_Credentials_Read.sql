-- =========================================================
-- CREDENTIAL READ (MODULE 1 — AUTHENTICATION)
-- FILE: Services/01_Module1/01_Authentication/03_Credentials_Read.sql
-- =========================================================
-- PURPOSE:   Read-only access to stored email + password hash by user id
-- DOMAIN:    Module 1 — User Management
-- LOADED BY: Bootstrap/Loaders/06_Services.sql (after login helpers)
-- CLEANUP:   drop function if exists before create
-- =========================================================
-- Integration helper only — production APIs should not expose hashes.
-- =========================================================

drop function if exists get_user_credentials(int); 

-- --- get_user_credentials ---
-- PURPOSE: resolve active employee or client channel for a user id
-- BEHAVIOUR: employee row wins when both exist; returns hash column as pass_hash

create or replace function get_user_credentials(p_id_usr int)
returns table(
    id_usr int,
    email varchar,
    pass_hash varchar,
    role text
)
language sql
stable
as $$
    -- active employee channel (preferred when present)
    select
        e.id_usr,
        e.ema_emp,
        e.pas_emp,
        'employee'::text
    from employee e
    where e.id_usr = p_id_usr
      and e.dea_dat_emp is null
    union all
    -- client channel when no active employee shares the user id
    select
        u.id_usr,
        u.ema_usr,
        c.pas_cli,
        'client'::text
    from client c
    inner join user_account u on u.id_usr = c.id_usr
    where c.id_usr = p_id_usr
      and c.ina_dat_cli is null
      and not exists (
          select 1
          from employee e2
          where e2.id_usr = p_id_usr
            and e2.dea_dat_emp is null
      );
$$;
