-- =========================================================
-- INIT: Database Setup (MiaCaoMigo)
-- Orquestra toda a criação da base de dados
-- =========================================================

-- ---------------------------------------------------------
-- 1. EXTENSÕES
-- ---------------------------------------------------------
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

-- Tabelas
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/00_Table_Mod1.sql

-- Funções
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_Functions_Mod1.sql

-- Triggers (dependem das funções)
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/02_Trigger_Mod1.sql

-- Índices
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/03_Indexes_Mod1.sql

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
-- FINAL
-- =========================================================

-- sanity check (opcional)
-- SELECT 'Database initialized successfully' AS status;