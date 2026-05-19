-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- =========================================================
-- FILE: 03_Triggers_Mod3.sql (Sincronizado)
-- =========================================================

-- =========================================================
-- Validates sellable quantity against on-hand stock
-- =========================================================
DROP TRIGGER IF EXISTS trg_check_stock_before_sale ON invoice_line;
CREATE TRIGGER trg_check_stock_before_sale
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_check_stock_before_sale();

-- =========================================================
-- Applies FIFO stock withdrawal after each sale line
-- =========================================================
DROP TRIGGER IF EXISTS trg_stock_after_sale ON invoice_line;
CREATE TRIGGER trg_stock_after_sale
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_stock_after_sale();

-- =========================================================
-- Keeps invoice totals in sync with line changes
-- =========================================================
DROP TRIGGER IF EXISTS trg_update_invoice_total ON invoice_line;
CREATE TRIGGER trg_update_invoice_total
AFTER INSERT OR UPDATE OR DELETE ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_update_invoice_total();

-- =========================================================
-- Replenishes stock when a customer return is posted
-- =========================================================
DROP TRIGGER IF EXISTS trg_return_restock ON "return";
CREATE TRIGGER trg_return_restock
AFTER INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION fn_return_restock();

-- =========================================================
-- Blocks invoice lines for inactive catalog items
-- =========================================================
DROP TRIGGER IF EXISTS trg_prevent_inactive_product_sale ON invoice_line;
CREATE TRIGGER trg_prevent_inactive_product_sale
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_prevent_inactive_product_sale();

-- =========================================================
-- Defaults return closure metadata when omitted
-- =========================================================
DROP TRIGGER IF EXISTS trg_set_return_return_date ON "return";
CREATE TRIGGER trg_set_return_return_date
BEFORE INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION fn_set_return_date();

-- =========================================================
-- Raises notice for low stock thresholds after entry
-- =========================================================
DROP TRIGGER IF EXISTS trg_warn_low_stock ON invoice_line;
CREATE TRIGGER trg_warn_low_stock
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_warn_low_stock();