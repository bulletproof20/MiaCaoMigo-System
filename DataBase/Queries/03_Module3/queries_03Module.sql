-- =========================================================
-- QUERIES — MODULE 3 (API REFERENCE)
-- =========================================================
-- DEPRECATED: prefer Services/03_Module3/02_Inventory_Read.sql
-- Canonical columns: id_inv, id_pro, qty_inv_lin, id_pur, id_pur_lin.
-- =========================================================

select * from vw_products_to_reorder
order by stock_minimo desc;

select * from vw_product_stock_levels
order by nam_pro;

-- Example: trigger restock check (schema procedure)
-- call sp_check_restock_needs();
