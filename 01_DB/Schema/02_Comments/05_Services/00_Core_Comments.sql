-- =========================================================
-- comments: services — core
-- =========================================================

comment on function normalize_email(character varying) is
'Normalizes email input (trim + lower case) for consistent identity and session lookups across all modules.';
