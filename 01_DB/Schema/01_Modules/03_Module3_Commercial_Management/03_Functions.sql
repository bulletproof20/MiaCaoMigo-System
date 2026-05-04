-- Stock disponível de um produto (todos os lotes juntos)
CREATE OR REPLACE FUNCTION fn_get_available_stock(p_product_id INT)
RETURNS INT AS $$
BEGIN
    RETURN COALESCE(
        (SELECT SUM(QUANTITY) FROM Stock WHERE ID_PRODUCT = p_product_id AND QUANTITY > 0),
        0
    );
END;
$$ LANGUAGE plpgsql;






--Function for not selling more than the available stock


CREATE OR REPLACE FUNCTION trg_check_stock_before_sale_func()
RETURNS TRIGGER AS $$
DECLARE
    stock_atual INT;
BEGIN
    SELECT fn_get_available_stock(NEW.ID_PRODUCT) INTO stock_atual;
    
    IF stock_atual < NEW.QUANTITY THEN
        RAISE EXCEPTION 'Stock insuficiente para o produto % (disponível: %, solicitado: %)',
                         NEW.ID_PRODUCT, stock_atual, NEW.QUANTITY;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- function for updating stock after a sale (decrease quantity)


CREATE OR REPLACE FUNCTION trg_stock_after_sale_func()
RETURNS TRIGGER AS $$
DECLARE
    stock_record RECORD;
    remaining_quantity INT;
BEGIN
    remaining_quantity := NEW.QUANTITY;
    
    -- Percorre lotes FIFO (primeiro a expirar primeiro)
    FOR stock_record IN
        SELECT ID_STOCK, QUANTITY FROM Stock
        WHERE ID_PRODUCT = NEW.ID_PRODUCT AND QUANTITY > 0
        ORDER BY VALIDATION_DATE NULLS LAST
    LOOP
        IF remaining_quantity <= stock_record.quantity THEN
            UPDATE Stock SET QUANTITY = stock_record.quantity - remaining_quantity
            WHERE ID_STOCK = stock_record.id_stock;
            EXIT;
        ELSE
            UPDATE Stock SET QUANTITY = 0
            WHERE ID_STOCK = stock_record.id_stock;
            remaining_quantity := remaining_quantity - stock_record.quantity;
        END IF;
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- function for updating invoice total after inserting/updating/deleting an invoice line

CREATE OR REPLACE FUNCTION trg_update_invoice_total_func()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Invoice SET VALUE = (
        SELECT COALESCE(SUM(QUANTITY * UNIT_PRICE * (1 + IVA/100)), 0)
        FROM InvoiceLine
        WHERE ID_INVOICE = NEW.ID_INVOICE
    )
    WHERE ID_INVOICE = NEW.ID_INVOICE;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--function that handles returns and restocks products accordingly

CREATE OR REPLACE FUNCTION trg_return_restock_func()
RETURNS TRIGGER AS $$
DECLARE
    prod_id INT;
    qty_sold INT;
BEGIN
    -- Obter produto e quantidade original
    SELECT ID_PRODUCT, QUANTITY INTO prod_id, qty_sold
    FROM InvoiceLine WHERE ID_INVOICE_LINE = NEW.ID_INVOICE_LINE;
    
    IF NEW.QUANTITY_RETURNED > qty_sold THEN
        RAISE EXCEPTION 'Quantidade devolvida (%) excede a quantidade vendida (%)',
                         NEW.QUANTITY_RETURNED, qty_sold;
    END IF;
    
    -- Repor stock (adicionar ao lote mais recente)
    INSERT INTO Stock (ID_PRODUCT, BATCH, QUANTITY, ENTRY_DATE, VALIDATION_DATE)
    VALUES (
        prod_id,
        (SELECT BATCH FROM Stock WHERE ID_PRODUCT = prod_id ORDER BY ENTRY_DATE DESC LIMIT 1),
        NEW.QUANTITY_RETURNED,
        NOW(),
        NULL
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;




--function for not seeling products that are not ative 

CREATE OR REPLACE FUNCTION trg_prevent_inactive_product_sale_func()
RETURNS TRIGGER AS $$
DECLARE
    is_inactive BOOLEAN;
BEGIN
    SELECT INACTIVATION_DATE IS NOT NULL INTO is_inactive
    FROM Product WHERE ID_PRODUCT = NEW.ID_PRODUCT;
    
    IF is_inactive THEN
        RAISE EXCEPTION 'Produto % está inativo e não pode ser vendido', NEW.ID_PRODUCT;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- function for setting return date to current timestamp if not provided

CREATE OR REPLACE FUNCTION trg_set_return_return_date_func()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.RETURN_DATE IS NULL THEN
        NEW.RETURN_DATE := NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
