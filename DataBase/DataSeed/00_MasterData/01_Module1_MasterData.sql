-- =========================================================
-- MASTER DATA — MODULE 1 (USER MANAGEMENT)
-- FILE: 01_Module1_MasterData.sql
-- =========================================================
--
-- PURPOSE
-- Minimal system bootstrap: RBAC lattice, default specialty,
-- and one active administrator employee.
--
-- USAGE
-- Loaded by Bootstrap/Loaders/11_MasterData.sql after Schema/00_Core/00_Data_Cleanup.sql.
-- Inserts only (no TRUNCATE in DataSeed).
--
-- DEPENDENCIES
-- Schema + Services pipeline applied. setup rows are created by
-- trg_create_default_setup on user_account insert (do not insert setup).
--
-- ID CONTRACT: see ../contracts/00_ENTITIES.md (Master tier)
-- STABLE IDENTIFIERS (this file)
--   id_usr 1 — bootstrap administrator identity
--   id_emp 1 — active employee (1@miacaomigo.pt)
--   id_pro 1 — administrador profile
--   id_spe 1 — general clinical specialty
-- =========================================================

set timezone to 'Europe/Lisbon';

-- ---------------------------------------------------------
-- Permissions (core operational set)
-- ---------------------------------------------------------

insert into permission (nam_per, des_per) values
    ('manage_users', 'create, update, and deactivate platform identities'),
    ('manage_roles', 'maintain occupies and have mappings for RBAC'),
    ('manage_animals', 'animal registry and custody lifecycle'),
    ('manage_appointments', 'clinical scheduling and appointment states'),
    ('manage_inventory', 'stock, purchasing, and catalog maintenance'),
    ('view_reports', 'read-only dashboards and exports'),
    ('manage_absences', 'absence approval and workforce compliance'),
    ('audit_security', 'authentication telemetry and security review');

-- ---------------------------------------------------------
-- Profiles (fixed platform roles)
-- ---------------------------------------------------------

insert into profile (nam_pro, des_pro) values
    ('administrador', 'full platform governance and security'),
    ('veterinario', 'clinical practitioner with OMV registration'),
    ('assistente', 'front-office and peri-clinical operations'),
    ('cliente', 'client portal access profile');

-- ---------------------------------------------------------
-- Profile × permission (have)
-- ---------------------------------------------------------

insert into have (id_pro, id_per) values
    (1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8),
    (2, 3), (2, 4), (2, 6),
    (3, 4), (3, 5), (3, 6),
    (4, 6);

-- ---------------------------------------------------------
-- Default clinical specialty
-- ---------------------------------------------------------

insert into specialty (nam_spe, des_spe) values
    ('geral', 'general practice and triage for small animals');

-- ---------------------------------------------------------
-- Bootstrap administrator (shared identity)
-- ---------------------------------------------------------

insert into user_account (id_usr, nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
overriding system value
values (
    1,
    'MiaCaoMigo System Administrator',
    'Avenida Central 1, Braga',
    '4700-001',
    '500000001',
    '+351910000001',
    'admin.bootstrap@gmail.com'
);

insert into employee (
    id_emp,
    id_usr,
    reg_dat_emp,
    aut_reg_emp,
    pho_emp,
    pho_emg,
    ema_emp,
    pas_emp
)
overriding system value
values (
    1,
    1,
    current_timestamp,
    null,
    '+351253000001',
    '+351912000001',
    '1@miacaomigo.pt',
    '$2b$12$bootstrap_admin_hash_16ch'
);

insert into occupies (id_emp, id_pro) values (1, 1);

-- ---------------------------------------------------------
-- Bootstrap clinical veterinarian (scheduling / expert demos)
-- ---------------------------------------------------------

insert into user_account (id_usr, nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
overriding system value
values (
    2,
    'Demo Veterinarian Bootstrap',
    'Rua da Clinica 10, Braga',
    '4700-010',
    '500000002',
    '+351910000002',
    'vet.bootstrap@gmail.com'
);

insert into employee (
    id_emp,
    id_usr,
    reg_dat_emp,
    aut_reg_emp,
    pho_emp,
    pho_emg,
    ema_emp,
    pas_emp
)
overriding system value
values (
    2,
    2,
    current_timestamp,
    1,
    '+351253000002',
    '+351912000002',
    '2@miacaomigo.pt',
    '$2b$12$bootstrap_vet_hash_16ch'
);

insert into occupies (id_emp, id_pro) values (2, 2);

insert into veterinarian (id_emp, num_omv_vet)
values (2, 'OMV-PT-BOOT-00001');

insert into expert (id_emp, id_spe) values (2, 1);

-- ---------------------------------------------------------
-- Identity sequence alignment
-- ---------------------------------------------------------

select setval(pg_get_serial_sequence('user_account', 'id_usr'),
    (select coalesce(max(id_usr), 1) from user_account));
select setval(pg_get_serial_sequence('employee', 'id_emp'),
    (select coalesce(max(id_emp), 1) from employee));
select setval(pg_get_serial_sequence('permission', 'id_per'),
    (select coalesce(max(id_per), 1) from permission));
select setval(pg_get_serial_sequence('profile', 'id_pro'),
    (select coalesce(max(id_pro), 1) from profile));
select setval(pg_get_serial_sequence('specialty', 'id_spe'),
    (select coalesce(max(id_spe), 1) from specialty));



