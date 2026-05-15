-- =========================================================
-- comments: functions - module 3
-- =========================================================
-- metadata documentation for stock, invoicing, and return
-- automation helpers used by commercial triggers.
-- =========================================================

comment on function fn_get_available_stock(integer) is
'aggregates positive stock quantities for a product across batches';

comment on function fn_warn_low_stock() is
'raises a notice when stock falls at or below the product minimum after a sale';

comment on function fn_check_stock_before_sale() is
'validates invoice lines against available stock before insert';

comment on function fn_stock_after_sale() is
'decrements fifo batches after a sale line is inserted';

comment on function fn_update_invoice_total() is
'recalculates invoice header totals when lines change';

comment on function fn_return_restock() is
'creates restock rows when returns reference invoice lines';

comment on function fn_prevent_inactive_product_sale() is
'blocks invoice lines for inactivated products';

comment on function fn_set_return_inactivation_date() is
'defaults return closure timestamps when omitted';
