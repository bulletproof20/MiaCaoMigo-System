-- =========================================================
-- DEVELOPMENT DATA — MODULE 3
-- FILE: 01_InventoryDevelopment.sql
-- =========================================================
--
-- PURPOSE
-- Small product catalog for inventory and billing experiments.
-- Uses family id 1 from MasterData (Geral).
-- =========================================================

insert into product (ref_pro, bar_pro, nam_pro, des_pro, pri_pro, iva_pro, id_fam, min_sto) values
    ('DEV-P001', '9000000000001', 'Ração Dev Adult 3kg', 'Development feed sample', 12.90, 23.00, 1, 5),
    ('DEV-P002', '9000000000002', 'Antibiótico Dev 250mg', 'Development pharmacy sample', 8.50, 6.00, 1, 3);

insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto) values
    (1, 'DEV-STK-001', 25, current_date, current_date + interval '1 year'),
    (2, 'DEV-STK-002', 10, current_date, current_date + interval '6 months');
