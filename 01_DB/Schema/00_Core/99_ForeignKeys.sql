-- =========================================================
-- global foreign keys script
-- auxiliary file responsible for creating
-- global foreign keys across the system.
--
-- some foreign keys are applied only
-- in this file to avoid problems related to:
-- - circular dependencies
-- - table creation order
-- - cross-module references
--
-- this approach allows all modules
-- to be loaded independently without
-- requiring a single massive file
-- containing every table definition
-- in the system.
-- =========================================================


-- =========================================================
-- module 3: commercial management
-- =========================================================

-- relationship between product and purchase
alter table product
add constraint fk_purchase_product
foreign key (id_pur)
references purchase(id_pur)
on delete set null;


-- relationship between product and stock
alter table product
add constraint fk_stock
foreign key (id_sto)
references stock(id_sto)
on delete set null;


-- relationship between product and return
alter table product
add constraint fk_return
foreign key (id_ret)
references "return"(id_ret)
on delete set null;


constraint fk_invoice_appointment foreign key (id_app)
    references appointment(id_app)
    on delete set null
-- Links to appointment

-- =========================================================
-- module 4: appointment management
-- =========================================================

-- relationship between appointment and animal
alter table appointment
add constraint fk_animal
foreign key (id_animal)
references animal(id_ani)
on delete cascade;
```
