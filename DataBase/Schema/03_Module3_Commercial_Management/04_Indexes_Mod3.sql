-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod3.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Targeted B-tree indexes for stock FIFO, billing line aggregates,
-- and catalog reporting. No duplicate coverage of primary keys.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 00_Tables_Mod3.sql, 01_ForeignKeys_Mod3.sql
-- - 02_Functions_Mod3.sql (fn_get_available_stock)
-- =========================================================

drop index if exists ix_stock_id_pro;
drop index if exists ix_purchase_line_id_pur;
drop index if exists ix_invoice_line_id_inv;


-- =========================================================
-- STOCK — availability and FIFO scans by product
-- =========================================================
-- Optimizes:
--   - fn_get_available_stock
--   - fn_stock_after_sale (qty_sto > 0, order by val_dat_sto)
--   - vw_product_stock_levels / vw_products_to_reorder
--
-- High-frequency filter: stock.id_pro with positive quantities.
-- =========================================================

create index ix_stock_id_pro
on stock (id_pro);


-- =========================================================
-- OPERATIONAL — purchase line aggregation
-- =========================================================
-- Optimizes:
--   - sp_receive_purchase (lines by id_pur)
--   - purchase total maintenance patterns
--
-- Supports nested lookups from purchase header to lines.
-- =========================================================

create index ix_purchase_line_id_pur
on purchase_line (id_pur);


-- =========================================================
-- OPERATIONAL — invoice line aggregation
-- =========================================================
-- Optimizes:
--   - fn_update_invoice_total
--   - invoice line triggers (insert/update/delete)
--
-- Supports recalculating invoice.val_inv from child rows.
-- =========================================================

create index ix_invoice_line_id_inv
on invoice_line (id_inv);
