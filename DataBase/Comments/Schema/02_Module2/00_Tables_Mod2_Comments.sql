--=========================================================
-- 1. species
--=========================================================

comment on table species is
'catalog of animal species supported by the clinic';

comment on column species.id_spc is
'unique species identifier';

comment on column species.nam_spc is
'common name of the species';

comment on column species.sci_nam_spc is
'optional scientific name';

comment on constraint pk_species on species is
'primary key for species rows';


--=========================================================
-- 2. breed
--=========================================================

comment on table breed is
'breed catalog scoped to a parent species';

comment on column breed.id_bre is
'unique breed identifier';

comment on column breed.nam_bre is
'breed display name';

comment on column breed.sci_nam_bre is
'optional scientific breed name';

comment on column breed.id_spc is
'reference to species (FK applied in 01_ForeignKeys_Mod2.sql)';

comment on constraint pk_breed on breed is
'primary key for breed rows';


--=========================================================
-- 3. animal
--=========================================================

comment on table animal is
'clinical and administrative record for each animal patient';

comment on column animal.id_ani is
'unique animal identifier';

comment on column animal.reg_id_ani is
'external or clinic-wide registration code';

comment on column animal.nam_ani is
'animal name';

comment on column animal.dat_bir_ani is
'birth date when known';

comment on column animal.gen_ani is
'biological sex marker (M/F)';

comment on column animal.ori_ani is
'origin or intake source narrative';

comment on column animal.sta_ani is
'operational status (e.g. internal, adopted, transferred)';

comment on column animal.id_spc is
'required species reference';

comment on column animal.id_bre is
'optional breed reference';

comment on constraint pk_animal on animal is
'primary key for animal rows';

comment on constraint uq_reg_id_ani on animal is
'enforces uniqueness of registration codes';

comment on constraint ck_gen_ani on animal is
'restricts gender codes to M, F, or null';


--=========================================================
-- 4. external_entity
--=========================================================

comment on table external_entity is
'partners such as shelters or suppliers involved in intake or transfers';

comment on column external_entity.id_ext_ent is
'unique external entity identifier';

comment on column external_entity.nam_ext_ent is
'organization name';

comment on column external_entity.loc_ext_ent is
'location descriptor';

comment on column external_entity.pho_ext_ent is
'contact phone in international format';

comment on column external_entity.ema_ext_ent is
'contact email';

comment on column external_entity.typ_ext_ent is
'entity classification label';

comment on constraint pk_external_entity on external_entity is
'primary key for external_entity rows';

comment on constraint ck_pho_ext_ent_format on external_entity is
'validates optional phone pattern';

comment on constraint ck_ema_ext_ent_format on external_entity is
'validates optional email pattern';


--=========================================================
-- 5. ownership
--=========================================================

comment on table ownership is
'client-to-animal ownership intervals with optional staff attribution';

comment on column ownership.id_own is
'unique ownership interval identifier';

comment on column ownership.id_cli is
'client who holds the animal';

comment on column ownership.id_ani is
'animal subject to ownership';

comment on column ownership.sta_dat_own is
'ownership start date';

comment on column ownership.end_dat_own is
'ownership end date when closed';

comment on column ownership.mot_own is
'reason narrative for the change';

comment on column ownership.id_emp is
'optional employee validating the change';

comment on constraint pk_ownership on ownership is
'primary key for ownership rows';

comment on constraint ck_ownership_dates on ownership is
'ensures end date is not before start date';


--=========================================================
-- 6. concession
--=========================================================

comment on table concession is
'transfer of an animal to an external entity with clinical context';

comment on column concession.id_con is
'unique concession identifier';

comment on column concession.dat_con is
'transfer date';

comment on column concession.mot_con is
'reason for concession';

comment on column concession.cli_sta_con is
'clinical status snapshot at transfer';

comment on column concession.id_ext_ent is
'target external entity';

comment on column concession.id_emp is
'employee authorizing the transfer';

comment on column concession.id_ani is
'animal being transferred';

comment on constraint pk_concession on concession is
'primary key for concession rows';


--=========================================================
-- 7. delivery
--=========================================================

comment on table delivery is
'rescue or intake workflow metadata for an animal';

comment on column delivery.id_del is
'unique delivery identifier';

comment on column delivery.reg_dat_del is
'record creation timestamp';

comment on column delivery.res_dat_del is
'rescue event timestamp';

comment on column delivery.del_dat_del is
'delivery or handover timestamp';

comment on column delivery.res_loc_del is
'location narrative for rescue';

comment on column delivery.cli_sta_del is
'clinical status at intake';

comment on column delivery.id_ext_ent is
'optional originating partner';

comment on column delivery.id_ani is
'animal associated with the delivery';

comment on constraint pk_delivery on delivery is
'primary key for delivery rows';

comment on constraint ck_delivery_dates on delivery is
'ensures delivery timestamp is not before registration timestamp';


--=========================================================
-- 8. delivery_employee
--=========================================================

comment on table delivery_employee is
'associates employees with a delivery operation';

comment on column delivery_employee.id_del is
'reference to delivery';

comment on column delivery_employee.id_emp is
'reference to participating employee';

comment on constraint pk_delivery_employee on delivery_employee is
'composite primary key for delivery_employee rows';
