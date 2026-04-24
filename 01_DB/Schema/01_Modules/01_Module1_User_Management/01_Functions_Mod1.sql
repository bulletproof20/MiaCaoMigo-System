
/*
### 1. Schedule – Overlap de horários

* **Onde:** `schedule`
* **Porquê:** evitar horários sobrepostos para o mesmo empregado no mesmo dia
* **Como:**

  * BEFORE INSERT/UPDATE
  * verificar se existe outro registo com:

    * mesmo `id_emp`
    * mesmo `day_wee_sch`
    * intervalo sobreposto
  * regra:

    ```
    novo_inicio < existente_fim AND novo_fim > existente_inicio
    ```
*/

--=========================================================
-- FUNCTION: prevent_schedule_overlap
--=========================================================
create or replace function prevent_schedule_overlap()
returns trigger as $$
begin

    -- Verifica se já existe um horário sobreposto
    if exists (
        select 1
        from schedule as s
        where s.id_emp = new.id_emp
          and s.day_wee_sch = new.day_wee_sch

          -- evitar comparar com ele próprio (no UPDATE)
          and (
              tg_op = 'INSERT'
              or (tg_op = 'UPDATE' and 
                  (s.id_emp, s.day_wee_sch, s.sta_tim_sch) 
                  <> (old.id_emp, old.day_wee_sch, old.sta_tim_sch)
              )
          )

          -- condição de overlap
          and new.sta_tim_sch < s.fin_hou_sch
          and new.fin_hou_sch > s.sta_tim_sch
    ) then
        raise exception 
        'Schedule overlap detected for employee % on day %',
        new.id_emp, new.day_wee_sch;
    end if;

    return new;
end;
$$ language plpgsql;


--=========================================================
-- TRIGGER: schedule_overlap
--=========================================================
create trigger trg_schedule_no_overlap
before insert or update on schedule
for each row
execute function prevent_schedule_overlap();


---
/*
### 2. Absence – Overlap de ausências

* **Onde:** `absence`
* **Porquê:** impedir múltiplas ausências sobrepostas
* **Como:**

  * BEFORE INSERT/UPDATE
  * comparar intervalos (`timestamp`) para o mesmo `id_emp`
  * mesma regra de overlap
*/
---
/*
### 3. Clock_in – Sessões inválidas

* **Onde:** `clock_in`
* **Porquê:**

  * só 1 sessão aberta por empregado
  * evitar overlaps de sessões
* **Como:**

  * BEFORE INSERT/UPDATE
  * validar:

    * não existe outro `end_dat_clk IS NULL`
    * não há sobreposição com sessões existentes
*/
---
/*
### 4. Especialização exclusiva

* **Onde:** `assistant`, `veterinarian`
* **Porquê:** impedir que um employee seja ambos
* **Como:**

  * BEFORE INSERT
  * ao inserir numa tabela, verificar se já existe na outra
*/
---
/*
### 5. Login_record – Consistência de sucesso

* **Onde:** `login_record`
* **Porquê:** coerência entre sucesso e user
* **Como:**

  * BEFORE INSERT
  * validar:

    * `suc_log = true` → `id_usr NOT NULL`
*/
---
/*
### 6. Normalização automática (opcional)

* **Onde:** várias tabelas (`user_account`, `employee`, etc.)
* **Porquê:** garantir consistência sem depender da app
* **Como:**

  * BEFORE INSERT/UPDATE
  * aplicar:

    ```
    valor := lower(trim(valor))
    ```
*/
---
/*
### 7. Employee – especialização vs estado

* **Onde:** `employee`
* **Porquê:** evitar employee inativo com especializações ativas
* **Como:**

  * BEFORE UPDATE
  * se `dea_dat_emp NOT NULL`:

    * bloquear ou remover registos em `assistant`/`veterinarian`
*/
---
/*
### 8. Absence vs Schedule (avançado)

* **Onde:** `absence`
* **Porquê:** evitar ausências fora do horário (se for regra de negócio)
* **Como:**

  * BEFORE INSERT/UPDATE
  * cruzar com `schedule`
*/
---

