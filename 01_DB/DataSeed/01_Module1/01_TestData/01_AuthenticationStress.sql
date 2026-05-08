--=========================================================
-- MODULE 1 - AUTHENTICATION STRESS TEST DATA
--=========================================================
-- Purpose:
-- High-volume authentication dataset used to validate:
--
-- - employee/client authentication
-- - RBAC logic
-- - login history
-- - failed logins
-- - active sessions
-- - brute-force patterns
-- - historical authentication activity
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
-- USER_ACCOUNT
--=========================================================

insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
values
('Ricardo Oliveira','Rua A, Braga','4700-001','251200001','+351910200001','ricardo1@gmail.com'),
('Ana Martins','Rua B, Braga','4700-002','251200002','+351910200002','ana1@gmail.com'),
('Carlos Ferreira','Rua C, Porto','4000-001','251200003','+351910200003','carlos1@gmail.com'),
('Sofia Almeida','Rua D, Porto','4000-002','251200004','+351910200004','sofia1@gmail.com'),
('Tiago Costa','Rua E, Braga','4700-003','251200005','+351910200005','tiago1@gmail.com'),
('Beatriz Sousa','Rua F, Braga','4700-004','251200006','+351910200006','beatriz1@gmail.com'),
('Mariana Rocha','Rua G, Lisboa','1000-001','251200007','+351910200007','mariana1@gmail.com'),
('Joao Mendes','Rua H, Lisboa','1000-002','251200008','+351910200008','joao1@gmail.com'),
('Pedro Silva','Rua I, Braga','4700-005','251200009','+351910200009','pedro1@gmail.com'),
('Filipa Santos','Rua J, Porto','4000-003','251200010','+351910200010','filipa1@gmail.com'),
('Miguel Costa','Rua K, Braga','4700-006','251200011','+351910200011','miguel1@gmail.com'),
('Andre Rocha','Rua L, Braga','4700-007','251200012','+351910200012','andre1@gmail.com'),
('Carla Mendes','Rua M, Porto','4000-004','251200013','+351910200013','carla1@gmail.com'),
('Rita Ferreira','Rua N, Lisboa','1000-003','251200014','+351910200014','rita1@gmail.com'),
('Daniel Sousa','Rua O, Braga','4700-008','251200015','+351910200015','daniel1@gmail.com'),
('Patricia Costa','Rua P, Porto','4000-005','251200016','+351910200016','patricia1@gmail.com'),
('Luis Almeida','Rua Q, Braga','4700-009','251200017','+351910200017','luis1@gmail.com'),
('Sara Martins','Rua R, Braga','4700-010','251200018','+351910200018','sara1@gmail.com'),
('Vitor Rocha','Rua S, Porto','4000-006','251200019','+351910200019','vitor1@gmail.com'),
('Helena Silva','Rua T, Lisboa','1000-004','251200020','+351910200020','helena1@gmail.com');



--=========================================================
-- EMPLOYEE
--=========================================================
-- Users 1-8 keep one active employee record
-- Users 9-10 become fully inactive
--=========================================================

insert into employee (
    id_usr,
    pho_emp,
    pho_emg,
    ema_emp,
    pas_emp,
    reg_dat_emp,
    aut_reg_emp,
    dea_dat_emp,
    aut_ina_emp
)
values

-- USER 1
(1,'+351253200101','+351930200101','ricardo.old1@miacaomigo.pt','$2b$12$hash_ricardo_old1_secure',current_timestamp - interval '5 years',2,current_timestamp - interval '4 years',2),
(1,'+351253200102','+351930200102','ricardo.old2@miacaomigo.pt','$2b$12$hash_ricardo_old2_secure',current_timestamp - interval '4 years',2,current_timestamp - interval '2 years',2),
(1,'+351253200001','+351930200001','ricardo1@miacaomigo.pt','$2b$12$hash_ricardo_secure',current_timestamp - interval '2 years',2,null,null),

-- USER 2
(2,'+351253200201','+351930200201','ana.old1@miacaomigo.pt','$2b$12$hash_ana_old1_secure',current_timestamp - interval '6 years',1,current_timestamp - interval '5 years',1),
(2,'+351253200202','+351930200202','ana.old2@miacaomigo.pt','$2b$12$hash_ana_old2_secure',current_timestamp - interval '5 years',1,current_timestamp - interval '3 years',1),
(2,'+351253200203','+351930200203','ana.old3@miacaomigo.pt','$2b$12$hash_ana_old3_secure',current_timestamp - interval '3 years',1,current_timestamp - interval '1 year',1),
(2,'+351253200002','+351930200002','ana1@miacaomigo.pt','$2b$12$hash_ana_secure',current_timestamp - interval '1 year',1,null,null),

-- USER 3
(3,'+351253200301','+351930200301','carlos.old1@miacaomigo.pt','$2b$12$hash_carlos_old1_secure',current_timestamp - interval '3 years',1,current_timestamp - interval '8 months',2),
(3,'+351253200003','+351930200003','carlos1@miacaomigo.pt','$2b$12$hash_carlos_secure',current_timestamp - interval '8 months',2,null,null),

-- USER 4
(4,'+351253200004','+351930200004','sofia1@miacaomigo.pt','$2b$12$hash_sofia_secure',current_timestamp - interval '1 year',1,null,null),

-- USER 5
(5,'+351253200501','+351930200501','tiago.old1@miacaomigo.pt','$2b$12$hash_tiago_old1_secure',current_timestamp - interval '7 years',1,current_timestamp - interval '6 years',2),
(5,'+351253200502','+351930200502','tiago.old2@miacaomigo.pt','$2b$12$hash_tiago_old2_secure',current_timestamp - interval '6 years',2,current_timestamp - interval '5 years',1),
(5,'+351253200503','+351930200503','tiago.old3@miacaomigo.pt','$2b$12$hash_tiago_old3_secure',current_timestamp - interval '5 years',1,current_timestamp - interval '3 years',2),
(5,'+351253200504','+351930200504','tiago.old4@miacaomigo.pt','$2b$12$hash_tiago_old4_secure',current_timestamp - interval '3 years',2,current_timestamp - interval '10 months',1),
(5,'+351253200005','+351930200005','tiago1@miacaomigo.pt','$2b$12$hash_tiago_secure',current_timestamp - interval '10 months',1,null,null),

-- USER 6
(6,'+351253200601','+351930200601','beatriz.old1@miacaomigo.pt','$2b$12$hash_beatriz_old1_secure',current_timestamp - interval '2 years',1,current_timestamp - interval '8 months',1),
(6,'+351253200006','+351930200006','beatriz1@miacaomigo.pt','$2b$12$hash_beatriz_secure',current_timestamp - interval '8 months',1,null,null),

-- USER 7
(7,'+351253200701','+351930200701','mariana.old1@miacaomigo.pt','$2b$12$hash_mariana_old1_secure',current_timestamp - interval '4 years',1,current_timestamp - interval '2 years',2),
(7,'+351253200702','+351930200702','mariana.old2@miacaomigo.pt','$2b$12$hash_mariana_old2_secure',current_timestamp - interval '2 years',2,current_timestamp - interval '6 months',1),
(7,'+351253200007','+351930200007','mariana1@miacaomigo.pt','$2b$12$hash_mariana_secure',current_timestamp - interval '6 months',1,null,null),

-- USER 8
(8,'+351253200008','+351930200008','joao1@miacaomigo.pt','$2b$12$hash_joao_secure',current_timestamp - interval '5 months',1,null,null),

-- USER 9 (FULLY INACTIVE)
(9,'+351253200901','+351930200901','pedro.old1@miacaomigo.pt','$2b$12$hash_pedro_old1_secure',current_timestamp - interval '2 years',1,current_timestamp - interval '1 year',2),
(9,'+351253200009','+351930200009','pedro1@miacaomigo.pt','$2b$12$hash_pedro_secure',current_timestamp - interval '1 year',2,current_timestamp - interval '4 months',2),

-- USER 10 (FULLY INACTIVE)
(10,'+351253201001','+351930201001','filipa.old1@miacaomigo.pt','$2b$12$hash_filipa_old1_secure',current_timestamp - interval '8 years',1,current_timestamp - interval '7 years',2),
(10,'+351253201002','+351930201002','filipa.old2@miacaomigo.pt','$2b$12$hash_filipa_old2_secure',current_timestamp - interval '7 years',2,current_timestamp - interval '6 years',1),
(10,'+351253201003','+351930201003','filipa.old3@miacaomigo.pt','$2b$12$hash_filipa_old3_secure',current_timestamp - interval '6 years',1,current_timestamp - interval '4 years',2),
(10,'+351253201004','+351930201004','filipa.old4@miacaomigo.pt','$2b$12$hash_filipa_old4_secure',current_timestamp - interval '4 years',2,current_timestamp - interval '2 years',1),
(10,'+351253201005','+351930201005','filipa.old5@miacaomigo.pt','$2b$12$hash_filipa_old5_secure',current_timestamp - interval '2 years',1,current_timestamp - interval '1 year',2),
(10,'+351253200010','+351930200010','filipa1@miacaomigo.pt','$2b$12$hash_filipa_secure',current_timestamp - interval '1 year',2,current_timestamp - interval '3 months',1);


--=========================================================
-- CLIENT
--=========================================================

insert into client (id_usr, pas_cli, reg_dat_cli)
values
(11,'$2b$12$hash_miguel',current_timestamp - interval '2 years'),
(12,'$2b$12$hash_andre',current_timestamp - interval '1 year'),
(13,'$2b$12$hash_carla',current_timestamp - interval '10 months'),
(14,'$2b$12$hash_rita',current_timestamp - interval '9 months'),
(15,'$2b$12$hash_daniel',current_timestamp - interval '8 months'),
(16,'$2b$12$hash_patricia',current_timestamp - interval '7 months'),
(17,'$2b$12$hash_luis',current_timestamp - interval '6 months'),
(18,'$2b$12$hash_sara',current_timestamp - interval '5 months'),
(19,'$2b$12$hash_vitor',current_timestamp - interval '4 months'),
(20,'$2b$12$hash_helena',current_timestamp - interval '3 months');



--=========================================================
-- LOGIN_RECORD
--=========================================================

insert into login_record (sig_tim_log, sou_tim_log, suc_log, ip_add_log, eml_usr, id_usr)
values

-- successful employee sessions
(current_timestamp - interval '10 hours',current_timestamp - interval '6 hours',true,'192.168.1.10','ricardo1@miacaomigo.pt',1),
(current_timestamp - interval '9 hours',current_timestamp - interval '5 hours',true,'192.168.1.11','ana1@miacaomigo.pt',2),
(current_timestamp - interval '8 hours',current_timestamp - interval '4 hours',true,'192.168.1.12','carlos1@miacaomigo.pt',3),
(current_timestamp - interval '7 hours',null,true,'192.168.1.13','sofia1@miacaomigo.pt',4),
(current_timestamp - interval '6 hours',null,true,'192.168.1.14','tiago1@miacaomigo.pt',5),

-- successful client sessions
(current_timestamp - interval '5 hours',null,true,'192.168.1.20','miguel1@gmail.com',11),
(current_timestamp - interval '4 hours',null,true,'192.168.1.21','andre1@gmail.com',12),
(current_timestamp - interval '3 hours',null,true,'192.168.1.22','carla1@gmail.com',13),

-- failed unknown users
(current_timestamp - interval '2 hours',null,false,'192.168.1.100','intruder1@gmail.com',null),
(current_timestamp - interval '110 minutes',null,false,'192.168.1.101','intruder2@gmail.com',null),
(current_timestamp - interval '100 minutes',null,false,'192.168.1.102','intruder3@gmail.com',null),

-- brute force simulation
(current_timestamp - interval '90 minutes',null,false,'192.168.50.10','ana1@miacaomigo.pt',2),
(current_timestamp - interval '89 minutes',null,false,'192.168.50.10','ana1@miacaomigo.pt',2),
(current_timestamp - interval '88 minutes',null,false,'192.168.50.10','ana1@miacaomigo.pt',2),
(current_timestamp - interval '87 minutes',null,false,'192.168.50.10','ana1@miacaomigo.pt',2),
(current_timestamp - interval '86 minutes',null,false,'192.168.50.10','ana1@miacaomigo.pt',2),

-- mixed authentication activity
(current_timestamp - interval '80 minutes',null,false,'10.0.0.20','pedro1@miacaomigo.pt',9),
(current_timestamp - interval '75 minutes',null,true,'10.0.0.20','pedro1@miacaomigo.pt',9),
(current_timestamp - interval '70 minutes',null,false,'10.0.0.21','filipa1@miacaomigo.pt',10),
(current_timestamp - interval '65 minutes',null,true,'10.0.0.21','filipa1@miacaomigo.pt',10),

-- historical sessions
(current_timestamp - interval '20 days',current_timestamp - interval '20 days' + interval '8 hours',true,'172.16.1.1','ricardo1@miacaomigo.pt',1),
(current_timestamp - interval '18 days',current_timestamp - interval '18 days' + interval '7 hours',true,'172.16.1.2','ana1@miacaomigo.pt',2),
(current_timestamp - interval '15 days',current_timestamp - interval '15 days' + interval '9 hours',true,'172.16.1.3','carlos1@miacaomigo.pt',3),
(current_timestamp - interval '12 days',current_timestamp - interval '12 days' + interval '5 hours',true,'172.16.1.4','miguel1@gmail.com',11),
(current_timestamp - interval '10 days',current_timestamp - interval '10 days' + interval '6 hours',true,'172.16.1.5','andre1@gmail.com',12),

-- more failed attempts
(current_timestamp - interval '50 minutes',null,false,'203.0.113.10','fake1@email.pt',null),
(current_timestamp - interval '45 minutes',null,false,'203.0.113.11','fake2@email.pt',null),
(current_timestamp - interval '40 minutes',null,false,'203.0.113.12','fake3@email.pt',null),
(current_timestamp - interval '35 minutes',null,false,'203.0.113.13','fake4@email.pt',null),
(current_timestamp - interval '30 minutes',null,false,'203.0.113.14','fake5@email.pt',null),

-- client failures
(current_timestamp - interval '10 minutes',null,false,'192.168.60.10','rita1@gmail.com',14),
(current_timestamp - interval '9 minutes',null,false,'192.168.60.10','rita1@gmail.com',14),
(current_timestamp - interval '8 minutes',null,false,'192.168.60.10','rita1@gmail.com',14),

-- failed logins on inactive employee accounts
-- credentials/email correct but account already inactive

(current_timestamp - interval '50 days',null,false,'185.10.10.10','pedro1@miacaomigo.pt',9),
(current_timestamp - interval '40 days',null,false,'185.10.10.11','pedro1@miacaomigo.pt',9),
(current_timestamp - interval '30 days',null,false,'185.10.10.12','pedro1@miacaomigo.pt',9),

(current_timestamp - interval '80 days',null,false,'185.20.20.10','filipa1@miacaomigo.pt',10),
(current_timestamp - interval '70 days',null,false,'185.20.20.11','filipa1@miacaomigo.pt',10),
(current_timestamp - interval '60 days',null,false,'185.20.20.12','filipa1@miacaomigo.pt',10),

-- repeated attempts after deactivation
(current_timestamp - interval '20 days',null,false,'203.10.10.10','pedro1@miacaomigo.pt',9),
(current_timestamp - interval '15 days',null,false,'203.10.10.10','pedro1@miacaomigo.pt',9),

(current_timestamp - interval '10 days',null,false,'203.20.20.20','filipa1@miacaomigo.pt',10),
(current_timestamp - interval '5 days',null,false,'203.20.20.20','filipa1@miacaomigo.pt',10),

-- old inactive historical emails
(current_timestamp - interval '300 days',null,false,'10.10.10.10','pedro.old1@miacaomigo.pt',9),
(current_timestamp - interval '200 days',null,false,'10.10.10.11','filipa.old5@miacaomigo.pt',10),

-- latest successful authentications

(current_timestamp - interval '5 minutes',null,true,'192.168.1.200','sofia1@miacaomigo.pt',4),
(current_timestamp - interval '3 minutes',null,true,'192.168.1.201','mariana1@gmail.com',7),
(current_timestamp - interval '1 minute',null,true,'192.168.1.202','helena1@gmail.com',20),

-- reconnect after explicit logout

(current_timestamp - interval '55 minutes',current_timestamp - interval '30 minutes',true,'192.168.10.10','ricardo1@miacaomigo.pt',1),
(current_timestamp - interval '25 minutes',null,true,'192.168.10.11','ricardo1@miacaomigo.pt',1),

(current_timestamp - interval '4 hours',current_timestamp - interval '2 hours',true,'10.1.1.10','ana1@miacaomigo.pt',2),
(current_timestamp - interval '90 minutes',null,true,'10.1.1.11','ana1@miacaomigo.pt',2),

(current_timestamp - interval '3 hours',current_timestamp - interval '1 hour',true,'192.168.88.10','carla1@gmail.com',13),
(current_timestamp - interval '40 minutes',null,true,'192.168.88.11','carla1@gmail.com',13),

-- blocked login attempts because active session already exists

(current_timestamp - interval '20 minutes',null,false,'192.168.10.12','ricardo1@miacaomigo.pt',1),
(current_timestamp - interval '18 minutes',null,false,'192.168.10.13','ricardo1@miacaomigo.pt',1),

(current_timestamp - interval '70 minutes',null,false,'10.1.1.12','ana1@miacaomigo.pt',2),

(current_timestamp - interval '15 minutes',null,false,'172.20.1.12','miguel1@gmail.com',11),

(current_timestamp - interval '25 minutes',null,false,'192.168.88.12','carla1@gmail.com',13),

-- session terminated before inactive account access attempts

(current_timestamp - interval '5 months',current_timestamp - interval '5 months' + interval '3 hours',true,'185.10.10.1','pedro1@miacaomigo.pt',9),
(current_timestamp - interval '4 months',current_timestamp - interval '4 months' + interval '2 hours',true,'185.20.20.1','filipa1@miacaomigo.pt',10);