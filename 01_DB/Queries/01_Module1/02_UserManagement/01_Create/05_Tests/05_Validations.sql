--=========================================================
-- MODULE 1 - ACCOUNT CREATION TESTS
--=========================================================
-- Purpose:
-- validates:
--
-- - completely new identities
-- - shared employee/client identities
-- - duplicated accounts
-- - identity ownership validation
-- - invalid creator employees
-- - inconsistent identity resolution
-- - invalid input data
-- - constraint enforcement
-- - automatic corporate email generation
--=========================================================



--=========================================================
-- CLIENT CREATION TESTS
--=========================================================



--=========================================================
-- TEST 1
-- CREATE COMPLETELY NEW CLIENT
--=========================================================
-- expected:
-- - new user_account created
-- - new setup created via trigger
-- - new client created
-- - success
--=========================================================

select fn_create_client(

    'Marco Ribeiro',
    'Rua Nova Braga',
    '4700-111',
    '299111111',
    '+351911111111',
    'marco.ribeiro@gmail.com',

    '$2b$12$validhashclient00000001'

);



--=========================================================
-- TEST 2
-- CREATE CLIENT FOR EXISTING EMPLOYEE IDENTITY
--=========================================================
-- expected:
-- - existing user reused
-- - no new user_account created
-- - client created successfully
--=========================================================

select fn_create_client(

    'Ricardo Oliveira',
    'Rua A Braga',
    '4700-001',
    '251200001',
    '+351910200001',
    'ricardo1@miacaomigo.pt',

    '$2b$12$validhashclient00000002',
    '$2b$12$hash_ricardo_secure'

);



--=========================================================
-- TEST 3
-- CREATE DUPLICATED CLIENT ACCOUNT
--=========================================================
-- expected:
-- - fail
-- - user already has client account
--=========================================================

select fn_create_client(

    'Miguel Costa',
    'Rua K Braga',
    '4700-006',
    '251200011',
    '+351910200011',
    'miguel1@gmail.com',

    '$2b$12$validhashclient00000003',
    '$2b$12$hash_miguel'

);



--=========================================================
-- TEST 4
-- EXISTING EMPLOYEE WITH WRONG PASSWORD
--=========================================================
-- expected:
-- - fail
-- - identity ownership validation failed
--=========================================================

select fn_create_client(

    'Ricardo Oliveira',
    'Rua A Braga',
    '4700-001',
    '251200001',
    '+351910200001',
    'ricardo1@miacaomigo.pt',

    '$2b$12$validhashclient00000004',
    'wrong_password'

);



--=========================================================
-- TEST 5
-- NIF BELONGS TO USER A / EMAIL BELONGS TO USER B
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_client(

    'Identity Conflict',
    'Rua Teste',
    '4700-999',
    '251200001',
    '+351922222222',
    'ana1@gmail.com',

    '$2b$12$validhashclient00000005'

);



--=========================================================
-- TEST 6
-- EXISTING NIF + NON-EXISTENT EMAIL
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_client(

    'Partial Conflict NIF',
    'Rua Teste',
    '4700-999',
    '251200001',
    '+351933333333',
    'novoemail@gmail.com',

    '$2b$12$validhashclient00000006'

);



--=========================================================
-- TEST 7
-- EXISTING EMAIL + NON-EXISTENT NIF
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_client(

    'Partial Conflict Email',
    'Rua Teste',
    '4700-999',
    '299888888',
    '+351944444444',
    'ricardo1@gmail.com',

    '$2b$12$validhashclient00000007'

);



--=========================================================
-- TEST 8
-- INVALID EMAIL FORMAT
--=========================================================
-- expected:
-- - fail
-- - email constraint violation
--=========================================================

select fn_create_client(

    'Invalid Email',
    'Rua Teste',
    '4700-999',
    '299333333',
    '+351955555555',
    'email_invalido',

    '$2b$12$validhashclient00000008'

);



--=========================================================
-- TEST 9
-- INVALID POSTAL CODE
--=========================================================
-- expected:
-- - fail
-- - postal code constraint violation
--=========================================================

select fn_create_client(

    'Invalid Postal Code',
    'Rua Teste',
    '4700999',
    '299444444',
    '+351966666666',
    'postal@gmail.com',

    '$2b$12$validhashclient00000009'

);



--=========================================================
-- TEST 10
-- INVALID PHONE FORMAT
--=========================================================
-- expected:
-- - fail
-- - phone constraint violation
--=========================================================

select fn_create_client(

    'Invalid Phone',
    'Rua Teste',
    '4700-999',
    '299555555',
    '912345678',
    'telefone@gmail.com',

    '$2b$12$validhashclient00000010'

);



--=========================================================
-- TEST 11
-- INVALID PASSWORD HASH
--=========================================================
-- expected:
-- - fail
-- - password constraint violation
--=========================================================

select fn_create_client(

    'Short Password',
    'Rua Teste',
    '4700-999',
    '299666666',
    '+351977777777',
    'password@gmail.com',

    '123'

);



--=========================================================
-- TEST 12
-- CORPORATE EMAIL AS CLIENT
--=========================================================
-- expected:
-- - fail
-- - employee email not allowed for client identity
--=========================================================

select fn_create_client(

    'Corporate Client',
    'Rua Teste',
    '4700-999',
    '299777777',
    '+351988888888',
    'corporate@miacaomigo.pt',

    '$2b$12$validhashclient00000012'

);



--=========================================================
-- TEST 13
-- INVALID NIF FORMAT
--=========================================================
-- expected:
-- - fail
-- - nif constraint violation
--=========================================================

select fn_create_client(

    'Invalid NIF',
    'Rua Teste',
    '4700-999',
    'ABC123',
    '+351999999999',
    'nif@gmail.com',

    '$2b$12$validhashclient00000013'

);



--=========================================================
-- EMPLOYEE CREATION TESTS
--=========================================================



--=========================================================
-- TEST 14
-- CREATE COMPLETELY NEW EMPLOYEE
--=========================================================
-- expected:
-- - new user_account created
-- - new setup created via trigger
-- - new employee created
-- - corporate email auto-generated
-- - success
--=========================================================

select fn_create_employee(

    'Bruno Carvalho',
    'Rua Nova Porto',
    '4000-111',
    '288111111',
    '+351911222333',
    'bruno.carvalho@gmail.com',

    '+351252111111',
    '+351939111111',
    '$2b$12$validhashemployee00000014',

    1

);



--=========================================================
-- TEST 15
-- CREATE EMPLOYEE FOR EXISTING CLIENT IDENTITY
--=========================================================
-- expected:
-- - existing user reused
-- - no new user_account created
-- - employee created successfully
--=========================================================

select fn_create_employee(

    'Miguel Costa',
    'Rua K Braga',
    '4700-006',
    '251200011',
    '+351910200011',
    'miguel1@gmail.com',

    '+351252222222',
    '+351939222222',
    '$2b$12$validhashemployee00000015',

    1

);



--=========================================================
-- TEST 16
-- CREATE DUPLICATED EMPLOYEE ACCOUNT
--=========================================================
-- expected:
-- - fail
-- - user already has employee account
--=========================================================

select fn_create_employee(

    'Ricardo Oliveira',
    'Rua A Braga',
    '4700-001',
    '251200001',
    '+351910200001',
    'ricardo1@gmail.com',

    '+351252333333',
    '+351939333333',
    '$2b$12$validhashemployee00000016',

    1

);



--=========================================================
-- TEST 17
-- INVALID CREATOR EMPLOYEE
--=========================================================
-- expected:
-- - fail
-- - creator employee invalid or inactive
--=========================================================

select fn_create_employee(

    'Novo Funcionario',
    'Rua Teste',
    '4700-999',
    '288222222',
    '+351922222222',
    'novo.funcionario@gmail.com',

    '+351252444444',
    '+351939444444',
    '$2b$12$validhashemployee00000017',

    9999

);



--=========================================================
-- TEST 18
-- INACTIVE CREATOR EMPLOYEE
--=========================================================
-- expected:
-- - fail
-- - creator employee invalid or inactive
--=========================================================

select fn_create_employee(

    'Funcionario Invalido',
    'Rua Teste',
    '4700-999',
    '288333333',
    '+351933333333',
    'funcionario.invalido@gmail.com',

    '+351252555555',
    '+351939555555',
    '$2b$12$validhashemployee00000018',

    10

);



--=========================================================
-- TEST 19
-- INVALID PROFESSIONAL PHONE
--=========================================================
-- expected:
-- - fail
-- - professional phone constraint violation
--=========================================================

select fn_create_employee(

    'Invalid Professional Phone',
    'Rua Teste',
    '4700-999',
    '288666666',
    '+351988888888',
    'telefone.profissional@gmail.com',

    '912345678',
    '+351931111111',
    '$2b$12$validhashemployee00000019',

    1

);



--=========================================================
-- TEST 20
-- INVALID EMERGENCY PHONE
--=========================================================
-- expected:
-- - fail
-- - emergency phone constraint violation
--=========================================================

select fn_create_employee(

    'Invalid Emergency Phone',
    'Rua Teste',
    '4700-999',
    '288777777',
    '+351999999999',
    'telefone.emergencia@gmail.com',

    '+351252121212',
    '939999999',
    '$2b$12$validhashemployee00000020',

    1

);



--=========================================================
-- TEST 21
-- INVALID PASSWORD HASH
--=========================================================
-- expected:
-- - fail
-- - password constraint violation
--=========================================================

select fn_create_employee(

    'Short Password',
    'Rua Teste',
    '4700-999',
    '288888888',
    '+351911111112',
    'password.employee@gmail.com',

    '+351252131313',
    '+351939131313',
    '123',

    1

);



--=========================================================
-- TEST 22
-- INVALID NIF FORMAT
--=========================================================
-- expected:
-- - fail
-- - nif constraint violation
--=========================================================

select fn_create_employee(

    'Invalid NIF',
    'Rua Teste',
    '4700-999',
    'ABC123',
    '+351922222223',
    'nif.employee@gmail.com',

    '+351252141414',
    '+351939141414',
    '$2b$12$validhashemployee00000022',

    1

);



--=========================================================
-- VERIFICATION TESTS
--=========================================================



--=========================================================
-- TEST 23
-- VERIFY USER + CLIENT RELATION
--=========================================================
-- expected:
-- - validate successful client associations
--=========================================================

select
    u.id_usr,
    u.nam_usr,
    u.nif_usr,
    u.ema_usr,
    c.id_cli,
    c.reg_dat_cli
from user_account as u
join client as c
    on c.id_usr = u.id_usr
order by u.id_usr desc;



--=========================================================
-- TEST 24
-- VERIFY USER + EMPLOYEE RELATION
--=========================================================
-- expected:
-- - validate employee associations
--=========================================================

select
    u.id_usr,
    u.nam_usr,
    u.nif_usr,
    u.ema_usr,
    e.id_emp,
    e.ema_emp,
    e.dea_dat_emp
from user_account as u
join employee as e
    on e.id_usr = u.id_usr
order by u.id_usr desc;



--=========================================================
-- TEST 25
-- VERIFY SHARED EMPLOYEE + CLIENT IDENTITIES
--=========================================================
-- expected:
-- - users with both employee and client roles
--=========================================================

select
    u.id_usr,
    u.nam_usr,
    u.nif_usr,
    u.ema_usr,
    e.id_emp,
    e.ema_emp,
    e.pas_emp,
    c.id_cli,
    c.pas_cli
from user_account as u
join employee as e
    on e.id_usr = u.id_usr
join client as c
    on c.id_usr = u.id_usr
order by u.id_usr desc;



--=========================================================
-- TEST 26
-- VERIFY GENERATED CORPORATE EMAILS
--=========================================================
-- expected:
-- - employee emails follow:
--   id_usr@miacaomigo.pt
--=========================================================

select
    e.id_emp,
    e.id_usr,
    e.ema_emp
from employee as e
order by e.id_emp desc;



--=========================================================
-- TEST 27
-- VERIFY USER ACCOUNTS
--=========================================================
-- expected:
-- - validate all stored identities
--=========================================================

select
    u.id_usr,
    u.nam_usr,
    u.nif_usr,
    u.ema_usr
from user_account as u
order by u.id_usr desc;