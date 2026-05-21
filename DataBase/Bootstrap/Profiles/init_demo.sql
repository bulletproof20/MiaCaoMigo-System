-- =========================================================
-- BOOTSTRAP PROFILE — DEMO (official Docker default)
-- =========================================================
--
-- Pipeline: init_core (DDL + services) → Master + Demo → sanity
-- =========================================================

\echo '>>> profile: init_demo'

\i /docker-entrypoint-initdb.d/Profiles/init_core.sql
\i /docker-entrypoint-initdb.d/Loaders/11_MasterData.sql
\i /docker-entrypoint-initdb.d/Loaders/12_DemoData.sql
\i /docker-entrypoint-initdb.d/Loaders/07_Sanity_Check.sql
