-- =========================================================
-- DATA TIER LOADER — MASTER DATA
-- =========================================================
-- Orchestration only: Core data reset + MasterData inserts (00_MasterData/*).
-- PREREQUISITE: Loaders 00–08 (schema + services).
-- INVOKED BY: init_demo, init_master.
-- =========================================================

\echo '========================================'
\echo 'MASTER DATA'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> step 1: logical data reset (Core)'
\i /docker-entrypoint-initdb.d/Schema/00_Core/00_Data_Cleanup.sql

\echo '>>> step 2: module 1 master data'
\i /docker-entrypoint-initdb.d/DataSeed/00_MasterData/01_Module1_MasterData.sql

\echo '>>> step 3: module 2 master data'
\i /docker-entrypoint-initdb.d/DataSeed/00_MasterData/02_Module2_MasterData.sql

\echo '>>> step 4: module 3 master data'
\i /docker-entrypoint-initdb.d/DataSeed/00_MasterData/03_Module3_MasterData.sql

\echo '>>> step 5: module 4 master data'
\i /docker-entrypoint-initdb.d/DataSeed/00_MasterData/04_Module4_MasterData.sql

\set QUIET 0

\echo '========================================'
\echo 'MASTER DATA COMPLETE'
\echo '========================================'
