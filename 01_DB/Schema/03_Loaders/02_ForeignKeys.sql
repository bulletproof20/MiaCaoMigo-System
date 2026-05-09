-- =========================================================
-- foreign keys loader
-- =========================================================
-- Runs after all module table scripts (00_Tables_ModX.sql).
--
-- Rationale:
--   * every module keeps FK definitions in 01_ForeignKeys_ModX.sql;
--   * init order stays predictable (tables → FKs → behavior);
--   * avoids circular CREATE TABLE dependency issues;
--   * matches the uniform per-module file numbering.
--
-- comment metadata: 02_Comments/<module>/01_ForeignKeys_ModX_Comments.sql
-- (loaded in 05_Comments.sql after integrity objects exist).
-- =========================================================

\echo '========================================'
\echo 'FOREIGN KEYS LAYER'
\echo '========================================'


\echo '--- module 1 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_ForeignKeys_Mod1.sql

\echo '--- module 2 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/01_ForeignKeys_Mod2.sql

\echo '--- module 3 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/01_ForeignKeys_Mod3.sql

\echo '--- module 4 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/01_ForeignKeys_Mod4.sql
