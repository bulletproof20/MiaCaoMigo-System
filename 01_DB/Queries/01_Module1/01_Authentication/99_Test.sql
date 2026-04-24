-- =========================================================
-- MODULE 1: USER MANAGEMENT - TESTS (LOGIN & LOGOUT)
-- =========================================================


--==============================
-- LOGIN TESTS
--==============================

-- 1. login with non-existent email
-- expected: login_success = false
select * 
from login_user('naoexiste@email.com', 'hashed_password_1234567890', '127.0.0.1');


-- 2. login with incorrect password (existing client)
-- expected: password_ok = false
select * 
from login_user('maria@email.pt', 'wrong_password_1234567890', '127.0.0.1');


-- 3. login client WITH active session
-- seed tem sessão ativa para maria → deve falhar
-- expected: login_success = false, has_active_session = true
select * 
from login_user('maria@email.pt', 'hashed_password_1234567890', '127.0.0.1');


-- 4. login employee WITHOUT active session
-- emp1 tem sessão fechada → deve dar sucesso
-- expected: login_success = true
select * 
from login_user('emp1@miacaomigo.pt', 'hashed_password_1234567890', '127.0.0.1');


-- 5. login employee WITH active session
-- emp2 tem sessão ativa → deve falhar
-- expected: login_success = false
select * 
from login_user('emp2@miacaomigo.pt', 'hashed_password_1234567890', '127.0.0.1');


--==============================
-- LOGOUT TESTS
--==============================

-- 6. logout non-existent user
-- expected: false
select logout_user('naoexiste@email.com');


-- 7. logout client (tem sessão ativa)
-- expected: true
select logout_user('maria@email.pt');


-- 8. logout employee (tem sessão ativa)
-- expected: true
select logout_user('emp1@miacaomigo.pt');


-- 9. logout again (já não tem sessão)
-- expected: false
select logout_user('maria@email.pt');


--==============================
-- EXTRA TEST (APÓS LOGOUT)
--==============================

-- 10. login após logout (client)
-- agora deve conseguir entrar
-- expected: login_success = true
select * 
from login_user('maria@email.pt', 'hashed_password_1234567890', '127.0.0.1');


--==============================
-- DEBUG / VALIDATION
--==============================

-- sessões ativas
select *
from login_record
where sou_tim_log is null
  and suc_log = true;

-- histórico completo
select *
from login_record
order by sig_tim_log desc;