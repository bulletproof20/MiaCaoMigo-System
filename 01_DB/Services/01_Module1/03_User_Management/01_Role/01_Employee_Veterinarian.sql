-- Role change (Employee -> Veterinarian)

--if id_emp not exists
--    trow excepcion

--if the id_usr have any id_emp active
--   if the id_emp is already a veterinarian
--      trow exception
--   try inativate the existing id_emp (set dat_end_emp to current date)

--try create a new id_emp (replicate the data of the old one but with a new id_emp)
--try create a new veterinarian with the new id_emp
--return ok       

drop function if exists fn_alter_employee_to_veterinarian(
    varchar, text, varchar, varchar, varchar, varchar,
    varchar, varchar, varchar,
    int,
    varchar
);

create or replace function fn_alter_employee_to_veterinarian(

    p_nam_usr varchar,
    p_add_usr text,
    p_pos_usr varchar,
    p_nif_usr varchar,
    p_pho_usr varchar,
    p_ema_usr varchar,

    p_pho_emp varchar,
    p_pho_emg varchar,
    p_pas_emp varchar,

    p_id_emp_reg int,

    p_num_omv_vet varchar

)
return int as $$

declare

    v_id_emp int;





;