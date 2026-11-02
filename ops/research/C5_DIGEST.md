# C5 Digest — TRAINING hub read API

## Delivered

- `GameState.get_training_hub()` returns the complete saved TRAINING projection:
  gym header, roster-ordered fighters, seven dressed days, totals, eight-point
  forecasts, event/bout/camp summaries, flags, station occupancy, and hub counts.
- `GameState.get_training_day()` returns the editor's current assignment,
  verbatim legal/illegal options, and ordered comparable impact rows.
- `GameState.forecast_training_day()` ports the legacy day arithmetic, including
  clearance fallback, recovery equipment/coach context, and per-day fatigue slice.
- `GameState.forecast_training_week()` walks seven days and returns start/end
  values plus start-and-seven-day body/fatigue series.

## Contract notes for R22

- A locked booked-fight day is dressed as `focus: "fight"`, label `FIGHT NIGHT`,
  retains `locked_fight: true`, and has no editor impact choices.
- `unplanned` means every non-fight day is `rest`; recovery counts as planned.
- Station `day_used` and `day_free` are seven-element Monday-through-Sunday arrays.
- Impact rows are ordered `rest`, `recovery`, `bags`, `ring`, `strength`, `cardio`;
  illegal and full options remain in `options` but are excluded from `impacts`.
- `readiness` is minimum body readiness minus current fatigue, clamped to 0–100;
  `condition` is minimum body readiness before the projected week.
- All four APIs are read-only. Forecasts deep-copy the athlete before
  `BodyReadiness.apply_activity`, and the focused test snapshots the whole career
  around every public C5 read.

## Files

- `Godot/scripts/GameState.gd`
- `Godot/tests/training_hub_api_test.gd`
- `research/C5_DIGEST.md`

## Verification

- Parse gate: `2/2`, zero failures.
- Focused C5: `20` checks, zero failures.
- Adjacent Gym hub: pass.
- Smoke: zero failures.
- Full headless suite: `119/119`, zero failures.
