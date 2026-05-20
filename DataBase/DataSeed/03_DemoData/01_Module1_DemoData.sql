-- =========================================================
-- DEMO DATA — MODULE 1 (USER MANAGEMENT)
-- FILE: 01_Module1_DemoData.sql
-- =========================================================
--
-- PURPOSE
-- Realistic clinic staff and client identities for staging/demos.
-- Requires 00_MasterData/01_Module1_MasterData.sql (bootstrap ids 1–2).
-- =========================================================

set timezone to 'Europe/Lisbon';

-- ---------------------------------------------------------
-- Additional specialties
-- ---------------------------------------------------------

insert into specialty (nam_spe, des_spe) values
    ('dermatologia', 'skin and coat disorders'),
    ('cirurgia', 'surgical procedures'),
    ('medicina interna', 'internal medicine');

-- ---------------------------------------------------------
-- Staff and clients (user_account)
-- ---------------------------------------------------------

insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) values
    ('João Silva', 'Rua das Flores 1, Lisboa', '1000-001', '123456789', '+351912345678', 'joao.silva@gmail.com'),
    ('Maria Oliveira', 'Av. da Liberdade 10, Lisboa', '1200-010', '234567890', '+351922345678', 'maria.oli@outlook.com'),
    ('Carlos Santos', 'Rua Central 5, Porto', '4000-005', '345678901', '+351932345678', 'carlos.santos@sapo.pt'),
    ('Ana Pereira', 'Praça da República 2, Braga', '4700-002', '456789012', '+351962345678', 'ana.p@gmail.com'),
    ('Ricardo Ramos', 'Rua Direita 5, Guimarães', '4800-005', '523456789', '+351910000005', 'ric.ramos@gmail.com');

-- id_usr 3–7 from above (after master 1–2)

insert into employee (id_usr, pho_emp, pho_emg, ema_emp, pas_emp, reg_dat_emp, aut_reg_emp) values
    (3, '+351210000001', '+351910000001', '3@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', current_timestamp, 1),
    (4, '+351210000002', '+351910000002', '4@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', current_timestamp, 1),
    (5, '+351210000003', '+351910000003', '5@miacaomigo.pt', 'hash_seguro_com_mais_de_16_caracteres', current_timestamp, 1);

insert into veterinarian (id_emp, num_omv_vet) values
    (3, 'OMV-PT-DEMO-00003'),
    (4, 'OMV-PT-DEMO-00004');

insert into assistant (id_emp, fun_ass) values
    (5, 'Receção e apoio clínico');

insert into expert (id_emp, id_spe) values
    (3, 1), (3, 2),
    (4, 1), (4, 3);

insert into occupies (id_emp, id_pro) values
    (3, 2), (4, 2), (5, 3);

insert into client (id_usr, pas_cli) values
    (6, 'senha_cliente_muito_segura_123'),
    (7, 'senha_cliente_muito_segura_123');

insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch)
select e.id_emp, d.day, '09:00'::time, '18:00'::time
from employee e
cross join generate_series(1, 5) as d(day)
where e.dea_dat_emp is null;
