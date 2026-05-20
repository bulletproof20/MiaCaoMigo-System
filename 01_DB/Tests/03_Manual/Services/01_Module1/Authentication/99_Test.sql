-- =========================================================
-- MODULE 1: USER MANAGEMENT - TESTS (LOGIN & LOGOUT)
-- =========================================================


--==============================
-- LOGIN TESTS
--==============================

-- 1. login with non-existent email
-- expected:
-- - login_success = false
-- - password_ok = false
-- - user_id = null

select * 
from login_user(
    'naoexiste@email.com',
    '$2b$12$fakepasswordhash000000000',
    '127.0.0.1'
);


-- 2. login with incorrect password (existing client)
-- helena exists as client
-- expected:
-- - password_ok = false
-- - login_success = false

select * 
from login_user(
    'helena1@gmail.com',
    'wrong_password_hash',
    '127.0.0.1'
);


-- 3. login client WITH active session
-- miguel already has active session in seed
-- expected:
-- - login_success = false
-- - has_active_session = true

select * 
from login_user(
    'miguel1@gmail.com',
    '$2b$12$hash_miguel',
    '127.0.0.1'
);


-- 4. login employee WITHOUT active session
-- carlos has only closed sessions
-- expected:
-- - login_success = true

select * 
from login_user(
    'carlos1@miacaomigo.pt',
    '$2b$12$hash_carlos_secure',
    '127.0.0.1'
);


-- 5. login employee WITH active session
-- sofia already has active session
-- expected:
-- - login_success = false
-- - has_active_session = true

select * 
from login_user(
    'sofia1@miacaomigo.pt',
    '$2b$12$hash_sofia_secure',
    '127.0.0.1'
);


-- 6. login inactive employee
-- employee exists but employment is inactive
-- expected:
-- - login_success = false

select * 
from login_user(
    'pedro1@miacaomigo.pt',
    '$2b$12$hash_pedro_secure',
    '127.0.0.1'
);


--==============================
-- LOGOUT TESTS
--==============================

-- 7. logout non-existent user
-- expected: false

select logout_user(
    'naoexiste@email.com'
);


-- 8. logout client with active session
-- miguel has active session
-- expected: true

select logout_user(
    'miguel1@gmail.com'
);


-- 9. logout employee with active session
-- sofia has active session
-- expected: true

select logout_user(
    'sofia1@miacaomigo.pt'
);


-- 10. logout again (already closed)
-- expected: false

select logout_user(
    'miguel1@gmail.com'
);


--==============================
-- EXTRA TESTS
--==============================

-- 11. login after logout
-- miguel session was closed in previous test
-- expected:
-- - login_success = true

select * 
from login_user(
    'miguel1@gmail.com',
    '$2b$12$hash_miguel',
    '127.0.0.1'
);


-- 12. brute-force simulation
-- repeated invalid attempts

select * 
from login_user(
    'ana1@miacaomigo.pt',
    'wrong_hash_1',
    '192.168.50.10'
);

select * 
from login_user(
    'ana1@miacaomigo.pt',
    'wrong_hash_2',
    '192.168.50.10'
);

select * 
from login_user(
    'ana1@miacaomigo.pt',
    'wrong_hash_3',
    '192.168.50.10'
);


--==============================
-- DEBUG / VALIDATION
--==============================

-- active sessions

select *
from login_record
where sou_tim_log is null
  and suc_log = true;


-- authentication history

select *
from login_record
order by sig_tim_log desc;


-- active employee records

select
    id_emp,
    id_usr,
    ema_emp,
    reg_dat_emp,
    dea_dat_emp
from employee
where dea_dat_emp is null
order by id_usr;


-- inactive employee records

select
    id_emp,
    id_usr,
    ema_emp,
    reg_dat_emp,
    dea_dat_emp
from employee
where dea_dat_emp is not null
order by id_usr;