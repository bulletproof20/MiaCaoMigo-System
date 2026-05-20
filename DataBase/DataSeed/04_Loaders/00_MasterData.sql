-- =========================================================
-- DATASEED LOADER — MASTER DATA (official bootstrap)
-- =========================================================
--
-- RESPONSIBILITY
--   1. TRUNCATE all module data (00_DataCleaner.sql)
--   2. Load system invariants only (00_MasterData/*)
--
-- NOT FOR
--   TestData or DevelopmentData (separate manual loaders)
--
-- OFFICIAL BOOTSTRAP
--   Schema/init.sql → 10_Official_Bootstrap.sql (step 1 of 2)
--
-- MANUAL (from 01_DB/DataSeed):
--   psql -v ON_ERROR_STOP=1 -f 04_Loaders/00_MasterData.sql
-- =========================================================

\echo '========================================'
\echo 'DATASEED — MASTER DATA'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> step 1: data cleaner'
\i 00_MasterData/00_DataCleaner.sql

\echo '>>> step 2: module 1 master data'
\i 00_MasterData/01_Module1_MasterData.sql

\echo '>>> step 3: module 2 master data'
\i 00_MasterData/02_Module2_MasterData.sql

\echo '>>> step 4: module 3 master data'
\i 00_MasterData/03_Module3_MasterData.sql

\echo '>>> step 5: module 4 master data'
\i 00_MasterData/04_Module4_MasterData.sql

\set QUIET 0

\echo '========================================'
\echo 'MASTER DATA LOAD COMPLETE'
\echo '========================================'
