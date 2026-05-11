--teste

-- 1. Verificamos quanto stock temos do Produto 1 (Royal Canin Mini)
-- O resultado deve ser 1000 (porque foi o que injetámos) ou um bocado menos se já o vendemos nos 40 registos.
SELECT fn_get_available_stock(3) AS stock_antes;

select * from stock;

-- 2. Criamos uma Fatura Nova (vai gerar o id_inv 41)
INSERT INTO invoice (dat_inv, bod_inv) 
VALUES (CURRENT_TIMESTAMP, 'Fatura de Teste - Triggers Venda');

-- 3. Inserimos a Linha de Fatura (Vendemos 10 sacos a 40€ cada, com 23% IVA)
INSERT INTO InvoiceLine (ID_INVOICE, ID_PRODUCT, QUANTITY, UNIT_PRICE, IVA) 
VALUES (41, 1, 10, 40.00, 23.00);

-- 4. VERIFICAÇÃO DO TOTAL DA FATURA (Deve dar 492.00€ -> 10 * 40€ * 1.23)
SELECT id_inv, val_inv FROM invoice WHERE id_inv = 41;

-- 5. VERIFICAÇÃO DO STOCK (Tem de ter descido exatamente 10 unidades)
SELECT fn_get_available_stock(2) AS stock_depois;



-- 1. Tentar vender 9000 unidades do Produto 2.
-- O PostgreSQL TEM de bloquear a operação e mostrar o teu erro personalizado.
INSERT INTO InvoiceLine (ID_INVOICE, ID_PRODUCT, QUANTITY, UNIT_PRICE, IVA) 
VALUES (41, 2, 9000, 52.00, 23.00);


-- 2. Tentar vender 9000 unidades do Produto 2.
-- O PostgreSQL TEM de bloquear a operação e mostrar o teu erro personalizado.
INSERT INTO InvoiceLine (ID_INVOICE, ID_PRODUCT, QUANTITY, UNIT_PRICE, IVA) 
VALUES (41, 2, 9000, 52.00, 23.00);



-- 1. Inserir devolução (Nota: Não enviamos o RETURN_DATE de propósito!)
INSERT INTO "return" (mot_ret, ID_INVOICE_LINE, QUANTITY_RETURNED)
VALUES ('Cliente enganou-se na ração', 41, 1);

-- 2. Verificar se a data (RETURN_DATE) foi preenchida com o TIMESTAMP exato do momento.
SELECT id_ret, mot_ret, return_date FROM "return" ORDER BY id_ret DESC LIMIT 1;

-- 3. Verificar o Stock (Tem de ter voltado a subir 1 unidade)
SELECT fn_get_available_stock(1) AS stock_apos_devolucao;






-- 1. Criar a encomenda (Gera ID 41) e fica 'pending'
INSERT INTO purchase (pur_dat_pur, sta_pur) VALUES (CURRENT_TIMESTAMP, 'pending');

-- 2. Adicionar 50 unidades de um produto a essa encomenda
INSERT INTO PurchaseLine (ID_PURCHASE, ID_PRODUCT, BATCH, QUANTITY, UNIT_COST) 
VALUES (41, 10, 'LOTE-NOVO-MELOXICAM', 50, 10.00);

-- 3. EXECUTAR A PROCEDURE
CALL sp_receive_purchase(41);

-- 4. Verificar se a encomenda passou a 'received'
SELECT id_pur, sta_pur FROM purchase WHERE id_pur = 41;

-- 5. Verificar se a PurchaseLine foi ligada ao novo ID de Stock gerado
SELECT ID_PURCHASE_LINE, ID_STOCK FROM PurchaseLine WHERE ID_PURCHASE = 41;







-- 1. No Teste 1, vendemos apenas 2 unidades do Produto 1 na Fatura 41.
-- Vamos tentar devolver 50 unidades usando o mesmo ID_INVOICE_LINE (41)!
-- O PostgreSQL TEM de dar ERRO: "Quantidade devolvida (50) excede a quantidade vendida (2)"
INSERT INTO "return" (mot_ret, ID_INVOICE_LINE, QUANTITY_RETURNED)
VALUES ('Tentativa de burla', 41, 50);




-- 1. Inserir um artigo extra na Fatura 41 (1 champô de 12.90€)
INSERT INTO InvoiceLine (ID_INVOICE, ID_PRODUCT, QUANTITY, UNIT_PRICE, IVA) 
VALUES (41, 23, 1, 12.90, 23.00);

-- 2. Verificar o total (subiu para acomodar o champô)
SELECT val_inv FROM invoice WHERE id_inv = 41;

-- 3. A rececionista enganou-se! Vamos apagar a linha desse champô.
-- (Assumindo que esta foi a última linha inserida e o seu ID é 42)
DELETE FROM InvoiceLine WHERE ID_INVOICE_LINE = 42;

-- 4. Verificar o total novamente. Tem de ter descido automaticamente para o valor original!
SELECT val_inv FROM invoice WHERE id_inv = 41;