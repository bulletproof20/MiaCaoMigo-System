-- =========================================================
-- comments: services — module 2 (animal management)
-- =========================================================

comment on function fn_register_adoption(integer, integer, integer, character varying) is
'Application wrapper for sp_assign_ownership (adoption lifecycle and status transition).';

comment on function fn_register_delivery_team(integer, integer, character varying, character varying, integer[]) is
'Application wrapper for sp_record_delivery (intake with optional employee witnesses).';

comment on function fn_animal_exit(integer, character varying) is
'Sets animal status and closes open ownership intervals (definitive exit).';

comment on function fn_get_animal_history(integer) is
'Returns merged ownership and concession events for audit display.';

comment on function fn_list_internal_animals_available() is
'Read-only list from vw_internal_animals_available (Interno status, not inactivated).';

comment on function fn_get_active_ownership_by_animal(integer) is
'Read-only rows from vw_active_ownership_detail for one animal.';

comment on function fn_get_animal_catalog_entry(integer) is
'Single-row lookup from vw_animal_catalog_detail by id_ani.';
