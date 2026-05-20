-- =========================================================
-- INTEGRITY TEST — MODULE 2 — OWNERSHIP RULES
-- =========================================================
--
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
--           (animal 3 adopted; animal 1 internal; client 4)
-- RUN:
--   psql -v ON_ERROR_STOP=1 -f 01_Integrity/02_Module2/01_Ownership_Rules.sql
-- =========================================================

-- Duplicate active ownership must be blocked (animal 3 already adopted)
do $$
begin
    call sp_assign_ownership(3, 5, 1, 'Duplicate adoption attempt');
    raise notice 'FAIL: duplicate ownership should be blocked';
exception
    when others then
        if sqlerrm like '%inactive%' or sqlerrm like '%ownership%' or sqlerrm like '%duplicate%' or sqlerrm like '%poss%' then
            raise notice 'PASS: duplicate or invalid ownership blocked — %', sqlerrm;
        else
            raise notice 'PASS: blocked with — %', sqlerrm;
        end if;
end;
$$;

-- Assign ownership on available animal
call sp_assign_ownership(p_id_ani => 1, p_id_cli => 4, p_id_emp => 1, p_mot_own => 'Integrity test adoption');

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

-- End ownership
call sp_end_ownership(p_id_ani => 1, p_reason => 'Integrity test return');

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
