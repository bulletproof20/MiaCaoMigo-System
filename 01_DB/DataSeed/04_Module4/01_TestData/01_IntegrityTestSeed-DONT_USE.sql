--=========================================================
-- MODULE 4: APPOINTMENT MANAGEMENT — DATA SEED
--=========================================================
-- Prerequisites: Module 1 (specialty, expert, employee ≥ 4 & 10 as vets),
-- Module 2 (animal, ownership), Module 3 optional for rel_app_product.
--
-- id_spe must match expert(id_emp, id_spe) for each id_emp used:
--   employee 4 → specialties 1, 7  |  employee 10 → specialties 2, 5
--=========================================================

--=========================================================
-- 0. CLEAN DATA
--=========================================================
truncate table
    rel_pre_prod,
    rel_app_product,
    prescription,
    anamnesis,
    overall_assessment,
    appointment
restart identity cascade;


--=========================================================
-- 1. APPOINTMENT
-- Dependencies: animal id 3 with client 4 (ownership from Mod2 seed),
-- veterinarians id_emp 4 and 10 with matching expert rows.
--=========================================================
insert into appointment (
    id_ani,
    id_emp,
    id_cli,
    id_spe,
    sch_dat_app,
    sta_dat_app,
    end_dat_app,
    status_app,
    dia_app,
    com_app
) values
-- Client 4 + animal 3 (ownership active in default Mod2 seed)
(3, 4, 4, 1, now() + interval '1 day', now() + interval '25 hours', now() + interval '26 hours', 'scheduled', null, 'Check-up anual'),
(3, 10, 4, 2, now() - interval '2 days', now() - interval '47 hours', now() - interval '46 hours', 'completed', 'Otite externa', 'Limpeza efetuada'),
(3, 4, 4, 7, now() + interval '2 days', now() + interval '49 hours', now() + interval '50 hours', 'scheduled', null, 'Reforço vacina'),
(3, 10, 4, 5, now() + interval '3 days', now() + interval '73 hours', now() + interval '74 hours', 'scheduled', null, 'Vacinação anual'),
(3, 4, 4, 1, now() - interval '1 day', now() - interval '23 hours', now() - interval '22 hours', 'completed', 'Revisão pós-operatória', 'Tudo ok'),
(3, 10, 4, 2, now() + interval '4 days', now() + interval '97 hours', now() + interval '98 hours', 'scheduled', null, 'Consulta de rotina'),
(3, 4, 4, 7, now() + interval '5 days', now() + interval '121 hours', now() + interval '122 hours', 'scheduled', null, 'Exame de sangue'),
(3, 10, 4, 5, now() - interval '5 days', now() - interval '120 hours', now() - interval '119 hours', 'completed', 'Dermatite', 'Tratamento tópico'),
(3, 4, 4, 1, now() + interval '6 days', now() + interval '145 hours', now() + interval '146 hours', 'scheduled', null, 'Check-up dentário'),
(3, 10, 4, 2, now() - interval '10 days', now() - interval '240 hours', now() - interval '239 hours', 'completed', 'Gastroenterite', 'Dieta especial'),
(3, 4, 4, 7, now() + interval '7 days', now() + interval '169 hours', now() + interval '170 hours', 'scheduled', null, 'Consulta de acompanhamento'),
(3, 10, 4, 5, now() - interval '15 days', now() - interval '360 hours', now() - interval '359 hours', 'completed', 'Fratura', 'Imobilização'),
(3, 4, 4, 1, now() + interval '8 days', now() + interval '193 hours', now() + interval '194 hours', 'scheduled', null, 'Consulta de emergência'),
(3, 10, 4, 2, now() - interval '20 days', now() - interval '480 hours', now() - interval '479 hours', 'completed', 'Infeção urinária', 'Antibióticos'),
(3, 4, 4, 7, now() + interval '9 days', now() + interval '217 hours', now() + interval '218 hours', 'scheduled', null, 'Consulta pré-cirúrgica');


--=========================================================
-- 2. OVERALL ASSESSMENT
--=========================================================
insert into overall_assessment (id_app, bod_tmp_ova, wei_ova, hrt_rat_ova, res_rat_ova, gen_sta_ova) values
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
(2, 'Dono reporta que o cão coça a orelha insistentemente há 3 dias e apresenta odor forte.'),
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
(2, 'Limpeza diária com solução otológica e aplicação de gotas antibióticas.'),
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
-- 5. REL_APP_PRODUCT
-- Dependencies: product ids from Mod3 seed
--=========================================================
insert into rel_app_product (id_app, id_pro, qty_pre_pro, dos_pre_pro) values
(2, 4, 1, 'Aplicação única em consultório para limpeza'),
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
-- 6. REL_PRE_PROD
--=========================================================
insert into rel_pre_prod (id_pre, id_pro, qty_pre_pro, dos_pre_pro) values
(1, 4, 1, 'Aplicar 3 gotas em cada ouvido, 2x ao dia durante 7 dias'),
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
