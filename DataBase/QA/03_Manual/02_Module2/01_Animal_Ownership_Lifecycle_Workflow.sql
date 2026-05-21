-- =========================================================
-- MANUAL TEST — MODULE 2
-- WORKFLOW: Animal registration and ownership lifecycle
-- =========================================================
-- PURPOSE:
--   sp_register_animal, fn_register_adoption, views, sp_end_ownership.
--
-- EXPECTED:
--   - New internal animal registered
--   - Adoption assigns active ownership (animal 5 — reset to Interno first)
--   - vw_active_ownership_detail / fn_get_animal_history reflect trail
--
-- REQUIRES: 04_Loaders/03_TestData.sql (id_cli 4, id_emp 1)
-- =========================================================

do $$ begin
    raise notice 'MANUAL M2-01 — Animal and ownership lifecycle';
end $$;

call sp_register_animal(
    'MANUAL-ANI-001',
    'Manual Workflow Dog',
    '2023-01-15',
    'M',
    'Entrega',
    'Interno',
    1,
    1
);

select * from fn_list_internal_animals_available()
where reg_id_ani = 'MANUAL-ANI-001';

do $$ begin
    raise notice '--- Reset animal 5 for adoption demo ---';
end $$;

update animal set sta_ani = 'Interno' where id_ani = 5;
update ownership set end_dat_own = current_date, mot_own = 'manual reset'
 where id_ani = 5 and end_dat_own is null;

select fn_register_adoption(4, 5, 1, 'manual qa adoption') as adoption_call;

select * from vw_active_ownership_detail where id_ani = 5;

select * from fn_get_animal_history(5);

select * from fn_get_active_ownership_by_animal(5);

call sp_end_ownership(5, 'manual qa end ownership');

do $$ begin
    raise notice '--- AFTER end_ownership: animal status and active ownership ---';
end $$;

select sta_ani, id_ani from animal where id_ani = 5;

select * from vw_active_ownership_detail where id_ani = 5;

select * from fn_get_animal_history(5);
