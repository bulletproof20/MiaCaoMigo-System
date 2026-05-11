--=========================================================
-- MODULE 1 - ASSISTANT CREATION TESTS
--=========================================================
-- Purpose:
-- Validates full assistant onboarding flow:
--
-- - employee creation
-- - assistant role assignment
-- - shared identities
-- - duplicated role prevention
-- - assistant/veterinarian exclusivity
-- - inactive employee validation
--=========================================================



--=========================================================
-- TEST 1
-- CREATE COMPLETELY NEW ASSISTANT
--=========================================================
-- expected:
-- - new user_account created
-- - new employee created
-- - assistant role created
-- - success
--=========================================================

select fn_create_assistant(

    fn_create_employee(

        'Assistant Novo',
        'Rua Nova Braga',
        '4700-111',
        '288111111',
        '+351911111111',
        'assistant.novo@gmail.com',

        '+351253111111',
        '+351939111111',
        '$2b$12$validhashassistant000001',

        1

    ),

    'triagem clinica'

);



--=========================================================
-- TEST 2
-- CREATE ASSISTANT FOR EXISTING CLIENT IDENTITY
--=========================================================
-- dataset:
-- - id_usr 24 exists as client only
--
-- expected:
-- - existing user reused
-- - employee created
-- - assistant role created
--=========================================================

select fn_create_assistant(

    fn_create_employee(

        'Margarida Leonor Vieira',
        'Rua de Camões 55, Lisboa',
        '1150-082',
        '610000024',
        '+351910300024',
        'margarida.vieira.cstress@sapo.pt',

        '+351253222222',
        '+351939222222',
        '$2b$12$validhashassistant000002',

        1

    ),

    'rececao e apoio administrativo'

);



--=========================================================
-- TEST 3
-- DUPLICATED ASSISTANT ROLE
--=========================================================
-- dataset:
-- - id_emp 9 already assistant
--
-- expected:
-- - fail
-- - duplicated assistant prevented
--=========================================================

select fn_create_assistant(

    9,

    'duplicated role'

);



--=========================================================
-- TEST 4
-- VETERINARIAN ROLE CONFLICT
--=========================================================
-- dataset:
-- - id_emp 8 already veterinarian
--
-- expected:
-- - fail
-- - veterinarian conflict detected
--=========================================================

select fn_create_assistant(

    8,

    'conflicting role'

);



--=========================================================
-- TEST 5
-- INVALID FUNCTION DESCRIPTION
--=========================================================
-- expected:
-- - fail
-- - check constraint violation
--=========================================================

select fn_create_assistant(

    fn_create_employee(

        'Invalid Assistant',
        'Rua Teste',
        '4700-999',
        '288555555',
        '+351955555555',
        'invalid.assistant@gmail.com',

        '+351253555555',
        '+351939555555',
        '$2b$12$validhashassistant000005',

        1

    ),

    ' '

);



--=========================================================
-- TEST 6
-- INVALID REGISTERING EMPLOYEE
--=========================================================
-- expected:
-- - fail
-- - employee creation blocked
--=========================================================

select fn_create_assistant(

    fn_create_employee(

        'Invalid Registrar',
        'Rua Teste',
        '4700-999',
        '288666666',
        '+351966666666',
        'invalid.registrar@gmail.com',

        '+351253666666',
        '+351939666666',
        '$2b$12$validhashassistant000006',

        9999

    ),

    'support operations'

);
