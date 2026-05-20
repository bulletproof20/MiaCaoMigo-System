-- =========================================================
-- MASTER DATA — MODULE 3 (COMMERCIAL MANAGEMENT)
-- FILE: 03_Module3_MasterData.sql
-- =========================================================
--
-- PURPOSE
-- Minimal product catalog anchor (one family) for inventory UI smoke tests.
-- Full commercial demo lives in 03_DemoData.
-- =========================================================

insert into family (nam_fam, des_fam) values
    ('Geral', 'default catalog family for bootstrap environments');

select setval(pg_get_serial_sequence('family', 'id_fam'),
    (select coalesce(max(id_fam), 1) from family));
