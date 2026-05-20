-- =========================================================
-- comments: indexes - module 2
-- =========================================================

comment on index uq_animal_single_delivery is
'unique: at most one delivery record per animal';

comment on index uq_ownership_active_per_animal is
'partial unique: one open ownership interval per animal';

comment on constraint ex_ownership_overlap on ownership is
'gist exclusion: non-overlapping custody date ranges per animal';
