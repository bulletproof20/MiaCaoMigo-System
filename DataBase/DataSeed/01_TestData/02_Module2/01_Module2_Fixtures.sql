-- =========================================================
-- TEST DATA — MODULE 2 — INTEGRATION FIXTURES
-- =========================================================
--
-- TIER: 01_TestData (fixtures only — no assertions)
-- LOADER: 04_Loaders/03_TestData.sql (step 2)
--
-- PREREQUISITE
-- 01_TestData/01_Module1/02_CreationStress.sql (id_cli 4–6, id_emp 1–3)
--
-- =========================================================
-- MODULE 2: ANIMAL MANAGEMENT - INTEGRITY SEED
-- =========================================================

--=========================================================
-- 0. CLEAN DATA 
--=========================================================
-- Limpa apenas as tabelas deste módulo
truncate table 
    delivery_employee,
    concession,
    delivery,
    ownership,
    animal,
    breed,
    species,
    external_entity
restart identity cascade;


--=========================================================
-- 1. SPECIES
--=========================================================
insert into species (nam_spc, sci_nam_spc) values 
('Cão', 'Canis lupus familiaris'),
('Gato', 'Felis catus'),
('Pássaro', 'Aves');


--=========================================================
-- 2. BREED
--=========================================================
insert into breed (nam_bre, sci_nam_bre, id_spc) values 
('Labrador Retriever', 'Canis lupus', 1),
('Pastor Alemão', 'Canis lupus', 1),
('Siamês', 'Felis catus', 2),
('Persa', 'Felis catus', 2),
('Canário', 'Serinus canaria', 3);


--=========================================================
-- 3. EXTERNAL_ENTITY (Telefone e Email validados)
--=========================================================
insert into external_entity (nam_ext_ent, loc_ext_ent, pho_ext_ent, ema_ext_ent, typ_ext_ent) values 
('Abrigo Patas Felizes', 'Lisboa', '+351912345678', 'contacto@patasfelizes.pt', 'Shelter'),
('Fornecedor Rações Pro', 'Porto', '+351223456789', 'vendas@racoespro.com', 'Supplier'),
('Associação Zoófila', 'Coimbra', '+351239123456', 'geral@az.org', 'Association');


--=========================================================
-- 4. ANIMAL
--=========================================================
insert into animal (reg_id_ani, nam_ani, dat_bir_ani, gen_ani, ori_ani, sta_ani, id_spc, id_bre) values 
('ANI-2026-001', 'Bobby', '2020-05-10', 'M', 'Rua', 'Interno', 1, 1),
('ANI-2026-002', 'Luna', '2021-02-20', 'F', 'Nascido na Clínica', 'Interno', 1, 2),
('ANI-2026-003', 'Miau', '2019-11-15', 'M', 'Entrega Externa', 'Interno', 2, 3),
('ANI-2026-004', 'Pipocas', '2022-08-01', 'F', 'Rua', 'Interno', 3, 5),
('ANI-2026-005', 'Rex', '2018-03-12', 'M', 'Abandono', 'Interno', 1, 2);


--=========================================================
-- 5. OWNERSHIP (FKs: id_cli 4,5,6 / id_emp 1,2,3 do Mod 1)
--=========================================================
insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, end_dat_own, mot_own)
values (4, 3, 1, '2026-01-10', null, 'Adoção definitiva para apartamento');

update animal set sta_ani = 'Adotado' where id_ani = 3;

insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, end_dat_own, mot_own)
values (5, 2, 2, '2026-02-01', '2026-03-01', 'Acolhimento temporário');


--=========================================================
-- 6. DELIVERY
--=========================================================
insert into delivery (reg_dat_del, res_dat_del, res_loc_del, cli_sta_del, id_ext_ent, id_ani) values 
(now(), now() - interval '2 hours', 'Rua de Baixo, Braga', 'Desnutrido', 1, 4),
(now() - interval '1 day', now() - interval '25 hours', 'Parque da Cidade', 'Saudável', 3, 1);


--=========================================================
-- 7. DELIVERY_EMPLOYEE (FKs: id_emp do Mod 1)
--=========================================================
insert into delivery_employee (id_del, id_emp) values 
(1, 1),
(1, 2),
(2, 3);


--=========================================================
-- 8. CONCESSION
--=========================================================
insert into concession (dat_con, mot_con, cli_sta_con, id_ext_ent, id_emp, id_ani) values 
('2026-04-15', 'Transferência para abrigo especializado', 'Saudável', 1, 1, 2);