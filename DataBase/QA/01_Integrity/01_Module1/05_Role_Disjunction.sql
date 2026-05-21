-- =========================================================
-- INTEGRITY — MODULE 1 — ROLE DISJUNCTION (ASSISTANT / VET)
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/01_Module1/01_Core_Context.sql
-- RULE:     trg_block_assistant_disjunction / trg_block_veterinarian_disjunction
-- CONTRACT: qa_vet_primary_id
-- =========================================================
-- expected:
-- - cannot assign same employee as assistant when already veterinarian
-- =========================================================

do $$
begin
    insert into assistant (id_emp, fun_ass)
    values (qa_vet_primary_id(), 'integrity disjunction test');

    raise notice 'FAIL: assistant on veterinarian employee should be blocked';
exception
    when others then
        if sqlerrm like '%assistant%' or sqlerrm like '%veterinarian%' then
            raise notice 'PASS: assistant/veterinarian disjunction blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected role disjunction error — %', sqlerrm;
        end if;
end;
$$;
