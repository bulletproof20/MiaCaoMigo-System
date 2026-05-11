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



CREATE OR REPLACE PROCEDURE sp_check_restock_needs()
LANGUAGE plpgsql AS $$
DECLARE
    v_total_produtos INT;
BEGIN
    -- 1. Contar quantos produtos estão na View de reposição
    SELECT COUNT(*) INTO v_total_produtos 
    FROM vw_produtos_para_encomendar;

    -- 2. Verificar se o contador é maior que zero
    IF v_total_produtos > 0 THEN
        RAISE NOTICE 'ATENÇÃO: Existem % produtos que atingiram o stock mínimo e precisam de reposição!', v_total_produtos;
        RAISE NOTICE 'Consulte a View "vw_produtos_para_encomendar" para ver a lista detalhada.';
    ELSE
        RAISE NOTICE 'Stock em conformidade: Nenhum produto necessita de encomenda no momento.';
    END IF;
END;
$$;