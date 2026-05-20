-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod2.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Integrity partial uniques, GiST exclusion, and btree_gist
-- enablement for ownership and delivery rules.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - delivery and ownership tables materialized
-- - btree_gist (also installed in 03_Loaders/00_Extensions.sql)
-- =========================================================

-- =========================================================
-- Extension required for GiST exclusion on scalar types
-- =========================================================

create extension if not exists btree_gist;


-- =========================================================
-- INTEGRITY — at most one delivery per animal
-- =========================================================
-- Optimizes:
--   - delivery uniqueness per animal intake pipeline
--   - animal-centric delivery lookups
--
-- Partial UNIQUE replaces redundant secondary index on id_ani.
-- =========================================================

drop index if exists uq_animal_single_delivery;

create unique index uq_animal_single_delivery
on delivery (id_ani);


-- =========================================================
-- INTEGRITY — single active ownership per animal
-- =========================================================
-- Optimizes:
--   - adoption and end-ownership procedures
--   - vw_active_ownership_detail (end_dat_own is null)
--
-- Enforces one open custody interval per animal.
-- =========================================================

drop index if exists uq_ownership_active_per_animal;

create unique index uq_ownership_active_per_animal
on ownership (id_ani)
where end_dat_own is null;


-- =========================================================
-- INTEGRITY — non-overlapping ownership date ranges
-- =========================================================
-- Optimizes:
--   - ownership overlap validation (GiST exclusion)
--
-- Prevents intersecting custody intervals per animal.
-- =========================================================

alter table ownership drop constraint if exists ex_ownership_overlap;

alter table ownership
add constraint ex_ownership_overlap
exclude using gist (
    id_ani with =,
    daterange(sta_dat_own, end_dat_own, '[]') with &&
);
