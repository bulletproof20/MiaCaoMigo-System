-- =========================================================
-- DEVELOPMENT DATA — MODULE 1
-- FILE: 01_CoreDevelopment.sql
-- =========================================================
--
-- PURPOSE
-- Comfortable daily-dev identities (clients + assistant).
--
-- TIER: 02_DevelopmentData (loaded via 04_Loaders/02_DevelopmentData.sql)
--
-- PREREQUISITE
--   04_Loaders/00_MasterData.sql (bootstrap admin id_emp 1, vet id_emp 2)
--
-- ID CONTRACT (after this script on fresh MasterData)
--   id_cli 1–2 — dev clients | id_emp 3 — dev assistant
-- =========================================================

insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) values
    ('Dev Client One', 'Rua Dev 1', '4700-100', '900000001', '+351910900001', 'dev.client1@gmail.com'),
    ('Dev Client Two', 'Rua Dev 2', '4700-101', '900000002', '+351910900002', 'dev.client2@gmail.com');

insert into client (id_usr, pas_cli) values
    ((select id_usr from user_account where ema_usr = 'dev.client1@gmail.com'), 'dev_client_pass_16chars'),
    ((select id_usr from user_account where ema_usr = 'dev.client2@gmail.com'), 'dev_client_pass_16chars');

insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) values
    ('Dev Assistant', 'Rua Dev 3', '4700-102', '900000003', '+351910900003', 'dev.assistant@gmail.com');

insert into employee (id_usr, pho_emp, pho_emg, ema_emp, pas_emp, reg_dat_emp, aut_reg_emp)
select
    u.id_usr,
    '+351210900003',
    '+351910900003',
    u.id_usr::text || '@miacaomigo.pt',
    'dev_employee_pass_16ch',
    current_timestamp,
    1
from user_account u
where u.ema_usr = 'dev.assistant@gmail.com';

insert into assistant (id_emp, fun_ass)
select e.id_emp, 'Desenvolvimento'
from employee e
inner join user_account u on u.id_usr = e.id_usr
where u.ema_usr = 'dev.assistant@gmail.com'
  and e.dea_dat_emp is null;

insert into occupies (id_emp, id_pro)
select e.id_emp, 3
from employee e
inner join user_account u on u.id_usr = e.id_usr
where u.ema_usr = 'dev.assistant@gmail.com'
  and e.dea_dat_emp is null;
