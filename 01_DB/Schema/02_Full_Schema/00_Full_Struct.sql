
drop schema if exists public cascade;
create schema if not exists public;


--=========================================================
-- MODULE 1: USER MANAGEMENT
--=========================================================

--=========================================================
-- DESCRIPTION
--=========================================================
-- This module defines the structure responsible for user management.
-- It includes user data, authentication, roles, permissions,
-- and operational records associated with system usage.

--=========================================================
-- 0. CLEANUP
--=========================================================
-- Drops only tables related to this module in reverse dependency order

-- Associative tables
drop table if exists have cascade;
drop table if exists occupies cascade;

-- Dependent entities
drop table if exists assistant cascade;
drop table if exists veterinarian cascade;
drop table if exists schedule cascade;
drop table if exists absence cascade;
drop table if exists clock_in cascade;
drop table if exists setup cascade;
drop table if exists login_record cascade;

-- Core entities
drop table if exists employee cascade;
drop table if exists client cascade;
drop table if exists profile cascade;
drop table if exists permission cascade;
drop table if exists specialty cascade;

-- Base entity
drop table if exists user_account cascade;

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

    constraint chk_nam_usr_format
    check (nam_usr ~ '^[A-Za-zÀ-ÿ\s''-]+$'
    and length(trim(nam_usr)) > 3
    ),
    -- Validates name format

    constraint chk_nif_usr_format
    check (nif_usr ~ '^[0-9]{9}$'),
    -- Validates tax number

    constraint uq_nif_usr unique(nif_usr),
    -- Unique NIF

    constraint chk_add_usr_format
    check(length(trim(add_usr)) > 3),
    -- Validades address format

    constraint chk_pos_usr_format
    check (pos_usr ~ '^[0-9]{4}-[0-9]{3}$'),
    -- Validates postal code

    constraint chk_pho_usr_format
    check (pho_usr is null or pho_usr ~ '^\+[1-9][0-9]{7,14}$'),
    -- Validates phone format

    constraint chk_ema_usr_format
	check (
	    ema_usr = lower(trim(ema_usr))
	    and ema_usr ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'
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

    constraint chk_nam_pro_format
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

    constraint chk_nam_per_format
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

    des_spe text,
    -- Description

    constraint pk_specialty primary key (id_spe),
    -- Unique identifier

    constraint uq_nam_spe unique (nam_spe),
    -- Prevents duplicates

    constraint chk_nam_spe_format
    check (
        nam_spe = trim(nam_spe)
        and length(nam_spe) > 3
        and nam_spe ~ '^[A-Za-zÀ-ÿ\s]+$'
    ),

    constraint chk_des_spe_format
    check (
        des_spe is null 
        or length(trim(des_spe)) > 5
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

    constraint chk_ema_emp_format
    check (
        ema_emp = lower(trim(ema_emp))
        and ema_emp ~ '^[^@\s]+@miacaomigo\.pt$'
    ),
    -- Ensures corporate email format and normalization

    constraint chk_pho_emp_format
    check (
        pho_emp is null 
        or pho_emp ~ '^\+[1-9][0-9]{7,14}$'
    ),
    -- Validates professional phone format (E.164)

    constraint chk_pho_emg_format
    check (
        pho_emg is null 
        or pho_emg ~ '^\+[1-9][0-9]{7,14}$'
    ),
    -- Validates emergency phone format (E.164)

    constraint chk_pas_emp_format
    check (length(trim(pas_emp)) >= 20),
    -- Ensures password hash is not trivial/invalid

    constraint fk_employee_user 
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade,
    -- Links employee to user

    constraint fk_employee_aut_reg 
        foreign key (aut_reg_emp)
        references employee(id_emp)
        on delete set null,
    -- Tracks creator

    constraint fk_employee_aut_ina 
        foreign key (aut_ina_emp)
        references employee(id_emp)
        on delete set null,
    -- Tracks deactivator

    constraint chk_employee_dates
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

    constraint chk_employee_inactivation
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

    constraint pk_assistant primary key (id_emp),
    -- One-to-one with employee

    constraint fk_assistant_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade
    -- Links to employee
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

    id_spe int null,
    -- Specialty

    constraint pk_veterinarian primary key (id_emp),
    -- One-to-one with employee

    constraint fk_veterinarian_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,
    -- Links to employee

    constraint fk_veterinarian_specialty 
        foreign key (id_spe)
        references specialty(id_spe)
        on delete set null,
    -- Links to specialty

    constraint uq_num_omv_vet unique (num_omv_vet),
    -- Prevents duplicate professional registrations

    constraint chk_num_omv_vet_format
    check (
        num_omv_vet = trim(num_omv_vet)
        and length(num_omv_vet) > 3
    )
    -- Ensures registration number is not empty or invalid
);

--=========================================================
-- 8. CLIENT
--=========================================================
-- Represents system clients
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

    constraint fk_client_user 
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade,
    -- Links client to user

    constraint chk_pas_cli_format
    check (length(trim(pas_cli)) >= 20),
    -- Ensures password hash is not trivial/invalid

    constraint chk_client_dates
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

    eml_usr varchar(255),
    -- Email snapshot (even if user does not exist)

    id_usr int,
    -- User reference (nullable for failed attempts)

    constraint pk_login_record primary key (id_log),

    constraint chk_login_time
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

    constraint chk_login_email_format
    check (
        eml_usr is null
        or (
            eml_usr = lower(trim(eml_usr))
            and eml_usr ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$'
        )
    ),
    -- Validates email snapshot format (if provided)

    constraint fk_login_record_user 
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade
    -- Links log to user (if exists)
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

    constraint chk_schedule_day
    check (day_wee_sch between 1 and 7),
    -- Ensures valid weekday

    constraint chk_schedule_time
    check (
        sta_tim_sch < fin_hou_sch
        and sta_tim_sch >= time '00:00'
        and fin_hou_sch <= time '23:59:59'
    ),
    -- Validates time interval within a day

    constraint fk_schedule_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade
    -- Links to employee
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

    mot_abs varchar(100),
    -- Reason

    constraint pk_absence primary key (id_abs),
    -- Unique identifier

    constraint chk_absence_time
    check (
        sta_dat_tim_abs < end_dat_tim_abs
        -- Start must be before end
    ),

    constraint chk_mot_abs_format
    check (
        mot_abs is null
        or (
            mot_abs = trim(mot_abs)
            and length(mot_abs) > 3
        )
    ),
    -- Prevents empty or meaningless reasons

    constraint fk_absence_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade
    -- Links to employee
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

    constraint chk_clock_time
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
    ),
    -- Ensures valid attendance interval

    constraint fk_clock_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade
    -- Links to employee
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

    constraint fk_setup_user 
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade,
    -- Links to user

    constraint chk_the_set_format
    check (
        the_set = lower(trim(the_set))
        and the_set in ('light', 'dark')
    ),
    -- Restricts theme to valid values

    constraint chk_lan_set_format
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

    constraint pk_occupies primary key (id_emp, id_pro),
    -- Composite identifier (prevents duplicates)

    constraint fk_occ_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,
    -- Links to employee

    constraint fk_occ_profile 
        foreign key (id_pro)
        references profile(id_pro)
        on delete cascade
    -- Links to profile
);

--=========================================================
-- 15. HAVE
--=========================================================
-- Associates profiles with permissions

create table have (
    id_pro int not null,
    -- Profile

    id_per int not null,
    -- Permission

    constraint pk_have primary key (id_pro, id_per),
    -- Composite identifier (prevents duplicates)

    constraint fk_have_profile 
        foreign key (id_pro)
        references profile(id_pro)
        on delete cascade,
    -- Links to profile

    constraint fk_have_permission 
        foreign key (id_per)
        references permission(id_per)
        on delete cascade
    -- Links to permission
);

--=========================================================
-- MODULE 2: ANIMAL MANAGEMENT  (incompleto)
--=========================================================

--=========================================================
-- DESCRIPTION
--=========================================================
-- This module defines the structure responsible for animal management.
-- It includes species classification, animal records, ownership,
-- and interactions with external entities such as suppliers or shelters.
--
-- The module supports:
-- - Animal identification and classification
-- - Ownership tracking
-- - Interaction with external entities
-- - Operational processes such as delivery and concession

--=========================================================
-- 0. CLEANUP
--=========================================================
-- Drops only tables related to this module in reverse dependency order

-- Associative tables
drop table if exists delivery_employee cascade;

-- Dependent entities
drop table if exists concession cascade;
drop table if exists delivery cascade;
drop table if exists ownership cascade;

-- Core entities
drop table if exists animal cascade;
drop table if exists breed cascade;
drop table if exists species cascade;
drop table if exists external_entity cascade;

--=========================================================
-- 1. SPECIES
--=========================================================
-- Defines animal species
create table species (
    id_spc int generated always as identity,
    -- Species identifier

    nam_spc varchar(100) not null,
    -- Common name

    sci_nam_spc varchar(100),
    -- Scientific name

    constraint pk_species primary key (id_spc)
    -- Unique identifier
);

--=========================================================
-- 2. BREED
--=========================================================
-- Defines breeds associated with a species
create table breed (
    id_bre int generated always as identity,
    -- Breed identifier

    nam_bre varchar(100) not null,
    -- Breed name

    sci_nam_bre varchar(100),
    -- Scientific name

    id_spc int not null,
    -- Associated species

    constraint pk_breed primary key (id_bre),
    -- Unique identifier

    constraint fk_breed_species 
        foreign key (id_spc)
        references species(id_spc)
        on delete cascade
    -- Links breed to species
);

--=========================================================
-- 3. ANIMAL
--=========================================================
-- Stores individual animal records
create table animal (
    id_ani int generated always as identity,
    -- Animal identifier

    reg_id_ani varchar(50) not null,
    -- Unique registration code

    nam_ani varchar(100),
    -- Name

    dat_bir_ani date,
    -- Birth date

    gen_ani char(1),
    -- Gender

    ori_ani varchar(100),
    -- Origin

    sta_ani varchar(50),
    -- Status

    id_spc int not null,
    -- Species

    id_bre int,
    -- Breed

    constraint pk_animal primary key (id_ani),
    -- Unique identifier

    constraint uq_reg_id_ani unique (reg_id_ani),
    -- Prevents duplicate registrations

    constraint fk_animal_species 
        foreign key (id_spc)
        references species(id_spc)
        on delete restrict,
    -- Links to species

    constraint fk_animal_breed 
        foreign key (id_bre)
        references breed(id_bre)
        on delete set null,
    -- Links to breed

    constraint chk_gen_ani
    check (gen_ani in ('M','F') or gen_ani is null)
    -- Validates gender
);

--=========================================================
-- 4. EXTERNAL_ENTITY
--=========================================================
-- Represents external organizations (suppliers, shelters, etc.)
create table external_entity (
    id_ext_ent int generated always as identity,
    -- Entity identifier

    nam_ext_ent varchar(100) not null,
    -- Name

    loc_ext_ent varchar(100),
    -- Location

    pho_ext_ent varchar(16),
    -- Phone

    ema_ext_ent varchar(255),
    -- Email

    typ_ext_ent varchar(50),
    -- Type

    constraint pk_external_entity primary key (id_ext_ent),
    -- Unique identifier

    constraint chk_pho_ext_ent_format
    check (pho_ext_ent is null or pho_ext_ent ~ '^\+[1-9][0-9]{7,14}$'),
    -- Validates phone format

    constraint chk_ema_ext_ent_format
    check (ema_ext_ent is null or ema_ext_ent ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$')
    -- Validates email format
);

--=========================================================
-- 5. OWNERSHIP
--=========================================================
-- Defines ownership relation between client and animal
create table ownership (
    id_own int generated always as identity,
    -- Ownership identifier

    id_cli int not null,
    -- Client

    id_ani int not null,
    -- Animal

    sta_dat_own date not null,
    -- Start date

    end_dat_own date,
    -- End date

    mot_own varchar(100),
    -- Reason

    id_emp int,
    -- Responsible employee

    constraint pk_ownership primary key (id_own),
    -- Unique identifier

    constraint fk_ownership_client 
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade,
    -- Links to client

    constraint fk_ownership_animal 
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade,
    -- Links to animal

    constraint fk_ownership_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete set null,
    -- Tracks responsible employee

    constraint chk_ownership_dates
    check (
        end_dat_own is null 
        or sta_dat_own <= end_dat_own
    )
    -- Ensures valid date range
);

--=========================================================
-- 6. CONCESSION
--=========================================================
-- Represents transfer of animals to external entities
create table concession (
    id_con int generated always as identity,
    -- Concession identifier

    dat_con date not null,
    -- Date

    mot_con varchar(100),
    -- Reason

    cli_sta_con varchar(100),
    -- Clinical status

    id_ext_ent int not null,
    -- External entity

    id_emp int not null,
    -- Employee

    id_ani int not null,
    -- Animal

    constraint pk_concession primary key (id_con),
    -- Unique identifier

    constraint fk_concession_entity 
        foreign key (id_ext_ent)
        references external_entity(id_ext_ent)
        on delete restrict,
    -- Links to entity

    constraint fk_concession_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete restrict,
    -- Links to employee

    constraint fk_concession_animal 
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade
    -- Links to animal
);

--=========================================================
-- 7. DELIVERY
--=========================================================
-- Represents rescue and delivery processes
create table delivery (
    id_del int generated always as identity,
    -- Delivery identifier

    reg_dat_del timestamp,
    -- Registration date

    res_dat_del timestamp,
    -- Rescue date

    del_dat_del timestamp,
    -- Delivery date

    res_loc_del varchar(100),
    -- Rescue location

    cli_sta_del varchar(100),
    -- Clinical status

    id_ext_ent int,
    -- External entity

    id_ani int not null,
    -- Animal

    constraint pk_delivery primary key (id_del),
    -- Unique identifier

    constraint fk_delivery_entity 
        foreign key (id_ext_ent)
        references external_entity(id_ext_ent)
        on delete set null,
    -- Links to entity

    constraint fk_delivery_animal 
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade,
    -- Links to animal

    constraint chk_delivery_dates
    check (
        del_dat_del is null 
        or reg_dat_del <= del_dat_del
    )
    -- Ensures valid dates
);

--=========================================================
-- 8. ASSOCIATIVE TABLE
--=========================================================
-- Defines many-to-many relation between delivery and employee

create table delivery_employee (
    id_del int not null,
    -- Delivery

    id_emp int not null,
    -- Employee

    constraint pk_delivery_employee primary key (id_del, id_emp),
    -- Composite identifier

    constraint fk_del_emp_delivery 
        foreign key (id_del)
        references delivery(id_del)
        on delete cascade,

    constraint fk_del_emp_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade
);

--=========================================================
-- MODULE 3: COMMERCIAL MANAGEMENT (incompleto)
--=========================================================

--=========================================================
-- DESCRIPTION
--=========================================================
-- This module defines the structure responsible for commercial management.
-- It includes product catalog, stock control, purchases and returns,
-- as well as relationships between employees and commercial operations.
--
-- The module supports:
-- - Product and family classification
-- - Stock management and tracking
-- - Purchase and return processes
-- - Employee participation in commercial activities

--=========================================================
-- 0. CLEANUP
--=========================================================
-- Drops only tables related to this module in reverse dependency order

-- Associative tables
drop table if exists employee_return cascade;
drop table if exists employee_purchase cascade;
drop table if exists return_product cascade;
drop table if exists purchase_product cascade;

-- Dependent entities
drop table if exists return cascade;
drop table if exists purchase cascade;
drop table if exists stock cascade;

-- Core entities
drop table if exists product cascade;
drop table if exists family cascade;

--=========================================================
-- 1. FAMILY
--=========================================================
-- Defines product categories
create table family (
    id_fam int generated always as identity,
    -- Family identifier

    nam_fam varchar(100) not null,
    -- Name

    des_fam text,
    -- Description

    constraint pk_family primary key (id_fam)
    -- Unique identifier
);

--=========================================================
-- 2. PRODUCT
--=========================================================
-- Stores product information
create table product (
    id_pro int generated always as identity,
    -- Product identifier

    ref_pro varchar(50),
    -- Reference code

    bar_pro varchar(50),
    -- Barcode

    nam_pro varchar(100) not null,
    -- Name

    des_pro text,
    -- Description

    pri_pro numeric(10,2),
    -- Unit price

    iva_pro numeric(5,2),
    -- VAT

    reg_dat_pro timestamp default current_timestamp,
    -- Registration date

    ina_dat_pro timestamp,
    -- Inactivation date

    id_fam int,
    -- Family

    constraint pk_product primary key (id_pro),
    -- Unique identifier

    constraint fk_product_family 
        foreign key (id_fam)
        references family(id_fam)
        on delete set null
    -- Links product to family
);

--=========================================================
-- 3. STOCK
--=========================================================
-- Tracks product stock and batches
create table stock (
    id_sto int generated always as identity,
    -- Stock identifier

    id_pro int not null,
    -- Product

    bat_sto varchar(50),
    -- Batch

    qty_sto int not null,
    -- Quantity

    val_dat_sto date,
    -- Expiration date

    ent_dat_sto date,
    -- Entry date

    constraint pk_stock primary key (id_sto),
    -- Unique identifier

    constraint fk_stock_product 
        foreign key (id_pro)
        references product(id_pro)
        on delete cascade,
    -- Links stock to product

    constraint chk_qty_sto
    check (qty_sto >= 0)
    -- Prevents negative stock
);

--=========================================================
-- 4. PURCHASE
--=========================================================
-- Represents product purchase operations
create table purchase (
    id_pur int generated always as identity,
    -- Purchase identifier

    pur_dat_pur timestamp,
    -- Purchase date

    tot_val_pur numeric(10,2),
    -- Total value

    ord_num_pur varchar(50),
    -- Order number

    pay_met_pur varchar(50),
    -- Payment method

    sta_pur varchar(50),
    -- Status

    id_ext_ent int,
    -- Supplier

    constraint pk_purchase primary key (id_pur),
    -- Unique identifier

    constraint fk_purchase_supplier 
        foreign key (id_ext_ent)
        references external_entity(id_ext_ent)
        on delete set null,
    -- Links to supplier

    constraint chk_sta_pur
    check (sta_pur in ('pending','received','cancelled') or sta_pur is null)
    -- Validates status
);

--=========================================================
-- 5. RETURN
--=========================================================
-- Represents product return operations
create table return (
    id_ret int generated always as identity,
    -- Return identifier

    dat_ret date,
    -- Return date

    mot_ret varchar(100),
    -- Reason

    reg_dat_ret timestamp default current_timestamp,
    -- Registration date

    ina_dat_ret timestamp,
    -- Inactivation date

    constraint pk_return primary key (id_ret)
    -- Unique identifier
);

--=========================================================
-- 6. ASSOCIATIVE TABLES
--=========================================================
-- Defines many-to-many relationships

-- PURCHASE ↔ PRODUCT
create table purchase_product (
    id_pur int not null,
    -- Purchase

    id_pro int not null,
    -- Product

    qty_pur_pro int not null,
    -- Quantity

    constraint pk_purchase_product primary key (id_pur, id_pro),
    -- Composite identifier

    constraint fk_pur_pro_purchase 
        foreign key (id_pur)
        references purchase(id_pur)
        on delete cascade,

    constraint fk_pur_pro_product 
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict,

    constraint chk_qty_purchase
    check (qty_pur_pro > 0)
    -- Ensures valid quantity
);

-- RETURN ↔ PRODUCT
create table return_product (
    id_ret int not null,
    -- Return

    id_pro int not null,
    -- Product

    qty_ret_pro int not null,
    -- Quantity

    constraint pk_return_product primary key (id_ret, id_pro),

    constraint fk_ret_pro_return 
        foreign key (id_ret)
        references return(id_ret)
        on delete cascade,

    constraint fk_ret_pro_product 
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict,

    constraint chk_qty_return
    check (qty_ret_pro > 0)
    -- Ensures valid quantity
);

-- EMPLOYEE ↔ PURCHASE
create table employee_purchase (
    id_emp int not null,
    -- Employee

    id_pur int not null,
    -- Purchase

    constraint pk_employee_purchase primary key (id_emp, id_pur),

    constraint fk_emp_pur_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,

    constraint fk_emp_pur_purchase 
        foreign key (id_pur)
        references purchase(id_pur)
        on delete cascade
);

-- EMPLOYEE ↔ RETURN
create table employee_return (
    id_emp int not null,
    -- Employee

    id_ret int not null,
    -- Return

    constraint pk_employee_return primary key (id_emp, id_ret),

    constraint fk_emp_ret_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,

    constraint fk_emp_ret_return 
        foreign key (id_ret)
        references return(id_ret)
        on delete cascade
);

--=========================================================
-- MODULE 4: APPOINTMENT MANAGEMENT (incompleto)
--=========================================================

--=========================================================
-- DESCRIPTION
--=========================================================
-- This module defines the structure responsible for appointment
-- and clinical management. It includes scheduling, medical records,
-- prescriptions, and billing associated with consultations.
--
-- The module supports:
-- - Appointment scheduling and tracking
-- - Clinical records (anamnesis and assessment)
-- - Prescription management
-- - Association of employees, clients and animals to appointments
-- - Billing through invoices

--=========================================================
-- 0. CLEANUP
--=========================================================
-- Drops only tables related to this module in reverse dependency order

-- Associative tables
drop table if exists employee_prescription cascade;
drop table if exists employee_assessment cascade;
drop table if exists employee_anamnesis cascade;
drop table if exists prescription_product cascade;
drop table if exists animal_appointment cascade;
drop table if exists client_appointment cascade;
drop table if exists employee_appointment cascade;

-- Dependent entities
drop table if exists invoice cascade;
drop table if exists prescription cascade;
drop table if exists assessment cascade;
drop table if exists anamnesis cascade;

-- Core entity
drop table if exists appointment cascade;

--=========================================================
-- 1. APPOINTMENT
--=========================================================
-- Stores appointment scheduling and general information
create table appointment (
    id_app int generated always as identity,
    -- Appointment identifier

    sch_dat_app timestamp,
    -- Scheduled datetime

    sta_dat_app timestamp not null,
    -- Start datetime

    end_dat_app timestamp not null,
    -- End datetime

    dia_app varchar(100),
    -- Diagnosis

    com_app text,
    -- Comments

    constraint pk_appointment primary key (id_app),
    -- Unique identifier

    constraint chk_app_time
    check (sta_dat_app < end_dat_app)
    -- Ensures valid time interval
);

--=========================================================
-- 2. ANAMNESIS
--=========================================================
-- Stores patient history collected during appointment
create table anamnesis (
    id_ana int generated always as identity,
    -- Anamnesis identifier

    id_app int not null,
    -- Appointment

    reg_dat_ana timestamp default current_timestamp,
    -- Record date

    des_ana text,
    -- Description

    constraint pk_anamnesis primary key (id_ana),
    -- Unique identifier

    constraint fk_anamnesis_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade
    -- Links to appointment
);

--=========================================================
-- 3. ASSESSMENT
--=========================================================
-- Stores clinical evaluation results
create table assessment (
    id_ass int generated always as identity,
    -- Assessment identifier

    id_app int not null,
    -- Appointment

    reg_dat_ass timestamp default current_timestamp,
    -- Record date

    des_ass text,
    -- Description

    constraint pk_assessment primary key (id_ass),
    -- Unique identifier

    constraint fk_assessment_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade
    -- Links to appointment
);

--=========================================================
-- 4. PRESCRIPTION
--=========================================================
-- Stores prescriptions issued during appointment
create table prescription (
    id_pre int generated always as identity,
    -- Prescription identifier

    id_app int not null,
    -- Appointment

    reg_dat_pre timestamp default current_timestamp,
    -- Issue date

    des_pre text,
    -- Description

    constraint pk_prescription primary key (id_pre),
    -- Unique identifier

    constraint fk_prescription_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade
    -- Links to appointment
);

--=========================================================
-- 5. INVOICE
--=========================================================
-- Stores billing information related to appointments
create table invoice (
    id_inv int generated always as identity,
    -- Invoice identifier

    val_inv numeric(10,2),
    -- Total value

    dat_inv timestamp,
    -- Issue date

    bod_inv text,
    -- Description/content

    id_app int,
    -- Appointment

    constraint pk_invoice primary key (id_inv),
    -- Unique identifier

    constraint fk_invoice_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete set null
    -- Links to appointment
);

--=========================================================
-- 6. ASSOCIATIVE TABLES
--=========================================================
-- Defines many-to-many relationships

-- EMPLOYEE ↔ APPOINTMENT
create table employee_appointment (
    id_emp int not null,
    -- Employee

    id_app int not null,
    -- Appointment

    constraint pk_employee_appointment primary key (id_emp, id_app),

    constraint fk_emp_app_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,

    constraint fk_emp_app_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade
);

-- CLIENT ↔ APPOINTMENT
create table client_appointment (
    id_cli int not null,
    -- Client

    id_app int not null,
    -- Appointment

    constraint pk_client_appointment primary key (id_cli, id_app),

    constraint fk_cli_app_client 
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade,

    constraint fk_cli_app_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade
);

-- ANIMAL ↔ APPOINTMENT
create table animal_appointment (
    id_ani int not null,
    -- Animal

    id_app int not null,
    -- Appointment

    constraint pk_animal_appointment primary key (id_ani, id_app),

    constraint fk_ani_app_animal 
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade,

    constraint fk_ani_app_appointment 
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade
);

-- PRESCRIPTION ↔ PRODUCT
create table prescription_product (
    id_pre int not null,
    -- Prescription

    id_pro int not null,
    -- Product

    qty_pre_pro int not null,
    -- Quantity

    dos_pre_pro varchar(100),
    -- Dosage

    constraint pk_prescription_product primary key (id_pre, id_pro),

    constraint fk_pre_pro_prescription 
        foreign key (id_pre)
        references prescription(id_pre)
        on delete cascade,

    constraint fk_pre_pro_product 
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict,

    constraint chk_qty_pre
    check (qty_pre_pro > 0)
    -- Ensures valid quantity
);

-- EMPLOYEE ↔ ANAMNESIS
create table employee_anamnesis (
    id_emp int not null,
    -- Employee

    id_ana int not null,
    -- Anamnesis

    constraint pk_employee_anamnesis primary key (id_emp, id_ana),

    constraint fk_emp_ana_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,

    constraint fk_emp_ana_anamnesis 
        foreign key (id_ana)
        references anamnesis(id_ana)
        on delete cascade
);

-- EMPLOYEE ↔ ASSESSMENT
create table employee_assessment (
    id_emp int not null,
    -- Employee

    id_ass int not null,
    -- Assessment

    constraint pk_employee_assessment primary key (id_emp, id_ass),

    constraint fk_emp_ass_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,

    constraint fk_emp_ass_assessment 
        foreign key (id_ass)
        references assessment(id_ass)
        on delete cascade
);

-- EMPLOYEE ↔ PRESCRIPTION
create table employee_prescription (
    id_emp int not null,
    -- Employee

    id_pre int not null,
    -- Prescription

    constraint pk_employee_prescription primary key (id_emp, id_pre),

    constraint fk_emp_pre_employee 
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade,

    constraint fk_emp_pre_prescription 
        foreign key (id_pre)
        references prescription(id_pre)
        on delete cascade
);