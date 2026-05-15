--=========================================================
-- MODULE 4: FOREIGN KEYS (APPOINTMENT MANAGEMENT)
--=========================================================
--
-- Cross-module links (animal, employee, client, product) are applied here
-- after all tables from Modules 1–4 exist.
--
--=========================================================
-- appointment → animal, employee, client, specialty, invoice
alter table appointment
    add constraint fk_appointment_animal
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade;

alter table appointment
    add constraint fk_appointment_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete restrict;

alter table appointment
    add constraint fk_appointment_client
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade;

alter table appointment
    add constraint fk_appointment_specialty
        foreign key (id_spe)
        references specialty(id_spe)
        on delete restrict
        on update cascade;

alter table appointment
    add constraint fk_appointment_invoice
        foreign key (id_inv)
        references invoice(id_inv)
        on delete set null
        on update cascade;

-- overall_assessment → appointment
alter table overall_assessment
    add constraint pk_overall_assessment primary key (id_app);

alter table overall_assessment
    add constraint fk_overall_assessment_appointment
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

-- appointment_notification → client, appointment
alter table appointment_notification
    add constraint fk_appointment_notification_client
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade;

alter table appointment_notification
    add constraint fk_notification_appointment
        foreign key (id_app)
        references appointment(id_app)
        on delete cascade;
