-- =========================================================
-- comments: triggers - module 3
-- =========================================================
-- metadata documentation for triggers orchestrating stock,
-- invoicing, and return flows.
-- =========================================================

-- comment on trigger trg_check_stock_before_sale on invoice_line is
-- 'fires before insert to guarantee sufficient stock';

-- comment on trigger trg_stock_after_sale on invoice_line is
-- 'fires after insert to consume fifo inventory';

-- comment on trigger trg_update_invoice_total on invoice_line is
-- 'fires after line mutations to refresh invoice totals';

-- comment on trigger trg_return_restock on "return" is
-- 'fires after return insert to push stock corrections';

-- comment on trigger trg_prevent_inactive_product_sale on invoice_line is
-- 'fires before insert to reject inactive catalog items';

-- comment on trigger trg_set_return_return_date on "return" is
-- 'fires before insert to stamp closure metadata';
