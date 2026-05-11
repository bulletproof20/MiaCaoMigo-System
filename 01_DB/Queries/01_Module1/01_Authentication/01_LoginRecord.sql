-- All data from login record

select * from login_record;


-- Tentativas de login de email não reconhecido
-- Simplified by model design
select 
    lgn_rcd.id_log,
    lgn_rcd.sig_tim_log,
    lgn_rcd.sou_tim_log,
    lgn_rcd.suc_log,
    lgn_rcd.ip_add_log,
    lgn_rcd.eml_usr,
    lgn_rcd.id_usr
    
from login_record as lgn_rcd

where lgn_rcd.eml_usr is null
;



-- Tentaivas de login como cliente

-- Tentativa de login como empregado







-- contas atualmente iniciadas de cliente 

-- contas atualmente iniciadas de empregado

-- users com conta de cliente e empregado abertas

-- 