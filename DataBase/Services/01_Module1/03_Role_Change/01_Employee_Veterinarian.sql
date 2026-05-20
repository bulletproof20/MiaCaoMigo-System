-- Role change (Employee -> Veterinarian)

--if id_emp not exists
--    trow excepcion

--if the id_usr have any id_emp active
--   if the id_emp is already a veterinarian
--      trow exception
--   try inativate the existing id_emp (set dat_end_emp to current date)

--try create a new id_emp (replicate the data of the old one but with a new id_emp)
--try create a new veterinarian with the new id_emp
--return ok       

drop function if exists fn_alter_employee_to_veterinarian(
    int, varchar, int
);

create or replace function fn_alter_employee_to_veterinarian(

    p_id_usr int,

    p_num_omv_vet varchar,

    p_id_emp_reg int

)
returns int as $$

declare

    v_id_emp_old int;
    v_id_emp_new int;

begin



    -- get the active employee account for the user
    v_id_emp_old := fn_get_active_employee_by_user(p_id_usr);

    if v_id_emp_old is null then
        raise exception using
            message = 'No active employee account found for user id: ' || p_id_usr;
    end if;
    -- check if already a veterinarian
    if fn_is_veterinarian(v_id_emp_old) then
        raise exception using
            message = 'Employee account with id ' || v_id_emp_old || ' is already a veterinarian.';
    end if;

    -- replace the employee record (inactivate old, create new active)
    v_id_emp_new := fn_renew_employee_record(v_id_emp_old, p_id_emp_reg);

    -- create the veterinarian record for the new employee
    insert into veterinarian (id_emp, num_omv_vet)
    values (v_id_emp_new, p_num_omv_vet);

    -- return the new employee id
    return v_id_emp_new;

exception
    when unique_violation then
        raise exception using
            message = 'Veterinarian record already exists for this employee.',
            detail = sqlerrm,
            errcode = sqlstate;

    when foreign_key_violation then
        raise exception using
            message = 'Invalid employee association while creating veterinarian.',
            detail = sqlerrm,
            errcode = sqlstate;

    when others then
        raise exception using
            message = 'Unexpected error while converting employee to veterinarian.',
            detail = sqlerrm,
            errcode = sqlstate;

end;
$$ language plpgsql;