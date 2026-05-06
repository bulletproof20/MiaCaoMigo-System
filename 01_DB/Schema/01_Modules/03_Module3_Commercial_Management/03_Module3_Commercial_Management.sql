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

-- Associative tables
drop table if exists employee_return cascade;
drop table if exists employee_purchase cascade;
drop table if exists return_product cascade;
drop table if exists purchase_product cascade;

-- Dependent entities
drop table if exists "return" cascade;
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

    constraint pk_invoice primary key (id_inv),
    -- Unique identifier

    constraint fk_invoice_appointment foreign key (id_app)
        references appointment(id_app)
        on delete set null
    -- Links to appointment
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

    id_fam int NOT NULL,
    -- Family

    id_ret int,
    -- Last return

    constraint pk_product primary key (id_pro),
    -- Unique identifier

    constraint fk_product_family foreign key (id_fam) references family(id_fam)
        on delete set null,
    -- Links product to family
    constraint fk_product_family foreign key (id_fam) references family(id_fam) on delete set null
    -- Links product to family. Outras FKs serão adicionadas no final.

    constraint fk_purchase_product foreign key(id_pur) references purchase(id_pur)
          on delete set null,
    --on delete set null because if the purchase is deleted for any reason, 
    --the product should not be deleted, removed from the catalog 
    --and the stock of that product should not be affected

    constraint fk_stock foreign key(id_sto) references stock(id_sto)
            on delete set null,


    constraint fk_return foreign key (id_ret) references "return"(id_ret)
        on delete set null


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

    alter table stock
    add constraint fk_stock_product
    foreign key (id_pro)
    references product(id_pro)
    on delete cascade;

    
-- this constraint had to be added via alter table after creating the stock table to prevent an error during the creation of the product table.

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
    -- Supplier

    id_cli int,
    -- client

    id_emp int,
    -- Employee responsible

    constraint pk_purchase primary key (id_pur),
    -- Unique identifier

    constraint fk_invoice foreign key (id_inv) references invoice(id_inv)
        on DELETE cascade,
    -- Links to supplier

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
create table "return" (
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
-- 7. ASSOCIATIVE TABLES
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
        references "return"(id_ret)
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
        references "return"(id_ret)
        on delete cascade
);





-- Linhas de compra (junta Product, Purchase, Stock)
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

-- Melhorar a tabela Return para ligar à linha da fatura
ALTER TABLE "return" ADD COLUMN ID_INVOICE_LINE INT REFERENCES InvoiceLine(ID_INVOICE_LINE);
ALTER TABLE "return" ADD COLUMN QUANTITY_RETURNED INT NOT NULL DEFAULT 1;
ALTER TABLE "return" DROP COLUMN reg_dat_ret; -- duplicado
ALTER TABLE "return" RENAME COLUMN ina_dat_ret TO RETURN_DATE;

-- =========================================================
-- 8. ADICIONAR CONSTRAINTS ADIADAS
-- (Resolve as dependências circulares com a tabela 'product')
-- =========================================================

ALTER TABLE product
ADD CONSTRAINT fk_purchase_product
FOREIGN KEY(id_pur) REFERENCES purchase(id_pur)
ON DELETE SET NULL;

ALTER TABLE product
ADD CONSTRAINT fk_stock
FOREIGN KEY(id_sto) REFERENCES stock(id_sto)
ON DELETE SET NULL;

ALTER TABLE product
ADD CONSTRAINT fk_return
FOREIGN KEY (id_ret) REFERENCES "return"(id_ret)
ON DELETE SET NULL;