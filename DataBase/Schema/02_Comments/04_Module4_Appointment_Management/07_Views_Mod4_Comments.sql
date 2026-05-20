-- =========================================================
-- comments: views - module 4
-- =========================================================

comment on view vw_appointment_detail is
'appointments enriched with client, clinician, animal, and specialty context';

comment on view vw_scheduled_appointments_tomorrow is
'scheduled appointments for the next calendar day; supports reminder workflows';

comment on view vw_appointments_today is
'scheduled and in-progress appointments for the current calendar day';
