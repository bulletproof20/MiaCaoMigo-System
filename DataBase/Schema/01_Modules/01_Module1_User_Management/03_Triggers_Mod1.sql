-- =========================================================
-- MODULE 1 — USER MANAGEMENT
-- =========================================================
-- FILE: 03_Triggers_Mod1.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Table-level triggers enforcing attendance, role, absence,
-- and auto-provisioning rules on top of Module 1 functions.
--
-- This file contains:
-- - BEFORE INSERT/UPDATE guards on clock_in, employee, assistant, veterinarian, absence
-- - AFTER INSERT hook for default user setup
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 02_Functions_Mod1.sql (trigger functions)
-- - Module 1 tables and constraints
--
-- Must load before:
-- - 04_Indexes_Mod1.sql (partial unique indexes reference same tables)
-- =========================================================

-- =========================================================
-- Prevents clock-in creation during an absence window
-- =========================================================

create or replace trigger trg_block_clock_in_insert
before insert on clock_in            -- fires before a new row is inserted
for each row                         -- executes once per inserted row
execute function fn_block_clock_in_if_absent(); -- calls validation function


-- =========================================================
-- Prevents deactivation while a clock-in remains open
-- =========================================================

create or replace trigger trg_block_employee_inactivation
before update of dea_dat_emp on employee     -- fires when deactivation date is set
for each row                                 -- executes once per affected row
execute function fn_block_inactivate_if_clock_active(); -- calls validation


-- =========================================================
-- Blocks assistant rows when the employee is already a veterinarian
-- =========================================================

create or replace trigger trg_block_assistant_disjunction
before insert or update on assistant     -- fires on insert or role change
for each row                              -- executes once per affected row
execute function fn_block_assistant_if_veterinarian_exists(); -- calls validation


-- =========================================================
-- Blocks veterinarian rows when the employee is already an assistant
-- =========================================================

create or replace trigger trg_block_veterinarian_disjunction
before insert or update on veterinarian   -- fires on insert or role change
for each row                               -- executes once per affected row
execute function fn_block_veterinarian_if_assistant_exists(); -- calls validation


-- =========================================================
-- Prevents overlapping absences for the same logical user
-- =========================================================

create or replace trigger trg_block_absence_overlap_by_user
before insert or update on absence     -- fires on insert or absence update
for each row                           -- executes once per affected row
execute function fn_block_absence_overlap_by_user(); -- calls validation


-- =========================================================
-- Creates default setup row after each user_account insert
-- =========================================================

create or replace trigger trg_create_default_setup
after insert on user_account
for each row
execute function fn_create_default_setup();
