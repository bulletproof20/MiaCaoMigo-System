-- =========================================================
-- comments: services — module 3 (commercial management)
-- =========================================================

-- session reads
comment on function is_user_logged_in(integer) is
'True when login_record has an open successful session for id_usr (no performs bridge).';

comment on function get_active_sessions() is
'Lists open successful sessions with user name and login metadata.';

comment on function get_last_login(integer) is
'Most recent login_record row for the user regardless of outcome.';

comment on function get_last_successful_login(integer) is
'Most recent successful login_record for the user.';

comment on function get_last_failed_login(integer) is
'Most recent failed login_record for the user.';

comment on function get_user_credentials(integer) is
'Returns email and password hash for active employee or client channel (auth integration).';

-- inventory reads
comment on function fn_list_product_stock_levels() is
'Full catalog read from vw_product_stock_levels ordered by product name.';

comment on function fn_list_products_to_reorder() is
'Reorder candidates from vw_products_to_reorder (at or below minimum stock).';

comment on function fn_get_product_stock_level(integer) is
'Single product row from vw_product_stock_levels.';

-- commercial writes
comment on function fn_receive_purchase(integer) is
'Application wrapper for sp_receive_purchase (marks purchase received and materializes stock).';

comment on function fn_check_restock_needs() is
'Application wrapper for sp_check_restock_needs (notices when vw_products_to_reorder is non-empty).';
