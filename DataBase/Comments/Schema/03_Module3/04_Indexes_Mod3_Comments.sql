-- =========================================================
-- comments: indexes - module 3
-- =========================================================

comment on index ix_stock_id_pro is
'b-tree: stock availability and fifo consumption by product';

comment on index ix_purchase_line_id_pur is
'b-tree: purchase line aggregation and receiving workflows';

comment on index ix_invoice_line_id_inv is
'b-tree: invoice total recalculation from line items';
