-- =========================================================
-- DEMO DATA — MODULE 3 (COMMERCIAL MANAGEMENT)
-- FILE: 03_Module3_DemoData.sql
-- =========================================================
--
-- PURPOSE
-- Product catalog, stock, and sample purchase headers for inventory demos.
-- =========================================================

insert into family (nam_fam, des_fam) values
    ('Ração Cão', 'Dry and wet food for dogs'),
    ('Medicamentos', 'Veterinary pharmacy');

insert into product (ref_pro, bar_pro, nam_pro, des_pro, pri_pro, iva_pro, id_fam, min_sto) values
    ('DEMO-P001', '1000000000001', 'Ração Adulto 15kg', 'Maintenance diet', 45.50, 23.00, 2, 10),
    ('DEMO-P002', '1000000000002', 'Antibiótico Amoxicilina', 'Broad spectrum antibiotic', 14.50, 6.00, 3, 5);

insert into stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto) values
    (1, 'LOTE-DEMO-001', 50, current_date, current_date + interval '1 year'),
    (2, 'LOTE-DEMO-002', 8, current_date, current_date + interval '6 months');

insert into purchase (pur_dat_pur, sta_pur, id_emp) values
    (current_timestamp - interval '3 days', 'pending', 1);

insert into purchase_line (id_pur, id_pro, bat_pln, qty_pln, uni_cos_pln) values
    (1, 1, 'LOTE-DEMO-001', 20, 30.00);
