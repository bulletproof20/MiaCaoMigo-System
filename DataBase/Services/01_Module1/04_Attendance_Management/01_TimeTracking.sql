-- =========================================================
-- MODULE 1 — ATTENDANCE MANAGEMENT
-- FILE: 01_TimeTracking.sql
-- =========================================================
--
-- FUNCTION: fn_clock_employee
-- Toggles clock-in / clock-out for an active employee.
-- Uses vw_open_clock_in_sessions for open session lookup.
-- =========================================================

create or replace function fn_clock_employee (
    p_id_emp int
)
returns varchar(50)
language plpgsql
as
$$
declare
    v_id_clk int;
begin

    if not exists (
        select 1
        from vw_active_employee_directory d 
        where d.id_emp = p_id_emp
    ) then
        raise exception 'Employee % does not exist or is inactive.', p_id_emp;
    end if;

    select s.id_clk
    into v_id_clk
    from vw_open_clock_in_sessions s
    where s.id_emp = p_id_emp
    order by s.sta_dat_clk desc
    limit 1;

    if v_id_clk is not null then

        update clock_in
        set end_dat_clk = current_timestamp
        where id_clk = v_id_clk;

        return 'CLOCK_OUT';

    end if;

    insert into clock_in (id_emp, sta_dat_clk)
    values (p_id_emp, current_timestamp);

    return 'CLOCK_IN';

end;
$$;
