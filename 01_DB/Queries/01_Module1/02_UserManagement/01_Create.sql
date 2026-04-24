
--=========================================================
-- Create a new client account
--=========================================================
DROP FUNCTION IF EXISTS reg_new_clt(varchar, text, varchar, varchar, varchar, varchar,varchar);

CREATE FUNCTION reg_new_clt(
    p_usr_nam varchar,
    p_usr_add text,
    p_usr_zip varchar,
    p_user_nif varchar,
    p_usr_pho varchar,
    p_ema varchar,
    p_pass varchar
) RETURNS int 

LANGUAGE plpgsql 
-- SECURITY DEFINER ensures that the function executes with the privileges of the user who created it, not the caller. 
--This is crucial for maintaining security while allowing necessary operations.
SECURITY DEFINER 
AS $$
DECLARE
    var_user_id int;
BEGIN
    -- 1. Check if the user already exists (by NIF or Email)
    -- This prevents duplicate entries before attempting the INSERT
    IF EXISTS (SELECT 1 FROM user_account WHERE nif_usr = p_user_nif OR ema_usr = p_ema) THEN
        RAISE EXCEPTION 'A user with this NIF or Email already exists.';
    END IF;

    -- 2. Insert into user_account
    INSERT INTO user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
    VALUES (p_usr_nam, p_usr_add, p_usr_zip, p_user_nif, p_usr_pho, p_ema)
    RETURNING id_usr INTO var_user_id;

    -- 3. Insert into client
    -- Since it's a new user, we create the client profile
    INSERT INTO client (id_usr, pas_cli, reg_dat_cli)
    VALUES (var_user_id, p_pass, current_timestamp);

    RETURN var_user_id;

EXCEPTION WHEN OTHERS THEN
    -- If anything fails, the entire transaction is rolled back
    RAISE EXCEPTION 'Error during client registration: %', SQLERRM;
END;
$$;
-- Grant permissions for the anonymous API key
GRANT EXECUTE ON FUNCTION reg_new_clt TO anon;

--=========================================================
-- Create a new employee account(...)
--=========================================================

DROP FUNCTION IF EXISTS reg_new_clt(varchar, text, varchar, varchar, varchar, varchar, varchar, int, varchar, varchar,varchar, timestamp);

CREATE FUNCTION reg_new_emp(
    p_usr_nam varchar,
    p_usr_add text,
    p_usr_zip varchar,
    p_user_nif varchar,
    p_usr_pho varchar,
    per_email varchar,
    p_pass varchar,
    resp_id int,
    phn_emp varchar,
    phn_emg varchar,
    role varchar,
    reg_date timestamp DEFAULT current_timestamp
) RETURNS int 
LANGUAGE plpgsql 
SECURITY DEFINER AS $$
DECLARE
    var_user_id int;
    var_emp_id int;
    var_gen_email varchar;
BEGIN
    -- 1. Procurar utilizador existente
    SELECT id_usr INTO var_user_id 
    FROM user_account 
    WHERE nif_usr = p_user_nif OR ema_usr = per_email
    LIMIT 1;

    -- 2. Criar conta de utilizador se não existir
    IF (var_user_id IS NULL) THEN
        INSERT INTO user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
        VALUES (p_usr_nam, p_usr_add, p_usr_zip, p_user_nif, p_usr_pho, per_email)
        RETURNING id_usr INTO var_user_id;
    END IF;

    -- 3. Verificar se já é funcionário (para evitar duplicados na tabela employee)
    IF EXISTS (SELECT 1 FROM employee WHERE id_usr = var_user_id) THEN
        RAISE EXCEPTION 'This user is already registered as an employee.';
    END IF;

    -- 4. Gerar p_ema profissional
    var_gen_email := var_user_id || '@miacaomigo.pt';

    -- 5. Inserir na tabela Employee
    INSERT INTO employee (id_usr, pas_emp, reg_dat_emp, aut_reg_emp, pho_emp, pho_emg, ema_emp)
    VALUES (var_user_id, p_pass, reg_date, resp_id, phn_emp, phn_emg, var_gen_email)
    RETURNING id_emp INTO var_emp_id;

    -- 6. Inserir na tabela Assistant (Usando var_emp_id)
    INSERT INTO assistant(id_emp, fun_ass)
    VALUES (var_emp_id, role);

    -- 7. Garantir que ele também existe como Cliente 
    INSERT INTO client(id_usr, pas_cli, reg_dat_cli)
    VALUES (var_user_id, p_pass, current_timestamp)
    ON CONFLICT (id_usr) DO NOTHING;

    RETURN var_user_id;

EXCEPTION WHEN OTHERS THEN
    -- O SQLERRM ajuda a debugar o erro exato que o Postgres está a lançar
    RAISE EXCEPTION 'Error during employee registration: %', SQLERRM;
END;
$$;

GRANT EXECUTE ON FUNCTION reg_new_emp TO anon;

-- =========================================================
-- TEMPORARIO
GRANT EXECUTE ON FUNCTION user_exists TO anon;
GRANT EXECUTE ON FUNCTION get_user_by_email TO anon;
GRANT EXECUTE ON FUNCTION validate_password TO anon;
GRANT EXECUTE ON FUNCTION has_active_sessions TO anon;
-- =========================================================




--=========================================================
-- reactivate_account(id_usr)
-- Reativa conta
--=========================================================
--=========================================================
-- can_user_login(id_usr)
-- Verifica se já existe sessão ativa
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