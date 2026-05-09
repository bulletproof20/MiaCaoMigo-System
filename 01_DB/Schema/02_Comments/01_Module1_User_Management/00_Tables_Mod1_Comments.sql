--=========================================================
-- 1. user_account
--=========================================================

comment on table user_account is
'stores general personal, contact, and identification data for all system users';

comment on column user_account.id_usr is
'unique identifier of the user account';
 
comment on column user_account.nam_usr is
'full legal name of the user';

comment on column user_account.add_usr is
'residential or registered address of the user';

comment on column user_account.pos_usr is
'postal code formatted as xxxx-xxx';

comment on column user_account.nif_usr is
'portuguese tax identification number';

comment on column user_account.pho_usr is
'personal phone number stored in international format';

comment on column user_account.ema_usr is
'personal normalized email address excluding corporate domains';

comment on constraint pk_user_account on user_account is
'ensures unique identification of each user';

comment on constraint uq_ema_usr on user_account is
'prevents duplicated personal email addresses';

comment on constraint chk_nam_usr_format on user_account is
'validates legal name format and minimum length';

comment on constraint chk_nif_usr_format on user_account is
'validates portuguese tax number numeric format';

comment on constraint uq_nif_usr on user_account is
'ensures tax identification uniqueness';

comment on constraint chk_add_usr_format on user_account is
'validates minimum address length';

comment on constraint chk_pos_usr_format on user_account is
'validates postal code structure';

comment on constraint chk_pho_usr_format on user_account is
'validates international phone number format';

comment on constraint chk_ema_usr_format on user_account is
'validates normalized email structure and blocks corporate domain usage';


--=========================================================
-- 2. profile
--=========================================================

comment on table profile is
'defines operational roles and access profiles within the system';

comment on column profile.id_pro is
'unique profile identifier';

comment on column profile.nam_pro is
'normalized profile name';

comment on column profile.des_pro is
'description of profile responsibilities and purpose';

comment on constraint pk_profile on profile is
'ensures unique identification of each profile';

comment on constraint uq_nam_pro on profile is
'prevents duplicated profile names';

comment on constraint chk_nam_pro_format on profile is
'validates normalized profile naming convention';


--=========================================================
-- 3. permission
--=========================================================

comment on table permission is
'defines granular permissions used for access control';

comment on column permission.id_per is
'unique permission identifier';

comment on column permission.nam_per is
'normalized permission name';

comment on column permission.des_per is
'description of the permission purpose';

comment on constraint pk_permission on permission is
'ensures unique identification of each permission';

comment on constraint uq_nam_per on permission is
'prevents duplicated permission names';

comment on constraint chk_nam_per_format on permission is
'validates permission naming convention and normalization';


--=========================================================
-- 4. specialty
--=========================================================

comment on table specialty is
'defines veterinary and operational specialties';

comment on column specialty.id_spe is
'unique specialty identifier';

comment on column specialty.nam_spe is
'name of the specialty';

comment on column specialty.des_spe is
'description of specialty scope and responsibilities (required)';

comment on constraint pk_specialty on specialty is
'ensures unique identification of each specialty';

comment on constraint uq_nam_spe on specialty is
'prevents duplicated specialty names';

comment on constraint chk_nam_spe_format on specialty is
'validates specialty naming format';

comment on constraint chk_des_spe_format on specialty is
'prevents invalid specialty descriptions (non-empty and minimum length)';


--=========================================================
-- 5. employee
--=========================================================

comment on table employee is
'stores operational employee authentication and lifecycle information';

comment on column employee.id_emp is
'unique employee identifier';

comment on column employee.id_usr is
'reference to associated user account';

comment on column employee.reg_dat_emp is
'employee registration timestamp';

comment on column employee.aut_reg_emp is
'employee responsible for registration';

comment on column employee.dea_dat_emp is
'employee deactivation timestamp';

comment on column employee.aut_ina_emp is
'employee responsible for deactivation';

comment on column employee.pho_emp is
'professional contact phone number';

comment on column employee.pho_emg is
'emergency contact phone number';

comment on column employee.ema_emp is
'corporate normalized email address';

comment on column employee.pas_emp is
'hashed employee authentication password';

comment on constraint pk_employee on employee is
'ensures unique identification of each employee';

comment on constraint uq_ema_emp on employee is
'prevents duplicated professional email addresses';

comment on constraint chk_ema_emp_format on employee is
'validates corporate email normalization and domain';

comment on constraint chk_pho_emp_format on employee is
'validates professional phone number format';

comment on constraint chk_pho_emg_format on employee is
'validates emergency phone number format';

comment on constraint chk_pas_emp_format on employee is
'ensures password hash minimum integrity requirements';

comment on constraint fk_employee_user on employee is
'links employee to base user account';

comment on constraint fk_employee_aut_reg on employee is
'tracks employee responsible for registration';

comment on constraint fk_employee_aut_ina on employee is
'tracks employee responsible for deactivation';

comment on constraint chk_employee_dates on employee is
'ensures valid temporal lifecycle consistency';

comment on constraint chk_employee_inactivation on employee is
'ensures deactivation requires responsible employee and timestamp';


--=========================================================
-- 6. assistant
--=========================================================

comment on table assistant is
'defines assistant employees and their operational functions';

comment on column assistant.id_emp is
'reference to employee entity';

comment on column assistant.fun_ass is
'operational function or assistant role';

comment on constraint pk_assistant on assistant is
'ensures one-to-one relation with employee';

comment on constraint fk_assistant_employee on assistant is
'links assistant specialization to employee';


--=========================================================
-- 7. veterinarian
--=========================================================

comment on table veterinarian is
'defines veterinarian employees and professional specialization';

comment on column veterinarian.id_emp is
'reference to employee entity';

comment on column veterinarian.num_omv_vet is
'official veterinarian professional registration number';

comment on constraint pk_veterinarian on veterinarian is
'ensures one-to-one relation with employee';

comment on constraint fk_veterinarian_employee on veterinarian is
'links veterinarian specialization to employee';

comment on constraint uq_num_omv_vet on veterinarian is
'prevents duplicated veterinarian registrations';

comment on constraint chk_num_omv_vet_format on veterinarian is
'validates veterinarian registration integrity';


--=========================================================
-- 8. expert
--=========================================================

comment on table expert is
'associates veterinarians with one or more specialties';

comment on column expert.id_emp is
'reference to veterinarian employee entity';

comment on column expert.id_spe is
'reference to specialty entity';

comment on constraint pk_expert on expert is
'ensures unique veterinarian-specialty assignment';

comment on constraint fk_expert_veterinarian on expert is
'links specialization assignment to a valid veterinarian';

comment on constraint fk_expert_specialty on expert is
'links specialization assignment to a valid specialty';


--=========================================================
-- 9. client
--=========================================================

comment on table client is
'stores client authentication and operational lifecycle information';

comment on column client.id_cli is
'unique client identifier';

comment on column client.id_usr is
'reference to associated user account';

comment on column client.pas_cli is
'hashed client authentication password';

comment on column client.reg_dat_cli is
'client registration timestamp';

comment on column client.ina_dat_cli is
'client inactivation timestamp';

comment on constraint pk_client on client is
'ensures unique identification of each client';

comment on constraint fk_client_user on client is
'links client to base user account';

comment on constraint chk_pas_cli_format on client is
'ensures password hash minimum integrity requirements';

comment on constraint chk_client_dates on client is
'ensures temporal consistency of client lifecycle';

--=========================================================
-- 9. login_record
--=========================================================

comment on table login_record is
'stores authentication attempts, session lifecycle, and login audit history';

comment on column login_record.id_log is
'unique login record identifier';

comment on column login_record.sig_tim_log is
'login/sign-in timestamp';

comment on column login_record.sou_tim_log is
'logout/sign-out timestamp';

comment on column login_record.suc_log is
'indicates whether authentication was successful';

comment on column login_record.ip_add_log is
'ip address used during authentication attempt';

comment on column login_record.eml_usr is
'email snapshot used during authentication attempt';

comment on column login_record.id_usr is
'reference to associated user account when applicable';

comment on constraint pk_login_record on login_record is
'ensures unique identification of each login record';

comment on constraint chk_login_time on login_record is
'ensures temporal consistency of authentication sessions';

comment on constraint chk_login_email_format on login_record is
'validates normalized email snapshot format';

comment on constraint fk_login_record_user on login_record is
'links authentication record to user account';


--=========================================================
-- 10. schedule
--=========================================================

comment on table schedule is
'defines recurring weekly operational schedules for employees';

comment on column schedule.id_emp is
'reference to employee entity';

comment on column schedule.day_wee_sch is
'day of the week associated with the schedule entry';

comment on column schedule.sta_tim_sch is
'schedule start time';

comment on column schedule.fin_hou_sch is
'schedule end time';

comment on constraint pk_schedule on schedule is
'ensures unique schedule interval per employee';

comment on constraint chk_schedule_day on schedule is
'validates allowed weekday range';

comment on constraint chk_schedule_time on schedule is
'validates schedule temporal interval consistency';

comment on constraint fk_schedule_employee on schedule is
'links schedule entry to employee';


--=========================================================
-- 11. absence
--=========================================================

comment on table absence is
'stores employee absences, operational interruptions, and approval lifecycle';

comment on column absence.id_abs is
'unique absence identifier';

comment on column absence.id_emp is
'reference to employee entity';

comment on column absence.sta_dat_tim_abs is
'absence start timestamp';

comment on column absence.end_dat_tim_abs is
'absence end timestamp';

comment on column absence.mot_abs is
'normalized absence reason';

comment on column absence.sta_abs is
'current operational absence state';

comment on column absence.res_abs is
'employee responsible for absence validation or resolution';

comment on column absence.cre_tim_abs is
'absence creation timestamp';

comment on constraint pk_absence on absence is
'ensures unique identification of each absence';

comment on constraint chk_absence_time on absence is
'ensures absence temporal interval consistency';

comment on constraint chk_mot_abs_format on absence is
'validates normalized absence reason format';

comment on constraint chk_sta_abs on absence is
'restricts allowed operational absence states';

comment on constraint fk_absence_employee on absence is
'links absence to employee';

comment on constraint fk_absence_responsible on absence is
'tracks responsible employee for absence processing';


--=========================================================
-- 12. clock_in
--=========================================================

comment on table clock_in is
'stores employee attendance intervals and operational presence records';

comment on column clock_in.id_clk is
'unique attendance record identifier';

comment on column clock_in.id_emp is
'reference to employee entity';

comment on column clock_in.sta_dat_clk is
'attendance start timestamp';

comment on column clock_in.end_dat_clk is
'attendance end timestamp';

comment on constraint pk_clock_in on clock_in is
'ensures unique identification of each attendance record';

comment on constraint chk_clock_time on clock_in is
'ensures temporal consistency of attendance intervals';

comment on constraint fk_clock_employee on clock_in is
'links attendance record to employee';


--=========================================================
-- 13. setup
--=========================================================

comment on table setup is
'stores user interface preferences and operational configuration settings';

comment on column setup.id_usr is
'reference to associated user account';

comment on column setup.the_set is
'user interface theme preference';

comment on column setup.lan_set is
'user interface language preference';

comment on constraint pk_setup on setup is
'ensures one-to-one relation between setup and user account';

comment on constraint fk_setup_user on setup is
'links setup preferences to user account';

comment on constraint chk_the_set_format on setup is
'validates allowed interface theme values';

comment on constraint chk_lan_set_format on setup is
'validates normalized language code structure';


--=========================================================
-- 14. occupies
--=========================================================

comment on table occupies is
'associates employees with operational access profiles';

comment on column occupies.id_emp is
'reference to employee entity';

comment on column occupies.id_pro is
'reference to profile entity';

comment on constraint pk_occupies on occupies is
'ensures unique employee-profile association';

comment on constraint fk_occ_employee on occupies is
'links association to employee';

comment on constraint fk_occ_profile on occupies is
'links association to profile';


--=========================================================
-- 15. have
--=========================================================

comment on table have is
'associates profiles with granular operational permissions';

comment on column have.id_pro is
'reference to profile entity';

comment on column have.id_per is
'reference to permission entity';

comment on constraint pk_have on have is
'ensures unique profile-permission association';

comment on constraint fk_have_profile on have is
'links permission association to profile';

comment on constraint fk_have_permission on have is
'links permission association to permission';