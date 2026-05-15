-- ==============================================================
-- Module 4: APPOINTMENT MANAGEMENT - TESTS
-- ==============================================================
-- This script contains tests for functions and procedures related
-- to appointment management. It assumes that the test data from
-- '01_IntegrityTestSeed.sql' has been loaded.
-- ==============================================================

-- ==============================================================
-- Test Case 1: Appointment Warning Notification
-- ==============================================================
-- Objective: Verify that notifications can be created for clients
-- with an appointment scheduled for the next day.

RAISE NOTICE 'TEST 1: APPOINTMENT WARNING';
RAISE NOTICE ' -> ARRANGE: Deleting previous notifications for client 4.';
DELETE FROM appointment_notification WHERE id_cli = 4;

RAISE NOTICE ' -> ACT: Simulating next-day reminder notification.';
INSERT INTO appointment_notification (id_cli, id_app, msg_not, rea_not)
SELECT a.id_cli,
       a.id_app,
       'Lembrete: O seu animal tem uma consulta agendada para amanhã.',
       false
FROM appointment a
WHERE a.id_cli = 4
  AND date(a.sch_dat_app) = current_date + interval '1 day';

RAISE NOTICE ' -> ASSERT: Verifying that a notification was created for client 4.';
DO $$
DECLARE
    notification_count integer;
BEGIN
    SELECT count(*)
      INTO notification_count
      FROM appointment_notification
     WHERE id_cli = 4
       AND msg_not ilike '%Lembrete: O seu animal tem uma consulta agendada para amanhã%'
       AND rea_not = false;

    IF notification_count >= 1 THEN
        RAISE NOTICE '   -> SUCCESS: Notification for tomorrow''s appointment found for client 4.';
    ELSE
        RAISE WARNING '   -> FAILURE: Expected at least 1 notification for client 4, but found %.', notification_count;
    END IF;
END $$;


-- ==============================================================
-- Test Case 2: Past Appointment Insert
-- ==============================================================
-- Objective: Verify that inserting a scheduled appointment in the past
-- is blocked by business rules (trigger fn_block_past_appointments).

RAISE NOTICE 'TEST 2: PAST APPOINTMENT INSERT';

RAISE NOTICE ' -> ACT: Inserting a scheduled appointment in the past.';
DO $$
BEGIN
    INSERT INTO appointment (id_ani, id_emp, id_cli, id_spe, sch_dat_app, sta_dat_app, end_dat_app, status_app, com_app)
    VALUES (
        1, 1, 4, 1,
        now() - interval '2 days',
        now() - interval '1 day',
        now() - interval '1 day' + interval '1 hour',
        'scheduled',
        'TEST: Past appointment'
    );
    RAISE WARNING '   -> FAILURE: Past appointment insert should have been blocked.';
EXCEPTION
    WHEN others THEN
        IF sqlerrm like '%passado%' THEN
            RAISE NOTICE '   -> SUCCESS: Past appointment blocked (%).', sqlerrm;
        ELSE
            RAISE WARNING '   -> FAILURE: Unexpected error — %', sqlerrm;
        END IF;
END $$;

-- ==============================================================
-- Test Case 3: Diagnostic History Procedure (placeholder)
-- ==============================================================

RAISE NOTICE 'TEST 3: DIAGNOSTIC HISTORY';
RAISE NOTICE '   -> SKIP: legacy diagnostic procedure not part of current schema.';
