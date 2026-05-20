-- =========================================================
-- STRUCTURE LAYER (Bootstrap/Loaders/01_Structure.sql)
-- =========================================================
--
-- DESCRIPTION
-- Loads module table scripts (00_Tables_Mod*.sql) only.
-- Foreign keys: 02_ForeignKeys.sql
-- Indexes, triggers, procedures: 03_Integrity.sql
--
-- PREREQUISITE
-- Schema/00_Core/01_Types.sql (via init_core) so ENUM columns resolve.
--
-- METADATA
-- Table/column COMMENT ON lives in 05_Comments.sql.
-- =========================================================

\echo '========================================'
\echo 'STRUCTURE LAYER'
\echo '========================================'

-- =========================================================
-- tables
-- =========================================================

\echo '=== Tables ==='


\echo '--- module 1 | tables'
\i /docker-entrypoint-initdb.d/Schema/01_Module1_User_Management/00_Tables_Mod1.sql


\echo '--- module 2 | tables'
\i /docker-entrypoint-initdb.d/Schema/02_Module2_Animal_Management/00_Tables_Mod2.sql


\echo '--- module 3 | tables'
\i /docker-entrypoint-initdb.d/Schema/03_Module3_Commercial_Management/00_Tables_Mod3.sql


\echo '--- module 4 | tables'

\i /docker-entrypoint-initdb.d/Schema/04_Module4_Appointment_Management/00_Tables_Mod4.sql
