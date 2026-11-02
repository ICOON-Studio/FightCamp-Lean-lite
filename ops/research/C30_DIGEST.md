# C30 — The Bout That Can Be Read Again

`BoutRead.gd` captures raw filed cards plus the range aggregates that disappear
with the live log. Judge totals and decision presentation are rebuilt on read;
the full event log is never saved.

Both watched settlement branches stamp a copy-safe `bout_read` on the recorded
row. `get_bout_read(athlete_id, bout_index)` reads athlete history newest first,
keeps legacy rows and logless range evidence explicitly `absent`, and carries a
saved `title_blocked_by_weight` unchanged.

Verification: parse 3/3; C30 11/11; C23 16/16; C25 9/9; C28 20/20;
`fight_log_test.gd` green; full suite 147/147.
