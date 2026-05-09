-- =========================================================
-- comments: triggers - module 4
-- =========================================================
-- metadata documentation for appointment lifecycle enforcement.
-- =========================================================

comment on trigger trg_block_overlapping_appointments on appointment is
'fires before insert/update to enforce veterinarian availability windows';

comment on trigger trg_block_appointment_if_vet_unavailable on appointment is
'fires before insert/update to respect recorded absences';

comment on trigger trg_validate_prescription_timing on prescription is
'fires before insert to align prescription time with consultation start';

comment on trigger trg_deduct_product_stock on rel_app_product is
'fires before insert to reserve inventory for appointment usage';

comment on trigger trg_block_past_appointments on appointment is
'fires before insert/update to reject retroactive scheduling';

comment on trigger trg_validate_animal_client_relationship on appointment is
'fires before insert/update of client or animal to validate ownership';

comment on trigger trg_prevent_completed_appointment_modification on appointment is
'fires before update to freeze terminal appointments';
