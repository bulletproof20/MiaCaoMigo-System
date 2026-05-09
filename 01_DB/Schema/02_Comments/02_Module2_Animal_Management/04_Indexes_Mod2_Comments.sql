-- =========================================================
-- comments: indexes - module 2
-- =========================================================
-- metadata documentation for uniqueness filters and temporal
-- exclusion constraints supporting animal workflows.
-- =========================================================

comment on index uq_animal_single_delivery is
'ensures each animal has at most one delivery intake row';

comment on index uq_ownership_active_per_animal is
'partial unique index limiting one open-ended ownership interval per animal';

comment on constraint ex_ownership_overlap on ownership is
'prevents overlapping ownership date ranges per animal via GiST exclusion';
