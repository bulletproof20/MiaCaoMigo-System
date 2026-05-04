CREATE OR REPLACE PROCEDURE sp_receive_purchase(p_purchase_id INT)
LANGUAGE plpgsql AS $$
DECLARE
    line RECORD;
    new_stock_id INT;
BEGIN
    -- Atualizar status
    UPDATE Purchase SET PURCHASE_STATUS = 'Recebida'
    WHERE ID_PURCHASE = p_purchase_id;
    
    -- Para cada linha de compra, criar ou atualizar stock
    FOR line IN
        SELECT * FROM PurchaseLine WHERE ID_PURCHASE = p_purchase_id
    LOOP
        INSERT INTO Stock (ID_PRODUCT, BATCH, QUANTITY, ENTRY_DATE, VALIDATION_DATE)
        VALUES (line.ID_PRODUCT, line.BATCH, line.QUANTITY, NOW(), NULL)
        RETURNING ID_STOCK INTO new_stock_id;
        
        -- Ligar o stock à linha de compra
        UPDATE PurchaseLine SET ID_STOCK = new_stock_id
        WHERE ID_PURCHASE_LINE = line.ID_PURCHASE_LINE;
    END LOOP;
END;
$$;