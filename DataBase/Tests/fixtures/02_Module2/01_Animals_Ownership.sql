-- =========================================================
-- QA FIXTURE — MODULE 2 — ANIMALS AND OWNERSHIP
-- =========================================================
-- TYPE:     fixture (data only)
-- REQUIRES: fixtures/01_Module1/01_Core_Context.sql + contracts
-- PROVIDES: QA_ANIMAL_INTERNAL, QA_ANIMAL_ADOPTED, QA_ANIMAL_STRESS_INTERNAL
-- =========================================================

truncate table
    delivery_employee,
    concession,
    delivery,
    ownership,
    animal,
    breed,
    species,
    external_entity
restart identity cascade;

insert into species (nam_spc, sci_nam_spc) values
    ('Dog', 'Canis lupus familiaris'),
    ('Cat', 'Felis catus'),
    ('Bird', 'Aves');

insert into breed (nam_bre, sci_nam_bre, id_spc) values
    ('Labrador Retriever', 'Canis lupus', 1),
    ('German Shepherd', 'Canis lupus', 1),
    ('Siamese', 'Felis catus', 2),
    ('Persian', 'Felis catus', 2),
    ('Canary', 'Serinus canaria', 3);

insert into external_entity (nam_ext_ent, loc_ext_ent, pho_ext_ent, ema_ext_ent, typ_ext_ent) values
    ('Happy Paws Shelter', 'Lisbon', '+351912345678', 'contact@happypaws.pt', 'Shelter'),
    ('Pro Feed Supplier', 'Porto', '+351223456789', 'sales@profeed.com', 'Supplier'),
    ('Animal Welfare Assoc', 'Coimbra', '+351239123456', 'info@az.org', 'Association');

insert into animal (reg_id_ani, nam_ani, dat_bir_ani, gen_ani, ori_ani, sta_ani, id_spc, id_bre) values
    ('ANI-2026-001', 'Bobby', '2020-05-10', 'M', 'Street', 'Interno', 1, 1),
    ('ANI-2026-002', 'Luna', '2021-02-20', 'F', 'Clinic born', 'Interno', 1, 2),
    ('ANI-2026-003', 'Miau', '2019-11-15', 'M', 'External delivery', 'Interno', 2, 3),
    ('ANI-2026-004', 'Pipocas', '2022-08-01', 'F', 'Street', 'Interno', 3, 5),
    ('ANI-2026-005', 'Rex', '2018-03-12', 'M', 'Abandonment', 'Interno', 1, 2);

do $$
declare
    v_cli_active int := qa_client_active_id();
    v_cli_sec int := qa_client_secondary_id();
    v_reg int := qa_registrar_emp_id();
begin
    if v_cli_active is null or v_reg is null then
        raise exception 'QA Mod2 fixture: missing client/registrar contracts.';
    end if;

    insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, end_dat_own, mot_own)
    select v_cli_active, a.id_ani, v_reg, date '2026-01-10', null, 'QA adoption for Mod4 scheduling'
      from animal a where a.reg_id_ani = 'ANI-2026-003';

    update animal set sta_ani = 'Adotado' where reg_id_ani = 'ANI-2026-003';

    if v_cli_sec is not null then
        insert into ownership (id_cli, id_ani, id_emp, sta_dat_own, end_dat_own, mot_own)
        select v_cli_sec, a.id_ani, v_reg, date '2026-02-01', date '2026-03-01', 'QA temporary foster'
          from animal a where a.reg_id_ani = 'ANI-2026-002';
    end if;
end;
$$;

insert into delivery (reg_dat_del, res_dat_del, res_loc_del, cli_sta_del, id_ext_ent, id_ani)
select current_timestamp, current_timestamp - interval '2 hours', 'Lower Street, Braga', 'Malnourished', 1, a.id_ani
  from animal a where a.reg_id_ani = 'ANI-2026-004';

insert into delivery (reg_dat_del, res_dat_del, res_loc_del, cli_sta_del, id_ext_ent, id_ani)
select current_timestamp - interval '1 day', current_timestamp - interval '25 hours', 'City Park', 'Healthy', 3, a.id_ani
  from animal a where a.reg_id_ani = 'ANI-2026-001';

insert into delivery_employee (id_del, id_emp)
select d.id_del, qa_registrar_emp_id()
  from delivery d
  join animal a on a.id_ani = d.id_ani
 where a.reg_id_ani in ('ANI-2026-001', 'ANI-2026-004');

insert into concession (dat_con, mot_con, cli_sta_con, id_ext_ent, id_emp, id_ani)
select date '2026-04-15', 'QA transfer to specialized shelter', 'Healthy', 1, qa_registrar_emp_id(), a.id_ani
  from animal a where a.reg_id_ani = 'ANI-2026-002';
