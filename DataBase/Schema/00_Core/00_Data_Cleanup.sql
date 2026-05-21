-- =========================================================
-- CORE — LOGICAL DATA RESET
-- FILE: Schema/00_Core/00_Data_Cleanup.sql
-- =========================================================
--
-- PURPOSE
--   TRUNCATE application data and RESTART IDENTITY sequences.
--   Preserves schema objects (tables, constraints, triggers, functions).
--
-- DOMAIN
--   Cross-module data reset (Modules 1–4).
--
-- INVOKED BY
--   Bootstrap/Loaders/11_MasterData.sql (before MasterData inserts).
--
-- NOT FOR
--   Structural DROP (handled inline in Schema module DDL files).
--
-- WARNING
--   Permanently deletes all row data. Use only for seed regeneration.
-- =========================================================

set timezone to 'Europe/Lisbon';

-- =========================================================
-- MODULE 1 — user management data
-- =========================================================
-- clears authentication, RBAC, attendance, and identity rows

truncate table
    have,
    occupies,
    expert,
    schedule,
    absence,
    clock_in,
    setup,
    login_record,
    assistant,
    veterinarian,
    client,
    employee,
    profile,
    permission,
    specialty,
    user_account
restart identity cascade;

-- =========================================================
-- MODULE 2 — animal management data
-- =========================================================
-- clears animals, taxonomy, ownership, and delivery rows

truncate table
    delivery_employee,
    concession,
    delivery,
    ownership,
    animal,
    breed,
    species,
    external_entity
restart identity cascade;

-- =========================================================
-- MODULE 3 — commercial management data
-- =========================================================
-- clears catalog, stock, purchases, invoices, and returns

truncate table
    invoice_line,
    purchase_line,
    employee_purchase,
    employee_return,
    purchase_product,
    return_product,
    return,
    stock,
    purchase,
    product,
    invoice,
    family
restart identity cascade;

-- =========================================================
-- MODULE 4 — appointment management data
-- =========================================================
-- clears clinical visits, prescriptions, and notifications

truncate table
    rel_app_product,
    rel_pre_prod,
    appointment_notification,
    prescription,
    anamnesis,
    overall_assessment,
    appointment
restart identity cascade;
