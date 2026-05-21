-- =========================================================
-- DATA TIER LOADER — DEVELOPMENT DATA
-- =========================================================
-- Orchestration only: comfortable local dev rows (02_DevelopmentData/*).
-- Appends on MasterData; does not truncate. Not for production.
-- PREREQUISITE: 11_MasterData.sql in the same profile run.
-- INVOKED BY: init_dev.sql (not part of default init_demo).
-- =========================================================

\echo '========================================'
\echo 'DEVELOPMENT DATA'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> module 1 development data'
\i /docker-entrypoint-initdb.d/DataSeed/02_DevelopmentData/01_Module1/01_CoreDevelopment.sql

\echo '>>> module 2 development data'
\i /docker-entrypoint-initdb.d/DataSeed/02_DevelopmentData/02_Module2/01_AnimalsDevelopment.sql

\echo '>>> module 3 development data'
\i /docker-entrypoint-initdb.d/DataSeed/02_DevelopmentData/03_Module3/01_InventoryDevelopment.sql

\echo '>>> module 4 development data'
\i /docker-entrypoint-initdb.d/DataSeed/02_DevelopmentData/04_Module4/01_AppointmentsDevelopment.sql

\set QUIET 0

\echo '========================================'
\echo 'DEVELOPMENT DATA COMPLETE'
\echo '========================================'
