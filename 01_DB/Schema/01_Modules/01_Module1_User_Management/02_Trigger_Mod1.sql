--=========================================================
-- TRIGGERS - MODULE 1
-- Binds functions to table events
--=========================================================

--=========================================================
-- TRIGGER: trg_block_clock_in_insert
-- Executes validation before inserting a clock-in record
--=========================================================

create or replace trigger trg_block_clock_in_insert
before insert on clock_in            -- fires before a new row is inserted
for each row                         -- executes once per inserted row
execute function fn_block_clock_in_if_absent(); -- calls validation function


--=========================================================
-- TRIGGER: trg_block_employee_inactivation
-- Executes validation before setting employee deactivation
--=========================================================

create or replace trigger trg_block_employee_inactivation
before update of dea_dat_emp on employee     -- fires when deactivation date is set
for each row                                 -- executes once per affected row
execute function fn_block_inactivate_if_clock_active(); -- calls validation


--=========================================================
-- TRIGGER: trg_block_assistant_overlap
-- Executes validation before inserting/updating assistant
--=========================================================

create or replace trigger trg_block_assistant_overlap
before insert or update on assistant     -- fires on insert or role change
for each row                              -- executes once per affected row
execute function fn_block_assistant_if_veterinarian_exists(); -- calls validation


--=========================================================
-- TRIGGER: trg_block_veterinarian_overlap
-- Executes validation before inserting/updating veterinarian
--=========================================================

create or replace trigger trg_block_veterinarian_overlap
before insert or update on veterinarian   -- fires on insert or role change
for each row                               -- executes once per affected row
execute function fn_block_veterinarian_if_assistant_exists(); -- calls validation


--=========================================================
-- TRIGGER: trg_check_user_mandatory_role
-- Executes validation at end of transaction to ensure
-- user has at least one role
--=========================================================

create constraint trigger trg_check_user_mandatory_role
after insert on user_account              -- fires after user creation
deferrable initially deferred             -- executes only at transaction commit
for each row                              -- executes once per affected row
execute function fn_check_user_has_mandatory_role(); -- calls validation
