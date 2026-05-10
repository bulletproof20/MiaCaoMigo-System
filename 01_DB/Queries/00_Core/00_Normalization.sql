--=========================================================
-- function: normalize_email
--=========================================================
-- description:
-- normalizes an email address by trimming whitespace
-- and converting to lowercase
--
-- purpose:
-- - ensure consistency across all authentication functions
-- - avoid duplicated normalization logic
--=========================================================
drop function if exists normalize_email(varchar);

create function normalize_email(p_email varchar)
returns varchar as $$
begin
    -- return nullif(lower(trim(p_email)), '');
    return lower(trim(p_email));
end;
$$ language plpgsql;


