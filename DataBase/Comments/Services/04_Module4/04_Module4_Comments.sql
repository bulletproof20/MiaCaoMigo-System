-- =========================================================
-- comments: services — module 4 (appointment management)
-- =========================================================

comment on function fn_list_appointments_today() is
'Operational board from vw_appointments_today (scheduled/in_progress, current date).';

comment on function fn_list_appointments_tomorrow() is
'Reminder shortlist from vw_scheduled_appointments_tomorrow.';

comment on function fn_get_appointment_detail(integer) is
'Single appointment row from vw_appointment_detail (canonical cross-module joins).';

comment on function fn_list_vet_appointments_from(integer, date) is
'Scheduled future appointments for a veterinarian from vw_appointment_detail.';

comment on function fn_list_animal_appointment_history(integer) is
'Descending appointment history for one animal from vw_appointment_detail.';
