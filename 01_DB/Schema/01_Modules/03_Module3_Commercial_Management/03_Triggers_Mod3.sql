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

CREATE TRIGGER trg_check_stock_before_sale
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_check_stock_before_sale();


-- =========================================================
-- Applies FIFO stock withdrawal after each sale line
-- =========================================================

CREATE TRIGGER trg_stock_after_sale
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_stock_after_sale();


-- =========================================================
-- Keeps invoice totals in sync with line changes
-- =========================================================

CREATE TRIGGER trg_update_invoice_total
AFTER INSERT OR UPDATE OR DELETE ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_update_invoice_total();

-- =========================================================
-- Replenishes stock when a customer return is posted
-- =========================================================

CREATE TRIGGER trg_return_restock
AFTER INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION fn_return_restock();


-- =========================================================
-- Blocks invoice lines for inactive catalog items
-- =========================================================

CREATE TRIGGER trg_prevent_inactive_product_sale
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_prevent_inactive_product_sale();


-- =========================================================
-- Defaults return closure metadata when omitted
-- =========================================================

CREATE TRIGGER trg_set_return_return_date
BEFORE INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION fn_set_return_inactivation_date();
