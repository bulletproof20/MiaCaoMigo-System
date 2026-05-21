-- =========================================================
-- QA CLEANUP — integrity absences tagged for clocking tests
-- =========================================================

delete from absence
where mot_abs like 'integrity absence%';
