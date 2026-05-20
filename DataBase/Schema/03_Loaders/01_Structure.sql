-- =========================================================
-- STRUCTURE LAYER (03_Loaders/01_Structure.sql)
-- =========================================================
--
-- DESCRIPTION
-- Loads module table scripts (00_Tables_Mod*.sql), then
-- index scripts bundled per module (04_Indexes_Mod*.sql) as
-- defined in this file. Foreign keys are applied separately
-- via 02_ForeignKeys.sql.
--
-- PREREQUISITE
-- 00_Core/01_Types.sql must run first (see init.sql) so ENUM
-- columns resolve.
--
-- METADATA
-- Table/column COMMENT ON lives in 02_Comments (05_Comments.sql).
-- =========================================================

\echo '========================================'
\echo 'STRUCTURE LAYER'
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


-- =========================================================
-- foreign keys
-- =========================================================
-- applies relational dependencies between
-- entities after all tables exist.
-- =========================================================

\echo '=== Foreign Keys ==='


-- global foreign keys
\echo '--- global foreign keys'

-- \i /docker-entrypoint-initdb.d/01_Modules/00_Core/99_ForeignKeys.sql
