-- =========================================================
-- OFFICIAL DATA BOOTSTRAP (Schema delegate)
-- =========================================================
--
-- DESCRIPTION
-- Orchestrates the official seed tiers after Schema + Services:
--   1. MasterData — TRUNCATE + system invariants
--   2. DemoData    — append operational demo narrative
--
-- NOT LOADED HERE (manual / optional only)
--   TestData        — 04_Loaders/03_TestData.sql
--   DevelopmentData — 04_Loaders/02_DevelopmentData.sql (or 09_DevelopmentData.sql)
--
-- REQUIRES MOUNT
--   ./01_DB/DataSeed → /docker-entrypoint-initdb.d/DataSeed
--
-- INVOKED BY
--   Schema/init.sql (after 08_Service_Comments, before 07_Sanity_Check)
-- =========================================================

\echo '========================================'
\echo 'OFFICIAL DATA BOOTSTRAP'
\echo '========================================'

\cd /docker-entrypoint-initdb.d/DataSeed

\echo '>>> tier 1: master data (truncate + invariants)'
\i 04_Loaders/00_MasterData.sql

\echo '>>> tier 2: demo data (append on master)'
\i 04_Loaders/01_DemoData.sql

\echo '========================================'
\echo 'OFFICIAL DATA BOOTSTRAP COMPLETE'
\echo '========================================'
