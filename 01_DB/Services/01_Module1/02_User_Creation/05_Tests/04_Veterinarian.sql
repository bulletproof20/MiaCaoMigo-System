--=========================================================
-- MODULE 1 - VETERINARIAN CREATION TESTS
--=========================================================
-- Purpose:
-- Validates full veterinarian onboarding flow:
--
-- - employee creation
-- - veterinarian role assignment
-- - shared identities
-- - duplicated role prevention
-- - assistant/veterinarian exclusivity
-- - OMV uniqueness validation
-- - inactive employee validation
--=========================================================



--=========================================================
-- TEST 1
-- CREATE COMPLETELY NEW VETERINARIAN
--=========================================================
-- expected:
-- - new user_account created
-- - new employee created
-- - veterinarian role created
-- - success
--=========================================================

select fn_create_veterinarian(

    fn_create_employee(

        'Veterinario Novo',
        'Rua Nova Braga',
        '4700-111',
        '299111111',
        '+351911111111',
        'vet.novo@gmail.com',

        '+351253111111',
        '+351939111111',
        '$2b$12$validhashvet00000001',

        1

    ),

    'OMV-PT-2026-CR-99001'

);



--=========================================================
-- TEST 2
-- CREATE VETERINARIAN FOR EXISTING CLIENT IDENTITY
--=========================================================
-- dataset:
-- - id_usr 23 exists as client only
--
-- expected:
-- - existing user reused
-- - employee created
-- - veterinarian role created
--=========================================================

select fn_create_veterinarian(

    fn_create_employee(

        'Gonçalo Miguel Pratas',
        'Rua da Sé 12, Faro',
        '8000-078',
        '610000023',
        '+351910300023',
        'goncalo.pratas.cstress@gmail.com',

        '+351253222222',
        '+351939222222',
        '$2b$12$validhashvet00000002',

        1

    ),

    'OMV-PT-2026-CR-99002'

);



--=========================================================
-- TEST 3
-- DUPLICATED VETERINARIAN ROLE
--=========================================================
-- dataset:
-- - id_emp 8 already veterinarian
--
-- expected:
-- - fail
-- - duplicated veterinarian prevented
--=========================================================

select fn_create_veterinarian(

    8,

    'OMV-PT-2026-CR-99003'

);



--=========================================================
-- TEST 4
-- ASSISTANT ROLE CONFLICT
--=========================================================
-- dataset:
-- - id_emp 9 already assistant
--
-- expected:
-- - fail
-- - assistant conflict detected
--=========================================================

select fn_create_veterinarian(

    9,

    'OMV-PT-2026-CR-99004'

);



--=========================================================
-- TEST 5
-- DUPLICATED OMV REGISTRATION
--=========================================================
-- dataset:
-- - OMV already exists
--
-- expected:
-- - fail
-- - OMV uniqueness enforced
--=========================================================

select fn_create_veterinarian(

    fn_create_employee(

        'Duplicated OMV',
        'Rua Teste',
        '4700-999',
        '299555555',
        '+351955555555',
        'duplicated.omv@gmail.com',

        '+351253555555',
        '+351939555555',
        '$2b$12$validhashvet00000005',

        1

    ),

    'OMV-PT-2024-CR-00841'

);



--=========================================================
-- TEST 6
-- INVALID OMV FORMAT
--=========================================================
-- expected:
-- - fail
-- - OMV constraint violation
--=========================================================

select fn_create_veterinarian(

    fn_create_employee(

        'Invalid OMV',
        'Rua Teste',
        '4700-999',
        '299666666',
        '+351966666666',
        'invalid.omv@gmail.com',

        '+351253666666',
        '+351939666666',
        '$2b$12$validhashvet00000006',

        1

    ),

    ' '

);



--=========================================================
-- TEST 7
-- INVALID REGISTERING EMPLOYEE
--=========================================================
-- expected:
-- - fail
-- - employee creation blocked
--=========================================================

select fn_create_veterinarian(

    fn_create_employee(

        'Invalid Registrar',
        'Rua Teste',
        '4700-999',
        '299777777',
        '+351977777777',
        'invalid.registrar@gmail.com',

        '+351253777777',
        '+351939777777',
        '$2b$12$validhashvet00000007',

        9999

    ),

    'OMV-PT-2026-CR-99007'

);