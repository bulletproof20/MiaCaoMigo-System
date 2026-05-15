-- =========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
-- File: 00_Tables_Mod4.sql (tables only)
-- =========================================================
--
-- DESCRIPTION
-- Consultations, clinical notes, prescriptions, product usage,
-- and client notifications. Workflow fields use appointment_status
-- and invoice_status from 00_Core/01_Types.sql.
--
-- FOREIGN KEYS: 01_ForeignKeys_Mod4.sql (after all module tables exist).
-- =========================================================

-- =========================================================
-- 1. APPOINTMENT
-- =========================================================
-- Stores appointment scheduling, status, and general information.
-- id_spe: clinical nature of the consultation (Module 1 specialty catalog),
--         distinct from the veterinarian's full qualification set (expert).
create table appointment (
    id_app int generated always as identity,
    -- Appointment identifier

    id_ani int not null,
    -- Animal identifier

    id_emp int not null,
    -- Employee (veterinarian) identifier

    id_cli int not null,
    -- Client identifier

    id_spe int not null,
    -- Specialty of the appointment (e.g., general checkup, surgery)

    id_inv int,
    -- Invoice identifier (nullable; may be generated after the appointment)

    sch_dat_app timestamp not null,
    -- Scheduled datetime

    sta_dat_app timestamp,
    -- Actual start datetime of the consultation

    end_dat_app timestamp,
    -- Actual end datetime of the consultation

    status_app appointment_status not null default 'scheduled',
    -- Current status of the appointment

    dia_app text,
    -- Diagnosis resulting from the appointment. Filled upon completion.

    com_app text,
    -- General comments or observations about the appointment

    constraint pk_appointment primary key (id_app),

    constraint ck_appointment_flow
    check (sta_dat_app < end_dat_app)
    -- Ensures the end time is after the start time
);

--=========================================================
-- 3. OVERALL_ASSESSMENT
--=========================================================
-- Stores clinical vitals collected during an appointment (1:1 with appointment)
create table overall_assessment (
    id_app int not null,
    -- PK and FK to appointment

    bod_tmp_ova numeric(4,1),
    -- Body temperature in °C (e.g., 38.5)

    wei_ova numeric(6,2),
    -- Weight in kg (e.g., 25.50)

    hrt_rat_ova int,
    -- Heart rate (beats per minute)

    res_rat_ova int,
    -- Respiratory rate (breaths per minute)

    gen_sta_ova text,
    -- General notations about the animal's condition

    constraint ck_bod_tmp_ova
    check (bod_tmp_ova is null or (bod_tmp_ova > 20 and bod_tmp_ova < 50)),

    constraint ck_wei_ova
    check (wei_ova is null or wei_ova > 0),

    constraint ck_hrt_rat_ova
    check (hrt_rat_ova is null or hrt_rat_ova > 0),

    constraint ck_res_rat_ova
    check (res_rat_ova is null or res_rat_ova > 0)
);

--=========================================================
-- 4. ANAMNESIS
--=========================================================
-- Stores patient history collected during appointment
create table anamnesis (
    id_app int not null,
    -- Establishes a 1-to-1 relationship, as an anamnesis is unique to a consultation.

    reg_dat_ana timestamp not null default current_timestamp,
    -- Record date and time

    des_ana text,
    -- Detailed description of the patient's history and symptoms (reason for visit, etc.)

    constraint pk_anamnesis primary key (id_app)
);

--=========================================================
-- 5. PRESCRIPTION
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

    constraint pk_prescription primary key (id_pre),

    constraint uq_prescription_per_appointment unique (id_app)
    -- Ensures only one prescription can be registered per appointment.
);

--=========================================================
-- 6. ASSOCIATIVE TABLE BETWEEN APPOINTMENT AND PRODUCTS
--=========================================================
-- This table links products used directly during an appointment.
create table rel_app_product (
    id_app int not null,
    -- Appointment

    id_pro int not null,
    -- Product

    qty_pre_pro int not null,
    -- Quantity

    dos_pre_pro varchar(100),
    -- Dosage

    constraint pk_appointment_product primary key (id_app, id_pro),

    constraint ck_qty_rel_app_product
    check (qty_pre_pro > 0)
);

--=========================================================
-- 7. ASSOCIATIVE TABLE BETWEEN PRESCRIPTION AND PRODUCTS
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

    constraint ck_qty_rel_pre_prod
    check (qty_pre_pro > 0)
);

--=========================================================
-- 8. APPOINTMENT_NOTIFICATION
--=========================================================
-- Stores notifications generated for clients
create table appointment_notification (
    id_not int generated always as identity,
    -- Notification identifier

    id_cli int not null,
    -- Client associated with the notification

    id_app int not null,
    -- Appointment associated with the notification

    msg_not text not null,
    -- Notification message body

    cre_tim_not timestamp default current_timestamp,
    -- Timestamp when the notification was created

    rea_not boolean default false,
    -- Flag indicating whether the client has read the notification

    constraint pk_appointment_notification primary key (id_not)
);
