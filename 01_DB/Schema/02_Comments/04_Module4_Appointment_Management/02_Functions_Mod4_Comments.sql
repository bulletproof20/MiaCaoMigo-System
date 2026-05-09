-- =========================================================
-- comments: functions - module 4
-- =========================================================
-- metadata documentation for scheduling, clinical validation,
-- and inventory hooks supporting appointment workflows.
-- =========================================================

comment on function fn_block_overlapping_appointments() is
'prevents double booking the same veterinarian for overlapping slots';

comment on function fn_block_appointment_if_vet_unavailable() is
'blocks scheduling when absence records intersect the proposed slot';

comment on function fn_validate_prescription_timing() is
'ensures prescription timestamps are not earlier than consultation start';

comment on function fn_deduct_product_stock() is
'validates and decrements inventory for appointment product usage';

comment on function fn_block_past_appointments() is
'rejects appointments scheduled in the past';

comment on function fn_appointment_duration_check() is
'validates that completed visits end after they start';

comment on function fn_appointment_see_app_clt(integer) is
'returns appointment projections for client self-service views';

comment on function fn_validate_animal_client_relationship() is
'ensures the scheduled animal is actively owned by the client';

comment on function fn_prevent_completed_appointment_modification() is
'blocks edits once an appointment reaches a terminal status';
