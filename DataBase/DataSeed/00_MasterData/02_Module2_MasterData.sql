-- =========================================================
-- MASTER DATA — MODULE 2 (ANIMAL MANAGEMENT)
-- FILE: 02_Module2_MasterData.sql
-- =========================================================
--
-- PURPOSE
-- Taxonomy minimum required before animal registry operations.
--
-- USAGE
-- Loaded after 01_Module1_MasterData.sql (no cross-FK to Mod1).
-- =========================================================

insert into species (nam_spc, sci_nam_spc) values
    ('Cão', 'Canis lupus familiaris'),
    ('Gato', 'Felis catus');

insert into breed (nam_bre, id_spc) values
    ('Sem raça definida (cão)', 1),
    ('Sem raça definida (gato)', 2);

select setval(pg_get_serial_sequence('species', 'id_spc'),
    (select coalesce(max(id_spc), 1) from species));
select setval(pg_get_serial_sequence('breed', 'id_bre'),
    (select coalesce(max(id_bre), 1) from breed));
