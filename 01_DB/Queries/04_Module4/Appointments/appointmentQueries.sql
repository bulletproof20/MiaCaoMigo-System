--=========================================================
-- QUERIES - MODULE 4
-- This file contains a set of useful SELECT queries for retrieving
-- data related to appointment management. These are intended for
-- direct use by administrators or as a reference for API endpoints.
--=========================================================

--=========================================================
-- QUERY 1: View Upcoming Appointments for a Veterinarian
-- Description: Lists all scheduled appointments for a specific vet from today onwards.
-- Usage: Useful for a vet to see their daily/weekly schedule.
--=========================================================
SELECT
    a.id_app,
    a.sch_dat_app,
    c.nam_usr as client_name,
    an.nam_ani as animal_name,
    a.status_app
FROM appointment a
JOIN client c ON a.id_cli = c.id_cli
JOIN animal an ON a.id_ani = an.id_ani
WHERE a.id_emp = 1 -- << Substituir pelo ID do veterinário
  AND a.sch_dat_app >= current_date
  AND a.status_app = 'scheduled'
ORDER BY a.sch_dat_app;

--=========================================================
-- QUERY 1: View Upcoming Appointments for a client with an animal
-- Description: Lists all scheduled appointments for a specific client.
-- Usage: Useful for a client to see their pet's upcoming appointments.
--=========================================================
SELECT 
    a.id_app,
    a.sch_dat_app,
    c.nam_usr as client_name,
    an.nam_ani as animal_name,
    a.status_app
FROM appointment a
JOIN client c ON a.id_cli = c.id_cli
JOIN animal an ON a.id_ani = an.id_ani
WHERE c.id_cli = 1 -- << Substituir pelo ID do cliente
  AND a.sch_dat_app >= current_date
  AND a.status_app = 'scheduled'
ORDER BY a.sch_dat_app;