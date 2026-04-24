
--=========================================================
-- update_password(id_usr, new_password)
-- Atualiza password do utilizador (cliente ou empregado)
--=========================================================
DROP IF EXISTS FUNCTION pass_change(varchar, varchar, varchar)
CREATE FUNCTION pass_change(
    p_email varchar,
    old_pass varchar,
    p_new_pass varchar
) RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- 1. Check if it's an internal employee email
    IF (p_email LIKE '%@miacaomigo.pt') THEN
        
        -- Update the employee table
        UPDATE employee 
        SET pas_emp = p_new_pass 
        WHERE ema_emp = p_email and old_pass = employee.pas_emp;

    ELSE
        -- 2. It's a client (using personal email from user_account)
        -- We need to join with user_account because client table only has id_usr
        UPDATE client
        SET pas_cli = p_new_pass
        WHERE id_usr = (SELECT id_usr FROM user_account WHERE ema_usr = p_email and old_pass = pas_cli);

    END IF;

    -- 3. Check if any row was actually updated
    IF NOT FOUND THEN
        RAISE EXCEPTION 'User with email % not found.', p_email;
    END IF;

    RETURN TRUE;

EXCEPTION WHEN OTHERS THEN
    RAISE EXCEPTION 'Error during password credential change: %', SQLERRM;
END;
$$;
GRANT EXECUTE ON FUNCTION pass_change TO anon;


--=========================================================
-- deactivate_account(id_usr)
-- Desativa conta (cliente ou empregado)
--=========================================================
DROP IF EXISTS FUNCTION deact_account
CREATE  FUNCTION deact_account(
    email varchar,
    password varchar
) RETURN boolean
LANGUAGE plpgsql AS $$
SECURITY DEFINER
BEGIN
    
    IF (p_email LIKE '%@miacaomigo.pt') THEN
        
        -- Update the employee table
        UPDATE employee 
        SET pas_emp = null 
        WHERE ema_emp = email and password = employee.pas_emp;

    ELSE
        -- 2. It's a client (using personal email from user_account)
        -- We need to join with user_account because client table only has id_usr
        UPDATE client
        SET pas_cli = p_new_pass
        WHERE id_usr = (SELECT id_usr FROM user_account WHERE ema_usr = p_email and old_pass = pas_cli);

    END IF;


EXCEPTION IF OTHERS THEN 
    RAISE EXCEPTION 'Error during account deactivations: %', SQLERRM;
END;
GRANTE EXECUTE ON FUNCTION deact_account TO anon;



--=========================================================
-- reactivate_account(id_usr)
-- Reativa conta
--=========================================================

--=========================================================
-- is_account_active(id_usr)
-- Verifica se a conta está ativa
--=========================================================

--=========================================================
-- get_employee_email(id_usr)
-- Devolve p_ema do empregado (id_usr@miacaomigo.pt)
--=========================================================
--=========================================================

-- assign_profile(id_emp, id_pro)
-- Associa perfil ao empregado
-- assign_specialization(id_emp, type)
-- Define especialização (assistant ou veterinarian)

