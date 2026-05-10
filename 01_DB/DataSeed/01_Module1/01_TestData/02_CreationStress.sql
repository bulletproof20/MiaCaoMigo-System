--=========================================================
-- MODULE 1 — CREATION STRESS TEST DATA
--=========================================================
-- Purpose:
--   Enterprise-grade dataset focused on validating creation
--   flows for user_account, client, employee, veterinarian,
--   assistant, RBAC links, scheduling primitives, attendance,
--   and authentication telemetry.
--
-- Design notes:
--   * user_account is the shared identity anchor; every row
--     participates in at least one role (client and/or employee).
--   * setup rows are created exclusively by trg_create_default_setup
--     (do not insert setup manually in this seed).
--   * Corporate mail for the current employment spell follows
--     fn_create_employee semantics: {id_usr}@miacaomigo.pt.
--     Legacy spells use unique {id_usr}.hist{n}@miacaomigo.pt.
--   * id_usr / id_emp are explicit (OVERRIDING SYSTEM VALUE) so
--     downstream references remain stable for automation.
--
-- Identity map (id_usr):
--   1-22   Staff-only or ex-staff scenarios (15-16 are ex-staff
--          with no active employee; they retain a client binding).
--   23-38  Pure clients (no employee rows).
--   39-52  Shared client + active employee identities.
--
-- Employee map (id_emp highlights):
--   1      Registrar bootstrap (id_usr 20) — active administrator.
--   2-33   Core lifecycle mixes (rehire, multi-spell, inactive).
--   34-47  Shared-identity employees (id_usr 39-52).
--   48-55  Additional historical rows for heavy stress users.
--
-- Future-facing coverage:
--   * profile / permission lattice extended with scheduling and
--     audit-oriented grants for forthcoming RBAC routines.
--   * schedule, absence, clock_in, and login_record populated with
--     relationships that mirror operational onboarding scenarios.
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
    client,
    employee,
    permission,
    profile,
    specialty,
    user_account
restart identity cascade;


--=========================================================
-- 1. PERMISSIONS (core + future operational hooks)
--=========================================================

insert into permission (nam_per, des_per) values
    ('manage_users', 'create, update, and deactivate identities bound to the platform'),
    ('manage_roles', 'maintain occupies and have mappings for RBAC automation'),
    ('manage_animals', 'full animal registry lifecycle including custody transfers'),
    ('manage_appointments', 'clinical scheduling workflows and appointment state transitions'),
    ('manage_inventory', 'stock, purchasing, and catalog maintenance'),
    ('view_reports', 'read-only dashboards, exports, and historical KPIs'),
    ('manage_absences', 'approve, reject, or annotate absence cases'),
    ('audit_security', 'inspect authentication telemetry and anomaly indicators'),
    ('manage_billing', 'invoice lifecycle, settlements, and revenue controls'),
    ('schedule_operations', 'maintain recurring rosters and coverage windows for clinical teams'),
    ('clinical_audit_trail', 'export immutable audit bundles for regulated reviews');


--=========================================================
-- 2. PROFILES
--=========================================================

insert into profile (nam_pro, des_pro) values
    ('administrador', 'global governance over users, security, and platform configuration'),
    ('veterinario', 'regulated clinical practitioner with professional registration'),
    ('assistente clínico', 'peri-clinical and front-office operational support'),
    ('gestor clínico', 'practice management, staffing compliance, and policy enforcement'),
    ('estagiario', 'supervised trainee operating under narrowed permission bundles');


--=========================================================
-- 3. HAVE (profile × permission)
--=========================================================

insert into have (id_pro, id_per) values
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11),
    (2, 3), (2, 4), (2, 6), (2, 10), (2, 11),
    (3, 4), (3, 6), (3, 10),
    (4, 2), (4, 5), (4, 6), (4, 7), (4, 9), (4, 10),
    (5, 6), (5, 10);


--=========================================================
-- 4. SPECIALTIES
--=========================================================

insert into specialty (nam_spe, des_spe) values
    ('medicina interna', 'diagnostico e tratamento de doencas sistemicas em pequenos animais'),
    ('cirurgia de tegumentos', 'procedimentos dermatologicos e reconstrucao de tecidos moles'),
    ('ortopedia', 'avaliacao funcional e tratamento de patologias musculo esqueleticas'),
    ('dermatologia', 'terapeutica alergologica e parasitarias prolongadas'),
    ('anestesiologia', 'sedacao balanceada, analgesia multimodal e monitorizacao avancada'),
    ('imagiologia', 'correlacao clinica de estudos de imagem e seguimento documental'),
    ('medicina felina', 'consultas especializadas para comportamento e prevencao felina'),
    ('oncologia basica', 'estadiaamento inicial, quimioterapia de manutencao e suporte paliativo');


--=========================================================
-- 5. USER_ACCOUNT (52 identities)
--=========================================================

insert into user_account (id_usr, nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
overriding system value
values
    (1, 'Mariana Filipa Lopes', 'Rua do Souto 214, Braga', '4700-304', '610000001', '+351910300001', 'mariana.lopes.cstress@gmail.com'),
    (2, 'Tiago Manuel Ribeiro', 'Praceta das Oliveiras 8, Guimarães', '4810-502', '610000002', '+351910300002', 'tiago.ribeiro.cstress@sapo.pt'),
    (3, 'Sofia Cristina Azevedo', 'Avenida Central 442, Porto', '4000-124', '610000003', '+351910300003', 'sofia.azevedo.cstress@icloud.com'),
    (4, 'Bruno Filipe Matos', 'Rua da Junqueira 55, Coimbra', '3000-341', '610000004', '+351910300004', 'bruno.matos.cstress@outlook.pt'),
    (5, 'Leonor Patrícia Sousa', 'Rua Garrett 18, Lisboa', '1200-020', '610000005', '+351910300005', 'leonor.sousa.cstress@gmail.com'),
    (6, 'Miguel Tomás Carvalho', 'Rua de Santa Catarina 512, Porto', '4000-452', '610000006', '+351910300006', 'miguel.carvalho.cstress@yahoo.com'),
    (7, 'Inês Margarida Pires', 'Rua dos Capelistas 44, Braga', '4700-442', '610000007', '+351910300007', 'ines.pires.cstress@me.com'),
    (8, 'Ricardo Daniel Fonseca', 'Avenida da Boavista 980, Porto', '4100-136', '610000008', '+351910300008', 'ricardo.fonseca.cstress@sapo.pt'),
    (9, 'Carla Filipa Monteiro', 'Rua Direita 93, Viseu', '3500-099', '610000009', '+351910300009', 'carla.monteiro.cstress@gmail.com'),
    (10, 'Hugo Alexandre Correia', 'Rua da Carreira 27, Aveiro', '3800-159', '610000010', '+351910300010', 'hugo.correia.cstress@proton.me'),
    (11, 'Patrícia Sofia Nunes', 'Rua do Almada 210, Porto', '4050-036', '610000011', '+351910300011', 'patricia.nunes.cstress@icloud.com'),
    (12, 'Duarte Filipe Ramos', 'Largo do Toural 14, Guimarães', '4810-431', '610000012', '+351910300012', 'duarte.ramos.cstress@gmail.com'),
    (13, 'Rita Cristina Lourenço', 'Rua de Miguel Bombarda 305, Porto', '4050-380', '610000013', '+351910300013', 'rita.lourenco.cstress@sapo.pt'),
    (14, 'Francisco Manuel Teixeira', 'Rua de São Bento 66, Lisboa', '1200-821', '610000014', '+351910300014', 'francisco.teixeira.cstress@outlook.pt'),
    (15, 'Joana Filipa Matias', 'Rua da Prata 120, Lisboa', '1100-416', '610000015', '+351910300015', 'joana.matias.cstress@gmail.com'),
    (16, 'Nuno Ricardo Sequeira', 'Rua do Carmo 188, Braga', '4700-309', '610000016', '+351910300016', 'nuno.sequeira.cstress@yahoo.com'),
    (17, 'Teresa Leonor Branco', 'Avenida dos Aliados 102, Porto', '4000-064', '610000017', '+351910300017', 'teresa.branco.cstress@me.com'),
    (18, 'André Gustavo Henriques', 'Rua Augusta 302, Lisboa', '1100-053', '610000018', '+351910300018', 'andre.henriques.cstress@sapo.pt'),
    (19, 'Marta Isabel Serafim', 'Rua de Cedofeita 228, Porto', '4050-182', '610000019', '+351910300019', 'marta.serafim.cstress@gmail.com'),
    (20, 'Cláudia Raquel Faria', 'Rua Gonçalo Sampaio 412, Porto', '4150-564', '610000020', '+351910300020', 'claudia.faria.cstress@icloud.com'),
    (21, 'Filipe Augusto Castro', 'Rua Ferreira Borges 92, Aveiro', '3800-041', '610000021', '+351910300021', 'filipe.castro.cstress@outlook.pt'),
    (22, 'Helena Patrícia Matos', 'Rua Alexandre Herculano 44, Braga', '4700-030', '610000022', '+351910300022', 'helena.matos.cstress@gmail.com'),
    (23, 'Gonçalo Miguel Pratas', 'Rua da Sé 12, Faro', '8000-078', '610000023', '+351910300023', 'goncalo.pratas.cstress@gmail.com'),
    (24, 'Margarida Leonor Vieira', 'Rua de Camões 55, Lisboa', '1150-082', '610000024', '+351910300024', 'margarida.vieira.cstress@sapo.pt'),
    (25, 'Vasco Tomás Oliveira', 'Avenida Central 120, Matosinhos', '4450-130', '610000025', '+351910300025', 'vasco.oliveira.cstress@icloud.com'),
    (26, 'Andreia Cristina Pinto', 'Rua do Ouro 188, Lisboa', '1200-109', '610000026', '+351910300026', 'andreia.pinto.cstress@yahoo.com'),
    (27, 'Eduardo Luís Gomes', 'Rua João de Deus 40, Setúbal', '2910-091', '610000027', '+351910300027', 'eduardo.gomes.cstress@gmail.com'),
    (28, 'Mónica Filipa Duarte', 'Travessa de São Sebastião 2, Braga', '4700-495', '610000028', '+351910300028', 'monica.duarte.cstress@me.com'),
    (29, 'Rui Alexandre Lopes', 'Rua da Misericórdia 21, Évora', '7000-645', '610000029', '+351910300029', 'rui.lopes.cstress@sapo.pt'),
    (30, 'Leonardo Tomás Rocha', 'Rua de São João 88, Aveiro', '3810-200', '610000030', '+351910300030', 'leonardo.rocha.cstress@outlook.pt'),
    (31, 'Carla Filipa Sequeira', 'Rua do Carmo 71, Braga', '4700-309', '610000031', '+351910300031', 'carla.sequeira.cstress@gmail.com'),
    (32, 'Vasco Miguel Neto', 'Rua da Boavista 512, Porto', '4050-111', '610000032', '+351910300032', 'vasco.neto.cstress@icloud.com'),
    (33, 'Patrícia Sofia Almeida', 'Rua Garrett 220, Lisboa', '1200-204', '610000033', '+351910300033', 'patricia.almeida.cstress@yahoo.com'),
    (34, 'Gonçalo Filipe Machado', 'Rua de Santa Justa 14, Lisboa', '1100-483', '610000034', '+351910300034', 'goncalo.machado.cstress@gmail.com'),
    (35, 'Duarte Manuel Cunha', 'Rua do Almada 44, Porto', '4050-036', '610000035', '+351910300035', 'duarte.cunha.cstress@sapo.pt'),
    (36, 'Margarida Leonor Tavares', 'Rua dos Capelistas 9, Braga', '4700-442', '610000036', '+351910300036', 'margarida.tavares.cstress@proton.me'),
    (37, 'Jorge Manuel Pacheco', 'Rua Direita 40, Leiria', '2400-122', '610000037', '+351910300037', 'jorge.pacheco.cstress@outlook.pt'),
    (38, 'Filipa Raquel Borges', 'Rua Alexandre Herculano 310, Braga', '4700-030', '610000038', '+351910300038', 'filipa.borges.cstress@gmail.com'),
    (39, 'Catarina Filipa Amado', 'Avenida da República 210, Lisboa', '1050-097', '610000039', '+351910300039', 'catarina.amado.cstress@gmail.com'),
    (40, 'Tomás Henrique Lacerda', 'Rua de Cedofeita 360, Porto', '4050-182', '610000040', '+351910300040', 'tomas.lacerda.cstress@sapo.pt'),
    (41, 'Paula Cristina Melo', 'Rua do Souto 160, Braga', '4700-304', '610000041', '+351910300041', 'paula.melo.cstress@icloud.com'),
    (42, 'Leonor Matilde Freitas', 'Avenida dos Aliados 44, Porto', '4000-064', '610000042', '+351910300042', 'leonor.freitas.cstress@yahoo.com'),
    (43, 'Nuno Ricardo Valente', 'Rua da Alegria 120, Porto', '4000-037', '610000043', '+351910300043', 'nuno.valente.cstress@gmail.com'),
    (44, 'Marta Isabel Câmara', 'Rua da Prata 18, Lisboa', '1100-413', '610000044', '+351910300044', 'marta.camara.cstress@me.com'),
    (45, 'Teresa Manuela Reis', 'Rua da Carreira 6, Coimbra', '3000-048', '610000045', '+351910300045', 'teresa.reis.cstress@sapo.pt'),
    (46, 'Filipe Augusto Mota', 'Rua Ferreira Borges 10, Aveiro', '3800-041', '610000046', '+351910300046', 'filipe.mota.cstress@outlook.pt'),
    (47, 'Helena Patrícia Neves', 'Rua de São João 4, Aveiro', '3810-200', '610000047', '+351910300047', 'helena.neves.cstress@gmail.com'),
    (48, 'Jorge Manuel Baltazar', 'Rua da Boavista 812, Porto', '4100-111', '610000048', '+351910300048', 'jorge.baltazar.cstress@icloud.com'),
    (49, 'Filipa Raquel Drumond', 'Rua do Raio 120, Braga', '4700-223', '610000049', '+351910300049', 'filipa.drumond.cstress@yahoo.com'),
    (50, 'Eduardo Luís Carneiro', 'Praceta das Camélias 1, Porto', '4050-162', '610000050', '+351910300050', 'eduardo.carneiro.cstress@gmail.com'),
    (51, 'Mónica Filipa Abreu', 'Rua Garrett 60, Lisboa', '1200-204', '610000051', '+351910300051', 'monica.abreu.cstress@sapo.pt'),
    (52, 'Rui Alexandre Coelho', 'Rua de Camões 12, Lisboa', '1150-082', '610000052', '+351910300052', 'rui.coelho.cstress@outlook.pt');


--=========================================================
-- 6. EMPLOYEE (explicit id_emp — lifecycle stress)
--=========================================================
-- Notes:
--   * aut_reg_emp = 1 for all rows created after bootstrap id_emp 1.
--   * Inactive spells carry paired dea_dat_emp / aut_ina_emp.
--   * Active spell per id_usr has dea_dat_emp / aut_ina_emp null.
--   * Corporate email aligns with fn_create_employee for active rows.
--=========================================================

insert into employee (
    id_emp,
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
overriding system value
values
    -- registrar bootstrap (id_usr 20)
    (1, 20, current_timestamp - interval '4 years', null, null, null, '+351253440020', '+351912340020', '20@miacaomigo.pt', '$2b$12$cstress_registrar_emp001'),

    -- id_usr 1 — two legacy spells + active rehire
    (2, 1, current_timestamp - interval '6 years', 1, current_timestamp - interval '5 years', 1, '+351253441001', '+351912341001', '1.hist1@miacaomigo.pt', '$2b$12$cstress_u01_legacy_spell01'),
    (3, 1, current_timestamp - interval '5 years', 1, current_timestamp - interval '3 years', 1, '+351253441002', '+351912341002', '1.hist2@miacaomigo.pt', '$2b$12$cstress_u01_legacy_spell02'),
    (4, 1, current_timestamp - interval '3 years', 1, null, null, '+351253441003', '+351912341003', '1@miacaomigo.pt', '$2b$12$cstress_u01_active_spell03'),

    -- id_usr 2 — legacy + active
    (5, 2, current_timestamp - interval '5 years', 1, current_timestamp - interval '2 years', 1, '+351253442001', '+351912342001', '2.hist1@miacaomigo.pt', '$2b$12$cstress_u02_legacy_spell01'),
    (6, 2, current_timestamp - interval '2 years', 1, null, null, '+351253442002', '+351912342002', '2@miacaomigo.pt', '$2b$12$cstress_u02_active_spell02'),

    -- id_usr 3 — single active onboarding
    (7, 3, current_timestamp - interval '9 months', 1, null, null, '+351253443001', '+351912343001', '3@miacaomigo.pt', '$2b$12$cstress_u03_active_only'),

    -- id_usr 4 — veterinarian track
    (8, 4, current_timestamp - interval '3 years', 1, null, null, '+351253444001', '+351912344001', '4@miacaomigo.pt', '$2b$12$cstress_u04_vet_track'),

    -- id_usr 5 — assistant track
    (9, 5, current_timestamp - interval '2 years', 1, null, null, '+351253445001', '+351912345001', '5@miacaomigo.pt', '$2b$12$cstress_u05_assist_track'),

    -- id_usr 6 — veterinarian track
    (10, 6, current_timestamp - interval '4 years', 1, null, null, '+351253446001', '+351912346001', '6@miacaomigo.pt', '$2b$12$cstress_u06_vet_track'),

    -- id_usr 7 — legacy + active manager
    (11, 7, current_timestamp - interval '6 years', 1, current_timestamp - interval '18 months', 1, '+351253447001', '+351912347001', '7.hist1@miacaomigo.pt', '$2b$12$cstress_u07_legacy_spell01'),
    (12, 7, current_timestamp - interval '18 months', 1, null, null, '+351253447002', '+351912347002', '7@miacaomigo.pt', '$2b$12$cstress_u07_active_spell02'),

    -- id_usr 8 — clinical operations lead
    (13, 8, current_timestamp - interval '3 years', 1, null, null, '+351253448001', '+351912348001', '8@miacaomigo.pt', '$2b$12$cstress_u08_ops_lead'),

    -- id_usr 9 — legacy assist + active assist
    (14, 9, current_timestamp - interval '4 years', 1, current_timestamp - interval '1 year', 1, '+351253449001', '+351912349001', '9.hist1@miacaomigo.pt', '$2b$12$cstress_u09_legacy_assist'),
    (15, 9, current_timestamp - interval '1 year', 1, null, null, '+351253449002', '+351912349002', '9@miacaomigo.pt', '$2b$12$cstress_u09_active_assist'),

    -- id_usr 10 — veterinarian
    (16, 10, current_timestamp - interval '5 years', 1, null, null, '+351253450001', '+351912350001', '10@miacaomigo.pt', '$2b$12$cstress_u10_vet'),

    -- id_usr 11 — triple historical spell + active (stress)
    (17, 11, current_timestamp - interval '8 years', 1, current_timestamp - interval '7 years', 1, '+351253451001', '+351912351001', '11.hist1@miacaomigo.pt', '$2b$12$cstress_u11_hist01'),
    (18, 11, current_timestamp - interval '7 years', 1, current_timestamp - interval '5 years', 1, '+351253451002', '+351912351002', '11.hist2@miacaomigo.pt', '$2b$12$cstress_u11_hist02'),
    (19, 11, current_timestamp - interval '5 years', 1, current_timestamp - interval '30 months', 1, '+351253451003', '+351912351003', '11.hist3@miacaomigo.pt', '$2b$12$cstress_u11_hist03'),
    (20, 11, current_timestamp - interval '30 months', 1, null, null, '+351253451004', '+351912351004', '11@miacaomigo.pt', '$2b$12$cstress_u11_active'),

    -- id_usr 12 — legacy + active
    (21, 12, current_timestamp - interval '3 years', 1, current_timestamp - interval '8 months', 1, '+351253452001', '+351912352001', '12.hist1@miacaomigo.pt', '$2b$12$cstress_u12_legacy'),
    (22, 12, current_timestamp - interval '8 months', 1, null, null, '+351253452002', '+351912352002', '12@miacaomigo.pt', '$2b$12$cstress_u12_active'),

    -- id_usr 13 — single active
    (23, 13, current_timestamp - interval '14 months', 1, null, null, '+351253453001', '+351912353001', '13@miacaomigo.pt', '$2b$12$cstress_u13_active'),

    -- id_usr 14 — dual inactive spells (ex-staff; client portal only afterwards)
    (24, 14, current_timestamp - interval '6 years', 1, current_timestamp - interval '4 years', 1, '+351253454001', '+351912354001', '14.hist1@miacaomigo.pt', '$2b$12$cstress_u14_hist01'),
    (25, 14, current_timestamp - interval '4 years', 1, current_timestamp - interval '2 years', 1, '+351253454002', '+351912354002', '14.hist2@miacaomigo.pt', '$2b$12$cstress_u14_hist02'),

    -- id_usr 15 — fully inactive employment history (client-only access)
    (26, 15, current_timestamp - interval '5 years', 1, current_timestamp - interval '3 years', 1, '+351253455001', '+351912355001', '15.hist1@miacaomigo.pt', '$2b$12$cstress_u15_hist01'),
    (27, 15, current_timestamp - interval '3 years', 1, current_timestamp - interval '1 year', 1, '+351253455002', '+351912355002', '15.hist2@miacaomigo.pt', '$2b$12$cstress_u15_hist02'),

    -- id_usr 16 — same pattern (client-only today)
    (28, 16, current_timestamp - interval '4 years', 1, current_timestamp - interval '2 years', 1, '+351253456001', '+351912356001', '16.hist1@miacaomigo.pt', '$2b$12$cstress_u16_hist01'),

    -- id_usr 17 — veterinarian + gestor hybrid profile via occupies
    (29, 17, current_timestamp - interval '7 years', 1, null, null, '+351253457001', '+351912357001', '17@miacaomigo.pt', '$2b$12$cstress_u17_vet_mgr'),

    -- id_usr 18 — assistant specialization
    (30, 18, current_timestamp - interval '2 years', 1, null, null, '+351253458001', '+351912358001', '18@miacaomigo.pt', '$2b$12$cstress_u18_assist'),

    -- id_usr 19 — inactive legacy + active return-to-work
    (31, 19, current_timestamp - interval '5 years', 1, current_timestamp - interval '26 months', 1, '+351253459001', '+351912359001', '19.hist1@miacaomigo.pt', '$2b$12$cstress_u19_hist01'),
    (32, 19, current_timestamp - interval '26 months', 1, null, null, '+351253459002', '+351912359002', '19@miacaomigo.pt', '$2b$12$cstress_u19_active'),

    -- id_usr 21 — veterinarian bench
    (33, 21, current_timestamp - interval '3 years', 1, null, null, '+351253461001', '+351912361001', '21@miacaomigo.pt', '$2b$12$cstress_u21_vet'),

    -- id_usr 22 — assistant bench
    (34, 22, current_timestamp - interval '18 months', 1, null, null, '+351253462001', '+351912362001', '22@miacaomigo.pt', '$2b$12$cstress_u22_assist'),

    -- shared identities (id_usr 39-52) — each has an active employment spell
    (35, 39, current_timestamp - interval '30 months', 1, null, null, '+351253439001', '+351912339001', '39@miacaomigo.pt', '$2b$12$cstress_u39_shared'),
    (36, 40, current_timestamp - interval '24 months', 1, null, null, '+351253440001', '+351912340001', '40@miacaomigo.pt', '$2b$12$cstress_u40_shared'),
    (37, 41, current_timestamp - interval '20 months', 1, null, null, '+351253441010', '+351912341010', '41@miacaomigo.pt', '$2b$12$cstress_u41_shared'),
    (38, 42, current_timestamp - interval '16 months', 1, null, null, '+351253442010', '+351912342010', '42@miacaomigo.pt', '$2b$12$cstress_u42_shared'),
    (39, 43, current_timestamp - interval '15 months', 1, null, null, '+351253443010', '+351912343010', '43@miacaomigo.pt', '$2b$12$cstress_u43_shared'),
    (40, 44, current_timestamp - interval '14 months', 1, null, null, '+351253444010', '+351912344010', '44@miacaomigo.pt', '$2b$12$cstress_u44_shared'),
    (41, 45, current_timestamp - interval '13 months', 1, null, null, '+351253445010', '+351912345010', '45@miacaomigo.pt', '$2b$12$cstress_u45_shared'),
    (42, 46, current_timestamp - interval '12 months', 1, null, null, '+351253446010', '+351912346010', '46@miacaomigo.pt', '$2b$12$cstress_u46_shared'),
    (43, 47, current_timestamp - interval '11 months', 1, null, null, '+351253447010', '+351912347010', '47@miacaomigo.pt', '$2b$12$cstress_u47_shared'),
    (44, 48, current_timestamp - interval '10 months', 1, null, null, '+351253448010', '+351912348010', '48@miacaomigo.pt', '$2b$12$cstress_u48_shared'),
    (45, 49, current_timestamp - interval '9 months', 1, null, null, '+351253449010', '+351912349010', '49@miacaomigo.pt', '$2b$12$cstress_u49_shared'),
    (46, 50, current_timestamp - interval '8 months', 1, null, null, '+351253450010', '+351912350010', '50@miacaomigo.pt', '$2b$12$cstress_u50_shared'),
    (47, 51, current_timestamp - interval '7 months', 1, null, null, '+351253451010', '+351912351010', '51@miacaomigo.pt', '$2b$12$cstress_u51_shared'),
    (48, 52, current_timestamp - interval '6 months', 1, null, null, '+351253452010', '+351912352010', '52@miacaomigo.pt', '$2b$12$cstress_u52_shared'),

    -- heavy history for shared users (extra inactive spells)
    (49, 49, current_timestamp - interval '4 years', 1, current_timestamp - interval '3 years', 1, '+351253449011', '+351912349011', '49.hist1@miacaomigo.pt', '$2b$12$cstress_u49_hist01'),
    (50, 50, current_timestamp - interval '4 years', 1, current_timestamp - interval '2 years', 1, '+351253450011', '+351912350011', '50.hist1@miacaomigo.pt', '$2b$12$cstress_u50_hist01'),
    (51, 51, current_timestamp - interval '3 years', 1, current_timestamp - interval '18 months', 1, '+351253451011', '+351912351011', '51.hist1@miacaomigo.pt', '$2b$12$cstress_u51_hist01'),
    (52, 52, current_timestamp - interval '3 years', 1, current_timestamp - interval '14 months', 1, '+351253452011', '+351912352011', '52.hist1@miacaomigo.pt', '$2b$12$cstress_u52_hist01'),
    (53, 39, current_timestamp - interval '5 years', 1, current_timestamp - interval '4 years', 1, '+351253439011', '+351912339011', '39.hist1@miacaomigo.pt', '$2b$12$cstress_u39_hist01'),
    (54, 40, current_timestamp - interval '5 years', 1, current_timestamp - interval '3 years', 1, '+351253440011', '+351912340011', '40.hist1@miacaomigo.pt', '$2b$12$cstress_u40_hist01'),
    (55, 41, current_timestamp - interval '4 years', 1, current_timestamp - interval '3 years', 1, '+351253441011', '+351912341011', '41.hist1@miacaomigo.pt', '$2b$12$cstress_u41_hist01');


--=========================================================
-- 7. CLIENT
--=========================================================
-- Pure clients: id_usr 23-38
-- Shared identities: id_usr 39-52
-- Ex-staff with portal access: id_usr 14-16
--=========================================================

insert into client (id_usr, pas_cli, reg_dat_cli, ina_dat_cli) values
    (14, '$2b$12$cstress_cli_portal_u014', current_timestamp - interval '4 years', null),
    (15, '$2b$12$cstress_cli_portal_u015', current_timestamp - interval '3 years', null),
    (16, '$2b$12$cstress_cli_portal_u016', current_timestamp - interval '2 years', null),
    (23, '$2b$12$cstress_cli_pure_u023', current_timestamp - interval '6 years', null),
    (24, '$2b$12$cstress_cli_pure_u024', current_timestamp - interval '5 years', null),
    (25, '$2b$12$cstress_cli_pure_u025', current_timestamp - interval '5 years', null),
    (26, '$2b$12$cstress_cli_pure_u026', current_timestamp - interval '4 years', null),
    (27, '$2b$12$cstress_cli_pure_u027', current_timestamp - interval '4 years', null),
    (28, '$2b$12$cstress_cli_pure_u028', current_timestamp - interval '3 years', null),
    (29, '$2b$12$cstress_cli_pure_u029', current_timestamp - interval '3 years', null),
    (30, '$2b$12$cstress_cli_pure_u030', current_timestamp - interval '2 years', null),
    (31, '$2b$12$cstress_cli_pure_u031', current_timestamp - interval '2 years', null),
    (32, '$2b$12$cstress_cli_pure_u032', current_timestamp - interval '18 months', null),
    (33, '$2b$12$cstress_cli_pure_u033', current_timestamp - interval '18 months', null),
    (34, '$2b$12$cstress_cli_pure_u034', current_timestamp - interval '15 months', null),
    (35, '$2b$12$cstress_cli_pure_u035', current_timestamp - interval '15 months', null),
    (36, '$2b$12$cstress_cli_pure_u036', current_timestamp - interval '12 months', null),
    (37, '$2b$12$cstress_cli_pure_u037', current_timestamp - interval '12 months', null),
    (38, '$2b$12$cstress_cli_pure_u038', current_timestamp - interval '9 months', null),
    (39, '$2b$12$cstress_cli_shared_u039', current_timestamp - interval '4 years', null),
    (40, '$2b$12$cstress_cli_shared_u040', current_timestamp - interval '4 years', null),
    (41, '$2b$12$cstress_cli_shared_u041', current_timestamp - interval '3 years', null),
    (42, '$2b$12$cstress_cli_shared_u042', current_timestamp - interval '3 years', null),
    (43, '$2b$12$cstress_cli_shared_u043', current_timestamp - interval '30 months', null),
    (44, '$2b$12$cstress_cli_shared_u044', current_timestamp - interval '30 months', null),
    (45, '$2b$12$cstress_cli_shared_u045', current_timestamp - interval '28 months', null),
    (46, '$2b$12$cstress_cli_shared_u046', current_timestamp - interval '28 months', null),
    (47, '$2b$12$cstress_cli_shared_u047', current_timestamp - interval '26 months', null),
    (48, '$2b$12$cstress_cli_shared_u048', current_timestamp - interval '26 months', null),
    (49, '$2b$12$cstress_cli_shared_u049', current_timestamp - interval '24 months', null),
    (50, '$2b$12$cstress_cli_shared_u050', current_timestamp - interval '24 months', null),
    (51, '$2b$12$cstress_cli_shared_u051', current_timestamp - interval '22 months', null),
    (52, '$2b$12$cstress_cli_shared_u052', current_timestamp - interval '22 months', null);


--=========================================================
-- 8. OCCUPIES (RBAC readiness)
--=========================================================

insert into occupies (id_emp, id_pro) values
    (1, 1),
    (4, 4), (6, 4), (7, 5), (12, 4), (13, 4), (20, 3), (22, 3), (23, 3),
    (29, 2), (29, 4),
    (32, 3),
    (8, 2), (10, 2), (16, 2), (21, 2), (33, 2),
    (35, 2), (36, 3), (37, 4), (38, 3), (39, 2), (40, 4), (41, 3), (42, 4),
    (43, 2), (44, 3), (45, 4), (46, 2), (47, 3), (48, 4),
    (9, 3), (15, 3), (30, 3), (34, 3);


--=========================================================
-- 9. VETERINARIAN (subset of active clinical employees)
--=========================================================

insert into veterinarian (id_emp, num_omv_vet) values
    (8, 'OMV-PT-2024-CR-00841'),
    (10, 'OMV-PT-2022-CR-01902'),
    (16, 'OMV-PT-2021-CR-02773'),
    (21, 'OMV-PT-2023-CR-03319'),
    (29, 'OMV-PT-2020-CR-04008'),
    (33, 'OMV-PT-2025-CR-01144'),
    (35, 'OMV-PT-2024-CR-01590'),
    (39, 'OMV-PT-2023-CR-02217'),
    (43, 'OMV-PT-2022-CR-02880'),
    (46, 'OMV-PT-2024-CR-03605');


--=========================================================
-- 10. ASSISTANT (disjoint from veterinarian id_emp)
--=========================================================

insert into assistant (id_emp, fun_ass) values
    (7, 'onboarding documental'),
    (9, 'triagem e rececao avancada'),
    (12, 'coordenacao de stocks clinicos'),
    (15, 'acompanhamento pos operatorio'),
    (20, 'formacao supervisionada e arquivo clinico'),
    (22, 'central telefonica e rececao'),
    (23, 'suporte laboratorial'),
    (30, 'preparacao de meios cirurgicos'),
    (32, 'acompanhamento pos operatorio'),
    (34, 'transporte interno e logistica'),
    (36, 'qualidade documental'),
    (37, 'inventario perioperatorio'),
    (38, 'central de contactos'),
    (40, 'gestao de turno'),
    (41, 'preparacao de salas'),
    (42, 'suporte a imagiologia'),
    (44, 'rececao e arquivo digital'),
    (45, 'acompanhamento de internamentos'),
    (47, 'coordenacao de amostras'),
    (48, 'suporte a cirurgia menor');


--=========================================================
-- 11. EXPERT (multi-specialty veterinarians)
--=========================================================

insert into expert (id_emp, id_spe) values
    (8, 1), (8, 7),
    (10, 2), (10, 5),
    (16, 4), (16, 6),
    (21, 3), (21, 5),
    (29, 1), (29, 8),
    (33, 2), (33, 4),
    (35, 7), (35, 1),
    (39, 3), (39, 6),
    (43, 4), (43, 7),
    (46, 5), (46, 2);


--=========================================================
-- 12. SCHEDULE (non-overlapping windows per employee × weekday)
--=========================================================

insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch) values
    (8, 1, '08:30', '12:30'), (8, 1, '14:00', '19:00'),
    (8, 2, '08:30', '12:30'), (8, 2, '14:00', '19:00'),
    (8, 3, '08:30', '12:30'), (8, 3, '14:00', '19:00'),
    (8, 4, '08:30', '12:30'), (8, 4, '14:00', '19:00'),
    (8, 5, '08:30', '12:30'), (8, 5, '14:00', '18:00'),
    (10, 1, '09:00', '18:00'), (10, 2, '09:00', '18:00'), (10, 3, '09:00', '18:00'),
    (10, 4, '09:00', '18:00'), (10, 5, '09:00', '17:30'),
    (16, 1, '08:00', '17:00'), (16, 2, '08:00', '17:00'), (16, 3, '08:00', '17:00'),
    (16, 4, '08:00', '17:00'), (16, 5, '08:00', '16:00'),
    (21, 1, '10:00', '19:00'), (21, 3, '10:00', '19:00'), (21, 5, '10:00', '18:00'),
    (29, 1, '07:45', '16:45'), (29, 2, '07:45', '16:45'), (29, 4, '07:45', '16:45'),
    (33, 2, '11:00', '20:00'), (33, 3, '11:00', '20:00'), (33, 5, '11:00', '19:00'),
    (35, 1, '08:45', '17:45'), (35, 2, '08:45', '17:45'), (35, 4, '08:45', '17:45'),
    (39, 1, '09:15', '18:15'), (39, 2, '09:15', '18:15'), (39, 5, '09:15', '17:45'),
    (43, 1, '08:15', '17:15'), (43, 3, '08:15', '17:15'), (43, 5, '08:15', '16:15'),
    (46, 2, '09:30', '18:30'), (46, 4, '09:30', '18:30'), (46, 6, '09:00', '13:30'),
    (1, 1, '08:00', '18:00'), (1, 2, '08:00', '18:00'), (1, 3, '08:00', '18:00'),
    (1, 4, '08:00', '18:00'), (1, 5, '08:00', '17:00'),
    (13, 1, '08:30', '17:30'), (13, 2, '08:30', '17:30'), (13, 3, '08:30', '17:30'),
    (12, 4, '09:00', '18:00'), (12, 5, '09:00', '17:30');


--=========================================================
-- 13. LOGIN_RECORD (authentication creation telemetry)
--=========================================================

insert into login_record (sig_tim_log, sou_tim_log, suc_log, ip_add_log, eml_usr, id_usr) values
    (current_timestamp - interval '26 days 4 hours', current_timestamp - interval '26 days 1 hours', true, '10.40.12.18'::inet, '20@miacaomigo.pt', 20),
    (current_timestamp - interval '20 days 6 hours', current_timestamp - interval '20 days 2 hours', true, '10.40.12.19'::inet, '1@miacaomigo.pt', 1),
    (current_timestamp - interval '18 days 3 hours', current_timestamp - interval '18 days', true, '10.40.20.22'::inet, '8@miacaomigo.pt', 8),
    (current_timestamp - interval '16 days 5 hours', current_timestamp - interval '16 days 2 hours', true, '192.168.88.40'::inet, 'mariana.lopes.cstress@gmail.com', 1),
    (current_timestamp - interval '14 days 2 hours', current_timestamp - interval '14 days', true, '192.168.88.41'::inet, 'goncalo.pratas.cstress@gmail.com', 23),
    (current_timestamp - interval '12 days 4 hours', current_timestamp - interval '12 days 1 hours', true, '192.168.88.42'::inet, 'catarina.amado.cstress@gmail.com', 39),
    (current_timestamp - interval '9 days 3 hours', current_timestamp - interval '9 days', true, '89.153.44.10'::inet, '17@miacaomigo.pt', 17),
    (current_timestamp - interval '7 days 2 hours', current_timestamp - interval '7 days', true, '89.153.44.11'::inet, '35@miacaomigo.pt', 39),
    (current_timestamp - interval '6 days 5 hours', current_timestamp - interval '6 days 2 hours', true, '89.153.44.12'::inet, '43@miacaomigo.pt', 43),
    (current_timestamp - interval '3 days 4 hours', current_timestamp - interval '3 days', true, '2001:818:def0:12::21'::inet, '46@miacaomigo.pt', 46),
    (current_timestamp - interval '90 minutes', null, true, '192.168.60.77'::inet, '12@miacaomigo.pt', 12),
    (current_timestamp - interval '70 minutes', null, true, '192.168.60.78'::inet, 'filipe.castro.cstress@outlook.pt', 21),
    (current_timestamp - interval '55 minutes', null, false, '185.220.101.44'::inet, 'unknown.admin@miacaomigo.pt', null),
    (current_timestamp - interval '50 minutes', null, false, '185.220.101.44'::inet, '20@miacaomigo.pt', null),
    (current_timestamp - interval '40 minutes', null, false, '185.220.101.45'::inet, 'nif.mismatch@gmail.com', null),
    (current_timestamp - interval '200 days', null, false, '10.33.44.55'::inet, '15.hist2@miacaomigo.pt', 15),
    (current_timestamp - interval '180 days', null, false, '10.33.44.56'::inet, '14.hist1@miacaomigo.pt', 14);


--=========================================================
-- 14. ABSENCE (per-user overlap guard awareness)
--=========================================================

insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs, res_abs, cre_tim_abs) values
    (8, current_timestamp - interval '200 days', current_timestamp - interval '192 days', 'ferias de primavera', 'approved', 1, current_timestamp - interval '210 days'),
    (8, current_timestamp + interval '40 days', current_timestamp + interval '55 days', 'ferias familiares', 'pending', null, current_timestamp - interval '5 days'),
    (10, current_timestamp + interval '25 days', current_timestamp + interval '32 days', 'congresso clínico internacional', 'approved', 29, current_timestamp - interval '8 days'),
    (16, current_timestamp - interval '120 days', current_timestamp - interval '118 days', 'consulta de saude ocupacional', 'approved', 1, current_timestamp - interval '125 days'),
    (21, current_timestamp + interval '15 days', current_timestamp + interval '16 days', 'formacao avancada em ortopedia', 'pending', null, current_timestamp - interval '3 days'),
    (29, current_timestamp - interval '60 days', current_timestamp - interval '58 days', 'ausencia detetada por turno', 'detected', null, current_timestamp - interval '57 days'),
    (33, current_timestamp + interval '70 days', current_timestamp + interval '78 days', 'viagem familiar prolongada', 'rejected', 12, current_timestamp - interval '12 days'),
    (35, current_timestamp + interval '10 days', current_timestamp + interval '11 days', 'consulta dentaria', 'cancelled', null, current_timestamp - interval '15 days'),
    (39, current_timestamp - interval '30 days', current_timestamp - interval '29 days', 'formacao interna obrigatoria', 'approved', 13, current_timestamp - interval '32 days'),
    (43, current_timestamp + interval '5 days', current_timestamp + interval '5 days' + interval '6 hours', 'consulta de rotina', 'pending', null, current_timestamp - interval '2 days'),
    (9, current_timestamp - interval '400 days', current_timestamp - interval '392 days', 'licenca parental', 'approved', 12, current_timestamp - interval '410 days'),
    (15, current_timestamp - interval '500 days', current_timestamp - interval '490 days', 'interrupcao contratual antiga', 'approved', 1, current_timestamp - interval '510 days');


--=========================================================
-- 15. CLOCK_IN (closed sessions + limited open shifts)
--=========================================================

insert into clock_in (id_emp, sta_dat_clk, end_dat_clk) values
    (1, current_timestamp - interval '2 days 8 hours', current_timestamp - interval '2 days 1 hours'),
    (4, current_timestamp - interval '2 days 7 hours', current_timestamp - interval '2 days 90 minutes'),
    (8, current_timestamp - interval '3 days 8 hours', current_timestamp - interval '3 days 2 hours'),
    (10, current_timestamp - interval '3 days 9 hours', current_timestamp - interval '3 days 3 hours'),
    (12, current_timestamp - interval '4 days 7 hours', current_timestamp - interval '4 days 1 hours'),
    (16, current_timestamp - interval '4 days 8 hours', current_timestamp - interval '4 days 2 hours'),
    (20, current_timestamp - interval '5 days 8 hours', current_timestamp - interval '5 days'),
    (29, current_timestamp - interval '5 days 7 hours', current_timestamp - interval '5 days 90 minutes'),
    (33, current_timestamp - interval '6 days 8 hours', current_timestamp - interval '6 days 1 hours'),
    (35, current_timestamp - interval '6 days 7 hours', current_timestamp - interval '6 days 2 hours'),
    (39, current_timestamp - interval '7 days 8 hours', current_timestamp - interval '7 days'),
    (43, current_timestamp - interval '7 days 7 hours', current_timestamp - interval '7 days 90 minutes'),
    (46, current_timestamp - interval '8 days 8 hours', current_timestamp - interval '8 days 1 hours'),
    (8, current_timestamp - interval '15 days 8 hours', current_timestamp - interval '15 days 3 hours'),
    (8, current_timestamp - interval '15 days 2 hours', current_timestamp - interval '15 days 30 minutes'),
    (6, current_timestamp - interval '75 minutes', null),
    (22, current_timestamp - interval '95 minutes', null),
    (36, current_timestamp - interval '110 minutes', null);


--=========================================================
-- 16. SEQUENCE REALIGNMENT (identity columns)
--=========================================================
-- Ensures all identity sequences continue from the current
-- maximum stored identifiers after manual identity inserts.

select setval(pg_get_serial_sequence('user_account', 'id_usr'), (select max(id_usr) from user_account));
select setval(pg_get_serial_sequence('employee', 'id_emp'), (select max(id_emp) from employee));
select setval(pg_get_serial_sequence('client', 'id_cli'), (select max(id_cli) from client));
select setval(pg_get_serial_sequence('permission', 'id_per'), (select max(id_per) from permission));
select setval(pg_get_serial_sequence('profile', 'id_pro'), (select max(id_pro) from profile));
select setval(pg_get_serial_sequence('specialty', 'id_spe'), (select max(id_spe) from specialty));
select setval(pg_get_serial_sequence('login_record', 'id_log'), (select max(id_log) from login_record));
select setval(pg_get_serial_sequence('absence', 'id_abs'), (select max(id_abs) from absence));
select setval(pg_get_serial_sequence('clock_in', 'id_clk'), (select max(id_clk) from clock_in));


--=========================================================
-- END
--=========================================================
