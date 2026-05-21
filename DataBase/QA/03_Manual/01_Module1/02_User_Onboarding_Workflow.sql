-- =========================================================
-- MANUAL TEST — MODULE 1
-- WORKFLOW: Client onboarding (fn_create_client)
-- =========================================================
-- PURPOSE:
--   Create a new client identity and verify user_account + client rows.
--
-- EXPECTED:
--   - fn_create_client returns new id_cli
--   - setup row created by trigger
--   - identity visible in user/client joins
--
-- REQUIRES: TestData + registrar id_emp 1 active
-- =========================================================

do $$
declare
    v_email varchar := 'manual.qa.cliente.' || floor(extract(epoch from clock_timestamp()))::text || '@gmail.com';
    v_nif varchar := '629' || lpad((floor(random() * 999999)::int)::text, 6, '0');
    v_id_cli int;
begin
    raise notice 'MANUAL M1-02 — User onboarding (new client)';
    raise notice 'Using email: %', v_email;

    v_id_cli := fn_create_client(
        'Manual QA Cliente',
        'Rua Manual 1, Braga',
        '4700-200',
        v_nif,
        '+351910000777',
        v_email,
        '$2b$12$manual_qa_client_hash_001'
    );

    raise notice 'Created id_cli=%', v_id_cli;
    raise notice '--- VERIFY: user + client + setup ---';

    perform u.id_usr
    from user_account u
    join client c on c.id_usr = u.id_usr
    join setup s on s.id_usr = u.id_usr
    where u.ema_usr = v_email;
end $$;

select
    u.id_usr,
    u.nam_usr,
    u.ema_usr,
    c.id_cli,
    s.the_set,
    s.lan_set
from user_account u
join client c on c.id_usr = u.id_usr
join setup s on s.id_usr = u.id_usr
where u.ema_usr like 'manual.qa.cliente.%@gmail.com'
order by c.id_cli desc
limit 1;
