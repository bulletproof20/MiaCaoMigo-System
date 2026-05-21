-- =========================================================
-- INTEGRITY — MODULE 2 — OWNERSHIP LIFECYCLE
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: fixtures/cleanup/02_Reset_Module2_Animal1.sql (runner prefix)
-- RULE:     sp_assign_ownership, sp_end_ownership
-- CONTRACT: qa_animal_internal_id, qa_client_active_id, qa_registrar_emp_id
-- =========================================================

do $$
declare
    v_ani int := qa_animal_internal_id();
    v_cli int := qa_client_active_id();
    v_emp int := qa_registrar_emp_id();
begin
    call sp_assign_ownership(v_ani, v_cli, v_emp, 'Integrity assign');
end;
$$;

do $$
declare
    v_sta varchar;
    v_active int;
    v_ani int := qa_animal_internal_id();
begin
    select sta_ani into v_sta from animal where id_ani = v_ani;
    select count(*) into v_active from ownership where id_ani = v_ani and end_dat_own is null;

    if v_sta = 'Adotado' and v_active = 1 then
        raise notice 'PASS: sp_assign_ownership updated animal and ownership';
    else
        raise notice 'FAIL: after assign — sta_ani=%, active_ownerships=%', v_sta, v_active;
    end if;
end;
$$;

do $$
declare
    v_ani int := qa_animal_internal_id();
begin
    call sp_end_ownership(v_ani, 'Integrity return');
end;
$$;

do $$
declare
    v_sta varchar;
    v_closed int;
    v_ani int := qa_animal_internal_id();
begin
    select sta_ani into v_sta from animal where id_ani = v_ani;
    select count(*) into v_closed from ownership where id_ani = v_ani and end_dat_own is not null;

    if v_sta = 'Interno' and v_closed >= 1 then
        raise notice 'PASS: sp_end_ownership restored internal status';
    else
        raise notice 'FAIL: after end — sta_ani=%, closed_ownerships=%', v_sta, v_closed;
    end if;
end;
$$;
