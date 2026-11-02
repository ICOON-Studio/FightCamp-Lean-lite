# U13 digest — THE CAREER THAT IS INVISIBLE (cursor)

**Shipped:** DevelopmentPanel honours surface on master.

## What landed

- `_honours()` beside `_titles()` routes through `_call("get_athlete_honours", [])`.
- `TitleHonours` preloaded; summary chip drives the standing-frame badge (held /
  interim / retired), with the old `_titles()` chip only when the read is absent.
- Honours section under STANDING & LOYALTY when rows exist: one caps line per row,
  standing obvious at a glance; retired lines print since week and defences but an
  em dash instead of reign length — never zero weeks, never defeat words.
- Empty career: no caption, no lines, no chip.

## Tests

- `development_panel_test.gd`: 24/0 — chip from summary, held/interim/retired
  lines, retired honesty trap, empty state, absent-read titles fallback.
- Focused: `profile_revamp_test.gd` 0 failures, `smoke_test.gd` 0 failures.
- Full suite: **fails=0**.

## Files

- `Godot/scripts/DevelopmentPanel.gd`
- `Godot/tests/development_panel_test.gd` (new)
