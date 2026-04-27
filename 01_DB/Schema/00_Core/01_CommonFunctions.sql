

-- =========================================================
-- FUNCTION: fn_normalize_text
-- Descrição: Normaliza texto (trim + lower)
-- =========================================================
drop function if exists fn_normalize_text(text);

create function fn_normalize_text(p_value text)
returns text as $$
begin
    -- return null if empty text
    return nullif(lower(trim(p_value)), '');
end;
$$ language plpgsql;

-- =========================================================
-- FUNCTION: fn_get_email_domain
-- Descrição: Extrai domínio de um email
-- =========================================================
drop function if exists fn_get_email_domain(varchar);

create function fn_get_email_domain(p_email varchar)
returns varchar as $$
declare
    v_email varchar;
begin

    v_email := normalize_email(p_email);

    if v_email is null or position('@' in v_email) = 0 then
        return null;
    end if;

    return split_part(v_email, '@', 2);

end;
$$ language plpgsql;

-- =========================================================
-- FUNCTION: fn_is_email_domain
-- Descrição: Verifica se email pertence a um domínio especifico
-- =========================================================
drop function if exists fn_is_email_domain(varchar, varchar);

create function fn_is_email_domain(p_email varchar, p_domain varchar)
returns boolean as $$
begin
    return normalize_email(p_email) like ('%@' || lower(trim(p_domain)));
end;
$$ language plpgsql;


-- =========================================================
-- FUNCTION: fn_time_overlap
-- Descrição: Verifica sobreposição entre intervalos TIME
-- =========================================================
drop function if exists fn_time_overlap(time, time, time, time);

create function fn_time_overlap(
    p_start1 time,
    p_end1 time,
    p_start2 time,
    p_end2 time
) returns boolean as $$
begin
    return (p_start1 < p_end2) and (p_end1 > p_start2);
end;
$$ language plpgsql;


-- =========================================================
-- FUNCTION: fn_timestamp_overlap
-- Descrição: Verifica sobreposição entre intervalos TIMESTAMP
-- =========================================================
drop function if exists fn_timestamp_overlap(timestamp, timestamp, timestamp, timestamp);

create function fn_timestamp_overlap(
    p_start1 timestamp,
    p_end1 timestamp,
    p_start2 timestamp,
    p_end2 timestamp
) returns boolean as $$
begin
    return (p_start1 < p_end2) and (p_end1 > p_start2);
end;
$$ language plpgsql;


-- =========================================================
-- FUNCTION: fn_timestamp_overlap_nullable
-- Descrição: Overlap com fim opcional (NULL = intervalo aberto)
-- =========================================================
drop function if exists fn_timestamp_overlap_nullable(timestamp, timestamp, timestamp, timestamp);

create function fn_timestamp_overlap_nullable(
    p_start1 timestamp,
    p_end1 timestamp,
    p_start2 timestamp,
    p_end2 timestamp
) returns boolean as $$
begin
    return (
        p_start1 < coalesce(p_end2, now())
        and coalesce(p_end1, now()) > p_start2
    );
end;
$$ language plpgsql;


-- =========================================================
-- FUNCTION: fn_validate_time_range
-- Descrição: Valida se start < end (TIME)
-- =========================================================
drop function if exists fn_validate_time_range(time, time);

create function fn_validate_time_range(
    p_start time,
    p_end time
) returns boolean as $$
begin
    return p_start < p_end;
end;
$$ language plpgsql;


-- =========================================================
-- FUNCTION: fn_validate_timestamp_range
-- Descrição: Valida se start < end (TIMESTAMP)
-- =========================================================
drop function if exists fn_validate_timestamp_range(timestamp, timestamp);

create function fn_validate_timestamp_range(
    p_start timestamp,
    p_end timestamp
) returns boolean as $$
begin
    if p_end is null then
        return true;
    end if;

    return p_start < p_end;
end;
$$ language plpgsql;