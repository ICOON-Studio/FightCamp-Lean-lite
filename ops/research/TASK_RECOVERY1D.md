# TASK RECOVERY1D (S217) - every boxer gets his own Recovery Rate (pure accessor + blind test)

Model: Goose (cloud, label `goose`, Qwen Token Plan). Branch `goose/issue-<n>` from master. Never master.

## Why
Operator approved Ludo r49 (board Q-S212-7, "Approve - build it"): every boxer has a RECOVERY RATE 0-100 (50 = average).
`Godot/scripts/RecoveryRate.gd` (on master) has `static func generate(conditioning, age_years, personal) -> float` (5..95).
Athletes in saves do not carry a `recovery_rate` key yet, and creation code is spread over a 19,876-line GameState.gd.
So the game reads the rate through ONE accessor that returns the stored value or derives a stable one.

## Do
In `Godot/scripts/RecoveryRate.gd` add (do not change any existing function):
```gdscript
## S217 RECOVERY1D: the one place the game reads a boxer's Recovery Rate.
static func for_athlete(athlete: Dictionary) -> float
```
- If `athlete` has a numeric `recovery_rate` -> return it clamped to [0, 100] (NaN/inf -> NEUTRAL).
- Else derive: `conditioning` = `athlete["stats"]["conditioning"]` (missing -> 50), `age` = `athlete["age"]` (missing -> 26),
  `personal` = a value in [-1, 1] that is a pure deterministic function of `str(athlete.get("athlete_id", athlete.get("id", "")))`
  (e.g. `float(posmod(id.hash(), 2001) - 1000) / 1000.0`; empty id -> 0.0). Return `generate(conditioning, age, personal)`.
- No preloads beyond what RecoveryRate.gd already has; no autoloads; no randomness (no randi/randf/RandomNumberGenerator).

New test `Godot/tests/recovery_rate_athlete_test.gd` (extends SceneTree, prints `RECOVERY_RATE_ATHLETE_TEST PASS (<n> checks)` or
FAIL lines, quits 0/1), written from THIS contract:
1. Stored value wins: `{"recovery_rate": 73.0}` -> 73.0; 140 -> 100; -5 -> 0; NAN -> 50.
2. Determinism: the same athlete dict -> the same value on repeated calls; two ids -> values differ for at least 90 of 100
   generated ids (different people differ).
3. Direction: same id and age, conditioning 80 vs 30 -> higher with 80. Same id and conditioning, age 24 vs 36 -> not higher at 36.
4. Bounds: 500 generated athletes (ids "ath_0".."ath_499", conditioning 0..100, age 18..40) -> every value in [5, 95];
   mean of the conditioning-50 / age-26 subset within 50 ± 8 (average man near average).
5. Missing keys: `{}` -> a finite value in [5, 95].
6. A mutant check: inside the test, recompute one value with `personal` forced to 0 and show it differs from the real one for
   some id (proves the id actually feeds the result).

## Run (CI image has Godot; no LFS needed - pure)
`python Godot/tools/check_scripts.py Godot/scripts/RecoveryRate.gd Godot/tests/recovery_rate_athlete_test.gd`
`godot --headless --path Godot --script tests/recovery_rate_athlete_test.gd` and the existing `tests/recovery_rate_test.gd`
(must stay PASS, 1433 checks).

## Owned files
- Godot/scripts/RecoveryRate.gd (add `for_athlete` only)
- Godot/tests/recovery_rate_athlete_test.gd (new)

## Prior research
TASK_RECOVERY1A.md (RecoveryRate contract), LUDO_ROUND49_VERDICT_S216.md (why Recovery Rate exists), TASK_RECOVERY1B.md
(the fight reads `recovery_rate`; Claude swaps it to `for_athlete` after both merge).

## What would a human do?
Read the value where it is stored, and derive a stable one from what the save already knows when it is not - no migration pass.

## Prefab check
None - internal stat.

## The one trap
Never delete or loosen a test to go green; the CI log is read by Claude. GDScript: `posmod` for a non-negative modulo; `:=` on a
Variant from a Dictionary needs an explicit type (see research/GDSCRIPT_TRAPS.md).
