 -- =========================================================
-- comments: procedures - module 1
-- =========================================================
-- metadata documentation for operational
-- maintenance procedures responsible for:
-- - attendance lifecycle automation
-- - absence lifecycle maintenance
-- - operational consistency
-- - automated data correction
-- =========================================================



-- =========================================================
-- sp_auto_close_clock_in_midnight
-- =========================================================

comment on procedure sp_auto_close_clock_in_midnight() is
'automatically closes open employee clock-in sessions from previous days by assigning midnight as the closing timestamp';



-- =========================================================
-- sp_auto_cancel_expired_absences
-- =========================================================

comment on procedure sp_auto_cancel_expired_absences() is
'automatically cancels pending absences whose scheduled absence interval has already expired';