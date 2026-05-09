--=========================================================
-- MODULE 2: FOREIGN KEYS (ANIMAL MANAGEMENT)
--=========================================================
--
-- See 01_ForeignKeys_Mod1.sql for the architectural rationale
-- (uniform init: tables first, then FK layer, then behavior).
--
--=========================================================

-- breed → species
alter table breed
    add constraint fk_breed_species
        foreign key (id_spc)
        references species(id_spc)
        on delete cascade;

-- animal → species, breed
alter table animal
    add constraint fk_animal_species
        foreign key (id_spc)
        references species(id_spc)
        on delete restrict;

alter table animal
    add constraint fk_animal_breed
        foreign key (id_bre)
        references breed(id_bre)
        on delete set null;

-- ownership → client, animal, employee
alter table ownership
    add constraint fk_ownership_client
        foreign key (id_cli)
        references client(id_cli)
        on delete cascade;

alter table ownership
    add constraint fk_ownership_animal
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade;

alter table ownership
    add constraint fk_ownership_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete set null;

-- concession → external_entity, employee, animal
alter table concession
    add constraint fk_concession_entity
        foreign key (id_ext_ent)
        references external_entity(id_ext_ent)
        on delete restrict;

alter table concession
    add constraint fk_concession_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete restrict;

alter table concession
    add constraint fk_concession_animal
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade;

-- delivery → external_entity, animal
alter table delivery
    add constraint fk_delivery_entity
        foreign key (id_ext_ent)
        references external_entity(id_ext_ent)
        on delete set null;

alter table delivery
    add constraint fk_delivery_animal
        foreign key (id_ani)
        references animal(id_ani)
        on delete cascade;

-- delivery_employee → delivery, employee
alter table delivery_employee
    add constraint fk_del_emp_delivery
        foreign key (id_del)
        references delivery(id_del)
        on delete cascade;

alter table delivery_employee
    add constraint fk_del_emp_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;
