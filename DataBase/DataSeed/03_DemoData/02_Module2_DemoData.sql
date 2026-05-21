-- =========================================================
-- DEMO DATA — MODULE 2 (ANIMAL MANAGEMENT)
-- FILE: 02_Module2_DemoData.sql
-- =========================================================
--
-- PURPOSE
-- Clinic animals, custody, and external entities for integrated demos.
-- Requires Demo Module 1 (clients id_cli 1–2) and Master taxonomy.
-- =========================================================

insert into breed (nam_bre, id_spc) values
    ('Labrador Retriever', 1),
    ('Europeu Comum', 2);

insert into external_entity (nam_ext_ent, loc_ext_ent, pho_ext_ent, typ_ext_ent) values
    ('Abrigo Patinhas', 'Lisboa', '+351213334445', 'Shelter'),
    ('Fornecedor PetGlobal', 'Porto', '+351221112223', 'Supplier');

insert into animal (reg_id_ani, nam_ani, dat_bir_ani, gen_ani, ori_ani, sta_ani, id_spc, id_bre) values
    ('ANI-DEMO-001', 'Bobi', '2020-05-15', 'M', 'Interno', 'Interno', 1, 3),
    ('ANI-DEMO-002', 'Luna', '2021-02-10', 'F', 'Interno', 'Interno', 2, 4),
    ('ANI-DEMO-003', 'Tareco', '2019-11-20', 'M', 'Interno', 'Interno', 2, 2);

-- id_cli 1–2: first demo clients (João, Maria).
insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, mot_own) values
    (1, 1, 2, current_date - interval '3 months', 'Registo clínico demo'),
    (2, 2, 2, current_date - interval '6 months', 'Adoção demo');
