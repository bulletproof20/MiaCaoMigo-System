--=========================================================
-- TRIGGERS - MODULE 2 (ANIMAL MANAGEMENT)
-- Enforces business rules and data integrity through table events
--=========================================================

--=========================================================
-- TRIGGER 1: trg_block_ownership_if_animal_inactive
-- Impede a criação de uma posse (Ownership) se o animal
-- estiver marcado com uma data de inativação.
--=========================================================

create or replace trigger trg_block_ownership_if_animal_inactive
before insert on ownership           -- dispara antes de associar um dono
for each row                         -- executa para cada nova posse
execute function fn_block_ownership_if_animal_inactive();


--=========================================================
-- TRIGGER 2: trg_check_delivery_date_consistency
-- Garante a integridade temporal impedindo que a entrega
-- ocorra antes do resgate do animal.
--=========================================================

create or replace trigger trg_check_delivery_date_consistency
before insert or update on delivery   -- dispara no registo ou alteração da entrega
for each row                          -- executa por linha afetada
execute function fn_check_delivery_date_after_rescue();


--=========================================================
-- TRIGGER 3: trg_prevent_duplicate_active_ownership
-- Garante que um animal não possa ter dois registos de posse
-- ativos (sem data de fim) em simultâneo.
--=========================================================

create or replace trigger trg_prevent_duplicate_active_ownership
before insert on ownership           -- dispara antes da inserção
for each row                         -- executa para cada tentativa de inserção
execute function fn_prevent_overlapping_ownership();


--=========================================================
-- TRIGGER 4: trg_validate_animal_breed_species
-- Verifica se a raça selecionada para o animal pertence 
-- efetivamente à espécie indicada (evita erros biológicos).
--=========================================================

create or replace trigger trg_validate_animal_breed_species
before insert or update on animal    -- dispara na criação ou edição do animal
for each row                         -- executa por cada animal processado
execute function fn_validate_breed_species_consistency();