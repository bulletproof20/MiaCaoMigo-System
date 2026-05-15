--=========================================================
-- MODULE 1: USER MANAGEMENT
--=========================================================

--=========================================================
-- DESCRIPTION
--=========================================================
-- This module defines the structure responsible for user management.
-- It includes user data, authentication, roles, permissions,
-- and operational records associated with system usage.
--
-- Foreign keys are applied in 01_ForeignKeys_Mod1.sql (after all
-- module tables are created) to simplify init order and dependency control.



--=========================================================
-- 1. USER_ACCOUNT
--=========================================================
-- Stores general personal data of any system user
create table user_account (
    id_usr int generated always as identity,
    -- Unique user identifier

    nam_usr varchar(250) not null,
    -- Full name

    add_usr text not null,
    -- Address

    pos_usr varchar(8) not null,
    -- Postal code

    nif_usr varchar(9) not null,
    -- Tax number

    pho_usr varchar(16) null,
    -- Phone number

    ema_usr varchar(255) not null,
    -- Email address

    constraint pk_user_account primary key (id_usr),
    -- Ensures unique identification

    constraint uq_ema_usr unique (ema_usr),
    -- Prevents duplicated emails

    constraint ck_nam_usr_format
    check (nam_usr ~ '^[A-Za-zÀ-ÿ\s''-]+$'
    and length(trim(nam_usr)) > 3
    ),
    -- Validates name format

    constraint ck_nif_usr_format
    check (nif_usr ~ '^[0-9]{9}$'),
    -- Validates tax number

    constraint uq_nif_usr unique(nif_usr),
    -- Unique NIF

    constraint ck_add_usr_format
    check(length(trim(add_usr)) > 3),
    -- Validades address format

    constraint ck_pos_usr_format
    check (pos_usr ~ '^[0-9]{4}-[0-9]{3}$'),
    -- Validates postal code

    constraint ck_pho_usr_format
    check (pho_usr is null or pho_usr ~ '^\+[1-9][0-9]{7,14}$'),
    -- Validates phone format

    constraint ck_ema_usr_format
	check (
	    ema_usr = lower(trim(ema_usr))
	    and ema_usr ~ '.+@.+\..+'
	    and ema_usr !~ '@miacaomigo\.pt$'
	)
	-- Validates email format and normalization
	-- and excludes corporate domain @miacaomigo.pt
);


--=========================================================
-- 2. PROFILE
--=========================================================
-- Defines user roles within the system
create table profile (
    id_pro int generated always as identity,
    -- Profile identifier

    nam_pro varchar(100) not null,
    -- Profile name

    des_pro text not null,
    -- Description

    constraint pk_profile primary key (id_pro),
    -- Unique identifier

    constraint uq_nam_pro unique (nam_pro),
    -- Prevents duplicate profiles

    constraint ck_nam_pro_format
    check (
        nam_pro = lower(trim(nam_pro))
        and length(nam_pro) > 3
        and nam_pro ~ '^[a-zà-ÿ\s]+$'
    )
);

--=========================================================
-- 3. PERMISSION
--=========================================================
-- Defines granular access permissions
create table permission (
    id_per int generated always as identity,
    -- Permission identifier

    nam_per varchar(100) not null,
    -- Permission name

    des_per text,
    -- Description

    constraint pk_permission primary key (id_per),
    -- Unique identifier

    constraint uq_nam_per unique (nam_per),
    -- Prevents duplicates

    constraint ck_nam_per_format
    check (
        nam_per = lower(trim(nam_per))
        and length(nam_per) > 3
        and nam_per ~ '^[a-z0-9_.]+$'
    )
);

--=========================================================
-- 4. SPECIALTY
--=========================================================
-- Defines veterinary/Appointment specialties
create table specialty (
    id_spe int generated always as identity,
    -- Specialty identifier

    nam_spe varchar(100) not null,
    -- Name

    des_spe text not null,
    -- Description

    constraint pk_specialty primary key (id_spe),
    -- Unique identifier

    constraint uq_nam_spe unique (nam_spe),
    -- Prevents duplicates

    constraint ck_nam_spe_format
    check (
        nam_spe = lower(trim(nam_spe))
        and length(trim(nam_spe)) >= 5
    ),

    constraint ck_des_spe_format
    check (
        des_spe = trim(des_spe)
        and length(trim(des_spe)) >= 5
    )
);

--=========================================================
-- 5. EMPLOYEE
--=========================================================
-- Represents system employees
create table employee (
    id_emp int generated always as identity,
    -- Employee identifier

    id_usr int not null,
    -- Associated user

    reg_dat_emp timestamp default current_timestamp not null,
    -- Registration date (cannot be in the future)

    aut_reg_emp int,
    -- Created by employee

    dea_dat_emp timestamp,
    -- Deactivation date

    aut_ina_emp int,
    -- Deactivated by employee

    pho_emp varchar(16),
    -- Professional phone

    pho_emg varchar(16) null,
    -- Emergency phone

    ema_emp varchar(255) not null,
    -- Professional email (must be corporate)

    pas_emp varchar(255) not null,
    -- Password hash

    constraint pk_employee primary key (id_emp),
    -- Unique identifier

    constraint uq_ema_emp unique (ema_emp),
    -- Prevents duplicate professional emails

    constraint ck_ema_emp_format
    check (
        ema_emp = lower(trim(ema_emp))
        and ema_emp ~ '^[^@\s]+@miacaomigo\.pt$'
    ),
    -- Ensures corporate email format and normalization

    constraint ck_pho_emp_format
    check (
        pho_emp is null 
        or pho_emp ~ '^\+[1-9][0-9]{7,14}$'
    ),
    -- Validates professional phone format (E.164)

    constraint ck_pho_emg_format
    check (
        pho_emg is null 
        or pho_emg ~ '^\+[1-9][0-9]{7,14}$'
    ),
    -- Validates emergency phone format (E.164)

    constraint ck_pas_emp_format
    check (length(trim(pas_emp)) >= 16),
    -- Ensures password hash is not trivial/invalid

    constraint ck_employee_dates
    check (
        -- Registration cannot be in the future
        reg_dat_emp <= current_timestamp
        and
        -- Deactivation must be valid if present
        (
            dea_dat_emp is null 
            or (
                dea_dat_emp >= reg_dat_emp
                and dea_dat_emp <= current_timestamp
            )
        )
    ),
    -- Ensures temporal consistency of employee lifecycle

    constraint ck_employee_inactivation
    check (
        (dea_dat_emp is null and aut_ina_emp is null)
        or
        (dea_dat_emp is not null and aut_ina_emp is not null)
    )
    -- Ensures deactivation always has both date and responsible
);

--=========================================================
-- 6. ASSISTANT
--=========================================================
-- Represents assistant employees
create table assistant (
    id_emp int,
    -- Employee

    fun_ass varchar(100) not null,
    -- Function/role

    constraint pk_assistant primary key (id_emp)
    -- One-to-one with employee
);

--=========================================================
-- 7. VETERINARIAN
--=========================================================
-- Represents veterinarian employees
create table veterinarian (
    id_emp int not null,
    -- Employee (inherits from employee)

    num_omv_vet varchar(50) not null,
    -- Professional registration number (OMV)

    constraint pk_veterinarian primary key (id_emp),
    -- One-to-one with employee

    constraint uq_num_omv_vet unique (num_omv_vet),
    -- Prevents duplicate professional registrations

    constraint ck_num_omv_vet_format
    check (
        num_omv_vet = trim(num_omv_vet)
        and length(num_omv_vet) > 3
    )
    -- Ensures registration number is not empty or invalid
);

--=========================================================
-- 8. EXPERT
--=========================================================
-- Associates veterinarians with specialties (many-to-many)
create table expert (
    id_emp int not null,
    -- Veterinarian employee identifier

    id_spe int not null,
    -- Specialty identifier

    constraint pk_expert primary key (id_emp, id_spe)
    -- Composite unique assignment per veterinarian and specialty
);

--=========================================================
-- 9. CLIENT
--=========================================================
-- Represents system clients.
-- Identity: surrogate PK id_cli (referenced by other modules).
-- Cardinality: exactly one client row per user_account via UNIQUE(id_usr) + FK to user_account.
create table client (
    id_cli int generated always as identity,
    -- Client identifier

    id_usr int not null,
    -- Associated user

    pas_cli varchar(255) not null,
    -- Password hash

    reg_dat_cli timestamp default current_timestamp not null,
    -- Registration date (cannot be in the future)

    ina_dat_cli timestamp,
    -- Inactivation date

    constraint pk_client primary key (id_cli),
    -- Unique identifier

    constraint uq_client_user
        unique (id_usr),
    -- Unique identifier for user association (one-to-one)

    constraint ck_pas_cli_format
    check (length(trim(pas_cli)) >= 16),
    -- Ensures password hash is not trivial/invalid

    constraint ck_client_dates
    check (
        -- Registration cannot be in the future
        reg_dat_cli <= current_timestamp

        and

        -- Inactivation must be valid if present
        (
            ina_dat_cli is null 
            or (
                ina_dat_cli >= reg_dat_cli
                and ina_dat_cli <= current_timestamp
            )
        )
    )
    -- Ensures temporal consistency of client lifecycle
);

--=========================================================
-- 9. LOGIN_RECORD
--=========================================================
-- Stores authentication attempts and session tracking

create table login_record (

    id_log int generated always as identity,
    -- Log identifier

    sig_tim_log timestamp not null default current_timestamp,
    -- Login timestamp (cannot be in the future)

    sou_tim_log timestamp,
    -- Logout timestamp

    suc_log boolean not null,
    -- Success flag

    ip_add_log inet,
    -- IP address (IPv4/IPv6)

    ema_log varchar(255),
    -- Email snapshot (even if user does not exist)

    id_usr int,
    -- User reference (nullable for failed attempts)

    constraint pk_login_record primary key (id_log),

    constraint ck_login_time
    check (
        -- Login cannot be in the future
        sig_tim_log <= current_timestamp

        and

        -- Logout must be after login and not in the future
        (
            sou_tim_log is null 
            or (
                sou_tim_log > sig_tim_log
                and sou_tim_log <= current_timestamp
            )
        )
    ),
    -- Ensures temporal consistency of login session

    check (
        suc_log = false
        or (
            id_usr is not null
            and ema_log is not null
            and ip_add_log is not null
            and sig_tim_log is not null
            and ip_add_log is not null
        )
    ),
    -- Ensures login sucess consistency

    constraint ck_ema_log_format
    check (
        ema_log is null
        or (
            ema_log = lower(trim(ema_log))
            and ema_log ~ '.+@.+\..+'
        )
    )
    -- Validates email snapshot format (if provided)
);

--=========================================================
-- 10. SCHEDULE
--=========================================================
-- Defines weekly working schedules for employees

create table schedule (
    id_emp int not null,
    -- Employee

    day_wee_sch int not null,
    -- Day of week (1–7)

    sta_tim_sch time not null,
    -- Start time

    fin_hou_sch time not null,
    -- End time

    constraint pk_schedule primary key (id_emp, day_wee_sch, sta_tim_sch),
    -- Composite identifier

    constraint ck_schedule_day
    check (day_wee_sch between 1 and 7),
    -- Ensures valid weekday

    constraint ck_schedule_time
    check (
        sta_tim_sch < fin_hou_sch
        and sta_tim_sch >= time '00:00:00'
        and fin_hou_sch <= time '23:59:59'
    )
    -- Validates time interval within a day
);


--=========================================================
-- 11. ABSENCE
--=========================================================
-- Stores employee absences over time

create table absence (
    id_abs int generated always as identity,
    -- Absence identifier

    id_emp int not null,
    -- Employee

    sta_dat_tim_abs timestamp not null,
    -- Start datetime

    end_dat_tim_abs timestamp not null,
    -- End datetime

    mot_abs varchar(50) not null,
    -- Reason (no_show, justified, etc.)

    sta_abs varchar(20) not null default 'pending',
    -- State (approved, rejected, pending, canceled, detected)

    res_abs int,
    -- Responsible (NULL = system)

    cre_tim_abs timestamp not null default current_timestamp,
    -- Creation timestamp

    constraint pk_absence primary key (id_abs),
    -- Unique identifier

    constraint ck_absence_time
    check (
        sta_dat_tim_abs < end_dat_tim_abs
        -- Start must be before end
    ),

    constraint ck_mot_abs_format
    check (
        mot_abs = lower(trim(mot_abs))
        and length(mot_abs) > 2 
    ),
    -- Prevents empty or meaningless reasons

    constraint ck_sta_abs
    check (
        sta_abs in ('pending','approved','rejected', 'cancelled', 'detected')
    )
    -- Restricts valid states
);


--=========================================================
-- 12. CLOCK_IN
--=========================================================
-- Stores employee attendance (entry and exit records)

create table clock_in (
    id_clk int generated always as identity,
    -- Record identifier

    id_emp int not null,
    -- Employee

    sta_dat_clk timestamp not null,
    -- Entry time

    end_dat_clk timestamp,
    -- Exit time

    constraint pk_clock_in primary key (id_clk),
    -- Unique identifier

    constraint ck_clock_time
    check (
        -- Entry cannot be in the future
        sta_dat_clk <= current_timestamp
        and
        -- Exit must be after entry and not in the future
        (
            end_dat_clk is null
            or (
                end_dat_clk > sta_dat_clk
                and end_dat_clk <= current_timestamp
            )
        )
    )
    -- Ensures valid attendance interval
);

--=========================================================
-- 13. SETUP
--=========================================================
-- Stores user preferences and configuration

create table setup (
    id_usr int,
    -- User

    the_set varchar(20) not null default 'light',
    -- Theme (default: light)

    lan_set varchar(20) not null default 'pt-pt',
    -- Language (default: pt-pt)

    constraint pk_setup primary key (id_usr),
    -- One-to-one relation with user

    constraint ck_the_set_format
    check (
        the_set = lower(trim(the_set))
        and the_set in ('light', 'dark')
    ),
    -- Restricts theme to valid values

    constraint ck_lan_set_format 
    check (
        lan_set = lower(trim(lan_set))
        and lan_set ~ '^[a-z]{2}-[a-z]{2}$'
    )
    -- Validates language format (e.g., pt-pt, en-us)
);


--=========================================================
-- 14. OCCUPIES
--=========================================================
-- Associates employees with profiles (roles)

create table occupies (
    id_emp int not null,
    -- Employee

    id_pro int not null,
    -- Profile

    constraint pk_occupies primary key (id_emp, id_pro)
    -- Composite identifier (prevents duplicates)
);


--=========================================================
-- 15. HAVE
--=========================================================
-- Associates profiles with permissions (access control)

create table have (
    id_pro int not null,
    -- Profile

    id_per int not null,
    -- Permission

    constraint pk_have primary key (id_pro, id_per)
    -- Composite identifier (prevents duplicates)
);
