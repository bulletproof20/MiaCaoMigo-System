-- =========================================================
-- QA CLEANUP — reset animal 1 for idempotent Mod2 lifecycle test
-- =========================================================

do $$
declare
    v_ani int := qa_animal_internal_id();
begin
    if v_ani is null then
        return;
    end if;

    update ownership
    set end_dat_own = coalesce(end_dat_own, current_date),
        mot_own = coalesce(mot_own, 'QA cleanup')
    where id_ani = v_ani
      and end_dat_own is null;

    update animal set sta_ani = 'Interno' where id_ani = v_ani;
end;
$$;
