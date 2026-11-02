# TASK RECOVERY1C_A (S217) - Tale of the Tape rows for Recovery Rate and Cut & Swell Resistance (pure data module + test)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.

## Why
The CEO approved two new boxer readouts (board, "Approve - build it"): RECOVERY RATE (how fast his wind comes back) and
CUT & SWELL RESISTANCE (how easily his face cuts). The pure maths exists on master:
- `Godot/scripts/RecoveryRate.gd`: `band_word(rate) -> String` (POOR <35 / AVERAGE <65 / GOOD <80 / ELITE),
  `scouted(rate, level) -> {"lo","hi","exact","word"}` (level 0 = wide 25-point range, 1 = 10-point range, >= 2 exact),
  `corner_bpm_drop(rate) -> float`.
- `Godot/scripts/CutResistance.gd`: `resistance(scar_level) -> float`, `band_word(resistance)`, `scouted(resistance, level)`.
  Read both files first (they are short) - use their real return keys.
This task builds the DATA the screens draw: one pure module that returns the rows; the screen code only renders them later.

## Do - new file `Godot/scripts/TapeReadoutRows.gd` (`extends RefCounted`; preload ONLY RecoveryRate.gd and CutResistance.gd)
```gdscript
## own = true: the player's own boxer (always exact). own = false: an opponent seen through scouting level 0..3.
static func rows(recovery_rate: float, scar_level: int, scout_level: int, own: bool) -> Array
```
Returns exactly two Dictionaries, in this order:
`{"id": "recovery_rate", "label": "RECOVERY RATE", "value_text": String, "word": String, "fill": float, "lo": float, "hi": float,
  "exact": bool, "detail": String}` and the same keys with id "cut_resistance", label "CUT & SWELL RESISTANCE".
- `own` -> treat as exact (use scouted(..., 3)). Otherwise scouted(..., scout_level).
- `value_text`: exact -> the integer ("72"); a range -> "60-70" (integers, hyphen, no spaces).
- `word`: from the module's scouted()["word"].
- `fill`: the bar fill 0..1 = midpoint of lo..hi / 100.
- `detail`: recovery -> "Corner: about -<N> bpm in 60 s" with N = round(RecoveryRate.corner_bpm_drop(midpoint)) (exact only;
  a range shows "Corner recovery: scout him to know"); cut -> exact: "Scar tissue: <none|light|heavy>" from scar_level 0 / 1-2 / 3+;
  a range: "Cut risk: scout him to know".
- NaN/inf inputs never crash (they become the modules' own neutral values).

## Test - new `Godot/tests/tape_readout_rows_test.gd` (extends SceneTree; prints `TAPE_READOUT_ROWS_TEST PASS (<n> checks)` or
FAIL lines; quit(0/1)). Blind, from this contract:
1. own=true, rate 72, scar 0 -> two rows, ids/labels/order exact, value_text "72" and "100" (check against CutResistance.resistance(0)),
   exact true, detail strings as specified.
2. own=false at levels 0, 1, 2: value_text is a range for 0 and 1, exact for >= 2; lo <= true value <= hi at every level for
   rates 0..100 step 1 and scar levels 0..5 (the range always contains the truth).
3. fill in [0,1] everywhere; word equals the module's own scouted word.
4. NaN rate / negative scar level -> no crash, still two rows.
5. A mutant check inside the test: a version that ignores `own` would show a range for own=true - assert it does not.
At least 80 checks.

## Run (CI has Godot; pure, no LFS)
`python Godot/tools/check_scripts.py Godot/scripts/TapeReadoutRows.gd Godot/tests/tape_readout_rows_test.gd`
`godot --headless --path Godot --script tests/tape_readout_rows_test.gd`, and the existing `tests/recovery_rate_test.gd`,
`tests/cut_resistance_test.gd` stay PASS.

## Owned files
Godot/scripts/TapeReadoutRows.gd (new), Godot/tests/tape_readout_rows_test.gd (new). Touch nothing else.

## The one trap
Read RecoveryRate.gd / CutResistance.gd before coding - do not guess their function names or keys. `round()` returns float;
cast with `int()`. Never delete or loosen a test to go green; Claude reads the CI log.
