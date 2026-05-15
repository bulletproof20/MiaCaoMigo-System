--=========================================================
-- TRIGGERS - MODULE 4
-- Enforces business rules and data integrity through table events
--=========================================================

--=========================================================
-- TRIGGER 1: trg_block_overlapping_appointments
-- (This trigger was removed and replaced by an EXCLUDE constraint)

--=========================================================
-- TRIGGER 2: trg_block_appointment_if_vet_unavailable
-- Prevents scheduling an appointment if the assigned veterinarian
-- is marked as absent during the appointment period.
--=========================================================
create or replace trigger trg_block_appointment_if_vet_unavailable
before insert or update on appointment
for each row
execute function fn_block_appointment_if_vet_unavailable();

--=========================================================
-- TRIGGER 3: trg_validate_prescription_timing
-- Ensures a prescription's issue date is not before the
-- associated appointment's start date.
--=========================================================
create or replace trigger trg_validate_prescription_timing
before insert on prescription
for each row
execute function fn_validate_prescription_timing();

--=========================================================
-- TRIGGER 4: trg_deduct_product_stock
-- Deducts the quantity of products used in an appointment
-- from the stock. Checks for sufficient stock before deduction.
--=========================================================
create or replace trigger trg_deduct_product_stock
before insert on rel_app_product
for each row
execute function fn_deduct_product_stock();

--=========================================================
-- TRIGGER 5: trg_block_past_appointments
-- Prevents scheduling appointments with a start date in the past.
--=========================================================
create or replace trigger trg_block_past_appointments
before insert or update on appointment
for each row
execute function fn_block_past_appointments();

--=========================================================
-- TRIGGER 6: trg_validate_animal_client_relationship
-- Ensures the animal belongs to the client before creating/updating an appointment.
--=========================================================
create or replace trigger trg_validate_animal_client_relationship
before insert or update of id_ani, id_cli on appointment
for each row
execute function fn_validate_animal_client_relationship();

--=========================================================
-- TRIGGER 8: trg_validate_appointment_vet_specialty
-- Ensures the consultation specialty matches veterinarian expert credentials.
--=========================================================
create or replace trigger trg_validate_appointment_vet_specialty
before insert or update of id_emp, id_spe on appointment
for each row
execute function fn_validate_appointment_vet_specialty();

--=========================================================
-- TRIGGER 7: trg_prevent_completed_appointment_modification
-- Prevents modification of appointments that are in a terminal state.
--=========================================================
create or replace trigger trg_prevent_completed_appointment_modification
before update on appointment
for each row
execute function fn_prevent_completed_appointment_modification();