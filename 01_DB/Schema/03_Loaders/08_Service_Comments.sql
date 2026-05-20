-- =========================================================
-- SERVICE FUNCTION COMMENTS (post-services loader)
-- =========================================================
-- Applies COMMENT ON FUNCTION for 01_DB/Services objects.
-- Must run after 06_Services.sql so targets exist.
-- =========================================================

\echo '>>> loading service function comments'

\i /docker-entrypoint-initdb.d/02_Comments/05_Services/00_Core_Comments.sql
\i /docker-entrypoint-initdb.d/02_Comments/05_Services/01_Module1_Comments.sql
\i /docker-entrypoint-initdb.d/02_Comments/05_Services/02_Module2_Comments.sql
\i /docker-entrypoint-initdb.d/02_Comments/05_Services/03_Module3_Comments.sql
\i /docker-entrypoint-initdb.d/02_Comments/05_Services/04_Module4_Comments.sql
