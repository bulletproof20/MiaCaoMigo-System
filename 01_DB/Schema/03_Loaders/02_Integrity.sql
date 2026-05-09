-- =========================================================
-- integrity loader
-- =========================================================
-- loads all integrity and behavioral database
-- components responsible for:
--
-- - relational integrity
-- - validation
-- - automation
-- - business enforcement
-- - operational execution
-- =========================================================

\echo '========================================'
\echo 'INTEGRITY LAYER'
\echo '========================================'



-- =========================================================
-- foreign keys
-- =========================================================
-- applies relational dependencies after all
-- tables exist.
-- =========================================================

\echo '=== Foreign Keys ==='


-- global foreign keys
\echo '--- global foreign keys'

-- \i /docker-entrypoint-initdb.d/01_Modules/00_Core/99_ForeignKeys.sql



-- =========================================================
-- integrity functions
-- =========================================================
-- loads validation and trigger support logic.
-- =========================================================

\echo '=== Integrity Functions ==='


-- module 1 | user management
\echo '--- module 1 | integrity functions'

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_Functions_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | integrity functions'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/01_Functions_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | integrity functions'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/01_Functions_Mod3.sql


-- module 4 | appointment management
\echo '--- module 4 | integrity functions'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/01_Functions_Mod4.sql



-- =========================================================
-- triggers
-- =========================================================
-- loads automatic event-driven logic executed
-- during insert, update and delete operations.
-- =========================================================

\echo '=== Triggers ==='


-- module 1 | user management
\echo '--- module 1 | triggers'

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/02_Triggers_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | triggers'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/02_Triggers_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | triggers'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/02_Triggers_Mod3.sql


-- module 4 | appointment management
\echo '--- module 4 | triggers'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/02_Triggers_Mod4.sql



-- =========================================================
-- integrity procedures
-- =========================================================
-- loads executable operational and enforcement
-- routines used internally by the system.
-- =========================================================

\echo '=== Integrity Procedures ==='


-- module 1 | user management
\echo '--- module 1 | integrity procedures'

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/04_Procedures_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | integrity procedures'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/04_Procedures_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | integrity procedures'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/04_Procedures_Mod3.sql


-- module 4 | appointment management
\echo '--- module 4 | integrity procedures'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/04_Procedures_Mod4.sql



-- =========================================================
-- jobs
-- =========================================================
-- loads scheduled automated tasks executed
-- internally through pg_cron.
-- =========================================================

\echo '=== Jobs ==='


-- module 1 | user management
\echo '--- module 1 | jobs'

\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/05_Jobs_Mod1.sql


-- module 2 | animal management
\echo '--- module 2 | jobs'

\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/05_Jobs_Mod2.sql


-- module 3 | commercial management
\echo '--- module 3 | jobs'

\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/05_Jobs_Mod3.sql


-- module 4 | appointment management
\echo '--- module 4 | jobs'

\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/05_Jobs_Mod4.sql