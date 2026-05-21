-- =========================================================
-- BOOTSTRAP PROFILE — FULL QA
-- =========================================================
-- SQL init: Master + Demo only. After container is up:
--   cd DataBase/Tests/runners
--   .\run_regression.ps1
-- =========================================================

\echo '>>> profile: init_full_qa'

\i /docker-entrypoint-initdb.d/Profiles/init_demo.sql

\echo '>>> next step (host): Tests/runners/run_regression.ps1'
