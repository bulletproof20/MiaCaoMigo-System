

select * from stock;

select * from product;

select * from purchase;

select * from purchase_line;

select * from invoice;

select * from invoice_line;


select * from "return";


select * from family;




-- Este é o teu painel de controlo. 
-- Devem aparecer aqui todos os produtos cujo stock atual <= min_sto.
SELECT * FROM vw_produtos_para_encomendar order by stock_minimo desc;   







-- 1. Garante que o Produto 1 tem um stock mínimo alto (ex: 50) para forçar o aviso
UPDATE product SET min_sto = 50 WHERE id_pro = 1;

-- 2. Faz uma venda de teste (Garante que o ID da fatura existe, usei o 41 do teu exemplo)
INSERT INTO invoice_line (id_invoice, id_product, quantity, unit_price, iva) 
VALUES (41, 1, 1, 10.00, 23.00);





CALL sp_check_restock_needs();








-- 1. Crias a compra (e fingimos que a função te devolveu o ID 42)
SELECT fn_create_purchase(1, NULL); 

-- 2. Agora já sabes que a compra é a 42, podes adicionar os produtos a ela:
INSERT INTO purchase_line (ID_PURCHASE, ID_PRODUCT, BATCH, QUANTITY, UNIT_COST) 
VALUES (43, 10, 'LOTE-TESTE', 23, 14.00);








--TEste 1 fluxo das faturas e abate fifo 



SELECT id_sto, qty_sto, val_dat_sto FROM stock WHERE id_pro = 1 ORDER BY val_dat_sto NULLS LAST;

SELECT fn_get_available_stock(1) AS stock_total_antes;


--criar fatura para vender 5 deste produto 1

-- 1. Criar cabeçalho da fatura
INSERT INTO invoice (dat_inv, bod_inv) 
VALUES (CURRENT_TIMESTAMP, 'Teste de Venda FIFO3')
RETURNING id_inv; -- Aponta o ID gerado (vamos assumir que é o 41)

-- 2. Inserir a linha de fatura (Substitui o 41 pelo ID gerado se for diferente)
INSERT INTO invoice_line (id_invoice, id_product, quantity, unit_price, iva) 
VALUES (43, 1, 5, 45.90, 23.00);


SELECT id_inv, val_inv FROM invoice WHERE id_inv = 43;


--teste do trigger para verificar se o stock foi atualizado corretamente (deve ter vendido 5 unidades do Produto 1, seguindo o FIFO)
INSERT INTO invoice_line (id_invoice, id_product, quantity, unit_price, iva) 
VALUES (41, 1, 9999, 45.90, 23.00);