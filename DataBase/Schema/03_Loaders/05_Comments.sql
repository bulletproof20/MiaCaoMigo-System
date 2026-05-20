-- =========================================================
-- COMMENTS LAYER (03_Loaders/05_Comments.sql)
-- =========================================================
--
-- DESCRIPTION
-- Applies COMMENT ON metadata after structural and behavioral
-- DDL so all targets exist.
--
-- ORDER (mirrors 01_Modules)
-- Core types → per module: tables, FKs, functions, triggers,
-- indexes, views, procedures, jobs.
--
-- PURPOSE
-- Documentation for operators, SchemaSpy, and tooling reading
-- pg_catalog descriptions.
-- =========================================================

\echo '========================================'
\echo 'COMMENTS LAYER'
\echo '========================================'



-- =========================================================
-- core comments
-- =========================================================

\echo '=== Core Comments ==='


\echo '--- core | custom types'

\i /docker-entrypoint-initdb.d/02_Comments/00_Core/02_Types_Comments.sql

\echo '--- core | shared functions'

\i /docker-entrypoint-initdb.d/02_Comments/00_Core/00_Common_Functions_Comments.sql



-- =========================================================
-- module 1 comments
-- =========================================================

\echo '=== Module 1 | User Management Comments ==='


\echo '--- module 1 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/00_Tables_Mod1_Comments.sql


\echo '--- module 1 | foreign key comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/01_ForeignKeys_Mod1_Comments.sql


\echo '--- module 1 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/02_Functions_Mod1_Comments.sql


\echo '--- module 1 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/03_Triggers_Mod1_Comments.sql


\echo '--- module 1 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/04_Indexes_Mod1_Comments.sql


\echo '--- module 1 | view comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/07_Views_Mod1_Comments.sql


\echo '--- module 1 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/05_Procedures_Mod1_Comments.sql


\echo '--- module 1 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/06_Jobs_Mod1_Comments.sql



-- =========================================================
-- module 2 comments
-- =========================================================

\echo '=== Module 2 | Animal Management Comments ==='


\echo '--- module 2 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/00_Tables_Mod2_Comments.sql


\echo '--- module 2 | foreign key comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/01_ForeignKeys_Mod2_Comments.sql


\echo '--- module 2 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/02_Functions_Mod2_Comments.sql


\echo '--- module 2 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/03_Triggers_Mod2_Comments.sql


\echo '--- module 2 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/04_Indexes_Mod2_Comments.sql


\echo '--- module 2 | view comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/07_Views_Mod2_Comments.sql


\echo '--- module 2 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/05_Procedures_Mod2_Comments.sql


\echo '--- module 2 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/06_Jobs_Mod2_Comments.sql



-- =========================================================
-- module 3 comments
-- =========================================================

\echo '=== Module 3 | Commercial Management Comments ==='


\echo '--- module 3 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/00_Tables_Mod3_Comments.sql


\echo '--- module 3 | foreign key comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/01_ForeignKeys_Mod3_Comments.sql


\echo '--- module 3 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/02_Functions_Mod3_Comments.sql


\echo '--- module 3 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/03_Triggers_Mod3_Comments.sql


\echo '--- module 3 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/04_Indexes_Mod3_Comments.sql


\echo '--- module 3 | view comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/07_Views_Mod3_Comments.sql


\echo '--- module 3 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/05_Procedures_Mod3_Comments.sql


\echo '--- module 3 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/06_Jobs_Mod3_Comments.sql



-- =========================================================
-- module 4 comments
-- =========================================================

\echo '=== Module 4 | Appointment Management Comments ==='


\echo '--- module 4 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/00_Tables_Mod4_Comments.sql


\echo '--- module 4 | foreign key comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/01_ForeignKeys_Mod4_Comments.sql


\echo '--- module 4 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/02_Functions_Mod4_Comments.sql


\echo '--- module 4 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/03_Triggers_Mod4_Comments.sql


\echo '--- module 4 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/04_Indexes_Mod4_Comments.sql


\echo '--- module 4 | view comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/07_Views_Mod4_Comments.sql


\echo '--- module 4 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/05_Procedures_Mod4_Comments.sql


\echo '--- module 4 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/06_Jobs_Mod4_Comments.sql


\echo '========================================'
\echo 'COMMENTS LAYER COMPLETE'
\echo '========================================'
