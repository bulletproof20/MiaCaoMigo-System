--=========================================================
-- INDEXES - MODULE 1 (USER MANAGEMENT / ATTENDANCE)
-- Ensures data integrity and enforces business rules
-- through partial unique constraints
--=========================================================

--=========================================================
-- INDEX 1: uq_login_single_active_session_email
-- Ensures that each email can only have one active
-- successful login session at a time.
--=========================================================

create unique index uq_login_single_active_session_email
on login_record(eml_usr)
where sou_tim_log is null 
  and suc_log = true
  and eml_usr is not null;



--=========================================================
-- INDEX 2: uq_employee_active_per_user
-- Ensures that each user can have only one active
-- employee record (i.e., not deactivated).
--=========================================================

create unique index uq_employee_active_per_user
on employee(id_usr)
where dea_dat_emp is null;



--=========================================================
-- INDEX 3: uq_clock_in_active_per_employee
-- Ensures that each employee can have only one
-- active clock-in (without end time).
--=========================================================

create unique index uq_clock_in_active_per_employee
on clock_in(id_emp)
where end_dat_clk is null;