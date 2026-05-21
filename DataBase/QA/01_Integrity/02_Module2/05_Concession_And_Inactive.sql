-- =========================================================
-- INTEGRITY — MODULE 2 — CONCESSION / INACTIVE OWNERSHIP
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     sp_process_concession; fn_block_ownership_if_animal_inactive
-- CONTRACT: qa_animal_adopted_id, qa_registrar_emp_id, qa_client_secondary_id
-- =========================================================
-- expected:
-- - concession on adopted animal blocked
-- - direct ownership insert on adopted animal blocked
-- =========================================================

-- TEST 01 — concession on adopted animal
do $$
begin
    call sp_process_concession(
        qa_animal_adopted_id(),
        qa_registrar_emp_id(),
        qa_registrar_emp_id(),
        'Integrity concession test',
        'OK'
    );
    raise notice 'FAIL: concession on adopted animal should be blocked';
exception
    when others then
        if sqlerrm like '%adotado%' or sqlerrm like '%Adotado%' then
            raise notice 'PASS: concession on adopted animal blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected concession error — %', sqlerrm;
        end if;
end;
$$;

-- TEST 02 — ownership insert on inactive/adopted animal
do $$
begin
    insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, mot_own)
    values (
        qa_client_secondary_id(),
        qa_animal_adopted_id(),
        qa_registrar_emp_id(),
        current_date,
        'Integrity direct ownership'
    );

    raise notice 'FAIL: ownership on adopted animal should be blocked';
exception
    when others then
        if sqlerrm like '%inactive%' or sqlerrm like '%ownership%' or sqlerrm like '%Adotado%' then
            raise notice 'PASS: ownership on adopted animal blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected inactive ownership error — %', sqlerrm;
        end if;
end;
$$;
