-- =========================================================
-- MODULE 3 — COMMERCIAL / SESSION READ (SERVICES)
-- FILE: 01_Session_Read.sql
-- =========================================================
--
-- Session and credential helpers aligned with login_record.id_usr
-- (no legacy performs table). Depends on: normalize_email,
-- fn_get_user_by_email, fn_is_employee_email (Module 1).
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


drop function if exists get_user_credentials(int);

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
    select
        e.id_usr,
        e.ema_emp,
        e.pas_emp,
        'employee'::text
    from employee e
    where e.id_usr = p_id_usr
      and e.dea_dat_emp is null
    union all
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
