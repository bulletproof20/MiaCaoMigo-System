-- =========================================================
-- QA CONTRACT — semantic lookup functions (Tests only)
-- =========================================================
-- Loaded by runners/run_fixtures.ps1 (Tests layer only).
-- Resolves stable fixture / contract keys to current surrogate IDs.
-- Does not alter application Services or Bootstrap init.
-- =========================================================

create or replace function qa_client_active_id()
returns integer
language sql
stable
as $$
    select c.id_cli
    from client c
    inner join user_account u on u.id_usr = c.id_usr
    where u.ema_usr = 'goncalo.pratas.cstress@gmail.com'
    limit 1;
$$;

create or replace function qa_client_secondary_id()
returns integer
language sql
stable
as $$
    select c.id_cli
    from client c
    inner join user_account u on u.id_usr = c.id_usr
    where u.ema_usr = 'goncalo.machado.cstress@gmail.com'
    limit 1;
$$;

create or replace function qa_registrar_emp_id()
returns integer
language sql
stable
as $$
    select e.id_emp
    from employee e
    where e.ema_emp = '20@miacaomigo.pt'
      and e.dea_dat_emp is null
    order by e.reg_dat_emp desc
    limit 1;
$$;

create or replace function qa_vet_primary_id()
returns integer
language sql
stable
as $$
    select v.id_emp
    from veterinarian v
    where v.num_omv_vet = 'OMV-PT-2024-CR-00841'
    limit 1;
$$;

create or replace function qa_emp_clockable_id()
returns integer
language sql
stable
as $$
    select e.id_emp
    from employee e
    where e.ema_emp = 'qa.clockable@miacaomigo.pt'
      and e.dea_dat_emp is null
    limit 1;
$$;

create or replace function qa_emp_absence_overlap_id()
returns integer
language sql
stable
as $$
    select e.id_emp
    from employee e
    where e.ema_emp = '21@miacaomigo.pt'
      and e.dea_dat_emp is null
    limit 1;
$$;

create or replace function qa_animal_internal_id()
returns integer
language sql
stable
as $$
    select id_ani from animal where reg_id_ani = 'ANI-2026-001' limit 1;
$$;

create or replace function qa_animal_adopted_id()
returns integer
language sql
stable
as $$
    select id_ani from animal where reg_id_ani = 'ANI-2026-003' limit 1;
$$;

create or replace function qa_animal_stress_internal_id()
returns integer
language sql
stable
as $$
    select id_ani from animal where reg_id_ani = 'ANI-2026-005' limit 1;
$$;

create or replace function qa_specialty_general_id()
returns integer
language sql
stable
as $$
    select coalesce(
        (select ex.id_spe from expert ex where ex.id_emp = qa_vet_primary_id() order by ex.id_spe limit 1),
        (select id_spe from specialty where nam_spe = 'geral' limit 1)
    );
$$;

create or replace function qa_specialty_mismatch_id()
returns integer
language sql
stable
as $$
    select s.id_spe
    from specialty s
    where s.id_spe not in (
        select e.id_spe from expert e where e.id_emp = qa_vet_primary_id()
    )
    order by s.id_spe
    limit 1;
$$;

create or replace function qa_product_int_p001_id()
returns integer
language sql
stable
as $$
    select id_pro from product where ref_pro = 'INT-P001' limit 1;
$$;

create or replace function qa_appt_overlap_slot()
returns timestamp
language sql
stable
as $$
    select timestamp '2099-06-15 10:00:00';
$$;

create or replace function qa_appt_notification_date()
returns date
language sql
stable
as $$
    select date '2099-07-11';
$$;
