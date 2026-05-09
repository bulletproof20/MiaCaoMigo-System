-- =========================================================
-- comments loader
-- =========================================================
-- applies COMMENT ON metadata after structural and behavioral
-- objects exist (post 03_Integrity.sql).
--
-- layout mirrors 01_Modules:
--   00_Tables → 01_ForeignKeys → 02_Functions → 03_Triggers
--   → 04_Indexes → 05_Procedures → 06_Jobs
--
-- each module under 02_Comments uses the same folder names and
-- numbering as 01_Modules, with the _Comments.sql suffix.
--
-- supports:
-- - schemaspy / pgadmin introspection
-- - operator documentation
-- - future tooling that reads pg_catalog descriptions
-- =========================================================

\echo '========================================'
\echo 'COMMENTS LAYER'
\echo '========================================'



-- =========================================================
-- core comments
-- =========================================================

\echo '=== Core Comments ==='


\echo '--- core | shared documentation placeholder'

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


\echo '--- module 4 | procedure comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/05_Procedures_Mod4_Comments.sql


\echo '--- module 4 | job comments'

\i /docker-entrypoint-initdb.d/02_Comments/04_Module4_Appointment_Management/06_Jobs_Mod4_Comments.sql


\echo '========================================'
\echo 'COMMENTS LAYER COMPLETE'
\echo '========================================'
