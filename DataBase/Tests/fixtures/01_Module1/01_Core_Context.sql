-- =========================================================
-- QA FIXTURE — MODULE 1 — CORE CONTEXT
-- =========================================================
-- TYPE:     fixture (data only)
-- REQUIRES: Bootstrap init_demo (Master + Demo)
-- PROVIDES: QA_CLIENT_ACTIVE, QA_CLIENT_SECONDARY, QA_REGISTRAR,
--            QA_VET_PRIMARY, QA_EMP_CLOCKABLE, QA_ABSENCE_OVERLAP,
--            login session (12@), schedule seed (registrar)
-- =========================================================

-- Extra specialties for expert / mismatch coverage (Master ships only "geral")
insert into specialty (nam_spe, des_spe)
select v.nam, v.des
  from (values
    ('medicina interna', 'internal medicine QA'),
    ('cirurgia de tegumentos', 'dermatologic surgery QA'),
    ('ortopedia', 'orthopedics QA'),
    ('dermatologia', 'dermatology QA'),
    ('anestesiologia', 'anesthesiology QA'),
    ('imagiologia', 'imaging QA'),
    ('medicina felina', 'feline medicine QA')
  ) as v(nam, des)
 where not exists (select 1 from specialty s where s.nam_spe = v.nam);

-- -------------------------------------------------------------------------
-- QA clients (portal emails — stable contract keys)
-- -------------------------------------------------------------------------
insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
select v.nam, v.add, v.pos, v.nif, v.pho, v.ema
  from (values
    ('Goncalo Miguel Pratas QA', 'Rua da Se 12, Faro', '8000-078', '610000023', '+351910300023', 'goncalo.pratas.cstress@gmail.com'),
    ('Goncalo Filipe Machado QA', 'Rua de Santa Justa 14, Lisboa', '1100-483', '610000034', '+351910300034', 'goncalo.machado.cstress@gmail.com')
  ) as v(nam, add, pos, nif, pho, ema)
 where not exists (select 1 from user_account u where u.ema_usr = v.ema);

insert into client (id_usr, pas_cli, reg_dat_cli, ina_dat_cli)
select u.id_usr, v.pas, current_timestamp - interval '2 years', null
  from (values
    ('goncalo.pratas.cstress@gmail.com', '$2b$12$cstress_cli_pure_u023'),
    ('goncalo.machado.cstress@gmail.com', '$2b$12$cstress_cli_pure_u034')
  ) as v(ema, pas)
  join user_account u on u.ema_usr = v.ema
 where not exists (select 1 from client c where c.id_usr = u.id_usr);

-- -------------------------------------------------------------------------
-- QA registrar (20@miacaomigo.pt) — ownership / login success path
-- -------------------------------------------------------------------------
do $$
declare
    v_usr int;
begin
    if not exists (select 1 from employee where ema_emp = '20@miacaomigo.pt') then
        insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
        values (
            'QA Registrar Spell',
            'Rua Goncalo Sampaio 412, Porto',
            '4150-564',
            '610000020',
            '+351910300020',
            'claudia.faria.cstress@icloud.com'
        )
        returning id_usr into v_usr;

        insert into employee (id_usr, reg_dat_emp, aut_reg_emp, pho_emp, pho_emg, ema_emp, pas_emp)
        values (
            v_usr,
            current_timestamp - interval '4 years',
            1,
            '+351253440020',
            '+351912340020',
            '20@miacaomigo.pt',
            '$2b$12$cstress_registrar_emp001'
        );
        insert into occupies (id_emp, id_pro)
        select e.id_emp, 1 from employee e where e.ema_emp = '20@miacaomigo.pt';
    end if;
end;
$$;

-- Schedule seed for registrar (id_emp 1 bootstrap admin OR 20@ — test targets emp 1)
insert into schedule (id_emp, day_wee_sch, sta_tim_sch, fin_hou_sch)
select e.id_emp, 1, '08:00', '18:00'
  from employee e
 where e.ema_emp = '1@miacaomigo.pt'
   and not exists (
       select 1 from schedule s
        where s.id_emp = e.id_emp and s.day_wee_sch = 1
   );

-- -------------------------------------------------------------------------
-- QA vet primary (OMV contract) + expert rows (spe 1 and 7)
-- -------------------------------------------------------------------------
do $$
declare
    v_usr int;
    v_emp int;
    v_spe1 int;
    v_spe7 int;
begin
    select id_spe into v_spe1 from specialty where nam_spe = 'medicina interna' limit 1;
    select id_spe into v_spe7 from specialty where nam_spe = 'medicina felina' limit 1;

    if not exists (select 1 from veterinarian where num_omv_vet = 'OMV-PT-2024-CR-00841') then
        insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
        values (
            'Bruno Filipe Matos QA Vet',
            'Rua da Junqueira 55, Coimbra',
            '3000-341',
            '610000004',
            '+351910300004',
            'bruno.matos.cstress@outlook.pt'
        )
        returning id_usr into v_usr;

        insert into employee (id_usr, reg_dat_emp, aut_reg_emp, pho_emp, pho_emg, ema_emp, pas_emp)
        values (
            v_usr,
            current_timestamp - interval '3 years',
            1,
            '+351253444001',
            '+351912344001',
            '8@miacaomigo.pt',
            '$2b$12$cstress_u04_vet_track'
        )
        returning id_emp into v_emp;

        insert into occupies (id_emp, id_pro) values (v_emp, 2);
        insert into veterinarian (id_emp, num_omv_vet) values (v_emp, 'OMV-PT-2024-CR-00841');
    else
        select id_emp into v_emp from veterinarian where num_omv_vet = 'OMV-PT-2024-CR-00841';
    end if;

    if v_spe1 is not null and not exists (
        select 1 from expert where id_emp = v_emp and id_spe = v_spe1
    ) then
        insert into expert (id_emp, id_spe) values (v_emp, v_spe1);
    end if;

    if v_spe7 is not null and not exists (
        select 1 from expert where id_emp = v_emp and id_spe = v_spe7
    ) then
        insert into expert (id_emp, id_spe) values (v_emp, v_spe7);
    end if;
end;
$$;

-- -------------------------------------------------------------------------
-- QA clockable employee (single open clock_in)
-- -------------------------------------------------------------------------
do $$
declare
    v_usr int;
    v_emp int;
begin
    if not exists (select 1 from employee where ema_emp = 'qa.clockable@miacaomigo.pt') then
        insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
        values (
            'QA Clockable Employee',
            'Avenida Central 100, Braga',
            '4700-100',
            '610000099',
            '+351910300099',
            'qa.clockable.user@gmail.com'
        )
        returning id_usr into v_usr;

        insert into employee (id_usr, reg_dat_emp, aut_reg_emp, pho_emp, ema_emp, pas_emp)
        values (
            v_usr,
            current_timestamp - interval '1 year',
            1,
            '+351253000099',
            'qa.clockable@miacaomigo.pt',
            '$2b$12$cstress_u12_active'
        )
        returning id_emp into v_emp;
    else
        select id_emp into v_emp from employee where ema_emp = 'qa.clockable@miacaomigo.pt';
    end if;

    update clock_in set end_dat_clk = current_timestamp
     where id_emp = v_emp and end_dat_clk is null;

    insert into clock_in (id_emp, sta_dat_clk)
    values (v_emp, current_timestamp - interval '75 minutes');
end;
$$;

-- -------------------------------------------------------------------------
-- QA absence overlap seed (pending window +15 days)
-- -------------------------------------------------------------------------
do $$
declare
    v_emp int;
begin
    if not exists (select 1 from employee where ema_emp = '21@miacaomigo.pt') then
        insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
        values (
            'QA Absence Overlap Vet',
            'Rua Ferreira Borges 10, Aveiro',
            '3800-041',
            '610000021',
            '+351910300021',
            'filipe.castro.cstress@outlook.pt'
        );

        insert into employee (id_usr, reg_dat_emp, aut_reg_emp, pho_emp, ema_emp, pas_emp)
        select
            u.id_usr,
            current_timestamp - interval '3 years',
            1,
            '+351253461001',
            '21@miacaomigo.pt',
            '$2b$12$cstress_u21_vet'
          from user_account u
         where u.ema_usr = 'filipe.castro.cstress@outlook.pt';

        insert into occupies (id_emp, id_pro)
        select e.id_emp, 2 from employee e where e.ema_emp = '21@miacaomigo.pt';

        insert into veterinarian (id_emp, num_omv_vet)
        select e.id_emp, 'OMV-PT-2023-CR-03319'
          from employee e where e.ema_emp = '21@miacaomigo.pt';
    end if;

    select id_emp into v_emp from employee where ema_emp = '21@miacaomigo.pt';

    delete from absence
     where id_emp = v_emp
       and mot_abs like 'qa fixture%';

    insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs, cre_tim_abs)
    values (
        v_emp,
        current_timestamp + interval '15 days',
        current_timestamp + interval '16 days',
        'qa fixture pending absence overlap seed',
        'pending',
        current_timestamp - interval '3 days'
    );
end;
$$;

-- -------------------------------------------------------------------------
-- Login session fixture (12@ — active session blocks second login)
-- -------------------------------------------------------------------------
do $$
declare
    v_usr int;
begin
    if not exists (select 1 from employee where ema_emp = '12@miacaomigo.pt') then
        insert into user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
        values (
            'QA Login Session Employee',
            'Largo do Toural 14, Guimaraes',
            '4810-431',
            '610000012',
            '+351910300012',
            'duarte.ramos.cstress@gmail.com'
        )
        returning id_usr into v_usr;

        insert into employee (id_usr, reg_dat_emp, aut_reg_emp, pho_emp, ema_emp, pas_emp)
        values (
            v_usr,
            current_timestamp - interval '8 months',
            1,
            '+351253452002',
            '12@miacaomigo.pt',
            '$2b$12$cstress_u12_active'
        );
    end if;

    select u.id_usr into v_usr
      from employee e
      join user_account u on u.id_usr = e.id_usr
     where e.ema_emp = '12@miacaomigo.pt';

    delete from login_record
     where ema_log = '12@miacaomigo.pt' and sou_tim_log is null;

    insert into login_record (sig_tim_log, sou_tim_log, suc_log, ip_add_log, ema_log, id_usr)
    values (
        current_timestamp - interval '90 minutes',
        null,
        true,
        '192.168.60.77'::inet,
        '12@miacaomigo.pt',
        v_usr
    );
end;
$$;
