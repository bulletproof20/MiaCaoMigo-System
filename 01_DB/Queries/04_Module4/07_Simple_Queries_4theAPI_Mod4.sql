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
    s.nam_spe as specialty_name,
    an.nam_ani as animal_name,
    a.status_app
FROM appointment a
JOIN client c ON a.id_cli = c.id_cli
JOIN specialty s ON a.id_spe = s.id_spe
JOIN animal an ON a.id_ani = an.id_ani
WHERE a.id_emp = 1 -- << Substituir pelo ID do veterinário
  AND a.sch_dat_app >= current_date
  AND a.status_app = 'scheduled'
ORDER BY a.sch_dat_app;


--=========================================================
-- QUERY 2: Complete Medical History for an Animal
-- Description: Retrieves the complete appointment history for a specific animal,
--              including diagnosis and comments from each visit.
-- Usage: Essential for tracking an animal's health over time.
--=========================================================
SELECT
    a.id_app,
    a.sch_dat_app,
    e.nam_emp as vet_name,
    s.nam_spe as specialty_name,
    a.status_app,
    a.dia_app as diagnosis,
    a.com_app as comments
FROM appointment a
JOIN employee e ON a.id_emp = e.id_emp
JOIN specialty s ON a.id_spe = s.id_spe
WHERE a.id_ani = 1 -- << Substituir pelo ID do animal
ORDER BY a.sch_dat_app DESC;


--=========================================================
-- QUERY 3: Full Details of a Single Appointment
-- Description: Gathers all information related to a single appointment, including
--              clinical assessment, anamnesis, and prescription details.
-- Usage: Provides a comprehensive view of a specific consultation.
--=========================================================
SELECT
    a.id_app,
    a.sch_dat_app,
    a.sta_dat_app,
    a.end_dat_app,
    c.nam_usr as client_name,
    an.nam_ani as animal_name,
    e.nam_emp as vet_name,
    s.nam_spe as specialty_name,
    i.id_inv as invoice_id,
    a.dia_app as diagnosis,
    a.com_app as comments,
    oa.bod_tmp_ova,
    oa.wei_ova,
    oa.hrt_rat_ova,
    oa.res_rat_ova,
    oa.gen_sta_ova,
    anam.des_ana as anamnesis_description,
    p.des_pre as prescription_description
FROM appointment a
LEFT JOIN client c ON a.id_cli = c.id_cli
LEFT JOIN animal an ON a.id_ani = an.id_ani
LEFT JOIN employee e ON a.id_emp = e.id_emp
LEFT JOIN specialty s ON a.id_spe = s.id_spe
LEFT JOIN overall_assessment oa ON a.id_app = oa.id_app
LEFT JOIN anamnesis anam ON a.id_app = anam.id_app
LEFT JOIN prescription p ON a.id_app = p.id_app
LEFT JOIN invoice i ON a.id_inv = i.id_inv
WHERE a.id_app = 1; -- << Substituir pelo ID da consulta

--=========================================================
-- QUERY 4: Products Used in an Appointment
-- Description: Lists all products (e.g., medication, supplies) used
--              during a specific appointment.
-- Usage: Useful for inventory tracking and billing.
--=========================================================
SELECT
    p.nam_pro as product_name,
    rap.qty_pre_pro as quantity,
    rap.dos_pre_pro as dosage
FROM rel_app_product rap
JOIN product p ON rap.id_pro = p.id_pro
WHERE rap.id_app = 1; -- << Substituir pelo ID da consulta


--=========================================================
-- QUERY 5: Monthly Appointment Report
-- Description: Generates a summary of appointments per month, grouped by status
--              (e.g., Completed, Cancelled, No-Show).
-- Usage: For administrative and business intelligence purposes.
--=========================================================
SELECT
    to_char(sch_dat_app, 'YYYY-MM') as month,
    status_app,
    count(*) as total_appointments
FROM appointment
GROUP BY month, status_app;


--=========================================================
-- QUERY 6: Unread Notifications for a Client
-- Description: Retrieves all unread notifications for a specific client.
-- Usage: To be used by the frontend to display alerts to the user.
--=========================================================
SELECT
    id_not,
    msg_not,
    cre_tim_not
FROM appointment_notification
WHERE id_cli = 1 -- << Substituir pelo ID do cliente
  AND rea_not = false
ORDER BY cre_tim_not DESC;