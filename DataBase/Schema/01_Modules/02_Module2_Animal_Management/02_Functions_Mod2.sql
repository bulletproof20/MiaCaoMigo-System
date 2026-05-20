-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
-- =========================================================
-- FILE: 02_Functions_Mod2.sql
-- =========================================================
--
-- DESCRIPTION
-- ---------------------------------------------------------
-- Database functions for validation, automation support, and
-- business-rule encapsulation for animals, ownership, and delivery.
--
-- This file contains:
-- - Ownership and adoption guards
-- - Temporal checks on delivery vs rescue
-- - Breed/species consistency validation
-- ---------------------------------------------------------
--
-- LOAD ORDER
-- ---------------------------------------------------------
-- Requires:
-- - Module 2 tables and foreign keys
--
-- Must load before:
-- - 03_Triggers_Mod2.sql
-- =========================================================

-- =========================================================
-- Validates ownership insert against the referenced animal record
-- =========================================================

create or replace function fn_block_ownership_if_animal_inactive()
returns trigger as $$
begin
     
     if exists (
         select 1
         from animal a
         where a.id_ani = new.id_ani
           and (
               a.ina_dat_ani is not null
               or a.sta_ani in ('Falecido', 'Adotado')
           )
     ) then
         raise exception 'Cannot assign ownership: Animal is inactive/deceased.';
     end if;
     return new;
end;
$$ language plpgsql;


-- =========================================================
-- Ensures delivery date is not earlier than rescue date
-- =========================================================

create or replace function fn_check_delivery_date_after_rescue()
returns trigger as $$
begin
    if new.del_dat_del is not null
       and new.res_dat_del is not null
       and new.del_dat_del < new.res_dat_del then
        raise exception 'Delivery date (%) cannot be earlier than rescue date (%)',
            new.del_dat_del, new.res_dat_del;
    end if;

    return new;
end;
$$ language plpgsql;


-- =========================================================
-- Prevents a second active ownership while another remains open
-- =========================================================

create or replace function fn_prevent_overlapping_ownership()
returns trigger as $$
begin
    if exists (
        select 1 
        from ownership o
        where o.id_ani = new.id_ani
          and o.end_dat_own is null  -- Posse anterior ainda ativa
          and o.id_own <> new.id_own
    ) then
        raise exception 'Animal already has an active owner. Close the previous ownership first.';
    end if;

    return new;
end;
$$ language plpgsql;


-- =========================================================
-- Ensures the animal breed belongs to the selected species
-- =========================================================

create or replace function fn_validate_breed_species_consistency()
returns trigger as $$
declare
    v_breed_species_id int;
begin
    -- Procura a espécie associada à raça
    select id_spc into v_breed_species_id 
    from breed 
    where id_bre = new.id_bre; -- No teu diagrama o FK no Animal é RECE_ID

    if v_breed_species_id <> new.id_spc then
        raise exception 'Consistency Error: Breed does not belong to the selected species.';
    end if;

    return new;
end;
$$ language plpgsql;
