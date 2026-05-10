--=========================================================
-- MODULE 1: USER MANAGEMENT — ENTERPRISE INTEGRITY SEED
--=========================================================
-- Purpose:
--   Production-like dataset for Module 1 that respects every
--   constraint, trigger, partial unique index, and exclusion rule.
--
-- Identity map (id_emp assigned in INSERT order, 1..N):
--   1-2   user 1 Ricardo   (former assist / active admin)
--   3-4   user 2 Ana       (former vet / active vet)
--   5-6   user 3 Carlos    (former vet / active assist)
--   7     user 4 Maria     (gestor)
--   8-9   user 5 João      (former assist / active admin)
--   10    user 6 Sofia     (vet)
--   11-12 user 7 Tiago     (former gestor / active assist)
--   13    user 8 Beatriz   (gestor)
--   14-15 user 9 Pedro     (former assist / active admin)
--   16    user 10 Inês     (vet)
--   17-18 user 11 Marta    (former ops / active assist)
--   19    user 12 Miguel   (gestor)
--   20    user 13 Diana C. (admin + vet registrado)
--   21    user 14 Bruno    (vet)
--   22    user 15 Lara     (assist)
--   23    user 16 Paulo    (gestor)
--   24    user 17 Joana    (inactive vet)
--   25-26 user 18 Samuel   (former assist / active vet)
--   27    user 19 Rita     (inactive gestor)
--   28    user 20 Francisco (inactive vet)
--   29    user 21 Diana M. (inactive vet)
--   30-31 user 22 Hugo     (former assist / active vet)
--   32    user 23 Sara     (inactive temp vet)
--   33    user 24 André    (inactive gestor)
--   34    user 25 Catarina (trainee)
--   35    user 26 Tomás    (vet)
--   36    user 27 Paula    (assist)
--   37    user 28 Leonor   (gestor)
--   38    user 29 Nuno     (vet)
--   39    user 30 Marta D. (assist)
--   40    user 31 Teresa   (admin)
--   41    user 32 Filipe   (vet)
--
-- Trigger highlights:
--   * assistant ∩ veterinarian = ∅ (same id_emp)
--   * clock_in insert blocked if sta_dat_clk ∈ absence[pending|approved|detected]
--   * absence overlap forbidden per id_usr for active states
--   * uq_clock_in_active_per_employee, uq_employee_active_per_user,
--     uq_login_single_active_session_email
--=========================================================


--=========================================================
-- 0. RESET
--=========================================================

truncate table
    have,
    occupies,
    expert,
    assistant,
    veterinarian,
    schedule,
    absence,
    clock_in,
    login_record,
    setup,
    client,
    employee,
    permission,
    profile,
    specialty,
    user_account
restart identity cascade;


--=========================================================
-- 1. PERMISSIONS
--=========================================================

insert into permission (nam_per, des_per) values
    ('manage_users', 'create, update, and deactivate user accounts and employee bindings'),
    ('manage_roles', 'assign profiles and audit occupies / have relationships'),
    ('manage_animals', 'full animal registry lifecycle including transfers'),
    ('manage_appointments', 'scheduling, status transitions, and clinical linkage'),
    ('manage_inventory', 'stock, purchasing, and product catalog operations'),
    ('view_reports', 'read-only operational dashboards and exports'),
    ('manage_absences', 'approve or reject absence workflows'),
    ('audit_security', 'review authentication telemetry and login anomalies'),
    ('manage_billing', 'invoice headers, payments, and revenue recognition');


--=========================================================
-- 2. PROFILES
--=========================================================

insert into profile (nam_pro, des_pro) values
    ('administrador', 'full platform governance including user and security administration'),
    ('veterinario', 'clinical staff with regulated professional identifiers'),
    ('assistente clínico', 'front-desk and peri-clinical operational support'),
    ('gestor clínico', 'practice management, staffing, and compliance oversight'),
    ('estagiario', 'supervised clinical trainee with restricted permissions');


--=========================================================
-- 3. HAVE (profile × permission)
--=========================================================

insert into have (id_pro, id_per) values
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9),
    (2, 3), (2, 4), (2, 6),
    (3, 4), (3, 6),
    (4, 2), (4, 5), (4, 6), (4, 7), (4, 9),
    (5, 6);


--=========================================================
-- 4. SPECIALTIES
--=========================================================

insert into specialty (nam_spe, des_spe) values
    ('medicina interna', 'diagnostico e tratamento de doencas sistemicas em pequenos animais'),
    ('cirurgia de tegumentos', 'procedimentos cirurgicos dermatologicos e reconstrucao simples'),
    ('ortopedia', 'avaliacao e tratamento de patologias musculo esqueleticas'),
    ('dermatologia', 'alergias cutaneas, parasitas e terapeutica topica prolongada'),
    ('anestesiologia', 'protocolos de sedacao, analgesia multimodal e monitorizacao'),
    ('imagiologia', 'interpretacao de estudos de imagem e integracao com historico clinico'),
    ('medicina felina', 'consultas especializadas para comportamento e medicina preventiva felina'),
    ('oncologia basica', 'estadiaamento inicial, quimioterapia de manutencao e suporte paliativo');


--=========================================================
-- 5. USER_ACCOUNT
--=========================================================

insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) values
    ('Ricardo Manuel Santos', 'Rua do Souto 14, Braga', '4700-304', '501964321', '+351912345001', 'ricardo.ms.santos@gmail.com'),
    ('Ana Beatriz Silva', 'Praceta das Camélias 3, Porto', '4050-162', '502073412', '+351912345002', 'ana.b.silva@sapo.pt'),
    ('Carlos Filipe Mendes', 'Avenida da Boavista 812, Porto', '4100-111', '503182503', '+351912345003', 'cfmendes@outlook.pt'),
    ('Maria Inês Costa', 'Rua Garrett 44, Lisboa', '1200-204', '504291594', '+351912345004', 'maria.ines.costa@icloud.com'),
    ('João Pedro Ferreira', 'Rua dos Capelistas 21, Braga', '4700-442', '505300685', '+351912345005', 'jpferreira@yahoo.com'),
    ('Sofia Margarida Rocha', 'Rua de Cedofeita 118, Porto', '4050-182', '506419776', '+351912345006', 'sofia.m.rocha@me.com'),
    ('Tiago André Almeida', 'Largo do Toural 6, Guimarães', '4810-431', '507528867', '+351912345007', 'tiago.almeida@gmail.com'),
    ('Beatriz Leonor Sousa', 'Rua do Raio 190, Braga', '4700-223', '508637958', '+351912345008', 'bleonor.sousa@sapo.pt'),
    ('Pedro Miguel Nunes', 'Rua Formosa 214, Porto', '4000-252', '509747049', '+351912345009', 'pedro.nunes.email@gmail.com'),
    ('Inês Matilde Fernandes', 'Rua da Boavista 112, Braga', '4710-057', '510856130', '+351912345010', 'ines.fernandes@proton.me'),
    ('Marta Filipa Pinto', 'Avenida Almirante Reis 88, Lisboa', '1150-019', '511965221', '+351912345011', 'marta.pinto.contact@gmail.com'),
    ('Miguel Tomás Oliveira', 'Rua de Santa Catarina 312, Porto', '4000-442', '512074312', '+351912345012', 'mtoliveira@outlook.com'),
    ('Diana Raquel Cruz', 'Rua do Almada 55, Porto', '4050-036', '513183403', '+351912345013', 'diana.cruz.mail@sapo.pt'),
    ('Bruno Filipe Moreira', 'Rua dos Biscainhos 9, Braga', '4700-415', '514292494', '+351912345014', 'bruno.moreira@gmail.com'),
    ('Lara Sofia Santos', 'Rua da Escola Politécnica 58, Lisboa', '1250-099', '515401585', '+351912345015', 'lara.santos.pt@icloud.com'),
    ('Paulo Jorge Carvalho', 'Avenida da República 52, Lisboa', '1050-196', '516510676', '+351912345016', 'paulo.carvalho@yahoo.com'),
    ('Joana Rita Lopes', 'Rua de Miguel Bombarda 217, Porto', '4050-381', '517619767', '+351912345017', 'joana.lopes.inbox@gmail.com'),
    ('Samuel Duarte Correia', 'Rua do Carmo 31, Braga', '4700-309', '518728858', '+351912345018', 'samuel.correia@sapo.pt'),
    ('Rita Catarina Lopes', 'Travessa de São Sebastião 4, Braga', '4700-495', '519837949', '+351912345019', 'rita.lopes.email@gmail.com'),
    ('Francisco Manuel Neves', 'Rua de José Falcão 138, Porto', '4000-191', '520947030', '+351912345020', 'f.neves@outlook.pt'),
    ('Diana Patrícia Martins', 'Rua das Portas de Santo Antão 86, Lisboa', '1150-268', '521056121', '+351912345021', 'diana.martins.pt@gmail.com'),
    ('Hugo Daniel Matos', 'Rua Gonçalo Sampaio 215, Porto', '4150-564', '522165212', '+351912345022', 'hugo.matos@me.com'),
    ('Sara Luísa Azevedo', 'Rua dos Chãos 44, Braga', '4700-210', '523274303', '+351912345023', 'sara.azevedo@sapo.pt'),
    ('André Gustavo Pereira', 'Rua do Monte 17, Guimarães', '4810-041', '524383394', '+351912345024', 'andre.pereira@gmail.com'),
    ('Catarina Filipa Vieira', 'Rua Augusta 220, Lisboa', '1100-053', '525492485', '+351912345025', 'catarina.vieira@icloud.com'),
    ('Tomás Henrique Sousa', 'Rua de Cedofeita 402, Porto', '4050-182', '526601576', '+351912345026', 'tomas.sousa@yahoo.com'),
    ('Paula Cristina Gomes', 'Rua do Souto 88, Braga', '4700-304', '527710667', '+351912345027', 'paula.gomes.mail@gmail.com'),
    ('Leonor Matilde Ribeiro', 'Avenida dos Aliados 70, Porto', '4000-064', '528819758', '+351912345028', 'leonor.ribeiro@sapo.pt'),
    ('Nuno Ricardo Correia', 'Rua da Alegria 955, Porto', '4000-037', '529928849', '+351912345029', 'nuno.correia@outlook.com'),
    ('Marta Isabel Duarte', 'Rua da Prata 66, Lisboa', '1100-413', '530037930', '+351912345030', 'marta.duarte@gmail.com'),
    ('Cláudia Sofia Alves', 'Rua do Ouro 256, Lisboa', '1200-109', '531147021', '+351912345031', 'claudia.alves.pt@me.com'),
    ('Teresa Manuela Faria', 'Rua da Carreira 12, Coimbra', '3000-048', '532256112', '+351912345032', 'teresa.faria@sapo.pt'),
    ('Filipe Augusto Ramos', 'Rua Ferreira Borges 76, Aveiro', '3800-041', '533365203', '+351912345033', 'filipe.ramos@gmail.com'),
    ('Helena Patrícia Moura', 'Rua Direita 105, Viseu', '3500-082', '534474294', '+351912345034', 'helena.moura@icloud.com'),
    ('Jorge Manuel Teixeira', 'Rua da Sé 3, Faro', '8000-082', '535583385', '+351912345035', 'jorge.teixeira@yahoo.com'),
    ('Filipa Raquel Monteiro', 'Rua de Santo António 44, Leiria', '2400-122', '536692476', '+351912345036', 'filipa.monteiro@gmail.com'),
    ('Eduardo Luís Branco', 'Rua João de Deus 18, Setúbal', '2910-091', '537801567', '+351912345037', 'eduardo.branco@sapo.pt'),
    ('Cláudia Raquel Oliveira', 'Rua Alexandre Herculano 210, Braga', '4700-030', '538910658', '+351912345038', 'claudia.r.oliveira@gmail.com'),
    ('Mónica Filipa Gomes', 'Rua do Almada 120, Porto', '4050-036', '539019749', '+351912345039', 'monica.gomes@outlook.com'),
    ('Rui Alexandre Pires', 'Rua da Misericórdia 9, Évora', '7000-645', '540128830', '+351912345040', 'ruipires.cliente@gmail.com'),
    ('Leonardo Tomás Matos', 'Rua de São João 44, Aveiro', '3810-200', '541237921', '+351912345041', 'leonardo.matos@sapo.pt'),
    ('Carla Filipa Sequeira', 'Rua do Carmo 55, Braga', '4700-309', '542347012', '+351912345042', 'carla.sequeira@icloud.com'),
    ('Vasco Miguel Lopes', 'Avenida Central 402, Matosinhos', '4450-291', '543456103', '+351912345043', 'vasco.lopes@yahoo.com'),
    ('Patrícia Sofia Henriques', 'Rua da Boavista 640, Porto', '4050-111', '544565194', '+351912345044', 'patricia.henriques@gmail.com'),
    ('Gonçalo Filipe Castro', 'Rua Garrett 12, Lisboa', '1200-204', '545674285', '+351912345045', 'goncalo.castro@me.com'),
    ('Andreia Cristina Lourenço', 'Rua de Camões 77, Lisboa', '1150-082', '546783376', '+351912345046', 'andreia.lourenco@sapo.pt'),
    ('Duarte Manuel Serafim', 'Rua do Almada 18, Porto', '4050-036', '547892467', '+351912345047', 'duarte.serafim@gmail.com'),
    ('Margarida Leonor Pratas', 'Rua dos Capelistas 5, Braga', '4700-442', '548901558', '+351912345048', 'margarida.pratas@outlook.com');


--=========================================================
-- 6. SETUP
--=========================================================

insert into setup (id_usr, the_set, lan_set)
select u.id_usr,
       case when u.id_usr % 3 = 0 then 'dark' else 'light' end,
       case when u.id_usr % 4 = 0 then 'en-us' else 'pt-pt' end
from user_account u
where u.id_usr between 1 and 40;


--=========================================================
-- 7. EMPLOYEE (aut_reg_emp / aut_ina_emp null — optional FK filled in §7b)
--=========================================================

insert into employee (id_usr, reg_dat_emp, aut_reg_emp, dea_dat_emp, aut_ina_emp, pho_emp, pho_emg, ema_emp, pas_emp) values
    (1, '2022-08-15 08:30:00', null, '2023-11-20 18:00:00', null, '+351253440101', '+351912340101', 'ricardo.legacy.assist@miacaomigo.pt', '$2b$12$assistlegacyhash00000001'),
    (1, '2023-11-25 09:00:00', null, null, null, '+351253440001', '+351912340001', 'ricardo.santos@miacaomigo.pt', '$2b$12$ricardoadmhashvalue000001'),
    (2, '2021-04-12 09:15:00', null, '2024-03-01 17:45:00', null, '+351253440102', '+351912340102', 'ana.junior.vet@miacaomigo.pt', '$2b$12$anajuniorhashvalue00000002'),
    (2, '2024-03-04 09:15:00', null, null, null, '+351253440002', '+351912340002', 'ana.silva@miacaomigo.pt', '$2b$12$anavetseniorhashval000002'),
    (3, '2023-01-10 08:45:00', null, '2024-06-12 17:30:00', null, '+351253440103', '+351912340103', 'carlos.vet.legacy@miacaomigo.pt', '$2b$12$carlosvetlegacyhash00003'),
    (3, '2024-06-17 08:45:00', null, null, null, '+351253440003', '+351912340003', 'carlos.mendes@miacaomigo.pt', '$2b$12$carlosassisthashval000003'),
    (4, '2022-11-05 10:00:00', null, null, null, '+351253440004', '+351912340004', 'maria.costa@miacaomigo.pt', '$2b$12$mariacostamanager00000004'),
    (5, '2023-05-22 09:00:00', null, '2025-01-15 17:00:00', null, '+351253440105', '+351912340105', 'joao.assist.legacy@miacaomigo.pt', '$2b$12$joaoassistlegacyhash000005'),
    (5, '2025-01-20 09:00:00', null, null, null, '+351253440005', '+351912340005', 'joao.ferreira@miacaomigo.pt', '$2b$12$joaoferreiraadmhash000005'),
    (6, '2020-09-01 08:30:00', null, null, null, '+351253440006', '+351912340006', 'sofia.rocha@miacaomigo.pt', '$2b$12$sofiarochavethash00000006'),
    (7, '2022-02-14 08:00:00', null, '2024-09-30 17:00:00', null, '+351253440107', '+351912340107', 'tiago.manager.legacy@miacaomigo.pt', '$2b$12$tiagomanagerlegacyh000007'),
    (7, '2024-10-07 08:00:00', null, null, null, '+351253440007', '+351912340007', 'tiago.almeida@miacaomigo.pt', '$2b$12$tiagoassisthashvalue000007'),
    (8, '2023-03-20 09:30:00', null, null, null, '+351253440008', '+351912340008', 'beatriz.sousa@miacaomigo.pt', '$2b$12$beatrizgestorhashval000008'),
    (9, '2024-07-01 09:00:00', null, '2025-04-10 17:00:00', null, '+351253440109', '+351912340109', 'pedro.assist.legacy@miacaomigo.pt', '$2b$12$pedroassistlegacyhash000009'),
    (9, '2025-04-14 09:00:00', null, null, null, '+351253440009', '+351912340009', 'pedro.nunes@miacaomigo.pt', '$2b$12$pedronunesadmhashval000009'),
    (10, '2024-09-09 10:00:00', null, null, null, '+351253440010', '+351912340010', 'ines.fernandes@miacaomigo.pt', '$2b$12$inesfernandesvethash0010'),
    (11, '2024-02-01 08:45:00', null, '2025-03-05 17:00:00', null, '+351253440111', '+351912340111', 'marta.ops.legacy@miacaomigo.pt', '$2b$12$martaopslegacyhashval0011'),
    (11, '2025-03-10 08:45:00', null, null, null, '+351253440011', '+351912340011', 'marta.pinto@miacaomigo.pt', '$2b$12$martapintoassisthash0011'),
    (12, '2024-11-18 09:15:00', null, null, null, '+351253440012', '+351912340012', 'miguel.oliveira@miacaomigo.pt', '$2b$12$migueloliveiramgrhash0012'),
    (13, '2023-07-22 09:00:00', null, null, null, '+351253440013', '+351912340013', 'diana.cruz@miacaomigo.pt', '$2b$12$dianacruzadmhashval00013'),
    (14, '2024-01-29 08:45:00', null, null, null, '+351253440014', '+351912340014', 'bruno.moreira@miacaomigo.pt', '$2b$12$brunomoreiravethash00014'),
    (15, '2025-02-03 09:30:00', null, null, null, '+351253440015', '+351912340015', 'lara.santos@miacaomigo.pt', '$2b$12$larasantosassisthash015'),
    (16, '2024-05-27 10:00:00', null, null, null, '+351253440016', '+351912340016', 'paulo.carvalho@miacaomigo.pt', '$2b$12$paulocarvalhomgrhash016'),
    (17, '2021-06-07 09:00:00', null, '2025-02-28 18:00:00', null, '+351253440017', '+351912340017', 'joana.lopes@miacaomigo.pt', '$2b$12$joanalopesinactivehash17'),
    (18, '2022-10-10 08:30:00', null, '2024-08-30 17:00:00', null, '+351253440118', '+351912340118', 'samuel.assist.legacy@miacaomigo.pt', '$2b$12$samuelassistlegacyhash18'),
    (18, '2024-09-03 08:30:00', null, null, null, '+351253440018', '+351912340018', 'samuel.correia@miacaomigo.pt', '$2b$12$samuelcorreiavethash00018'),
    (19, '2022-04-18 09:00:00', null, '2025-05-12 17:00:00', null, '+351253440019', '+351912340019', 'rita.lopes@miacaomigo.pt', '$2b$12$ritalopesinactivehash0019'),
    (20, '2023-03-27 10:00:00', null, '2025-06-01 17:00:00', null, '+351253440020', '+351912340020', 'francisco.neves@miacaomigo.pt', '$2b$12$franciscoinactivehash0020'),
    (21, '2022-09-12 09:15:00', null, '2025-05-20 17:00:00', null, '+351253440021', '+351912340021', 'diana.martins@miacaomigo.pt', '$2b$12$dianamartinsinactiveh21'),
    (22, '2023-04-03 08:45:00', null, '2025-03-14 17:00:00', null, '+351253440122', '+351912340122', 'hugo.assist.legacy@miacaomigo.pt', '$2b$12$hugoassistlegacyhashval22'),
    (22, '2025-03-19 08:45:00', null, null, null, '+351253440022', '+351912340022', 'hugo.matos@miacaomigo.pt', '$2b$12$hugomatosvethashval000022'),
    (23, '2024-10-01 09:00:00', null, '2025-01-31 17:00:00', null, '+351253440023', '+351912340023', 'sara.azevedo@miacaomigo.pt', '$2b$12$saraazevedoinactiveh00023'),
    (24, '2023-08-21 09:00:00', null, '2025-07-08 17:00:00', null, '+351253440024', '+351912340024', 'andre.pereira@miacaomigo.pt', '$2b$12$andrepereirainactive0024'),
    (25, '2025-04-01 09:00:00', null, null, null, '+351253440025', '+351912340025', 'catarina.vieira@miacaomigo.pt', '$2b$12$catarinaroletrainee00025'),
    (26, '2025-04-15 08:30:00', null, null, null, '+351253440026', '+351912340026', 'tomas.sousa@miacaomigo.pt', '$2b$12$tomassousavethashval0026'),
    (27, '2025-05-02 09:15:00', null, null, null, '+351253440027', '+351912340027', 'paula.gomes@miacaomigo.pt', '$2b$12$paulagomesassisthash0027'),
    (28, '2024-12-02 09:00:00', null, null, null, '+351253440028', '+351912340028', 'leonor.ribeiro@miacaomigo.pt', '$2b$12$leonorribeiromgrhash0028'),
    (29, '2025-01-13 08:45:00', null, null, null, '+351253440029', '+351912340029', 'nuno.correia@miacaomigo.pt', '$2b$12$nunocorreiavethashval29'),
    (30, '2025-03-24 09:30:00', null, null, null, '+351253440030', '+351912340030', 'marta.duarte@miacaomigo.pt', '$2b$12$martaduarteassisthash30'),
    (31, '2025-02-17 09:00:00', null, null, null, '+351253440031', '+351912340031', 'teresa.faria@miacaomigo.pt', '$2b$12$teresafariasecurity0031'),
    (32, '2025-06-02 08:30:00', null, null, null, '+351253440032', '+351912340032', 'filipe.ramos@miacaomigo.pt', '$2b$12$filiperamosvethashval0032');


--=========================================================
-- 7b. ACCOUNTABILITY — aut_ina_emp for every deactivated row
--=========================================================
-- chk_employee_inactivation requires aut_ina_emp whenever dea_dat_emp is set.
-- Spell hand-offs: inactive row closed by the successor employment of same user.
-- Departures without successor spell: attribute to active administrator (id_emp 2).

update employee set aut_ina_emp = 2 where id_emp = 1;
update employee set aut_ina_emp = 4 where id_emp = 3;
update employee set aut_ina_emp = 6 where id_emp = 5;
update employee set aut_ina_emp = 9 where id_emp = 8;
update employee set aut_ina_emp = 12 where id_emp = 11;
update employee set aut_ina_emp = 15 where id_emp = 14;
update employee set aut_ina_emp = 18 where id_emp = 17;
update employee set aut_ina_emp = 26 where id_emp = 25;
update employee set aut_ina_emp = 31 where id_emp = 30;
update employee set aut_ina_emp = 2 where id_emp in (24, 27, 28, 29, 32, 33);


--=========================================================
-- 8. CLIENT
--=========================================================

insert into client (id_usr, pas_cli, reg_dat_cli, ina_dat_cli) values
    (17, '$2b$12$clientportalhashval000017', '2024-01-10 11:00:00', null),
    (18, '$2b$12$clientportalhashval000018', '2024-02-11 11:00:00', null),
    (19, '$2b$12$clientportalhashval000019', '2024-03-12 11:00:00', '2025-05-20 10:00:00'),
    (33, '$2b$12$clientportalhashval000033', '2024-06-01 10:30:00', null),
    (34, '$2b$12$clientportalhashval000034', '2024-07-15 09:45:00', null),
    (35, '$2b$12$clientportalhashval000035', '2024-08-20 14:00:00', null),
    (36, '$2b$12$clientportalhashval000036', '2024-09-05 16:20:00', null),
    (37, '$2b$12$clientportalhashval000037', '2024-10-12 13:10:00', null),
    (38, '$2b$12$clientportalhashval000038', '2024-11-03 12:00:00', null),
    (39, '$2b$12$clientportalhashval000039', '2025-01-08 15:30:00', null),
    (40, '$2b$12$clientportalhashval000040', '2025-02-14 10:00:00', null),
    (41, '$2b$12$clientportalhashval000041', '2025-03-22 11:45:00', null),
    (42, '$2b$12$clientportalhashval000042', '2025-04-02 09:30:00', null),
    (43, '$2b$12$clientportalhashval000043', '2025-04-18 14:15:00', null),
    (44, '$2b$12$clientportalhashval000044', '2025-05-01 16:00:00', null),
    (45, '$2b$12$clientportalhashval000045', '2025-05-10 12:30:00', null),
    (46, '$2b$12$clientportalhashval000046', '2025-05-15 13:45:00', null),
    (47, '$2b$12$clientportalhashval000047', '2025-05-20 10:10:00', null),
    (48, '$2b$12$clientportalhashval000048', '2025-05-25 09:50:00', null);


--=========================================================
-- 9. OCCUPIES (id_emp per map above)
--=========================================================

insert into occupies (id_emp, id_pro) values
    (2, 1), (9, 1), (15, 1), (40, 1),
    (4, 2), (10, 2), (16, 2), (21, 2), (26, 2), (31, 2), (35, 2), (38, 2), (41, 2),
    (6, 3), (12, 3), (18, 3), (22, 3), (27, 3), (30, 3), (36, 3), (39, 3),
    (7, 4), (13, 4), (19, 4), (23, 4), (28, 4), (37, 4),
    (34, 5),
    (1, 3), (3, 2), (5, 3), (8, 4), (11, 3), (14, 3), (20, 1),
    (24, 2), (25, 3), (29, 2), (32, 2), (33, 4),
    (17, 3);


--=========================================================
-- 10. VETERINARIAN (never same id_emp as assistant)
--=========================================================

insert into veterinarian (id_emp, num_omv_vet) values
    (4, 'OMV-PT-2021-00412'),
    (10, 'OMV-PT-2019-00987'),
    (13, 'OMV-PT-2017-03300'),
    (16, 'OMV-PT-2022-03567'),
    (20, 'OMV-PT-2021-02901'),
    (21, 'OMV-PT-2022-01890'),
    (24, 'OMV-PT-2016-03789'),
    (26, 'OMV-PT-2023-02678'),
    (28, 'OMV-PT-2015-04012'),
    (29, 'OMV-PT-2022-04777'),
    (31, 'OMV-PT-2024-03156'),
    (32, 'OMV-PT-2024-04298'),
    (35, 'OMV-PT-2023-04510'),
    (38, 'OMV-PT-2020-05234'),
    (41, 'OMV-PT-2024-05401');


--=========================================================
-- 11. ASSISTANT
--=========================================================

insert into assistant (id_emp, fun_ass) values
    (1, 'rececao administrativa'),
    (2, 'suporte administrativo'),
    (3, 'assistencia cirurgica'),
    (5, 'rececao e triagem'),
    (6, 'sala de tratamentos'),
    (7, 'inventario clinico'),
    (8, 'coordenacao de turno'),
    (9, 'suporte administrativo'),
    (11, 'rececao e arquivo clinico'),
    (12, 'coordenacao de stocks'),
    (14, 'preparacao de meios'),
    (15, 'transporte interno'),
    (17, 'arquivo clinico'),
    (18, 'central telefonica'),
    (19, 'gestao de turno'),
    (22, 'acompanhamento pos operatorio'),
    (23, 'suporte administrativo'),
    (25, 'formacao supervisionada'),
    (27, 'rececao avancada'),
    (30, 'suporte laboratorial'),
    (33, 'inventario temporario'),
    (34, 'observacao supervisionada'),
    (36, 'gestao de stocks clinicos'),
    (39, 'central de contactos'),
    (40, 'qualidade documental');


--=========================================================
-- 12. EXPERT
--=========================================================

insert into expert (id_emp, id_spe) values
    (4, 1), (4, 7),
    (10, 2), (10, 5),
    (13, 8), (13, 1),
    (16, 4), (16, 2),
    (20, 1), (20, 6),
    (21, 3), (21, 4),
    (24, 3), (24, 6),
    (26, 1), (26, 2),
    (28, 4), (28, 8),
    (29, 2), (29, 7),
    (31, 7), (31, 1),
    (32, 4), (32, 5),
    (35, 2), (35, 7),
    (38, 5), (38, 3),
    (41, 3), (41, 5);


--=========================================================
-- 13. SCHEDULE (non-overlapping intervals per emp × weekday)
--=========================================================

insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch) values
    (4, 1, '08:30', '12:30'), (4, 1, '14:00', '19:00'),
    (4, 2, '08:30', '12:30'), (4, 2, '14:00', '19:00'),
    (4, 3, '08:30', '12:30'), (4, 3, '14:00', '19:00'),
    (4, 4, '08:30', '12:30'), (4, 4, '14:00', '19:00'),
    (4, 5, '08:30', '12:30'), (4, 5, '14:00', '18:30'),
    (10, 1, '09:00', '18:00'), (10, 2, '09:00', '18:00'), (10, 3, '09:00', '18:00'),
    (10, 4, '09:00', '18:00'), (10, 5, '09:00', '17:30'),
    (13, 1, '07:30', '15:30'), (13, 2, '07:30', '15:30'), (13, 3, '07:30', '15:30'),
    (13, 4, '07:30', '15:30'), (13, 5, '07:30', '14:30'),
    (16, 1, '08:00', '17:00'), (16, 2, '08:00', '17:00'), (16, 3, '08:00', '17:00'),
    (16, 4, '08:00', '17:00'), (16, 5, '08:00', '16:00'),
    (19, 1, '08:00', '16:30'), (19, 2, '08:00', '16:30'), (19, 3, '08:00', '16:30'),
    (19, 4, '08:00', '16:30'), (19, 5, '08:00', '15:30'),
    (21, 1, '10:00', '19:00'), (21, 2, '10:00', '19:00'), (21, 3, '10:00', '19:00'),
    (21, 4, '10:00', '19:00'), (21, 5, '10:00', '18:00'),
    (35, 1, '08:45', '17:45'), (35, 2, '08:45', '17:45'), (35, 3, '08:45', '17:45'),
    (35, 4, '08:45', '17:45'), (35, 5, '08:45', '16:45'),
    (38, 2, '11:00', '20:00'), (38, 3, '11:00', '20:00'), (38, 4, '11:00', '20:00'),
    (38, 5, '11:00', '19:00'), (38, 6, '09:00', '13:00'),
    (41, 1, '09:00', '18:00'), (41, 3, '09:00', '18:00'), (41, 5, '09:00', '18:00'),
    (24, 1, '09:00', '18:00'), (24, 2, '09:00', '18:00'), (24, 3, '09:00', '18:00'),
    (29, 1, '08:30', '17:30'), (29, 4, '08:30', '17:30'), (29, 5, '08:30', '16:30'),
    (32, 1, '10:00', '18:00'), (32, 3, '10:00', '18:00'), (32, 5, '10:00', '17:00');


--=========================================================
-- 14. LOGIN_RECORD
--=========================================================

insert into login_record (sig_tim_log, sou_tim_log, suc_log, ip_add_log, eml_usr, id_usr) values
    (now() - interval '9 days 5 hours', now() - interval '9 days 2 hours', true, '10.12.10.21'::inet, 'ana.silva@miacaomigo.pt', 2),
    (now() - interval '8 days 4 hours', now() - interval '8 days 1 hours', true, '10.12.10.22'::inet, 'ricardo.santos@miacaomigo.pt', 1),
    (now() - interval '7 days 6 hours', now() - interval '7 days 2 hours', true, '10.12.20.30'::inet, 'maria.costa@miacaomigo.pt', 4),
    (now() - interval '6 days 3 hours', now() - interval '6 days', true, '10.12.20.31'::inet, 'sofia.rocha@miacaomigo.pt', 6),
    (now() - interval '5 days 7 hours', now() - interval '5 days 3 hours', true, '192.168.30.10'::inet, 'beatriz.sousa@miacaomigo.pt', 8),
    (now() - interval '4 days 2 hours', now() - interval '4 days', true, '192.168.30.11'::inet, 'diana.cruz@miacaomigo.pt', 13),
    (now() - interval '3 days 5 hours', now() - interval '3 days 1 hours', true, '192.168.40.50'::inet, 'bruno.moreira@miacaomigo.pt', 14),
    (now() - interval '2 days 4 hours', now() - interval '2 days', true, '192.168.40.51'::inet, 'ines.fernandes@miacaomigo.pt', 10),
    (now() - interval '11 days 2 hours', now() - interval '11 days', true, '89.153.12.10'::inet, 'joana.lopes.inbox@gmail.com', 17),
    (now() - interval '10 days 3 hours', now() - interval '10 days 1 hours', true, '89.153.12.11'::inet, 'samuel.correia@sapo.pt', 18),
    (now() - interval '15 days 4 hours', now() - interval '15 days', true, '89.153.22.44'::inet, 'leonardo.matos@sapo.pt', 40),
    (now() - interval '55 minutes', null, true, '192.168.50.60'::inet, 'ana.silva@miacaomigo.pt', 2),
    (now() - interval '48 minutes', null, true, '192.168.50.61'::inet, 'ricardo.santos@miacaomigo.pt', 1),
    (now() - interval '40 minutes', null, true, '192.168.50.62'::inet, 'catarina.vieira@miacaomigo.pt', 25),
    (now() - interval '35 minutes', null, false, '185.220.101.17'::inet, 'admin@miacaomigo.pt', null),
    (now() - interval '34 minutes', null, false, '185.220.101.17'::inet, 'ricardo.santos@miacaomigo.pt', null),
    (now() - interval '33 minutes', null, false, '185.220.101.17'::inet, 'ana.silva@miacaomigo.pt', null),
    (now() - interval '32 minutes', null, false, '185.220.101.17'::inet, 'suporte@miacaomigo.pt', null),
    (now() - interval '20 minutes', null, false, '2001:818:e4f2:2::55'::inet, 'ricardo.santoz@gmail.com', null),
    (now() - interval '18 minutes', null, false, '2001:818:e4f2:2::55'::inet, 'naoexiste@gmail.com', null),
    ('2025-05-28 08:30:00', '2025-05-28 17:45:00', true, '10.0.5.18'::inet, 'rita.lopes@miacaomigo.pt', 19),
    ('2025-04-02 09:00:00', '2025-04-02 18:10:00', true, '10.0.5.19'::inet, 'sara.azevedo@miacaomigo.pt', 23);


--=========================================================
-- 15. ABSENCE (no overlapping pending|approved|detected per id_usr)
--=========================================================

insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs, res_abs, cre_tim_abs) values
    (6, now() - interval '26 days', now() - interval '26 days' + interval '6 hours', 'consulta de saude ocupacional', 'approved', 23, now() - interval '30 days'),
    (10, now() + interval '20 days', now() + interval '27 days', 'ferias planejadas verao', 'pending', null, now() - interval '5 days'),
    (12, now() - interval '40 days', now() - interval '39 days' + interval '8 hours', 'ausencia detetada por turno', 'detected', null, now() - interval '38 days'),
    (16, now() + interval '60 days', now() + interval '70 days', 'viagem pessoal prolongada', 'rejected', 28, now() - interval '12 days'),
    (18, now() + interval '15 days', now() + interval '16 days', 'consulta dentaria', 'cancelled', null, now() - interval '20 days'),
    (21, now() + interval '45 days', now() + interval '47 days', 'formacao avancada em ortopedia', 'approved', 28, now() - interval '10 days'),
    (4, now() - interval '120 days', now() - interval '112 days', 'ferias de primavera', 'approved', 23, now() - interval '125 days'),
    (4, now() + interval '100 days', now() + interval '114 days', 'ferias familiares', 'pending', null, now() - interval '3 days'),
    (27, '2024-08-01 09:00:00', '2024-08-15 18:00:00', 'ferias de verao', 'approved', 23, '2024-07-20 10:00:00'),
    (32, '2024-12-23 09:00:00', '2024-12-31 18:00:00', 'encerramento de contrato temporario', 'approved', 2, '2024-12-15 09:00:00'),
    (14, now() - interval '18 days', now() - interval '17 days', 'formacao interna obrigatoria', 'approved', 13, now() - interval '25 days'),
    (18, now() - interval '55 days', now() - interval '54 days', 'falta justificada tardia', 'detected', null, now() - interval '53 days'),
    (30, now() + interval '3 days', now() + interval '3 days' + interval '7 hours', 'consulta de rotina', 'pending', null, now() - interval '2 days'),
    (41, now() + interval '30 days', now() + interval '32 days', 'congresso nacional de medicina veterinaria', 'approved', 28, now() - interval '6 days');


--=========================================================
-- 16. CLOCK_IN (inserted after absences; ≤1 open row per id_emp)
--=========================================================

insert into clock_in (id_emp, sta_dat_clk, end_dat_clk) values
    (2, now() - interval '1 day 7 hours', now() - interval '1 day 1 hours'),
    (4, now() - interval '1 day 8 hours', now() - interval '1 day 2 hours'),
    (8, now() - interval '1 day 6 hours', now() - interval '1 day 90 minutes'),
    (9, now() - interval '2 days 8 hours', now() - interval '2 days 1 hours'),
    (10, now() - interval '2 days 7 hours', now() - interval '2 days 2 hours'),
    (13, now() - interval '3 days 6 hours', now() - interval '3 days'),
    (19, now() - interval '3 days 7 hours', now() - interval '3 days 30 minutes'),
    (15, now() - interval '4 days 8 hours', now() - interval '4 days 1 hours'),
    (20, now() - interval '4 days 9 hours', now() - interval '4 days 2 hours'),
    (21, now() - interval '5 days 8 hours', now() - interval '5 days'),
    (23, now() - interval '5 days 7 hours', now() - interval '5 days 90 minutes'),
    (28, now() - interval '6 days 8 hours', now() - interval '6 days 1 hours'),
    (30, now() - interval '6 days 7 hours', now() - interval '6 days 2 hours'),
    (31, now() - interval '7 days 6 hours', now() - interval '7 days'),
    (35, now() - interval '7 days 8 hours', now() - interval '7 days 1 hours'),
    (36, now() - interval '8 days 7 hours', now() - interval '8 days'),
    (37, now() - interval '8 days 8 hours', now() - interval '8 days 2 hours'),
    (38, now() - interval '9 days 7 hours', now() - interval '9 days'),
    (39, now() - interval '9 days 8 hours', now() - interval '9 days 90 minutes'),
    (40, now() - interval '10 days 6 hours', now() - interval '10 days'),
    (4, now() - interval '12 days 8 hours', now() - interval '12 days 4 hours'),
    (4, now() - interval '12 days 3 hours', now() - interval '12 days'),
    (10, now() - interval '13 days 9 hours', now() - interval '13 days 5 hours'),
    (10, now() - interval '13 days 4 hours', now() - interval '13 days 30 minutes'),
    (6, now() - interval '90 minutes', null),
    (14, now() - interval '2 hours', null),
    (22, now() - interval '50 minutes', null),
    (24, '2024-11-04 08:45:00', '2024-11-04 17:30:00'),
    (24, '2024-11-05 08:50:00', '2024-11-05 17:25:00'),
    (29, '2025-03-10 09:00:00', '2025-03-10 18:00:00'),
    (32, '2024-12-27 09:00:00', '2024-12-27 13:00:00'),
    (27, '2025-04-02 08:30:00', '2025-04-02 17:45:00'),
    (35, '2025-11-02 21:30:00', '2025-11-03 05:45:00'),
    (38, '2025-10-18 22:00:00', '2025-10-19 06:15:00');


--=========================================================
-- END
--=========================================================
