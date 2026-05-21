-- =========================================================
-- INTEGRITY — MODULE 4 — VET ABSENCE BLOCK
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     trg_block_appointment_if_vet_unavailable
-- CONTRACT: qa_vet_primary_id, qa_client_active_id, qa_animal_adopted_id, qa_specialty_general_id
-- =========================================================
-- expected:
-- - appointment during approved absence blocked
-- =========================================================

do $$
declare
    v_slot timestamp := now() + interval '9 days';
    v_emp int := qa_vet_primary_id();
    v_cli int := qa_client_active_id();
    v_ani int := qa_animal_adopted_id();
    v_spe int := qa_specialty_general_id();
begin
    insert into absence (id_emp, sta_dat_tim_abs, end_dat_tim_abs, mot_abs, sta_abs, cre_tim_abs)
    values (
        v_emp,
        v_slot - interval '1 hour',
        v_slot + interval '2 hours',
        'integrity vet absence block',
        'approved',
        current_timestamp
    );

    call sp_create_appointment(v_cli, v_ani, v_emp, v_spe, v_slot);
    raise notice 'FAIL: appointment during vet absence should be blocked';
exception
    when others then
        if sqlerrm ilike '%indispon%' or sqlerrm ilike '%ausência%' or sqlerrm ilike '%ausencia%' then
            raise notice 'PASS: appointment during vet absence blocked';
        else
            raise notice 'FAIL: unexpected vet absence error — %', sqlerrm;
        end if;
end;
$$;

delete from absence where mot_abs = 'integrity vet absence block';
