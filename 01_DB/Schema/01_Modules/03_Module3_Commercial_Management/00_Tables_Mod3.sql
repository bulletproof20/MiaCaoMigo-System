-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- File: 00_Tables_Mod3.sql (tables only)
-- =========================================================
--
-- DESCRIPTION
-- Product catalog, stock, purchases, returns, and associative
-- links to employees. Purchase workflow state uses purchase_status
-- (see 00_Core/01_Types.sql).
--
-- FOREIGN KEYS
-- Deferred to 01_ForeignKeys_Mod3.sql after all module tables exist.
-- =========================================================




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

    
    min_sto INT NOT NULL DEFAULT 5,
    -- Minimum stock level,


    constraint pk_product primary key (id_pro)
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

    constraint ck_qty_sto
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

    pur_dat_pur timestamp default current_timestamp,
    -- Purchase date

    tot_val_pur numeric(10,2),
    -- Total value

    ord_num_pur varchar(50),
    -- Order number

    pay_met_pur varchar(50),
    -- Payment method

    sta_pur purchase_status,
    -- Workflow state (purchase_status enum; nullable until confirmed)

    id_inv int,
    -- Linked invoice (see FK phase)
    
    sta_pur varchar(50) default 'pending',
    -- Status

    id_cli int,
    -- client

    id_emp int,
    -- Employee responsible

    constraint pk_purchase primary key (id_pur)
    -- Unique identifier
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

    constraint ck_qty_pln
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

    constraint ck_qty_inv_lin
    check (qty_inv_lin > 0)
);

--=========================================================
-- 8. RETURN
--=========================================================
-- Represents product return operations
create table return (
    id_ret int generated always as identity,
    -- Return identifier

    mot_ret varchar(100),
    -- Reason

    reg_dat_ret timestamp not null default current_timestamp,
    -- Registration date

    ina_dat_ret timestamp,
    -- Inactivation / closing date

    id_inv_lin int,
    -- Optional link to originating invoice line

    qty_ret int not null default 1,
    -- Quantity returned (replaces legacy qty_ret)
    return_date timestamp,
    
    id_invLine int,
    -- Invoice line (if return is related to a sale)

    quant_ret int NOT NULL DEFAULT 1,
    -- Quantity returned

    constraint pk_return primary key (id_ret),
    -- Unique identifier

    constraint fk_return_invoice_line foreign key (id_invLine) references InvoiceLine(id_invoice_line)
        on DELETE set null,
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

    constraint ck_qty_purchase
    check (qty_pur_pro > 0)
    -- Ensures valid quantity
);

