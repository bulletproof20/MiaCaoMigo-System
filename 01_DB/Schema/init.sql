-- =========================================================
-- INIT: Database Setup (MiaCaoMigo)
-- Orquestra toda a criação da base de dados
-- =========================================================

-- ---------------------------------------------------------
-- 1. EXTENSÕES
-- ---------------------------------------------------------
\echo 'Creating pg_cron extension...'
drop extension if exists pg_cron cascade; -- remove se já existir para evitar erros
create extension if not exists pg_cron;

-- ---------------------------------------------------------
-- 2. CORE (tipos, enums, funções base)
-- ---------------------------------------------------------
-- (ajusta conforme tiveres)
-- \i /docker-entrypoint-initdb.d/00_Core/00_Types.sql
-- \i /docker-entrypoint-initdb.d/00_Core/01_Enums.sql
-- \i /docker-entrypoint-initdb.d/00_Core/02_Functions_Base.sql


-- =========================================================
-- MODULE 1: USER MANAGEMENT
-- =========================================================

\echo 'Initializing Module 1: User Management...'
-- Tabelas
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/00_Table_Mod1.sql
\echo 'Module 1: Tables created.'

-- Funções
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_Functions_Mod1.sql
\echo 'Module 1: Functions created.'

-- Triggers (dependem das funções)
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/02_Trigger_Mod1.sql
\echo 'Module 1: Triggers created.'

-- Índices
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/03_Indexes_Mod1.sql
\echo 'Module 1: Indexes created.'

-- Procedures (se tiveres)
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/04_Procedures_Mod1.sql

-- Jobs (sempre no fim)
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/05_Jobs_Mod1.sql


-- =========================================================
-- MODULE 2: (exemplo)
-- =========================================================

-- \i /docker-entrypoint-initdb.d/01_Modules/02_ModuleX/00_Table.sql
-- \i /docker-entrypoint-initdb.d/01_Modules/02_ModuleX/01_Functions.sql
-- \i /docker-entrypoint-initdb.d/01_Modules/02_ModuleX/02_Triggers.sql
-- \i /docker-entrypoint-initdb.d/01_Modules/02_ModuleX/05_Jobs.sql





-- =========================================================
-- MODULE 3: (exemplo)
-- =========================================================

-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Module3_Commercial_Management.sql
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Module3_Trigger.sql


-- =========================================================
-- MODULE 4: APPOINTMENT MANAGEMENT
-- =========================================================

\echo 'Initializing Module 4: Appointment Management...'
-- Tabelas
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/00_Table_mod4.sql
\echo 'Module 4: Tables created.'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/01_Functions_mod4.sql
\echo 'Module 4: Functions created.'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/02_Triggers_mod4.sql
\echo 'Module 4: Triggers created.'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/03_Jobs_mod4.sql
\echo 'Module 4: Jobs created.'



-- =========================================================
-- FINAL
-- =========================================================
-- sanity check (opcional)
\echo 'Database initialized successfully' AS status;