-- =========================================================
-- comments: functions - module 3
-- =========================================================
-- metadata documentation for stock, invoicing, and return
-- automation helpers used by commercial triggers.
-- =========================================================

comment on function fn_get_available_stock(integer) is
'aggregates positive stock quantities for a product across batches';

comment on function trg_check_stock_before_sale_func() is
'validates invoice lines against available stock before insert';

comment on function trg_stock_after_sale_func() is
'decrements fifo batches after a sale line is inserted';

comment on function trg_update_invoice_total_func() is
'recalculates invoice header totals when lines change';

comment on function trg_return_restock_func() is
'creates restock rows when returns reference invoice lines';

comment on function trg_prevent_inactive_product_sale_func() is
'blocks invoice lines for inactivated products';

comment on function trg_set_return_return_date_func() is
'defaults return closure timestamps when omitted';
