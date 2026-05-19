-- =========================================================
-- comments: indexes - module 1
-- =========================================================

comment on index uq_login_single_active_session_email is
'partial unique: one active successful login session per email (ema_log)';

comment on index uq_employee_active_per_user is
'partial unique: one active employee row per user_account';

comment on index uq_clock_in_active_per_employee is
'partial unique: one open clock-in row per employee';

comment on constraint ex_schedule_overlap on schedule is
'gist exclusion: non-overlapping shift intervals per employee and weekday';

comment on index ix_absence_id_emp is
'b-tree: absence lookups and overlap validation by employee';

comment on index ix_absence_pending_expiry is
'partial b-tree: pending absences filtered by end_dat_tim_abs for daily cancellation job';

comment on index ix_clock_in_open_by_start is
'partial b-tree: open clock-in rows ordered by start time for midnight auto-close job';
