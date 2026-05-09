--=========================================================
-- MODULE 4: APPOINTMENT MANAGEMENT (Por retificar)
--=========================================================

--=========================================================
-- DESCRIPTION
--=========================================================
-- This module defines the structure responsible for appointment
-- and clinical management. It includes scheduling, medical records,
-- prescriptions, and billing associated with consultations.
--
-- The module supports:
-- - Appointment scheduling and tracking with status management
-- - Clinical records (anamnesis and assessment)
-- - Prescription management
-- - Association of employees, clients and animals to appointments
-- - Billing through invoices with status tracking
--
-- Foreign keys: 01_ForeignKeys_Mod4.sql (after all module tables exist).

--=========================================================
-- 0. CLEANUP
--=========================================================
-- Drops only tables related to this module in reverse dependency order


drop table if exists appointment_specialty cascade;
drop table if exists appointment cascade;
drop table if exists overall_assessment cascade;
drop table if exists anamnesis cascade;
drop table if exists prescription cascade;
drop table if exists rel_app_product cascade;
drop table if exists appointment_notification cascade;
drop table if exists rel_pre_prod cascade;

-- Custom types
drop type if exists appointment_status cascade;
drop type if exists invoice_status cascade;

--=========================================================
-- 1. TYPES
--=========================================================
-- Defines custom ENUM types for status fields to ensure data consistency.

create type appointment_status as enum (
    'Scheduled',
    'In Progress', 
    'Completed', 
    'Cancelled', 
    'No-Show'
);

create type invoice_status as enum (
    'Pending', 
    'Paid', 
    'Overdue', 
    'Cancelled'
);

--=========================================================
-- 2. APPOINTMENT
-- 2. APPOINTMENT SPECIALTY
--=========================================================
-- Stores the different types of appointment specialties available.
-- This promotes data consistency over a free-text field.
create table appointment_specialty (
    id_spec int generated always as identity,
    -- Specialty identifier

    name_spec varchar(100) not null unique,
    -- Name of the specialty (e.g., 'General Checkup', 'Surgery', 'Vaccination')

    description_spec text,
    -- Optional description of the specialty.

    constraint pk_appointment_specialty primary key (id_spec)
);

--=========================================================
-- 3. APPOINTMENT
--=========================================================
-- Stores appointment scheduling, status, and general information.
create table appointment (
    id_app int generated always as identity,
    -- Appointment identifier

    --Animal identifier    
    id_animal int NOT NULL,

    -- Employee (Veterinarian) identifier
    id_emp int NOT NULL,

    --client identifier
    id_cli int NOT NULL,

    -- Specialty of the appointment (e.g., General Checkup, Surgery)
    spec_app varchar(100) not null,
    -- Foreign key to the appointment_specialty table
    id_spec int not null,

    sch_dat_app timestamp NOT NULL,
    -- Scheduled datetime

    sta_dat_app timestamp,
    -- Actual start datetime of the consultation

    end_dat_app timestamp,
    -- Actual end datetime of the consultation

    status_app appointment_status not null default 'Scheduled',
    -- Current status of the appointment (e.g., Scheduled, Completed)

    dia_app varchar(100),
    -- Diagnosis resulting from the appointment. Filled upon completion.

    com_app text,
    -- General comments or observations about the appointment

    constraint pk_appointment primary key (id_app),
    -- Unique identifier

    constraint chk_app_time
    check (sta_dat_app < end_dat_app)
    -- Ensures the end time is after the start time
);

--=========================================================
-- 2. Overall Assessment
-- 4. Overall Assessment
--=========================================================
-- Stores clinical history collected during appointment
CREATE TABLE overall_assessment (
    id_app INT NOT NULL, -- PK and FK
    body_temp FLOAT,     -- Body temperature in °C
    weight FLOAT,        -- Weight in kg
    hrt_rate FLOAT,      -- Heart rate (BPM)
    resp_rate FLOAT,     -- Respiratory rate (MPM)
    general_status TEXT, -- Notations about the animal
    
    -- Defining the Primary Key
    CONSTRAINT pk_overall_assessment PRIMARY KEY (id_app),
        
    -- Safety checks to prevent impossible medical data
    CONSTRAINT chk_body_temp CHECK (body_temp > 0 AND body_temp < 50),
    CONSTRAINT chk_weight CHECK (weight > 0)
);

--=========================================================
-- 3. ANAMNESIS
-- 5. ANAMNESIS
--=========================================================
-- Stores patient history collected during appointment
create table anamnesis (
    id_ana int generated always as identity,
    -- Anamnesis identifier

    id_app int not null,
    -- Foreign key to the related appointment

    reg_dat_ana timestamp not null default current_timestamp,
    -- Record date and time

    des_ana text,
    -- Detailed description of the patient's history and symptoms

    constraint pk_anamnesis primary key (id_ana)
    -- Unique identifier
);

--=========================================================
-- 4. PRESCRIPTION
-- 6. PRESCRIPTION
--=========================================================
-- Stores prescriptions issued during appointment
create table prescription (
    id_pre int generated always as identity,
    -- Prescription identifier

    id_app int not null,
    -- Foreign key to the related appointment

    reg_dat_pre timestamp not null default current_timestamp,
    -- Issue date and time of the prescription

    des_pre text,
    -- General instructions or description for the prescription

    constraint pk_prescription primary key (id_pre)
    -- Unique identifier
);

--=========================================================
-- 5. ASSOCIATIVE TABLE BETWEEN APPOINTMENT AND PRODUCTS
-- 7. ASSOCIATIVE TABLE BETWEEN APPOINTMENT AND PRODUCTS
--=========================================================
create table rel_app_product (
    id_app int not null,
    -- Prescription

    id_pro int not null,
    -- Product

    qty_pre_pro int not null,
    -- Quantity

    dos_pre_pro varchar(100),
    -- Dosage

    constraint pk_appointment_product primary key (id_app, id_pro),

    constraint chk_qty_rel_app_product
    check (qty_pre_pro > 0)
    -- Ensures valid quantity
);

--=========================================================
-- 6. ASSOCIATIVE TABLE BETWEEN PRESCRIPTION AND PRODUCTS
-- 8. ASSOCIATIVE TABLE BETWEEN PRESCRIPTION AND PRODUCTS
--=========================================================
create table rel_pre_prod (
    id_pre int not null,
    -- Prescription

    id_pro int not null,
    -- Product

    qty_pre_pro int not null,
    -- Quantity of the product prescribed

    dos_pre_pro varchar(100),
    -- Dosage instructions (e.g., '1 pill every 8 hours')

    constraint pk_prescription_product primary key (id_pre, id_pro),

    constraint chk_qty_rel_pre_prod
    check (qty_pre_pro > 0)
    -- Ensures valid quantity
);

--=========================================================
-- 7. APPOINTMENT NOTIFICATIONS
-- 9. APPOINTMENT NOTIFICATIONS
--=========================================================
-- Stores notifications generated for clients
create table appointment_notification (
    id_not int generated always as identity,
    -- Notification identifier

    id_cli int not null,
    -- Client associated with the notification

    message text not null,
    -- The notification message

    created_at timestamp default current_timestamp,
    -- Timestamp when the notification was created

    is_read boolean default false,
    -- Flag to indicate if the client has read the notification

    constraint pk_appointment_notification primary key (id_not)
);

