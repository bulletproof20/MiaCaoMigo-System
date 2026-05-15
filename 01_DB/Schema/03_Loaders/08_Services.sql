-- =========================================================
-- services loader
-- =========================================================
-- API / business-logic PL/pgSQL (01_DB/Services).
-- Runs after integrity (tables + schema functions) and before
-- data migration / comments / reporting queries.
--
-- Test scripts (*Tests*, 99_*) are intentionally excluded.
-- =========================================================

\echo '========================================'
\echo 'SERVICES LAYER'
\echo '========================================'


-- =========================================================
-- 00_Core
-- =========================================================

\echo '--- services | 00_Core'

\i /docker-entrypoint-initdb.d/05_Services/00_Core/00_Normalization.sql
\i /docker-entrypoint-initdb.d/05_Services/00_Core/02_Validation.sql


-- =========================================================
-- 01_Module1 — core
-- =========================================================

\echo '--- services | module 1 core'

\i /docker-entrypoint-initdb.d/05_Services/01_Module1/00_Core_Mod1/01_Identity.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/00_Core_Mod1/02_Validations.sql


-- =========================================================
-- 01_Module1 — authentication
-- =========================================================

\echo '--- services | module 1 authentication'

\i /docker-entrypoint-initdb.d/05_Services/01_Module1/01_Authentication/00_Common_Auth.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/01_Authentication/01_Login.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/01_Authentication/02_Logout.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/01_Authentication/03_PasswordRecovery.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/01_Authentication/04_PasswordChange.sql


-- =========================================================
-- 01_Module1 — user creation
-- =========================================================

\echo '--- services | module 1 user creation'

\i /docker-entrypoint-initdb.d/05_Services/01_Module1/02_User_Creation/00_Common_UserCreation.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/02_User_Creation/01_NewClient.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/02_User_Creation/02_NewEmployee.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/02_User_Creation/03_NewAssistant.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/02_User_Creation/04_NewVeterian.sql


-- =========================================================
-- 01_Module1 — role change
-- =========================================================

\echo '--- services | module 1 role change'

\i /docker-entrypoint-initdb.d/05_Services/01_Module1/03_Role_Change/00_CommonManagement.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/03_Role_Change/01_Employee_Veterinarian.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/03_Role_Change/02_Employee_Assistant.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/03_Role_Change/03_To_Employee.sql


-- =========================================================
-- 01_Module1 — attendance
-- =========================================================

\echo '--- services | module 1 attendance'

\i /docker-entrypoint-initdb.d/05_Services/01_Module1/04_AttendanceManagment/00_Common.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/04_AttendanceManagment/01_TimeTracking.sql
\i /docker-entrypoint-initdb.d/05_Services/01_Module1/04_AttendanceManagment/02_ScheduleAssignment.sql


\echo '========================================'
\echo 'SERVICES LAYER COMPLETE'
\echo '========================================'
