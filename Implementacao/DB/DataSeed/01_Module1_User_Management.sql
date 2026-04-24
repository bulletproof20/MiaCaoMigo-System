--=========================================================
-- MODULE 1: USER MANAGEMENT - DATA SEED (FIXED)
--=========================================================
--=========================================================
-- 0.CLEAN DATA 
--=========================================================

truncate table 
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
insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) values
('Ricardo Santos', 'Rua A, Braga', '4700-001', '251000001', '+351910000001', 'ricardo@gmail.com'),
('Ana Silva', 'Rua B, Braga', '4700-002', '251000002', '+351910000002', 'ana@gmail.com'),
('Carlos Mendes', 'Rua C, Porto', '4000-001', '251000003', '+351910000003', 'carlos@email.pt'),
('Maria Costa', 'Rua D, Lisboa', '1000-001', '251000004', '+351910000004', 'maria@email.pt'),
('João Ferreira', 'Rua E, Braga', '4700-003', '251000005', '+351910000005', 'joao@email.pt'),
('Sofia Rocha', 'Rua F, Porto', '4000-002', '251000006', '+351910000006', 'sofia@email.pt');


--=========================================================
-- 2. SETUP (lowercase obrigatório)
--=========================================================
insert into setup (id_usr, the_set, lan_set) values
(1,'dark','pt-pt'),
(2,'light','pt-pt'),
(3,'dark','en-us'),
(4,'light','pt-pt'),
(5,'dark','pt-pt'),
(6,'light','en-us');


--=========================================================
-- 3. EMPLOYEE
-- password >= 20 chars + email corporate válido
--=========================================================
insert into employee (id_usr, pho_emp, ema_emp, pas_emp) values
(1,'+351253000001','emp1@miacaomigo.pt','hashed_password_1234567890'),
(2,'+351253000002','emp2@miacaomigo.pt','hashed_password_1234567890'),
(3,'+351253000003','emp3@miacaomigo.pt','hashed_password_1234567890');


--=========================================================
-- 4. CLIENT
-- password >= 20 chars
--=========================================================
insert into client (id_usr, pas_cli) values
(4,'hashed_password_1234567890'),
(5,'hashed_password_1234567890'),
(6,'hashed_password_1234567890');


--=========================================================
-- 5. PROFILE
--=========================================================
insert into profile (nam_pro, des_pro) values
('administrador','full access'),
('clinico','medical operations'),
('rececionista','front desk');


--=========================================================
-- 6. PERMISSION
--=========================================================
insert into permission (nam_per, des_per) values
('manage_users','users'),
('manage_animals','animals'),
('manage_appointments','appointments');


--=========================================================
-- 8. OCCUPIES
--=========================================================
insert into occupies (id_emp, id_pro) values
(1,1),
(2,2),
(3,3);


--=========================================================
-- 9. SPECIALTY (nome > 3 chars)
--=========================================================
insert into specialty (nam_spe, des_spe) values
('cirurgia geral','cirurgias'),
('medicina geral','consultas');


--=========================================================
-- 10. SPECIALIZATION
--=========================================================
insert into veterinarian (id_emp, num_omv_vet, id_spe) values
(1,'OMV-1001',1),
(2,'OMV-1002',2);

insert into assistant (id_emp, fun_ass) values
(3,'auxiliar clinico');


--=========================================================
-- 11. LOGIN_RECORD
-- emails normalizados
--=========================================================
insert into login_record (sig_tim_log, sou_tim_log, suc_log, ip_add_log, eml_usr, id_usr) values
(now() - interval '2 hours', now() - interval '1 hour', true, '192.168.0.1', 'emp1@miacaomigo.pt', 1),
(now() - interval '30 minutes', null, true, '192.168.0.2', 'emp2@miacaomigo.pt', 2),
(now() - interval '20 minutes', null, true, '192.168.0.3', 'maria@email.pt', 4),
(now() - interval '10 minutes', null, false, '192.168.0.4', 'ana@gmail.com', null);


--=========================================================
-- 12. SCHEDULE
--=========================================================
insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch) values
(1,1,'09:00','18:00'),
(2,2,'09:00','18:00'),
(3,3,'09:00','18:00');


--=========================================================
-- 13. CLOCK_IN (adicionado end_dat_clk opcional)
--=========================================================
insert into clock_in (id_emp, sta_dat_clk, end_dat_clk) values
(1, now() - interval '2 hours', now() - interval '1 hour'),
(2, now() - interval '1 hour', null);


--=========================================================
-- 14. ABSENCE
--=========================================================
insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs) values
(2,'2026-04-10 09:00','2026-04-10 18:00','consulta medica'),
(3,'2026-04-11 09:00','2026-04-11 18:00','ferias');