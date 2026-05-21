-- =========================================================
-- INTEGRITY — MODULE 2 — DELIVERY DATE CONSISTENCY
-- =========================================================
-- TYPE:     01_Integrity
-- REQUIRES: 04_Loaders/03_TestData.sql
-- RULE:     trg_check_delivery_date_consistency
-- FIXTURES: animal 5 internal (no delivery yet)
-- =========================================================
-- expected:
-- - delivery date earlier than rescue date blocked
-- =========================================================

do $$
begin
    insert into delivery (
        reg_dat_del, res_dat_del, del_dat_del, res_loc_del, cli_sta_del, id_ext_ent, id_ani
    )
    values (
        now(),
        current_timestamp,
        current_timestamp - interval '2 days',
        'Integrity test location',
        'Test state',
        1,
        5
    );

    raise notice 'FAIL: delivery before rescue date should be blocked';
exception
    when others then
        if sqlerrm like '%Delivery date%' or sqlerrm like '%rescue%' then
            raise notice 'PASS: delivery date consistency blocked — %', sqlerrm;
        else
            raise notice 'FAIL: unexpected delivery date error — %', sqlerrm;
        end if;
end;
$$;
