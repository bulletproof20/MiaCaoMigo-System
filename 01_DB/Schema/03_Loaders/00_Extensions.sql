-- =========================================================
-- extensions loader
-- =========================================================
-- enables required postgresql extensions used
-- across the database infrastructure.
--
-- extensions expand native postgresql
-- capabilities and provide support for:
-- - scheduling
-- - advanced indexing
-- - exclusion constraints
-- - automation
--
-- extension-specific COMMENT ON statements (if any) should stay
-- beside the objects that depend on them or in 02_Comments when
-- the described object is created during init.
-- =========================================================

\echo '========================================'
\echo 'EXTENSIONS LAYER'
\echo '========================================'



-- =========================================================
-- pg_cron
-- =========================================================
-- enables native job scheduling inside
-- postgresql.
--
-- pg_cron allows execution of:
-- - scheduled procedures
-- - maintenance routines
-- - cleanup jobs
-- - automated operational tasks
--
-- jobs are executed directly inside the
-- database engine using cron syntax.
-- =========================================================

\echo '=== pg_cron Extension ==='


-- removing existing pg_cron extension
\echo '--- removing existing pg_cron extension'

-- removes the extension if it already exists.
--
-- cascade:
-- automatically removes dependent objects
-- associated with the extension.
drop extension if exists pg_cron cascade;


-- enabling pg_cron extension
\echo '--- enabling pg_cron extension'

-- creates the extension if it does not exist.
--
-- this makes pg_cron features available
-- inside the current database.
create extension if not exists pg_cron;



-- =========================================================
-- btree_gist
-- =========================================================
-- enables btree-compatible operators inside
-- gist indexes.
--
-- commonly used for:
-- - exclusion constraints
-- - temporal overlap validation
-- - advanced indexing strategies
-- - range conflict prevention
-- =========================================================

\echo '=== btree_gist Extension ==='


-- enabling btree_gist extension
\echo '--- enabling btree_gist extension'

-- creates the extension if it does not exist.
--
-- extends gist indexing capabilities with
-- btree operator support such as:
-- - =
-- - <
-- - >
-- - <=
-- - >=
create extension if not exists btree_gist;



-- =========================================================
-- final confirmation
-- =========================================================
-- confirms successful extension loading.
-- =========================================================

\echo '========================================'
\echo 'EXTENSIONS LOADED SUCCESSFULLY'
\echo '========================================'