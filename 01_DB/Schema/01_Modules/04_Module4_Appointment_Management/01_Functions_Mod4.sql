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
    -- Check for existing appointments that overlap with the new/updated one
    if exists (
        select 1
        from appointment a
        where a.id_emp = new.id_emp -- Same veterinarian
          and a.id_app != new.id_app -- Exclude the current appointment itself during updates
          and (
                (new.sta_dat_app, new.end_dat_app) OVERLAPS (a.sta_dat_app, a.end_dat_app)
              )
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
    -- Check if the veterinarian is absent during the proposed appointment time
    if exists (
        select 1
        from absence a
        where a.id_emp = new.id_emp -- Same veterinarian
          and (new.sta_dat_app, new.end_dat_app) OVERLAPS (a.sta_dat_tim_abs, a.end_dat_tim_abs)
    ) then
        raise exception 'O veterinário está indisponível devido a uma ausência durante este período de consulta.';
    end if;

    -- Optionally, you could also check for clock-in status if it's a strict requirement
    -- For example, if an employee *must* be clocked in to have an appointment.
    -- This would depend on business rules. For now, we focus on explicit absences.

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
    select sta_dat_app into v_appointment_start_time
    from appointment
    where id_app = new.id_app;

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
    if new.sta_dat_app < current_timestamp then
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
-- FUNCTION 7: fn_appointment_warning_next_day
-- Generates a warning message for clients who have an appointment the next day.
--=========================================================
create or replace function fn_appointment_warning_next_day()
returns void as $$ -- Alterado para retornar VOID, pois será um job, não um trigger
declare
    consulta record;
    v_aviso text;
begin
    for consulta in (
        select
            a.id_cli, -- Precisamos do ID do cliente para a nova tabela
            c.nam_usr as nome_cliente,
            e.nam_emp as nome_veterinario,
            an.nam_ani as nome_animal
        from appointment a
        join client c on a.id_cli = c.id_cli
        join animal an on a.id_animal = an.id_ani
        join employee e on a.id_emp = e.id_emp
        where a.sta_dat_app::date = current_date + interval '1 day'
    ) loop
        v_aviso := format('Bom dia %s, amanhã tem consulta com o veterinário %s para o seu animal %s.',
                         consulta.nome_cliente, consulta.nome_veterinario, consulta.nome_animal);
        insert into client_notification (id_cli, message) values (consulta.id_cli, v_aviso);
    end loop;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION 8: fn_appointment_see_app_clt
-- Allows clients to see their appointments
--=========================================================
CREATE FUNCTION fn_appointment_see_app_clt(clt_id int)
 RETURNS table(
    id_app int,
    sch_dat_app timestamp,
    nam_usr varchar(100)
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  select ap.id_app, ap.sch_dat_app, uac.nam_usr 
  from appointment ap 
  inner join animal an on ap.id_app = an.id_app
  inner join user_account uac on uac. = an.id_app
  inner join client cl on ap.id_app = an.id_app
  WHERE ap.id_cli = clt_id

  EXCEPTION NOT FOUND then
    RAISE EXCEPTION 'Cliente não encontrado'
EXCEPTION IF OTHERS THEN
    RAISE 'Erro: %', SQLERRM



