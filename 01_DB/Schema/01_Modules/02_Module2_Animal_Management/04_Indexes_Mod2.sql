-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
-- =========================================================
-- FILE: 04_Indexes_Mod2.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Supporting extension install, partial uniques, and exclusion constraints
-- that complement Module 2 triggers for animal ownership integrity.
--
-- This file contains:
-- - btree_gist enablement
-- - Delivery and ownership uniqueness aids
-- - GiST ownership overlap exclusion
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - delivery and ownership tables materialized
--
-- Must load before:
-- - Bulk loads assuming uniqueness and exclusion rules
-- =========================================================

-- =========================================================
-- Extension required for GiST exclusion on scalar types
-- =========================================================

create extension if not exists btree_gist;
 
-- =========================================================
-- Enforces at most one delivery record per animal
-- =========================================================

drop index if exists uq_animal_single_delivery;
create unique index uq_animal_single_delivery
on delivery(id_ani);


-- =========================================================
-- Enforces a single active ownership interval per animal
-- =========================================================

drop index if exists uq_ownership_active_per_animal;
create unique index uq_ownership_active_per_animal
on ownership(id_ani)
where end_dat_own is null;


-- =========================================================
-- Prevents overlapping ownership dateranges per animal
-- =========================================================

alter table ownership drop constraint if exists ex_ownership_overlap;
alter table ownership
add constraint ex_ownership_overlap
exclude using gist (
    id_ani with =,
    daterange(sta_dat_own, end_dat_own, '[]') with &&
);
