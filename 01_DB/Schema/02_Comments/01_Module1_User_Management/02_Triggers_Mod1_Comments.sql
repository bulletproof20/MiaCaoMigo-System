 -- =========================================================
-- comments: triggers - module 1
-- =========================================================
-- metadata documentation for trigger-based
-- integrity enforcement related to:
-- - attendance validation
-- - employee lifecycle control
-- - role disjunction
-- - absence consistency
-- =========================================================



-- =========================================================
-- trg_block_clock_in_insert
-- =========================================================

comment on trigger trg_block_clock_in_insert on clock_in is
'blocks clock-in registration when the employee is inside an active absence interval';



-- =========================================================
-- trg_block_employee_inactivation
-- =========================================================

comment on trigger trg_block_employee_inactivation on employee is
'prevents employee deactivation while active attendance sessions remain open';



-- =========================================================
-- trg_block_assistant_disjunction
-- =========================================================

comment on trigger trg_block_assistant_disjunction on assistant is
'enforces role disjunction by preventing veterinarian employees from being assigned as assistants';



-- =========================================================
-- trg_block_veterinarian_disjunction
-- =========================================================

comment on trigger trg_block_veterinarian_disjunction on veterinarian is
'enforces role disjunction by preventing assistant employees from being assigned as veterinarians';



-- =========================================================
-- trg_block_absence_overlap_by_user
-- =========================================================

comment on trigger trg_block_absence_overlap_by_user on absence is
'prevents temporal overlap of operational absences for the same user across multiple employee records';