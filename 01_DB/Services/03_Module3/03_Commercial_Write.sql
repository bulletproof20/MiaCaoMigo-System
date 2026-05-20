-- =========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT (SERVICES)
-- FILE: 03_Commercial_Write.sql
-- =========================================================
--
-- Write wrappers: service function → schema procedure.
-- Depends on: sp_receive_purchase, sp_check_restock_needs
--             (05_Procedures_Mod3.sql).
-- =========================================================

drop function if exists fn_receive_purchase(int);

create function fn_receive_purchase(p_id_pur int)
returns void
language plpgsql
as $$
begin
    call sp_receive_purchase(p_id_pur);
end;
$$;


drop function if exists fn_check_restock_needs();

create function fn_check_restock_needs()
returns void
language plpgsql
as $$
begin
    call sp_check_restock_needs();
end;
$$;
