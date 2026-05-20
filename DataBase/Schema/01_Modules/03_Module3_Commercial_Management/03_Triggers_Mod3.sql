-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- =========================================================
-- FILE: 03_Triggers_Mod3.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Table-level triggers orchestrating stock checks, invoice totals,
-- returns, and inactive-product guards for commercial flows.
--
-- This file contains:
-- - invoice_line BEFORE/AFTER hooks for stock and pricing
-- - return-table hooks for replenishment and metadata defaults
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 02_Functions_Mod3.sql (all referenced functions)
-- - product, stock, invoice, invoice_line, return tables
--
-- Must load before:
-- - Scheduled jobs or procedures that assume triggers are active
-- =========================================================

-- =========================================================
-- Validates sellable quantity against on-hand stock
-- =========================================================

drop trigger if exists trg_check_stock_before_sale on invoice_line;

create trigger trg_check_stock_before_sale
before insert on invoice_line
for each row
execute function fn_check_stock_before_sale();


-- =========================================================
-- Applies FIFO stock withdrawal after each sale line
-- =========================================================

drop trigger if exists trg_stock_after_sale on invoice_line;

create trigger trg_stock_after_sale
after insert on invoice_line
for each row
execute function fn_stock_after_sale();


-- =========================================================
-- Keeps invoice totals in sync with line changes
-- =========================================================

drop trigger if exists trg_update_invoice_total on invoice_line;

create trigger trg_update_invoice_total
after insert or update or delete on invoice_line
for each row
execute function fn_update_invoice_total();


-- =========================================================
-- Replenishes stock when a customer return is posted
-- =========================================================

drop trigger if exists trg_return_restock on "return";

create trigger trg_return_restock
after insert on "return"
for each row
execute function fn_return_restock();


-- =========================================================
-- Blocks invoice lines for inactive catalog items
-- =========================================================

drop trigger if exists trg_prevent_inactive_product_sale on invoice_line;

create trigger trg_prevent_inactive_product_sale
before insert on invoice_line
for each row
execute function fn_prevent_inactive_product_sale();


-- =========================================================
-- Defaults return closure metadata when omitted
-- =========================================================

drop trigger if exists trg_set_return_return_date on "return";

create trigger trg_set_return_return_date
before insert on "return"
for each row
execute function fn_set_return_inactivation_date();


-- =========================================================
-- Raises notice for low stock thresholds after entry
-- =========================================================

drop trigger if exists trg_warn_low_stock on invoice_line;

create trigger trg_warn_low_stock
after insert on invoice_line
for each row
execute function fn_warn_low_stock();
