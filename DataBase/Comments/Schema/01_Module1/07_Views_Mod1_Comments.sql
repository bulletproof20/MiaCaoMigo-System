-- =========================================================
-- comments: views - module 1
-- =========================================================

comment on view vw_active_employee_directory is
'active employees joined to user_account for directory and scheduling consumers';

comment on view vw_open_clock_in_sessions is
'open clock-in rows without end timestamp, enriched with employee identity';

comment on view vw_operational_absences is
'pending, approved, and detected absences with employee and user context';
