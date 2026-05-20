-- =========================================================
-- TEST DATA — MODULE 4 — APPOINTMENT FIXTURES
-- =========================================================
--
-- TIER: 01_TestData (fixtures only — no assertions)
-- LOADER: 04_Loaders/03_TestData.sql (step 3)
--
-- PREREQUISITE
--   01_TestData/01_Module1/02_CreationStress.sql
--   01_TestData/02_Module2/01_Module2_Fixtures.sql (animal 3, client 4)
--
-- PURPOSE
-- Appointment rows aligned with expert(id_emp, id_spe) from CreationStress.
-- =========================================================

truncate table
    rel_pre_prod,
    rel_app_product,
    prescription,
    anamnesis,
    overall_assessment,
    appointment_notification,
    appointment
restart identity cascade;

insert into appointment (
    id_ani, id_emp, id_cli, id_spe,
    sch_dat_app, sta_dat_app, end_dat_app,
    status_app, dia_app, com_app
) values
    (3, 8, 4, 1, now() + interval '1 day', null, null, 'scheduled', null, 'Annual check-up'),
    (3, 8, 4, 7, now() + interval '2 days', null, null, 'scheduled', null, 'Vaccine booster');

-- Historical completed visits: create via sp_start_appointment / sp_end_appointment in Tests/01_Integrity/
