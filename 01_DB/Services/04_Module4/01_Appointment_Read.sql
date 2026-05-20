-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT (SERVICES)
-- FILE: 01_Appointment_Read.sql
-- =========================================================
--
-- Read helpers over Module 4 reporting views.
-- Depends on: vw_appointment_detail, vw_appointments_today,
--             vw_scheduled_appointments_tomorrow.
-- =========================================================

drop function if exists fn_list_appointments_today();

create function fn_list_appointments_today()
returns setof vw_appointments_today
language sql
stable
as $$
    select *
    from vw_appointments_today
    order by sch_dat_app;
$$;


drop function if exists fn_list_appointments_tomorrow();

create function fn_list_appointments_tomorrow()
returns setof vw_scheduled_appointments_tomorrow
language sql
stable
as $$
    select *
    from vw_scheduled_appointments_tomorrow
    order by sch_dat_app;
$$;


drop function if exists fn_get_appointment_detail(int);

create function fn_get_appointment_detail(p_id_app int)
returns vw_appointment_detail
language sql
stable
as $$
    select *
    from vw_appointment_detail
    where id_app = p_id_app;
$$;


drop function if exists fn_list_vet_appointments_from(int, date);

create function fn_list_vet_appointments_from(
    p_id_emp int,
    p_from_date date default current_date
)
returns setof vw_appointment_detail
language sql
stable
as $$
    select *
    from vw_appointment_detail d
    where d.id_emp = p_id_emp
      and d.sch_dat_app::date >= p_from_date
      and d.status_app = 'scheduled'
    order by d.sch_dat_app;
$$;


drop function if exists fn_list_animal_appointment_history(int);

create function fn_list_animal_appointment_history(p_id_ani int)
returns setof vw_appointment_detail
language sql
stable
as $$
    select *
    from vw_appointment_detail d
    where d.id_ani = p_id_ani
    order by d.sch_dat_app desc;
$$;
