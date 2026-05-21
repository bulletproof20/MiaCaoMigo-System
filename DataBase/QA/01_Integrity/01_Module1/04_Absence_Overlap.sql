-- =========================================================
-- INTEGRITY — MODULE 1 — ABSENCE OVERLAP
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/01_Module1/01_Core_Context.sql
-- RULE:     trg_block_absence_overlap_by_user / fn_block_absence_overlap_by_user
-- CONTRACT: qa_emp_absence_overlap_id (pending absence +15 to +16 days)
-- =========================================================
-- expected:
-- - overlapping absence for same employee blocked
-- =========================================================

do $$
declare
    v_emp int := qa_emp_absence_overlap_id();
begin
    insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs, cre_tim_abs)
    values (
        v_emp,
        current_timestamp + interval '15 days 2 hours',
        current_timestamp + interval '15 days 8 hours',
        'integrity overlapping absence',
        'pending',
        current_timestamp
    );

    raise notice 'FAIL: overlapping absence should be blocked';
exception
    when others then
        if sqlerrm like '%overlapping%' or sqlerrm like '%absence%' then
            raise notice 'PASS: overlapping absence blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected absence overlap error — %', sqlerrm;
        end if;
end;
$$;
