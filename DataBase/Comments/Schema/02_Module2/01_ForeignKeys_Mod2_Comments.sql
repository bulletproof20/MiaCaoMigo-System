--=========================================================
-- MODULE 2 — metadata: foreign keys
--=========================================================
-- Declarative FKs are defined in 01_ForeignKeys_Mod2.sql
-- after all module tables exist.
--=========================================================

comment on constraint fk_breed_species on breed is
'ensures each breed references a valid species';

comment on constraint fk_animal_species on animal is
'binds the animal to its species catalog row';

comment on constraint fk_animal_breed on animal is
'optional breed refinement; null when unknown';

comment on constraint fk_ownership_client on ownership is
'ownership row references the adopting client';

comment on constraint fk_ownership_animal on ownership is
'ownership row references the animal';

comment on constraint fk_ownership_employee on ownership is
'optional employee associated with the ownership change';

comment on constraint fk_concession_entity on concession is
'concession targets a registered external entity';

comment on constraint fk_concession_employee on concession is
'records which employee authorized the concession';

comment on constraint fk_concession_animal on concession is
'identifies the animal leaving the clinic';

comment on constraint fk_delivery_entity on delivery is
'optional partner metadata for the intake';

comment on constraint fk_delivery_animal on delivery is
'identifies the animal impacted by the delivery workflow';

comment on constraint fk_del_emp_delivery on delivery_employee is
'associates staff with a delivery record';

comment on constraint fk_del_emp_employee on delivery_employee is
'links each association to a concrete employee';
