--=========================================================
-- FULL TEST DATA SEED SCRIPT
-- Populates the MiaCaoMigo database with 20 rows per table.
-- Respeita constraints de CHECK, domínios ENUM e FKs.
--=========================================================

SET TIMEZONE TO 'Europe/Lisbon';

-- 0. CLEAN DATA (Já fornecido por ti, mantido por segurança)

TRUNCATE TABLE have,
               occupies,
               expert,
               appointment_notification,
               rel_app_product,
               rel_pre_prod,
               prescription,
               anamnesis,
               overall_assessment,
               appointment,
               delivery_employee,
               concession,
               delivery,
               ownership,
               invoiceline,
               purchaseline,
               "return",
               stock,
               product,
               invoice,
               purchase,
               family,
               external_entity,
               schedule,
               absence,
               clock_in,
               setup,
               login_record,
               assistant,
               veterinarian,
               client,
               employee,
               user_account,
               breed,
               species,
               profile,
               permission,
               specialty RESTART IDENTITY CASCADE;

--=========================================================
-- 1. MODULE 1: USER & EMPLOYEE MANAGEMENT
--=========================================================
 -- 1.1. USER_ACCOUNT (40 registos para cobrir 20 funcionários + 20 clientes)

INSERT INTO user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
VALUES ('João Silva', 'Rua das Flores 1', '1000-001', '123456789', '+351912345678', 'joao.silva@gmail.com'),
       ('Maria Oliveira', 'Avenida da Liberdade 10', '1200-010', '234567890', '+351922345678', 'maria.oli@outlook.com'),
       ('Carlos Santos', 'Rua Central 5', '2000-005', '345678901', '+351932345678', 'carlos.santos@sapo.pt'),
       ('Ana Pereira', 'Praça da República 2', '3000-002', '456789012', '+351962345678', 'ana.p@gmail.com'),
       ('Ricardo Ramos', 'Rua Direita 5', '5000-005', '523456789', '+351910000005', 'ric.ramos@gmail.com'),
       ('Beatriz Costa', 'Travessa do Sol 12', '4000-123', '678901234', '+351911111111', 'b.costa@yahoo.com'),
       ('Fernando Mendes', 'Rua do Porto 45', '4100-045', '789012345', '+351922222222', 'fmendes@gmail.com'),
       ('Sofia Vieira', 'Rua Norte 20', '8000-020', '923456780', '+351910000020', 'sofia.v@gmail.com'),
       ('Tiago Lopes', 'Avenida Europa 100', '3030-100', '112233445', '+351933333333', 'tiago.lopes@gmail.com'),
       ('Diana Martins', 'Rua da Escola 8', '2500-008', '223344556', '+351964444444', 'diana.m@sapo.pt'),
       ('Hugo Rocha', 'Rua Nova 3', '4700-003', '334455667', '+351915555555', 'hugo.rocha@gmail.com'),
       ('Inês Castro', 'Largo do Paço 1', '4710-001', '445566778', '+351926666666', 'ines.castro@gmail.com'),
       ('Miguel Antunes', 'Rua das Amoreiras 50', '1250-050', '556677889', '+351937777777', 'm.antunes@outlook.com'),
       ('Patrícia Gomes', 'Rua da Prata 15', '1100-015', '667788990', '+351968888888', 'patricia.g@gmail.com'),
       ('Rui Ferreira', 'Avenida do Mar 5', '8200-005', '778899001', '+351919999999', 'rui.f@gmail.com'),
       ('Catarina Belo', 'Rua do Ouro 2', '1100-002', '889900112', '+351920000000', 'c.belo@gmail.com'),
       ('Nuno Correia', 'Rua da Paz 10', '6000-010', '990011223', '+351931111111', 'n.correia@gmail.com'),
       ('Sara Matos', 'Avenida da Igreja 40', '1700-040', '101112131', '+351962222222', 'sara.matos@gmail.com'),
       ('Vasco Duarte', 'Rua do Alecrim 8', '1200-008', '141516171', '+351913333333', 'v.duarte@gmail.com'),
       ('Marta Neves', 'Rua da Alegria 90', '4000-090', '181920212', '+351924444444', 'marta.neves@gmail.com'),
       ('José Ferreira', 'Rua Sul 1', '8000-100', '123456701', '+351910000101', 'jose.f@gmail.com'),
       ('Cláudia Cruz', 'Rua do Sol 2', '1000-002', '123456702', '+351910000102', 'claudia.c@gmail.com'),
       ('André Silva', 'Rua da Lua 3', '2000-003', '123456703', '+351910000103', 'andre.s@gmail.com'),
       ('Paula Santos', 'Rua das Estrelas 4', '3000-004', '123456704', '+351910000104', 'paula.s@gmail.com'),
       ('Luís Amaral', 'Rua do Rio 5', '4000-005', '123456705', '+351910000105', 'luis.a@gmail.com'),
       ('Sónia Neto', 'Rua do Campo 6', '5000-006', '123456706', '+351910000106', 'sonia.n@gmail.com'),
       ('Jorge Vaz', 'Rua do Monte 7', '6000-007', '123456707', '+351910000107', 'jorge.v@gmail.com'),
       ('Mónica Luz', 'Rua da Ponte 8', '7000-008', '123456708', '+351910000108', 'monica.l@gmail.com'),
       ('Pedro Lima', 'Rua da Fonte 9', '8000-009', '123456709', '+351910000109', 'pedro.l@gmail.com'),
       ('Rita Gomes', 'Rua da Serra 10', '9000-010', '123456710', '+351910000110', 'rita.g@gmail.com'),
       ('Vítor Bruno', 'Rua das Matas 11', '1000-011', '123456711', '+351910000111', 'vitor.b@gmail.com'),
       ('Alice Mota', 'Rua das Hortas 12', '2000-012', '123456712', '+351910000112', 'alice.m@gmail.com'),
       ('Bruno Dias', 'Rua da Vila 13', '3000-013', '123456713', '+351910000113', 'bruno.d@gmail.com'),
       ('Carla Pais', 'Rua do Vale 14', '4000-014', '123456714', '+351910000114', 'carla.p@gmail.com'),
       ('Daniel Rei', 'Rua do Castelo 15', '5000-015', '123456715', '+351910000115', 'daniel.r@gmail.com'),
       ('Elsa Faria', 'Rua do Palácio 16', '6000-016', '123456716', '+351910000116', 'elsa.f@gmail.com'),
       ('Filipe Sá', 'Rua do Jardim 17', '7000-017', '123456717', '+351910000117', 'filipe.s@gmail.com'),
       ('Gina Rosa', 'Rua da Flor 18', '8000-018', '123456718', '+351910000118', 'gina.r@gmail.com'),
       ('Hélio Gil', 'Rua do Mar 19', '9000-019', '123456719', '+351910000119', 'helio.g@gmail.com'),
       ('Igor João', 'Rua do Porto 20', '1000-020', '123456720', '+351910000120', 'igor.j@gmail.com');

-- 1.2. PROFILE

INSERT INTO profile (nam_pro,
                     des_pro)
VALUES ('administrador', 'Acesso total ao sistema'),
       ('veterinário', 'Gestão clínica e prescrições'),
       ('assistente', 'Gestão de marcações e stock'),
       ('cliente', 'Acesso à área pessoal e notificações');

-- 1.3. EMPLOYEE (20 Funcionários)

INSERT INTO employee (id_usr, ema_emp, pas_emp, pho_emp)
VALUES (1, 'joao.silva@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000001'),
       (2, 'maria.oli@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000002'),
       (3, 'carlos.santos@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000003'),
       (4, 'ana.p@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000004'),
       (5, 'ricardo.r@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000005'),
       (6, 'beatriz.c@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000006'),
       (7, 'fernando.m@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000007'),
       (8, 'sofia.v@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000008'),
       (9, 'tiago.l@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000009'),
       (10, 'diana.m@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000010'),
       (11, 'hugo.r@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000011'),
       (12, 'ines.c@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000012'),
       (13, 'miguel.a@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000013'),
       (14, 'patricia.g@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000014'),
       (15, 'rui.f@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000015'),
       (16, 'catarina.b@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000016'),
       (17, 'nuno.c@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000017'),
       (18, 'sara.m@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000018'),
       (19, 'vasco.d@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000019'),
       (20, 'marta.n@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', '+351210000020');

-- 1.4. VETERINARIAN (Subtipo de Employee - 10 Veterinários)

INSERT INTO veterinarian (id_emp, num_omv_vet)
VALUES (1, 'OMV-1234'),
       (2, 'OMV-2345'),
       (3, 'OMV-3456'),
       (4, 'OMV-4567'),
       (5, 'OMV-5678'),
       (11, 'OMV-6789'),
       (12, 'OMV-7890'),
       (13, 'OMV-8901'),
       (14, 'OMV-9012'),
       (15, 'OMV-0123');

-- 1.5. ASSISTANT (Os outros 10 funcionários)

INSERT INTO assistant (id_emp, fun_ass)
VALUES (6, 'Rececionista'),
       (7, 'Auxiliar de Stock'),
       (8, 'Limpeza'),
       (9, 'Rececionista'),
       (10, 'Apoio Clínico'),
       (16, 'Financeiro'),
       (17, 'TI'),
       (18, 'Marketing'),
       (19, 'Rececionista'),
       (20, 'Gerente');

-- 1.6. SPECIALTY

INSERT INTO specialty (nam_spe, des_spe)
VALUES ('cardiologia', 'Especialidade em doenças do coração animal'),
       ('dermatologia', 'Cuidados com a pele e pelo'),
       ('ortopedia', 'Problemas ósseos e articulares'),
       ('oftalmologia', 'Saúde ocular animal'),
       ('oncologia', 'Tratamento de tumores e cancro'),
       ('cirurgia', 'Procedimentos cirúrgicos gerais'),
       ('dentisteria', 'Saúde oral e dentária'),
       ('exóticos', 'Cuidado de animais não convencionais'),
       ('neurologia', 'Sistema nervoso'),
       ('comportamento', 'Psicologia e etologia animal');

-- 1.7. EXPERT (Associação Veterinário-Especialidade)

INSERT INTO expert (id_emp, id_spe)
VALUES (1, 1),
       (1, 6),
       (2, 2),
       (2, 4),
       (3, 3),
       (4, 5),
       (5, 8),
       (11, 1),
       (12, 7),
       (13, 9),
       (14, 10),
       (15, 6);

-- 1.8. CLIENT (Utilizadores 21-40)

INSERT INTO client (id_usr, pas_cli, ina_dat_cli)
VALUES (21, 'senha_cliente_muito_segura_123', null),
       (22, 'senha_cliente_muito_segura_123', null),
       (23, 'senha_cliente_muito_segura_123', null),
       (24, 'senha_cliente_muito_segura_123', null),
       (25, 'senha_cliente_muito_segura_123', null),
       (26, 'senha_cliente_muito_segura_123', null),
       (27, 'senha_cliente_muito_segura_123', null),
       (28, 'senha_cliente_muito_segura_123', null),
       (29, 'senha_cliente_muito_segura_123', null),
       (30, 'senha_cliente_muito_segura_123', null),
       (31, 'senha_cliente_muito_segura_123', null),
       (32, 'senha_cliente_muito_segura_123', null),
       (33, 'senha_cliente_muito_segura_123', null),
       (34, 'senha_cliente_muito_segura_123', null),
       (35, 'senha_cliente_muito_segura_123', null),
       (36, 'senha_cliente_muito_segura_123', null),
       (37, 'senha_cliente_muito_segura_123', null),
       (38, 'senha_cliente_muito_segura_123', null),
       (39, 'senha_cliente_muito_segura_123', null),
       (40, 'senha_cliente_muito_segura_123', null);

-- 1.9. SCHEDULE (Horários para os 20 funcionários, dias 1 a 5)

INSERT INTO schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch)
SELECT id_emp,
       day,
       '09:00:00',
       '18:00:00'
FROM employee,
     generate_series(1, 5) as day;

-- 1.10. LOGIN_RECORD

INSERT INTO login_record (sig_tim_log, suc_log, ip_add_log, eml_usr, id_usr)
VALUES (current_timestamp - interval '1 day', true, '192.168.1.1', 'joao.silva@gmail.com', 1),
       (current_timestamp - interval '20 hours', true, '192.168.1.5', 'maria.oli@outlook.com', 2),
       (current_timestamp - interval '18 hours', false, '1.2.3.4', 'hacker@mal.com', null),
       (current_timestamp - interval '15 hours', true, '192.168.1.10', 'ric.ramos@gmail.com', 5),
       (current_timestamp - interval '12 hours', true, '10.0.0.1', 'ana.p@gmail.com', 4),
       (current_timestamp - interval '10 hours', true, '10.0.0.2', 'b.costa@yahoo.com', 6),
       (current_timestamp - interval '8 hours', true, '192.168.2.1', 'sofia.v@gmail.com', 8),
       (current_timestamp - interval '7 hours', true, '192.168.2.2', 'tiago.lopes@gmail.com', 9),
       (current_timestamp - interval '6 hours', true, '192.168.2.3', 'diana.m@sapo.pt', 10),
       (current_timestamp - interval '5 hours', true, '192.168.1.50', 'jose.f@gmail.com', 21),
       (current_timestamp - interval '4 hours', true, '192.168.1.51', 'claudia.c@gmail.com', 22),
       (current_timestamp - interval '3 hours', true, '192.168.1.52', 'andre.s@gmail.com', 23),
       (current_timestamp - interval '2 hours', true, '192.168.1.53', 'paula.s@gmail.com', 24),
       (current_timestamp - interval '1 hour', true, '192.168.1.54', 'luis.a@gmail.com', 25),
       (current_timestamp - interval '50 minutes', true, '192.168.1.55', 'sonia.n@gmail.com', 26),
       (current_timestamp - interval '40 minutes', true, '192.168.1.56', 'jorge.v@gmail.com', 27),
       (current_timestamp - interval '30 minutes', true, '192.168.1.57', 'monica.l@gmail.com', 28),
       (current_timestamp - interval '20 minutes', true, '192.168.1.58', 'pedro.l@gmail.com', 29),
       (current_timestamp - interval '10 minutes', true, '192.168.1.59', 'rita.g@gmail.com', 30),
       (current_timestamp, true, '192.168.1.60', 'vitor.b@gmail.com', 31);

--=========================================================
-- 2. MODULE 2: ANIMAL MANAGEMENT
--=========================================================
 -- 2.1. SPECIES

INSERT INTO species (nam_spc, sci_nam_spc)
VALUES ('Cão', 'Canis lupus familiaris'),
       ('Gato', 'Felis catus'),
       ('Coelho', 'Oryctolagus cuniculus'),
       ('Hamster', 'Cricetinae'),
       ('Porquinho da Índia', 'Cavia porcellus'),
       ('Furão', 'Mustela putorius furo'),
       ('Papagaio', 'Psittacidae'),
       ('Tartaruga', 'Testudines');

-- 2.2. BREED

INSERT INTO breed (nam_bre, id_spc)
VALUES ('Labrador Retriever', 1),
       ('Pastor Alemão', 1),
       ('Golden Retriever', 1),
       ('Beagle', 1),
       ('Poodle', 1),
       ('Siamês', 2),
       ('Persa', 2),
       ('Maine Coon', 2),
       ('Bengala', 2),
       ('Europeu Comum', 2),
       ('Anão Holandês', 3),
       ('Belier', 3),
       ('Angorá', 3),
       ('Sírio', 4),
       ('Russo', 4),
       ('Abissínio', 5),
       ('Peruano', 5),
       ('Standard', 6),
       ('Cinzento', 7),
       ('Hieroglífica', 8);

-- 2.3. ANIMAL (20 Animais)

INSERT INTO animal (reg_id_ani, nam_ani, dat_bir_ani, gen_ani, id_spc, id_bre, inactivation_date)
VALUES ('ANI-001', 'Bobi', '2020-05-15', 'M', 1, 1, null),
       ('ANI-002', 'Tareco', '2021-02-10', 'M', 2, 10, null),
       ('ANI-003', 'Luna', '2019-11-20', 'F', 1, 3, null),
       ('ANI-004', 'Mimi', '2022-01-05', 'F', 2, 6, null),
       ('ANI-005', 'Pipoca', '2023-03-12', 'F', 3, 11, null),
       ('ANI-006', 'Rex', '2018-08-25', 'M', 1, 2, null),
       ('ANI-007', 'Simba', '2020-12-30', 'M', 2, 8, null),
       ('ANI-008', 'Daisy', '2021-07-14', 'F', 1, 4, null),
       ('ANI-009', 'Nala', '2019-04-18', 'F', 2, 7, null),
       ('ANI-011', 'Thor', '2020-01-01', 'M', 1, 3, null),
       ('ANI-012', 'Cleo', '2021-05-20', 'F', 2, 9, null),
       ('ANI-013', 'Tico', '2023-01-15', 'M', 3, 12, null),
       ('ANI-014', 'Jade', '2018-03-22', 'F', 1, 5, null),
       ('ANI-015', 'Félix', '2017-10-10', 'M', 2, 10, null),
       ('ANI-016', 'Mel', '2022-11-30', 'F', 1, 1, null),
       ('ANI-017', 'Zeca', '2020-06-05', 'M', 2, 6, null),
       ('ANI-018', 'Pipa', '2021-08-20', 'F', 3, 13, null),
       ('ANI-019', 'Russo', '2022-04-12', 'M', 4, 15, null),
       ('ANI-020', 'Kika', '2019-02-28', 'F', 1, 2, null);

-- 2.4. OWNERSHIP

INSERT INTO ownership (id_cli, id_ani, sta_dat_own)
VALUES (1, 1, '2020-06-01'),
       (2, 2, '2021-03-01'),
       (3, 3, '2019-12-01'),
       (4, 4, '2022-02-01'),
       (5, 5, '2023-04-01'),
       (6, 6, '2018-09-01'),
       (7, 7, '2021-01-01'),
       (8, 8, '2021-08-01'),
       (9, 9, '2019-05-01'),
       (10, 10, '2022-10-01'),
       (11, 11, '2020-02-01'),
       (12, 12, '2021-06-01'),
       (13, 13, '2023-02-01'),
       (14, 14, '2018-04-01'),
       (15, 15, '2017-11-01'),
       (16, 16, '2022-12-01'),
       (17, 17, '2020-07-01'),
       (18, 18, '2021-09-01'),
       (19, 19, '2022-05-01'),
       (20, 20, '2019-03-01');

-- 2.5. EXTERNAL_ENTITY

INSERT INTO external_entity (nam_ext_ent, loc_ext_ent, pho_ext_ent, typ_ext_ent)
VALUES ('Fornecedor PetGlobal', 'Porto', '+351221112223', 'Supplier'),
       ('Abrigo Patinhas', 'Lisboa', '+351213334445', 'Shelter'),
       ('Farmácia Vet+', 'Coimbra', '+351239102030', 'Pharmacy'),
       ('Câmara Municipal de Braga', 'Braga', '+351253999888', 'Public Entity'),
       ('Canil de Sintra', 'Sintra', '+351219887766', 'Shelter'),
       ('Laboratório VetLab', 'Oeiras', '+351215550001', 'Laboratory');

--=========================================================
-- 3. MODULE 3: COMMERCIAL MANAGEMENT
--=========================================================
 -- 3.1. FAMILY

INSERT INTO family (nam_fam, des_fam)
VALUES ('Ração Cão', 'Alimento seco e húmido para cães'),
       ('Ração Gato', 'Alimento seco e húmido para gatos'),
       ('Medicamentos', 'Produtos farmacêuticos de uso veterinário'),
       ('Higiene', 'Champôs e produtos de limpeza'),
       ('Acessórios', 'Tretas, coleiras e camas'),
       ('Brinquedos', 'Entretenimento animal');

-- 3.2. PRODUCT (20 Produtos)

INSERT INTO product (ref_pro, bar_pro, nam_pro, pri_pro, iva_pro, id_fam)
VALUES ('P001', '123001', 'Ração Adulto 15kg', 45.50, 6.0, 1),
       ('P002', '123002', 'Ração Puppy 3kg', 15.20, 6.0, 1),
       ('P003', '123003', 'Ração Gato Esterilizado 2kg', 18.90, 6.0, 2),
       ('P004', '123004', 'Lata Atum Gato', 1.50, 6.0, 2),
       ('P005', '123005', 'Champô Antiparalítico', 8.50, 23.0, 4),
       ('P006', '123006', 'Coleira Antipulgas', 12.00, 23.0, 4),
       ('P007', '123007', 'Antibiótico Genérico', 25.00, 6.0, 3),
       ('P008', '123008', 'Anti-inflamatório', 15.75, 6.0, 3),
       ('P009', '123009', 'Brinquedo Corda', 5.00, 23.0, 6),
       ('P010', '123010', 'Bola de Borracha', 3.50, 23.0, 6),
       ('P011', '123011', 'Cama L', 35.00, 23.0, 5),
       ('P012', '123012', 'Trela Extensível', 14.00, 23.0, 5),
       ('P013', '123013', 'Snack Dental', 2.99, 6.0, 1),
       ('P014', '123014', 'Areia Sílica 5L', 9.90, 23.0, 4),
       ('P015', '123015', 'Vitamina C Coelho', 6.50, 6.0, 3),
       ('P016', '123016', 'Pente de Aço', 7.50, 23.0, 4),
       ('P017', '123017', 'Desparasitante Interno', 10.00, 6.0, 3),
       ('P018', '123018', 'Taça Inox', 4.50, 23.0, 5),
       ('P019', '123019', 'Arranhador Torre', 45.00, 23.0, 6),
       ('P020', '123020', 'Transportadora M', 25.00, 23.0, 5);

-- 3.3. STOCK (Para cada produto)

INSERT INTO stock (id_pro, bat_sto, qty_sto, ent_dat_sto)
SELECT id_pro,
       'BATCH-202',
       100,
       current_date
FROM product;

-- 3.4. PURCHASE

INSERT INTO purchase (pur_dat_pur, tot_val_pur, id_cli, id_emp, sta_pur)
VALUES (current_timestamp - interval '5 days', 150.00, 1, 6, 'received'),
       (current_timestamp - interval '4 days', 25.50, 2, 6, 'received'),
       (current_timestamp - interval '3 days', 80.00, 3, 9, 'received'),
       (current_timestamp - interval '2 days', 12.00, 4, 9, 'pending');

--=========================================================
-- 4. MODULE 4: APPOINTMENT MANAGEMENT
--=========================================================
 -- 4.1. APPOINTMENT (20 Consultas)
--=========================================================
-- 4.1. APPOINTMENT (20 Consultas - Seed Corrigida)
--=========================================================

INSERT INTO appointment (id_animal, id_emp, id_cli, sch_dat_app, sta_dat_app, end_dat_app, status_app, dia_app, com_app)
VALUES (1, 1, 1, '2027-05-01 10:00:00', '2027-05-01 10:00:00', '2027-05-01 10:30:00', 'Completed', 'Check-up anual', 'Animal saudável, vacinas em dia.'),
       (2, 2, 2, '2027-05-01 11:00:00', '2027-05-01 11:05:00', '2027-05-01 11:40:00', 'Completed', 'Otite externa', 'Prescrito tratamento tópico e oral.'),
       (3, 3, 3, '2027-05-02 09:00:00', '2027-05-02 09:00:00', '2027-05-02 09:25:00', 'Completed', 'Desparasitação', 'Administrado desparasitante interno.'),
       (4, 4, 4, '2027-05-02 10:30:00', '2027-05-02 10:30:00', '2027-05-02 11:00:00', 'Completed', 'Revisão de ferida', 'Cicatrização a decorrer bem.'),
       (5, 5, 5, '2027-05-03 14:00:00', '2027-05-03 14:00:00', '2027-05-03 14:35:00', 'Completed', 'Vacinação', 'Vacina polivalente administrada.'),
       (6, 1, 6, '2027-05-03 15:30:00', '2027-05-03 15:30:00', '2027-05-03 16:00:00', 'Completed', 'Problemas gastrointestinais', 'Dieta especial recomendada.'),
       (7, 2, 7, '2027-05-04 10:00:00', '2027-05-04 10:00:00', '2027-05-04 10:20:00', 'Completed', 'Check-up dentário', 'Sem problemas graves, limpeza recomendada.'),
       (8, 3, 8, '2027-05-04 11:30:00', '2027-05-04 11:30:00', '2027-05-04 12:00:00', 'Completed', 'Alergia cutânea', 'Identificado alérgeno, tratamento com anti-histamínicos.'),
       (9, 4, 9, '2027-05-05 09:00:00', '2027-05-05 09:00:00', '2027-05-05 09:45:00', 'Completed', 'Exame de rotina', 'Animal em excelente forma.'),
       (10, 5, 10, '2027-05-05 16:00:00', '2027-05-05 16:00:00', '2027-05-05 16:30:00', 'Completed', 'Problemas respiratórios', 'Antibiótico e repouso.'),
       (11, 11, 11, '2027-05-06 10:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (12, 12, 12, '2027-05-06 11:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (13, 13, 13, '2027-05-07 09:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (14, 14, 14, '2027-05-07 15:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (15, 15, 15, '2027-05-08 10:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (16, 1, 16, '2027-05-08 11:00:00', NULL, NULL, 'Cancelled', NULL, NULL),
       (17, 2, 17, '2027-05-09 10:00:00', NULL, NULL, 'No-Show', NULL, NULL),
       (18, 3, 18, '2027-05-09 12:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (19, 4, 19, '2027-05-10 09:00:00', NULL, NULL, 'Scheduled', NULL, NULL),
       (20, 5, 20, '2027-05-10 14:00:00', NULL, NULL, 'Scheduled', NULL, NULL);

-- 4.2. OVERALL_ASSESSMENT (Para os primeiros 10 appointments - Completed)

INSERT INTO overall_assessment (id_app, body_temp, weight, hrt_rate, resp_rate, general_status)
VALUES (1, 38.5, 25.0, 80, 20, 'Saudável, check-up anual'),
       (2, 39.0, 4.5, 110, 25, 'Ligeira desidratação'),
       (3, 38.2, 30.0, 75, 18, 'Excelente condição física'),
       (4, 38.7, 3.2, 120, 30, 'Infeção auditiva detetada'),
       (5, 39.2, 1.1, 140, 40, 'Febre ligeira'),
       (6, 38.4, 35.0, 85, 22, 'Recuperação pós-cirúrgica'),
       (7, 38.1, 5.0, 105, 24, 'Peso ideal'),
       (8, 38.8, 12.0, 90, 20, 'Alergia alimentar suspeita'),
       (9, 39.5, 6.0, 115, 28, 'Infeção urinária'),
       (10, 37.9, 0.5, 150, 45, 'Normal para a espécie');

-- 4.3. ANAMNESIS (Histórico recolhido)

INSERT INTO anamnesis (id_app, des_ana)
VALUES (1, 'Dono reporta falta de apetite.'),
       (2, 'Vómitos ocasionais nas últimas 24h.'),
       (3, 'Check-up de rotina para vacinação.'),
       (4, 'Animal coça muito a orelha esquerda.'),
       (5, 'Espirros frequentes.'),
       (6, 'Revisão de pontos cirúrgicos.'),
       (7, 'Consulta de rotina.'),
       (8, 'Pele irritada na zona abdominal.'),
       (9, 'Dificuldade em urinar.'),
       (10, 'Apatia nas últimas 4 horas.');

-- 4.4. PRESCRIPTION (Receitas - Corrigido reg_dat_pre para ser posterior a sta_dat_app)

INSERT INTO prescription (id_app, reg_dat_pre, des_pre)
VALUES (2, '2027-05-01 11:15:00', 'Dieta mole por 3 dias.'),
       (4, '2027-05-02 10:40:00', 'Limpeza auricular diária.'),
       (5, '2027-05-03 14:10:00', 'Manter animal em ambiente quente.'),
       (8, '2027-05-04 11:40:00', 'Mudança de ração para hipoalergénica.'),
       (9, '2027-05-05 09:10:00', 'Antibioticoterapia por 7 dias.');

-- 4.5. REL_PRE_PROD (Associação Prescrição-Produto)

INSERT INTO rel_pre_prod (id_pre, id_pro, qty_pre_pro, dos_pre_pro)
VALUES (1, 4, 6, '1 lata manhã e noite'),
       (2, 5, 1, '3 gotas/dia'),
       (5, 7, 1, '1 comp de 12h em 12h');

-- 4.6. APPOINTMENT_NOTIFICATION (Para clientes)

INSERT INTO appointment_notification (id_cli, id_app, message)
SELECT id_cli,
       id_app,
       'Lembrete: Consulta agendada para o seu animal.'
FROM appointment
WHERE status_app = 'Scheduled'
LIMIT 20;

-- 4.7. INVOICE (Faturas das consultas terminadas)

INSERT INTO invoice (val_inv, dat_inv, bod_inv, id_app)
VALUES (50.00, '2027-05-01 11:00:00', 'Consulta Geral - Bobi', 1),
       (65.50, '2027-05-01 12:00:00', 'Consulta + Medicamento - Tareco', 2),
       (50.00, '2027-05-02 10:00:00', 'Consulta - Luna', 3),
       (60.00, '2027-05-02 11:30:00', 'Consulta + Limpeza - Mimi', 4);
