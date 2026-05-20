-- =========================================================
-- MIACAOMIGO — DATABASE INITIALIZATION (init.sql)
-- =========================================================
--
-- DESCRIPTION
-- Orchestrates full schema creation for Docker/CI init. Loads
-- extensions, centralized ENUM types, table DDL, foreign keys,
-- integrity objects, optional migration hooks, catalog comments,
-- and sanity checks.
--
-- LOAD ORDER (pipeline)
--   00_Extensions.sql     — pg_cron, btree_gist, …
--   00_Core/01_Types.sql  — absence_status, purchase_status,
--                           appointment_status, invoice_status
--   01_Structure.sql      — 00_Tables_Mod*.sql + per-module indexes
--   02_ForeignKeys.sql    — 01_ForeignKeys_Mod*.sql
--   03_Integrity.sql      — functions, triggers, indexes, views,
--                           procedures, jobs
--   04_Data_Migration.sql — reserved (ETL / reference imports; optional seed docs)
--   05_Comments.sql       — COMMENT ON (mirrors 01_Modules order)
--   06_Services.sql       — application PL/pgSQL (01_DB/Services)
--   08_Service_Comments.sql — COMMENT ON service functions
--   10_Official_Bootstrap.sql — MasterData + DemoData (official seed tiers)
--   07_Sanity_Check.sql   — extensions, ENUMs, catalog smoke checks
--   09_DevelopmentData.sql — optional manual only (NOT in init; MIACAOMIGO_SEED_DEV=1)
--
-- Comments run after behavioral DDL so COMMENT ON resolves.
-- =========================================================


\echo '========================================'
\echo 'MIACAOMIGO DATABASE INITIALIZATION'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;

--=========================================================
-- SESSION CONFIGURATION
--=========================================================

\echo '>>> setting timezone to Europe/Lisbon'

SET timezone TO 'Europe/Lisbon';

-- =========================================================
-- extensions layer
-- =========================================================

\echo '>>> loading extensions layer'

\i /docker-entrypoint-initdb.d/03_Loaders/00_Extensions.sql



-- =========================================================
-- custom types layer
-- =========================================================

\echo '>>> loading custom types layer'

\i /docker-entrypoint-initdb.d/00_Core/01_Types.sql



-- =========================================================
-- structure layer (tables only)
-- =========================================================

\echo '>>> loading structure layer (tables)'

\i /docker-entrypoint-initdb.d/03_Loaders/01_Structure.sql



-- =========================================================
-- foreign keys layer
-- =========================================================
-- all 01_ForeignKeys_ModX.sql files (after tables exist)
-- =========================================================

\echo '>>> loading foreign keys layer'

\i /docker-entrypoint-initdb.d/03_Loaders/02_ForeignKeys.sql



-- =========================================================
-- integrity layer
-- =========================================================
-- functions, triggers, indexes, views, procedures, jobs
-- =========================================================

\echo '>>> loading integrity layer'

\i /docker-entrypoint-initdb.d/03_Loaders/03_Integrity.sql



-- =========================================================
-- data migration layer
-- =========================================================

\echo '>>> loading data migration layer'

\i /docker-entrypoint-initdb.d/03_Loaders/04_Data_Migration.sql



-- =========================================================
-- comments layer
-- =========================================================
-- 02_Comments/<module>/NN_*_Comments.sql follows the same
-- ordering as 01_Modules/<module>/NN_*.sql (tables → fks → …).
-- =========================================================

\echo '>>> loading comments layer'

\i /docker-entrypoint-initdb.d/03_Loaders/05_Comments.sql



-- =========================================================
-- services layer
-- =========================================================

\echo '>>> loading services layer'

\i /docker-entrypoint-initdb.d/03_Loaders/06_Services.sql



-- =========================================================
-- service function comments
-- =========================================================

\echo '>>> loading service function comments'

\i /docker-entrypoint-initdb.d/03_Loaders/08_Service_Comments.sql



-- =========================================================
-- official data bootstrap (master + demo)
-- =========================================================
-- TestData and DevelopmentData are never loaded here.
-- =========================================================

\echo '>>> official data bootstrap (master + demo)'

\i /docker-entrypoint-initdb.d/03_Loaders/10_Official_Bootstrap.sql



-- =========================================================
-- sanity check layer
-- =========================================================

\echo '>>> loading sanity check layer'

\i /docker-entrypoint-initdb.d/03_Loaders/07_Sanity_Check.sql



-- =========================================================
-- initialization completed
-- =========================================================

\set QUIET 0