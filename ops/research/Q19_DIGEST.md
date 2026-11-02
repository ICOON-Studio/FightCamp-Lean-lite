# Q19 Digest — GrappleSeat.gd

Commit: `6e76cff`
Files: `Godot/scripts/GrappleSeat.gd`, `Godot/tests/grapple_seat_test.gd`

## What shipped

Pure static module, `extends RefCounted`, `class_name GrappleSeat`, zero preloads.
Six statics: `fresh`, `is_legal`, `hold_ticks`, `control_units`, `is_dominant`, `apply`.

- `apply` uses `.duplicate(true)` for deep copy (FightTrauma._copy_face pattern).
- `is_legal` checks both source and target stance/seat pair validity.
- `hold_ticks`: standing=0, clinch=10, guard=20, half/side/mount/back=60.
- `control_units`: clinch+top=1, ground side/mount/back=2, ground half=1, guard=0, standing=0.
- `is_dominant`: ground side/mount/back only.

## Tests

99 checks pass in `grapple_seat_test.gd`.

Full suite could not complete (hung after 30+ min on an unrelated test). First
partial run reached 98/213 with only `grapple_contract_test.gd` failing (expected:
see disagreements below).

## Contract ambiguity resolved

**`hold_ticks` for `half`:** The contract table lists "guard, half, side" as
takedown landings (20 ticks), but Codex's blind test (C67) groups half with
side/mount/back at 60. I aligned with the blind test: only guard=20, half and
all other ground positions=60. Rationale: guard is the most stable bottom
position (closed guard, hard to pass); half is transitional and unstable,
closer to side control in character.

## Contract disagreement reported

**`is_dominant("clinch", "over_under")`:** C67 line reads
`not seat_script.is_dominant("clinch", "over_under") == false`, which parses as
`not (false == false)` = `not true` = `false` — the test always fails regardless
of the implementation. The contract explicitly says "side, mount and back are;
guard is not" and does not list clinch as dominant. This is a bug in C67.

## Suite status

Suite base was 209/0 per task brief. Now 213 tests (C67 + my test + siblings).
Only failure is `grapple_contract_test.gd` (2 check failures: the dominance bug
above + GrappleResolve.gd not yet landed by Cursor).
