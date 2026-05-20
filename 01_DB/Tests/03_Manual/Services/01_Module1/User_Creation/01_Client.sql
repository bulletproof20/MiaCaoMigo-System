--=========================================================
-- MODULE 1 - CLIENT CREATION TESTS
--=========================================================
-- Purpose:
-- Validates fn_create_client behavior using the
-- Creation Stress Test dataset.
--
-- Coverage:
-- - completely new identities
-- - shared employee/client identities
-- - duplicated client accounts
-- - inactive ex-staff client creation
-- - identity consistency validation
-- - ownership validation
-- - invalid formats and constraints
-- - setup trigger propagation
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

    'Novo Cliente Stress',
    'Rua Nova de Teste 100, Braga',
    '4700-100',
    '620000100',
    '+351911100100',
    'novo.cliente.stress@gmail.com',

    '$2b$12$cstress_new_client_001'

);



--=========================================================
-- TEST 2
-- CREATE CLIENT FOR ACTIVE EMPLOYEE IDENTITY
--=========================================================
-- dataset:
-- - id_usr = 1
-- - active employee exists
--
-- expected:
-- - existing user reused
-- - no new user_account created
-- - client created successfully
--=========================================================

select fn_create_client(

    'Mariana Filipa Lopes',
    'Rua do Souto 214, Braga',
    '4700-304',
    '610000001',
    '+351910300001',
    'mariana.lopes.cstress@gmail.com',

    '$2b$12$cstress_client_bind_002',
    '$2b$12$cstress_u01_active_spell03'

);



--=========================================================
-- TEST 3
-- CREATE CLIENT FOR ACTIVE VETERINARIAN
--=========================================================
-- dataset:
-- - id_usr = 4
-- - veterinarian employee
--
-- expected:
-- - existing identity reused
-- - client created successfully
--=========================================================

select fn_create_client(

    'Bruno Filipe Matos',
    'Rua da Junqueira 55, Coimbra',
    '3000-341',
    '610000004',
    '+351910300004',
    'bruno.matos.cstress@outlook.pt',

    '$2b$12$cstress_client_bind_003',
    '$2b$12$cstress_u04_vet_track'

);



--=========================================================
-- TEST 4
-- CREATE CLIENT FOR ACTIVE ASSISTANT
--=========================================================
-- dataset:
-- - id_usr = 5
-- - assistant employee
--
-- expected:
-- - existing identity reused
-- - client created successfully
--=========================================================

select fn_create_client(

    'Leonor Patrícia Sousa',
    'Rua Garrett 18, Lisboa',
    '1200-020',
    '610000005',
    '+351910300005',
    'leonor.sousa.cstress@gmail.com',

    '$2b$12$cstress_client_bind_004',
    '$2b$12$cstress_u05_assist_track'

);



--=========================================================
-- TEST 5
-- DUPLICATED CLIENT ACCOUNT
--=========================================================
-- dataset:
-- - id_usr = 23 already has client
--
-- expected:
-- - fail
-- - duplicated client prevented
--=========================================================

select fn_create_client(

    'Gonçalo Miguel Pratas',
    'Rua da Sé 12, Faro',
    '8000-078',
    '610000023',
    '+351910300023',
    'goncalo.pratas.cstress@gmail.com',

    '$2b$12$cstress_duplicate_client_005'

);



--=========================================================
-- TEST 6
-- EX-STAFF USER ALREADY CLIENT
--=========================================================
-- dataset:
-- - id_usr = 15
-- - inactive employee history
-- - already client
--
-- expected:
-- - fail
-- - duplicated client prevented
--=========================================================

select fn_create_client(

    'Joana Filipa Matias',
    'Rua da Prata 120, Lisboa',
    '1100-416',
    '610000015',
    '+351910300015',
    'joana.matias.cstress@gmail.com',

    '$2b$12$cstress_duplicate_client_006'

);



--=========================================================
-- TEST 7
-- WRONG PASSWORD FOR EXISTING EMPLOYEE
--=========================================================
-- dataset:
-- - id_usr = 2
--
-- expected:
-- - fail
-- - ownership validation failed
--=========================================================

select fn_create_client(

    'Tiago Manuel Ribeiro',
    'Praceta das Oliveiras 8, Guimarães',
    '4810-502',
    '610000002',
    '+351910300002',
    'tiago.ribeiro.cstress@sapo.pt',

    '$2b$12$cstress_wrong_password_007',
    'wrong_password'

);



--=========================================================
-- TEST 8
-- NIF BELONGS TO USER A / EMAIL BELONGS TO USER B
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_client(

    'Identity Conflict',
    'Rua de Teste',
    '4700-999',
    '610000001',
    '+351933333333',
    'sofia.azevedo.cstress@icloud.com',

    '$2b$12$cstress_identity_conflict_008'

);



--=========================================================
-- TEST 9
-- EXISTING NIF + NEW EMAIL
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_client(

    'Partial Conflict',
    'Rua de Teste',
    '4700-999',
    '610000004',
    '+351944444444',
    'novo.email.stress@gmail.com',

    '$2b$12$cstress_partial_conflict_009'

);



--=========================================================
-- TEST 10
-- EXISTING EMAIL + NEW NIF
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_client(

    'Partial Conflict Email',
    'Rua de Teste',
    '4700-999',
    '620999999',
    '+351955555555',
    'bruno.matos.cstress@outlook.pt',

    '$2b$12$cstress_partial_conflict_010'

);



--=========================================================
-- TEST 11
-- INVALID EMAIL FORMAT
--=========================================================
-- expected:
-- - fail
-- - email validation violation
--=========================================================

select fn_create_client(

    'Invalid Email',
    'Rua de Teste',
    '4700-999',
    '620111111',
    '+351966666666',
    'email_invalido',

    '$2b$12$cstress_invalid_email_011'

);



--=========================================================
-- TEST 12
-- INVALID POSTAL CODE
--=========================================================
-- expected:
-- - fail
-- - postal code validation violation
--=========================================================

select fn_create_client(

    'Invalid Postal',
    'Rua de Teste',
    '4700999',
    '620222222',
    '+351977777777',
    'postal.stress@gmail.com',

    '$2b$12$cstress_invalid_postal_012'

);



--=========================================================
-- TEST 13
-- INVALID PHONE FORMAT
--=========================================================
-- expected:
-- - fail
-- - phone validation violation
--=========================================================

select fn_create_client(

    'Invalid Phone',
    'Rua de Teste',
    '4700-999',
    '620333333',
    '912345678',
    'telefone.stress@gmail.com',

    '$2b$12$cstress_invalid_phone_013'

);



--=========================================================
-- TEST 14
-- INVALID PASSWORD HASH
--=========================================================
-- expected:
-- - fail
-- - password validation violation
--=========================================================

select fn_create_client(

    'Invalid Password',
    'Rua de Teste',
    '4700-999',
    '620444444',
    '+351988888888',
    'password.stress@gmail.com',

    '123'

);



--=========================================================
-- TEST 15
-- INVALID NIF FORMAT
--=========================================================
-- expected:
-- - fail
-- - nif validation violation
--=========================================================

select fn_create_client(

    'Invalid NIF',
    'Rua de Teste',
    '4700-999',
    'ABC123',
    '+351999999999',
    'nif.stress@gmail.com',

    '$2b$12$cstress_invalid_nif_015'

);



