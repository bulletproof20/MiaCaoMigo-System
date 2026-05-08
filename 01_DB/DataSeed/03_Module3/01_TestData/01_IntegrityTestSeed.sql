-- =========================================================================
-- 1. TABELAS BASE (Assumindo que os IDs 1, 2 e 3 existem)
-- Nota: Se não tiveres dados nestas tabelas, terás de os criar primeiro.
-- Exemplo de dependências: client(id_cli), employee(id_emp), appointment(id_app)
-- =========================================================================

-- =========================================================================
-- 2. FAMÍLIAS DE PRODUTOS (Sem dependências)
-- =========================================================================
INSERT INTO family (nam_fam, des_fam) VALUES
('Alimentação Cão', 'Ração seca, húmida e snacks para cães de todas as idades.'),
('Alimentação Gato', 'Ração seca, húmida e snacks para gatos.'),
('Brinquedos', 'Bolas, cordas, peluches e brinquedos interativos.'),
('Higiene e Cuidado', 'Champôs, escovas, corta-unhas e produtos de limpeza.'),
('Acessórios', 'Treias, coleiras, peitorais e camas.');

-- =========================================================================
-- 3. DEVOLUÇÕES (Sem dependências)
-- =========================================================================
INSERT INTO return (dat_ret, mot_ret) VALUES
('2023-10-15', 'Produto com defeito de fabrico na costura da cama.'),
('2023-11-02', 'Cliente comprou a ração errada (gato em vez de cão).'),
('2024-01-10', 'A trela partiu-se no primeiro uso.');

-- =========================================================================
-- 4. FATURAS (Depende de appointment - assumindo id_app 1, 2, 3)
-- =========================================================================
INSERT INTO invoice (val_inv, dat_inv, bod_inv, id_app) VALUES
(45.50, '2023-10-10 14:30:00', 'Fatura referente a consulta de rotina e vacinação.', 1),
(120.00, '2023-11-01 10:15:00', 'Fatura referente a cirurgia menor.', 2),
(25.00, '2024-01-05 16:45:00', 'Fatura de banho e tosquia.', 3);

-- =========================================================================
-- 5. PRODUTOS (Depende de family. Deixamos id_sto, id_pur e id_ret a NULL temporariamente)
-- =========================================================================
INSERT INTO product (ref_pro, bar_pro, nam_pro, des_pro, pri_pro, iva_pro, id_fam) VALUES
('RC-DOG-10KG', '5601234567890', 'Ração Royal Canin Cão Adulto 10kg', 'Ração premium para cães adultos de porte médio.', 55.90, 23.00, 1),
('FR-CAT-2KG', '5601234567891', 'Friskies Gato Esterilizado 2kg', 'Ração seca para gatos esterilizados sabor salmão.', 12.50, 23.00, 2),
('TOY-BALL-01', '5601234567892', 'Bola de Borracha Indestrutível', 'Bola maciça para cães com mordida forte.', 8.99, 23.00, 3),
('HYG-SHAM-01', '5601234567893', 'Champô Pêlo Longo 500ml', 'Champô com aloe vera para cães e gatos de pêlo comprido.', 14.20, 23.00, 4),
('ACC-COL-RED', '5601234567894', 'Coleira Vermelha Ajustável', 'Coleira em nylon resistente com fecho de segurança.', 6.50, 23.00, 5);

-- =========================================================================
-- 6. STOCK (Depende de product)
-- =========================================================================
INSERT INTO stock (id_pro, bat_sto, qty_sto, val_dat_sto, ent_dat_sto) VALUES
(1, 'LOTE-2023-A', 50, '2025-12-31', '2023-09-01'),
(2, 'LOTE-2023-B', 100, '2026-06-30', '2023-09-15'),
(3, 'N/A', 30, NULL, '2023-10-01'),
(4, 'LOTE-CH-01', 25, '2027-01-01', '2023-10-05'),
(5, 'N/A', 40, NULL, '2023-11-10');

-- =========================================================================
-- 7. ATUALIZAR PRODUTOS COM O SEU STOCK ATUAL
-- (Resolve a dependência circular)
-- =========================================================================
UPDATE product SET id_sto = 1 WHERE id_pro = 1;
UPDATE product SET id_sto = 2 WHERE id_pro = 2;
UPDATE product SET id_sto = 3 WHERE id_pro = 3;
UPDATE product SET id_sto = 4 WHERE id_pro = 4;
UPDATE product SET id_sto = 5 WHERE id_pro = 5;

-- =========================================================================
-- 8. COMPRAS (Depende de invoice, client e employee. Assumindo IDs 1, 2)
-- =========================================================================
INSERT INTO purchase (pur_dat_pur, tot_val_pur, ord_num_pur, pay_met_pur, sta_pur, id_inv, id_cli, id_emp) VALUES
('2023-10-11 10:00:00', 64.89, 'ORD-001', 'MBWAY', 'received', 1, 1, 1),
('2023-11-02 11:30:00', 12.50, 'ORD-002', 'Cartão de Crédito', 'received', 2, 2, 1),
('2024-01-06 09:00:00', 20.70, 'ORD-003', 'Dinheiro', 'pending', 3, 1, 2);

-- =========================================================================
-- 9. TABELAS ASSOCIATIVAS (Muitos-para-Muitos)
-- =========================================================================

-- Produtos na Compra (purchase_product)
INSERT INTO purchase_product (id_pur, id_pro, qty_pur_pro) VALUES
(1, 1, 1), -- Compra 1 tem 1x Ração Cão
(1, 3, 1), -- Compra 1 tem 1x Bola
(2, 2, 1), -- Compra 2 tem 1x Ração Gato
(3, 4, 1), -- Compra 3 tem 1x Champô
(3, 5, 1); -- Compra 3 tem 1x Coleira

-- Produtos na Devolução (return_product)
INSERT INTO return_product (id_ret, id_pro, qty_ret_pro) VALUES
(1, 5, 1), -- Devolução da cama (Assumindo que inserimos uma cama)
(2, 2, 1), -- Devolução da Ração Gato
(3, 5, 1); -- Devolução da Coleira (Trela)

-- Funcionários associados a compras (employee_purchase)
INSERT INTO employee_purchase (id_emp, id_pur) VALUES
(1, 1),
(1, 2),
(2, 3);

-- Funcionários associados a devoluções (employee_return)
INSERT INTO employee_return (id_emp, id_ret) VALUES
(2, 1),
(1, 2),
(1, 3);



INSERT INTO user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) VALUES

('Ana Silva', 'Rua das Flores, 123', '4000-123', '123456789', '+351912345678', 'ana.silva@email.com'),
('Bruno Costa', 'Avenida Central, 45', '4100-234', '987654321', '+351961234567', 'bruno.costa@email.com'),
('Carla Mendes', 'Rua Nova, 67', '4200-345', '111222333', '+351931112223', 'carla.mendes@email.com');

-- =========================================================================
-- 1. TABELAS BASE (Para resolver dependências de Foreign Keys)
-- =========================================================================

-- Inserir Contas de Utilizador (user_account)
INSERT INTO user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr) VALUES
('Ana Silva', 'Rua das Flores, 123', '4000-123', '1234  56789', '912345678', 'ana.silva@email.com'),
('Bruno Costa', 'Avenida Central, 45', '4100-234', '987654321', '961234567', 'bruno.costa@email.com'),
('Carla Mendes', 'Rua Nova, 67', '4200-345', '111222333', '931112223', 'carla.mendes@email.com');

-- Inserir Clientes (client) - Depende de user_account
-- Assumindo que os clientes são a Ana (id 1) e o Bruno (id 2)
INSERT INTO client (id_usr, pas_cli, reg_dat_cli) VALUES
(1, 'senhaSegura1', current_timestamp),
(2, 'senhaSegura2', current_timestamp);

-- Inserir Funcionários (employee) - Depende de user_account
-- Assumindo que a funcionária é a Carla (id 3)
INSERT INTO employee (id_usr, reg_dat_emp, aut_reg_emp, pho_emp, pho_emg, ema_emp, pas_emp) VALUES
(3, current_timestamp, 1, '931112223', '910000000', 'carla.mendes@empresa.com', 'senhaFunc3');

-- Inserir Consultas (appointment)
-- Estas são as consultas que faltam para que as faturas possam ser inseridas!
INSERT INTO appointment (sch_dat_app, sta_dat_app, end_dat_app, dia_app, com_app) VALUES
('2023-10-10 14:00:00', '2023-10-10 14:05:00', '2023-10-10 14:30:00', 'Consulta de rotina. Animal saudável.', 'Dono reporta comportamento normal.'),
('2023-11-01 09:30:00', '2023-11-01 09:40:00', '2023-11-01 10:15:00', 'Cirurgia menor. Sucesso.', 'Recomendado repouso por 3 dias.'),
('2024-01-05 15:00:00', '2024-01-05 15:10:00', '2024-01-05 16:45:00', 'Banho e tosquia completos.', 'Nenhuma anomalia detetada na pele.');