-- =========================================================
-- SERVICE FUNCTION COMMENTS (post-services loader)
-- =========================================================
-- Applies COMMENT ON FUNCTION for DataBase/Services objects.
-- Must run after 06_Services.sql so targets exist.
-- =========================================================

\echo '>>> loading service function comments'

\i /docker-entrypoint-initdb.d/Comments/Services/00_Core/00_Core_Comments.sql
\i /docker-entrypoint-initdb.d/Comments/Services/01_Module1/01_Module1_Comments.sql
\i /docker-entrypoint-initdb.d/Comments/Services/02_Module2/02_Module2_Comments.sql
\i /docker-entrypoint-initdb.d/Comments/Services/03_Module3/03_Module3_Comments.sql
\i /docker-entrypoint-initdb.d/Comments/Services/04_Module4/04_Module4_Comments.sql
