# TASK KNEESWEEP1 - which knee-solve setting moves the rear knee onto the take? (a sweep; measure only, headless)

Status: OPEN (S473, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/guard_knee_test.gd is red: the rear knee's mean sits at -0.031 (boxer 0) against the source take's +0.029 (bar 0.03).
S472-S473 ruled out the stance (S472), the crouch depth (BoxerFootworkRig DROP: straighter legs move it further away,
-0.031 -> -0.044) and a sideways hip shift (both directions worse) - docs/PELVIS1_RESULT.md, last sections. What is left is
the knee solve itself: scripts/fight3d/BoxerFootworkRig.gd KNEE_TURN_DEG (45, line ~22) and REAR_BAND_DEG (18, line ~35),
and scripts/fight3d/KneeTrack.gd ALLOW_DEG (20), BENT_DEG (15), STRAIGHT_DEG (5).

## What to do (measure only - leave every number as main has it at the end)
In YOUR worktree only, for each setting below change ONE constant, run tests/guard_knee_test.gd and
tests/boxer_footwork_test.gd, record the lines, then put the constant back before the next:
- KNEE_TURN_DEG: 15, 30, 45 (main), 60
- REAR_BAND_DEG: 10, 18 (main), 26
- KneeTrack ALLOW_DEG: 10, 20 (main), 35
- KneeTrack BENT_DEG: 10, 15 (main), 25
For every run record: GUARD_KNEE boxer 0 and 1, lead and rear mean; GUARD_KNEE failures; BOXER_FOOTWORK failures.
Write docs/KNEESWEEP1_RESULT.md: one table (setting, value, b0 rear, b1 rear, b0 lead, b1 lead, guard_knee failures,
footwork failures), then ONE paragraph: which single setting moves the rear knee toward +0.029 the most WITHOUT turning
boxer_footwork red, and by how much. If none moves it, say so plainly. Commit only the doc; `git diff -- scripts` must be
empty at the end.

## Pass lines
- 13 runs in the table (4 + 3 + 3 + 3, main's values counted once each family).
- RESULT: docs/KNEESWEEP1_RESULT.md -> KNEESWEEP runs=13

## Contract
OWNS: docs/KNEESWEEP1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures= (stays as main: measure only)
REGRESSION: guard_knee_test (unchanged from main), boxer_footwork_test (BOXER_FOOTWORK failures=0)
VISUAL: no
NOT YOURS: no script change is committed - scripts/fight3d/* are edited only for a run and put back.
Runs only through `python ops/Tools/godot_slot.py run --who kneesweep1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/guard_knee_test.gd`
(same for boxer_footwork_test). Never the _console exe, never a window, never wrapped in `timeout`. One run at a time.

## Prior research
docs/PELVIS1_RESULT.md (the hips, crouch and hip-shift results), tools/stance_raw.py (the take's knee: rear 17.8 deg inside
the toes), ops/research/KNEEPLANE_S408.md, tests/guard_knee_test.gd header (how the knee is read).
## What would a human do?
Turn each knob one at a time and watch the one needle, before choosing which knob to fix.
## Prefab check
None: our own rig.
