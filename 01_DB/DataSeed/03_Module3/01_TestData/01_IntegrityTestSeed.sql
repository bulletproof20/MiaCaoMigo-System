-- =========================================================
-- 1. USER_ACCOUNT (Cria 80 utilizadores base: 40 para Empregados + 40 para Clientes)
-- =========================================================
WITH names AS (
    SELECT
        nome || ' ' || apelido as full_name,
        row_number() over() as rn
    FROM
        unnest(ARRAY['Ana', 'Bruno', 'Carlos', 'Diana', 'Eduardo', 'Filipa', 'Goncalo', 'Helena', 'Ines', 'Joao']) as nome
    CROSS JOIN
        unnest(ARRAY['Silva', 'Santos', 'Ferreira', 'Pereira', 'Oliveira', 'Costa', 'Rodrigues', 'Martins', 'Gomes', 'Lopes']) as apelido
    LIMIT 80
)
INSERT INTO user_account (nam_usr, add_usr, pos_usr, nif_usr, pho_usr, ema_usr)
SELECT
    full_name,
    'Rua Principal de Espinho',
    '4500-100', 
    (100000000 + rn)::varchar, 
    '+351910000' || lpad(rn::text, 3, '0'),
    lower(replace(full_name, ' ', '.') || rn || '@pessoal.com')
FROM names;

-- =========================================================
-- 2. EMPLOYEE (40 Registos)
-- =========================================================
INSERT INTO employee (id_usr, ema_emp, pas_emp, reg_dat_emp)
SELECT
    id_usr,
    replace(ema_usr, '@pessoal.com', '@miacaomigo.pt'),
    'hash_muito_seguro_e_longo_emp_' || id_usr,
    current_timestamp
FROM user_account
WHERE id_usr <= 40;

-- =========================================================
-- 3. CLIENT (40 Registos)
-- =========================================================
INSERT INTO client (id_usr, pas_cli, reg_dat_cli)
SELECT
    id_usr,
    'hash_muito_seguro_e_longo_cli_' || id_usr,
    current_timestamp
FROM user_account
WHERE id_usr > 40 AND id_usr <= 80;

-- ==========================================
-- 4. FAMILY (Categorias)
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
-- 5. PRODUCT (30 Produtos Reais)
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




UPDATE product SET min_sto = 15 WHERE id_fam = 1 OR id_fam = 2; -- Food
UPDATE product SET min_sto = 20 WHERE id_fam = 3; -- Medicines
UPDATE product SET min_sto = 15 WHERE id_fam = 4; -- Desparasitants
UPDATE product SET min_sto = 30 WHERE id_fam = 5; -- Vaccines
UPDATE product SET min_sto = 10 WHERE id_fam = 6; -- Hygiene
UPDATE product SET min_sto = 10 WHERE id_fam = 7; -- Accessories
UPDATE product SET min_sto = 15 WHERE id_fam = 8; -- Supplements




-- =========================================================
-- 6. STOCK (40 Registos)
-- Injeta 1000 unidades em formato TIMESTAMP
-- =========================================================
-- Injeta 40 lotes distribuídos pelos teus 30 produtos
INSERT INTO stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
SELECT
    (i % 30) + 1, -- Garante que distribui pelos IDs 1 a 30
    'LOTE-2026-' || lpad(i::text, 3, '0'),
    floor(random() * 31 + 2)::int, -- Quantidade aleatória entre 2 e 32
    current_date,
    current_date + (random() * 730 || ' days')::interval -- Validade aleatória até 2 anos
FROM generate_series(1, 40) as i;




-- =========================================================
-- 7. PURCHASE (40 Registos)
-- =========================================================
INSERT INTO purchase (pur_dat_pur, sta_pur, id_cli, id_emp)
SELECT
    current_timestamp - (i || ' days')::interval,
    'received',
    (i % 40) + 1, 
    (i % 40) + 1  
FROM generate_series(1, 40) as i;





-- =========================================================
-- 8. PURCHASELINE (40 Registos)
-- =========================================================
INSERT INTO purchase_line (id_pur, id_pro, bat_pln, qty_pln, uni_cos_pln, id_sto)
SELECT
    i, 
    (i % 30) + 1, 
    'LOTE-2026-' || lpad(i::text, 3, '0'),
    2,
    15.50,
    i
FROM generate_series(1, 40) as i;



-- =========================================================
-- 9. INVOICE (40 Registos)
-- =========================================================
INSERT INTO invoice (dat_inv, bod_inv)
SELECT
    current_timestamp - (i || ' hours')::interval,
    'Fatura de venda direta #' || lpad(i::text, 3, '0')
FROM generate_series(1, 40) as i;

-- =========================================================
-- 10. INVOICELINE (40 Registos)
-- =========================================================
INSERT INTO invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin)
SELECT
    i, 
    (i % 30) + 1, 
    1, 
    35.00, 
    23.00
FROM generate_series(1, 40) as i;


