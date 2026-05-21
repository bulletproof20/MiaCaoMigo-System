-- =========================================================
-- QA FIXTURE — RESET SCOPED QA STATE (idempotent preflight)
-- =========================================================
-- TYPE:     fixture (data only)
-- REQUIRES: Bootstrap init_demo (Master + Demo)
-- SCOPE:   QA-tagged rows only; does not truncate Master/Demo tiers
-- =========================================================

-- Close open login sessions used by integrity login tests
update login_record
   set sou_tim_log = current_timestamp
 where ema_log in ('12@miacaomigo.pt', '20@miacaomigo.pt')
   and sou_tim_log is null;

-- Integrity / fixture absence rows
delete from absence
 where mot_abs like 'integrity%'
    or mot_abs like 'qa fixture%';

-- Mod4 deterministic appointments (re-created by 04_Module4 fixture)
delete from appointment_notification
 where id_app in (
     select id_app from appointment where sch_dat_app >= timestamp '2099-01-01'
 );
delete from appointment where sch_dat_app >= timestamp '2099-01-01';
