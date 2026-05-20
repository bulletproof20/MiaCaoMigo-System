-- =========================================================
-- INTEGRITY — MODULE 2 — OWNERSHIP LIFECYCLE
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     sp_assign_ownership, sp_end_ownership
-- FIXTURES: animal 1 internal; id_cli 4; id_emp 1
-- =========================================================
-- expected:
-- - assign sets Adotado + one active ownership
-- - end restores Interno and closes ownership
-- =========================================================

-- TEST 01 — assign ownership on internal animal
call sp_assign_ownership(p_id_ani => 1, p_id_cli => 4, p_id_emp => 1, p_mot_own => 'Integrity assign');

do $$
declare
    v_sta varchar;
    v_active int;
begin
    select sta_ani into v_sta from animal where id_ani = 1;
    select count(*) into v_active from ownership where id_ani = 1 and end_dat_own is null;

    if v_sta = 'Adotado' and v_active = 1 then
        raise notice 'PASS: sp_assign_ownership updated animal and ownership';
    else
        raise notice 'FAIL: after assign — sta_ani=%, active_ownerships=%', v_sta, v_active;
    end if;
end;
$$;

-- TEST 02 — end ownership
call sp_end_ownership(p_id_ani => 1, p_mot_own => 'Integrity return');

do $$
declare
    v_sta varchar;
    v_closed int;
begin
    select sta_ani into v_sta from animal where id_ani = 1;
    select count(*) into v_closed from ownership where id_ani = 1 and end_dat_own is not null;

    if v_sta = 'Interno' and v_closed >= 1 then
        raise notice 'PASS: sp_end_ownership restored internal status';
    else
        raise notice 'FAIL: after end — sta_ani=%, closed_ownerships=%', v_sta, v_closed;
    end if;
end;
$$;
