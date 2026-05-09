--- ========================================================= ------


-- Stock check before sale line insert
create trigger trg_check_stock_before_sale
before insert on invoice_line
for each row
execute function trg_check_stock_before_sale_func();


-- Decrement stock after sale line insert
create trigger trg_stock_after_sale
after insert on invoice_line
for each row
execute function trg_stock_after_sale_func();


-- Recalculate invoice header total
create trigger trg_update_invoice_total
after insert or update or delete on invoice_line
for each row
execute function trg_update_invoice_total_func();

-- Restock on return insert
create trigger trg_return_restock
after insert on "return"
for each row
execute function trg_return_restock_func();


-- Block inactive products on invoice lines
create trigger trg_prevent_inactive_product_sale
before insert on invoice_line
for each row
execute function trg_prevent_inactive_product_sale_func();


-- Default ina_dat_ret on return insert
create trigger trg_set_return_return_date
before insert on "return"
for each row
execute function trg_set_return_return_date_func();
