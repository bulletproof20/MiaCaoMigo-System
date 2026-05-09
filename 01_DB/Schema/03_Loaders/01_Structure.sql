-- =========================================================
-- structure loader
-- =========================================================
-- Creates physical tables only (00_Tables_ModX.sql).
--
-- Foreign keys are NOT declared here; they load in
-- 02_ForeignKeys.sql after every module's tables exist.
--
-- Indexes / exclusion constraints load later in the
-- integrity layer (04_Indexes_ModX.sql) so GiST/btree
-- objects attach to stable tables and FK-backed columns.
--
-- descriptive metadata for these tables is applied later via
-- 02_Comments/<module>/00_Tables_ModX_Comments.sql (see 05_Comments.sql).
-- =========================================================

\echo '========================================'
\echo 'STRUCTURE LAYER (TABLES ONLY)'
\echo '========================================'


-- =========================================================
-- tables
-- =========================================================

\echo '=== Tables ==='


\echo '--- module 1 | tables'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/00_Tables_Mod1.sql


\echo '--- module 2 | tables'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/00_Tables_Mod2.sql


\echo '--- module 3 | tables'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/00_Tables_Mod3.sql


\echo '--- module 4 | tables'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/00_Tables_Mod4.sql
