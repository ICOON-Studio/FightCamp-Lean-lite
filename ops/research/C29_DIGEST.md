# C29 DIGEST — THE BLOCKED BELT READ

## Shipped

- Added pure `ChampionshipRead.belt_scale_read(...)` and the thin
  `GameState.get_belt_scale_read(event_id, bout_index)` read-region wrapper.
- The read preserves the booking stamp, resolved state, verbatim
  `title_blocked_by_weight`, division and week, then exposes the direct UI
  mark: `title_bout`, `pending`, `belt_not_on_the_line`, or `none`.
- A blocked row carries one factual `why_line`: who missed, division, week.
  Unstamped remains `pending`; it is never flattened into a negative stamp.
- Championship rows now expose `vacancy_reason` with `source: absent`.

## Honest vacancy gap

`WorldPopulation._vacate_on_the_scale` and R7's move-up `vacate_title` persist
the same `vacated_by`, `vacated_week`, and `title_status` fields. The save has
no vacancy-reason field, so C29 does not infer one from week proximity, the
fight log, or the former holder. M9's `VACANT ON THE SCALE` mark remains
blocked on a follow-up write in Claude's R42 region.

## Verification

- Parse gate: `CHECK total=3 fails=0 autoload_refs=1`.
- `belt_scale_read_test.gd`: 9 checks, 0 failures.
- `belt_scale_test.gd`: 0 failures.
- `championship_read_test.gd`: 8 checks, 0 failures.
- Full `smoke_test.gd`: 0 failures after the concurrent R44 cash expectation
  was updated for its newly added membership income.
