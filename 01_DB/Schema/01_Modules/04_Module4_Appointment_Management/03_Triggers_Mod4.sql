-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- =========================================================
-- FILE: 03_Triggers_Mod4.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Table-level triggers enforcing scheduling, clinical, prescription,
-- and lifecycle rules for appointments and related entities.
--
-- Note:
-- Overlapping veterinarian appointments are enforced primarily via
-- GiST exclusion (see 04_Indexes_Mod4.sql); related function hooks
-- remain for documentation symmetry with historical layouts.
--
-- This file contains:
-- - Appointment scheduling and lifecycle guards
-- - Prescription and product-usage hooks
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 02_Functions_Mod4.sql
-- - Cross-module tables (absence, expert, ownership, stock)
--
-- Must load before:
-- - 05_Procedures_Mod4.sql / 06_Jobs_Mod4.sql (operational callers)
-- =========================================================

-- =========================================================
-- Prevents scheduling when the veterinarian is unavailable
-- =========================================================

create or replace trigger trg_block_appointment_if_vet_unavailable
before insert or update on appointment
for each row
execute function fn_block_appointment_if_vet_unavailable();

-- =========================================================
-- Validates prescription registration timing vs appointment start
-- =========================================================

create or replace trigger trg_validate_prescription_timing
before insert on prescription
for each row
execute function fn_validate_prescription_timing();

-- =========================================================
-- Deducts inventory when appointment products are consumed
-- =========================================================

create or replace trigger trg_deduct_product_stock
before insert on rel_app_product
for each row
execute function fn_deduct_product_stock();

-- =========================================================
-- Blocks past-dated scheduling attempts
-- =========================================================

create or replace trigger trg_block_past_appointments
before insert or update on appointment
for each row
execute function fn_block_past_appointments();

-- =========================================================
-- Ensures the animal belongs to the client owning the appointment
-- =========================================================

create or replace trigger trg_validate_animal_client_relationship
before insert or update of id_ani, id_cli on appointment
for each row
execute function fn_validate_animal_client_relationship();

-- =========================================================
-- Ensures veterinarian credentials cover the requested specialty
-- =========================================================

create or replace trigger trg_validate_appointment_vet_specialty
before insert or update of id_emp, id_spe on appointment
for each row
execute function fn_validate_appointment_vet_specialty();

-- =========================================================
-- Prevents edits to appointments already in terminal states
-- =========================================================

create or replace trigger trg_prevent_completed_appointment_modification
before update on appointment
for each row
execute function fn_prevent_completed_appointment_modification();
