--=========================================================
-- MODULE 3 — metadata: foreign keys
--=========================================================
-- Declarative FKs are defined in 01_ForeignKeys_Mod3.sql after
-- cross-module tables exist (including appointment from module 4).
--=========================================================

comment on constraint fk_product_family on product is
'every product belongs to a catalog family';

comment on constraint fk_stock_product on stock is
'stock rows reference their product master data';

comment on constraint fk_invoice_appointment on invoice is
'optional bridge from billing to scheduling';

comment on constraint fk_purchase_invoice on purchase is
'purchase may reference an invoice for reconciliation';

comment on constraint fk_purchase_client on purchase is
'captures the client context for a purchase';

comment on constraint fk_purchase_employee on purchase is
'captures staff accountability';

comment on constraint fk_purchase_line_purchase on purchase_line is
'lines roll up to a purchase header';

comment on constraint fk_purchase_line_product on purchase_line is
'lines reference catalog products';

comment on constraint fk_purchase_line_stock on purchase_line is
'optional hook to generated stock rows';

comment on constraint fk_invoice_line_invoice on invoice_line is
'sales lines belong to an invoice';

comment on constraint fk_invoice_line_product on invoice_line is
'sales lines reference sellable products';

comment on constraint fk_return_invoice_line on "return" is
'returns may cite the invoice line that originated the sale';

comment on constraint fk_pur_pro_purchase on purchase_product is
'associative rows reference purchases';

comment on constraint fk_pur_pro_product on purchase_product is
'associative rows reference products';

comment on constraint fk_ret_pro_return on return_product is
'associative rows reference return headers';

comment on constraint fk_ret_pro_product on return_product is
'associative rows reference products';

comment on constraint fk_emp_pur_employee on employee_purchase is
'employee side of purchase participation';

comment on constraint fk_emp_pur_purchase on employee_purchase is
'purchase side of employee participation';

comment on constraint fk_emp_ret_employee on employee_return is
'employee side of return participation';

comment on constraint fk_emp_ret_return on employee_return is
'return side of employee participation';

comment on constraint fk_purchase_product on product is
'latest purchase pointer maintained on the product';

comment on constraint fk_product_stock on product is
'current stock pointer maintained on the product';

comment on constraint fk_product_return on product is
'latest return pointer maintained on the product';
