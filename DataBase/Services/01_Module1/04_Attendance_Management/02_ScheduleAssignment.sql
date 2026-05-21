-- =========================================================
-- MODULE 1 — ATTENDANCE MANAGEMENT
-- FILE: 02_ScheduleAssignment.sql
-- =========================================================
--
-- FUNCTION: fn_replicate_previous_schedule
-- Copies schedule rows from the latest inactive employee record
-- that had schedules, onto the target active employee.
-- =========================================================

create or replace function fn_replicate_previous_schedule ( 
    p_id_emp int
)
returns void
language plpgsql
as
$$
declare
    v_source_emp int;
begin

    if not exists (
        select 1
        from vw_active_employee_directory d
        where d.id_emp = p_id_emp
    ) then
        raise exception
            'Employee % does not exist or is inactive.',
            p_id_emp;
    end if;

    if exists (
        select 1
        from schedule s
        where s.id_emp = p_id_emp
    ) then
        raise exception
            'Employee % already has an associated schedule.',
            p_id_emp;
    end if;

    select e.id_emp
    into v_source_emp
    from employee e
    where e.dea_dat_emp is not null
      and exists (
            select 1
            from schedule s
            where s.id_emp = e.id_emp
      )
    order by e.dea_dat_emp desc
    limit 1;

    if v_source_emp is null then
        raise exception
            'No inactive employee with associated schedule found.';
    end if;

    insert into schedule (
        id_emp,
        day_wee_sch,
        sta_tim_sch,
        fin_hou_sch
    )
    select
        p_id_emp,
        s.day_wee_sch,
        s.sta_tim_sch,
        s.fin_hou_sch
    from schedule s
    where s.id_emp = v_source_emp;

end;
$$;
