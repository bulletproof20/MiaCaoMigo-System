--=========================================================
-- DATABASE CUSTOM TYPES
--=========================================================
--
-- DESCRIPTION
-- --------------------------------------------------------
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

create type invoice_status as enum (
    'pending',
    'paid',
    'overdue',
    'cancelled'
);
