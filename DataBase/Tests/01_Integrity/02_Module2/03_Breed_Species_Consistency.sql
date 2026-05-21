-- =========================================================
-- INTEGRITY — MODULE 2 — BREED / SPECIES CONSISTENCY
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     trg_validate_animal_breed_species
-- CONTRACT: qa_animal_stress_internal_id; breed 3 (cat) vs species 1 (dog)
-- =========================================================
-- expected:
-- - breed not belonging to species blocked on update
-- =========================================================

do $$
begin
    update animal
       set id_bre = 3
     where id_ani = qa_animal_stress_internal_id();

    raise notice 'FAIL: breed/species mismatch should be blocked';
exception
    when others then
        if sqlerrm like '%Breed%' or sqlerrm like '%species%' or sqlerrm like '%Consistency%' then
            raise notice 'PASS: breed/species inconsistency blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected breed/species error — %', sqlerrm;
        end if;
end;
$$;
