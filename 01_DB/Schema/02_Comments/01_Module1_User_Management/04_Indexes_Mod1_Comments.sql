 -- =========================================================
-- comments: indexes - module 1
-- =========================================================
-- metadata documentation for indexes and
-- exclusion constraints responsible for:
-- - operational uniqueness
-- - session consistency
-- - temporal integrity
-- - overlap prevention
-- =========================================================



-- =========================================================
-- uq_login_single_active_session_email
-- =========================================================

comment on index uq_login_single_active_session_email is
'ensures that each email address can only maintain one active successful login session at a time';



-- =========================================================
-- uq_employee_active_per_user
-- =========================================================

comment on index uq_employee_active_per_user is
'ensures that each user account can only have one operationally active employee record';



-- =========================================================
-- uq_clock_in_active_per_employee
-- =========================================================

comment on index uq_clock_in_active_per_employee is
'ensures that each employee can only maintain one active clock-in session without end timestamp';



-- =========================================================
-- ex_schedule_overlap
-- =========================================================

comment on constraint ex_schedule_overlap on schedule is
'prevents overlapping work schedule intervals for the same employee on the same weekday using temporal exclusion validation';