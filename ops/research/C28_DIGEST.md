# C28 DIGEST — THE ATHLETE'S PURSE READ

## Shipped

- Added pure `AthletePurseRead.build(career, athlete_id)` and the thin
  `GameState.get_athlete_purse_read(athlete_id)` read-region wrapper.
- The read exposes `wallet_now`, `career_earnings`, and athlete-filtered bout
  rows newest first without mutating or reconstructing Career state.
- Each bout carries four `gross_lines`, three `deduction_lines`, and one
  `wallet_credit` line. Every line has `amount`, `source`, and `why`.
- Signed purse/bonus values are `evidenced`; uncovered travel and
  accommodation is honestly named and `invented`; keys absent from old rows
  remain present as `absent` zeroes. A never-collectible manager share is also
  a present `absent` zero line.
- `title_blocked_by_weight` passes through only for `winner_missed` or
  `both_missed`; untouched and older bouts gain no synthetic title state.
- No settlement code, money arithmetic, contract code, billing code, or UI
  was changed.

## Compatibility

- Reads both a future explicit `show_purse` and the existing settlement
  `purse` key.
- Reads a named `logistics_debit` (or `uncovered_travel_accommodation`) and
  retains the legacy stored `expenses` value behind the honest public label.
- Reads an explicitly saved wallet result from `wallet_credit`, `athlete_net`,
  `athlete_landed`, `paid`, or `net`; otherwise the line is `absent` rather
  than recomputed.

## Verification

- Parse gate: `CHECK total=3 fails=0 autoload_refs=1`.
- `athlete_purse_read_test.gd`: 20 checks, 0 failures.
- `gym_ledger_read_test.gd`: 15 checks, 0 failures.
- `fight_log_test.gd`: 0 failures.
- Full `smoke_test.gd`: 0 failures.
