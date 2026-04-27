-- Login Record table

-- unique session per email address (app_acess)
create unique index uq_login_single_active_session_email
on login_record(eml_usr)
where sou_tim_log is null 
  and suc_log = true
  and eml_usr is not null;

-- unique active register per user (employee)
create unique index uq_employee_active_per_user
on employee(id_usr)
where dea_dat_emp is null;

-- unique clock-in without end time per employee
create unique index uq_clock_in_active_per_employee
on clock_in(id_emp)
where end_dat_clk is null;

