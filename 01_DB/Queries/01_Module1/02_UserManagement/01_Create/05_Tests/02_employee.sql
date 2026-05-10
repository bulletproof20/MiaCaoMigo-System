--=========================================================
-- MODULE 1 - EMPLOYEE CREATION TESTS
--=========================================================
-- Purpose:
-- Validates fn_create_employee behavior using the
-- Creation Stress Test dataset.
--
-- Coverage:
-- - completely new identities
-- - shared client/employee identities
-- - duplicated employee accounts
-- - inactive registrar validation
-- - identity consistency validation
-- - automatic corporate email generation
-- - employee lifecycle constraints
-- - setup trigger propagation
--=========================================================



--=========================================================
-- TEST 1
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

    'Novo Empregado Stress',
    'Rua Nova de Teste 200, Braga',
    '4700-200',
    '630000200',
    '+351911200200',
    'novo.empregado.stress@gmail.com',

    '+351253200200',
    '+351912200200',
    '$2b$12$cstress_new_employee_001',

    1

);



--=========================================================
-- TEST 2
-- CREATE EMPLOYEE FOR PURE CLIENT IDENTITY
--=========================================================
-- dataset:
-- - id_usr = 23
-- - client only
--
-- expected:
-- - existing identity reused
-- - employee created successfully
--=========================================================

select fn_create_employee(

    'Gonçalo Miguel Pratas',
    'Rua da Sé 12, Faro',
    '8000-078',
    '610000023',
    '+351910300023',
    'goncalo.pratas.cstress@gmail.com',

    '+351253300023',
    '+351913300023',
    '$2b$12$cstress_client_to_employee_002',

    1

);



--=========================================================
-- TEST 3
-- CREATE EMPLOYEE FOR EX-STAFF CLIENT
--=========================================================
-- dataset:
-- - id_usr = 15
-- - inactive employee history only
-- - active client
--
-- expected:
-- - identity reused
-- - new employee spell created
--=========================================================

select fn_create_employee(

    'Joana Filipa Matias',
    'Rua da Prata 120, Lisboa',
    '1100-416',
    '610000015',
    '+351910300015',
    'joana.matias.cstress@gmail.com',

    '+351253300015',
    '+351913300015',
    '$2b$12$cstress_rehire_003',

    1

);



--=========================================================
-- TEST 4
-- DUPLICATED ACTIVE EMPLOYEE
--=========================================================
-- dataset:
-- - id_usr = 1
-- - active employee exists
--
-- expected:
-- - fail
-- - duplicated employee prevented
--=========================================================

select fn_create_employee(

    'Mariana Filipa Lopes',
    'Rua do Souto 214, Braga',
    '4700-304',
    '610000001',
    '+351910300001',
    'mariana.lopes.cstress@gmail.com',

    '+351253400001',
    '+351914400001',
    '$2b$12$cstress_duplicate_employee_004',

    1

);



--=========================================================
-- TEST 5
-- INVALID REGISTRAR EMPLOYEE
--=========================================================
-- expected:
-- - fail
-- - registrar employee does not exist
--=========================================================

select fn_create_employee(

    'Funcionario Invalido',
    'Rua de Teste',
    '4700-999',
    '630000500',
    '+351922222222',
    'funcionario.invalido@gmail.com',

    '+351253500500',
    '+351915500500',
    '$2b$12$cstress_invalid_registrar_005',

    9999

);



--=========================================================
-- TEST 6
-- INACTIVE REGISTRAR EMPLOYEE
--=========================================================
-- dataset:
-- - id_emp = 2
-- - inactive spell
--
-- expected:
-- - fail
-- - registrar employee inactive
--=========================================================

select fn_create_employee(

    'Funcionario Inativo',
    'Rua de Teste',
    '4700-999',
    '630000600',
    '+351933333333',
    'funcionario.inativo@gmail.com',

    '+351253600600',
    '+351916600600',
    '$2b$12$cstress_inactive_registrar_006',

    2

);



--=========================================================
-- TEST 7
-- NIF BELONGS TO USER A / EMAIL BELONGS TO USER B
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_employee(

    'Identity Conflict',
    'Rua de Teste',
    '4700-999',
    '610000001',
    '+351944444444',
    'sofia.azevedo.cstress@icloud.com',

    '+351253700700',
    '+351917700700',
    '$2b$12$cstress_identity_conflict_007',

    1

);



--=========================================================
-- TEST 8
-- EXISTING NIF + NEW EMAIL
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_employee(

    'Partial Conflict',
    'Rua de Teste',
    '4700-999',
    '610000004',
    '+351955555555',
    'novo.empregado@gmail.com',

    '+351253800800',
    '+351918800800',
    '$2b$12$cstress_partial_conflict_008',

    1

);



--=========================================================
-- TEST 9
-- EXISTING EMAIL + NEW NIF
--=========================================================
-- expected:
-- - fail
-- - identity inconsistency detected
--=========================================================

select fn_create_employee(

    'Partial Conflict Email',
    'Rua de Teste',
    '4700-999',
    '630999999',
    '+351966666666',
    'bruno.matos.cstress@outlook.pt',

    '+351253900900',
    '+351919900900',
    '$2b$12$cstress_partial_conflict_009',

    1

);



--=========================================================
-- TEST 10
-- INVALID PROFESSIONAL PHONE
--=========================================================
-- expected:
-- - fail
-- - professional phone validation violation
--=========================================================

select fn_create_employee(

    'Invalid Professional Phone',
    'Rua de Teste',
    '4700-999',
    '631000010',
    '+351977777777',
    'telefone.profissional@gmail.com',

    '912345678',
    '+351920100100',
    '$2b$12$cstress_invalid_phone_010',

    1

);



--=========================================================
-- TEST 11
-- INVALID EMERGENCY PHONE
--=========================================================
-- expected:
-- - fail
-- - emergency phone validation violation
--=========================================================

select fn_create_employee(

    'Invalid Emergency Phone',
    'Rua de Teste',
    '4700-999',
    '631000011',
    '+351988888888',
    'telefone.emergencia@gmail.com',

    '+351253110110',
    '939999999',
    '$2b$12$cstress_invalid_emergency_011',

    1

);



--=========================================================
-- TEST 12
-- INVALID EMAIL FORMAT
--=========================================================
-- expected:
-- - fail
-- - email validation violation
--=========================================================

select fn_create_employee(

    'Invalid Email',
    'Rua de Teste',
    '4700-999',
    '631000012',
    '+351999999999',
    'email_invalido',

    '+351253120120',
    '+351920120120',
    '$2b$12$cstress_invalid_email_012',

    1

);



--=========================================================
-- TEST 13
-- INVALID POSTAL CODE
--=========================================================
-- expected:
-- - fail
-- - postal code validation violation
--=========================================================

select fn_create_employee(

    'Invalid Postal',
    'Rua de Teste',
    '4700999',
    '631000013',
    '+351911111111',
    'postal.employee@gmail.com',

    '+351253130130',
    '+351920130130',
    '$2b$12$cstress_invalid_postal_013',

    1

);



--=========================================================
-- TEST 14
-- INVALID PASSWORD HASH
--=========================================================
-- expected:
-- - fail
-- - password validation violation
--=========================================================

select fn_create_employee(

    'Invalid Password',
    'Rua de Teste',
    '4700-999',
    '631000014',
    '+351922222223',
    'password.employee@gmail.com',

    '+351253140140',
    '+351920140140',
    '123',

    1

);



--=========================================================
-- TEST 15
-- INVALID NIF FORMAT
--=========================================================
-- expected:
-- - fail
-- - nif validation violation
--=========================================================

select fn_create_employee(

    'Invalid NIF',
    'Rua de Teste',
    '4700-999',
    'ABC123',
    '+351933333334',
    'nif.employee@gmail.com',

    '+351253150150',
    '+351920150150',
    '$2b$12$cstress_invalid_nif_015',

    1

);
