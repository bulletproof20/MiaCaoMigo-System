-- =========================================================
-- MODULE 2 — ANIMAL MANAGEMENT (SERVICES)
-- FILE: 01_Animal_Lifecycle.sql
-- =========================================================
--
-- Thin wrappers around schema procedures (05_Procedures_Mod2).
-- Preserves existing fn_* signatures for application compatibility.
-- =========================================================

-- ---------------------------------------------------------
-- fn_register_adoption → sp_assign_ownership
-- ---------------------------------------------------------

drop function if exists fn_register_adoption(int, int, int, varchar);

create function fn_register_adoption(
    p_id_cli int,
    p_id_ani int,
    p_id_emp int,
    p_motive varchar
)
returns void
language plpgsql
as $$
begin
    call sp_assign_ownership(p_id_ani, p_id_cli, p_id_emp, p_motive);
end;
$$;


-- ---------------------------------------------------------
-- fn_register_delivery_team → sp_record_delivery
-- ---------------------------------------------------------

drop function if exists fn_register_delivery_team(int, int, varchar, varchar, int[]);

create function fn_register_delivery_team(
    p_id_ani int,
    p_id_ext int,
    p_location varchar,
    p_status_clinic varchar,
    p_emp_ids int[]
)
returns void
language plpgsql
as $$
begin
    call sp_record_delivery(
        p_id_ani,
        current_timestamp,
        p_location,
        p_status_clinic,
        p_id_ext,
        p_emp_ids
    );
end;
$$;


-- ---------------------------------------------------------
-- fn_animal_exit — ownership closure + status update
-- (no matching single procedure for arbitrary exit reason)
-- ---------------------------------------------------------

drop function if exists fn_animal_exit(int, varchar);

create function fn_animal_exit(
    p_id_ani int,
    p_reason varchar
)
returns void
language plpgsql
as $$
begin

    update animal
    set sta_ani = p_reason
    where id_ani = p_id_ani;

    update ownership
    set end_dat_own = current_date
    where id_ani = p_id_ani
      and end_dat_own is null;

end;
$$;


-- ---------------------------------------------------------
-- fn_get_animal_history — merged ownership / concession trail
-- ---------------------------------------------------------

drop function if exists fn_get_animal_history(int);

create function fn_get_animal_history(p_id_ani int)
returns table(event_date date, description text)
language plpgsql
as $$
begin
    return query
    select o.sta_dat_own, 'Adopted by client id: ' || o.id_cli::text
    from ownership o
    where o.id_ani = p_id_ani
    union all
    select c.dat_con, 'Conceded to entity id: ' || c.id_ext_ent::text
    from concession c
    where c.id_ani = p_id_ani
    order by 1 desc;
end;
$$;
