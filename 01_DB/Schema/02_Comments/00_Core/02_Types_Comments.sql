--=========================================================
-- metadata: centralized custom types (00_Core/02_Types.sql)
--=========================================================

-- module 1 — employee management

comment on type absence_status is
'absence approval workflow states; replaces legacy ck_sta_abs check constraint';

-- module 3 — commercial management

comment on type purchase_status is
'purchase reception workflow states; replaces legacy ck_sta_pur check constraint';

-- module 4 — appointment management

comment on type appointment_status is
'consultation lifecycle states; includes late for derived client-portal display';

comment on type invoice_status is
'billing workflow states for invoice entities';
