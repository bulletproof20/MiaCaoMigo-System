-- =========================================================
-- DATA TIER LOADER — DEMO DATA
-- =========================================================
-- Orchestration only: appends demo narrative (03_DemoData/*).
-- PREREQUISITE: 11_MasterData.sql in the same profile run.
-- INVOKED BY: init_demo, init_test.
-- =========================================================

\echo '========================================'
\echo 'DEMO DATA'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> module 1 demo data'
\i /docker-entrypoint-initdb.d/DataSeed/03_DemoData/01_Module1_DemoData.sql

\echo '>>> module 2 demo data'
\i /docker-entrypoint-initdb.d/DataSeed/03_DemoData/02_Module2_DemoData.sql

\echo '>>> module 3 demo data'
\i /docker-entrypoint-initdb.d/DataSeed/03_DemoData/03_Module3_DemoData.sql

\echo '>>> module 4 demo data'
\i /docker-entrypoint-initdb.d/DataSeed/03_DemoData/04_Module4_DemoData.sql

\set QUIET 0

\echo '========================================'
\echo 'DEMO DATA COMPLETE'
\echo '========================================'
