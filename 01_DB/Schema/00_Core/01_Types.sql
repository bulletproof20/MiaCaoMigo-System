-- =========================================================
-- DATABASE CUSTOM TYPES
-- File: 00_Core/01_Types.sql
-- =========================================================
--
-- DESCRIPTION
-- Single catalog of ENUM types for workflow and lifecycle fields.
-- Prefer these types over VARCHAR + CHECK (…) for stable value sets.
--
-- PURPOSE
-- One vocabulary per domain; align API and SQL literals.
--
-- LOAD ORDER
-- After 03_Loaders/00_Extensions.sql, before 01_Structure.sql
-- (any 00_Tables_Mod*.sql that references these types).
--
-- DBMS: PostgreSQL
-- =========================================================



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
