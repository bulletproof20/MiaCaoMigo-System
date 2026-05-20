-- =========================================================
-- DEVELOPMENT DATA — MODULE 2
-- FILE: 01_AnimalsDevelopment.sql
-- =========================================================
--
-- PURPOSE
-- Two internal animals for local API work. Run after MasterData + optional Mod1 dev.
-- =========================================================

insert into animal (reg_id_ani, nam_ani, dat_bir_ani, gen_ani, ori_ani, sta_ani, id_spc, id_bre) values
    ('DEV-ANI-001', 'Rufus', '2022-01-01', 'M', 'Interno', 'Interno', 1, 1),
    ('DEV-ANI-002', 'Mimi', '2023-06-15', 'F', 'Interno', 'Interno', 2, 2);

-- Active custody for Dev Client One (id_cli 1) on Rufus — enables appointment scheduling.
insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, mot_own) values
    (1, 1, 2, current_date - interval '3 months', 'Development custody');
