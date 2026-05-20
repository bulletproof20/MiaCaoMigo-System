-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT (SERVICES)
-- FILE: 02_Animal_Read.sql
-- =========================================================
--
-- Read helpers over Module 2 reporting views.
-- Depends on: vw_internal_animals_available, vw_active_ownership_detail,
--             vw_animal_catalog_detail.
-- =========================================================

drop function if exists fn_list_internal_animals_available();

create function fn_list_internal_animals_available()
returns setof vw_internal_animals_available
language sql
stable
as $$
    select *
    from vw_internal_animals_available
    order by reg_dat_ani desc;
$$;


drop function if exists fn_get_active_ownership_by_animal(int);

create function fn_get_active_ownership_by_animal(p_id_ani int)
returns setof vw_active_ownership_detail
language sql
stable
as $$
    select *
    from vw_active_ownership_detail
    where id_ani = p_id_ani;
$$;


drop function if exists fn_get_animal_catalog_entry(int);

create function fn_get_animal_catalog_entry(p_id_ani int)
returns vw_animal_catalog_detail
language sql
stable
as $$
    select *
    from vw_animal_catalog_detail
    where id_ani = p_id_ani;
$$;
