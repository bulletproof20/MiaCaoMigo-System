-- =========================================================
-- MANUAL TEST — MODULE 1
-- WORKFLOW: Authentication and single-session policy
-- =========================================================
-- PURPOSE:
--   Exercise login_user / logout_user against CreationStress data.
--   Show session state before and after each transition.
--
-- EXPECTED:
--   - Active session blocks second login (12@miacaomigo.pt)
--   - Logout closes session; login succeeds again
--   - Open sessions count <= 1 per email
--
-- REQUIRES: 04_Loaders/03_TestData.sql (02_CreationStress.sql)
-- =========================================================

do $$ begin
    raise notice 'MANUAL M1-01 — Authentication session workflow';
    raise notice '--- BEFORE: open sessions for stress user 12 ---';
end $$;

select ema_log, sig_tim_log, sou_tim_log, suc_log, ip_add_log
from login_record
where ema_log = '12@miacaomigo.pt'
order by sig_tim_log desc
limit 5;

do $$ begin
    raise notice '--- STEP: login while session may be active (expect login_success=false) ---';
end $$;

select *
from login_user(
    '12@miacaomigo.pt',
    '$2b$12$cstress_u12_active',
    '127.0.0.1'::inet
);

do $$ begin
    raise notice '--- STEP: logout ---';
end $$;

select logout_user('12@miacaomigo.pt') as logout_ok;

do $$ begin
    raise notice '--- STEP: login after logout (expect login_success=true) ---';
end $$;

select *
from login_user(
    '12@miacaomigo.pt',
    '$2b$12$cstress_u12_active',
    '127.0.0.1'::inet
);

do $$ begin
    raise notice '--- AFTER: open successful sessions (expect <= 1) ---';
end $$;

select ema_log, count(*) as open_sessions
from login_record
where ema_log = '12@miacaomigo.pt'
  and sou_tim_log is null
  and suc_log = true
group by ema_log;

select logout_user('12@miacaomigo.pt') as cleanup_logout;
