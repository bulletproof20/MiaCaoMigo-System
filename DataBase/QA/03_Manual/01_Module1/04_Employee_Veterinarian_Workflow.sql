-- =========================================================
-- MANUAL TEST — MODULE 1
-- WORKFLOW: Employee + veterinarian onboarding
-- =========================================================
-- PURPOSE:
--   Chain fn_create_employee and fn_create_veterinarian;
--   verify corporate email and expert row via views.
--
-- EXPECTED:
--   - New user_account + employee + veterinarian
--   - ema_emp = {id_usr}@miacaomigo.pt
--   - Visible in vw_active_employee_directory
--
-- REQUIRES: registrar id_emp 1; unique NIF/email below
-- =========================================================

do $$
declare
    v_tag text := floor(extract(epoch from clock_timestamp()))::text;
    v_email varchar;
    v_nif varchar;
    v_omv varchar;
begin
    raise notice 'MANUAL M1-04 — Employee and veterinarian onboarding';
    v_email := 'manual.qa.vet.' || v_tag || '@gmail.com';
    v_nif := '298' || lpad((floor(random() * 999999)::int)::text, 6, '0');
    v_omv := 'OMV-PT-MANUAL-' || v_tag;

    perform fn_create_veterinarian(
        fn_create_employee(
            'Manual QA Veterinario',
            'Av. Manual Vet 10, Braga',
            '4700-301',
            v_nif,
            '+351910888801',
            v_email,
            '+351253888801',
            '+351939888801',
            '$2b$12$manual_qa_vet_hash_001',
            1
        ),
        v_omv
    );

    raise notice 'Onboarded vet personal email: % OMV: %', v_email, v_omv;
end $$;

select
    d.id_emp,
    d.id_usr,
    d.nam_usr,
    d.ema_emp,
    v.num_omv_vet
from vw_active_employee_directory d
join veterinarian v on v.id_emp = d.id_emp
where d.nam_usr = 'Manual QA Veterinario';

select e.id_emp, ex.id_spe, s.nam_spe
from employee e
join expert ex on ex.id_emp = e.id_emp
join specialty s on s.id_spe = ex.id_spe
join user_account u on u.id_usr = e.id_usr
where u.nam_usr = 'Manual QA Veterinario';
