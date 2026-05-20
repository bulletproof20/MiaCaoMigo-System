-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
-- =========================================================
-- FILE: 07_Views_Mod3.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Reporting views for catalog, stock levels, and procurement.
-- Relies on fn_get_available_stock for consolidated quantities.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - 02_Functions_Mod3.sql (fn_get_available_stock)
-- - product, family, stock tables
--
-- Must load before:
-- - 05_Procedures_Mod3.sql (sp_check_restock_needs)
-- =========================================================

-- =========================================================
-- Products at or below minimum stock (reorder candidates)
-- =========================================================
-- Entities: product, family
-- Purpose: procurement and sp_check_restock_needs monitoring
drop view if exists vw_produtos_para_encomendar;
drop view if exists vw_products_to_reorder;

create view vw_products_to_reorder as
select
    p.id_pro,
    p.nam_pro,
    f.nam_fam,
    fn_get_available_stock(p.id_pro) as qty_available,
    p.min_sto,
    (p.min_sto * 2) - fn_get_available_stock(p.id_pro) as qty_reorder_suggestion
from product p
inner join family f on f.id_fam = p.id_fam
where fn_get_available_stock(p.id_pro) <= p.min_sto
  and p.ina_dat_pro is null;


-- =========================================================
-- Active catalog with consolidated stock per product
-- =========================================================
-- Entities: product, family
-- Purpose: inventory dashboards and commercial reporting

drop view if exists vw_product_stock_levels;

create view vw_product_stock_levels as
select
    p.id_pro,
    p.ref_pro,
    p.bar_pro,
    p.nam_pro,
    f.id_fam,
    f.nam_fam,
    p.pri_pro,
    p.iva_pro,
    p.min_sto,
    fn_get_available_stock(p.id_pro) as qty_available,
    p.reg_dat_pro,
    p.ina_dat_pro
from product p
inner join family f on f.id_fam = p.id_fam
where p.ina_dat_pro is null;
