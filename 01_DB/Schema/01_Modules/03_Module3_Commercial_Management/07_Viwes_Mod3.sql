--=========================================================
-- MODULE 3: VIEWS / REPORTING
--=========================================================

DROP VIEW IF EXISTS vw_produtos_para_encomendar;

CREATE OR REPLACE VIEW vw_produtos_para_encomendar AS
SELECT 
    p.id_pro AS id,
    p.nam_pro AS produto,
    f.nam_fam AS familia,
    fn_get_available_stock(p.id_pro) AS stock_atual,
    p.min_sto AS stock_minimo,
    -- Sugestão: comprar o suficiente para repor o dobro do mínimo
    ((p.min_sto * 2) - fn_get_available_stock(p.id_pro)) AS sugestao_encomenda
FROM product p
JOIN family f ON p.id_fam = f.id_fam
WHERE fn_get_available_stock(p.id_pro) <= p.min_sto
  AND p.ina_dat_pro IS NULL
ORDER BY f.nam_fam, p.nam_pro;