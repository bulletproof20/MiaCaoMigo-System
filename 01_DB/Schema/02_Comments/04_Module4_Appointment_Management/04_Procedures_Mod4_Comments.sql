-- =========================================================
-- COMMENTS: PROCEDURES - MODULE 4
-- =========================================================
-- Metadata documentation for operational
-- maintenance procedures responsible for:
-- - Appointment status lifecycle automation
-- - Generating client notifications
-- - Data archiving
-- =========================================================



-- =========================================================
-- prc_auto_update_no_show_appointments
-- =========================================================

COMMENT ON PROCEDURE prc_auto_update_no_show_appointments() IS
'Automatically updates the status of past, scheduled appointments to ''No-Show'' if they were not attended.';