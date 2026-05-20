-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
-- =========================================================
-- FILE: 05_Procedures_Mod2.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Stored procedures encapsulating animal intake, adoption, delivery,
-- concession, and ownership lifecycle transitions.
--
-- This file contains:
-- - Animal registration and status transitions
-- - Ownership begin/end flows
-- - Delivery capture with optional employee linkage
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 2 tables, triggers, and validation functions online
--
-- Must load before:
-- - Application layers calling these entry points
-- =========================================================

-- =========================================================
-- Inserts a new animal catalog row with species/breed linkage
-- =========================================================

create or replace procedure sp_register_animal( p_reg_id_ani varchar, p_nam_ani varchar, p_dat_bir_ani date, p_gen_ani char, p_ori_ani varchar, p_sta_ani varchar, p_id_spc int, p_id_bre int default null ) language plpgsql as $$ begin
insert into animal (
    reg_id_ani,
    nam_ani,
    dat_bir_ani,
    gen_ani,
    ori_ani,
    sta_ani,
    id_spc,
    id_bre
)
values
    (
        p_reg_id_ani,
        p_nam_ani,
        p_dat_bir_ani,
        p_gen_ani,
        p_ori_ani,
        p_sta_ani,
        p_id_spc,
        p_id_bre
    );
end;
$$;

-- =========================================================
-- Creates ownership and marks the animal as adopted
-- =========================================================

create or replace procedure sp_assign_ownership( p_id_ani int, p_id_cli int, p_id_emp int, p_mot_own varchar ) language plpgsql as $$
declare
    v_animal_status varchar;
begin
    -- 1. Check if the animal is available for adoption and lock the row
    select
        sta_ani into v_animal_status
    from
        animal
    where
        id_ani = p_id_ani for update;

    if not found then
        raise exception 'Animal com ID % não encontrado.', p_id_ani;
    end if;

    if v_animal_status <> 'Interno' then
        raise exception 'Animal com ID % não está disponível para adoção (Status: %).', p_id_ani, v_animal_status; 
    end if;

    -- 2. Create the new ownership record
    insert into
        ownership (id_cli, id_ani, id_emp, sta_dat_own, mot_own)
    values
        (p_id_cli, p_id_ani, p_id_emp, current_date, p_mot_own);

    -- 3. Update the animal's status to 'Adotado'
    update
        animal
    set
        sta_ani = 'Adotado'
    where
        id_ani = p_id_ani;

exception
    when others then
        raise exception 'Falha ao atribuir posse ao animal %: %', p_id_ani, sqlerrm;
end;
$$;

-- =========================================================
-- Closes the open ownership interval and returns animal to internal status
-- =========================================================

create or replace procedure sp_end_ownership(p_id_ani int, p_mot_own varchar) language plpgsql as $$
declare
    v_ownership_id int;
begin
    -- 1. Find the active ownership record for the animal
    select
        id_own into v_ownership_id
    from
        ownership
    where
        id_ani = p_id_ani
        and end_dat_own is null for update;

    if v_ownership_id is null then 
        raise exception 'Nenhuma posse ativa encontrada para o animal com ID %.', p_id_ani;
    end if;

    -- 2. Update the ownership record with an end date and reason
    update
        ownership
    set
        end_dat_own = current_date, mot_own = p_mot_own
    where
        id_own = v_ownership_id;

    -- 3. Update the animal's status back to 'Interno' (available)
    update
        animal
    set
        sta_ani = 'Interno'
    where
        id_ani = p_id_ani;

exception
    when others then
        raise exception 'Falha ao terminar posse do animal %: %', p_id_ani, sqlerrm;
end;
$$;

-- =========================================================
-- Records intake/rescue metadata and reuses employee witness list
-- =========================================================

create or replace procedure sp_record_delivery( p_id_ani int, p_res_dat_del timestamp, p_res_loc_del varchar, p_cli_sta_del varchar, p_id_ext_ent int, p_employee_ids int[] ) language plpgsql as $$
declare
    v_id_del int;
    v_emp_id int;
begin
    -- 1. Lock animal row for the duration of the workflow
    perform 1
    from animal
    where id_ani = p_id_ani
    for update;

    if not found then
        raise exception 'Animal com ID % não existe. Registe o animal primeiro.', p_id_ani;
    end if;
-- 2. Create the delivery record
insert into
    delivery (
        reg_dat_del, res_dat_del, del_dat_del, res_loc_del, cli_sta_del, id_ext_ent, id_ani
    )
values
    (
        now(),
        p_res_dat_del,
        now(),
-- Delivery date is when it arrives at the clinic
        p_res_loc_del,
        p_cli_sta_del,
        p_id_ext_ent,
        p_id_ani
    ) returning id_del into v_id_del;
-- 3. Associate employees with the delivery
if p_employee_ids is not null then foreach v_emp_id in array p_employee_ids loop
insert into
    delivery_employee (id_del, id_emp)
values
    (v_id_del, v_emp_id);
end loop;
end if;
-- 4. Ensure animal status is 'Interno'
update
    animal
set
    sta_ani = 'Interno'
where
    id_ani = p_id_ani;

exception
    when others then
        raise exception 'Falha ao registar entrega do animal %: %', p_id_ani, sqlerrm;
end;
$$;

-- =========================================================
-- Transfers animals to external entities when not adopted
-- =========================================================

create or replace procedure sp_process_concession( p_id_ani int, p_id_ext_ent int, p_id_emp int, p_mot_con varchar, p_cli_sta_con varchar ) language plpgsql as $$
declare
    v_animal_status varchar;
begin
    -- 1. Check animal status and lock the row
    select
        sta_ani into v_animal_status
    from
        animal
    where
        id_ani = p_id_ani for update;

    if not found then
        raise exception 'Animal com ID % não encontrado.', p_id_ani;
    end if;

    if v_animal_status = 'Adotado' then
        raise exception 'Animal com ID % está atualmente adotado e não pode ser transferido.', p_id_ani;
    end if;

    -- 2. Create the concession record
    insert into
        concession (
            dat_con, mot_con, cli_sta_con, id_ext_ent, id_emp, id_ani
        )
    values
        (
            current_date,
            p_mot_con,
            p_cli_sta_con,
            p_id_ext_ent,
            p_id_emp,
            p_id_ani
        );

    -- 3. Update animal status to 'Transferido'
    update
        animal
    set
        sta_ani = 'Transferido'
    where
        id_ani = p_id_ani;

exception
    when others then
        raise exception 'Falha ao processar concessão do animal %: %', p_id_ani, sqlerrm;
end;
$$;
