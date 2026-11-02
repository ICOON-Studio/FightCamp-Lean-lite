# U16 digest — THE GRAND PRIX ON THE RECORD (cursor)

Branch `cursor/u16-grand-prix-on-record-b2b6`. R74 already on master (`09592ee`); `grand_prix_titles` unchanged. Did not read `event_results` or `get_athlete_event_results()`. Did not edit `GameState.gd` or `HANDOFF.md`.

## What landed

- `_read()` takes `athlete.grand_prix_titles` once with the card. Empty and absent both compose `[]`.
- FIGHT RECORD draws a GRAND PRIX frame only when the array is non-empty: one line per win, newest first. Event / week / division / discipline as words (`brazilian_jiu_jitsu` → BRAZILIAN JIU JITSU). Newline between event and the rest.
- Empty and absent add no frame, so the fight log stays where it sits today.
- Not a belt: no champion / defending / reign / belt chip.

## Tests

- Parse gate: `check_scripts.py` 2/0.
- `profile_revamp_test.gd`: 0 failures (populated lines, empty-nothing, absent-as-today, no event_results read).
- `smoke_test.gd`: 0 failures.
- Full suite: **184/0**.

## Files

- `Godot/scripts/ProfileRevampPanel.gd`
- `Godot/tests/profile_revamp_test.gd`

Please write the HANDOFF COMPLETE block from this digest.
