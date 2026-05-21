-- =========================================================
-- MANUAL TEST — MODULE 1
-- WORKFLOW: Clock-in/out, schedule, absence (operational)
-- =========================================================
-- PURPOSE:
--   fn_clock_employee toggle, operational views, schedule slot,
--   absence registration with overlap rules.
--
-- EXPECTED:
--   - CLOCK_IN then CLOCK_OUT for id_emp 6 (no open session after out)
--   - vw_open_clock_in_sessions reflects state
--   - Future absence insert succeeds; overlapping absence fails
--
-- REQUIRES: CreationStress id_emp 6 (open clock-in may exist — workflow closes it)
-- =========================================================

do $$ begin
    raise notice 'MANUAL M1-03 — Attendance operations';
end $$;

do $$ begin
    raise notice '--- BEFORE: open clock-ins (vw_open_clock_in_sessions) ---';
end $$;

select * from vw_open_clock_in_sessions where id_emp = 6;

do $$ begin
    raise notice '--- STEP: toggle clock until CLOCK_OUT ---';
end $$;

select fn_clock_employee(6) as clock_action_1;
select fn_clock_employee(6) as clock_action_2;

select * from vw_open_clock_in_sessions where id_emp = 6;

do $$ begin
    raise notice '--- STEP: schedule row (Mon 09:00-17:00) ---';
end $$;

insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch)
values (6, 1, time '09:00', time '17:00')
on conflict on constraint pk_schedule do nothing;

select id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch
from schedule
where id_emp = 6
order by day_wee_sch, sta_tim_sch;

do $$ begin
    raise notice '--- STEP: future absence (should succeed) ---';
end $$;

insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs)
values (
    6,
    current_timestamp + interval '30 days',
    current_timestamp + interval '32 days',
    'manual qa ferias',
    'approved'
);

select * from vw_operational_absences
where id_emp = 6
order by sta_dat_tim_abs desc
limit 3;

do $$ begin
    raise notice '--- STEP: overlapping absence (uncomment to probe trigger) ---';
end $$;

-- insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs)
-- values (
--     6,
--     current_timestamp + interval '31 days',
--     current_timestamp + interval '33 days',
--     'manual qa overlap probe',
--     'approved'
-- );
