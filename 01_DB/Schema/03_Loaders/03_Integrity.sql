-- =========================================================
-- INTEGRITY LAYER (03_Loaders/03_Integrity.sql)
-- =========================================================
--
-- DESCRIPTION
-- Loads behavioral DDL in module order: functions, triggers,
-- indexes (second pass where applicable), procedures, jobs.
--
-- PREREQUISITE
-- 02_ForeignKeys.sql must have run so relationship targets exist.
--
-- Metadata: 02_Comments parallels 01_Modules (02–06_*_Comments.sql).
-- =========================================================

\echo '========================================'
\echo 'INTEGRITY LAYER'
\echo '========================================'


-- =========================================================
-- integrity functions
-- =========================================================

\echo '=== Integrity Functions ==='


\echo '--- module 1 | integrity functions'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/02_Functions_Mod1.sql


\echo '--- module 2 | integrity functions'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/02_Functions_Mod2.sql


\echo '--- module 3 | integrity functions'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/02_Functions_Mod3.sql


\echo '--- module 4 | integrity functions'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/02_Functions_Mod4.sql



-- =========================================================
-- triggers
-- =========================================================

\echo '=== Triggers ==='


\echo '--- module 1 | triggers'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/03_Triggers_Mod1.sql


\echo '--- module 2 | triggers'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/03_Triggers_Mod2.sql


\echo '--- module 3 | triggers'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/03_Triggers_Mod3.sql


\echo '--- module 4 | triggers'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/03_Triggers_Mod4.sql



-- =========================================================
-- indexes (including exclusion constraints on tables)
-- =========================================================

\echo '=== Indexes ==='


\echo '--- module 1 | indexes'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/04_Indexes_Mod1.sql


\echo '--- module 2 | indexes'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/04_Indexes_Mod2.sql


\echo '--- module 3 | indexes'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/04_Indexes_Mod3.sql


\echo '--- module 4 | indexes'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/04_Indexes_Mod4.sql



-- =========================================================
-- integrity procedures
-- =========================================================

\echo '=== Integrity Procedures ==='


\echo '--- module 1 | integrity procedures'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/05_Procedures_Mod1.sql


\echo '--- module 2 | integrity procedures'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/05_Procedures_Mod2.sql


\echo '--- module 3 | integrity procedures'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/05_Procedures_Mod3.sql


\echo '--- module 4 | integrity procedures'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/05_Procedures_Mod4.sql



-- =========================================================
-- jobs
-- =========================================================

\echo '=== Jobs ==='


\echo '--- module 1 | jobs'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/06_Jobs_Mod1.sql


\echo '--- module 2 | jobs'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/06_Jobs_Mod2.sql


\echo '--- module 3 | jobs'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/06_Jobs_Mod3.sql


\echo '--- module 4 | jobs'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/06_Jobs_Mod4.sql
