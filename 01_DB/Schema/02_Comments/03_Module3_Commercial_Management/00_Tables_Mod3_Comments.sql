--=========================================================
-- 1. family
--=========================================================

comment on table family is
'product family or category grouping for catalog organization';

comment on column family.id_fam is
'unique family identifier';

comment on column family.nam_fam is
'display name of the family';

comment on column family.des_fam is
'long-form description';

comment on constraint pk_family on family is
'primary key for family rows';


--=========================================================
-- 2. invoice
--=========================================================

comment on table invoice is
'billing header that may reference an appointment';

comment on column invoice.id_inv is
'unique invoice identifier';

comment on column invoice.val_inv is
'monetary total for the invoice';

comment on column invoice.dat_inv is
'issue timestamp';

comment on column invoice.bod_inv is
'free-text body or notes';

comment on column invoice.id_app is
'optional appointment linkage (FK in 01_ForeignKeys_Mod3.sql)';

comment on constraint pk_invoice on invoice is
'primary key for invoice rows';


--=========================================================
-- 3. product
--=========================================================

comment on table product is
'catalog item with pricing, tax, and lifecycle metadata';

comment on column product.id_pro is
'unique product identifier';

comment on column product.ref_pro is
'internal reference code';

comment on column product.bar_pro is
'barcode or alternate scanner key';

comment on column product.nam_pro is
'product name';

comment on column product.des_pro is
'detailed description';

comment on column product.pri_pro is
'unit list price';

comment on column product.iva_pro is
'vat percentage';

comment on column product.reg_dat_pro is
'catalog registration timestamp';

comment on column product.ina_dat_pro is
'inactivation timestamp when the sku retires';

comment on column product.id_pur is
'optional pointer to latest purchase (FK phase)';

comment on column product.id_sto is
'optional pointer to primary stock row (FK phase)';

comment on column product.id_fam is
'required catalog family';

comment on column product.id_ret is
'optional pointer to latest return (FK phase)';

comment on constraint pk_product on product is
'primary key for product rows';


--=========================================================
-- 4. stock
--=========================================================

comment on table stock is
'quantity ledger per product with batch and expiry metadata';

comment on column stock.id_sto is
'unique stock row identifier';

comment on column stock.id_pro is
'product being stocked';

comment on column stock.bat_sto is
'batch or lot identifier';

comment on column stock.qty_sto is
'available quantity in this batch';

comment on column stock.val_dat_sto is
'expiration date';

comment on column stock.ent_dat_sto is
'warehouse entry date';

comment on constraint pk_stock on stock is
'primary key for stock rows';

comment on constraint ck_qty_sto on stock is
'disallows negative quantities';


--=========================================================
-- 5. purchase
--=========================================================

comment on table purchase is
'purchase order header with totals and workflow status';

comment on column purchase.id_pur is
'unique purchase identifier';

comment on column purchase.pur_dat_pur is
'purchase timestamp';

comment on column purchase.tot_val_pur is
'order total';

comment on column purchase.ord_num_pur is
'external order reference';

comment on column purchase.pay_met_pur is
'payment method label';

comment on column purchase.sta_pur is
'workflow state using centralized purchase_status enum (nullable until confirmed)';

comment on column purchase.id_inv is
'linked invoice when billed';

comment on column purchase.id_cli is
'optional client reference';

comment on column purchase.id_emp is
'employee responsible for the purchase';

comment on constraint pk_purchase on purchase is
'primary key for purchase rows';


--=========================================================
-- 6. purchase_line
--=========================================================

comment on table purchase_line is
'line-level detail for incoming stock tied to a purchase';

comment on column purchase_line.id_pur_lin is
'unique line identifier';

comment on column purchase_line.id_pur is
'parent purchase';

comment on column purchase_line.id_pro is
'product being procured';

comment on column purchase_line.bat_pln is
'batch label captured at receipt';

comment on column purchase_line.qty_pln is
'ordered quantity';

comment on column purchase_line.uni_cos_pln is
'unit cost';

comment on column purchase_line.id_sto is
'optional stock row created from this line';

comment on constraint pk_purchase_line on purchase_line is
'primary key for purchase_line rows';

comment on constraint ck_qty_pln on purchase_line is
'requires strictly positive quantities';


--=========================================================
-- 7. invoice_line
--=========================================================

comment on table invoice_line is
'sales line items contributing to invoice totals';

comment on column invoice_line.id_inv_lin is
'unique invoice line identifier';

comment on column invoice_line.id_inv is
'parent invoice';

comment on column invoice_line.id_pro is
'product sold';

comment on column invoice_line.qty_inv_lin is
'quantity sold';

comment on column invoice_line.uni_pri_inv_lin is
'unit selling price';

comment on column invoice_line.iva_inv_lin is
'vat rate applied to the line';

comment on constraint pk_invoice_line on invoice_line is
'primary key for invoice_line rows';

comment on constraint ck_qty_inv_lin on invoice_line is
'requires strictly positive sale quantities';


--=========================================================
-- 8. return
--=========================================================

comment on table "return" is
'commercial return header with optional invoice line linkage';

comment on column "return".id_ret is
'unique return identifier';

comment on column "return".mot_ret is
'reason narrative';

-- comment on column "return".reg_dat_ret is
-- 'record creation timestamp';

comment on column "return".ina_dat_ret is
'closure or inactivation timestamp';

comment on column "return".id_inv_lin is
'optional originating invoice line';

comment on column "return".qty_ret is
'quantity being returned';

comment on constraint pk_return on "return" is
'primary key for return rows';


--=========================================================
-- 9. purchase_product
--=========================================================

comment on table purchase_product is
'associative detail between purchases and products with quantities';

comment on column purchase_product.id_pur is
'purchase reference';

comment on column purchase_product.id_pro is
'product reference';

comment on column purchase_product.qty_pur_pro is
'quantity associated with the pair';

comment on constraint pk_purchase_product on purchase_product is
'composite primary key';

comment on constraint ck_qty_purchase on purchase_product is
'enforces strictly positive quantities';


--=========================================================
-- 10. return_product
--=========================================================

comment on table return_product is
'associative detail between returns and products';

comment on column return_product.id_ret is
'return reference';

comment on column return_product.id_pro is
'product reference';

comment on column return_product.qty_ret_pro is
'returned quantity';

comment on constraint pk_return_product on return_product is
'composite primary key';

comment on constraint ck_qty_return on return_product is
'enforces strictly positive quantities';


--=========================================================
-- 11. employee_purchase
--=========================================================

comment on table employee_purchase is
'links employees to purchases they processed';

comment on column employee_purchase.id_emp is
'employee identifier';

comment on column employee_purchase.id_pur is
'purchase identifier';

comment on constraint pk_employee_purchase on employee_purchase is
'composite primary key';


--=========================================================
-- 12. employee_return
--=========================================================

comment on table employee_return is
'links employees to returns they supervised';

comment on column employee_return.id_emp is
'employee identifier';

comment on column employee_return.id_ret is
'return identifier';

comment on constraint pk_employee_return on employee_return is
'composite primary key';
