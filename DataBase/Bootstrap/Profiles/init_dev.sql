-- =========================================================
-- BOOTSTRAP PROFILE — DEVELOPMENT (core + master + dev + sanity)
-- =========================================================

\echo '>>> profile: init_dev'

\i /docker-entrypoint-initdb.d/Profiles/init_core.sql
\i /docker-entrypoint-initdb.d/Loaders/11_MasterData.sql
\i /docker-entrypoint-initdb.d/Loaders/09_DevelopmentData.sql
\i /docker-entrypoint-initdb.d/Loaders/07_Sanity_Check.sql
