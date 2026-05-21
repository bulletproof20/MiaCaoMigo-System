-- =========================================================
-- INTEGRITY — MODULE 1 — SCHEDULE EXCLUSION
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/01_Module1/01_Core_Context.sql + Bootstrap Master (1@miacaomigo.pt)
-- RULE:     ex_schedule_overlap (GiST on schedule)
-- FIXTURES: bootstrap admin schedule Monday 08:00-18:00
-- =========================================================
-- expected:
-- - overlapping schedule interval for same employee/day blocked
-- =========================================================

do $$
begin
    insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch)
    values (1, 1, '10:00', '12:00');

    raise notice 'FAIL: overlapping schedule should be blocked';
exception
    when others then
        if sqlerrm like '%overlap%' or sqlerrm like '%ex_schedule%' or sqlerrm like '%conflict%' then
            raise notice 'PASS: schedule overlap blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected schedule exclusion error — %', sqlerrm;
        end if;
end;
$$;
