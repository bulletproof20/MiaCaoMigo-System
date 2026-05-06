-- ==========================================
-- 1. FAMILY (Categorias) - 8 Categorias realistas
-- ==========================================
INSERT INTO family (nam_fam, des_fam) VALUES 
('Rações Cão', 'Alimentação seca e húmida para cães'),
('Rações Gato', 'Alimentação seca e húmida para gatos'),
('Medicamentos', 'Antibióticos, anti-inflamatórios e analgésicos'),
('Desparasitantes', 'Desparasitantes internos e externos (pipetas, coleiras)'),
('Vacinas', 'Vacinas anuais e reforços'),
('Higiene', 'Champôs, escovas e corta-unhas'),
('Acessórios', 'Trelas, coleiras, bebedouros e camas'),
('Suplementos', 'Vitaminas e suplementos articulares');

-- ==========================================
-- 2. PRODUCT (30 Produtos Reais de Veterinária)
-- ==========================================
INSERT INTO product (ref_pro, bar_pro, nam_pro, des_pro, pri_pro, iva_pro, id_fam) VALUES 
('RAC-C01', '1000000000001', 'Royal Canin Mini Adult 8kg', 'Ração para cães pequenos adultos', 45.90, 23.00, 1),
('RAC-C02', '1000000000002', 'Advance Medium Puppy 12kg', 'Ração para cachorros médios', 52.00, 23.00, 1),
('RAC-C03', '1000000000003', 'Pro Plan Large Robust 14kg', 'Ração para cães grandes', 65.50, 23.00, 1),
('RAC-C04', '1000000000004', 'Hill''s Prescription Diet Gastrointestinal', 'Ração veterinária cão', 35.00, 23.00, 1),
('RAC-C05', '1000000000005', 'Pedigree Dentastix (7 unid)', 'Snacks dentários', 3.50, 23.00, 1),
('RAC-G01', '2000000000001', 'Purina ONE Sterilised 3kg', 'Ração para gatos esterilizados', 18.90, 23.00, 2),
('RAC-G02', '2000000000002', 'Royal Canin Kitten 2kg', 'Ração para gatinhos', 22.00, 23.00, 2),
('RAC-G03', '2000000000003', 'Felix Saquetas (12 unid)', 'Comida húmida para gatos', 5.99, 23.00, 2),
('RAC-G04', '2000000000004', 'Advance Urinary Feline 1.5kg', 'Trato urinário gatos', 15.50, 23.00, 2),
('MED-001', '3000000000001', 'Meloxicam 1mg', 'Anti-inflamatório', 12.00, 6.00, 3),
('MED-002', '3000000000002', 'Amoxicilina 250mg', 'Antibiótico largo espetro', 14.50, 6.00, 3),
('MED-003', '3000000000003', 'Clavamox Gotas', 'Antibiótico líquido', 18.00, 6.00, 3),
('MED-004', '3000000000004', 'Cerenia 16mg', 'Anti-emético (enjoos)', 25.00, 6.00, 3),
('DES-001', '4000000000001', 'Bravecto Cão 20-40kg', 'Comprimido pulgas/carraças 3 meses', 35.00, 23.00, 4),
('DES-002', '4000000000002', 'Advantage Gato (>4kg)', 'Pipeta desparasitante', 8.50, 23.00, 4),
('DES-003', '4000000000003', 'Seresto Coleira Cão Grande', 'Coleira 8 meses proteção', 42.00, 23.00, 4),
('DES-004', '4000000000004', 'Milbemax Cão Adulto', 'Desparasitante interno (2 comp)', 10.00, 23.00, 4),
('DES-005', '4000000000005', 'Drontal Gato', 'Desparasitante interno', 6.50, 23.00, 4),
('VAC-001', '5000000000001', 'Vacina Polivalente Cão (CHPPI2L)', 'Vacina anual cão', 25.00, 6.00, 5),
('VAC-002', '5000000000002', 'Vacina Raiva', 'Vacina antirrábica', 20.00, 6.00, 5),
('VAC-003', '5000000000003', 'Vacina Tripla Felina (RCP)', 'Vacina anual gato', 25.00, 6.00, 5),
('VAC-004', '5000000000004', 'Vacina Leucose Felina', 'Vacina FeLV', 28.00, 6.00, 5),
('HIG-001', '6000000000001', 'Champô Fisiológico 250ml', 'Champô uso frequente', 12.90, 23.00, 6),
('HIG-002', '6000000000002', 'Limpa Orelhas EpiOtic', 'Solução auricular', 14.00, 23.00, 6),
('HIG-003', '6000000000003', 'Escova Furminator M', 'Escova tira-pelo', 29.90, 23.00, 6),
('ACE-001', '7000000000001', 'Trela Extensível Flexi 5m', 'Trela de passeio', 16.50, 23.00, 7),
('ACE-002', '7000000000002', 'Transportadora Gulliver', 'Caixa de transporte rígida', 24.00, 23.00, 7),
('ACE-003', '7000000000003', 'Cama Donut Fofa', 'Cama para cão/gato', 35.00, 23.00, 7),
('SUP-001', '8000000000001', 'Condrovet Force HA', 'Protetor articular', 45.00, 6.00, 8),
('SUP-002', '8000000000002', 'Pasta Nutriplus Gel', 'Suplemento vitamínico e energético', 15.00, 6.00, 8);


-- ==========================================
-- 3. LOOP AUTOMÁTICO (Gera 30 Stocks, Faturas, Compras, etc.)
-- ==========================================
DO $$
DECLARE
    i INT;
    v_id_stock INT;
    v_id_invoice INT;
    v_id_purchase INT;
    v_id_return INT;
    v_id_inv_line INT;
    
    -- Vamos assumir que os IDs Cliente 1, Empregado 1 e Consulta 1 existem.
    -- (O script não falha se existirem na tua BD).
    v_cli INT := 1; v_emp INT := 1; v_app INT := 1;
    v_preco NUMERIC; v_iva NUMERIC;
BEGIN
    FOR i IN 1..30 LOOP
    
        -- -----------------------------------------------------
        -- A) CRIAR 30 ENTRADAS DE STOCK (1 para cada produto)
        -- -----------------------------------------------------
        INSERT INTO stock (id_pro, bat_sto, qty_sto, val_dat_sto, ent_dat_sto) 
        VALUES (i, 'LOTE-TESTE-' || i, 100 + (random() * 50)::INT, CURRENT_DATE + (random() * 365)::INT, CURRENT_DATE)
        RETURNING id_sto INTO v_id_stock;

        -- Pegar no preço e IVA do produto atual para fazer as contas
        SELECT pri_pro, iva_pro INTO v_preco, v_iva FROM product WHERE id_pro = i;

        -- -----------------------------------------------------
        -- B) CRIAR 30 COMPRAS AOS FORNECEDORES (Reposição)
        -- -----------------------------------------------------
        INSERT INTO purchase (pur_dat_pur, tot_val_pur, ord_num_pur, pay_met_pur, sta_pur, id_cli, id_emp) 
        VALUES (CURRENT_TIMESTAMP - (random() * 30 || ' days')::INTERVAL, 
               (v_preco * 10), 'ORD-2026-' || i, 'Transferência', 'received', NULL, v_emp)
        RETURNING id_pur INTO v_id_purchase;

        INSERT INTO PurchaseLine (ID_PURCHASE, ID_PRODUCT, BATCH, QUANTITY, UNIT_COST, ID_STOCK) 
        VALUES (v_id_purchase, i, 'LOTE-TESTE-' || i, 10, v_preco * 0.5, v_id_stock);

        INSERT INTO purchase_product (id_pur, id_pro, qty_pur_pro) VALUES (v_id_purchase, i, 10);
        INSERT INTO employee_purchase (id_emp, id_pur) VALUES (v_emp, v_id_purchase);


        -- -----------------------------------------------------
        -- C) CRIAR 30 FATURAS (Venda aos clientes)
        -- -----------------------------------------------------
        INSERT INTO invoice (val_inv, dat_inv, bod_inv, id_app) 
        VALUES (v_preco + (v_preco * (v_iva/100)), CURRENT_TIMESTAMP - (random() * 15 || ' days')::INTERVAL, 'Fatura de Venda Nº' || i, v_app)
        RETURNING id_inv INTO v_id_invoice;

        INSERT INTO InvoiceLine (ID_INVOICE, ID_PRODUCT, QUANTITY, UNIT_PRICE, IVA) 
        VALUES (v_id_invoice, i, 1, v_preco, v_iva)
        RETURNING ID_INVOICE_LINE INTO v_id_inv_line;


        -- -----------------------------------------------------
        -- D) CRIAR DEVOLUÇÕES (Só cria 1 a cada 3 loops, senão era irreal)
        -- -----------------------------------------------------
        IF i % 3 = 0 THEN
            INSERT INTO return (dat_ret, mot_ret, ID_INVOICE_LINE, QUANTITY_RETURNED, RETURN_DATE) 
            VALUES (CURRENT_DATE, 'Motivo da devolução ' || i, v_id_inv_line, 1, CURRENT_TIMESTAMP)
            RETURNING id_ret INTO v_id_return;

            INSERT INTO return_product (id_ret, id_pro, qty_ret_pro) VALUES (v_id_return, i, 1);
            INSERT INTO employee_return (id_emp, id_ret) VALUES (v_emp, v_id_return);
        END IF;

    END LOOP;
END $$;