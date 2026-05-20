-- =========================================================
-- comments: procedures - module 4
-- =========================================================

comment on procedure sp_auto_update_no_show_appointments() is
'marks past scheduled appointments as no_show for nightly hygiene';

comment on procedure sp_generate_appointment_warnings() is
'creates next-day reminder notifications from vw_scheduled_appointments_tomorrow';

comment on procedure sp_cancel_appointment(integer) is
'cancels future appointments subject to the 24-hour policy window';

comment on procedure sp_reschedule_appointment(integer, timestamp without time zone) is
'updates scheduled times when advance-notice rules pass';

comment on procedure sp_create_appointment(integer, integer, integer, integer, timestamp without time zone) is
'inserts a scheduled appointment with explicit consultation specialty';

comment on procedure sp_start_appointment(integer) is
'marks a visit as in_progress and stamps the start time';

comment on procedure sp_end_appointment(integer, character varying, text) is
'finalizes a visit with diagnosis metadata and completed status';

comment on procedure sp_prescription_for_appointment(integer, text) is
'creates a prescription row linked to a completed appointment';
