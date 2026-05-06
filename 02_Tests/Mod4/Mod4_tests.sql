--  ==============================================================
--  Module 4 appointment tests - APPOINTMENT MANAGEMENT
--  ==============================================================

-- Trying to insert an appointment in the past, which should be allowed but will trigger a warning when the function is executed
INSERT INTO appointment (id_animal, id_emp, id_cli, sch_dat_app, sta_dat_app, end_dat_app, status_app, com_app)
VALUES (1, 1, 4, NOW() - INTERVAL '2 days', NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day' + INTERVAL '1 hour', 'Scheduled', 'TEST: Past appointment');
