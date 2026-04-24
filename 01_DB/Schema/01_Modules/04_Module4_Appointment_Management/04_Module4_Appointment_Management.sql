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