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
-- Note: legacy name retained for procedure compatibility

drop view if exists vw_produtos_para_encomendar;

create view vw_produtos_para_encomendar as
select
    p.id_pro as id,
    p.nam_pro as produto,
    f.nam_fam as familia,
    fn_get_available_stock(p.id_pro) as stock_atual,
    p.min_sto as stock_minimo,
    (p.min_sto * 2) - fn_get_available_stock(p.id_pro) as sugestao_encomenda
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
