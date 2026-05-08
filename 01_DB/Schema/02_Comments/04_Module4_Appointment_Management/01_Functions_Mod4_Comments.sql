-- =========================================================
-- COMMENTS: FUNCTIONS - MODULE 4
-- =========================================================
-- Metadata documentation for trigger-support and
-- business enforcement functions related to:
-- - Appointment scheduling integrity
-- - Status transition validation
-- - Automated notifications
-- =========================================================



-- =========================================================
-- fn_prevent_conflicting_appointments
-- =========================================================

COMMENT ON FUNCTION fn_prevent_conflicting_appointments() IS
'Blocks the creation or update of an appointment if it conflicts with an existing appointment for the same veterinarian at the same time.';