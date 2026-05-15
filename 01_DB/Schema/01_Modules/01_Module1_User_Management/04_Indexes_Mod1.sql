--=========================================================
-- INDEXES - MODULE 1
-- Ensures older indexes get droped before new ones
-- avoids conflit
--=========================================================
drop index if exists uq_login_single_active_session_email;
drop index if exists uq_employee_active_per_user;
drop index if exists uq_clock_in_active_per_employee;
alter table schedule drop constraint if exists ex_schedule_overlap;


--=========================================================
-- INDEXES - MODULE 1
-- Ensures data integrity and operational consistency
-- through partial unique indexes.
--=========================================================



--=========================================================
-- INDEX 1: uq_login_single_active_session_email
-- Ensures that each email can only have one active
-- successful login session at a time.
--=========================================================

create unique index uq_login_single_active_session_email
on login_record(ema_log)
where sou_tim_log is null 
  and suc_log = true
  and ema_log is not null;



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
-- active clock-in record (without end time).
--=========================================================

create unique index uq_clock_in_active_per_employee
on clock_in(id_emp)
where end_dat_clk is null;







--=========================================================
-- EXCLUSION CONSTRAINTS - MODULE 1
-- Ensures temporal integrity and prevents overlapping
-- operational intervals through GiST exclusion constraints.
--=========================================================



--=========================================================
-- EXCLUDE CONSTRAINT 1: ex_schedule_overlap
-- Prevents overlapping schedule periods for the same
-- employee on the same weekday.
--
-- Uses GiST indexing with timestamp ranges to enforce
-- temporal integrity and avoid conflicting work shifts.
--=========================================================

alter table schedule
add constraint ex_schedule_overlap
exclude using gist (

    id_emp with =,

    day_wee_sch with =,

    tsrange(
        ('2000-01-01'::date + sta_tim_sch)::timestamp,
        ('2000-01-01'::date + fin_hou_sch)::timestamp
    ) with &&
);