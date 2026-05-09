--=========================================================
-- MODULE 1: USER MANAGEMENT - DATA SEED (4X VOLUME)
--=========================================================
-- Purpose:
-- Populate the module with coherent operational data
-- for testing integrity, triggers, authentication,
-- attendance and RBAC logic at a larger scale.
--=========================================================



--=========================================================
-- 0. CLEAN DATA
--=========================================================

truncate table
    have,
    occupies,
    assistant,
    veterinarian,
    schedule,
    absence,
    clock_in,
    setup,
    login_record,
    employee,
    client,
    profile,
    permission,
    specialty,
    user_account
restart identity cascade;



--=========================================================
-- 1. USER_ACCOUNT
--=========================================================

insert into user_account (
    nam_usr,
    add_usr,
    pos_usr,
    nif_usr,
    pho_usr,
    ema_usr
)
values
('Ricardo Santos','Rua da Universidade, Braga','4700-001','251000001','+351910000001','ricardo@gmail.com'),
('Ana Silva','Rua das Flores, Braga','4700-002','251000002','+351910000002','ana@gmail.com'),
('Carlos Mendes','Avenida Central, Porto','4000-001','251000003','+351910000003','carlos@email.pt'),
('Maria Costa','Rua da Liberdade, Lisboa','1000-001','251000004','+351910000004','maria@email.pt'),
('Joao Ferreira','Rua do Hospital, Braga','4700-003','251000005','+351910000005','joao@email.pt'),
('Sofia Rocha','Rua do Sol, Porto','4000-002','251000006','+351910000006','sofia@email.pt'),
('Tiago Almeida','Rua Nova, Guimaraes','4800-001','251000007','+351910000007','tiago@email.pt'),
('Beatriz Sousa','Rua Verde, Braga','4700-004','251000008','+351910000008','beatriz@email.pt'),
('Pedro Nunes','Rua da Estrela, Braga','4700-005','251000009','+351910000009','pedro@email.com'),
('Ines Fernandes','Avenida dos Aliados, Porto','4000-003','251000010','+351910000010','ines.fernandes@example.com'),
('Marta Pinto','Rua do Comércio, Lisboa','1000-002','251000011','+351910000011','marta.pinto@example.com'),
('Miguel Oliveira','Rua do Bonfim, Porto','4000-004','251000012','+351910000012','miguel.oliveira@example.com'),
('Diana Cruz','Rua de Santa Catarina, Porto','4000-005','251000013','+351910000013','diana.cruz@example.com'),
('Bruno Moreira','Rua de São Paulo, Braga','4700-006','251000014','+351910000014','bruno.moreira@example.com'),
('Lara Santos','Rua do Carmo, Lisboa','1000-003','251000015','+351910000015','lara.santos@example.com'),
('Paulo Carvalho','Avenida da Liberdade, Lisboa','1000-004','251000016','+351910000016','paulo.carvalho@example.com'),
('Joana Lopes','Rua da Alegria, Porto','4000-006','251000017','+351910000017','joana.lopes@example.com'),
('Samuel Correia','Rua das Palmeiras, Braga','4700-007','251000018','+351910000018','samuel.correia@example.com'),
('Rita Lopes','Rua das Laranjeiras, Braga','4700-008','251000019','+351910000019','rita.lopes@example.com'),
('Francisco Neves','Rua de Santa Maria, Porto','4000-007','251000020','+351910000020','francisco.neves@example.com'),
('Diana Martins','Largo do Carmo, Lisboa','1000-005','251000021','+351910000021','diana.martins@example.com'),
('Hugo Matos','Avenida do Brasil, Porto','4000-008','251000022','+351910000022','hugo.matos@example.com'),
('Sara Azevedo','Rua da Palmela, Braga','4700-009','251000023','+351910000023','sara.azevedo@example.com'),
('Andre Pereira','Rua da Alegria, Braga','4700-010','251000024','+351910000024','andre.pereira@example.com'),
('Catarina Silva','Rua Nova, Lisboa','1000-006','251000025','+351910000025','catarina.silva@example.com'),
('Tomas Sousa','Rua do Comércio, Porto','4000-009','251000026','+351910000026','tomas.sousa@example.com'),
('Paula Gomes','Rua do Colégio, Braga','4700-011','251000027','+351910000027','paula.gomes@example.com'),
('Leonor Ribeiro','Avenida dos Aliados, Porto','4000-010','251000028','+351910000028','leonor.ribeiro@example.com'),
('Nuno Correia','Rua do Bonfim, Porto','4000-011','251000029','+351910000029','nuno.correia@example.com'),
('Marta Lopes','Rua da Betesga, Lisboa','1000-007','251000030','+351910000030','marta.lopes@example.com'),
('Joao Mendes','Rua de São Bento, Braga','4700-012','251000031','+351910000031','joao.mendes@example.com'),
('Claudia Alves','Rua de São Bento, Lisboa','1000-008','251000032','+351910000032','claudia.alves@example.com');



--=========================================================
-- 2. SETUP
--=========================================================

insert into setup (
    id_usr,
    the_set,
    lan_set
)
values
(1,'dark','pt-pt'),
(2,'light','pt-pt'),
(3,'dark','en-us'),
(4,'light','pt-pt'),
(5,'dark','pt-pt'),
(6,'light','en-us'),
(7,'dark','pt-pt'),
(8,'light','pt-pt'),
(9,'dark','en-us'),
(10,'light','pt-pt'),
(11,'dark','pt-pt'),
(12,'light','en-us'),
(13,'dark','pt-pt'),
(14,'light','pt-pt'),
(15,'dark','en-us'),
(16,'light','pt-pt'),
(17,'dark','pt-pt'),
(18,'light','en-us'),
(19,'dark','pt-pt'),
(20,'light','pt-pt'),
(21,'dark','en-us'),
(22,'light','pt-pt'),
(23,'dark','pt-pt'),
(24,'light','en-us'),
(25,'dark','pt-pt'),
(26,'light','pt-pt'),
(27,'dark','en-us'),
(28,'light','pt-pt'),
(29,'dark','pt-pt'),
(30,'light','en-us'),
(31,'dark','pt-pt'),
(32,'light','pt-pt');



--=========================================================
-- 3. EMPLOYEE
--=========================================================

insert into employee (
    id_usr,
    reg_dat_emp,
    aut_reg_emp,
    dea_dat_emp,
    aut_ina_emp,
    pho_emp,
    pho_emg,
    ema_emp,
    pas_emp
)
values

-- ========= USER 1 (Ricardo Santos): Progression over time =========
-- Former role: Assistant (2023-06 to 2024-01)
(1,'2023-06-10 09:00:00',2,'2024-01-10 17:00:00',2,
'+351253000001','+351911111101',
'ricardo.assist@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Administrator (2024-01-15 onwards - ACTIVE)
(1,'2024-01-15 09:00:00',2,null,null,
'+351253000001','+351911111111',
'ricardo@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 2 (Ana Silva): Veterinarian progression =========
-- Former role: General Veterinarian (2023-02 to 2024-02)
(2,'2023-02-20 10:00:00',1,'2024-02-15 16:30:00',1,
'+351253000002','+351911111102',
'ana.junior@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Senior Veterinarian (2024-02-20 onwards - ACTIVE)
(2,'2024-02-20 10:00:00',1,null,null,
'+351253000002','+351911111112',
'ana@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 3 (Carlos Mendes): Career change =========
-- Former role: Veterinarian (2024-01 to 2024-03)
(3,'2024-01-15 08:00:00',1,'2024-03-05 17:00:00',2,
'+351253000003','+351911111103',
'carlos.vet@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Assistant (2024-03-10 onwards - ACTIVE)
(3,'2024-03-10 08:00:00',2,null,null,
'+351253000003','+351911111113',
'carlos@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 4 (Maria Costa): Active Manager =========
(4,'2024-04-05 11:00:00',1,null,null,
'+351253000004','+351911111114',
'maria@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 5 (Joao Ferreira): Promotion pathway =========
-- Former role: Assistant (2024-01 to 2024-05)
(5,'2024-01-20 09:30:00',1,'2024-05-10 17:00:00',1,
'+351253000005','+351911111105',
'joao.assist@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Administrator (2024-05-12 onwards - ACTIVE)
(5,'2024-05-12 09:30:00',1,null,null,
'+351253000005','+351911111115',
'joao@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 6 (Sofia Rocha): Active Veterinarian =========
(6,'2024-06-18 10:15:00',1,null,null,
'+351253000006','+351911111116',
'sofia@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 7 (Tiago Almeida): Extended tenure =========
-- Former role: Manager (2023-07 to 2024-07)
(7,'2023-07-22 08:45:00',1,'2024-07-15 17:00:00',1,
'+351253000007','+351911111107',
'tiago.manager@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Assistant (2024-07-22 onwards - ACTIVE)
(7,'2024-07-22 08:45:00',1,null,null,
'+351253000007','+351911111117',
'tiago@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 8 (Beatriz Sousa): Active Manager =========
(8,'2024-08-14 09:00:00',1,null,null,
'+351253000008','+351911111118',
'beatriz@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 9 (Pedro Nunes): New staff with history =========
-- Former role: Clinical Assistant (2024-12 to 2025-01)
(9,'2024-12-15 09:00:00',1,'2025-01-08 16:00:00',2,
'+351253000009','+351911111109',
'pedro.assist@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Administrator (2025-01-10 onwards - ACTIVE)
(9,'2025-01-10 09:00:00',1,null,null,
'+351253000009','+351911111119',
'pedro@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 10 (Ines Fernandes): Active Veterinarian =========
(10,'2025-01-20 10:00:00',1,null,null,
'+351253000010','+351911111120',
'ines@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 11 (Marta Pinto): Career progression =========
-- Former role: Operational Assistant (2024-11 to 2025-02)
(11,'2024-11-10 10:00:00',2,'2025-02-10 16:00:00',1,
'+351253000011','+351911111131',
'marta.ops@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- Current role: Clinical Assistant (2025-02-15 onwards - ACTIVE)
(11,'2025-02-15 08:30:00',2,null,null,
'+351253000011','+351911111121',
'marta@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 12 (Miguel Oliveira): Active Manager =========
(12,'2025-03-01 09:15:00',2,null,null,
'+351253000012','+351911111122',
'miguel@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 13 (Diana Cruz): Active Administrator =========
(13,'2025-04-05 10:00:00',1,null,null,
'+351253000013','+351911111123',
'diana@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 14 (Bruno Moreira): Active Veterinarian =========
(14,'2025-05-10 08:45:00',2,null,null,
'+351253000014','+351911111124',
'bruno@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 15 (Lara Santos): Active Assistant =========
(15,'2025-06-01 09:30:00',1,null,null,
'+351253000015','+351911111125',
'lara@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 16 (Paulo Carvalho): Active Manager =========
(16,'2025-07-15 10:15:00',2,null,null,
'+351253000016','+351911111126',
'paulo@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 17 (Joana Lopes): Former Veterinarian =========
(17,'2024-01-10 09:00:00',1,'2024-11-30 18:00:00',2,
'+351253000017','+351911111127',
'joana.vet@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 18 (Samuel Correia): Assistant promoted to Veterinarian =========
(18,'2024-03-15 08:30:00',1,'2025-01-31 18:00:00',2,
'+351253000018','+351911111128',
'samuel@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 19 (Rita Lopes): Former Manager =========
(19,'2024-05-01 09:00:00',1,'2025-03-20 17:00:00',2,
'+351253000019','+351911111129',
'rita.manager@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 20 (Francisco Neves): Veterinarian on leave =========
(20,'2024-06-10 10:00:00',1,'2025-05-05 17:00:00',2,
'+351253000020','+351911111130',
'francisco.vet@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 21 (Diana Martins): Senior Veterinarian =========
(21,'2024-07-12 09:15:00',1,'2025-04-25 17:00:00',2,
'+351253000021','+351911111131',
'diana.martins@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 22 (Hugo Matos): Assistant promoted to Veterinarian =========
(22,'2024-08-01 08:45:00',1,'2025-02-28 17:00:00',2,
'+351253000022','+351911111132',
'hugo@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 23 (Sara Azevedo): Temporary Veterinarian =========
(23,'2024-11-15 09:00:00',1,'2024-12-31 17:00:00',2,
'+351253000023','+351911111133',
'sara.temp@miacaomigo.pt',
'hashed_password_secure_123456789'),

-- ========= USER 24 (Andre Pereira): Assistant promoted to Manager =========
(24,'2025-01-05 09:00:00',1,'2025-06-15 17:00:00',2,
'+351253000024','+351911111134',
'andre.manager@miacaomigo.pt',
'hashed_password_secure_123456789');



--=========================================================
-- 4. CLIENT
--=========================================================

insert into client (
    id_usr,
    pas_cli
)
values
(17,'hashed_password_secure_123456789'),
(18,'hashed_password_secure_123456789'),
(19,'hashed_password_secure_123456789'),
(20,'hashed_password_secure_123456789'),
(21,'hashed_password_secure_123456789'),
(22,'hashed_password_secure_123456789'),
(23,'hashed_password_secure_123456789'),
(24,'hashed_password_secure_123456789'),
(25,'hashed_password_secure_123456789'),
(26,'hashed_password_secure_123456789'),
(27,'hashed_password_secure_123456789'),
(28,'hashed_password_secure_123456789'),
(29,'hashed_password_secure_123456789'),
(30,'hashed_password_secure_123456789'),
(31,'hashed_password_secure_123456789'),
(32,'hashed_password_secure_123456789');



--=========================================================
-- 5. PROFILE
--=========================================================

insert into profile (
    nam_pro,
    des_pro
)
values
('administrador','system administration'),
('veterinario','clinical operations'),
('assistente','front desk and operational support'),
('gestor','management operations');



--=========================================================
-- 6. PERMISSION
--=========================================================

insert into permission (
    nam_per,
    des_per
)
values
('manage_users','manage system users'),
('manage_animals','manage animals'),
('manage_appointments','manage appointments'),
('manage_inventory','manage inventory'),
('view_reports','view operational reports'),
('manage_absences','manage employee absences');



--=========================================================
-- 7. HAVE
--=========================================================

insert into have (
    id_pro,
    id_per
)
values

-- administrador
(1,1),
(1,2),
(1,3),
(1,4),
(1,5),
(1,6),

-- veterinario
(2,2),
(2,3),
(2,5),

-- assistente
(3,3),

-- gestor
(4,5),
(4,6);



--=========================================================
-- 8. OCCUPIES (Role assignments including transitions)
--=========================================================

insert into occupies (
    id_emp,
    id_pro
)
values

-- ACTIVE EMPLOYEES - Current roles
(1,1),  -- Ricardo: administrador
(2,2),  -- Ana: veterinario
(3,3),  -- Carlos: assistente
(4,4),  -- Maria: gestor
(5,1),  -- Joao: administrador
(6,2),  -- Sofia: veterinario
(7,3),  -- Tiago: assistente
(8,4),  -- Beatriz: gestor
(9,1),  -- Pedro: administrador
(10,2), -- Ines: veterinario
(11,3), -- Marta: assistente
(12,4), -- Miguel: gestor
(13,1), -- Diana: administrador
(14,2), -- Bruno: veterinario
(15,3), -- Lara: assistente
(16,4), -- Paulo: gestor

-- INACTIVE EMPLOYEES - Role history (transitions over time)

-- Employee 17 (Antonio): Veterinarian
(17,2),  -- Antonio was veterinario

-- Employee 18 (Helena): Assistant -> Veterinarian (promotion)
(18,3),  -- Helena started as assistente
(18,2),  -- Helena promoted to veterinario

-- Employee 19 (Jorge): Manager -> Assistant (demotion/transition)
(19,4),  -- Jorge started as gestor
(19,3),  -- Jorge transitioned to assistente

-- Employee 20 (Filipa): Veterinarian (maternity leave)
(20,2),  -- Filipa was veterinario

-- Employee 21 (Dr. Eduardo): Veterinarian (specialization loss)
(21,2),  -- Eduardo was veterinario (lost specialty)

-- Employee 22 (Claudia): Assistant -> Veterinarian (career progression)
(22,3),  -- Claudia started as assistente
(22,2),  -- Claudia promoted to veterinario

-- Employee 23 (Temporario): Veterinarian (temporary contract)
(23,2),  -- Temporario was veterinario

-- Employee 24 (Monica): Assistant -> Manager -> Left
(24,3),  -- Monica started as assistente
(24,4);  -- Monica promoted to gestor before leaving



--=========================================================
-- 9. SPECIALTY
--=========================================================

insert into specialty (
    nam_spe,
    des_spe
)
values
('cirurgia geral','procedimentos cirurgicos'),
('medicina geral','consultas gerais'),
('dermatologia veterinaria','problemas dermatologicos'),
('ortopedia veterinaria','tratamentos ortopedicos');



--=========================================================
-- 10. SPECIALIZATION
--=========================================================

insert into veterinarian (
    id_emp,
    num_omv_vet
)
values

-- ACTIVE VETERINARIANS
(1,'OMV-1001'),    -- Ricardo
(2,'OMV-1002'),    -- Ana
(5,'OMV-1003'),    -- Joao
(6,'OMV-1004'),    -- Sofia
(9,'OMV-1005'),    -- Pedro
(10,'OMV-1006'),   -- Ines
(13,'OMV-1007'),   -- Diana
(14,'OMV-1008'),   -- Bruno

-- INACTIVE VETERINARIANS - Specialization history

-- Employee 17 (Antonio): Veterinarian - Orthopedics
(17,'OMV-2001'),   -- Antonio

-- Employee 18 (Helena): Advanced to Veterinarian with Dermatology
(18,'OMV-2002'),   -- Helena

-- Employee 20 (Filipa): Veterinarian - General Medicine (maternity leave)
(20,'OMV-2003'),   -- Filipa

-- Employee 21 (Dr. Eduardo): Lost Ortho specialization, only general practice recorded
-- Note: No longer has specialty (lost certification during tenure)
(21,'OMV-2004'),   -- Eduardo

-- Employee 22 (Claudia): Advanced to Veterinarian with Surgery specialization
(22,'OMV-2005'),   -- Claudia

-- Employee 23 (Temporario): Temporary Veterinarian - Dermatology
(23,'OMV-2006');   -- Temporario


--=========================================================
-- 10. EXPERT
--=========================================================

insert into expert (
    id_emp,
    id_spe
)
values
-- ACTIVE VETERINARIANS
(1,1),    -- Ricardo: cirurgia geral
(2,2),    -- Ana: medicina geral
(5,1),    -- Joao: cirurgia geral
(6,2),    -- Sofia: medicina geral
(9,3),    -- Pedro: dermatologia
(10,4),   -- Ines: ortopedia
(13,3),   -- Diana: dermatologia
(14,4),   -- Bruno: ortopedia

-- INACTIVE VETERINARIANS
(17,4),   -- Antonio: ortopedia
(18,3),   -- Helena: dermatologia
(20,2),   -- Filipa: medicina geral
(21,2),   -- Eduardo: only general medicine left
(22,1),   -- Claudia: cirurgia geral
(23,3);   -- Temporario: dermatologia


insert into assistant (
    id_emp,
    fun_ass
)
values

-- ACTIVE ASSISTANTS
(3,'assistente clinico'),      -- Carlos: assistente clinico
(4,'gestao operacional'),      -- Maria: gestao operacional
(7,'assistente clinico'),      -- Tiago: assistente clinico
(8,'gestao operacional'),      -- Beatriz: gestao operacional
(11,'assistente clinico'),     -- Marta: assistente clinico
(12,'gestao operacional'),     -- Miguel: gestao operacional
(15,'assistente clinico'),     -- Lara: assistente clinico
(16,'gestao operacional'),     -- Paulo: gestao operacional

-- INACTIVE ASSISTANTS - Function transitions

-- Employee 18 (Helena): Started as clinical assistant before promotion
(18,'assistente clinico'),     -- Helena was assistente clinico

-- Employee 19 (Jorge): Transitioned from operational to clinical then left
(19,'gestao operacional'),     -- Jorge started as gestao operacional

-- Employee 22 (Claudia): Started as operational assistant before promotion
(22,'assistente clinico'),     -- Claudia was assistente clinico

-- Employee 24 (Monica): Started as clinical assistant before promotion
(24,'assistente clinico');     -- Monica was assistente clinico



--=========================================================
-- 11. LOGIN_RECORD (Including sessions from inactive employees)
--=========================================================

insert into login_record (
    sig_tim_log,
    sou_tim_log,
    suc_log,
    ip_add_log,
    eml_usr,
    id_usr
)
values

-- SUCCESSFUL CLOSED SESSIONS - ACTIVE EMPLOYEES
(now() - interval '4 hours', now() - interval '2 hours', true, '192.168.1.10', 'ricardo@miacaomigo.pt', 1),
(now() - interval '5 hours', now() - interval '3 hours', true, '192.168.1.11', 'ana@miacaomigo.pt', 2),
(now() - interval '6 hours', now() - interval '4 hours', true, '192.168.1.12', 'carlos@miacaomigo.pt', 3),
(now() - interval '7 hours', now() - interval '5 hours', true, '192.168.1.13', 'maria@miacaomigo.pt', 4),

-- ACTIVE SUCCESSFUL SESSIONS - CURRENT STAFF
(now() - interval '1 hour', null, true, '192.168.1.20', 'ana@miacaomigo.pt', 2),
(now() - interval '40 minutes', null, true, '192.168.1.21', 'joao@miacaomigo.pt', 5),
(now() - interval '30 minutes', null, true, '192.168.1.22', 'sofia@miacaomigo.pt', 6),
(now() - interval '20 minutes', null, true, '192.168.1.23', 'tiago@miacaomigo.pt', 7),
(now() - interval '15 minutes', null, true, '192.168.1.24', 'pedro@miacaomigo.pt', 9),
(now() - interval '10 minutes', null, true, '192.168.1.25', 'ines@miacaomigo.pt', 10),

-- LOGIN HISTORY - INACTIVE EMPLOYEES (Last logins before deactivation)

-- Employee 17 (Antonio): Regular staff with access history
('2024-11-25 09:00:00', '2024-11-25 17:00:00', true, '192.168.10.10', 'antonio.silva@miacaomigo.pt', 17),
('2024-11-28 08:30:00', '2024-11-28 16:45:00', true, '192.168.10.11', 'antonio.silva@miacaomigo.pt', 17),
('2024-11-30 09:00:00', '2024-11-30 14:00:00', true, '192.168.10.12', 'antonio.silva@miacaomigo.pt', 17),

-- Employee 18 (Helena): Advanced career with login progression
('2025-01-20 10:00:00', '2025-01-20 17:30:00', true, '192.168.10.20', 'helena.santos@miacaomigo.pt', 18),
('2025-01-25 08:45:00', '2025-01-25 18:00:00', true, '192.168.10.21', 'helena.santos@miacaomigo.pt', 18),
('2025-01-31 10:00:00', '2025-01-31 12:30:00', true, '192.168.10.22', 'helena.santos@miacaomigo.pt', 18),

-- Employee 19 (Jorge): Manager with access attempts
('2025-03-10 08:00:00', '2025-03-10 16:30:00', true, '192.168.10.30', 'jorge.ferreira@miacaomigo.pt', 19),
('2025-03-14 09:15:00', '2025-03-14 17:45:00', true, '192.168.10.31', 'jorge.ferreira@miacaomigo.pt', 19),

-- Employee 20 (Filipa): Part-time with irregular access
('2025-04-20 10:00:00', '2025-04-20 14:00:00', true, '192.168.10.40', 'filipa.costa@miacaomigo.pt', 20),
('2025-04-30 10:15:00', '2025-04-30 13:45:00', true, '192.168.10.41', 'filipa.costa@miacaomigo.pt', 20),

-- Employee 21 (Dr. Eduardo): Specialist with full access history
('2025-04-15 08:30:00', '2025-04-15 17:30:00', true, '192.168.10.50', 'dr.eduardo.silva@miacaomigo.pt', 21),
('2025-04-18 09:00:00', '2025-04-18 18:00:00', true, '192.168.10.51', 'dr.eduardo.silva@miacaomigo.pt', 21),
('2025-04-20 08:45:00', '2025-04-20 17:15:00', true, '192.168.10.52', 'dr.eduardo.silva@miacaomigo.pt', 21),

-- Employee 22 (Claudia): Long-term staff with extensive access history
('2025-02-20 08:00:00', '2025-02-20 17:00:00', true, '192.168.10.60', 'claudia.oliveira@miacaomigo.pt', 22),
('2025-02-25 08:30:00', '2025-02-25 18:30:00', true, '192.168.10.61', 'claudia.oliveira@miacaomigo.pt', 22),

-- Employee 23 (Temporario): Temporary contractor with limited access
('2024-12-20 09:00:00', '2024-12-20 17:00:00', true, '192.168.10.70', 'temporario.vet@miacaomigo.pt', 23),
('2024-12-31 09:00:00', '2024-12-31 16:00:00', true, '192.168.10.71', 'temporario.vet@miacaomigo.pt', 23),

-- Employee 24 (Monica): Manager with promotion history
('2025-06-10 08:00:00', '2025-06-10 18:00:00', true, '192.168.10.80', 'monica.gomes@miacaomigo.pt', 24),
('2025-06-12 08:30:00', '2025-06-12 17:30:00', true, '192.168.10.81', 'monica.gomes@miacaomigo.pt', 24),

-- FAILED LOGIN ATTEMPTS
(now() - interval '10 minutes', null, false, '192.168.1.40', 'unknown@email.pt', null),
(now() - interval '8 minutes', null, false, '192.168.1.41', 'invalid@example.com', null),
(now() - interval '6 minutes', null, false, '192.168.1.42', 'admin@miacaomigo.pt', null),
(now() - interval '4 minutes', null, false, '192.168.1.43', 'marta.santos@example.com', null);



--=========================================================
-- 12. SCHEDULE (Including transitions and inactive employees)
--=========================================================

insert into schedule (
    id_emp,
    day_wee_sch,
    sta_tim_sch,
    fin_hou_sch
)
values

--=========================================================
-- ACTIVE EMPLOYEES - CURRENT SCHEDULES
--=========================================================

-- Employee 2 (Ana): Current veterinarian schedule
(2,1,'10:00','19:00'),
(2,2,'10:00','19:00'),
(2,3,'10:00','19:00'),
(2,4,'10:00','19:00'),

-- Employee 4 (Maria): Management schedule
(4,1,'09:00','18:00'),
(4,2,'09:00','18:00'),
(4,5,'09:00','18:00'),

-- Employee 6 (Sofia): Veterinarian schedule
(6,1,'09:00','18:00'),
(6,2,'09:00','18:00'),
(6,3,'09:00','18:00'),

-- Employee 8 (Beatriz): Operational management
(8,2,'11:00','20:00'),
(8,3,'11:00','20:00'),
(8,4,'11:00','20:00'),

-- Employee 10 (Ines): Specialist veterinarian
(10,1,'08:00','17:00'),
(10,2,'08:00','17:00'),
(10,3,'08:00','17:00'),

-- Employee 12 (Miguel): Administrative management
(12,1,'08:00','16:00'),
(12,2,'08:00','16:00'),
(12,3,'08:00','16:00'),

-- Employee 13 (Diana): Administrator
(13,1,'09:00','18:00'),
(13,2,'09:00','18:00'),
(13,3,'09:00','18:00'),

-- Employee 14 (Bruno): Orthopedic veterinarian
(14,3,'10:00','19:00'),
(14,4,'10:00','19:00'),
(14,5,'10:00','19:00'),

-- Employee 15 (Lara): Clinical assistant
(15,1,'09:00','18:00'),
(15,2,'09:00','18:00'),

-- Employee 16 (Paulo): Manager
(16,4,'10:00','19:00'),
(16,5,'10:00','19:00'),

--=========================================================
-- HISTORICAL EMPLOYEE RECORDS (same id_usr, different id_emp)
--=========================================================

-- Employee 1 (Ricardo): Former assistant schedule
(1,1,'08:00','17:00'),
(1,2,'08:00','17:00'),
(1,3,'08:00','17:00'),

-- Employee 3 (Carlos): Former veterinarian schedule
(3,1,'10:00','19:00'),
(3,2,'10:00','19:00'),
(3,3,'10:00','19:00'),

-- Employee 5 (Joao): Former assistant schedule
(5,1,'08:30','17:30'),
(5,2,'08:30','17:30'),
(5,3,'08:30','17:30'),

-- Employee 7 (Tiago): Former manager schedule
(7,1,'08:00','17:00'),
(7,2,'08:00','17:00'),
(7,3,'08:00','17:00'),
(7,4,'08:00','17:00'),

-- Employee 9 (Pedro): Former assistant schedule
(9,1,'09:00','18:00'),
(9,2,'09:00','18:00'),

-- Employee 11 (Marta): Former operational assistant schedule
(11,1,'10:00','19:00'),
(11,2,'10:00','19:00'),

--=========================================================
-- INACTIVE EMPLOYEES - Historical schedules
--=========================================================

-- Employee 17 (Antonio): Orthopedic veterinarian
(17,1,'09:00','18:00'),
(17,2,'09:00','18:00'),
(17,3,'09:00','18:00'),
(17,4,'09:00','18:00'),

-- Employee 18 (Helena): Assistant then veterinarian
(18,2,'08:00','17:00'),
(18,3,'08:00','17:00'),
(18,4,'10:00','19:00'),

-- Employee 19 (Jorge): Management transition
(19,1,'08:00','17:00'),
(19,2,'08:00','17:00'),
(19,3,'08:00','17:00'),

-- Employee 20 (Filipa): Part-time veterinarian
(20,1,'10:00','14:00'),
(20,3,'10:00','14:00'),

-- Employee 21 (Dr. Eduardo): Senior veterinarian
(21,1,'09:00','18:00'),
(21,2,'09:00','18:00'),
(21,3,'09:00','18:00'),
(21,5,'09:00','18:00'),

-- Employee 22 (Claudia): Assistant progression
(22,1,'08:00','17:00'),
(22,2,'08:00','17:00'),
(22,3,'10:00','19:00'),

-- Employee 23 (Temporario): Temporary veterinarian
(23,1,'09:00','18:00'),
(23,2,'09:00','18:00'),
(23,4,'09:00','18:00'),

-- Employee 24 (Monica): Assistant to manager transition
(24,1,'08:00','17:00'),
(24,2,'08:00','17:00'),
(24,3,'09:00','18:00'),
(24,4,'09:00','18:00');



--=========================================================
-- 13. CLOCK_IN (Comprehensive attendance records including anomalies)
--=========================================================

insert into clock_in (
    id_emp,
    sta_dat_clk,
    end_dat_clk
)
values

-- ACTIVE EMPLOYEES - Current attendance

-- finished attendance (today)
(1, now() - interval '5 hours', now() - interval '1 hour'),
(2, now() - interval '6 hours', now() - interval '2 hours'),
(3, now() - interval '7 hours', now() - interval '3 hours'),
(4, now() - interval '8 hours', now() - interval '4 hours'),

-- active attendance (still working)
(5, now() - interval '2 hours', null),
(6, now() - interval '3 hours', null),
(7, now() - interval '1 hour', null),
(8, now() - interval '45 minutes', null),

-- NEW EMPLOYEES - Recent attendance

(9, now() - interval '4 hours', now() - interval '30 minutes'),
(10, now() - interval '3 hours', null),
(11, now() - interval '2 hours', now() - interval '15 minutes'),
(12, now() - interval '5 hours', now() - interval '1 hour'),

-- LATE CLOCK INS

-- Employee arrived late but completed workday
(13,'2026-04-10 10:30:00','2026-04-10 18:00:00'),

-- Employee arrived extremely late
(14,'2026-04-11 13:00:00','2026-04-11 19:00:00'),

-- EARLY LEAVES

-- Employee left before shift ended
(15,'2026-04-12 09:00:00','2026-04-12 15:00:00'),

-- Employee emergency early exit
(16,'2026-04-13 08:00:00','2026-04-13 11:30:00'),

-- OVERTIME RECORDS

-- Employee worked overtime
(1,'2026-04-14 09:00:00','2026-04-14 21:00:00'),

-- Night overtime after emergency surgery
(2,'2026-04-15 10:00:00','2026-04-15 23:30:00'),

-- DOUBLE CLOCK IN SCENARIOS

-- Lunch break split attendance
(5,'2026-04-16 08:00:00','2026-04-16 12:00:00'),
(5,'2026-04-16 13:00:00','2026-04-16 18:00:00'),

-- Training interruption
(6,'2026-04-17 09:00:00','2026-04-17 11:00:00'),
(6,'2026-04-17 14:00:00','2026-04-17 19:00:00'),

-- OPEN / UNCLOSED SESSIONS

-- Forgot to clock out
(7,'2026-04-18 09:00:00',null),

-- System crash before checkout
(8,'2026-04-18 10:00:00',null),

-- INVALID / ANOMALY TEST CASES

-- Very short accidental clock in
(9,'2026-04-19 09:00:00','2026-04-19 09:02:00'),

-- Overnight shift anomaly
(10,'2026-04-20 22:00:00','2026-04-21 06:00:00'),

-- Consecutive long shifts
(11,'2026-04-21 08:00:00','2026-04-21 22:00:00'),
(11,'2026-04-22 08:00:00','2026-04-22 21:00:00'),

-- WEEKEND WORK

(12,'2026-04-25 09:00:00','2026-04-25 13:00:00'),
(13,'2026-04-26 10:00:00','2026-04-26 14:00:00'),

-- INACTIVE EMPLOYEES - Historical attendance records

-- Employee 17 (Antonio): Last day attendance
(17,'2024-11-30 09:00:00','2024-11-30 17:00:00'),

-- Employee 18 (Helena): Multiple recent attendances before leaving
(18,'2025-01-28 08:30:00','2025-01-28 17:30:00'),
(18,'2025-01-29 08:45:00','2025-01-29 17:45:00'),
(18,'2025-01-31 10:00:00','2025-01-31 12:00:00'),

-- Employee 19 (Jorge): Manager schedule
(19,'2025-03-13 08:00:00','2025-03-13 17:00:00'),
(19,'2025-03-14 08:15:00','2025-03-14 16:45:00'),
(19,'2025-03-15 08:00:00','2025-03-15 15:30:00'),

-- Employee 20 (Filipa): Part-time record
(20,'2025-04-28 10:00:00','2025-04-28 14:00:00'),
(20,'2025-04-30 10:15:00','2025-04-30 13:45:00'),
(20,'2025-05-01 10:00:00','2025-05-01 12:00:00'),

-- Employee 21 (Dr. Eduardo): Full records
(21,'2025-04-18 08:45:00','2025-04-18 17:30:00'),
(21,'2025-04-19 08:30:00','2025-04-19 17:15:00'),
(21,'2025-04-20 09:00:00','2025-04-20 17:00:00'),

-- Employee 22 (Claudia): Extended career attendance
(22,'2025-02-24 08:00:00','2025-02-24 17:00:00'),
(22,'2025-02-25 08:30:00','2025-02-25 18:30:00'),
(22,'2025-02-26 08:00:00','2025-02-26 17:30:00'),

-- Employee 23 (Temporario): Temporary contract
(23,'2024-12-30 09:00:00','2024-12-30 17:00:00'),
(23,'2024-12-31 09:00:00','2024-12-31 16:00:00'),

-- Employee 24 (Monica): Final days
(24,'2025-06-13 08:00:00','2025-06-13 18:00:00'),
(24,'2025-06-14 08:30:00','2025-06-14 17:30:00'),
(24,'2025-06-15 08:00:00','2025-06-15 17:00:00');


--=========================================================
-- 14. ABSENCE (Including inactive employees absence records)
--=========================================================

insert into absence (
    id_emp,
    sta_dat_tim_abs,
    end_dat_tim_abs,
    mot_abs,
    sta_abs
)
values

--=========================================================
-- ACTIVE EMPLOYEES - CURRENT / RECENT ABSENCES
--=========================================================

(3,'2026-05-10 09:00:00','2026-05-10 18:00:00',
'consulta medica','approved'),

(4,'2026-05-11 09:00:00','2026-05-15 18:00:00',
'ferias','pending'),

(5,'2026-05-12 09:00:00','2026-05-12 14:00:00',
'formacao interna','approved'),

(6,'2026-05-13 09:00:00','2026-05-17 18:00:00',
'ferias','pending'),

(7,'2026-05-14 09:00:00','2026-05-14 18:00:00',
'consulta especial','approved'),

(8,'2026-05-15 09:00:00','2026-05-15 18:00:00',
'dia pessoal','pending'),

(9,'2026-05-16 09:00:00','2026-05-16 18:00:00',
'agendamento medico','approved'),

(10,'2026-05-17 09:00:00','2026-05-18 18:00:00',
'ferias','pending'),

--=========================================================
-- NEW EMPLOYEES - ABSENCE RECORDS
--=========================================================

(11,'2026-05-08 09:00:00','2026-05-08 12:00:00',
'consulta dentaria','approved'),

(12,'2026-05-09 09:00:00','2026-05-10 18:00:00',
'motivo pessoal','pending'),

--=========================================================
-- REJECTED ABSENCE REQUESTS
--=========================================================

(5,'2026-06-01 09:00:00','2026-06-10 18:00:00',
'ferias verao','rejected'),

(7,'2026-05-20 09:00:00','2026-05-22 18:00:00',
'viagem pessoal','rejected'),

(10,'2026-07-01 09:00:00','2026-07-05 18:00:00',
'ferias','rejected'),

--=========================================================
-- CANCELLED ABSENCES
--=========================================================

(4,'2026-06-15 09:00:00','2026-06-20 18:00:00',
'ferias familiares','cancelled'),

(11,'2026-05-25 09:00:00','2026-05-25 18:00:00',
'consulta rotina','cancelled'),

--=========================================================
-- SYSTEM DETECTED ABSENCES
--=========================================================
-- Automatically generated when employee fails to clock in
-- and the expected work schedule has already ended

(3,'2026-04-10 08:00:00','2026-04-10 23:59:00',
'falta sem clock in','detected'),

(7,'2026-03-02 09:00:00','2026-03-04 23:59:00',
'faltas consecutivas','detected'),

(12,'2026-04-18 08:00:00','2026-04-18 23:59:00',
'ausencia parcial automatica','detected'),

(15,'2026-04-21 09:00:00','2026-04-21 23:59:00',
'nao compareceu ao turno','detected'),

(6,'2026-02-08 10:00:00','2026-02-08 23:59:00',
'falta automatica','detected'),

--=========================================================
-- RETROACTIVE APPROVALS
--=========================================================

(6,'2026-02-14 09:00:00','2026-02-14 18:00:00',
'consulta urgente','approved'),

(9,'2026-01-22 09:00:00','2026-01-24 18:00:00',
'emergencia familiar','approved'),

--=========================================================
-- LONG TERM / MEDICAL ABSENCES
--=========================================================

(2,'2026-08-01 09:00:00','2026-08-30 18:00:00',
'baixa medica prolongada','approved'),

(14,'2026-09-10 09:00:00','2026-09-17 18:00:00',
'recuperacao pos cirurgica','approved'),

--=========================================================
-- TRAINING / CERTIFICATION ABSENCES
--=========================================================

(1,'2026-07-10 09:00:00','2026-07-12 18:00:00',
'formacao administracao','approved'),

(13,'2026-10-02 09:00:00','2026-10-04 18:00:00',
'certificacao veterinaria','approved'),

--=========================================================
-- INACTIVE EMPLOYEES - HISTORICAL ABSENCE RECORDS
--=========================================================

-- Employee 17 (Joana Lopes): Medical and vacation absences

(17,'2024-10-15 09:00:00','2024-10-15 18:00:00',
'consulta especialista','approved'),

(17,'2024-11-01 09:00:00','2024-11-08 18:00:00',
'ferias','approved'),

-- Employee 18 (Samuel Correia): Career progression absences

(18,'2024-12-20 09:00:00','2025-01-03 18:00:00',
'ferias natal','approved'),

(18,'2025-01-15 09:00:00','2025-01-15 17:00:00',
'formacao profissional','approved'),

-- Employee 19 (Rita Lopes): Management-related absences

(19,'2025-02-10 09:00:00','2025-02-10 18:00:00',
'conferencia gestao','approved'),

(19,'2025-03-01 09:00:00','2025-03-07 18:00:00',
'ferias','approved'),

-- Employee 20 (Francisco Neves): Maternity and medical absences

(20,'2024-12-15 09:00:00','2025-05-01 18:00:00',
'licenca maternidade','approved'),

(20,'2025-04-20 09:00:00','2025-04-25 18:00:00',
'consulta pediatra','approved'),

-- Employee 21 (Diana Martins): Specialist absence

(21,'2025-03-10 09:00:00','2025-03-10 18:00:00',
'seminario ortopedia','approved'),

(21,'2025-04-01 09:00:00','2025-04-08 18:00:00',
'ferias primavera','approved'),

-- Employee 22 (Hugo Matos): Long-term staff absences

(22,'2024-12-23 09:00:00','2025-01-05 18:00:00',
'ferias fim ano','approved'),

(22,'2025-02-14 09:00:00','2025-02-21 18:00:00',
'ferias carnaval','approved'),

-- Employee 23 (Sara Azevedo): Limited absences

(23,'2024-12-24 09:00:00','2024-12-27 18:00:00',
'ferias natal','approved'),

-- Employee 24 (Andre Pereira): Management transition absences

(24,'2025-05-20 09:00:00','2025-05-23 18:00:00',
'conferencia lideranca','approved'),

(24,'2025-06-01 09:00:00','2025-06-08 18:00:00',
'ferias transicao','pending');
