-- =========================================================
-- BOOTSTRAP PROFILE — TEST (alias of init_demo)
-- =========================================================
-- PURPOSE: Same SQL init as init_demo (Master + Demo).
-- QA data: Tests/fixtures/ via Tests/runners/ — not a separate DataSeed tier.
-- =========================================================

\echo '>>> profile: init_test (= init_demo; QA via Tests/runners)'

\i /docker-entrypoint-initdb.d/Profiles/init_demo.sql
