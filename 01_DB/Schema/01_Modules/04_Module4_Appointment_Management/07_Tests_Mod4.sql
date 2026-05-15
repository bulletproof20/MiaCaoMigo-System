--=========================================================
-- TESTS - MODULE 4
-- Automated checks for appointment rules including specialty × vet.
-- Run after full schema + representative seed (ownership + expert rows).
--=========================================================

do $$
declare
    v_cli int;
    v_ani int;
    v_vet int;
    v_spe int;
    v_bad_spe int;
    v_app int;
    v_spec_name varchar(100);
begin
    raise notice '=========================================================';
    raise notice 'MODULE 4 — TEST SUITE';
    raise notice '=========================================================';

    select o.id_cli,
           o.id_ani,
           x.id_emp,
           x.id_spe
      into v_cli, v_ani, v_vet, v_spe
      from ownership o
      cross join lateral (
          select e.id_emp, e.id_spe
          from expert e
          join employee emp on emp.id_emp = e.id_emp and emp.dea_dat_emp is null
          join veterinarian vt on vt.id_emp = e.id_emp
          limit 1
      ) x
     where o.end_dat_own is null
     limit 1;

    if v_cli is null then
        raise notice 'SKIP: no active ownership / expert combination — seed Modules 1–2 first.';
        return;
    end if;

    raise notice 'Using client % animal % vet % specialty %', v_cli, v_ani, v_vet, v_spe;

    begin
        call sp_create_appointment(v_cli, v_ani, v_vet, v_spe, now() + interval '3 days');
        raise notice 'PASS: sp_create_appointment';
    exception when others then
        raise notice 'FAIL: sp_create_appointment — %', sqlerrm;
    end;

    begin
        call sp_create_appointment(v_cli, v_ani, v_vet, v_spe, now() - interval '1 day');
        raise notice 'FAIL: past appointment should be blocked';
    exception when others then
        if sqlerrm like '%passado%' then
            raise notice 'PASS: past appointment blocked';
        else
            raise notice 'FAIL: unexpected — %', sqlerrm;
        end if;
    end;

    select s.id_spe
      into v_bad_spe
      from specialty s
     where not exists (
               select 1 from expert x
                where x.id_emp = v_vet and x.id_spe = s.id_spe
           )
     order by s.id_spe
     limit 1;

    if v_bad_spe is not null then
        begin
            call sp_create_appointment(v_cli, v_ani, v_vet, v_bad_spe, now() + interval '8 days');
            raise notice 'FAIL: vet without specialty should be blocked';
        exception when others then
            if sqlerrm like '%especialidade%' or sqlerrm like '%credenciado%' or sqlerrm like '%associado%' then
                raise notice 'PASS: vet specialty mismatch blocked';
            else
                raise notice 'FAIL: unexpected — %', sqlerrm;
            end if;
        end;
    else
        raise notice 'SKIP: no specialty outside vet expert set';
    end if;

    begin
        select a.id_app
          into v_app
          from appointment a
         where a.id_cli = v_cli
         order by a.id_app desc
         limit 1;

        select f.specialty_name
          into v_spec_name
          from fn_appointment_see_app_clt(v_cli) f
         where f.appointment_id = v_app;

        if v_spec_name is not null and length(trim(v_spec_name)) > 0 then
            raise notice 'PASS: fn_appointment_see_app_clt exposes specialty_name';
        else
            raise notice 'FAIL: specialty_name missing for appointment %', v_app;
        end if;
    exception when others then
        raise notice 'FAIL: client portal — %', sqlerrm;
    end;

    raise notice '=========================================================';
    raise notice 'MODULE 4 — TEST SUITE FINISHED';
    raise notice '=========================================================';
end;
$$;
