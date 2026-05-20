--=========================================================
-- MODULE 1 - VERIFICATION QUERIES
--=========================================================
-- Purpose:
-- Centralized validation queries for:
--
-- - identity sharing
-- - employee lifecycle
-- - assistant/veterinarian bindings
-- - RBAC relations
-- - role exclusivity
--=========================================================



--=========================================================
-- 1. USER + CLIENT RELATION
--=========================================================
-- expected:
-- - validate all client bindings
--=========================================================

select

    u.id_usr,
    u.nam_usr,
    u.nif_usr,
    u.ema_usr,

    c.id_cli,
    c.reg_dat_cli,
    c.ina_dat_cli

from user_account as u

join client as c
    on c.id_usr = u.id_usr

order by u.id_usr desc;



--=========================================================
-- 2. USER + EMPLOYEE RELATION
--=========================================================
-- expected:
-- - validate employee bindings
-- - validate active/inactive spells
--=========================================================

select

    u.id_usr,
    u.nam_usr,

    e.id_emp,

    e.ema_emp,

    e.reg_dat_emp,
    e.dea_dat_emp

from user_account as u

join employee as e
    on e.id_usr = u.id_usr

order by e.id_emp desc;



--=========================================================
-- 3. SHARED CLIENT + EMPLOYEE IDENTITIES
--=========================================================
-- expected:
-- - users with both roles
--=========================================================

select

    u.id_usr,
    u.nam_usr,

    c.id_cli,

    e.id_emp,
    e.ema_emp

from user_account as u

join client as c
    on c.id_usr = u.id_usr

join employee as e
    on e.id_usr = u.id_usr

where e.dea_dat_emp is null

order by u.id_usr desc;



--=========================================================
-- 4. EMPLOYEE HISTORY
--=========================================================
-- expected:
-- - users with multiple employment spells
--=========================================================

select

    e.id_usr,

    u.nam_usr,

    count(*) as total_spells,

    min(e.reg_dat_emp) as first_registration,
    max(e.reg_dat_emp) as latest_registration

from employee as e

join user_account as u
    on u.id_usr = e.id_usr

group by
    e.id_usr,
    u.nam_usr

having count(*) > 1

order by total_spells desc;



--=========================================================
-- 5. ASSISTANT ROLE ASSOCIATIONS
--=========================================================
-- expected:
-- - validate assistant bindings
--=========================================================

select

    a.id_emp,

    u.nam_usr,

    e.ema_emp,

    a.fun_ass

from assistant as a

join employee as e
    on e.id_emp = a.id_emp

join user_account as u
    on u.id_usr = e.id_usr

order by a.id_emp;



--=========================================================
-- 6. VETERINARIAN ROLE ASSOCIATIONS
--=========================================================
-- expected:
-- - validate veterinarian bindings
--=========================================================

select

    v.id_emp,

    u.nam_usr,

    e.ema_emp,

    v.num_omv_vet

from veterinarian as v

join employee as e
    on e.id_emp = v.id_emp

join user_account as u
    on u.id_usr = e.id_usr

order by v.id_emp;



--=========================================================
-- 7. VETERINARIAN SPECIALTIES
--=========================================================
-- expected:
-- - validate expert specialty mappings
--=========================================================

select

    v.id_emp,

    u.nam_usr,

    v.num_omv_vet,

    s.nam_spe

from veterinarian as v

join employee as e
    on e.id_emp = v.id_emp

join user_account as u
    on u.id_usr = e.id_usr

left join expert as ex
    on ex.id_emp = v.id_emp

left join specialty as s
    on s.id_spe = ex.id_spe

order by v.id_emp;



--=========================================================
-- 8. ROLE + PROFILE RELATIONS
--=========================================================
-- expected:
-- - validate RBAC assignments
--=========================================================

select

    e.id_emp,

    u.nam_usr,

    p.nam_pro

from employee as e

join user_account as u
    on u.id_usr = e.id_usr

left join occupies as o
    on o.id_emp = e.id_emp

left join profile as p
    on p.id_pro = o.id_pro

order by e.id_emp;



--=========================================================
-- 9. ASSISTANT / VETERINARIAN EXCLUSIVITY
--=========================================================
-- expected:
-- - query should return zero rows
-- - no employee can have both roles
--=========================================================

select

    e.id_emp,

    u.nam_usr,

    a.fun_ass,

    v.num_omv_vet

from employee as e

join user_account as u
    on u.id_usr = e.id_usr

join assistant as a
    on a.id_emp = e.id_emp

join veterinarian as v
    on v.id_emp = e.id_emp;