-- =========================================================
-- INIT: Database Setup (MiaCaoMigo)
-- Orquestra toda a criação da base de dados
-- =========================================================
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
-- \echo '--- Including Core Types...'
-- \i /docker-entrypoint-initdb.d/00_Core/00_Types.sql =======AINDA NAO EXISTEM=========
-- \echo '--- Including Core Enums...'
-- \i /docker-entrypoint-initdb.d/00_Core/01_Enums.sql
-- \echo '--- Including Core Base Functions...'
-- \i /docker-entrypoint-initdb.d/00_Core/02_Functions_Base.sql


-- =========================================================
-- MODULE 1: USER MANAGEMENT
-- =========================================================
\echo '--- Starting Module 1: User Management ---'

-- Tabelas
\echo '--- Including Module 1 Tables...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/00_Table_Mod1.sql

-- Funções
\echo '--- Including Module 1 Functions...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_Functions_Mod1.sql

-- Triggers (dependem das funções)
\echo '--- Including Module 1 Triggers...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/02_Trigger_Mod1.sql

-- Índices
\echo '--- Including Module 1 Indexes...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/03_Indexes_Mod1.sql

-- Procedures (se tiveres)
\echo '--- Including Module 1 Procedures...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/04_Procedures_Mod1.sql

-- Jobs (sempre no fim)
\echo '--- Including Module 1 Jobs...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/05_Jobs_Mod1.sql


-- =========================================================
-- MODULE 2: ANIMAL MANAGEMENT
-- =========================================================
\echo '--- Starting Module 2: Animal Management ---'
\echo '--- Including Module 2 Tables...'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/00_table_mod2.sql

\echo '--- Including Module 2 Functions...'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/01_Functions_mod2.sql

\echo '--- Including Module 2 Triggers...'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/02_Triggers_mod2.sql

-- \echo '--- Including Module 2 Jobs...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_ModuleX/05_Jobs.sql


-- =========================================================
-- MODULE 3: COMMERCIAL MANAGEMENT
-- =========================================================
\echo '--- Starting Module 3: Commercial Management ---'

-- Tabelas
\echo '--- Including Module 3 Tables...'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Module3_Commercial_Management.sql -- Este ficheiro deve conter as tabelas do Módulo 3

-- Funções (dependem das tabelas)
\echo '--- Including Module 3 Functions...'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Module3_Functions.sql

-- Triggers (dependem das funções)
\echo '--- Including Module 3 Triggers...'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Module3_Trigger.sql

-- Procedures (dependem das funções)
\echo '--- Including Module 3 Procedures...'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Procedures.sql


-- =========================================================
-- MODULE 4: APPOINTMENT MANAGEMENT
-- =========================================================

-- Tabelas
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/00_Table_Mod4.sql

-- Funções
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/01_Functions_Mod4.sql

-- Triggers (dependem das funções)
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/02_Trigger_Mod4.sql

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/03_Jobs_Mod4.sql


-- =========================================================
-- FINAL
-- =========================================================
<<<<<<< HEAD
\echo '--- Database initialization complete. ---'
SELECT 'Database initialized successfully' AS status;
=======

-- Apply all Foreign Keys
\i /docker-entrypoint-initdb.d/99_Final/01_ForeignKeys.sql


-- sanity check (opcional)
-- SELECT 'Database initialized successfully' AS status;
>>>>>>> 667ea31 (ultimo push antes da alteração das FK)
