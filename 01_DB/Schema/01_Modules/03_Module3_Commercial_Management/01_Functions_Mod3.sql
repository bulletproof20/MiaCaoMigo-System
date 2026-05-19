-- Stock disponível de um produto (todos os lotes juntos)
CREATE OR REPLACE FUNCTION fn_get_available_stock(p_product_id INT)
RETURNS INT AS $$
BEGIN
    RETURN COALESCE(
        (SELECT SUM(qty_sto) FROM Stock WHERE id_pro = p_product_id AND qty_sto > 0),
        0
    );
END;
$$ LANGUAGE plpgsql;


--function that is called by the trigger that checks for low stock 
--after a sale and raises a notice if the stock is below the minimum

CREATE OR REPLACE FUNCTION trg_warn_low_stock_func()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_atual INT;
    v_min_sto INT;
    v_nam_pro VARCHAR;
BEGIN
    -- 1. Ver stock após abate
    SELECT fn_get_available_stock(NEW.ID_PRODUCT) INTO v_stock_atual;
    
    -- 2. Buscar dados do produto específico
    SELECT min_sto, nam_pro INTO v_min_sto, v_nam_pro
    FROM Product 
    WHERE id_pro = NEW.ID_PRODUCT;
    
    -- 3. Aviso se atingir o limite individual
    IF v_stock_atual <= v_min_sto THEN
        RAISE NOTICE ' STOCK BAIXO: O produto "%" (ID: %) tem apenas % unidades. (Mínimo: %). Consulte a View vw_produtos_para_encomendar.', 
                     v_nam_pro, NEW.ID_PRODUCT, v_stock_atual, v_min_sto;
    END IF;
    
    RETURN NEW;
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
        SELECT id_sto, qty_sto FROM Stock
        WHERE id_pro = NEW.ID_PRODUCT AND qty_sto > 0
        ORDER BY val_dat_sto NULLS LAST
    LOOP
        IF remaining_quantity <= stock_record.qty_sto THEN
            UPDATE Stock SET qty_sto = stock_record.qty_sto - remaining_quantity
            WHERE id_sto = stock_record.id_sto;
            EXIT;
        ELSE
            UPDATE Stock SET qty_sto = 0
            WHERE id_sto = stock_record.id_sto;
            remaining_quantity := remaining_quantity - stock_record.qty_sto;
        END IF;
    END LOOP;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- function for updating invoice total after inserting/updating/deleting an invoice line

CREATE OR REPLACE FUNCTION trg_update_invoice_total_func()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Invoice SET val_inv = (
        SELECT COALESCE(SUM(QUANTITY * UNIT_PRICE * (1 + IVA/100)), 0)
        FROM InvoiceLine
        WHERE ID_INVOICE = NEW.ID_INVOICE
    )
    WHERE id_inv = NEW.ID_INVOICE;
    
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
    INSERT INTO Stock (id_pro, bat_sto, qty_sto, ent_dat_sto, val_dat_sto)
    VALUES (
        prod_id,
        (SELECT bat_sto FROM Stock WHERE id_pro = prod_id ORDER BY ent_dat_sto DESC LIMIT 1),
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
    SELECT ina_dat_pro IS NOT NULL INTO is_inactive
    FROM Product WHERE id_pro = NEW.ID_PRODUCT;
    
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



-- function to start a new purchase and automatically return the new ID
CREATE OR REPLACE FUNCTION fn_create_purchase(
    p_id_emp INT DEFAULT NULL,
    p_id_cli INT DEFAULT NULL
)
RETURNS INT AS $$
DECLARE
    v_new_purchase_id INT;
BEGIN
    -- Usufrui dos valores DEFAULT criados na tabela para o pur_dat_pur e sta_pur
    INSERT INTO purchase (id_emp, id_cli)
    VALUES (p_id_emp, p_id_cli)
    RETURNING id_pur INTO v_new_purchase_id;
    
    RETURN v_new_purchase_id;
END;
$$ LANGUAGE plpgsql;


-- function for updating purchase total after inserting/updating/deleting a purchase line
CREATE OR REPLACE FUNCTION trg_update_purchase_total_func()
RETURNS TRIGGER AS $$
DECLARE
    v_id_pur INT;
BEGIN
    -- Garante que funciona tanto para INSERT/UPDATE (NEW) como para DELETE (OLD)
    IF TG_OP = 'DELETE' THEN
        v_id_pur := OLD.ID_PURCHASE;
    ELSE
        v_id_pur := NEW.ID_PURCHASE;
    END IF;

    UPDATE Purchase SET tot_val_pur = (
        SELECT COALESCE(SUM(QUANTITY * UNIT_COST), 0)
        FROM PurchaseLine
        WHERE ID_PURCHASE = v_id_pur
    )
    WHERE id_pur = v_id_pur;
    
    IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END;
$$ LANGUAGE plpgsql;
