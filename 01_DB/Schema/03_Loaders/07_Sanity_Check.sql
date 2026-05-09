-- =========================================================
-- sanity check loader
-- =========================================================
-- performs final validation checks after all
-- database layers are loaded.
--
-- validates:
-- - successful initialization
-- - extension availability
-- - structural readiness
-- - integrity readiness
-- - comments layer reachability (indirectly, via prior \i success)
-- =========================================================

\echo '========================================'
\echo 'SANITY CHECK LAYER'
\echo '========================================'



-- =========================================================
-- initialization validation
-- =========================================================
-- validates whether the initialization process
-- reached the final execution stage correctly.
-- =========================================================

\echo '=== Initialization Validation ==='


-- database initialization confirmation
\echo '--- validating initialization status'

-- returns a simple success message confirming
-- that the initialization process completed
-- without fatal execution errors.
select 
    'database initialized successfully' as status;



-- =========================================================
-- extension validation
-- =========================================================
-- validates whether required postgresql
-- extensions were successfully enabled.
-- =========================================================

\echo '=== Extension Validation ==='


-- pg_cron validation
\echo '--- validating pg_cron extension'

-- retrieves the extension name from the
-- internal pg_extension catalog.
--
-- if the extension exists, one row is returned.
-- otherwise, the result will be empty.
select 
    extname as extension_name
from pg_extension
where extname = 'pg_cron';


-- btree_gist validation
\echo '--- validating btree_gist extension'

-- validates whether the btree_gist extension
-- exists in the current database.
--
-- this extension is commonly used for:
-- - exclusion constraints
-- - advanced indexing strategies
-- - temporal overlap prevention
select 
    extname as extension_name
from pg_extension
where extname = 'btree_gist';



-- =========================================================
-- structural validation
-- =========================================================
-- validates whether structural entities
-- were successfully created.
-- =========================================================

\echo '=== Structural Validation ==='


-- validates table existence
\echo '--- validating structural entities'

-- retrieves all tables from the public schema.
--
-- information_schema.tables:
-- standardized sql metadata view containing
-- information about database tables.
--
-- table_schema = 'public':
-- filters only user-created public entities.
--
-- order by table_name:
-- improves readability and deterministic output.
select 
    table_name
from information_schema.tables
where table_schema = 'public'
order by table_name;



-- =========================================================
-- integrity validation
-- =========================================================
-- validates whether integrity-related
-- executable components were successfully loaded.
-- =========================================================

\echo '=== Integrity Validation ==='


-- validates trigger existence
\echo '--- validating triggers'

-- retrieves all triggers registered in the
-- public schema.
--
-- information_schema.triggers:
-- metadata view containing trigger definitions.
--
-- trigger_name:
-- name of the trigger object.
--
-- event_object_table:
-- table associated with the trigger.
select 
    trigger_name,
    event_object_table
from information_schema.triggers
where trigger_schema = 'public'
order by event_object_table;


-- validates functions existence
\echo '--- validating functions'

-- retrieves all functions created in the
-- public schema.
--
-- information_schema.routines:
-- metadata view containing routines such as:
-- - functions
-- - procedures
--
-- routine_type = 'FUNCTION':
-- filters only functions.
select 
    routine_name
from information_schema.routines
where routine_schema = 'public'
and routine_type = 'FUNCTION'

-- excludes internal extension helper functions
and routine_name not like 'gbt_%'
and routine_name not like '%_dist'

order by routine_name;


-- =========================================================
-- final confirmation
-- =========================================================
-- final visual confirmation printed to the
-- execution console.
-- =========================================================

\echo '========================================'
\echo 'DATABASE SETUP COMPLETED SUCCESSFULLY'
\echo '========================================'