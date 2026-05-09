-- =========================================================
-- structure loader
-- =========================================================
-- loads all structural database components.
--
-- includes:
-- - core structures
-- - tables
-- - indexes
--
-- this phase creates the physical relational
-- structure of the database.
-- =========================================================

\echo '========================================'
\echo 'STRUCTURE LAYER'
\echo '========================================'



-- =========================================================
-- core structures
-- =========================================================

\echo '=== Core Structures ==='


-- core types
\echo '--- core | types'

-- \i /docker-entrypoint-initdb.d/00_Core/00_Types.sql


-- core enums
\echo '--- core | enums'

-- \i /docker-entrypoint-initdb.d/00_Core/01_Enums.sql


-- core base functions
\echo '--- core | base functions'

-- \i /docker-entrypoint-initdb.d/00_Core/02_Functions_Base.sql



-- =========================================================
-- tables
-- =========================================================
-- creates all entities before integrity rules
-- are applied.
-- =========================================================

\echo '=== Tables ==='


-- module 1 | user management
\echo '--- module 1 | tables'

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/00_Tables_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | tables'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/00_Tables_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | tables'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/00_Tables_Mod3.sql


-- module 4 | appointment management
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

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/03_Indexes_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/03_Indexes_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Indexes_Mod3.sql


-- module 4 | appointment management
\echo '--- module 4 | indexes'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/03_Indexes_Mod4.sql

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