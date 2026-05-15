-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 05_Procedures_Mod4.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Procedures orchestrating appointment lifecycle operations,
-- client communications, and prescription capture.
--
-- This file contains:
-- - Scheduling, cancellation, and rescheduling guards
-- - Clinical start/end transitions
-- - Notification generation and prescription inserts
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Appointment triggers (03_Triggers_Mod4.sql) for validation hooks
-- - Supporting tables (appointment, appointment_notification, prescription)
--
-- Must load before:
-- - 06_Jobs_Mod4.sql (cron wrappers)
-- =========================================================

-- =========================================================
-- Marks overdue scheduled appointments as no-shows
-- =========================================================

create or replace procedure sp_auto_update_no_show_appointments()
language plpgsql
as $$
begin
    -- Updates appointments that were scheduled for any time before the current moment
    -- and are still in 'scheduled' status.
    update appointment
    set status_app = 'no_show'
    where
        status_app = 'scheduled'
        and sch_dat_app < now();
end;
$$;

-- =========================================================
-- Queues reminder notifications for next-day appointments
-- =========================================================

create or replace procedure sp_generate_appointment_warnings()
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
        join animal an on a.id_ani = an.id_ani
        join employee e on a.id_emp = e.id_emp
        where a.sch_dat_app::date = current_date + interval '1 day' and a.status_app = 'scheduled'
    ) loop
        v_aviso := format('Lembrete: Bom dia %s! A sua consulta para o animal %s com o/a Dr(a). %s está marcada para amanhã.', consulta.nome_cliente, consulta.nome_animal, consulta.nome_veterinario);
        insert into appointment_notification (id_cli, id_app, msg_not) values (consulta.id_cli, consulta.id_app, v_aviso);
    end loop;
end;
$$;

-- =========================================================
-- Cancels appointments outside the 24-hour change window
-- =========================================================

create or replace procedure sp_cancel_appointment(p_app_id int)
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

    -- Update the status to 'cancelled'
    update appointment set status_app = 'cancelled' where id_app = p_app_id;
end;
$$;

-- =========================================================
-- Moves appointments to a new slot when policy allows
-- =========================================================

create or replace procedure sp_reschedule_appointment(
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

-- =========================================================
-- Inserts a freshly scheduled appointment row
-- =========================================================

create or replace procedure sp_create_appointment(
    p_id_cli int,
    p_id_ani int,
    p_id_emp int,
    p_id_spe int,
    p_scheduled_time timestamp
)
language plpgsql
as $$
begin
    -- Creates an appointment with a 'scheduled' status.
    -- The sta_dat_app and end_dat_app fields are left NULL, to be filled in by the vet later.
    -- Triggers enforce: past dates, overlaps, absences, ownership, vet × specialty (expert).
    insert into appointment (id_cli, id_ani, id_emp, id_spe, sch_dat_app, status_app)
    values (p_id_cli, p_id_ani, p_id_emp, p_id_spe, p_scheduled_time, 'scheduled');
end;
$$;

-- =========================================================
-- Transitions an appointment into in-progress clinical state
-- =========================================================

create or replace procedure sp_start_appointment(p_app_id int)
language plpgsql
as $$
begin
    update appointment
    set
        sta_dat_app = now(),
        status_app = 'in_progress'
    where
        id_app = p_app_id
        and status_app in ('scheduled'); -- Can start if it's scheduled 

    if not found then
        raise exception 'Não foi possível iniciar a consulta. Verifique se o ID % existe e se o estado é "Scheduled".', p_app_id;
    end if;
end;
$$;

-- =========================================================
-- Finalizes consult details and marks completion
-- =========================================================

create or replace procedure sp_end_appointment(
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
        status_app = 'completed',
        dia_app = p_diagnosis,
        com_app = p_comments
    where
        id_app = p_app_id
        and status_app = 'in_progress'; -- Can only end an appointment that is in progress

    if not found then
        raise exception 'Não foi possível terminar a consulta. Verifique se o ID % existe e se o estado é "In Progress".', p_app_id;
    end if;
end;
$$;


-- =========================================================
-- Inserts prescription narrative linked to a completed appointment
-- =========================================================

create or replace procedure sp_prescription_for_appointment(
    p_id_app int,
    p_des_pre text
)
language plpgsql
as $$
begin
    insert into prescription (id_app, reg_dat_pre, des_pre)
    values (p_id_app, now(), p_des_pre);
end;
$$;
