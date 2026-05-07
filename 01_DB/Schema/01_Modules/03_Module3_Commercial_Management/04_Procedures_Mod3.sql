CREATE OR REPLACE PROCEDURE sp_receive_purchase(p_purchase_id INT)
LANGUAGE plpgsql AS $$
DECLARE
    line RECORD;
    new_stock_id INT;
BEGIN
    -- Atualizar status
    UPDATE Purchase SET sta_pur = 'received'
    WHERE id_pur = p_purchase_id;
    
    -- Para cada linha de compra, criar ou atualizar stock
    FOR line IN
        SELECT * FROM PurchaseLine WHERE ID_PURCHASE = p_purchase_id
    LOOP
        INSERT INTO Stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
        VALUES (line.ID_PRODUCT, line.BATCH, line.QUANTITY, NOW(), NULL)
        RETURNING id_sto INTO new_stock_id;
        
        -- Ligar o stock à linha de compra
        UPDATE PurchaseLine SET ID_STOCK = new_stock_id
        WHERE ID_PURCHASE_LINE = line.ID_PURCHASE_LINE;
    END LOOP;
END;
$$;