--=========================================================

-- function: fn_register_adoption

--=========================================================

-- description:

-- registers a new animal adoption (ownership relation).

--

-- purpose:

-- - validates if the animal is available for adoption

-- - creates the record in the ownership table

-- - triggers automatic status update via 'trg_animal_adotado'

--=========================================================

drop function if exists fn_register_adoption(int, int, int, varchar);



create function fn_register_adoption(

    p_id_cli int,

    p_id_ani int,

    p_id_emp int,

    p_motive varchar

) returns void as $$

begin



    --=====================================================

    -- 1. VALIDATE ANIMAL AVAILABILITY

    --=====================================================



    if exists (

        select 1

        from animal

        where id_ani = p_id_ani

          and sta_ani in ('Adotado', 'Falecido')

    ) then

        raise exception 'Animal with ID % is not available (Status: %).',

            p_id_ani, (select sta_ani from animal where id_ani = p_id_ani);

    end if;



    --=====================================================

    -- 2. CREATE OWNERSHIP RECORD

    --=====================================================



    insert into ownership (id_cli, id_ani, id_emp, mot_own, sta_dat_own)

    values (p_id_cli, p_id_ani, p_id_emp, p_motive, current_date);



end;

$$ language plpgsql;



--=========================================================

-- function: fn_register_delivery_team

--=========================================================

-- description:

-- registers an animal rescue/delivery involving multiple employees.

--

-- purpose:

-- - centralizes delivery and team association

-- - handles the many-to-many relation (delivery_employee)

-- - ensures correct status update to 'Interno'

--=========================================================

drop function if exists fn_register_delivery_team(int, int, varchar, varchar, int[]);



create function fn_register_delivery_team(

    p_id_ani int,

    p_id_ext int,

    p_location varchar,

    p_status_clinic varchar,

    p_emp_ids int[]

) returns void as $$

declare

    v_id_del int;

    v_emp_id int;

begin



    --=====================================================

    -- 1. CREATE DELIVERY RECORD

    --=====================================================



    insert into delivery (id_ani, id_ext_ent, res_loc_del, cli_sta_del, res_dat_del)

    values (p_id_ani, p_id_ext, p_location, p_status_clinic, current_timestamp)

    returning id_del into v_id_del;



    --=====================================================

    -- 2. ASSOCIATE TEAM MEMBERS

    --=====================================================



    foreach v_emp_id in array p_emp_ids loop

        insert into delivery_employee (id_del, id_emp)

        values (v_id_del, v_emp_id);

    end loop;



    --=====================================================

    -- 3. UPDATE ANIMAL STATUS

    --=====================================================

   

    update animal

    set sta_ani = 'Interno'

    where id_ani = p_id_ani;



end;

$$ language plpgsql;



--=========================================================

-- function: fn_animal_exit

--=========================================================

-- description:

-- processes a definitive exit of an animal from the clinic.

--

-- purpose:

-- - updates animal status (e.g., 'Falecido')

-- - terminates any active ownership records

--=========================================================

drop function if exists fn_animal_exit(int, varchar);



create function fn_animal_exit(

    p_id_ani int,

    p_reason varchar

) returns void as $$

begin



    --=====================================================

    -- 1. UPDATE ANIMAL STATUS

    --=====================================================



    update animal

    set sta_ani = p_reason

    where id_ani = p_id_ani;



    --=====================================================

    -- 2. TERMINATE ACTIVE OWNERSHIP

    --=====================================================



    update ownership

    set end_dat_own = current_date

    where id_ani = p_id_ani

      and end_dat_own is null;



end;

$$ language plpgsql;



--=========================================================

-- function: fn_get_animal_history

--=========================================================

-- description:

-- retrieves the chronological history of an animal.

--

-- purpose:

-- - merges records from ownership and concession

-- - provides a audit trail for the animal

--=========================================================

drop function if exists fn_get_animal_history(int);



create function fn_get_animal_history(p_id_ani int)

returns table(event_date date, description text) as $$

begin



    --=====================================================

    -- 1. RETRIEVE MERGED HISTORY

    --=====================================================



    return query

    select sta_dat_own, 'Adotado por Cliente ID: ' || id_cli::text

    from ownership

    where id_ani = p_id_ani

   

    union all

   

    select dat_con, 'Cedido para Entidade ID: ' || id_ext_ent::text

    from concession

    where id_ani = p_id_ani

   

    order by 1 desc;



end;

$$ language plpgsql;