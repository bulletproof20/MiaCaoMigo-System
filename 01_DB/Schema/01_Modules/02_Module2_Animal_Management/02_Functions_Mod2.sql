--=========================================================
-- FUNCTIONS - MODULE 2 (ANIMAL MANAGEMENT)
-- Contains trigger-support functions and business logic
--=========================================================

--=========================================================
-- FUNCTION 1: fn_block_ownership_if_animal_inactive
-- Impede que um animal seja adotado/possuído se ele
-- estiver marcado como inativo (ex: falecido ou removido).
--=========================================================
 create or replace function fn_block_ownership_if_animal_inactive()
 returns trigger as $$
  begin
     
     if exists (
         select 1 
         from animal a
         where a.id_ani = new.id_ani
           --and a.ina_dat_ani is not null
     ) then
         raise exception 'Cannot assign ownership: Animal is inactive/deceased.';
     end if;
     return new;
 end;
 $$ language plpgsql;


--=========================================================
-- FUNCTION 2: fn_check_delivery_date_after_rescue
-- Garante a lógica temporal: a entrega (delivery) não
-- pode ser feita antes da data de resgate (rescue).
--=========================================================

create or replace function fn_check_delivery_date_after_rescue()
returns trigger as $$
begin
    if new.delivery_date < new.rescue_date then
        raise exception 'Delivery date (%) cannot be earlier than rescue date (%)', 
        new.delivery_date, new.rescue_date;
    end if;

    return new;
end;
$$ language plpgsql;


--=========================================================
-- FUNCTION 3: fn_prevent_overlapping_ownership
-- Impede que um animal tenha dois donos ao mesmo tempo.
-- Uma nova posse só pode começar se a anterior tiver terminado.
--=========================================================

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


--=========================================================
-- FUNCTION 4: fn_validate_breed_species_consistency
-- Garante que a raça (Breed) escolhida pertence de facto 
-- à espécie (Species) indicada no registo do animal.
--=========================================================

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