-- =========================================================
-- MANUAL TEST — MODULE 4
-- WORKFLOW: Appointment schedule → start → end → prescription
-- =========================================================
-- PURPOSE:
--   Full clinical path using schema procedures and read services.
--
-- EXPECTED:
--   - scheduled → in_progress → completed
--   - sta_dat_app < end_dat_app (ck_appointment_flow)
--   - Prescription only after completion
--
-- REQUIRES: id_cli 4, id_ani 3, id_emp 8, id_spe 1 (TestData)
-- =========================================================

do $$
declare
    v_id_app int;
begin
    raise notice 'MANUAL M4-01 — Appointment lifecycle';

    call sp_create_appointment(
        4, 3, 8, 1,
        timestamp '2099-07-10 10:00:00'
    );

    select id_app into v_id_app
    from appointment
    where id_cli = 4 and sch_dat_app = timestamp '2099-07-10 10:00:00'
    order by id_app desc
    limit 1;

    raise notice 'Created appointment %', v_id_app;

    call sp_start_appointment(v_id_app);

    update appointment
       set sta_dat_app = sta_dat_app - interval '3 seconds'
     where id_app = v_id_app;

    call sp_end_appointment(v_id_app, 'manual qa', 'lifecycle workflow');

    call sp_prescription_for_appointment(
        v_id_app,
        'Manual QA — repouso e controlo em 7 dias'
    );

    raise notice 'Completed appointment % with prescription', v_id_app;
end $$;

select *
from fn_get_appointment_detail(
    (select id_app from appointment
      where sch_dat_app = timestamp '2099-07-10 10:00:00'
      order by id_app desc limit 1)
);

select des_pre, reg_dat_pre
from prescription
where id_app = (
    select id_app from appointment
    where sch_dat_app = timestamp '2099-07-10 10:00:00'
    order by id_app desc limit 1
);
