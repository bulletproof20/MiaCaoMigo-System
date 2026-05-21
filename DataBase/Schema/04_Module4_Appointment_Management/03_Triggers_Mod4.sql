-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 03_Triggers_Mod4.sql
-- =========================================================
--
-- PURPOSE
--   Table-level triggers for scheduling, clinical, and lifecycle rules.
--
-- CLEANUP
--   drop trigger if exists before each create (idempotent reload).
-- =========================================================

-- =========================================================
-- Prevents scheduling when the veterinarian is unavailable
-- =========================================================

drop trigger if exists trg_block_appointment_if_vet_unavailable on appointment;
create trigger trg_block_appointment_if_vet_unavailable
before insert or update on appointment
for each row
execute function fn_block_appointment_if_vet_unavailable();

-- =========================================================
-- Validates prescription registration timing vs appointment start
-- =========================================================

drop trigger if exists trg_validate_prescription_timing on prescription;
create trigger trg_validate_prescription_timing
before insert on prescription
for each row
execute function fn_validate_prescription_timing();

-- =========================================================
-- Deducts inventory when appointment products are consumed
-- =========================================================

drop trigger if exists trg_deduct_product_stock on rel_app_product;
create trigger trg_deduct_product_stock
before insert on rel_app_product
for each row
execute function fn_deduct_product_stock();

-- =========================================================
-- Blocks past-dated scheduling attempts
-- =========================================================

drop trigger if exists trg_block_past_appointments on appointment;
create trigger trg_block_past_appointments
before insert or update on appointment
for each row
execute function fn_block_past_appointments();

-- =========================================================
-- Ensures the animal belongs to the client owning the appointment
-- =========================================================

drop trigger if exists trg_validate_animal_client_relationship on appointment;
create trigger trg_validate_animal_client_relationship
before insert or update of id_ani, id_cli on appointment
for each row
execute function fn_validate_animal_client_relationship();

-- =========================================================
-- Ensures veterinarian credentials cover the requested specialty
-- =========================================================

drop trigger if exists trg_validate_appointment_vet_specialty on appointment;
create trigger trg_validate_appointment_vet_specialty
before insert or update of id_emp, id_spe on appointment
for each row
execute function fn_validate_appointment_vet_specialty();

-- =========================================================
-- Prevents edits to appointments already in terminal states
-- =========================================================

drop trigger if exists trg_prevent_completed_appointment_modification on appointment;
create trigger trg_prevent_completed_appointment_modification
before update on appointment
for each row
execute function fn_prevent_completed_appointment_modification();
