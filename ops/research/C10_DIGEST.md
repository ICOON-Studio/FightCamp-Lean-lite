# C10 — Coach assignment write

## Delivered

- Added persistent optional `athlete["coach_id"]`, with no read-time save
  migration: older saves without the key remain explicitly unassigned.
- Added `assign_coach()` and `clear_coach()` with atomic save rollback,
  exact failure reasons, and per-coach capacity enforcement.
- `_corner_coach_id()` now prefers a valid explicit assignment, then preserves
  the former training-coach and best-teacher fallback behavior.
- Added `release_coach()` and shared cleanup so a staff departure removes all
  affected `coach_id` values before it is saved.
- C9's Staff projection now exposes real `assigned_fighters`, total assigned
  capacity use, and pair-level assignment availability using the same rule as
  `assign_coach()`.

Training credit and rapport growth deliberately remain tied to the existing
training-session logic. Making them follow the explicit corner assignment is
a balance change and was not made in C10.

`office_hub_api_test.gd` received one necessary compatibility assertion update:
it no longer expects all pairs to be blocked by the pre-C10 placeholder, while
the new C10 contract test verifies real pair/write agreement.

## Verification

- Parse gate: `CHECK total=3 fails=0 autoload_refs=1`
- Focused C10 test: `20 checks, 0 failures`
- C9 office API: `21 checks, 0 failures`
- Training gain: `2 checks, 0 failures`
- Coach rapport: `0 failures`
- Smoke: `failures=0`
- Full headless suite: completed with no failing test exit.
