-- =========================================================
-- CORE — CUSTOM TYPE COMMENTS
-- Source types: 00_Core/01_Types.sql
-- =========================================================

-- module 1 — employee management

comment on type absence_status is
'absence lifecycle: pending, approved, rejected, cancelled, detected';

-- module 3 — commercial management

comment on type purchase_status is
'purchase lifecycle: pending, received, cancelled';

-- module 4 — appointment management

comment on type appointment_status is
'consultation lifecycle; includes late for derived display';

comment on type invoice_status is
'billing lifecycle for invoice entities';
