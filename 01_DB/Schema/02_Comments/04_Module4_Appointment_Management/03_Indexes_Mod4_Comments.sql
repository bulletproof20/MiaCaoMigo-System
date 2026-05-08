-- =========================================================
-- COMMENTS: INDEXES - MODULE 4
-- =========================================================
-- Metadata documentation for indexes and
-- exclusion constraints responsible for:
-- - Preventing scheduling overlaps
-- - Optimizing appointment lookups
-- - Ensuring data integrity
-- =========================================================



-- =========================================================
-- ex_appointment_vet_overlap
-- =========================================================

COMMENT ON CONSTRAINT ex_appointment_vet_overlap ON appointment IS
'Prevents overlapping appointment time ranges for the same veterinarian using a temporal exclusion constraint.';