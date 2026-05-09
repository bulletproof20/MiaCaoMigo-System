--=========================================================
-- TRIGGERS - MODULE 1
-- Enforces business rules and data integrity through table events
--=========================================================

--=========================================================
-- TRIGGER 1: trg_block_clock_in_insert
-- Prevents clock-in creation when the employee is absent
-- during the specified period, without affecting clock-out.
--=========================================================

create or replace trigger trg_block_clock_in_insert
before insert on clock_in            -- fires before a new row is inserted
for each row                         -- executes once per inserted row
execute function fn_block_clock_in_if_absent(); -- calls validation function


--=========================================================
-- TRIGGER 2: trg_block_employee_inactivation
-- Prevents employee inactivation if there is an active
-- clock-in record (without end time).
--=========================================================

create or replace trigger trg_block_employee_inactivation
before update of dea_dat_emp on employee     -- fires when deactivation date is set
for each row                                 -- executes once per affected row
execute function fn_block_inactivate_if_clock_active(); -- calls validation


--=========================================================
-- TRIGGER 3: trg_block_assistant_disjunction
-- Ensures role disjunction by preventing an employee already
-- assigned as veterinarian from being assigned as assistant,
-- and vice versa.
--=========================================================

create or replace trigger trg_block_assistant_disjunction
before insert or update on assistant     -- fires on insert or role change
for each row                              -- executes once per affected row
execute function fn_block_assistant_if_veterinarian_exists(); -- calls validation


--=========================================================
-- TRIGGER 4: trg_block_veterinarian_disjunction
-- Ensures role disjunction by preventing an employee already
-- assigned as assistant from being assigned as veterinarian,
-- and vice versa.
--=========================================================

create or replace trigger trg_block_veterinarian_disjunction
before insert or update on veterinarian   -- fires on insert or role change
for each row                               -- executes once per affected row
execute function fn_block_veterinarian_if_assistant_exists(); -- calls validation


--=========================================================
-- TRIGGER 5: trg_block_absence_overlap_by_user
-- Prevents overlapping absences for the same user
-- across all associated employee records.
--=========================================================

create or replace trigger trg_block_absence_overlap_by_user
before insert or update on absence     -- fires on insert or absence update
for each row                           -- executes once per affected row
execute function fn_block_absence_overlap_by_user(); -- calls validation


