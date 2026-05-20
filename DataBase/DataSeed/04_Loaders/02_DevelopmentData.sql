-- =========================================================
-- DATASEED LOADER — DEVELOPMENT DATA (optional tier)
-- =========================================================
--
-- PURPOSE
-- Comfortable working dataset for local development and debugging.
-- Appends rows on top of MasterData; does NOT truncate.
--
-- PREREQUISITE
--   04_Loaders/00_MasterData.sql must have been applied first.
--
-- WHEN TO USE
--   Local developer machines and dev/staging profiles only.
--   Never use in production or as official bootstrap replacement.
--
-- NOT A SUBSTITUTE FOR
--   DemoData (03_DemoData) — presentation / staging narratives
--   TestData (01_TestData) — stress, edge cases, integrity probes
--
-- RUN (from 01_DB/DataSeed):
--   psql -U postgres -d miacaomigo -v ON_ERROR_STOP=1 \
--     -f 04_Loaders/02_DevelopmentData.sql
--
-- Docker dev profile: see Schema/dev-init/zzz_dev_bootstrap.sql
-- =========================================================

\echo '========================================'
\echo 'DATASEED — DEVELOPMENT DATA'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;
set timezone to 'Europe/Lisbon';

\echo '>>> module 1 development data'
\i 02_DevelopmentData/01_Module1/01_CoreDevelopment.sql

\echo '>>> module 2 development data'
\i 02_DevelopmentData/02_Module2/01_AnimalsDevelopment.sql

\echo '>>> module 3 development data'
\i 02_DevelopmentData/03_Module3/01_InventoryDevelopment.sql

\echo '>>> module 4 development data'
\i 02_DevelopmentData/04_Module4/01_AppointmentsDevelopment.sql

\set QUIET 0

\echo '========================================'
\echo 'DEVELOPMENT DATA LOAD COMPLETE'
\echo '========================================'
