-- =========================================================
-- DATASEED LOADER — TEST DATA (fixtures / stress datasets)
-- =========================================================
--
-- RESPONSIBILITY
--   Load QA fixture chain for manual and automated test runs.
--   Contains DATA ONLY — no assertions or PASS/FAIL logic.
--
-- PREREQUISITE
--   Full Schema + Services pipeline (init.sql) already applied.
--
-- NOT FOR
--   Production bootstrap, Docker init.sql, DevelopmentData, or DemoData.
--
-- DEFAULT CHAIN
--   CreationStress → Module2 fixtures → Module4 fixtures
--
-- RUN (from 01_DB/DataSeed):
--   psql -U postgres -d miacaomigo -v ON_ERROR_STOP=1 -f 04_Loaders/03_TestData.sql
--
-- THEN (from 01_DB/Tests):
--   See Tests/runners/run_full_qa.ps1
-- =========================================================

\echo '========================================'
\echo 'DATASEED — TEST DATA (fixtures)'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> module 1 — creation stress (stable IDs)'
\i 01_TestData/01_Module1/02_CreationStress.sql

\echo '>>> module 2 — integration fixtures'
\i 01_TestData/02_Module2/01_Module2_Fixtures.sql

\echo '>>> module 4 — appointment fixtures'
\i 01_TestData/04_Module4/01_Module4_Fixtures.sql

\set QUIET 0

\echo '========================================'
\echo 'TEST DATA LOAD COMPLETE'
\echo '========================================'
\echo 'Optional: 01_TestData/03_Module3/01_Module3_VolumeStress.sql (isolated)'
\echo 'Optional: 01_TestData/01_Module1/01_AuthenticationStress.sql (replaces Mod1 chain)'
\echo 'Next: 01_DB/Tests/runners/run_integrity_all.ps1'
