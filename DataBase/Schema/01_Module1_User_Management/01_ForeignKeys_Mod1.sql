--=========================================================
-- MODULE 1: FOREIGN KEYS (USER MANAGEMENT)
--=========================================================
--
-- ARCHITECTURE
-- ----------
-- Foreign keys are declared in this file, separate from
-- 00_Tables_Mod1.sql, so that:
--
--   * init/build scripts can create all base tables first
--     without circular-dependency ordering issues;
--   * cross-table dependencies are visible in one layer;
--   * modules stay uniform (00_Tables → 01_ForeignKeys → …);
--   * automation and CI can validate FK phases independently.
--
-- All constraints below use ALTER TABLE … ADD CONSTRAINT and
-- match the semantics previously embedded in CREATE TABLE.
--
--=========================================================

--=========================================================
-- employee → user_account, employee (self-reference)
--=========================================================

alter table employee
    add constraint fk_employee_user
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade;

alter table employee
    add constraint fk_employee_aut_reg
        foreign key (aut_reg_emp)
        references employee(id_emp)
        on delete set null;

alter table employee
    add constraint fk_employee_aut_ina
        foreign key (aut_ina_emp)
        references employee(id_emp)
        on delete set null;

--=========================================================
-- assistant, veterinarian, expert
--=========================================================

alter table assistant
    add constraint fk_assistant_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table veterinarian
    add constraint fk_veterinarian_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table expert
    add constraint fk_expert_veterinarian
        foreign key (id_emp)
        references veterinarian(id_emp)
        on delete cascade;

alter table expert
    add constraint fk_expert_specialty
        foreign key (id_spe)
        references specialty(id_spe)
        on delete cascade;

--=========================================================
-- client, login_record, setup
--=========================================================

alter table client
    add constraint fk_client_user
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade;

alter table login_record
    add constraint fk_login_record_user
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade;

alter table setup
    add constraint fk_setup_user
        foreign key (id_usr)
        references user_account(id_usr)
        on delete cascade;

--=========================================================
-- schedule, absence, clock_in
--=========================================================

alter table schedule
    add constraint fk_schedule_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table absence
    add constraint fk_absence_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table absence
    add constraint fk_absence_responsible
        foreign key (res_abs)
        references employee(id_emp)
        on delete set null;

alter table clock_in
    add constraint fk_clock_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

--=========================================================
-- RBAC associative tables
--=========================================================

alter table occupies
    add constraint fk_occ_employee
        foreign key (id_emp)
        references employee(id_emp)
        on delete cascade;

alter table occupies
    add constraint fk_occ_profile
        foreign key (id_pro)
        references profile(id_pro)
        on delete cascade;

alter table have
    add constraint fk_have_profile
        foreign key (id_pro)
        references profile(id_pro)
        on delete cascade;

alter table have
    add constraint fk_have_permission
        foreign key (id_per)
        references permission(id_per)
        on delete cascade;
