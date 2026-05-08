--=========================================================
-- INDEXES - MODULE 2 (ANIMAL MANAGEMENT)
-- Ensures data integrity and performance through indexing
-- and exclusion constraints.
--=========================================================

--=========================================================
-- EXTENSIONS
--=========================================================
-- Required for GIST indexes on standard data types
create extension if not exists btree_gist;
 
--=========================================================
-- INDEX 1: uq_animal_single_delivery
-- Ensures that each animal has only one delivery record,
-- enforcing that its entry into the system via
-- rescue/delivery is a unique event.
--=========================================================

drop index if exists uq_animal_single_delivery;
create unique index uq_animal_single_delivery
on delivery(id_ani);



--=========================================================
-- INDEX 2: uq_ownership_active_per_animal
-- Ensures that an animal can only have one active ownership
-- record (without an end date) at a time. This is more
-- efficient than using a trigger.
--=========================================================

drop index if exists uq_ownership_active_per_animal;
create unique index uq_ownership_active_per_animal
on ownership(id_ani)
where end_dat_own is null;



--=========================================================
-- EXCLUSION CONSTRAINT 1: ex_ownership_overlap
-- Prevents the creation of overlapping ownership periods
-- for the same animal, ensuring data integrity over time.
--=========================================================

alter table ownership drop constraint if exists ex_ownership_overlap;
alter table ownership
add constraint ex_ownership_overlap
exclude using gist (
    id_ani with =,
    daterange(sta_dat_own, end_dat_own, '[]') with &&
);