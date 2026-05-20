-- =========================================================
-- SERVICES LAYER LOADER
-- =========================================================
--
-- DESCRIPTION
-- Application-facing PL/pgSQL functions. Loads after schema
-- integrity (tables, FKs, functions, triggers, indexes, views,
-- procedures, jobs) so all dependencies exist.
--
-- SOURCE
-- Mounted from 01_DB/Services (see docker-compose.yml).
--
-- LOAD ORDER
--   00_Core → Module 1 (core → auth → creation → roles → attendance)
--            → Module 2 → Module 3 → Module 4
-- Executable tests live in 01_DB/Tests/ (not loaded here).
-- =========================================================

\echo '>>> loading services layer (00_Core)'

\i /docker-entrypoint-initdb.d/Services/00_Core/00_Normalization.sql

\echo '>>> loading services layer (01_Module1)'

\i /docker-entrypoint-initdb.d/Services/01_Module1/00_Core_Mod1/01_Identity.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/00_Core_Mod1/02_Validations.sql

\i /docker-entrypoint-initdb.d/Services/01_Module1/01_Authentication/00_Common_Auth.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/01_Authentication/01_Login.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/01_Authentication/02_Logout.sql

\i /docker-entrypoint-initdb.d/Services/01_Module1/02_User_Creation/00_Common_UserCreation.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/02_User_Creation/01_NewClient.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/02_User_Creation/02_NewEmployee.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/02_User_Creation/03_NewAssistant.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/02_User_Creation/04_NewVeterinarian.sql

\i /docker-entrypoint-initdb.d/Services/01_Module1/03_Role_Change/00_CommonManagement.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/03_Role_Change/01_Employee_Veterinarian.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/03_Role_Change/02_Employee_Assistant.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/03_Role_Change/03_To_Employee.sql

\i /docker-entrypoint-initdb.d/Services/01_Module1/04_Attendance_Management/01_TimeTracking.sql
\i /docker-entrypoint-initdb.d/Services/01_Module1/04_Attendance_Management/02_ScheduleAssignment.sql

\echo '>>> loading services layer (02_Module2)'

\i /docker-entrypoint-initdb.d/Services/02_Module2/01_Animal_Lifecycle.sql
\i /docker-entrypoint-initdb.d/Services/02_Module2/02_Animal_Read.sql

\echo '>>> loading services layer (03_Module3)'

\i /docker-entrypoint-initdb.d/Services/03_Module3/01_Session_Read.sql
\i /docker-entrypoint-initdb.d/Services/03_Module3/02_Inventory_Read.sql
\i /docker-entrypoint-initdb.d/Services/03_Module3/03_Commercial_Write.sql

\echo '>>> loading services layer (04_Module4)'

\i /docker-entrypoint-initdb.d/Services/04_Module4/01_Appointment_Read.sql
