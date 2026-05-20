-- =========================================================
-- comments: views - module 3
-- =========================================================

comment on view vw_produtos_para_encomendar is
'active products at or below minimum stock; consumed by sp_check_restock_needs';

comment on view vw_product_stock_levels is
'active catalog products with family metadata and consolidated available quantity';
