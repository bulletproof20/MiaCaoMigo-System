--=================================================================
-- FICHEIRO DE TESTES - MÓDULO 2 (GESTÃO DE ANIMAIS)
--=================================================================
-- Este ficheiro contém uma série de consultas para validar
-- a integridade dos dados e o comportamento esperado das
-- funções, procedures e triggers do Módulo 2.
-- Execute cada query individualmente para verificar os resultados.
--=================================================================

-- Teste 1: Listar todos os animais com a sua espécie e raça
-- Objetivo: Verificar se os joins básicos entre animal, species e breed funcionam.
select
    a.id_ani as "ID Animal",
    a.nam_ani as "Nome",
    s.nam_spc as "Espécie",
    b.nam_bre as "Raça",
    a.sta_ani as "Estado"
from
    animal a
join
    species s on a.id_spc = s.id_spc
left join
    breed b on a.id_bre = b.id_bre
order by
    a.id_ani;

-- Teste 2: Listar animais disponíveis para adoção
-- Objetivo: Verificar a lógica de estado do animal. Apenas animais com estado 'Interno' devem aparecer.
select
    id_ani,
    nam_ani,
    sta_ani
from
    animal
where
    sta_ani = 'Interno';

-- Teste 3: Ver o histórico completo de um animal (posses e concessões)
-- Objetivo: Validar a capacidade de rastrear a vida de um animal na clínica.
-- Vamos usar o animal com ID 3, que foi adotado.
select
    'Posse' as "Tipo de Evento",
    o.sta_dat_own as "Data Início",
    o.end_dat_own as "Data Fim",
    'Cliente ' || c.id_cli as "Envolvido",
    o.mot_own as "Motivo"
from
    ownership o
join
    client c on o.id_cli = c.id_cli
where
    o.id_ani = 3
union all
select
    'Concessão' as "Tipo de Evento",
    con.dat_con as "Data Início",
    null as "Data Fim",
    'Entidade ' || ee.nam_ext_ent as "Envolvido",
    con.mot_con as "Motivo"
from
    concession con
join
    external_entity ee on con.id_ext_ent = ee.id_ext_ent
where
    con.id_ani = 3
order by
    "Data Início" desc;

-- Teste 4: Listar todas as posses ativas
-- Objetivo: Verificar a constraint/índice que garante apenas uma posse ativa por animal.
select
    o.id_own,
    a.nam_ani as "Animal",
    c.id_cli as "ID Cliente",
    o.sta_dat_own as "Data de Início da Posse"
from
    ownership o
join
    animal a on o.id_ani = a.id_ani
join
    client c on o.id_cli = c.id_cli
where
    o.end_dat_own is null;

-- Teste 5: Listar entregas (rescates) e os funcionários envolvidos
-- Objetivo: Testar a relação muitos-para-muitos entre delivery e employee.
select
    d.id_del as "ID Entrega",
    a.nam_ani as "Animal",
    d.res_loc_del as "Local de Resgate",
    string_agg(e.id_emp::text, ', ') as "IDs Funcionários"
from
    delivery d
join
    animal a on d.id_ani = a.id_ani
join
    delivery_employee de on d.id_del = de.id_del
join
    employee e on de.id_emp = e.id_emp
group by
    d.id_del, a.nam_ani, d.res_loc_del
order by
    d.id_del;

-- Teste 6: Tentar atribuir uma posse a um animal já adotado
-- Objetivo: Verificar se a trigger/constraint 'trg_prevent_duplicate_active_ownership' ou o índice único está a funcionar.
-- Isto DEVE falhar com uma exceção.
do $$
begin
    -- Tenta atribuir o animal com ID 3 (que já está 'Adotado') a um novo cliente (ID 5).
    call prc_assign_ownership(3, 5, 1, 'Tentativa de adoção duplicada');
exception
    when others then
        raise notice 'TESTE BEM SUCEDIDO: A exceção foi apanhada, o que impede posses duplicadas. Mensagem: %', sqlerrm;
end;
$$;

-- Teste 7: Executar o procedimento para registar uma nova adoção
-- Objetivo: Testar o procedure 'prc_assign_ownership' num animal disponível.
-- Vamos adotar o animal 'Bobby' (ID 1) para o cliente com ID 4.
call prc_assign_ownership(p_id_ani => 1, p_id_cli => 4, p_id_emp => 1, p_mot_own => 'Adoção via teste');

-- Verificação do Teste 7:
-- Confirma se o estado do animal 'Bobby' foi atualizado para 'Adotado' e se existe um novo registo de posse.
select id_ani, nam_ani, sta_ani from animal where id_ani = 1;
select * from ownership where id_ani = 1 and end_dat_own is null;

-- Teste 8: Terminar a posse criada no teste anterior
-- Objetivo: Testar o procedure 'prc_end_ownership'.
call prc_end_ownership(p_id_ani => 1, p_reason => 'Devolução via teste');

-- Verificação do Teste 8:
-- Confirma se o estado do animal 'Bobby' voltou a 'Interno' e se a posse tem uma data de fim.
select id_ani, nam_ani, sta_ani from animal where id_ani = 1;
select * from ownership where id_ani = 1 order by sta_dat_own desc;