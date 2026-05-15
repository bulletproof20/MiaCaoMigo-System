--=========================================================
-- DATABASE CLEANUP SCRIPT
-- Veterinary Clinic Management System
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- This script removes all database objects related to the
-- veterinary clinic management system.
--
-- The cleanup process is organized by functional modules
-- and executed in reverse dependency order to prevent
-- foreign key conflicts.
--
-- The script includes:
-- - Associative tables
-- - Dependent entities
-- - Core entities
-- - Base entities
-- - Custom ENUM types
--
-- CASCADE is used to automatically remove dependent
-- constraints, indexes and relationships.
--
-- Recommended execution order:
-- 1. Run this cleanup script
-- 2. Recreate ENUM types
-- 3. Recreate tables
-- 4. Apply foreign keys
-- 5. Apply triggers and procedures
--
-- DBMS: PostgreSQL
--=========================================================



--=========================================================
-- MODULE 1 — EMPLOYEE MANAGEMENT
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- Removes all entities related to:
-- - Employees
-- - Authentication and access control
-- - Schedules and absences
-- - Professional specialties
-- - Employee permissions and profiles
--
-- Tables are removed in reverse dependency order.
--=========================================================

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
drop table if exists occupies cascade;
drop table if exists have cascade;
drop table if exists expert cascade;

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
drop table if exists assistant cascade;
drop table if exists veterinarian cascade;
drop table if exists schedule cascade;
drop table if exists absence cascade;
drop table if exists clock_in cascade;
drop table if exists setup cascade;
drop table if exists login_record cascade;

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
drop table if exists employee cascade;
drop table if exists client cascade;
drop table if exists profile cascade;
drop table if exists permission cascade;
drop table if exists specialty cascade;

-----------------------------------------------------------
-- Base entity
-----------------------------------------------------------
drop table if exists user_account cascade;



--=========================================================
-- MODULE 2 — ANIMAL MANAGEMENT
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- Removes all entities related to:
-- - Animals and species
-- - Breeds
-- - Ownership and concessions
-- - External entities and deliveries
--
-- Tables are removed in reverse dependency order.
--=========================================================

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
drop table if exists delivery_employee cascade;

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
drop table if exists concession cascade;
drop table if exists delivery cascade;
drop table if exists ownership cascade;

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
drop table if exists animal cascade;
drop table if exists breed cascade;
drop table if exists species cascade;
drop table if exists external_entity cascade;



--=========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- Removes all entities related to:
-- - Product catalog management
-- - Product families
-- - Purchases and invoices
-- - Stock management
-- - Product returns
--
-- Tables are removed in reverse dependency order.
--=========================================================

-----------------------------------------------------------
-- Transaction line entities
-----------------------------------------------------------
drop table if exists purchase_line cascade;
drop table if exists invoice_line cascade;

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
drop table if exists employee_purchase cascade;
drop table if exists employee_return cascade;
drop table if exists purchase_product cascade;
drop table if exists return_product cascade;

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
drop table if exists return cascade;
drop table if exists purchase cascade;
drop table if exists stock cascade;

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
drop table if exists product cascade;
drop table if exists invoice cascade;
drop table if exists family cascade;



--=========================================================
-- MODULE 4 — CLINICAL MANAGEMENT
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- Removes all entities related to:
-- - Appointments
-- - Prescriptions
-- - Clinical assessments
-- - Notifications
-- - Anamneses
--
-- Tables are removed in reverse dependency order.
--=========================================================

-----------------------------------------------------------
-- Associative entities
-----------------------------------------------------------
drop table if exists rel_app_product cascade;
drop table if exists rel_pre_prod cascade;

-----------------------------------------------------------
-- Dependent entities
-----------------------------------------------------------
drop table if exists prescription cascade;
drop table if exists anamnesis cascade;
drop table if exists overall_assessment cascade;
drop table if exists appointment_notification cascade;

-----------------------------------------------------------
-- Core entities
-----------------------------------------------------------
drop table if exists appointment cascade;



--=========================================================
-- CUSTOM TYPES
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
-- Removes all custom ENUM types used by the system.
--=========================================================

drop type if exists appointment_status cascade;
drop type if exists invoice_status cascade;