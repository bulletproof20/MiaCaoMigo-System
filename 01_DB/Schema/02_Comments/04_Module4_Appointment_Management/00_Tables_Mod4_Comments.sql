--=========================================================
-- COMMENTS: TABLES - MODULE 4
--=========================================================

--=========================================================
-- 1. appointment
--=========================================================

COMMENT ON TABLE appointment IS
'Stores all data related to veterinary appointments, from scheduling to completion.';

COMMENT ON COLUMN appointment.id_app IS
'Unique identifier for the appointment.';
COMMENT ON COLUMN appointment.id_cli IS
'Foreign key referencing the client associated with the appointment.';
COMMENT ON COLUMN appointment.id_animal IS
'Foreign key referencing the animal patient for the appointment.';
COMMENT ON COLUMN appointment.id_emp IS
'Foreign key referencing the veterinarian assigned to the appointment.';
COMMENT ON COLUMN appointment.sch_dat_app IS
'The scheduled date and time for the appointment.';
COMMENT ON COLUMN appointment.sta_dat_app IS
'Timestamp marking the actual start of the appointment.';
COMMENT ON COLUMN appointment.end_dat_app IS
'Timestamp marking the end of the appointment.';
COMMENT ON COLUMN appointment.status_app IS
'Current status of the appointment (e.g., Scheduled, In Progress, Completed, Cancelled, No-Show).';
COMMENT ON COLUMN appointment.dia_app IS
'Clinical diagnosis determined by the veterinarian during the appointment.';
COMMENT ON COLUMN appointment.com_app IS
'General comments or observations from the veterinarian.';

COMMENT ON CONSTRAINT pk_appointment ON appointment IS
'Ensures unique identification for each appointment.';
COMMENT ON CONSTRAINT fk_appointment_client ON appointment IS
'Links the appointment to a valid client.';
COMMENT ON CONSTRAINT fk_appointment_animal ON appointment IS
'Links the appointment to a valid animal.';
COMMENT ON CONSTRAINT fk_appointment_employee ON appointment IS
'Links the appointment to a valid employee (veterinarian).';
COMMENT ON CONSTRAINT chk_appointment_flow ON appointment IS
'Ensures the temporal consistency of appointment timestamps (start must be before end).';


--=========================================================
-- 2. overall_assessment
--=========================================================

COMMENT ON TABLE overall_assessment IS
'Stores the objective clinical assessment data collected during an appointment.';

COMMENT ON COLUMN overall_assessment.id_app IS
'Unique identifier and foreign key linking the assessment to a specific appointment (1-to-1 relationship).';
COMMENT ON COLUMN overall_assessment.body_temp IS
'Animal''s body temperature in Celsius.';
COMMENT ON COLUMN overall_assessment.weight IS
'Animal''s weight in kilograms.';
COMMENT ON COLUMN overall_assessment.hrt_rate IS
'Animal''s heart rate in beats per minute.';
COMMENT ON COLUMN overall_assessment.resp_rate IS
'Animal''s respiratory rate in breaths per minute.';
COMMENT ON COLUMN overall_assessment.general_status IS
'A textual description of the animal''s overall condition.';

COMMENT ON CONSTRAINT pk_overall_assessment ON overall_assessment IS
'Ensures unique identification for each assessment record.';
COMMENT ON CONSTRAINT fk_assessment_appointment ON overall_assessment IS
'Links the assessment to a valid appointment.';


--=========================================================
-- 3. anamnesis
--=========================================================

COMMENT ON TABLE anamnesis IS
'Stores the anamnesis (patient''s medical history) information provided by the client.';

COMMENT ON COLUMN anamnesis.id_ana IS
'Unique identifier for the anamnesis record.';
COMMENT ON COLUMN anamnesis.id_app IS
'Foreign key linking the anamnesis to a specific appointment.';
COMMENT ON COLUMN anamnesis.des_ana IS
'Detailed description of the patient''s history and symptoms as reported by the client.';

COMMENT ON CONSTRAINT pk_anamnesis ON anamnesis IS
'Ensures unique identification for each anamnesis record.';
COMMENT ON CONSTRAINT uq_anamnesis_per_appointment ON anamnesis IS
'Ensures only one anamnesis can be registered per appointment.';
COMMENT ON CONSTRAINT fk_anamnesis_appointment ON anamnesis IS
'Links the anamnesis to a valid appointment.';


--=========================================================
-- 4. prescription
--=========================================================

COMMENT ON TABLE prescription IS
'Stores the medical prescription issued during an appointment.';

COMMENT ON COLUMN prescription.id_pre IS
'Unique identifier for the prescription.';
COMMENT ON COLUMN prescription.id_app IS
'Foreign key linking the prescription to a specific appointment.';
COMMENT ON COLUMN prescription.des_pre IS
'Detailed description of the prescribed treatment, medication, and instructions.';

COMMENT ON CONSTRAINT pk_prescription ON prescription IS
'Ensures unique identification for each prescription record.';
COMMENT ON CONSTRAINT uq_prescription_per_appointment ON prescription IS
'Ensures only one prescription can be registered per appointment.';
COMMENT ON CONSTRAINT fk_prescription_appointment ON prescription IS
'Links the prescription to a valid appointment.';


--=========================================================
-- 5. appointment_notification
--=========================================================

COMMENT ON TABLE appointment_notification IS
'Stores notifications sent to clients regarding their appointments (e.g., reminders, confirmations).';

COMMENT ON COLUMN appointment_notification.id_not IS
'Unique identifier for the notification.';
COMMENT ON COLUMN appointment_notification.id_cli IS
'Foreign key referencing the client who received the notification.';
COMMENT ON COLUMN appointment_notification.id_app IS
'Foreign key referencing the appointment related to the notification.';
COMMENT ON COLUMN appointment_notification.message IS
'The content of the notification message.';
COMMENT ON COLUMN appointment_notification.is_read IS
'Flag indicating whether the client has read the notification.';
COMMENT ON COLUMN appointment_notification.created_at IS
'Timestamp when the notification was created.';

COMMENT ON CONSTRAINT pk_appointment_notification ON appointment_notification IS
'Ensures unique identification for each notification.';
COMMENT ON CONSTRAINT fk_notification_client ON appointment_notification IS
'Links the notification to a valid client.';
COMMENT ON CONSTRAINT fk_notification_appointment ON appointment_notification IS
'Links the notification to a valid appointment.';