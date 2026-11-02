# U17 digest — THE GRAND PRIX BLOCK THAT EATS THE FIGHT LOG (cursor)

**Branch:** `master` (pushed directly).

## What landed

- `GP_BLOCK_H := 132.0` — fixed frame budget when `grand_prix_titles` is non-empty. The 8px spacer after the frame stays separate from the frame height.
- Frame title carries the true count: `GRAND PRIX  ·  N WIN(S)`.
- `_fill_grand_prix` derives visible rows from `b.size.y` (same contract as `_fill_log`); newest first, capped.
- Empty/absent still draw no frame; `row2_y` unchanged at `arc_h + 8.0`.

## Tests

- Parse gate: `check_scripts.py` 2/0.
- `profile_revamp_test.gd`: 0 failures (U16 green + U17: 20 titles keep log/numbers bodies alive, capped rows, header says 20, two-title case unchanged).
- `smoke_test.gd`: 0 failures.
- Full suite: **187/0**.

## Files

- `Godot/scripts/ProfileRevampPanel.gd`
- `Godot/tests/profile_revamp_test.gd`

Please write the HANDOFF COMPLETE block from this digest.
