-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
-- =========================================================
-- FILE: 07_Views_Mod2.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Reporting views for animal catalog, ownership, and intake
-- pipelines. Encapsulates joins across animals, taxonomy, and
-- client identities from Module 1.
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 2 tables and 01_ForeignKeys_Mod2.sql
-- - Module 1 client / user_account (cross-module FK phase)
--
-- Must load before:
-- - Application reporting layers and optional batch jobs
-- =========================================================

-- =========================================================
-- Active ownership intervals with client and animal context
-- =========================================================
-- Entities: ownership, client, user_account, animal, species, breed
-- Purpose: current custodianship and adoption tracking

drop view if exists vw_active_ownership_detail;

create view vw_active_ownership_detail as
select
    o.id_own,
    o.id_ani,
    o.id_cli,
    u.nam_usr as client_name,
    u.ema_usr as client_email,
    a.reg_id_ani,
    a.nam_ani,
    a.sta_ani,
    s.nam_spc,
    b.nam_bre,
    o.sta_dat_own,
    o.mot_own,
    o.id_emp
from ownership o
inner join client c on c.id_cli = o.id_cli
inner join user_account u on u.id_usr = c.id_usr
inner join animal a on a.id_ani = o.id_ani
inner join species s on s.id_spc = a.id_spc
left join breed b on b.id_bre = a.id_bre
where o.end_dat_own is null;


-- =========================================================
-- Animal catalog with taxonomy and optional owner
-- =========================================================
-- Entities: animal, species, breed, client, user_account
-- Purpose: consolidated animal registry for operational search

drop view if exists vw_animal_catalog_detail;

create view vw_animal_catalog_detail as
select
    a.id_ani,
    a.reg_id_ani,
    a.nam_ani,
    a.dat_bir_ani,
    a.gen_ani,
    a.ori_ani,
    a.sta_ani,
    a.reg_dat_ani,
    a.ina_dat_ani,
    s.id_spc,
    s.nam_spc,
    b.id_bre,
    b.nam_bre,
    a.id_cli,
    u.nam_usr as owner_name,
    u.ema_usr as owner_email
from animal a
inner join species s on s.id_spc = a.id_spc
left join breed b on b.id_bre = a.id_bre
left join client c on c.id_cli = a.id_cli
left join user_account u on u.id_usr = c.id_usr;


-- =========================================================
-- Animals available for adoption (internal status)
-- =========================================================
-- Entities: animal, species, breed
-- Purpose: intake and adoption workflow shortlist

drop view if exists vw_internal_animals_available;

create view vw_internal_animals_available as
select
    a.id_ani,
    a.reg_id_ani,
    a.nam_ani,
    a.sta_ani,
    s.nam_spc,
    b.nam_bre,
    a.reg_dat_ani
from animal a
inner join species s on s.id_spc = a.id_spc
left join breed b on b.id_bre = a.id_bre
where a.sta_ani = 'Interno'
  and a.ina_dat_ani is null;
