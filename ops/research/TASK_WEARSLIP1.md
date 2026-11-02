# TASK WEARSLIP1 - a worn boxer must slip FEWER punches in the game arm (today he slips more)

Model: Goose (cloud, long task). Discipline: BOXING (demo).
Measured S279 by Claude on master 4f4e7f73, PC: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/bout_wear_wire_test.gd -- as_game`
-> `FAIL the worn man slips fewer punches (225 -> 232)`; plain arm green. The wear itself is seated (same test: worn evasion = fresh
x 0.88, chin x 0.91, accuracy x 0.925 - those checks pass as_game), so the game-arm fight path does not read evasion when it decides a
slip - or reads it from a copy taken before wear. Game arm = S271 rokoko_clips + S274 clips_only_base (GameSwitches.gd CLIPS_ONLY_OFF).

## Do
1. Trace where a slip is decided in the as_game bout (FightRealtime.gd - grep `slip`, `evasion`; never read it whole) and which
   fighter dict it reads; compare with the plain arm's route. Name file:line in the PR body.
2. Fix the GAME (smallest change) so the worn man's evasion drives his slips in both arms. Never loosen the test.
3. bout_wear_wire_test green in BOTH arms; attribute_wire_test and mastery_wire_test stay green.

## Contract
OWNS: Godot/scripts/FightRealtime.gd, Godot/tests/bout_wear_wire_test.gd
RED_TEST: Godot/tests/bout_wear_wire_test.gd -> as_game arm green
REGRESSION: attribute_wire_test, mastery_wire_test
VISUAL: no

## Prior research
S251 digest (FIGHTLINK 1b wear into the bout), Godot/scripts/rules/BoutWear.gd, S274 digest (clips_only_base), GDSCRIPT_TRAPS.md.

## What would a human do?
Print the slipping man's evasion at the moment a slip is rolled, fresh vs worn, in both arms - the arm where it does not change is the bug.

## Prefab check
None - our engine.

## The one trap
FightRealtime.gd is huge: grep + `sed -n` windows only. A same-seed run is deterministic; compare the two arms on one seed first.

## Output
PR from goose/issue-<n> with `RESULT: tests/bout_wear_wire_test.gd -> PASS` both arms + the regression lines.
