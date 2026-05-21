-- =========================================================
-- MASTER DATA — DATA CLEANER
-- FILE: 00_DataCleaner.sql
-- =========================================================
--
-- TIER: 00_MasterData (infrastructure)
-- Invoked first by Bootstrap/Loaders/11_MasterData.sql
-- =========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- This script removes all data stored in the database
-- while preserving the entire schema structure.
--
-- The cleanup process is organized by functional modules
-- and executed independently for easier maintenance,
-- testing and debugging.
--
-- FEATURES
-- --------------------------------------------------------
-- - Removes all records from system tables
-- - Preserves schema structure
-- - Preserves constraints, triggers and procedures
-- - Resets identity sequences
-- - Automatically resolves dependencies using CASCADE
--
-- INTENDED USAGE
-- --------------------------------------------------------
-- - Development environments
-- - Integration testing
-- - Seed regeneration
-- - Database reset operations
-- - Automated testing pipelines
--
-- WARNING
-- --------------------------------------------------------
-- This operation permanently deletes all stored data.
--
-- DBMS: PostgreSQL
--=========================================================



--=========================================================
-- SESSION CONFIGURATION
--=========================================================

SET TIMEZONE TO 'Europe/Lisbon';



--=========================================================
-- MODULE 1 — EMPLOYEE MANAGEMENT
--=========================================================
--
-- Removes all data related to:
-- - Employees
-- - Authentication
-- - Profiles and permissions
-- - Schedules and absences
--
-- Identity sequences are reset automatically.
--=========================================================

TRUNCATE TABLE

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
have,
occupies,
expert,

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
schedule,
absence,
clock_in,
setup,
login_record,
assistant,
veterinarian,

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
client,
employee,
profile,
permission,
specialty,

-----------------------------------------------------------
-- Base entity
-----------------------------------------------------------
user_account

RESTART IDENTITY CASCADE;



--=========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
--=========================================================
--
-- Removes all data related to:
-- - Animals
-- - Species and breeds
-- - Ownerships and deliveries
-- - External entities
--
-- Identity sequences are reset automatically.
--=========================================================

TRUNCATE TABLE

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
delivery_employee,

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
concession,
delivery,
ownership,

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
animal,
breed,
species,
external_entity

RESTART IDENTITY CASCADE;



--=========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
--=========================================================
--
-- Removes all data related to:
-- - Products and families
-- - Purchases and invoices
-- - Stock management
-- - product returns
--
-- Identity sequences are reset automatically.
--=========================================================

TRUNCATE TABLE

-----------------------------------------------------------
-- Transaction line entities
-----------------------------------------------------------
invoice_line,
purchase_line,

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
employee_purchase,
employee_return,
purchase_product,
return_product,

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
return,
stock,
purchase,

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
product,
invoice,
family

RESTART IDENTITY CASCADE;



--=========================================================
-- MODULE 4 — CLINICAL MANAGEMENT
--=========================================================
--
-- Removes all data related to:
-- - Appointments
-- - Prescriptions
-- - Clinical assessments
-- - Notifications
--
-- Identity sequences are reset automatically.
--=========================================================

TRUNCATE TABLE

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
rel_app_product,
rel_pre_prod,

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
appointment_notification,
prescription,
anamnesis,
overall_assessment,

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
appointment

RESTART IDENTITY CASCADE;



--=========================================================
-- END OF SCRIPT
--=========================================================
--
-- All database data was successfully removed.
-- Identity sequences were reset.
-- Database structure remains intact.
--=========================================================