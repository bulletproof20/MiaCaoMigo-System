

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
INSERT INTO invoice_line (id_inv, id_pro, qty_inv_lin, uni_pri_inv_lin, iva_inv_lin) 
VALUES (41, 1, 1, 10.00, 23.00);





CALL sp_check_restock_needs();


