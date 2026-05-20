-- =========================================================
-- DATASEED LOADER — DEMO DATA (official bootstrap tier)
-- =========================================================
--
-- RESPONSIBILITY
--   Append realistic clinic demo narrative on top of MasterData.
--
-- PREREQUISITE
--   04_Loaders/00_MasterData.sql (same init run)
--
-- OFFICIAL BOOTSTRAP
--   Schema/init.sql → 10_Official_Bootstrap.sql (step 2 of 2)
--
-- NOT FOR
--   TestData (03_TestData.sql) or DevelopmentData (02_DevelopmentData.sql)
--
-- MANUAL (from 01_DB/DataSeed):
--   psql -v ON_ERROR_STOP=1 -f 04_Loaders/01_DemoData.sql
-- =========================================================

\echo '========================================'
\echo 'DATASEED — DEMO DATA'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> module 1 demo data'
\i 03_DemoData/01_Module1_DemoData.sql

\echo '>>> module 2 demo data'
\i 03_DemoData/02_Module2_DemoData.sql

\echo '>>> module 3 demo data'
\i 03_DemoData/03_Module3_DemoData.sql

\echo '>>> module 4 demo data'
\i 03_DemoData/04_Module4_DemoData.sql

\set QUIET 0

\echo '========================================'
\echo 'DEMO DATA LOAD COMPLETE'
\echo '========================================'
