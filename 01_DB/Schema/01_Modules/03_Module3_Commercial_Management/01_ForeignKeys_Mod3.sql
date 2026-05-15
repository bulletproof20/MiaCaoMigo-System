--=========================================================
-- MODULE 3: FOREIGN KEYS (COMMERCIAL MANAGEMENT)
--=========================================================
--
-- Deferred and cross-module FKs for commercial entities live here
-- so that all tables (Modules 1–4) exist before linking.
--
-- Order respects circular links between product, stock, purchase,
-- and return (same semantics as previous end-of-file ALTER block).
--
--=========================================================

-- product → family (declared first; other product FKs applied below)
alter table product
    add constraint fk_product_family
        foreign key (id_fam)
        references family(id_fam)
        on delete restrict;

-- stock → product
alter table stock
    add constraint fk_stock_product
        foreign key (id_pro)
        references product(id_pro)
        on delete cascade;

-- invoice → appointment (optional link)
alter table invoice
    add constraint fk_invoice_appointment
        foreign key (id_app)
        references appointment(id_app)
        on delete set null;

-- purchase → invoice, client, employee
alter table purchase
    add constraint fk_purchase_invoice
        foreign key (id_inv)
        references invoice(id_inv)
        on delete cascade;

alter table purchase
    add constraint fk_purchase_client
        foreign key (id_cli)
        references client(id_cli)
        on delete set null;

alter table purchase
    add constraint fk_purchase_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete set null;

-- purchase_line → purchase, product, stock
alter table purchase_line
    add constraint fk_purchase_line_purchase
        foreign key (id_pur)
        references purchase(id_pur)
        on delete cascade;

alter table purchase_line
    add constraint fk_purchase_line_product
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict;

alter table purchase_line
    add constraint fk_purchase_line_stock
        foreign key (id_sto)
        references stock(id_sto)
        on delete set null;

-- invoice_line → invoice, product
alter table invoice_line
    add constraint fk_invoice_line_invoice
        foreign key (id_inv)
        references invoice(id_inv)
        on delete cascade;

alter table invoice_line
    add constraint fk_invoice_line_product
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict;

-- return → invoice_line (optional)
alter table return
    add constraint fk_return_invoice_line
        foreign key (id_inv_lin)
        references invoice_line(id_inv_lin)
        on delete set null;

-- purchase_product
alter table purchase_product
    add constraint fk_pur_pro_purchase
        foreign key (id_pur)
        references purchase(id_pur)
        on delete cascade;

alter table purchase_product
    add constraint fk_pur_pro_product
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict;

-- return_product
alter table return_product
    add constraint fk_ret_pro_return
        foreign key (id_ret)
        references return(id_ret)
        on delete cascade;

alter table return_product
    add constraint fk_ret_pro_product
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict;

-- employee_purchase
alter table employee_purchase
    add constraint fk_emp_pur_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table employee_purchase
    add constraint fk_emp_pur_purchase
        foreign key (id_pur)
        references purchase(id_pur)
        on delete cascade;

-- employee_return
alter table employee_return
    add constraint fk_emp_ret_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table employee_return
    add constraint fk_emp_ret_return
        foreign key (id_ret)
        references return(id_ret)
        on delete cascade;

-- product circular references (after purchase, stock, return rows can be targeted)
alter table product
    add constraint fk_purchase_product
        foreign key (id_pur)
        references purchase(id_pur)
        on delete set null;

alter table product
    add constraint fk_product_stock
        foreign key (id_sto)
        references stock(id_sto)
        on delete set null;

alter table product
    add constraint fk_product_return
        foreign key (id_ret)
        references "return"(id_ret)
        on delete set null;
