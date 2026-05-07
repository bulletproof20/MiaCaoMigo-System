-- =========================================================
-- INIT: Database Setup (MiaCaoMigo)
-- orchestrates the complete database creation
-- =========================================================


-- =========================================================
-- 1. EXTENSIONS
-- =========================================================

\echo '--- Starting Extensions Setup...'

-- ---------------------------------------------------------
-- pg_cron
-- ---------------------------------------------------------
-- Extensão que permite executar jobs agendados
-- diretamente dentro do PostgreSQL.
--
-- O cascade remove dependências associadas caso
-- a extensão já exista.

\echo '--- creating pg_cron extension...'
drop extension if exists pg_cron cascade;

\echo '--- enabling pg_cron extension...'
create extension if not exists pg_cron;


-- ---------------------------------------------------------
-- btree_gist
-- ---------------------------------------------------------
-- Extensão que adiciona suporte a operadores
-- B-Tree (=, <, >, etc.) dentro de índices GiST.

\echo '--- enabling btree_gist extension...'
create extension if not exists btree_gist;


-- =========================================================
-- 2. CORE
-- =========================================================

\echo '--- Starting Core Setup...'

-- Tipos personalizados globais
\echo '--- Including Core Types...'
-- \i /docker-entrypoint-initdb.d/00_Core/00_Types.sql

-- Enums globais
\echo '--- Including Core Enums...'
-- \i /docker-entrypoint-initdb.d/00_Core/01_Enums.sql

-- Funções base reutilizáveis
\echo '--- Including Core Base Functions...'
-- \i /docker-entrypoint-initdb.d/00_Core/02_Functions_Base.sql


-- =========================================================
-- 3. TABLE CREATION PHASE
-- =========================================================
-- in this phase all tables are created first.
--
-- this guarantees:
-- - all entities exist beforehand
-- - no dependency issues
-- - easier modularization
-- - cleaner foreign key management
-- =========================================================



-- =========================================================
-- module 1: user management
-- =========================================================

\echo '--- Creating Module 1 Tables...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/00_Tables_Mod1.sql


-- =========================================================
-- module 2: animal management
-- =========================================================

\echo '--- Creating Module 2 Tables...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/00_Tables_Mod2.sql


-- =========================================================
-- module 3: commercial management
-- =========================================================

\echo '--- Creating Module 3 Tables...'
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/00_Tables_Mod3.sql


-- =========================================================
-- module 4: appointment management
-- =========================================================

\echo '--- Creating Module 4 Tables...'
-- \i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/00_Tables_Mod4.sql



-- =========================================================
-- 4. FOREIGN KEYS PHASE
-- =========================================================
-- foreign keys are applied only after all
-- tables are created.
--
-- this avoids:
-- - circular dependencies
-- - missing table references
-- - module loading order problems
-- =========================================================

\echo '--- Applying Global Foreign Keys...'
-- \i /docker-entrypoint-initdb.d/01_Modules/00_Core/99_ForeignKeys.sql



-- =========================================================
-- 5. FUNCTIONS PHASE
-- =========================================================
-- functions are loaded after tables and
-- foreign keys because they may depend on:
-- - constraints
-- - relations
-- - existing entities
-- =========================================================


-- =========================================================
-- module 1: user management
-- =========================================================

\echo '--- Including Module 1 Functions...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_Functions_Mod1.sql


-- =========================================================
-- module 2: animal management
-- =========================================================

\echo '--- Including Module 2 Functions...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/01_Functions_Mod2.sql


-- =========================================================
-- module 3: commercial management
-- =========================================================

\echo '--- Including Module 3 Functions...'
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/01_Functions_Mod3.sql


-- =========================================================
-- module 4: appointment management
-- =========================================================

\echo '--- Including Module 4 Functions...'
-- \i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/01_Functions_Mod4.sql



-- =========================================================
-- 6. TRIGGERS PHASE
-- =========================================================
-- triggers are loaded after functions because
-- triggers depend directly on trigger functions.
-- =========================================================


-- =========================================================
-- module 1: user management
-- =========================================================

\echo '--- Including Module 1 Triggers...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/02_Triggers_Mod1.sql


-- =========================================================
-- module 2: animal management
-- =========================================================

\echo '--- Including Module 2 Triggers...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/02_Triggers_Mod2.sql


-- =========================================================
-- module 3: commercial management
-- =========================================================

\echo '--- Including Module 3 Triggers...'
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/02_Triggers_Mod3.sql


-- =========================================================
-- module 4: appointment management
-- =========================================================

\echo '--- Including Module 4 Triggers...'
-- \i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/02_Triggers_Mod4.sql



-- =========================================================
-- 7. INDEXES PHASE
-- =========================================================
-- indexes are created after tables and
-- constraints for optimization purposes.
-- =========================================================


-- =========================================================
-- module 1: user management
-- =========================================================

\echo '--- Including Module 1 Indexes...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/03_Indexes_Mod1.sql


-- =========================================================
-- module 2: animal management
-- =========================================================

\echo '--- Including Module 2 Indexes...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/03_Indexes_Mod2.sql


-- =========================================================
-- module 3: commercial management
-- =========================================================

\echo '--- Including Module 3 Indexes...'
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Indexes_Mod3.sql


-- =========================================================
-- module 4: appointment management
-- =========================================================

\echo '--- Including Module 4 Indexes...'
-- \i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/03_Indexes_Mod4.sql



-- =========================================================
-- 8. PROCEDURES PHASE
-- =========================================================

\echo '--- Including Module 1 Procedures...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/04_Procedures_Mod1.sql

\echo '--- Including Module 2 Procedures...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/04_Procedures_Mod2.sql

\echo '--- Including Module 3 Procedures...'
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/04_Procedures_Mod3.sql

\echo '--- Including Module 4 Procedures...'
-- \i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/04_Procedures_Mod4.sql



-- =========================================================
-- 9. JOBS PHASE
-- =========================================================
-- scheduled jobs are loaded at the end
-- because they may depend on:
-- - procedures
-- - functions
-- - triggers
-- - existing data structures
-- =========================================================

\echo '--- Including Module 1 Jobs...'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/05_Jobs_Mod1.sql

\echo '--- Including Module 2 Jobs...'
-- \i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/05_Jobs_Mod2.sql

\echo '--- Including Module 3 Jobs...'
-- \i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/05_Jobs_Mod3.sql

\echo '--- Including Module 4 Jobs...'
-- \i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/05_Jobs_Mod4.sql



-- =========================================================
-- 10. SANITY CHECK
-- =========================================================

\echo '--- Starting Sanity Check...'

-- final validation query confirming that
-- the initialization process finished
-- successfully without fatal errors.

select 'database initialized successfully' as status;