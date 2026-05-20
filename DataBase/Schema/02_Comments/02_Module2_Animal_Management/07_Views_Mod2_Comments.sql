-- =========================================================
-- comments: views - module 2
-- =========================================================

comment on view vw_active_ownership_detail is
'open ownership intervals with client, animal, and taxonomy attributes';

comment on view vw_animal_catalog_detail is
'full animal registry joined to species, breed, and optional owner identity';

comment on view vw_internal_animals_available is
'non-inactivated animals in internal status available for adoption workflows';
