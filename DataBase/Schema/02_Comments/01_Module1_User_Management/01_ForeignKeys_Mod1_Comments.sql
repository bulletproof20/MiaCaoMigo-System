--=========================================================
-- MODULE 1 — metadata: foreign keys
--=========================================================
-- Declarative FKs are defined in 01_ForeignKeys_Mod1.sql
-- (post-table phase) for uniform init ordering.
--=========================================================

comment on constraint fk_employee_user on employee is
'links each employee row to exactly one user_account';

comment on constraint fk_employee_aut_reg on employee is
'optional employee who registered this employee record';

comment on constraint fk_employee_aut_ina on employee is
'optional employee who authorized deactivation';

comment on constraint fk_assistant_employee on assistant is
'assistant specialization row references base employee';

comment on constraint fk_veterinarian_employee on veterinarian is
'veterinarian specialization row references base employee';

comment on constraint fk_expert_veterinarian on expert is
'specialty assignment belongs to a veterinarian employee';

comment on constraint fk_expert_specialty on expert is
'specialty assignment references specialty catalog';

comment on constraint fk_client_user on client is
'each client profile links to one user_account (1:1 via unique id_usr)';

comment on constraint fk_login_record_user on login_record is
'optional user reference for successful or tracked authentication rows';

comment on constraint fk_setup_user on setup is
'user preferences keyed by user_account';

comment on constraint fk_schedule_employee on schedule is
'weekly schedule belongs to one employee';

comment on constraint fk_absence_employee on absence is
'absence interval belongs to one employee';

comment on constraint fk_absence_responsible on absence is
'employee who approved or owns the absence decision';

comment on constraint fk_clock_employee on clock_in is
'attendance record belongs to one employee';

comment on constraint fk_occ_employee on occupies is
'RBAC: employee assigned to profile';

comment on constraint fk_occ_profile on occupies is
'RBAC: profile assigned to employee';

comment on constraint fk_have_profile on have is
'RBAC: profile grants permission set membership';

comment on constraint fk_have_permission on have is
'RBAC: permission granted through profile';
