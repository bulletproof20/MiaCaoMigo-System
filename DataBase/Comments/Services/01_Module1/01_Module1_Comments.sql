-- =========================================================
-- comments: services — module 1 (user management)
-- =========================================================

-- identity
comment on function fn_is_employee_email(character varying) is
'Returns true when the email belongs to the corporate @miacaomigo.pt domain (employee channel).';

comment on function fn_get_user_by_email(character varying) is
'Resolves id_usr from employee.ema_emp or user_account.ema_usr after normalization.';

comment on function fn_get_user_by_nif(character varying) is
'Returns id_usr for a personal NIF on user_account, or null when not found.';

comment on function fn_get_user_by_employee(integer) is
'Returns id_usr linked to a specific employee row.';

comment on function fn_get_user_by_client(integer) is
'Returns id_usr linked to a specific client row.';

comment on function fn_get_active_employee_by_user(integer) is
'Returns the active id_emp (dea_dat_emp is null) for a user, or null.';

comment on function fn_get_client_by_user(integer) is
'Returns id_cli for a user when a client profile exists.';

comment on function fn_user_exists_by_email(character varying) is
'True when email exists on an active employee or any user_account personal email.';

comment on function fn_user_exists_by_nif(character varying) is
'True when a user_account row exists for the given NIF.';

comment on function fn_client_exists(integer) is
'True when the user already has a client record.';

comment on function fn_has_active_employee(integer) is
'True when the user has at least one employee row with dea_dat_emp null.';

comment on function fn_is_veterinarian(integer) is
'True when the employee id exists in veterinarian.';

comment on function fn_is_assistant(integer) is
'True when the employee id exists in assistant.';

-- validations
comment on function fn_is_account_active(character varying) is
'True for active employees (dea_dat_emp null) or active clients (ina_dat_cli null).';

comment on function validate_password(character varying, character varying) is
'Compares API-supplied bcrypt hash against stored pas_emp or pas_cli for the resolved email channel.';

-- authentication
comment on function has_active_sessions(character varying) is
'True when login_record has an open successful session for the normalized email (ema_log).';

comment on function close_active_sessions_by_email(character varying) is
'Sets sou_tim_log on all open successful sessions for the given email.';

comment on function login_user(character varying, character varying, inet) is
'Authenticates by email and API-supplied password hash; enforces single session; audits login_record.';

comment on function logout_user(character varying) is
'Closes the active successful session for the email; returns false when none exists.';

comment on function get_user_credentials(integer) is
'Read-only: email and stored password hash for employee or client channel (integration helper).';

-- user creation
comment on function fn_create_user_account(character varying, text, character varying, character varying, character varying, character varying) is
'Inserts user_account; setup row is created by trigger. Shared base for all creation flows.';

comment on function fn_assign_profile(integer, integer) is
'Links an employee to an RBAC profile via occupies.';

comment on function fn_create_client(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying) is
'Creates or extends client identity; may reuse existing user_account by NIF/email rules.';

comment on function fn_create_employee(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer) is
'Creates employee with corporate email; registers aut_reg_emp from the acting employee id.';

comment on function fn_create_assistant(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying) is
'Creates employee plus assistant role row (fun_ass).';

comment on function fn_create_veterinarian(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying) is
'Creates employee plus veterinarian role row (num_omv_vet).';

-- role change
comment on function fn_renew_employee_record(integer, integer) is
'Inactivates the latest employee row and inserts a successor; used by role transitions.';

comment on function fn_alter_employee_to_veterinarian(integer, character varying, integer) is
'Renews employment and attaches veterinarian role to the new id_emp.';

comment on function fn_alter_employee_to_assistant(integer, character varying, integer) is
'Renews employment and attaches assistant role to the new id_emp.';

comment on function fn_alter_employee_to_general(integer, integer) is
'Renews employment without role extension; demotes vet/assistant to general staff.';

-- attendance
comment on function fn_clock_employee(integer) is
'Toggles clock-in/out using vw_open_clock_in_sessions; returns CLOCK_IN or CLOCK_OUT.';

comment on function fn_replicate_previous_schedule(integer) is
'Copies schedule rows from the latest inactive employee that had shifts onto the target.';
