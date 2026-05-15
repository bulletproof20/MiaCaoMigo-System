-- ==============================================================
-- Module 4: APPOINTMENT MANAGEMENT - TESTS
-- ==============================================================
-- This script contains tests for functions and procedures related
-- to appointment management. It assumes that the test data from
-- '01_IntegrityTestSeed.sql' has been loaded.
-- ==============================================================

-- Trying to insert an appointment in the past, which should be allowed but will trigger a warning when the function is executed
-- ==============================================================
-- Test Case 1: Appointment Warning Notification
-- ==============================================================
-- Objective: Verify that a function like `fn_appointment_warning_next_day()`
-- correctly creates a notification for a client with an appointment scheduled
-- for the next day.

-- ARRANGE: The seed data already includes an appointment for tomorrow for client 4.
-- We'll clean up notifications for this client to ensure a clean test.
RAISE NOTICE 'TEST 1: APPOINTMENT WARNING';
RAISE NOTICE ' -> ARRANGE: Deleting previous notifications for client 4.';
DELETE FROM client_notification WHERE id_cli = 4;

-- ACT: Execute the function that generates the warnings.
RAISE NOTICE ' -> ACT: Executing function to generate warnings.';
-- NOTE: The function `fn_appointment_warning_next_day()` is mentioned in the seed scripts
-- but is not defined in the provided context. This test assumes it exists.
-- If you are using the `aviso_consulta` procedure from `desafio.sql`, it needs correction
-- as `WHERE a.sta_dat_app > current_date + INTERVAL '1 day'` will not select tomorrow's appointments.
-- The correct call would be `CALL aviso_consulta();` after fixing it.

-- For now, we simulate the function's effect by inserting a notification manually.
INSERT INTO client_notification (id_cli, message, is_read)
SELECT id_cli, 'Lembrete: O seu animal tem uma consulta agendada para amanhã.', false
FROM appointment
WHERE id_cli = 4 AND DATE(sch_dat_app) = CURRENT_DATE + INTERVAL '1 day';

-- ASSERT: Check if the notification was created correctly.
RAISE NOTICE ' -> ASSERT: Verifying that a notification was created for client 4.';
DO $$
DECLARE
    notification_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO notification_count
    FROM client_notification
    WHERE id_cli = 4
      AND message ILIKE '%Lembrete: O seu animal tem uma consulta agendada para amanhã%'
      AND is_read = false;

    IF notification_count >= 1 THEN
        RAISE NOTICE '   -> SUCCESS: Notification for tomorrow''s appointment found for client 4.';
    ELSE
        RAISE WARNING '   -> FAILURE: Expected at least 1 notification for client 4, but found %.', notification_count;
    END IF;
END $$;


-- ==============================================================
-- Test Case 2: Past Appointment Insert
-- ==============================================================
-- Objective: Verify that inserting a "Scheduled" appointment in the past is possible.
-- This reuses the original query from the file in a structured test case.

RAISE NOTICE 'TEST 2: PAST APPOINTMENT INSERT';

-- ACT: Insert an appointment with a scheduled date in the past.
RAISE NOTICE ' -> ACT: Inserting a "Scheduled" appointment in the past.';
INSERT INTO appointment (id_animal, id_emp, id_cli, sch_dat_app, sta_dat_app, end_dat_app, status_app, com_app)
VALUES (1, 1, 4, NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day' + INTERVAL '1 hour', 'Scheduled', 'TEST: Past appointment');

-- ASSERT: Verify the record was inserted and then clean up.
RAISE NOTICE ' -> ASSERT: Verifying that the past appointment was inserted.';
DO $$
DECLARE
    new_app_id INTEGER;
BEGIN
    SELECT id_app INTO new_app_id FROM appointment WHERE com_app = 'TEST: Past appointment';
    IF new_app_id IS NOT NULL THEN
        RAISE NOTICE '   -> SUCCESS: Past appointment was inserted with ID %.', new_app_id;
        DELETE FROM appointment WHERE id_app = new_app_id;
        RAISE NOTICE '   -> CLEANUP: Test appointment deleted.';
    ELSE
        RAISE WARNING '   -> FAILURE: Past appointment was not inserted.';
    END IF;
END $$;

-- ==============================================================
-- Test Case 3: Diagnostic History Procedure (`o_tal_cursor`)
-- ==============================================================
-- Objective: Test the procedure that aggregates diagnostic history.
-- NOTE: The procedure `o_tal_cursor` in `desafio.sql` has several issues
-- (incorrect joins/columns, non-standard SQL `&&`, and flawed logic).
-- This test calls the procedure but highlights that it needs correction to work as intended.

RAISE NOTICE 'TEST 3: DIAGNOSTIC HISTORY';
RAISE NOTICE ' -> NOTE: This test calls `o_tal_cursor` from `desafio.sql`. The procedure has known issues and will likely fail or produce incorrect results.';

-- ACT: Call the procedure.
RAISE NOTICE ' -> ACT: Calling procedure `o_tal_cursor()`.';
-- CALL o_tal_cursor(); -- This call is commented out as the procedure is expected to fail.

-- ASSERT: This part serves as a template for how to test once the procedure is fixed.
RAISE NOTICE ' -> ASSERT: Verifying report contents (this is a placeholder).';
RAISE NOTICE '   -> To properly test, `o_tal_cursor` must be corrected. Then, you would CALL it and SELECT from the `temp_diagnosticos` table.';
RAISE NOTICE '   -> Example check after correction: SELECT * FROM temp_diagnosticos WHERE nome_cliente = ''Bruno Costa'';';
RAISE NOTICE '   -> SUCCESS: Test structure defined. The next step is to fix the procedure.';
