-- =========================================================
-- MANUAL TEST — MODULE 2
-- WORKFLOW: Delivery team and external concession
-- =========================================================
-- PURPOSE:
--   fn_register_delivery_team, sp_process_concession, catalog views.
--
-- EXPECTED:
--   - Delivery recorded with employee team
--   - Concession row for external entity
--   - History merges ownership + concession events
--
-- REQUIRES: TestData (animal 1 internal, entity 1, emp 1-3)
-- =========================================================

do $$ begin
    raise notice 'MANUAL M2-02 — Delivery and concession';
end $$;

select fn_register_delivery_team(
    1,
    1,
    'Manual QA — local de entrega',
    'Recuperado',
    array[1, 2]
) as delivery_registered;

select
    d.id_del,
    a.nam_ani,
    d.res_loc_del,
    d.cli_sta_del
from delivery d
join animal a on a.id_ani = d.id_ani
where a.id_ani = 1
order by d.id_del desc
limit 3;

call sp_process_concession(
    4,
    2,
    1,
    'manual qa concession to supplier',
    'Estavel'
);

select * from fn_get_animal_history(4);

select * from fn_get_animal_catalog_entry(4);
