-- =========================================================
-- DEVELOPMENT DATA — MODULE 4
-- FILE: 01_AppointmentsDevelopment.sql
-- =========================================================
--
-- PURPOSE
-- One scheduled appointment for local API debugging.
-- Requires:
--   id_cli 1, id_ani 1 (ownership in 02_Module2/01_AnimalsDevelopment.sql)
--   id_emp 2, id_spe 1 (MasterData veterinarian + expert)
-- =========================================================

insert into appointment (
    id_ani, id_emp, id_cli, id_spe,
    sch_dat_app, status_app, com_app
) values (
    1, 2, 1, 1,
    current_timestamp + interval '3 days',
    'scheduled',
    'Development smoke appointment'
);
