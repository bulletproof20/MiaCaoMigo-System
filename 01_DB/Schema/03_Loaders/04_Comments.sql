-- =========================================================
-- comments loader
-- =========================================================
-- applies metadata and descriptive documentation
-- across the database structure.
--
-- supports:
-- - schemaspy
-- - pgadmin
-- - schema introspection
-- - internal tooling
-- - future maintainability
--
-- includes comments for:
-- - tables
-- - columns
-- - constraints
-- - functions
-- - triggers
-- - procedures
-- - indexes
-- - jobs
-- - views
-- =========================================================

\echo '========================================'
\echo 'COMMENTS LAYER'
\echo '========================================'



-- =========================================================
-- core comments
-- =========================================================

\echo '=== Core Comments ==='


-- common functions comments
\echo '--- core | common functions comments'

\i /docker-entrypoint-initdb.d/02_Comments/00_Core/00_Common_Functions_Comments.sql



-- =========================================================
-- module 1 comments
-- =========================================================

\echo '=== Module 1 | User Management Comments ==='


-- table comments
\echo '--- module 1 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/00_Tables_Mod1_Comments.sql


-- function comments
\echo '--- module 1 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/01_Functions_Mod1_Comments.sql


-- trigger comments
\echo '--- module 1 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/02_Triggers_Mod1_Comments.sql


-- index comments
\echo '--- module 1 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/03_Indexes_Mod1_Comments.sql


-- procedure comments
\echo '--- module 1 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/04_Procedures_Mod1_Comments.sql


-- job comments
\echo '--- module 1 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/01_Module1_User_Management/05_Jobs_Mod1_Comments.sql



-- =========================================================
-- module 2 comments
-- =========================================================

\echo '=== Module 2 | Animal Management Comments ==='


-- table comments
\echo '--- module 2 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/00_Tables_Mod2_Comments.sql


-- function comments
\echo '--- module 2 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/01_Functions_Mod2_Comments.sql


-- trigger comments
\echo '--- module 2 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/02_Triggers_Mod2_Comments.sql


-- index comments
\echo '--- module 2 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/03_Indexes_Mod2_Comments.sql


-- procedure comments
\echo '--- module 2 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/04_Procedures_Mod2_Comments.sql


-- job comments
\echo '--- module 2 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/02_Module2_Animal_Management/05_Jobs_Mod2_Comments.sql



-- =========================================================
-- module 3 comments
-- =========================================================

\echo '=== Module 3 | Commercial Management Comments ==='


-- table comments
\echo '--- module 3 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/00_Tables_Mod3_Comments.sql


-- function comments
\echo '--- module 3 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/01_Functions_Mod3_Comments.sql


-- trigger comments
\echo '--- module 3 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/02_Triggers_Mod3_Comments.sql


-- index comments
\echo '--- module 3 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/03_Indexes_Mod3_Comments.sql


-- procedure comments
\echo '--- module 3 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/04_Procedures_Mod3_Comments.sql


-- job comments
\echo '--- module 3 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/03_Module3_Commercial_Management/05_Jobs_Mod3_Comments.sql



-- =========================================================
-- module 4 comments
-- =========================================================

\echo '=== Module 4 | Appointment Management Comments ==='


-- table comments
\echo '--- module 4 | table comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/00_Tables_Mod4_Comments.sql


-- function comments
\echo '--- module 4 | function comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/01_Functions_Mod4_Comments.sql


-- trigger comments
\echo '--- module 4 | trigger comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/02_Triggers_Mod4_Comments.sql


-- index comments
\echo '--- module 4 | index comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/03_Indexes_Mod4_Comments.sql


-- procedure comments
\echo '--- module 4 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/04_Procedures_Mod4_Comments.sql


-- job comments
\echo '--- module 4 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/05_Jobs_Mod4_Comments.sql