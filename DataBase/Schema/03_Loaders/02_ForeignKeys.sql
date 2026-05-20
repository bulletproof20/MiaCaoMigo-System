-- =========================================================
-- FOREIGN KEYS LAYER (03_Loaders/02_ForeignKeys.sql)
-- =========================================================
--
-- DESCRIPTION
-- Applies deferred foreign keys after all 00_Tables_Mod*.sql
-- scripts. One file per module: 01_ForeignKeys_Mod*.sql.
--
-- PURPOSE
-- Avoids circular CREATE TABLE ordering; keeps FK phase explicit
-- for CI and reviews.
--
-- Metadata: 02_Comments/**/01_ForeignKeys_*_Comments.sql
-- =========================================================

\echo '========================================'
\echo 'FOREIGN KEYS LAYER'
\echo '========================================'


\echo '--- module 1 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/01_Module1_User_Management/01_ForeignKeys_Mod1.sql

\echo '--- module 2 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/02_Module2_Animal_Management/01_ForeignKeys_Mod2.sql

\echo '--- module 3 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/03_Module3_Commercial_Management/01_ForeignKeys_Mod3.sql

\echo '--- module 4 | foreign keys'
\i /docker-entrypoint-initdb.d/01_Modules/04_Module4_Appointment_Management/01_ForeignKeys_Mod4.sql
