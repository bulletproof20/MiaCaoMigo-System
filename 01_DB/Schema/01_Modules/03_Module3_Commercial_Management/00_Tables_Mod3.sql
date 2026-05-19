--=========================================================
-- MODULE 3: COMMERCIAL MANAGEMENT (Por retificar)
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



-- Dependent entities
drop table if exists "return" cascade;
drop table if exists purchase cascade;
drop table if exists stock cascade;

-- Core entities
drop table if exists product cascade;
drop table if exists "family" cascade;
drop table if exists invoice cascade;
drop table if exists purchase_line cascade;
drop table if exists invoice_line cascade;



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
-- 2. INVOICE
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

    constraint pk_invoice primary key (id_inv)
    -- Unique identifier

    -- constraint fk_invoice_appointment foreign key (id_app)
    --     references appointment(id_app)
    --     on delete set null
    -- -- Links to appointment
);


--=========================================================
-- 3. PRODUCT
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

    id_fam int NOT NULL,
    -- Family

    
    min_sto INT NOT NULL DEFAULT 5,
    -- Minimum stock level,


    constraint pk_product primary key (id_pro),
    -- Unique identifier

    constraint fk_product_family foreign key (id_fam) references family(id_fam) on delete restrict,
    -- Links product to family. Outras FKs serão adicionadas no final.

);


--=========================================================
-- 4. STOCK
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

    -- alter table stock
    -- add constraint fk_stock_product
    -- foreign key (id_pro)
    -- references product(id_pro)
    -- on delete cascade;

    
-- this constraint had to be added via alter table after creating the stock table to prevent an error during the creation of the product table.

--=========================================================
-- 5. PURCHASE
--=========================================================
-- Represents product purchase operations
create table purchase (
    id_pur int generated always as identity,
    -- Purchase identifier

    pur_dat_pur timestamp default current_timestamp,
    -- Purchase date

    tot_val_pur numeric(10,2),
    -- Total value

    ord_num_pur varchar(50),
    -- Order number

    pay_met_pur varchar(50),
    -- Payment method

    sta_pur varchar(50) default 'pending',
    -- Status

    id_cli int,
    -- client

    id_emp int,
    -- Employee responsible

    constraint pk_purchase primary key (id_pur),
    -- Unique identifier


    constraint fk_client foreign key (id_cli) references client(id_cli)
        on DELETE set null,

    constraint fk_employee foreign key (id_emp) references employee(id_emp)
        on DELETE set null,


    constraint chk_sta_pur
    check (sta_pur in ('pending','received','cancelled') or sta_pur is null)
    -- Validates status
);

--=========================================================
-- 6. RETURN
--=========================================================
-- Represents product return operations
create table return (
    id_ret int generated always as identity,
    -- Return identifier

    mot_ret varchar(100),
    -- Reason

    reg_dat_ret timestamp default current_timestamp,
    -- Registration date

    return_date timestamp,
    -- Return date

    id_invLine int,
    -- Invoice line (if return is related to a sale)

    quant_ret int NOT NULL DEFAULT 1,
    -- Quantity returned

    constraint pk_return primary key (id_ret),
    -- Unique identifier

    constraint fk_return_invoice_line foreign key (id_invLine) references invoice_line(id_invoice_line)
        on DELETE set null,
);



-- Linhas de compra (junta Product, Purchase, Stock)
CREATE TABLE purchase_line (
    ID_PURCHASE_LINE SERIAL PRIMARY KEY,
    ID_PURCHASE INT NOT NULL REFERENCES Purchase(id_pur),
    ID_PRODUCT INT NOT NULL REFERENCES Product(id_pro),
    BATCH VARCHAR(50),
    QUANTITY INT NOT NULL CHECK (QUANTITY > 0),
    UNIT_COST NUMERIC(10,2) NOT NULL,
    ID_STOCK INT REFERENCES Stock(id_sto)
);

-- Linhas de fatura (venda ao cliente)
CREATE TABLE invoice_line (
    ID_INVOICE_LINE SERIAL PRIMARY KEY,
    ID_INVOICE INT NOT NULL REFERENCES Invoice(id_inv),
    ID_PRODUCT INT NOT NULL REFERENCES Product(id_pro),
    QUANTITY INT NOT NULL CHECK (QUANTITY > 0),
    UNIT_PRICE NUMERIC(10,2) NOT NULL,
    IVA NUMERIC(5,2) NOT NULL
);

