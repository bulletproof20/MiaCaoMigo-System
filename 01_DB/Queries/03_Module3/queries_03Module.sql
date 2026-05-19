

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
