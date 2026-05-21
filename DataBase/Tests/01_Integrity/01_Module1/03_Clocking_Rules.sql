-- =========================================================
-- INTEGRITY — MODULE 1 — CLOCKING RULES
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     fn_block_clock_in_if_absent; uq_clock_in_active_per_employee;
--           fn_block_inactivate_if_clock_active
-- CONTRACT: qa_registrar_emp_id, qa_emp_clockable_id
-- =========================================================
-- expected:
-- - clock-in during absence blocked
-- - second open clock-in blocked
-- - inactivation with open clock-in blocked
-- =========================================================

-- TEST 01 — clock-in during absence
do $$
declare
    v_emp_reg int := qa_registrar_emp_id();
begin
    insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs, cre_tim_abs)
    values (
        v_emp_reg,
        current_timestamp - interval '1 hour',
        current_timestamp + interval '2 hours',
        'integrity absence overlap clock-in',
        'approved',
        current_timestamp
    );

    insert into clock_in (id_emp, sta_dat_clk)
    values (v_emp_reg, current_timestamp);

    raise notice 'FAIL: clock-in during absence should be blocked';
exception
    when others then
        if sqlerrm like '%absence%' or sqlerrm like '%clock in%' then
            raise notice 'PASS: clock-in during absence blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected clock-in/absence error — %', sqlerrm;
        end if;
end;
$$;

-- TEST 02 — duplicate open clock-in (unique partial index)
do $$
declare
    v_emp_clk int := qa_emp_clockable_id();
begin
    insert into clock_in (id_emp, sta_dat_clk)
    values (v_emp_clk, current_timestamp);

    raise notice 'FAIL: duplicate open clock-in should be blocked';
exception
    when unique_violation then
        raise notice 'PASS: duplicate open clock-in blocked — %', sqlerrm;
    when others then
        raise notice 'FAIL: unexpected duplicate clock-in error — %', sqlerrm;
end;
$$;

-- TEST 03 — inactivate employee with open clock-in
do $$
declare
    v_emp_clk int := qa_emp_clockable_id();
begin
    update employee
       set dea_dat_emp = current_timestamp
     where id_emp = v_emp_clk;

    raise notice 'FAIL: inactivation with open clock-in should be blocked';
exception
    when others then
        if sqlerrm like '%clock-in%' or sqlerrm like '%clock in%' then
            raise notice 'PASS: inactivation with open clock-in blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected inactivation error — %', sqlerrm;
        end if;
end;
$$;

delete from absence where mot_abs like 'integrity absence%';
