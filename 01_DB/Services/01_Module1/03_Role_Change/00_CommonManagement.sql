--=========================================================
-- FUNCTION: FN_REPLACE_EMPLOYEE_RECORD
--=========================================================
-- Purpose:
-- Replaces the latest employee record of a user by:
--   1. Inactivating the current/latest record (if active)
--   2. Creating a new active record with duplicated data
--
-- Rules:
-- - A user may have multiple employee records over time
-- - Only one employee record may be active simultaneously
-- - Only the most recent employee record may be replaced
--=========================================================

drop function if exists fn_renew_employee_record(
    int,
    int
);

create or replace function fn_renew_employee_record(
    p_id_emp int,
    p_id_emp_reg int
)
returns int as $$

declare

    v_id_usr int;
    v_is_active boolean;

    v_id_emp_most_recent int;
    v_id_emp_new int;

begin

    --=====================================================
    -- Validate registering employee
    --=====================================================

    if not exists (
        select 1
        from employee e
        where e.id_emp = p_id_emp_reg
          and e.dea_dat_emp is null
    ) then
        raise exception using
            message = 'Registering employee is invalid or inactive.';
    end if;

    --=====================================================
    -- Retrieve target employee and lock row
    --=====================================================

    select
        e.id_usr,
        e.dea_dat_emp is null
    into
        v_id_usr,
        v_is_active
    from employee e
    where e.id_emp = p_id_emp
    for update;

    if v_id_usr is null then
        raise exception using
            message = 'Employee record not found for id ' || p_id_emp;
    end if;

    --=====================================================
    -- Validate that target record is the most recent
    --=====================================================

    select e.id_emp
    into v_id_emp_most_recent
    from employee e
    where e.id_usr = v_id_usr
    order by
        case
            when e.dea_dat_emp is null then 1
            else 0
        end desc,

        e.dea_dat_emp desc nulls first,
        e.reg_dat_emp desc

    limit 1;

    if v_id_emp_most_recent <> p_id_emp then
        raise exception using
            message =
                'Employee id ' || p_id_emp ||
                ' is not the most recent record for user id ' || v_id_usr;
    end if;

    --=====================================================
    -- Inactivate current record if active
    --=====================================================

    if v_is_active then

        update employee
        set
            dea_dat_emp = current_timestamp,
            aut_ina_emp = p_id_emp_reg
        where id_emp = p_id_emp;

    else

        raise notice
            'Employee id % is already inactive; replacement will continue.',
            p_id_emp;

    end if;

    --=====================================================
    -- Create new employee record
    --=====================================================

    insert into employee (
        id_usr,
        pho_emp,
        pho_emg,
        ema_emp,
        pas_emp,
        reg_dat_emp,
        aut_reg_emp
    )

    select
        e.id_usr,
        e.pho_emp,
        e.pho_emg,
        e.ema_emp,
        e.pas_emp,
        current_timestamp,
        p_id_emp_reg

    from employee e
    where e.id_emp = p_id_emp

    returning id_emp
    into v_id_emp_new;

    --=====================================================
    -- Return new employee id
    --=====================================================

    return v_id_emp_new;

exception

    when others then

        raise exception using
            message =
                'fn_replace_employee_record failed: ' || sqlerrm,
            errcode = sqlstate;

end;

$$ language plpgsql;