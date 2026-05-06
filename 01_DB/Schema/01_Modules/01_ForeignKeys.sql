-- =========================================================
-- GLOBAL FOREIGN KEYS SCRIPT
-- Orquestra todas as relações entre tabelas para evitar 
-- problemas de dependências circulares.
-- =========================================================

-- =========================================================
-- MODULE 3: COMMERCIAL MANAGEMENT
-- =========================================================

ALTER TABLE product
ADD CONSTRAINT fk_purchase_product
FOREIGN KEY(id_pur) REFERENCES purchase(id_pur)
ON DELETE SET NULL;

ALTER TABLE product
ADD CONSTRAINT fk_stock
FOREIGN KEY(id_sto) REFERENCES stock(id_sto)
ON DELETE SET NULL;

ALTER TABLE product
ADD CONSTRAINT fk_return
FOREIGN KEY (id_ret) REFERENCES "return"(id_ret)
ON DELETE SET NULL;