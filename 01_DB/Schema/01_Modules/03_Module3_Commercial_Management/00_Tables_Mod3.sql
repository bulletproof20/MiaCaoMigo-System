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
--
-- Foreign keys: 01_ForeignKeys_Mod3.sql (after all module tables exist).




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

    id_pur int,
    -- Last purchase

    id_sto int,
    -- Current stock

    id_fam int not null,
    -- Family

    id_ret int,
    -- Last return

    min_sto INT NOT NULL DEFAULT 5,
    -- Minimum stock level,


    constraint pk_product primary key (id_pro)
    -- Unique identifier
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

    constraint chk_qty_sto
    check (qty_sto >= 0)
    -- Prevents negative stock
);

--=========================================================
-- 5. PURCHASE
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

    id_inv int,
    -- Linked invoice (see FK phase)

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
-- 6. PURCHASE_LINE
--=========================================================
-- Line items for a purchase (product, batch, cost; optional stock row)
create table purchase_line (
    id_pur_lin int generated always as identity,
    -- Purchase line identifier

    id_pur int not null,
    -- Purchase header

    id_pro int not null,
    -- Product

    bat_pln varchar(50),
    -- Batch identifier

    qty_pln int not null,
    -- Quantity purchased

    uni_cos_pln numeric(10,2) not null,
    -- Unit cost

    id_sto int,
    -- Optional link to stock row created from this line

    constraint pk_purchase_line primary key (id_pur_lin),

    constraint chk_qty_pln
    check (qty_pln > 0)
);

--=========================================================
-- 7. INVOICE_LINE
--=========================================================
-- Line items for a customer invoice (sale)
create table invoice_line (
    id_inv_lin int generated always as identity,
    -- Invoice line identifier

    id_inv int not null,
    -- Invoice header

    id_pro int not null,
    -- Product

    qty_inv_lin int not null,
    -- Quantity sold

    uni_pri_inv_lin numeric(10,2) not null,
    -- Unit price

    iva_inv_lin numeric(5,2) not null,
    -- VAT rate or amount per business rules

    constraint pk_invoice_line primary key (id_inv_lin),

    constraint chk_qty_inv_lin
    check (qty_inv_lin > 0)
);

--=========================================================
-- 8. RETURN
--=========================================================
-- Represents product return operations
create table return (
    id_ret int generated always as identity,
    -- Return identifier

    --dat_ret date,
    -- Return date, this column was "deleted" because of the trigger that sets the return date to the current timestamp if not provided.

    mot_ret varchar(100),
    -- Reason

    reg_dat_ret timestamp not null default current_timestamp,
    -- Registration date

    ina_dat_ret timestamp,
    -- Inactivation / closing date

    id_inv_lin int,
    -- Optional link to originating invoice line

    qty_ret int not null default 1,
    -- Quantity returned (replaces legacy QUANTITY_RETURNED)

    constraint pk_return primary key (id_ret)
    -- Unique identifier
);

--=========================================================
-- 9. ASSOCIATIVE TABLES
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

    constraint pk_employee_purchase primary key (id_emp, id_pur)
);

-- EMPLOYEE ↔ RETURN
create table employee_return (
    id_emp int not null,
    -- Employee

    id_ret int not null,
    -- Return

    constraint pk_employee_return primary key (id_emp, id_ret)
);

------------------------------------------------------------
CREATE TABLE PurchaseLine (
    ID_PURCHASE_LINE SERIAL PRIMARY KEY,
    ID_PURCHASE INT NOT NULL REFERENCES Purchase(id_pur),
    ID_PRODUCT INT NOT NULL REFERENCES Product(id_pro),
    BATCH VARCHAR(50),
    QUANTITY INT NOT NULL CHECK (QUANTITY > 0),
    UNIT_COST NUMERIC(10,2) NOT NULL,
    ID_STOCK INT REFERENCES Stock(id_sto)
);

-- Linhas de fatura (venda ao cliente)
CREATE TABLE InvoiceLine (
    ID_INVOICE_LINE SERIAL PRIMARY KEY,
    ID_INVOICE INT NOT NULL REFERENCES Invoice(id_inv),
    ID_PRODUCT INT NOT NULL REFERENCES Product(id_pro),
    QUANTITY INT NOT NULL CHECK (QUANTITY > 0),
    UNIT_PRICE NUMERIC(10,2) NOT NULL,
    IVA NUMERIC(5,2) NOT NULL
);

ALTER TABLE "return" ADD COLUMN ID_INVOICE_LINE INT REFERENCES InvoiceLine(ID_INVOICE_LINE);
ALTER TABLE "return" ADD COLUMN QUANTITY_RETURNED INT NOT NULL DEFAULT 1;
-- ALTER TABLE "return" DROP COLUMN reg_dat_ret; -- duplicado
-- ALTER TABLE "return" RENAME COLUMN ina_dat_ret TO RETURN_DATE;