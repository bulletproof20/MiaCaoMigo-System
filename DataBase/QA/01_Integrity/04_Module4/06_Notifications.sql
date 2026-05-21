-- =========================================================
-- INTEGRITY — MODULE 4 — APPOINTMENT NOTIFICATIONS
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/04_Module4_Appointment_Slots.sql
-- RULE:     appointment_notification persistence
-- CONTRACT: qa_client_active_id, qa_appt_notification_date
-- =========================================================

do $$
declare
    v_count integer;
    v_cli int := qa_client_active_id();
    v_day date := qa_appt_notification_date();
begin
    delete from appointment_notification where id_cli = v_cli;

    insert into appointment_notification (id_cli, id_app, msg_not, rea_not)
    select a.id_cli,
           a.id_app,
           'Reminder: your pet has an appointment scheduled for tomorrow.',
           false
      from appointment a
     where a.id_cli = v_cli
       and date(a.sch_dat_app) = v_day;

    select count(*)
      into v_count
      from appointment_notification
     where id_cli = v_cli
       and msg_not ilike '%appointment scheduled for tomorrow%'
       and rea_not = false;

    if v_count >= 1 then
        raise notice 'PASS: notification created for client on % (count=%)', v_day, v_count;
    else
        raise notice 'FAIL: expected notification for client %, found %', v_cli, v_count;
    end if;
exception
    when others then
        raise notice 'FAIL: notification test — %', sqlerrm;
end;
$$;
