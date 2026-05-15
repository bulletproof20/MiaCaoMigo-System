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



-- =========================================================
-- indexes
-- =========================================================
-- indexes are created after tables exist.
-- =========================================================

\echo '=== Indexes ==='


-- module 1 | user management
\echo '--- module 1 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/04_Indexes_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/04_Indexes_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/04_Indexes_Mod3.sql


-- module 4 | appointment management
\echo '--- module 4 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/04_Indexes_Mod4.sql

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
