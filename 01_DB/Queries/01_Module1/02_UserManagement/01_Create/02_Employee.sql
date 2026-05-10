drop function if exists fn_create_employee(
    varchar, text, varchar, varchar, varchar, varchar,
    varchar, varchar, varchar,
    int
);

create or replace function fn_create_employee(

    p_nam_usr varchar,
    p_add_usr text,
    p_pos_usr varchar,
    p_nif_usr varchar,
    p_pho_usr varchar,
    p_ema_usr varchar,

    p_pho_emp varchar,
    p_pho_emg varchar,
    p_pas_emp varchar,

    p_id_emp_reg int

)
returns int as $$

declare

    v_id_usr int;
    v_id_emp int;

    v_ema_emp varchar;

    v_id_usr_by_nif int;
    v_id_usr_by_email int;

begin

    -- normalize identity data
    p_nif_usr := trim(p_nif_usr);

    p_ema_usr := normalize_email(p_ema_usr);

    -- validate registering employee
    if not exists (

        select 1
        from employee e
        where e.id_emp = p_id_emp_reg
          and e.dea_dat_emp is null

    ) then

        raise exception using
            message = 'Registering employee is invalid or inactive.';

    end if;

    -- retrieve existing shared identity
    v_id_usr_by_nif := fn_get_user_by_nif(p_nif_usr);

    v_id_usr_by_email := get_user_by_email(p_ema_usr);

    -- validate identity consistency
    if v_id_usr_by_nif is distinct from v_id_usr_by_email then

        raise exception using
            message = 'NIF and email belong to different identities.';

    end if;

    -- resolve existing identity
    v_id_usr := v_id_usr_by_nif;

    -- prevent duplicated employee accounts
    if v_id_usr is not null
    and exists (

        select 1
        from employee e
        where e.id_usr = v_id_usr

    ) then

        raise exception using
            message = 'User already has an employee account.';

    end if;

    -- create shared identity if necessary
    if v_id_usr is null then

        -- create base user identity
        v_id_usr := fn_create_user_account(

            p_nam_usr,
            p_add_usr,
            p_pos_usr,
            p_nif_usr,
            p_pho_usr,
            p_ema_usr

        );

    end if;

    -- generate corporate email
    v_ema_emp := v_id_usr || '@miacaomigo.pt';

    -- create employee account
    insert into employee (

        id_usr,
        pho_emp,
        pho_emg,
        ema_emp,
        pas_emp,
        reg_dat_emp,
        aut_reg_emp

    )
    values (

        v_id_usr,
        trim(p_pho_emp),
        trim(p_pho_emg),
        v_ema_emp,
        trim(p_pas_emp),
        current_timestamp,
        p_id_emp_reg

    )

    returning id_emp
    into v_id_emp;

    -- return created employee
    return v_id_emp;

exception

    when check_violation then

        raise exception using

            message = 'Employee data validation failed.',
            detail = sqlerrm,
            errcode = sqlstate;

    when foreign_key_violation then

        raise exception using

            message = 'Invalid employee association.',
            detail = sqlerrm,
            errcode = sqlstate;

    when unique_violation then

        raise exception using

            message = 'Employee account already exists.',
            detail = sqlerrm,
            errcode = sqlstate;

    when others then

        raise exception using

            message = 'Unexpected error while creating employee account.',
            detail = sqlerrm,
            errcode = sqlstate;

end;

$$ language plpgsql;