-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT (SERVICES)
-- FILE: 02_Inventory_Read.sql
-- =========================================================
--
-- Read helpers over Module 3 reporting views.
-- Depends on: vw_product_stock_levels, vw_products_to_reorder.
-- =========================================================

drop function if exists fn_list_product_stock_levels();

create function fn_list_product_stock_levels()
returns setof vw_product_stock_levels
language sql
stable
as $$
    select *
    from vw_product_stock_levels
    order by nam_pro;
$$;


drop function if exists fn_list_products_to_reorder();

create function fn_list_products_to_reorder()
returns setof vw_products_to_reorder
language sql
stable
as $$
    select *
    from vw_products_to_reorder
    order by min_sto desc;
$$;


drop function if exists fn_get_product_stock_level(int);

create function fn_get_product_stock_level(p_id_pro int)
returns vw_product_stock_levels
language sql
stable
as $$
    select *
    from vw_product_stock_levels
    where id_pro = p_id_pro;
$$;
