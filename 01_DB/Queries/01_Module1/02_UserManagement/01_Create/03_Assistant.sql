--=========================================================
-- FUNCTION: FN_CREATE_ASSISTANT
--=========================================================
-- Purpose:
-- Creates a complete assistant account by:
-- - creating the employee identity
-- - assigning the assistant role
--
-- Flow:
-- 1. Create employee account through fn_create_employee
-- 2. Prevent veterinarian role conflicts
-- 3. Create assistant role
--
-- Notes:
-- - Assistant and veterinarian roles are mutually exclusive
-- - Employee creation and role assignment occur in one flow
-- - Corporate email is generated automatically
--=========================================================

drop function if exists fn_create_assistant(
    varchar, text, varchar, varchar, varchar, varchar,
    varchar, varchar, varchar,
    int,
    varchar
);

create or replace function fn_create_assistant(

    p_nam_usr varchar,
    p_add_usr text,
    p_pos_usr varchar,
    p_nif_usr varchar,
    p_pho_usr varchar,
    p_ema_usr varchar,

    p_pho_emp varchar,
    p_pho_emg varchar,
    p_pas_emp varchar,

    p_id_emp_reg int,

    p_fun_ass varchar

)
returns int as $$

declare

    v_id_emp int;

begin

    -- create employee account
    v_id_emp := fn_create_employee(

        p_nam_usr,
        p_add_usr,
        p_pos_usr,
        p_nif_usr,
        p_pho_usr,
        p_ema_usr,

        p_pho_emp,
        p_pho_emg,
        p_pas_emp,

        p_id_emp_reg

    );

    -- prevent veterinarian role conflict
    if exists (

        select 1
        from veterinarian as v
        where v.id_emp = v_id_emp

    ) then

        raise exception using
            message = 'Employee already has a veterinarian role.';

    end if;

    -- create assistant role
    insert into assistant (

        id_emp,
        fun_ass

    )
    values (

        v_id_emp,
        trim(p_fun_ass)

    );

    -- return assistant employee id
    return v_id_emp;

exception

    when check_violation then

        raise exception using

            message = 'Assistant data validation failed.',
            detail = sqlerrm,
            errcode = sqlstate;

    when foreign_key_violation then

        raise exception using

            message = 'Invalid employee association.',
            detail = sqlerrm,
            errcode = sqlstate;

    when unique_violation then

        raise exception using

            message = 'Assistant role already exists.',
            detail = sqlerrm,
            errcode = sqlstate;

    when others then

        raise exception using

            message = 'Unexpected error while creating assistant account.',
            detail = sqlerrm,
            errcode = sqlstate;

end;

$$ language plpgsql;