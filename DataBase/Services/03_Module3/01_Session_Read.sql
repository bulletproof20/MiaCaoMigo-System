-- =========================================================
-- SESSION READ (MODULE 3 — COMMERCIAL)
-- FILE: Services/03_Module3/01_Session_Read.sql
-- =========================================================
-- PURPOSE:   Login session queries (active sessions, last login audit)
-- DOMAIN:    Module 3 — Commercial (reads Module 1 login_record)
-- LOADED BY: Bootstrap/Loaders/06_Services.sql
-- CLEANUP:   drop function if exists before create
-- =========================================================
-- Credential hash lookup: see 01_Module1/01_Authentication/03_Credentials_Read.sql
-- =========================================================

drop function if exists is_user_logged_in(int);

create or replace function is_user_logged_in(p_id_usr int)
returns boolean
language sql
stable
as $$
    select exists (
        select 1
        from login_record lr
        where lr.id_usr = p_id_usr
          and lr.sou_tim_log is null
          and lr.suc_log = true
    );
$$;


drop function if exists get_active_sessions();

create or replace function get_active_sessions()
returns table(
    id_usr int,
    name varchar,
    login_time timestamp,
    ip inet
)
language sql
stable
as $$
    select
        lr.id_usr,
        u.nam_usr,
        lr.sig_tim_log,
        lr.ip_add_log
    from login_record lr
    inner join user_account u on u.id_usr = lr.id_usr
    where lr.sou_tim_log is null
      and lr.suc_log = true
    order by lr.sig_tim_log desc;
$$;


drop function if exists get_last_login(int);

create or replace function get_last_login(p_id_usr int)
returns setof login_record
language sql
stable
as $$
    select lr.*
    from login_record lr
    where lr.id_usr = p_id_usr
    order by lr.sig_tim_log desc
    limit 1;
$$;


drop function if exists get_last_successful_login(int);

create or replace function get_last_successful_login(p_id_usr int)
returns setof login_record
language sql
stable
as $$
    select lr.*
    from login_record lr
    where lr.id_usr = p_id_usr
      and lr.suc_log = true
    order by lr.sig_tim_log desc
    limit 1;
$$;


drop function if exists get_last_failed_login(int);

create or replace function get_last_failed_login(p_id_usr int)
returns setof login_record
language sql
stable
as $$
    select lr.*
    from login_record lr
    where lr.id_usr = p_id_usr
      and lr.suc_log = false
    order by lr.sig_tim_log desc
    limit 1;
$$;
