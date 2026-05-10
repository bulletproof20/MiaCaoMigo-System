--=========================================================
-- MODULE 4: FOREIGN KEYS (APPOINTMENT MANAGEMENT)
--=========================================================
--
-- Cross-module links (animal, employee, client, product) are applied here
-- after all tables from Modules 1–4 exist.
--
--=========================================================

-- appointment → animal, employee, client
alter table appointment
    add constraint fk_animal
        foreign key (id_animal)
        references animal(id_ani)
        on delete cascade;

-- Add foreign key for employee in appointment table
alter table appointment
    add constraint fk_appointment_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete restrict;

-- Add foreign key for client in appointment table
alter table appointment
    add constraint fk_client
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade;
    
-- Add foreign key for specialty in appointment table
ALTER TABLE appointment
ADD CONSTRAINT fk_appointment_specialty
FOREIGN KEY (id_spe) REFERENCES specialty(id_spe)
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Add foreign key for invoice in appointment table
-- Assumes 'invoice' table with 'id_inv' PK from Module 3
ALTER TABLE appointment
ADD CONSTRAINT fk_appointment_invoice
FOREIGN KEY (id_inv) REFERENCES invoice(id_inv)
ON DELETE SET NULL ON UPDATE CASCADE;

-- overall_assessment → appointment
alter table overall_assessment
    add constraint fk_appointment
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade;

-- anamnesis → appointment
alter table anamnesis
    add constraint fk_anamnesis_appointment
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade;

-- prescription → appointment
alter table prescription
    add constraint fk_prescription_appointment
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade;

-- rel_app_product → appointment, product
alter table rel_app_product
    add constraint fk_app_pro_appointment
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade;

alter table rel_app_product
    add constraint fk_app_pro_product
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict;

-- rel_pre_prod → prescription, product
alter table rel_pre_prod
    add constraint fk_pre_pro_prescription
        foreign key (id_pre)
        references prescription(id_pre)
        on delete cascade;

alter table rel_pre_prod
    add constraint fk_pre_pro_product
        foreign key (id_pro)
        references product(id_pro)
        on delete restrict;

-- appointment_notification → client
alter table appointment_notification
    add constraint fk_appointment_notification_client
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade;
