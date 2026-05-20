-- =========================================================
-- COMMENTS LAYER (Bootstrap/Loaders/05_Comments.sql)
-- =========================================================
--
-- DESCRIPTION
-- Applies COMMENT ON metadata after structural and behavioral DDL.
-- Sources live under DataBase/Comments/Schema/ (not under Schema/).
--
-- ORDER (mirrors Schema module folders)
-- Core types -> per module: tables, FKs, functions, triggers,
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

\i /docker-entrypoint-initdb.d/Comments/Schema/00_Core/02_Types_Comments.sql

\echo '--- core | shared functions'

\i /docker-entrypoint-initdb.d/Comments/Schema/00_Core/00_Common_Functions_Comments.sql



-- =========================================================
-- module 1 comments
-- =========================================================

\echo '=== Module 1 | User Management Comments ==='


\echo '--- module 1 | table comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/00_Tables_Mod1_Comments.sql


\echo '--- module 1 | foreign key comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/01_ForeignKeys_Mod1_Comments.sql


\echo '--- module 1 | function comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/02_Functions_Mod1_Comments.sql


\echo '--- module 1 | trigger comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/03_Triggers_Mod1_Comments.sql


\echo '--- module 1 | index comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/04_Indexes_Mod1_Comments.sql


\echo '--- module 1 | view comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/07_Views_Mod1_Comments.sql


\echo '--- module 1 | procedure comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/05_Procedures_Mod1_Comments.sql


\echo '--- module 1 | job comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/01_Module1/06_Jobs_Mod1_Comments.sql



-- =========================================================
-- module 2 comments
-- =========================================================

\echo '=== Module 2 | Animal Management Comments ==='


\echo '--- module 2 | table comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/00_Tables_Mod2_Comments.sql


\echo '--- module 2 | foreign key comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/01_ForeignKeys_Mod2_Comments.sql


\echo '--- module 2 | function comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/02_Functions_Mod2_Comments.sql


\echo '--- module 2 | trigger comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/03_Triggers_Mod2_Comments.sql


\echo '--- module 2 | index comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/04_Indexes_Mod2_Comments.sql


\echo '--- module 2 | view comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/07_Views_Mod2_Comments.sql


\echo '--- module 2 | procedure comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/05_Procedures_Mod2_Comments.sql


\echo '--- module 2 | job comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/02_Module2/06_Jobs_Mod2_Comments.sql



-- =========================================================
-- module 3 comments
-- =========================================================

\echo '=== Module 3 | Commercial Management Comments ==='


\echo '--- module 3 | table comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/00_Tables_Mod3_Comments.sql


\echo '--- module 3 | foreign key comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/01_ForeignKeys_Mod3_Comments.sql


\echo '--- module 3 | function comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/02_Functions_Mod3_Comments.sql


\echo '--- module 3 | trigger comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/03_Triggers_Mod3_Comments.sql


\echo '--- module 3 | index comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/04_Indexes_Mod3_Comments.sql


\echo '--- module 3 | view comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/07_Views_Mod3_Comments.sql


\echo '--- module 3 | procedure comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/05_Procedures_Mod3_Comments.sql


\echo '--- module 3 | job comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/03_Module3/06_Jobs_Mod3_Comments.sql



-- =========================================================
-- module 4 comments
-- =========================================================

\echo '=== Module 4 | Appointment Management Comments ==='


\echo '--- module 4 | table comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/00_Tables_Mod4_Comments.sql


\echo '--- module 4 | foreign key comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/01_ForeignKeys_Mod4_Comments.sql


\echo '--- module 4 | function comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/02_Functions_Mod4_Comments.sql


\echo '--- module 4 | trigger comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/03_Triggers_Mod4_Comments.sql


\echo '--- module 4 | index comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/04_Indexes_Mod4_Comments.sql


\echo '--- module 4 | view comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/07_Views_Mod4_Comments.sql


\echo '--- module 4 | procedure comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/05_Procedures_Mod4_Comments.sql


\echo '--- module 4 | job comments'

\i /docker-entrypoint-initdb.d/Comments/Schema/04_Module4/06_Jobs_Mod4_Comments.sql


\echo '========================================'
\echo 'COMMENTS LAYER COMPLETE'
\echo '========================================'
