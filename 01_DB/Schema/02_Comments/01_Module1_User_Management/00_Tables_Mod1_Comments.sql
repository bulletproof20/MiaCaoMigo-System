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
'description of specialty scope and responsibilities';

comment on constraint pk_specialty on specialty is
'ensures unique identification of each specialty';

comment on constraint uq_nam_spe on specialty is
'prevents duplicated specialty names';

comment on constraint chk_nam_spe_format on specialty is
'validates specialty naming format';

comment on constraint chk_des_spe_format on specialty is
'validates minimum description length when provided';


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

comment on column veterinarian.id_spe is
'associated veterinary specialty';

comment on constraint pk_veterinarian on veterinarian is
'ensures one-to-one relation with employee';

comment on constraint fk_veterinarian_employee on veterinarian is
'links veterinarian specialization to employee';

comment on constraint fk_veterinarian_specialty on veterinarian is
'links veterinarian to specialty';

comment on constraint uq_num_omv_vet on veterinarian is
'prevents duplicated veterinarian registrations';

comment on constraint chk_num_omv_vet_format on veterinarian is
'validates veterinarian registration integrity';


--=========================================================
-- 8. client
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