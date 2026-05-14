--=========================================================
-- FUNCTIONS - MODULE 4 (APPOINTMENT MANAGEMENT)
-- Contains trigger-support functions and business logic
--=========================================================

--=========================================================
-- FUNCTION 1: fn_block_overlapping_appointments
-- Prevents scheduling of overlapping appointments for the same veterinarian.
--=========================================================
create or replace function fn_block_overlapping_appointments()
returns trigger as $$
begin
    -- Check for existing appointments that overlap with the new/updated one.
    -- Assumes a fixed duration of 30 minutes for each appointment for scheduling purposes.
    if exists (
        select 1
        from appointment a
        where a.id_emp = new.id_emp -- Same veterinarian
          and a.status_app = 'Scheduled' -- Only check against other scheduled appointments
          and (tg_op = 'INSERT' or a.id_app <> new.id_app) -- Exclude self on updates only
          and (new.sch_dat_app, new.sch_dat_app + interval '30 minutes') OVERLAPS 
              (a.sch_dat_app, a.sch_dat_app + interval '30 minutes')
    ) then
        raise exception 'O veterinário já tem uma consulta sobreposta agendada.';
    end if;

    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 2: fn_block_appointment_if_vet_unavailable
-- Prevents scheduling an appointment if the assigned veterinarian
-- is marked as absent during the appointment period.
--=========================================================
create or replace function fn_block_appointment_if_vet_unavailable()
returns trigger as $$
begin
    -- Check if the veterinarian is absent during the proposed appointment time.
    -- Assumes a fixed duration of 30 minutes for the appointment.
    if exists (
        select 1
        from absence a
        where a.id_emp = new.id_emp -- Same veterinarian
          and (new.sch_dat_app, new.sch_dat_app + interval '30 minutes') OVERLAPS 
              (a.sta_dat_tim_abs, a.end_dat_tim_abs)
    ) then
        raise exception 'O veterinário está indisponível devido a uma ausência durante este período de consulta.';
    end if;

    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 3: fn_validate_prescription_timing
-- Ensures a prescription's issue date is not before the
-- associated appointment's start date.
--=========================================================
create or replace function fn_validate_prescription_timing()
returns trigger as $$
declare
    v_appointment_start_time timestamp;
begin
    select coalesce(sta_dat_app, sch_dat_app)
      into v_appointment_start_time
    from appointment
    where id_app = new.id_app;

    if v_appointment_start_time is null then
        raise exception 'Inicie a consulta primeiro.';
    end if;

    if new.reg_dat_pre < v_appointment_start_time then
        raise exception 'A data de emissão da prescrição não pode ser anterior à data de início da consulta.';
    end if;


    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 4: fn_deduct_product_stock
-- Deducts the quantity of products used in an appointment
-- from the stock. Checks for sufficient stock before deduction.
--=========================================================
create or replace function fn_deduct_product_stock()
returns trigger as $$
declare
    v_current_stock_qty int;
begin
    -- Get current stock quantity for the product
    select qty_sto into v_current_stock_qty
    from stock
    where id_pro = new.id_pro;

    -- Check if there's enough stock
    if v_current_stock_qty < new.qty_pre_pro then
        raise exception 'O produto com ID % não tem stock suficiente (Requisitou: %, Disponível: %)',
                        new.id_pro, new.qty_pre_pro, v_current_stock_qty;
    end if;

    -- Deduct stock
    update stock
    set qty_sto = qty_sto - new.qty_pre_pro
    where id_pro = new.id_pro;

    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 5: fn_block_past_appointments
-- Prevents scheduling appointments with a start date in the past.
--=========================================================
create or replace function fn_block_past_appointments()
returns trigger as $$
begin
    -- Check against the scheduled date, not the start date
    if new.sch_dat_app < current_timestamp then
        raise exception 'A data de início da consulta não pode ser no passado.';
    end if;
    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 6: fn_appointment_duration_check
-- Ensures the appointment duration is valid.
--=========================================================
create or replace function fn_appointment_duration_check()
returns trigger as $$
begin
    if new.end_dat_app <= new.sta_dat_app then
        raise exception 'A data de término da consulta deve ser posterior à data de início.';
    end if;
    return new;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION 7: fn_validate_appointment_vet_specialty
-- Ensures the assigned veterinarian is credentialed for the
-- consultation specialty via Module 1 expert (vet × specialty).
--=========================================================
create or replace function fn_validate_appointment_vet_specialty()
returns trigger as $$
begin
    if not exists (
        select 1
        from expert x
        where x.id_emp = new.id_emp
          and x.id_spe = new.id_spe
    ) then
        raise exception
            'O médico veterinário selecionado não está associado à especialidade indicada para esta consulta.';
    end if;

    return new;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION 8: fn_appointment_see_app_clt
-- Allows clients to see their appointments
-- Returns a table with key details of all appointments for a given client ID.
--=========================================================
create or replace function fn_appointment_see_app_clt(p_client_id int)
returns table(
    appointment_id int,
    scheduled_date timestamp,
    status appointment_status,
    vet_name varchar(250),
    animal_name varchar(100),
    specialty_id int,
    specialty_name varchar(100)
) language plpgsql
as $$
begin
    return query
    select
        a.id_app as appointment_id,
        a.sch_dat_app as scheduled_date,
        case
            when a.status_app = 'Scheduled' and a.sch_dat_app < now() then 'Late'::appointment_status
            else a.status_app
        end as status,
        ua.nam_usr as vet_name,
        an.nam_ani as animal_name,
        s.id_spe as specialty_id,
        s.nam_spe as specialty_name
    from appointment a
    join employee e on a.id_emp = e.id_emp
    join user_account ua on e.id_usr = ua.id_usr
    join animal an on a.id_animal = an.id_ani
    join specialty s on a.id_spe = s.id_spe
    where a.id_cli = p_client_id
    order by a.sta_dat_app desc nulls last, a.sch_dat_app desc;
end;
$$;

--=========================================================
-- FUNCTION 9: fn_validate_animal_client_relationship
-- Ensures that the animal being scheduled for an appointment
-- actually belongs to the client.
--=========================================================
create or replace function fn_validate_animal_client_relationship()
returns trigger as $$
begin
    if not exists (
        select 1
        from ownership o
        where o.id_ani = new.id_animal
          and o.id_cli = new.id_cli
          and o.end_dat_own is null
    ) then
        raise exception 'O animal com ID % não pertence ao cliente com ID %.', new.id_animal, new.id_cli;
    end if;

    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 10: fn_prevent_completed_appointment_modification
-- Prevents any modification to an appointment that is already
-- in a terminal state (Completed, Cancelled, No-Show).
--=========================================================
create or replace function fn_prevent_completed_appointment_modification()
returns trigger as $$
begin
    if old.status_app in ('Completed', 'Cancelled', 'No-Show') then
        raise exception 'Não é possível alterar uma consulta que já foi concluída, cancelada ou marcada como não comparência.';
    end if;
    return new;
end;
$$ language plpgsql;

--=========================================================
-- FUNCTION 12: fn_prevent_completed_appointment_modification
-- Prevents any modification to an appointment that is already
-- in a terminal state (Completed, Cancelled).
--=========================================================
create or replace function fn_prevent_completed_appointment_modification()
returns trigger as $$
begin
    if old.status_app IN ('Completed', 'Cancelled') then
        raise exception 'Não é possível modificar uma consulta finalizada';
    end if;
    return new;
end;
$$ language plpgsql;
