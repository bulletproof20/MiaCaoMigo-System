-- =========================================================
-- DEMO DATA — MODULE 4 (APPOINTMENT MANAGEMENT)
-- FILE: 04_Module4_DemoData.sql
-- =========================================================
--
-- PURPOSE
-- Scheduled and completed appointments using demo identities.
-- Requires active ownership (see 03_DemoData/02_Module2_DemoData.sql):
--   id_cli 2, id_ani 2, id_emp 2, id_spe 1.
-- =========================================================

insert into appointment (
    id_ani, id_emp, id_cli, id_spe,
    sch_dat_app, sta_dat_app, end_dat_app,
    status_app, dia_app, com_app
) values
    (2, 2, 2, 1,
     current_timestamp + interval '1 day',
     null, null,
     'scheduled', null, 'Check-up anual'),
    (2, 3, 2, 2,
     current_timestamp + interval '2 days',
     null, null,
     'scheduled', null, 'Vacinação');

-- Historical completed visits are created via sp_end_appointment in integration tests.
-- Demo tier keeps future-facing scheduled rows only (fn_block_past_appointments).
