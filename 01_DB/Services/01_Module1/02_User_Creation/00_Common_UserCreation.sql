--=========================================================
-- COMMON CREATE FUNCTIONS
--=========================================================
-- Description:
-- Shared helper functions used by multiple creation flows
-- (client, employee, veterinarian, assistant).
--
-- Scope:
-- - User account creation
-- - Existing user retrieval
-- - Profile association
--
-- Notes:
-- - Business-role logic is NOT handled here
-- - Integrity is enforced through constraints
-- - Functions are designed for reuse
--=========================================================



--=========================================================
-- function: fn_create_user_account
--=========================================================
-- description:
-- creates a new base user identity.
--
-- purpose:
-- - centralize user creation logic
-- - guarantee normalized insertion
-- - support shared identities between roles
--
-- behavior:
-- - inserts into user_account
-- - automatic setup creation occurs via trigger
-- - returns created user id
--
-- notes:
-- - duplicate users are blocked by constraints
-- - validation relies primarily on table constraints
--=========================================================

create or replace function fn_create_user_account(

    p_nam_usr varchar,
    p_add_usr text,
    p_pos_usr varchar,
    p_nif_usr varchar,
    p_pho_usr varchar,
    p_ema_usr varchar

)
returns int as $$

declare

    v_id_usr int;

begin

    --=====================================================
    -- 1. NORMALIZE INPUT
    --=====================================================

    p_nam_usr := trim(p_nam_usr);
    p_add_usr := trim(p_add_usr);
    p_pos_usr := trim(p_pos_usr);
    p_nif_usr := trim(p_nif_usr);
    p_pho_usr := trim(p_pho_usr);
    p_ema_usr := normalize_email(p_ema_usr);

    --=====================================================
    -- 2. CREATE USER ACCOUNT
    --=====================================================

    insert into user_account (

        nam_usr,
        add_usr,
        pos_usr,
        nif_usr,
        pho_usr,
        ema_usr

    )
    values (

        p_nam_usr,
        p_add_usr,
        p_pos_usr,
        p_nif_usr,
        p_pho_usr,
        p_ema_usr

    )

    returning id_usr
    into v_id_usr;

    --=====================================================
    -- 3. RETURN CREATED USER
    --=====================================================

    return v_id_usr;

--=========================================================
-- EXCEPTION HANDLING
--=========================================================

exception

    --=====================================================
    -- UNIQUE VIOLATION
    --=====================================================

    when unique_violation then

        raise exception using

            message = 'User already exists.',

            detail = sqlerrm,

            errcode = sqlstate;

    --=====================================================
    -- CHECK CONSTRAINT VIOLATION
    --=====================================================

    when check_violation then

        raise exception using

            message = 'User data validation failed.',

            detail = sqlerrm,

            errcode = sqlstate;

    --=====================================================
    -- INVALID TEXT / ENUM / FORMAT
    --=====================================================

    when invalid_text_representation then

        raise exception using

            message = 'Invalid textual value provided.',

            detail = sqlerrm,

            errcode = sqlstate;

    --=====================================================
    -- GENERIC ERROR
    --=====================================================

    when others then

        raise exception using

            message = 'Unexpected error while creating user account.',

            detail = sqlerrm,

            errcode = sqlstate;

end;

$$ language plpgsql;



--=========================================================
-- function: fn_assign_profile
--=========================================================
-- description:
-- associates a profile to an employee.
--
-- purpose:
-- - centralize occupies insertion
-- - avoid duplicated assignment logic
--=========================================================

create or replace function fn_assign_profile(

    p_id_emp int,
    p_id_pro int

)
returns void as $$

begin

    --=====================================================
    -- 1. ASSIGN PROFILE
    --=====================================================

    insert into occupies (

        id_emp,
        id_pro

    )
    values (

        p_id_emp,
        p_id_pro

    );

--=========================================================
-- EXCEPTION HANDLING
--=========================================================

exception

    when unique_violation then

        raise exception using

            message = 'Profile already assigned to employee.',

            detail = sqlerrm,

            errcode = sqlstate;

    when foreign_key_violation then

        raise exception using

            message = 'Invalid employee or profile reference.',

            detail = sqlerrm,

            errcode = sqlstate;

    when others then

        raise exception using

            message = 'Unexpected error while assigning profile.',

            detail = sqlerrm,

            errcode = sqlstate;

end;

$$ language plpgsql;

