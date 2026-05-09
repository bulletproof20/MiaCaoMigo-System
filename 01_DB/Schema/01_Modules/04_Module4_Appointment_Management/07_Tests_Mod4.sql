--=========================================================
-- TESTS - MODULE 4
-- This script validates the business logic implemented in functions,
-- procedures, and triggers for appointment management.
-- To run, execute this entire file in a pgAdmin query tool.
-- Check the "Messages" tab for test results.
--=========================================================

-- Use a DO block to run tests without creating a permanent function
do $$
declare
    v_test_client_id int;
    v_test_animal_id int;
    v_test_vet_id int;
    v_test_app_id int;
    v_derived_status appointment_status;
begin
    raise notice '=========================================================';
    raise notice 'INICIANDO SUÍTE DE TESTES - MÓDULO 4';
    raise notice '=========================================================';

    -- 1. SETUP: Insert dummy data for tests
    -- We use ON CONFLICT DO NOTHING to avoid errors if data already exists.
    begin
        insert into client (id_cli, nam_usr) values (999, 'Cliente de Teste') on conflict (id_cli) do nothing;
        insert into employee (id_emp, nam_emp) values (999, 'Veterinário de Teste') on conflict (id_emp) do nothing;
        insert into animal (id_ani, nam_ani) values (999, 'Animal de Teste') on conflict (id_ani) do nothing;
        insert into ownership (id_cli, id_animal, sta_dat_own) values (999, 999, now()) on conflict (id_cli, id_animal) do nothing;

        v_test_client_id := 999;
        v_test_animal_id := 999;
        v_test_vet_id := 999;

        -- Clean up any previous test appointments
        delete from appointment where id_cli = v_test_client_id;
        delete from absence where id_emp = v_test_vet_id;

        raise notice 'SETUP: Dados de teste criados/verificados.';
    exception
        when others then
            raise notice 'SETUP FALHOU: %', sqlerrm;
            return;
    end;

    --=========================================================
    -- TESTE 1: Criar uma consulta válida
    --=========================================================
    begin
        call prc_create_appointment(v_test_client_id, v_test_animal_id, v_test_vet_id, now() + interval '3 days');
        raise notice 'SUCESSO: Teste 1 - Criar consulta válida.';
    exception
        when others then
            raise notice 'FALHA: Teste 1 - Criar consulta válida. Erro: %', sqlerrm;
    end;

    --=========================================================
    -- TESTE 2: Impedir consulta no passado (trg_block_past_appointments)
    --=========================================================
    begin
        call prc_create_appointment(v_test_client_id, v_test_animal_id, v_test_vet_id, now() - interval '1 day');
        raise notice 'FALHA: Teste 2 - Devia ter impedido consulta no passado.';
    exception
        when others then
            if sqlerrm like '%A data de início da consulta não pode ser no passado.%' then
                raise notice 'SUCESSO: Teste 2 - Impediu corretamente consulta no passado.';
            else
                raise notice 'FALHA: Teste 2 - Erro inesperado: %', sqlerrm;
            end if;
    end;

    --=========================================================
    -- TESTE 3: Impedir consulta sobreposta (trg_block_overlapping_appointments)
    --=========================================================
    begin
        -- First, create a valid appointment to conflict with
        call prc_create_appointment(v_test_client_id, v_test_animal_id, v_test_vet_id, now() + interval '4 days 10:00');
        -- Now, try to create another one at the same time
        call prc_create_appointment(v_test_client_id, v_test_animal_id, v_test_vet_id, now() + interval '4 days 10:05');
        raise notice 'FALHA: Teste 3 - Devia ter impedido consulta sobreposta.';
    exception
        when others then
            if sqlerrm like '%O veterinário já tem uma consulta sobreposta agendada.%' then
                raise notice 'SUCESSO: Teste 3 - Impediu corretamente consulta sobreposta.';
            else
                raise notice 'FALHA: Teste 3 - Erro inesperado: %', sqlerrm;
            end if;
    end;

    --=========================================================
    -- TESTE 4: Impedir consulta com animal de outro cliente (trg_validate_animal_client_relationship)
    --=========================================================
    begin
        -- Try to book for client 999 with an animal that is not theirs (e.g., animal 1)
        call prc_create_appointment(v_test_client_id, 1, v_test_vet_id, now() + interval '5 days');
        raise notice 'FALHA: Teste 4 - Devia ter impedido agendamento com animal de outro cliente.';
    exception
        when others then
            if sqlerrm like '%O animal com ID % não pertence ao cliente com ID %.' then
                raise notice 'SUCESSO: Teste 4 - Impediu corretamente agendamento com animal de outro cliente.';
            else
                raise notice 'FALHA: Teste 4 - Erro inesperado: %', sqlerrm;
            end if;
    end;

    --=========================================================
    -- TESTE 5: Cancelar consulta com mais de 24h de antecedência
    --=========================================================
    begin
        -- Create an appointment to be cancelled
        insert into appointment (id_cli, id_animal, id_emp, sch_dat_app, status_app)
        values (v_test_client_id, v_test_animal_id, v_test_vet_id, now() + interval '2 days', 'Scheduled')
        returning id_app into v_test_app_id;

        call prc_cancel_appointment(v_test_app_id);

        if (select status_app from appointment where id_app = v_test_app_id) = 'Cancelled' then
            raise notice 'SUCESSO: Teste 5 - Consulta cancelada com sucesso.';
        else
            raise notice 'FALHA: Teste 5 - O estado da consulta não foi alterado para Cancelled.';
        end if;
    exception
        when others then
            raise notice 'FALHA: Teste 5 - Erro inesperado ao cancelar: %', sqlerrm;
    end;

    --=========================================================
    -- TESTE 6: Impedir cancelamento com menos de 24h de antecedência
    --=========================================================
    begin
        -- Create an appointment to be cancelled
        insert into appointment (id_cli, id_animal, id_emp, sch_dat_app, status_app)
        values (v_test_client_id, v_test_animal_id, v_test_vet_id, now() + interval '12 hours', 'Scheduled')
        returning id_app into v_test_app_id;

        call prc_cancel_appointment(v_test_app_id);
        raise notice 'FALHA: Teste 6 - Devia ter impedido o cancelamento.';
    exception
        when others then
            if sqlerrm like '%A consulta só pode ser cancelada com mais de 24 horas de antecedência.%' then
                raise notice 'SUCESSO: Teste 6 - Impediu corretamente o cancelamento fora do prazo.';
            else
                raise notice 'FALHA: Teste 6 - Erro inesperado: %', sqlerrm;
            end if;
    end;

    --=========================================================
    -- TESTE 7: Iniciar e Terminar uma consulta (ciclo de vida)
    --=========================================================
    begin
        insert into appointment (id_cli, id_animal, id_emp, sch_dat_app, status_app)
        values (v_test_client_id, v_test_animal_id, v_test_vet_id, now() + interval '1 minute', 'Scheduled')
        returning id_app into v_test_app_id;

        -- Start
        call prc_start_appointment(v_test_app_id);
        if (select status_app from appointment where id_app = v_test_app_id) != 'In Progress' then
            raise exception 'Falha ao iniciar. Estado não é In Progress.';
        end if;

        -- End
        call prc_end_appointment(v_test_app_id, 'Diagnóstico de Teste', 'Comentários de Teste');
        if (select status_app from appointment where id_app = v_test_app_id) != 'Completed' then
            raise exception 'Falha ao terminar. Estado não é Completed.';
        end if;

        raise notice 'SUCESSO: Teste 7 - Ciclo de vida da consulta (Iniciar/Terminar) funcionou.';
    exception
        when others then
            raise notice 'FALHA: Teste 7 - Erro no ciclo de vida da consulta: %', sqlerrm;
    end;

    --=========================================================
    -- TESTE 8: Verificar estado derivado 'Late' na função de visualização
    --=========================================================
    begin
        -- Create an appointment in the past that is still 'Scheduled'
        insert into appointment (id_cli, id_animal, id_emp, sch_dat_app, status_app)
        values (v_test_client_id, v_test_animal_id, v_test_vet_id, now() - interval '1 hour', 'Scheduled')
        returning id_app into v_test_app_id;

        -- Call the function and check the derived status
        select status into v_derived_status from fn_appointment_see_app_clt(v_test_client_id) where appointment_id = v_test_app_id;

        if v_derived_status = 'Late' then
            raise notice 'SUCESSO: Teste 8 - Função `fn_appointment_see_app_clt` derivou o estado para "Late" corretamente.';
        else
            raise notice 'FALHA: Teste 8 - O estado derivado deveria ser "Late", mas foi "%".', v_derived_status;
        end if;
    exception
        when others then
            raise notice 'FALHA: Teste 8 - Erro ao verificar estado derivado: %', sqlerrm;
    end;

    raise notice '=========================================================';
    raise notice 'SUÍTE DE TESTES CONCLUÍDA.';
    raise notice '=========================================================';

end;
$$;
