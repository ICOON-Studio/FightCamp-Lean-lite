# TASK FLOORGAIN1B - blind contract test for TrainingPreview.lived_gain (Arena, cloud)

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into
master, NEVER merge it. Write ONE new file: `Godot/tests/lived_gain_contract_test.gd`. Do NOT read or edit
`Godot/scripts/TrainingPreview.gd` beyond the two constants named below (the test is written from THIS contract, blind).

## Prior research
FLOORGAIN1 (S188): a lived club day's raw gains (DayLap units, about +5 per fresh hour) reached no stat; the fix converts them
through one constant. Training rule of record: research/topics/training_floor.md.

## What would a human do?
Write a pure table test of the documented formula, then prove it can fail by breaking the formula in a copy (mutants).

## Prefab check
N/A - a GDScript SceneTree test, same shape as `Godot/tests/shown_record_test.gd` (read it for the house style: extends
SceneTree, a `_check(ok, message)` helper, prints `... FAILS=<n>`, `quit(1 if failures > 0 else 0)`).

## The contract (the only thing you may rely on)
`const TP := preload("res://scripts/TrainingPreview.gd")`.
`TP.lived_gain(stats: Dictionary, potential: int, raw: Dictionary, coach_rating: float) -> Dictionary` is pure (never writes
its arguments) and returns {stat_key: points}:
1. Each raw key is renamed through `TP.LIVED_STAT_KEYS` ({"hand_speed": "speed", "defence": "defense", "ring_iq": "fight_iq"});
   any other key is used as is.
2. A key whose renamed stat is NOT in `stats` is dropped. A raw value <= 0 is dropped.
3. points = raw * TP.LIVED_GAIN_SCALE * coach_factor * headroom, where
   coach_factor = 0.5 + (coach_rating / 100) * 0.7, and
   headroom = clamp((potential - stats[stat]) / 20, 0.15, 1.0).
4. Two raw keys that rename to the same stat add up.

## Cases the test must cover (each its own _check, with the numbers in the message)
- a fresh stat far below potential (headroom 1.0) at coach 50 and coach 100 (coach factor 0.85 and 1.2);
- headroom in the middle (potential - stat = 10 -> 0.5), at the floor (stat above potential -> 0.15);
- each of the three renames lands on the renamed key and the raw key is absent from the result;
- an unknown stat key and a zero/negative raw value are absent;
- the arguments are unchanged after the call (compare deep copies);
- an empty raw gives {}.
Compare floats with an absolute tolerance of 1e-6. Use the constants by name (TP.LIVED_GAIN_SCALE), never the literal value.
Population line: print the stats/potential/coach used, once.

## Mutants (prove the test can fail) - list each in the PR description with the FAIL count it produced
Make a temporary copy of the function inside your test file ONLY for this proof (or describe the edit), and show the test
fails for: (a) headroom floor 0.15 -> 0.0; (b) coach factor 0.7 -> 0.5; (c) rename map ignored; (d) values summed twice.
Do not commit any mutant.

## Test command (tier: new test file only)
Parse: `python Godot/tools/check_scripts.py Godot/tests/lived_gain_contract_test.gd`
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/lived_gain_contract_test.gd` -> rc 0, `FAILS=0`,
no SCRIPT ERROR line. The test loads no 3D model (CI has no LFS).

## The one trap
Do not preload `res://scripts/GameState.gd` or UI scripts - the test must be pure; GameState compiled before the autoloads
prints SCRIPT ERRORs that fail the runner.
