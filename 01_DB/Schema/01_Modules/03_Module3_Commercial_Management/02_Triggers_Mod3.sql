--- ========================================================= ------


--Calls low stock function befor inserting new line 

CREATE TRIGGER trg_check_stock_before_sale
BEFORE INSERT ON InvoiceLine
FOR EACH ROW
EXECUTE FUNCTION trg_check_stock_before_sale_func();



-- cals function that updates stock after a sale
CREATE TRIGGER trg_stock_after_sale
AFTER INSERT ON InvoiceLine
FOR EACH ROW
EXECUTE FUNCTION trg_stock_after_sale_func();



-- calls function that updates invoice total after inserting/updating/deleting an invoice line

CREATE TRIGGER trg_update_invoice_total
AFTER INSERT OR UPDATE OR DELETE ON InvoiceLine
FOR EACH ROW
EXECUTE FUNCTION trg_update_invoice_total_func();

-- calls function that restocks products after a return is inserted

CREATE TRIGGER trg_return_restock
AFTER INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION trg_return_restock_func();


-- calls function that prevents sales of inactive products

CREATE TRIGGER trg_prevent_inactive_product_sale
BEFORE INSERT ON InvoiceLine
FOR EACH ROW
EXECUTE FUNCTION trg_prevent_inactive_product_sale_func();




-- calls function that sets return date after inserting a return

CREATE TRIGGER trg_set_return_return_date
BEFORE INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION trg_set_return_return_date_func();


-- calls function that updates purchase total after inserting/updating/deleting a purchase line
CREATE TRIGGER trg_update_purchase_total
AFTER INSERT OR UPDATE OR DELETE ON PurchaseLine
FOR EACH ROW
EXECUTE FUNCTION trg_update_purchase_total_func();