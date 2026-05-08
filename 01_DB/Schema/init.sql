-- =========================================================
-- init: database setup (miacaomigo)
-- =========================================================
-- central orchestration script responsible for
-- loading the complete database architecture.
--


\echo '========================================'
\echo 'MIACAOMIGO DATABASE INITIALIZATION'
\echo '========================================'



-- =========================================================
-- extensions layer
-- =========================================================
-- loads required postgresql extensions used
-- across the database infrastructure.
-- =========================================================

\echo '>>> loading extensions layer'

\i /docker-entrypoint-initdb.d/03_Loaders/00_Extensions.sql



-- =========================================================
-- structure layer
-- =========================================================
-- loads physical relational structures such as:
-- - core entities
-- - tables
-- - indexes
-- - foreign keys
-- =========================================================

\echo '>>> loading structure layer'

\i /docker-entrypoint-initdb.d/03_Loaders/01_Structure.sql



-- =========================================================
-- integrity layer
-- =========================================================
-- loads executable integrity and behavioral
-- components such as:
-- - functions
-- - triggers
-- - procedures
-- - jobs
-- =========================================================

\echo '>>> loading integrity layer'

\i /docker-entrypoint-initdb.d/03_Loaders/02_Integrity.sql



-- =========================================================
-- data migration layer
-- =========================================================
-- loads master and reference data required
-- for stable system operation.
--
-- includes:
-- - permissions
-- - profiles
-- - specialties
-- - default configurations
-- - controlled reference entities
-- =========================================================

\echo '>>> loading data migration layer'

\i /docker-entrypoint-initdb.d/03_Loaders/03_Data_Migration.sql



-- =========================================================
-- comments layer
-- =========================================================
-- loads metadata documentation and descriptive
-- annotations for:
-- - schemaspy
-- - pgadmin
-- - introspection tooling
-- - future maintainability
-- =========================================================

\echo '>>> loading comments layer'

\i /docker-entrypoint-initdb.d/03_Loaders/04_Comments.sql



-- =========================================================
-- queries layer
-- =========================================================
-- loads reusable query definitions consumed
-- by the application and reporting layers.
-- =========================================================

\echo '>>> loading queries layer'

\i /docker-entrypoint-initdb.d/03_Loaders/05_Queries.sql



-- =========================================================
-- sanity check layer
-- =========================================================
-- performs final validation checks after all
-- database layers are fully loaded.
-- =========================================================

\echo '>>> loading sanity check layer'

\i /docker-entrypoint-initdb.d/03_Loaders/06_Sanity_Check.sql



-- =========================================================
-- initialization completed
-- =========================================================
