 -- =========================================================
-- comments: functions - module 1
-- =========================================================
-- metadata documentation for trigger-support and
-- business enforcement functions related to:
-- - attendance
-- - absences
-- - role integrity
-- - operational consistency
-- =========================================================



-- =========================================================
-- fn_block_clock_in_if_absent
-- =========================================================

comment on function fn_block_clock_in_if_absent() is
'blocks employee clock-in operations when the employee is currently inside an active absence period';



-- =========================================================
-- fn_block_inactivate_if_clock_active
-- =========================================================

comment on function fn_block_inactivate_if_clock_active() is
'prevents employee inactivation while an active clock-in session without end timestamp exists';



-- =========================================================
-- fn_block_assistant_if_veterinarian_exists
-- =========================================================

comment on function fn_block_assistant_if_veterinarian_exists() is
'enforces role disjunction by preventing assignment of assistant role to employees already registered as veterinarians';



-- =========================================================
-- fn_block_veterinarian_if_assistant_exists
-- =========================================================

comment on function fn_block_veterinarian_if_assistant_exists() is
'enforces role disjunction by preventing assignment of veterinarian role to employees already registered as assistants';



-- =========================================================
-- fn_block_absence_overlap_by_user
-- =========================================================

comment on function fn_block_absence_overlap_by_user() is
'prevents overlapping operational absences for the same user across multiple employee records';