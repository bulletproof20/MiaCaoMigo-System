-- =========================================================
-- INTEGRITY — MODULE 2 — DUPLICATE ACTIVE OWNERSHIP
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     sp_assign_ownership + trg_prevent_duplicate_active_ownership
-- CONTRACT: qa_animal_adopted_id, qa_client_secondary_id, qa_registrar_emp_id
-- =========================================================

do $$
declare
    v_ani int := qa_animal_adopted_id();
    v_cli int := qa_client_secondary_id();
    v_emp int := qa_registrar_emp_id();
begin
    call sp_assign_ownership(v_ani, v_cli, v_emp, 'Integrity duplicate adoption attempt');
    raise notice 'FAIL: duplicate ownership should be blocked';
exception
    when others then
        if sqlerrm like '%ownership%'
           or sqlerrm like '%active owner%'
           or sqlerrm like '%Interno%'
           or sqlerrm like '%disponível%'
           or sqlerrm like '%Adotado%' then
            raise notice 'PASS: duplicate ownership blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected duplicate ownership error — %', sqlerrm;
        end if;
end;
$$;
