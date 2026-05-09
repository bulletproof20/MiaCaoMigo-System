-- =========================================================
-- comments: procedures - module 3
-- =========================================================
-- metadata documentation for operational routines that move
-- purchases through receipt and stock creation.
-- =========================================================

comment on procedure sp_receive_purchase(integer) is
'marks a purchase as received and projects purchase lines into stock rows';
