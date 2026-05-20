-- =========================================================
-- MIACAOMIGO — DATABASE INITIALIZATION (Bootstrap/init.sql)
-- =========================================================
--
-- DESCRIPTION
-- Docker/CI entry point. Orchestration lives under Bootstrap/;
-- structural DDL lives under Schema/; data tiers under DataSeed/.
--
-- DEFAULT PROFILE
--   Profiles/init_demo.sql — core + MasterData + DemoData + sanity
--
-- OTHER PROFILES (manual, from container or psql)
--   Profiles/init_minimal.sql
--   Profiles/init_master.sql
--   Profiles/init_dev.sql
--   Profiles/init_test.sql
--   Profiles/init_full_qa.sql
--
-- MOUNTS (docker-compose.yml)
--   DataBase/Bootstrap  → /docker-entrypoint-initdb.d
--   DataBase/Schema     → /docker-entrypoint-initdb.d/Schema
--   DataBase/Comments   → /docker-entrypoint-initdb.d/Comments
--   DataBase/Services   → /docker-entrypoint-initdb.d/Services
--   DataBase/DataSeed   → /docker-entrypoint-initdb.d/DataSeed
-- =========================================================

\echo '========================================'
\echo 'MIACAOMIGO DATABASE INITIALIZATION'
\echo '========================================'

\set QUIET 1
set client_min_messages to warning;

\echo '>>> setting timezone to Europe/Lisbon'
SET timezone TO 'Europe/Lisbon';

\i /docker-entrypoint-initdb.d/Profiles/init_demo.sql

\set QUIET 0

\echo '========================================'
\echo 'INITIALIZATION COMPLETE'
\echo '========================================'

