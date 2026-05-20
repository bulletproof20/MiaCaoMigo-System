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
    v_row record;
    v_msg text;
begin
    -- Uses vw_scheduled_appointments_tomorrow (canonical joins via vw_appointment_detail).
    for v_row in
        select
            t.id_app,
            t.id_cli,
            t.client_name,
            t.veterinarian_name,
            t.animal_name
        from vw_scheduled_appointments_tomorrow t
    loop
        v_msg := format(
            'Lembrete: Bom dia %s! A sua consulta para o animal %s com o/a Dr(a). %s está marcada para amanhã.',
            v_row.client_name,
            v_row.animal_name,
            v_row.veterinarian_name
        );

        insert into appointment_notification (id_cli, id_app, msg_not)
        values (v_row.id_cli, v_row.id_app, v_msg);
    end loop;
end;
$$;

-- =========================================================
-- Cancels appointments outside the 24-hour change window
-- =========================================================

create or replace procedure sp_cancel_appointment(p_id_app int)
language plpgsql
as $$
declare
    v_scheduled_time timestamp;
begin
    -- Get the scheduled time and lock the row
    select sch_dat_app into v_scheduled_time from appointment where id_app = p_id_app for update;

    if not found then
        raise exception 'Consulta com ID % não encontrada.', p_id_app;
    end if;

    -- Check if the cancellation is being made within the allowed window
    -- The cancellation must be more than 24 hours before the scheduled time.
    if v_scheduled_time <= (now() + interval '24 hours') then
        raise exception 'A consulta só pode ser cancelada com mais de 24 horas de antecedência.';
    end if;

    -- Update the status to 'cancelled'
    update appointment set status_app = 'cancelled' where id_app = p_id_app;
end;
$$;

-- =========================================================
-- Moves appointments to a new slot when policy allows
-- =========================================================

create or replace procedure sp_reschedule_appointment(
    p_id_app int,
    p_sch_dat_app timestamp
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
    where id_app = p_id_app
    for update;

    if not found then
        raise exception 'Consulta com ID % não encontrada.', p_id_app;
    end if;

    -- Check if the rescheduling is being made within the allowed window
    if v_original_scheduled_time <= (now() + interval '24 hours') then
        raise exception 'A consulta só pode ser reagendada com mais de 24 horas de antecedência.';
    end if;

    -- Perform the update. This will fire the trigger for past dates, ensuring the new slot is valid.
    -- Note: The overlap trigger should also be based on sch_dat_app if appointments have a fixed duration.
    update appointment set sch_dat_app = p_sch_dat_app where id_app = p_id_app;
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
    p_sch_dat_app timestamp
)
language plpgsql
as $$
begin
    -- Creates an appointment with a 'scheduled' status.
    -- The sta_dat_app and end_dat_app fields are left NULL, to be filled in by the vet later.
    -- Triggers enforce: past dates, overlaps, absences, ownership, vet × specialty (expert).
    insert into appointment (id_cli, id_ani, id_emp, id_spe, sch_dat_app, status_app)
    values (p_id_cli, p_id_ani, p_id_emp, p_id_spe, p_sch_dat_app, 'scheduled');
end;
$$;

-- =========================================================
-- Transitions an appointment into in-progress clinical state
-- =========================================================

create or replace procedure sp_start_appointment(p_id_app int)
language plpgsql
as $$
begin
    update appointment
    set
        sta_dat_app = now(),
        status_app = 'in_progress'
    where
        id_app = p_id_app
        and status_app in ('scheduled'); -- Can start if it's scheduled 

    if not found then
        raise exception 'Não foi possível iniciar a consulta. Verifique se o ID % existe e se o estado é "Scheduled".', p_id_app;
    end if;
end;
$$;

-- =========================================================
-- Finalizes consult details and marks completion
-- =========================================================

create or replace procedure sp_end_appointment(
    p_id_app int,
    p_dia_app varchar(100),
    p_com_app text
)
language plpgsql
as $$
begin
    update appointment
    set
        end_dat_app = now(),
        status_app = 'completed',
        dia_app = p_dia_app,
        com_app = p_com_app
    where
        id_app = p_id_app
        and status_app = 'in_progress'; -- Can only end an appointment that is in progress

    if not found then
        raise exception 'Não foi possível terminar a consulta. Verifique se o ID % existe e se o estado é "In Progress".', p_id_app;
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
declare
    v_status appointment_status;
begin
    select status_app
    into v_status
    from appointment
    where id_app = p_id_app
    for update;

    if not found then
        raise exception 'Consulta com ID % não encontrada.', p_id_app;
    end if;

    insert into prescription (id_app, reg_dat_pre, des_pre)
    values (p_id_app, now(), p_des_pre);

exception
    when others then
        raise exception 'Falha ao registar prescrição para consulta %: %', p_id_app, sqlerrm;
end;
$$;
