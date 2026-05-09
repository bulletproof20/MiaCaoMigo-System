-- =========================================================
-- comments: functions - module 2
-- =========================================================
-- metadata documentation for trigger-support functions related
-- to animal intake, ownership, and delivery workflows.
-- =========================================================

comment on function fn_block_ownership_if_animal_inactive() is
'guards ownership inserts when source data marks the animal inactive';

comment on function fn_check_delivery_date_after_rescue() is
'enforces chronological ordering between rescue and delivery timestamps';

comment on function fn_prevent_overlapping_ownership() is
'blocks concurrent active ownership rows for the same animal';

comment on function fn_validate_breed_species_consistency() is
'validates breed selection against the animal''s declared species';
