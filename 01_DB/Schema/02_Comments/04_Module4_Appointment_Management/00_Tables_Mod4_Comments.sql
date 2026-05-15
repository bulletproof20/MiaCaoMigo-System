--=========================================================
-- 1. appointment
--=========================================================
-- ENUM metadata: 02_Comments/00_Core/02_Types_Comments.sql

comment on table appointment is
'scheduling and consultation session for a client animal with assigned veterinarian and declared clinical specialty';

comment on column appointment.id_app is
'unique appointment identifier';

comment on column appointment.id_ani is
'animal receiving care';

comment on column appointment.id_emp is
'assigned employee (veterinarian)';

comment on column appointment.id_cli is
'client responsible for the visit';

comment on column appointment.id_spe is
'clinical specialty requested for this consultation; FK to module 1 specialty catalog; must match an expert(id_emp,id_spe) assignment for the veterinarian';

comment on column appointment.sch_dat_app is
'scheduled start timestamp';

comment on column appointment.sta_dat_app is
'actual consultation start timestamp';

comment on column appointment.end_dat_app is
'actual consultation end timestamp';

comment on column appointment.status_app is
'workflow status using appointment_status enum';

comment on column appointment.dia_app is
'diagnosis captured when closing the visit';

comment on column appointment.com_app is
'free-form clinical or operational notes';

comment on constraint pk_appointment on appointment is
'primary key for appointment rows';

comment on constraint ck_appointment_flow on appointment is
'ensures recorded end time is strictly after start time when both present';


--=========================================================
-- 2. overall_assessment
--=========================================================

comment on table overall_assessment is
'structured vitals captured during an appointment';

comment on column overall_assessment.id_app is
'primary key and foreign key to appointment';

comment on column overall_assessment.bod_tmp_ova is
'body temperature in degrees celsius';

comment on column overall_assessment.wei_ova is
'weight measurement in kilograms';

comment on column overall_assessment.hrt_rat_ova is
'heart rate in beats per minute';

comment on column overall_assessment.res_rat_ova is
'respiratory rate in breaths per minute';

comment on column overall_assessment.gen_sta_ova is
'qualitative assessment narrative';

comment on constraint pk_overall_assessment on overall_assessment is
'primary key for overall_assessment rows';

comment on constraint ck_bod_tmp_ova on overall_assessment is
'keeps temperature within plausible veterinary bounds';

comment on constraint ck_wei_ova on overall_assessment is
'requires positive weight measurements';


--=========================================================
-- 3. anamnesis
--=========================================================

comment on table anamnesis is
'client-reported history snippets tied to appointments';

comment on column anamnesis.id_app is
'related appointment';

comment on column anamnesis.reg_dat_ana is
'capture timestamp';

comment on column anamnesis.des_ana is
'detailed history narrative';

comment on constraint pk_anamnesis on anamnesis is
'primary key for anamnesis rows';


--=========================================================
-- 4. prescription
--=========================================================

comment on table prescription is
'prescription metadata issued during a consultation';

comment on column prescription.id_pre is
'unique prescription identifier';

comment on column prescription.id_app is
'parent appointment';

comment on column prescription.reg_dat_pre is
'issuance timestamp';

comment on column prescription.des_pre is
'instructions or pharmaceutical narrative';

comment on constraint pk_prescription on prescription is
'primary key for prescription rows';


--=========================================================
-- 5. rel_app_product
--=========================================================

comment on table rel_app_product is
'products consumed or billed directly through an appointment';

comment on column rel_app_product.id_app is
'appointment reference';

comment on column rel_app_product.id_pro is
'product reference';

comment on column rel_app_product.qty_pre_pro is
'quantity associated with the appointment usage';

comment on column rel_app_product.dos_pre_pro is
'dosage or administration instructions';

comment on constraint pk_appointment_product on rel_app_product is
'composite primary key';

comment on constraint ck_qty_rel_app_product on rel_app_product is
'requires strictly positive quantities';


--=========================================================
-- 6. rel_pre_prod
--=========================================================

comment on table rel_pre_prod is
'line items that materialize a prescription into catalog skus';

comment on column rel_pre_prod.id_pre is
'prescription reference';

comment on column rel_pre_prod.id_pro is
'product reference';

comment on column rel_pre_prod.qty_pre_pro is
'prescribed quantity';

comment on column rel_pre_prod.dos_pre_pro is
'dosage instructions';

comment on constraint pk_prescription_product on rel_pre_prod is
'composite primary key';

comment on constraint ck_qty_rel_pre_prod on rel_pre_prod is
'requires strictly positive quantities';


--=========================================================
-- 7. appointment_notification
--=========================================================

comment on table appointment_notification is
'client notifications such as reminders generated by jobs or procedures';

comment on column appointment_notification.id_not is
'unique notification identifier';

comment on column appointment_notification.id_cli is
'target client';

comment on column appointment_notification.msg_not is
'human-readable notification body';

comment on column appointment_notification.cre_tim_not is
'creation timestamp';

comment on column appointment_notification.rea_not is
'read/unread flag for client portals';

comment on constraint pk_appointment_notification on appointment_notification is
'primary key for appointment_notification rows';
