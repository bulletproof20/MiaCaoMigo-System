-- =========================================================
-- COMMENTS: TRIGGERS - MODULE 4
-- =========================================================
-- Metadata documentation for trigger-based
-- integrity enforcement related to:
-- - Appointment scheduling conflicts
-- - Automatic status updates
-- - Notification generation
-- =========================================================



-- =========================================================
-- trg_check_appointment_conflict
-- =========================================================

COMMENT ON TRIGGER trg_check_appointment_conflict ON appointment IS
'Prevents temporal overlap of appointments for the same veterinarian before an insert or update operation.';