-- =========================================================
-- queries loader
-- =========================================================
-- reporting views and read models that depend on finalized
-- schema objects and COMMENT ON metadata (runs after 05_Comments).
-- =========================================================

\echo '========================================'
\echo 'QUERIES / REPORTING LAYER'
\echo '========================================'


\echo '--- appointment reporting views'

\i /docker-entrypoint-initdb.d/04_Queries/01_Appointment_Reporting.sql


\echo '========================================'
\echo 'QUERIES LAYER COMPLETE'
\echo '========================================'
