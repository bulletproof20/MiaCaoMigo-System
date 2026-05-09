-- =========================================================
-- comments: triggers - module 2
-- =========================================================
-- metadata documentation for triggers enforcing animal lifecycle
-- rules on ownership, delivery, and breed consistency.
-- =========================================================

comment on trigger trg_block_ownership_if_animal_inactive on ownership is
'fires before ownership inserts to respect animal activity rules';

comment on trigger trg_check_delivery_date_consistency on delivery is
'fires before delivery inserts/updates to validate rescue ordering';

comment on trigger trg_prevent_duplicate_active_ownership on ownership is
'fires before ownership inserts to avoid parallel active owners';

comment on trigger trg_validate_animal_breed_species on animal is
'fires before animal inserts/updates to align breed with species';
