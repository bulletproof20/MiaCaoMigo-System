-- =========================================================
-- comments: procedures - module 2
-- =========================================================
-- metadata documentation for procedural workflows covering
-- registration, ownership, delivery, and concession handling.
-- =========================================================

comment on procedure sp_register_animal(character varying, character varying, date, character, character varying, character varying, integer, integer) is
'inserts a new animal row with species/breed metadata';

comment on procedure sp_assign_ownership(integer, integer, integer, character varying) is
'creates an ownership interval and promotes animal status when eligible';

comment on procedure sp_end_ownership(integer, character varying) is
'closes the active ownership interval and reverts animal availability';

comment on procedure sp_record_delivery(integer, timestamp without time zone, character varying, character varying, integer, integer[]) is
'records a delivery event, links participating employees, and normalizes animal status';

comment on procedure sp_process_concession(integer, integer, integer, character varying, character varying) is
'creates a concession transfer and updates animal disposition';
