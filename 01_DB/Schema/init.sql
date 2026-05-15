-- =========================================================
-- init: database setup (miacaomigo)
-- =========================================================
-- central orchestration script responsible for loading the
-- complete database architecture inside the docker init hook.
--
-- pipeline overview:
--   00_Extensions   → enable pg_cron, btree_gist, etc.
--   01_Structure    → 00_Tables_Mod*.sql (tables only)
--   02_ForeignKeys  → 01_ForeignKeys_Mod*.sql (cross-module safe phase)
--   03_Integrity    → functions, triggers, indexes, procedures, jobs
--   08_Services     → 05_Services/** API / business-logic functions
--   04_Data_Migration → reserved for seed / etl scripts
--   05_Comments     → 02_Comments/** mirrors 01_Modules/** layout
--   06_Queries      → 04_Queries/** reporting views (post-comments)
--   07_Sanity_Check → lightweight catalog validation
--
-- the comments layer intentionally runs after behavioral objects
-- so COMMENT ON targets always resolve.
-- =========================================================


\echo '========================================'
\echo 'MIACAOMIGO DATABASE INITIALIZATION'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;

-- =========================================================
-- extensions layer
-- =========================================================

\echo '>>> loading extensions layer'

\i /docker-entrypoint-initdb.d/03_Loaders/00_Extensions.sql



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
-- functions, triggers, indexes, procedures, jobs
-- =========================================================

\echo '>>> loading integrity layer'

\i /docker-entrypoint-initdb.d/03_Loaders/03_Integrity.sql



-- =========================================================
-- services layer
-- =========================================================
-- PL/pgSQL used by the Node API (login_user, new_client, …).
-- =========================================================

\echo '>>> loading services layer'

\i /docker-entrypoint-initdb.d/03_Loaders/08_Services.sql



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
-- queries layer
-- =========================================================

\echo '>>> loading queries layer'

-- \i /docker-entrypoint-initdb.d/03_Loaders/06_Queries.sql
-- (06_Queries.sql still points at a missing file; enable after fixing the loader)



-- =========================================================
-- sanity check layer
-- =========================================================

\echo '>>> loading sanity check layer'

\i /docker-entrypoint-initdb.d/03_Loaders/07_Sanity_Check.sql



-- =========================================================
-- initialization completed
-- =========================================================

\set QUIET 0