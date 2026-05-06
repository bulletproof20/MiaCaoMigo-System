--=========================================================
--=========================================================
-- MODULE 4: APPOINTMENT MANAGEMENT - DATA SEED
--=========================================================

--=========================================================
-- 0. CLEAN DATA
--=========================================================
truncate table 
    rel_pre_prod,
    client_notification,
    rel_app_product,
    prescription,
    anamnesis,
    overall_assessment,
    appointment
restart identity cascade;

--=========================================================
-- 1. APPOINTMENT
-- Dependencies: animal(1,2), employee(1,2), client(4,5)
-- Note: Assuming animals with ID 1 and 2 were created in Mod2
--=========================================================
insert into appointment (id_animal, id_emp, id_cli, sch_dat_app, sta_dat_app, end_dat_app, status_app, dia_app, com_app) values
(1, 1, 4, now() + interval '1 day', now() + interval '25 hours', now() + interval '26 hours', 'Scheduled', null, 'Check-up anual'),
(2, 2, 5, now() - interval '2 days', now() - interval '47 hours', now() - interval '46 hours', 'Completed', 'Otite externa', 'Limpeza efetuada'),
(1, 1, 4, now() + interval '2 days', now() + interval '49 hours', now() + interval '50 hours', 'Scheduled', null, 'Reforço vacina'),
(1, 2, 4, now() + interval '3 days', now() + interval '73 hours', now() + interval '74 hours', 'Scheduled', null, 'Vacinação anual'),
(2, 1, 5, now() - interval '1 day', now() - interval '23 hours', now() - interval '22 hours', 'Completed', 'Revisão pós-operatória', 'Tudo ok'),
(1, 2, 4, now() + interval '4 days', now() + interval '97 hours', now() + interval '98 hours', 'Scheduled', null, 'Consulta de rotina'),
(2, 1, 5, now() + interval '5 days', now() + interval '121 hours', now() + interval '122 hours', 'Scheduled', null, 'Exame de sangue'),
(1, 2, 4, now() - interval '5 days', now() - interval '120 hours', now() - interval '119 hours', 'Completed', 'Dermatite', 'Tratamento tópico'),
(2, 1, 5, now() + interval '6 days', now() + interval '145 hours', now() + interval '146 hours', 'Scheduled', null, 'Check-up dentário'),
(1, 2, 4, now() - interval '10 days', now() - interval '240 hours', now() - interval '239 hours', 'Completed', 'Gastroenterite', 'Dieta especial'),
(2, 1, 5, now() + interval '7 days', now() + interval '169 hours', now() + interval '170 hours', 'Scheduled', null, 'Consulta de acompanhamento'),
(1, 2, 4, now() - interval '15 days', now() - interval '360 hours', now() - interval '359 hours', 'Completed', 'Fratura', 'Imobilização'),
(2, 1, 5, now() + interval '8 days', now() + interval '193 hours', now() + interval '194 hours', 'Scheduled', null, 'Consulta de emergência'),
(1, 2, 4, now() - interval '20 days', now() - interval '480 hours', now() - interval '479 hours', 'Completed', 'Infeção urinária', 'Antibióticos'),
(2, 1, 5, now() + interval '9 days', now() + interval '217 hours', now() + interval '218 hours', 'Scheduled', null, 'Consulta pré-cirúrgica');

--=========================================================
-- 2. OVERALL ASSESSMENT
--=========================================================
insert into overall_assessment (id_app, body_temp, weight, hrt_rate, resp_rate, general_status) values
(2, 38.5, 12.4, 80, 20, 'Animal alerta, mas com desconforto na orelha direita.');

insert into overall_assessment (id_app, body_temp, weight, hrt_rate, resp_rate, general_status) values
(5, 37.8, 15.0, 75, 18, 'Recuperação excelente, sem sinais de complicação.'),
(8, 39.0, 8.2, 90, 25, 'Pele avermelhada e com crostas, prurido intenso.'),
(10, 39.5, 10.1, 100, 30, 'Vómitos e diarreia, desidratado.'),
(12, 37.5, 20.5, 70, 16, 'Fratura consolidada, animal a apoiar a pata.'),
(14, 38.8, 7.5, 85, 22, 'Dor ao urinar, urina turva.'),
(1, 38.0, 10.0, 70, 18, 'Estado geral bom, sem queixas.'),
(3, 38.2, 11.5, 72, 19, 'Estado geral bom, para reforço vacinal.'),
(4, 38.1, 13.0, 78, 20, 'Estado geral bom, para vacinação.'),
(6, 37.9, 9.8, 70, 17, 'Estado geral bom, para rotina.'),
(7, 38.3, 16.2, 80, 21, 'Estado geral bom, para exames.'),
(9, 38.0, 14.5, 75, 19, 'Estado geral bom, para dentário.'),
(11, 38.0, 10.0, 70, 18, 'Estado geral bom, para acompanhamento.'),
(13, 38.5, 12.0, 95, 28, 'Animal com dor aguda, necessita avaliação urgente.'),
(15, 38.0, 11.0, 70, 18, 'Estado geral bom, para pré-cirúrgica.');

--=========================================================
-- 3. ANAMNESIS
--=========================================================
insert into anamnesis (id_app, des_ana) values
(2, 'Dono reporta que o cão coça a orelha insistentemente há 3 dias e apresenta odor forte.');

insert into anamnesis (id_app, des_ana) values
(5, 'Dono satisfeito com a recuperação do animal após cirurgia.'),
(8, 'Dono refere que o animal se coça muito e tem zonas sem pelo.'),
(10, 'Dono relata que o animal vomitou várias vezes e teve diarreia nas últimas 24h.'),
(12, 'Dono informa que o animal foi atropelado há 3 semanas e está a recuperar bem.'),
(14, 'Dono observa que o animal urina com frequência e com dificuldade.'),
(1, 'Dono não reporta alterações, consulta de rotina.'),
(3, 'Dono para reforço vacinal.'),
(4, 'Dono para vacinação anual.'),
(6, 'Dono para consulta de rotina.'),
(7, 'Dono para exames de rotina.'),
(9, 'Dono para check-up dentário.'),
(11, 'Dono para consulta de acompanhamento.'),
(13, 'Dono relata que o animal está apático e com dor.'),
(15, 'Dono para consulta pré-cirúrgica.');

--=========================================================
-- 4. PRESCRIPTION
--=========================================================
insert into prescription (id_app, des_pre) values
(2, 'Limpeza diária com solução otológica e aplicação de gotas antibióticas.');

insert into prescription (id_app, des_pre) values
(5, 'Manter repouso e observar cicatrização da ferida.'),
(8, 'Creme tópico para dermatite e banhos com champô medicado.'),
(10, 'Dieta gastrointestinal e probióticos.'),
(12, 'Fisioterapia e analgésicos.'),
(14, 'Antibiótico oral por 7 dias.'),
(1, 'Vacina polivalente.'),
(3, 'Reforço vacina raiva.'),
(4, 'Vacina anual.'),
(6, 'Desparasitação interna e externa.'),
(7, 'Preparação para exames de sangue (jejum).'),
(9, 'Limpeza dentária profissional.'),
(11, 'Ajuste de medicação.'),
(13, 'Analgésicos e anti-inflamatórios.'),
(15, 'Exames pré-operatórios.');

--=========================================================
-- 5. REL_APP_PRODUCT (Immediate consumption during appointment)
-- Dependencies: product(1, 4) from Mod3
--=========================================================
insert into rel_app_product (id_app, id_pro, qty_pre_pro, dos_pre_pro) values
(2, 4, 1, 'Aplicação única em consultório para limpeza');

insert into rel_app_product (id_app, id_pro, qty_pre_pro, dos_pre_pro) values
(5, 1, 1, 'Ração de convalescença, 1kg'),
(8, 4, 1, 'Champô medicado, aplicação em consultório'),
(10, 2, 1, 'Ração gastrointestinal, 1kg'),
(12, 3, 1, 'Ligadura elástica'),
(14, 4, 1, 'Solução antisséptica'),
(1, 5, 1, 'Coleira de identificação'),
(3, 1, 1, 'Ração de manutenção, 1kg'),
(4, 2, 1, 'Ração para gatos, 1kg'),
(6, 3, 1, 'Brinquedo para enriquecimento ambiental'),
(7, 4, 1, 'Luvas descartáveis para exame'),
(9, 5, 1, 'Escova de dentes veterinária'),
(11, 1, 1, 'Suplemento vitamínico'),
(13, 2, 1, 'Soro fisiológico'),
(15, 3, 1, 'Material de contenção');

--=========================================================
-- 6. REL_PRE_PROD (Products to take home)
-- Dependencies: prescription(1), product(4)
--=========================================================
insert into rel_pre_prod (id_pre, id_pro, qty_pre_pro, dos_pre_pro) values
(1, 4, 1, 'Aplicar 3 gotas em cada ouvido, 2x ao dia durante 7 dias');

insert into rel_pre_prod (id_pre, id_pro, qty_pre_pro, dos_pre_pro) values
(2, 1, 1, 'Ração de convalescença, 1kg, por 15 dias'),
(3, 4, 1, 'Champô medicado, 2x por semana'),
(4, 2, 1, 'Ração gastrointestinal, 2kg, por 10 dias'),
(5, 3, 1, 'Ligadura de substituição'),
(6, 4, 1, 'Antibiótico oral, 1 comprimido 2x ao dia por 7 dias'),
(7, 1, 1, 'Ração de manutenção, 2kg'),
(8, 2, 1, 'Ração para gatos, 1kg'),
(9, 3, 1, 'Brinquedo interativo'),
(10, 4, 1, 'Pipeta desparasitante'),
(11, 5, 1, 'Coleira de passeio'),
(12, 1, 1, 'Escova de dentes e pasta enzimática'),
(13, 2, 1, 'Suplemento para articulações'),
(14, 3, 1, 'Compressas frias'),
(15, 4, 1, 'Solução desinfetante');

--=========================================================
-- 7. CLIENT_NOTIFICATION
--=========================================================
insert into client_notification (id_cli, message, is_read) values
(4, 'Lembrete: O seu animal tem uma consulta agendada para amanhã às 10:00.', false),
(5, 'A fatura da consulta de ontem já se encontra disponível para pagamento.', true);

insert into client_notification (id_cli, message, is_read) values
(4, 'A sua consulta de vacinação anual foi agendada para daqui a 3 dias.', false),
(5, 'O resultado dos exames do seu animal já está disponível.', false),
(4, 'Não se esqueça de dar a medicação ao seu animal.', false),
(5, 'A sua fatura #INV001 está em atraso.', false),
(4, 'O seu animal está de parabéns! Faz hoje 1 ano.', true),
(5, 'Temos uma nova promoção em rações premium.', false),
(4, 'Lembrete: Consulta de acompanhamento agendada para a próxima semana.', false),
(5, 'O seu animal precisa de reforço vacinal em breve.', false),
(4, 'A sua fatura #INV002 foi paga com sucesso.', true),
(5, 'A clínica estará encerrada no feriado de 1 de maio.', false),
(4, 'Recebemos novos brinquedos para cães.', false),
(5, 'O seu animal tem uma consulta de emergência agendada para hoje.', false),
(4, 'O seu animal está recuperado! Parabéns!', true);

--=========================================================
-- 8. JOB TEST (Appointment warning simulation)
--=========================================================
-- This function inserts notifications for appointments occurring tomorrow
-- Based on the insert in point 1, client ID 4 should receive a new notification
-- select fn_appointment_warning_next_day();
```