-- =========================================================
-- INTEGRITY — MODULE 1 — EMAIL / NIF UNIQUENESS
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql (CreationStress)
-- RULE:     uq_ema_usr, uq_nif_usr on user_account
-- =========================================================
-- expected:
-- - duplicate email insert blocked (unique_violation)
-- - duplicate NIF insert blocked (unique_violation)
-- =========================================================

-- TEST 01 — duplicate email
do $$
begin
    insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
    values (
        'Integrity Duplicate Email',
        'Rua Teste 1',
        '4700-000',
        '999000001',
        '+351910999001',
        'goncalo.pratas.cstress@gmail.com'
    );
    raise notice 'FAIL: duplicate email should be blocked';
exception
    when unique_violation then
        raise notice 'PASS: duplicate email blocked — %', sqlerrm;
    when others then
        raise notice 'FAIL: unexpected error on duplicate email — %', sqlerrm;
end;
$$;

-- TEST 02 — duplicate NIF
do $$
begin
    insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
    values (
        'Integrity Duplicate NIF',
        'Rua Teste 2',
        '4700-001',
        '610000020',
        '+351910999002',
        'integrity.duplicate.nif@pessoal.com'
    );
    raise notice 'FAIL: duplicate NIF should be blocked';
exception
    when unique_violation then
        raise notice 'PASS: duplicate NIF blocked — %', sqlerrm;
    when others then
        raise notice 'FAIL: unexpected error on duplicate NIF — %', sqlerrm;
end;
$$;
