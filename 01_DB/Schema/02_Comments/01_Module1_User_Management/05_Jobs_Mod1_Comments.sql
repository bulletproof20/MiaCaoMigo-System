 -- =========================================================
-- comments: jobs - module 1
-- =========================================================
-- metadata documentation for scheduled
-- operational automation jobs responsible for:
-- - attendance maintenance
-- - absence lifecycle maintenance
-- - automated operational corrections
-- - periodic consistency enforcement
--
-- important:
-- pg_cron jobs are not native relational
-- schema objects.
--
-- because of this, postgresql does not allow:
-- - comment on job
-- - comment on cron entry
--
-- therefore, job metadata must be documented
-- manually through structured sql comments
-- inside the corresponding migration files.
--
-- schemaspy may still expose this information
-- if properly parsed from source scripts.
-- =========================================================



-- =========================================================
-- cron.schedule
-- =========================================================

comment on function cron.schedule(text, text, text) is
'registers scheduled pg_cron jobs responsible for automated database task execution';