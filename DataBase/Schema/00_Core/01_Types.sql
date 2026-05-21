-- =========================================================
-- CORE TYPES
-- FILE: Schema/00_Core/01_Types.sql
-- =========================================================
-- PURPOSE:   Shared ENUM types (workflow statuses)
-- DOMAIN:    Core
-- LOADED BY: Bootstrap/Profiles/init_core.sql (before 01_Structure)
-- CLEANUP:   inline DROP TYPE then CREATE
-- =========================================================

-- --- CLEANUP: ENUM types (reverse dependency handled by CASCADE) ---
-- removes previous enum definitions before recreation
--
-- Types are removed after dependent tables to prevent
-- dependency conflicts during database cleanup.
--
-- CASCADE automatically removes any remaining dependent
-- objects and constraints.
--
-- RECOMMENDED EXECUTION ORDER
-- --------------------------------------------------------
-- 1. Drop foreign keys and dependent tables
-- 2. Run this script
-- 3. Recreate custom types
-- 4. Recreate tables and relationships
--
-- DBMS: PostgreSQL
--=========================================================



--=========================================================
-- MODULE 1 — EMPLOYEE MANAGEMENT
--=========================================================
-- Absence approval and detection workflow states.

drop type if exists absence_status cascade;



--=========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
--=========================================================
-- Purchase and invoice lifecycle workflow states.

drop type if exists purchase_status cascade;
drop type if exists invoice_status cascade;



--=========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
--=========================================================
-- Consultation scheduling lifecycle states.

drop type if exists appointment_status cascade;

-- --- CREATE: shared ENUM types ---
-- central catalog of workflow status values used by module tables

-- DESCRIPTION
-- Central catalog of PostgreSQL ENUM types used for workflow
-- and lifecycle status fields across all modules.
--
-- Status validation is enforced at the type level instead of
-- per-table CHECK constraints, ensuring:
-- - consistent vocabulary across modules;
-- - single source of truth for allowed values;
-- - safer refactors and API alignment.
--
-- LOAD ORDER
-- --------------------------------------------------------
-- This script must run after extensions and before any
-- 00_Tables_ModX.sql file that references these types.
-- 
-- DBMS: PostgreSQL
--=========================================================



--=========================================================
-- MODULE 1 — EMPLOYEE MANAGEMENT
--=========================================================
-- Absence approval and detection workflow states.

create type absence_status as enum (
    'pending',
    'approved',
    'rejected',
    'cancelled',
    'detected'
);



--=========================================================
-- MODULE 3 — COMMERCIAL MANAGEMENT
--=========================================================
-- Purchase order reception workflow states.

create type purchase_status as enum (
    'pending',
    'received',
    'cancelled'
);

create type invoice_status as enum (
    'pending',
    'paid',
    'overdue',
    'cancelled'
);


--=========================================================
-- MODULE 4 — APPOINTMENT MANAGEMENT
--=========================================================
-- Consultation scheduling lifecycle and billing status.

create type appointment_status as enum (
    'scheduled',
    'in_progress',
    'completed',
    'cancelled',
    'no_show',
    'late'
);

