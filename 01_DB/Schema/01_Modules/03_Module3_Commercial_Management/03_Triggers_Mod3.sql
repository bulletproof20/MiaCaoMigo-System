--- ========================================================= ------


--Calls low stock function befor inserting new line 

CREATE TRIGGER trg_check_stock_before_sale
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_check_stock_before_sale();



-- cals function that updates stock after a sale
CREATE TRIGGER trg_stock_after_sale
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_stock_after_sale();


-- calls function that updates invoice total after inserting/updating/deleting an invoice line
CREATE TRIGGER trg_update_invoice_total
AFTER INSERT OR UPDATE OR DELETE ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_update_invoice_total();

-- calls function that restocks products after a return is inserted

CREATE TRIGGER trg_return_restock
AFTER INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION fn_return_restock();


-- calls function that prevents sales of inactive products

CREATE TRIGGER trg_prevent_inactive_product_sale
BEFORE INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_prevent_inactive_product_sale();




-- calls function that sets return date after inserting a return

CREATE TRIGGER trg_set_return_return_date
BEFORE INSERT ON "return"
FOR EACH ROW
EXECUTE FUNCTION fn_set_return_inactivation_date();