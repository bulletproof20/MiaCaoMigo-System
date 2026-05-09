--=========================================================
-- PROCEDURE: prc_auto_update_no_show_appointments
-- Automatically updates the status of past, scheduled appointments to 'No-Show'.
-- This procedure is intended to be called by a scheduled job, typically
-- running once per day after midnight.
--=========================================================
create or replace procedure prc_auto_update_no_show_appointments()
language plpgsql
as $$
begin
    -- Updates appointments that were scheduled for any time before the current moment
    -- and are still in 'Scheduled' status.
    update appointment
    set status_app = 'No-Show'
    where
        status_app = 'Scheduled'
        and sch_dat_app < now();
end;
$$;

--=========================================================
-- PROCEDURE: prc_generate_appointment_warnings
-- Generates a warning message for clients who have an appointment the next day.
-- This procedure is intended to be called by a scheduled job.
--=========================================================
create or replace procedure prc_generate_appointment_warnings()
language plpgsql
as $$
declare
    consulta record;
    v_aviso text;
begin
    for consulta in (
        select a.id_app,
               a.id_cli,
               c.nam_usr as nome_cliente,
               e.nam_emp as nome_veterinario,
               an.nam_ani as nome_animal
        from appointment a
        join user_account c on a.id_cli = c.id_usr -- Assuming client name is in user_account
        join animal an on a.id_animal = an.id_ani
        join employee e on a.id_emp = e.id_emp
        where a.sta_dat_app::date = current_date + interval '1 day' and a.status_app = 'Scheduled'
        where a.sch_dat_app::date = current_date + interval '1 day' and a.status_app = 'Scheduled'
    ) loop
        v_aviso := format('Lembrete: Bom dia %s! A sua consulta para o animal %s com o/a Dr(a). %s está marcada para amanhã.', consulta.nome_cliente, consulta.nome_animal, consulta.nome_veterinario);
        insert into appointment_notification (id_cli, message) values (consulta.id_cli, v_aviso);
        insert into appointment_notification (id_cli, id_app, message) values (consulta.id_cli, consulta.id_app, v_aviso);
    end loop;
end;
$$;

--=========================================================
-- PROCEDURE: prc_cancel_appointment
-- Cancels an appointment by setting its status to 'Cancelled'.
-- The cancellation is only allowed if done more than 24 hours
-- before the appointment's start time.
--=========================================================
create or replace procedure prc_cancel_appointment(p_app_id int)
language plpgsql
as $$
declare
    v_scheduled_time timestamp;
begin
    -- Get the scheduled time and lock the row
    select sch_dat_app into v_scheduled_time from appointment where id_app = p_app_id for update;

    if not found then
        raise exception 'Consulta com ID % não encontrada.', p_app_id;
    end if;

    -- Check if the cancellation is being made within the allowed window
    -- The cancellation must be more than 24 hours before the scheduled time.
    if v_scheduled_time <= (now() + interval '24 hours') then
        raise exception 'A consulta só pode ser cancelada com mais de 24 horas de antecedência.';
    end if;

    -- Update the status to 'Cancelled'
    update appointment set status_app = 'Cancelled' where id_app = p_app_id;
end;
$$;

--=========================================================
-- PROCEDURE: prc_reschedule_appointment
-- Updates the scheduled time (sch_dat_app) of an existing appointment.
-- The update is only allowed if done more than 24 hours
-- before the original appointment's start time.
--=========================================================
create or replace procedure prc_reschedule_appointment(
    p_app_id int,
    p_new_scheduled_time timestamp
)
language plpgsql
as $$
declare
    v_original_scheduled_time timestamp;
begin
    -- Get the original scheduled time and lock the row for update
    select sch_dat_app
    into v_original_scheduled_time
    from appointment
    where id_app = p_app_id
    for update;

    if not found then
        raise exception 'Consulta com ID % não encontrada.', p_app_id;
    end if;

    -- Check if the rescheduling is being made within the allowed window
    if v_original_scheduled_time <= (now() + interval '24 hours') then
        raise exception 'A consulta só pode ser reagendada com mais de 24 horas de antecedência.';
    end if;

    -- Perform the update. This will fire the trigger for past dates, ensuring the new slot is valid.
    -- Note: The overlap trigger should also be based on sch_dat_app if appointments have a fixed duration.
    update appointment set sch_dat_app = p_new_scheduled_time where id_app = p_app_id;
end;
$$;

--=========================================================
-- PROCEDURE: prc_create_appointment
-- Creates a new appointment in the system.
-- This procedure centralizes the logic for creating an appointment,
-- based on the initial scheduling data.
--=========================================================
create or replace procedure prc_create_appointment(
    p_id_cli int,
    p_id_animal int,
    p_id_emp int,
    p_scheduled_time timestamp
)
language plpgsql
as $$
begin
    -- Creates an appointment with a 'Scheduled' status.
    -- The sta_dat_app and end_dat_app fields are left NULL, to be filled in by the vet later.
    -- The existing triggers for validation (e.g., past dates) will be fired upon insertion.
    insert into appointment (id_cli, id_animal, id_emp, sch_dat_app, status_app)
    values (p_id_cli, p_id_animal, p_id_emp, p_scheduled_time, 'Scheduled');
end;
$$;

--=========================================================
-- PROCEDURE: prc_start_appointment
-- Marks an appointment as 'In Progress' and sets its start time.
-- To be called by the veterinarian when the consultation begins.
--=========================================================
create or replace procedure prc_start_appointment(p_app_id int)
language plpgsql
as $$
begin
    update appointment
    set
        sta_dat_app = now(),
        status_app = 'In Progress'
    where
        id_app = p_app_id
        and status_app in ('Scheduled'); -- Can start if it's scheduled 

    if not found then
        raise exception 'Não foi possível iniciar a consulta. Verifique se o ID % existe e se o estado é "Scheduled".', p_app_id;
    end if;
end;
$$;

--=========================================================
-- PROCEDURE: prc_end_appointment
-- Marks an appointment as 'Completed', sets its end time, and records diagnosis/comments.
-- To be called by the veterinarian when the consultation ends.
--=========================================================
create or replace procedure prc_end_appointment(
    p_app_id int,
    p_diagnosis varchar(100),
    p_comments text
)
language plpgsql
as $$
begin
    update appointment
    set
        end_dat_app = now(),
        status_app = 'Completed',
        dia_app = p_diagnosis,
        com_app = p_comments
    where
        id_app = p_app_id
        and status_app = 'In Progress'; -- Can only end an appointment that is in progress

    if not found then
        raise exception 'Não foi possível terminar a consulta. Verifique se o ID % existe e se o estado é "In Progress".', p_app_id;
    end if;
end;
$$;
