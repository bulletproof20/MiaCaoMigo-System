-- =========================================================
-- comments: procedures - module 4
-- =========================================================
-- metadata documentation for appointment automation routines.
-- note: prc_auto_close_clock_in_midnight shares a name with module 1;
-- whichever script loads last defines the callable signature.
-- =========================================================

comment on procedure prc_auto_close_clock_in_midnight() is
'closes stale attendance rows by backfilling midnight end timestamps';

comment on procedure prc_generate_appointment_warnings() is
'creates next-day reminder notifications for scheduled clients';

comment on procedure prc_cancel_appointment(integer) is
'cancels future appointments subject to the 24-hour policy window';

comment on procedure prc_reschedule_appointment(integer, timestamp without time zone) is
'updates scheduled times when advance-notice rules pass';

comment on procedure prc_create_appointment(integer, integer, integer, timestamp without time zone) is
'inserts a scheduled appointment with default status handling';

comment on procedure prc_start_appointment(integer) is
'marks a visit as in progress and stamps the start time';

comment on procedure prc_end_appointment(integer, character varying, text) is
'finalizes a visit with diagnosis metadata and completion state';
