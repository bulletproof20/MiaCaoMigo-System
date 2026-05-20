-- =========================================================
-- MODULE 1 — ROLE CHANGE
-- FILE: 03_To_Employee.sql
-- =========================================================
--
-- FUNCTION: fn_alter_employee_to_general
-- Demotes veterinarian or assistant to a general employee row
-- by renewing the employment record (no role extension insert).
-- Depends on: fn_renew_employee_record, fn_is_veterinarian,
--             fn_is_assistant, fn_get_active_employee_by_user.
-- =========================================================

drop function if exists fn_alter_employee_to_general(int, int);

create or replace function fn_alter_employee_to_general(
    p_id_usr int,
    p_id_emp_reg int
)
returns int as $$

declare
    v_id_emp_old int;
    v_id_emp_new int;

begin

    v_id_emp_old := fn_get_active_employee_by_user(p_id_usr);

    if v_id_emp_old is null then
        raise exception using
            message = 'No active employee account found for user id: ' || p_id_usr;
    end if;

    if not fn_is_veterinarian(v_id_emp_old)
       and not fn_is_assistant(v_id_emp_old) then
        raise exception using
            message = 'Employee account with id ' || v_id_emp_old ||
                      ' is already a general employee.';
    end if;

    v_id_emp_new := fn_renew_employee_record(v_id_emp_old, p_id_emp_reg);

    return v_id_emp_new;

end;

$$ language plpgsql;
