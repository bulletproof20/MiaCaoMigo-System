--=========================================================
-- MODULE 4 — metadata: foreign keys
--=========================================================
-- Declarative FKs are defined in 01_ForeignKeys_Mod4.sql once
-- modules 1–4 tables exist.
--=========================================================

comment on constraint fk_animal on appointment is
'ensures appointments reference a live animal';

comment on constraint fk_appointment_employee on appointment is
'binds the visit to a responsible employee';

comment on constraint fk_client on appointment is
'binds the visit to the owning client';

comment on constraint fk_appointment on overall_assessment is
'vitals row references its appointment';

comment on constraint fk_anamnesis_appointment on anamnesis is
'history row references its appointment';

comment on constraint fk_prescription_appointment on prescription is
'prescription references the originating appointment';

comment on constraint fk_app_pro_appointment on rel_app_product is
'usage row references appointment context';

comment on constraint fk_app_pro_product on rel_app_product is
'usage row references catalog inventory';

comment on constraint fk_pre_pro_prescription on rel_pre_prod is
'prescription line references header';

comment on constraint fk_pre_pro_product on rel_pre_prod is
'prescription line references product sku';

comment on constraint fk_appointment_notification_client on appointment_notification is
'notification targets a registered client';
