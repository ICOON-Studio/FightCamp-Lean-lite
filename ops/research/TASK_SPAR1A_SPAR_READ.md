# TASK SPAR1A - SparRead: the camp spar panel's numbers, folded from the fight log (Arena, cloud)

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into
master, NEVER merge it. Two NEW files only: `Godot/scripts/SparRead.gd` and `Godot/tests/spar_read_test.gd`.

## Why
SPAR1 (operator 2026-10-09: "use that picture in the training ring or camp as final test before the real fight"): fight week ends
with a 2-round spar against the camp's cast partner; a panel beside our 3D ring shows mirrored bars (red = our fighter = side "a",
blue = the partner = side "b"). This task is ONLY the pure read model the panel prints. No UI, no GameState, no engine change.

## Prior research
The fold pattern already exists: `Godot/scripts/FightBroadcast.gd` `round_stats(log, round, side)` (read it - same event shape,
same LANDS rule via `BroadcastRead.gd`, `FightBroadcast.is_jab_technique(id)` decides a jab from the technique catalog).

## What would a human do?
Copy round_stats' event walk, bucket each punch by its shape, sum rounds 1..N, and turn four pairs of numbers into red-vs-blue shares.

## Prefab check
N/A - CompuBox-style counting is what FightBroadcast already does; reuse its helpers by preload, never copy its constants.

## The contract
`extends RefCounted`, statics only, preloads allowed: `res://scripts/FightBroadcast.gd`, `res://scripts/BroadcastRead.gd`.
`static func panel(log: Array, through_round: int) -> Dictionary` returns:
```
{"punches": {"a": ROWS, "b": ROWS}, "knockdowns": {"a": int, "b": int},
 "tug": {"work_rate": float, "accuracy": float, "jabbing": float, "power_shots": float}, "rounds": through_round}
ROWS = {"jab": [landed, thrown], "cross": [l, t], "hook": [l, t], "uppercut": [l, t], "total": [l, t]}
```
- Counted events: Dictionary rows with `type == "action"`, `round` in 1..through_round, actor from `actor` (or `actor_side`) =
  "a" or "b" (exactly as round_stats reads them). Everything else is ignored (grapple rows, other rounds, malformed rows).
- landed = `BroadcastRead.LANDS.has(str(event.contact))`; knockdown = `knockdown` or `flash_knockdown` true.
- Shape of a punch, in this order: `FightBroadcast.is_jab_technique(id)` -> jab; id contains "uppercut" -> uppercut; id contains
  "hook" -> hook; anything else -> cross (straights, overhands, counters). Put the shape words in ONE const.
- total = the sum of the four rows.
- Tug shares are side a's share in 0..1, and exactly 0.5 when both sides are 0:
  work_rate = a.total.thrown / (a + b thrown); jabbing = a.jab.thrown / (a + b jab thrown);
  power_shots = a power landed / (a + b), where power = cross + hook + uppercut landed;
  accuracy = acc_a / (acc_a + acc_b), acc = total landed / total thrown (0 when thrown 0).
- Pure: never writes `log`.

## Test (spar_read_test.gd, house style of Godot/tests/shown_record_test.gd: _check, prints `SPAR_READ_TEST FAILS=<n>`, quit(1|0))
Build small hand-made logs (technique ids from the catalog: boxing_jab, boxing_cross, boxing_lead_hook, boxing_rear_uppercut,
boxing_overhand, boxing_body_hook; contact words: read `BroadcastRead.LANDS` for one that lands and use "miss" style words that
are NOT in it - assert that first). Cover: each shape bucket; landed vs thrown; round 3 rows excluded at through_round 2; grapple
and malformed rows ignored; knockdown counted; every tug at 0.5 on an empty log; a lopsided log gives the expected share (numbers
in the message); the input log unchanged after the call. Then MUTANTS (describe in the PR, do not commit): uppercut checked after
hook (boxing_rear_uppercut has no "hook" - pick an id that proves the order matters, or say none exists), the 0.5 empty rule
removed, round filter `<` instead of `<=`. Each must make the test FAIL - list the FAIL count per mutant.

## Commands (tier: new test file)
`python Godot/tools/check_scripts.py Godot/scripts/SparRead.gd Godot/tests/spar_read_test.gd`
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/spar_read_test.gd` -> rc 0, FAILS=0, no SCRIPT ERROR line.

## The one trap
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). Do not preload GameState or any UI script.
