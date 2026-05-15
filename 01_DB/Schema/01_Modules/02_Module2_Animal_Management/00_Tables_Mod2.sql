--=========================================================
-- MODULE 2: ANIMAL MANAGEMENT 
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
--
-- Foreign keys: 01_ForeignKeys_Mod2.sql (after all module tables exist).



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

    constraint pk_breed primary key (id_bre)
    -- Unique identifier
);

--=========================================================
-- 3. ANIMAL
--=========================================================
-- Stores individual animal records
create table animal (
    id_ani int generated always as identity,
    -- Animal identifier

    id_cli int,
    -- Owner (client) identifier

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

    registration_date date default current_date, -- Data de registo
    inactivation_date date,                      -- Data de inativação

    constraint pk_animal primary key (id_ani),
    -- Unique identifier

    constraint uq_reg_id_ani unique (reg_id_ani),
    -- Prevents duplicate registrations

    constraint fk_animal_client 
        foreign key (id_cli)
        references client(id_cli)
        on delete set null,

    -- constraint fk_animal_species 
    --     foreign key (id_spc)
    --     references species(id_spc)
    --     on delete restrict,
    -- -- Links to species, declares on external file

    -- constraint fk_animal_breed 
    --     foreign key (id_bre)
    --     references breed(id_bre)
    --     on delete set null,
    -- -- Links to breed, declared on external file

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
-- 5. Ownership
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

    constraint pk_concession primary key (id_con)
    -- Unique identifier
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

    constraint pk_delivery_employee primary key (id_del, id_emp)
    -- Composite identifier
);