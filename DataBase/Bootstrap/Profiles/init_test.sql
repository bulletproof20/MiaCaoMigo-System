-- =========================================================
-- BOOTSTRAP PROFILE — TEST (same data tier as demo)
-- =========================================================
-- QA entities live in Tests/fixtures/ (run_fixtures.ps1), not DataSeed.
-- =========================================================

\echo '>>> profile: init_test (Master + Demo; QA via Tests/runners)'

\i /docker-entrypoint-initdb.d/Profiles/init_demo.sql
