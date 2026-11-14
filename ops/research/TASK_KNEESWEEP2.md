# TASK KNEESWEEP2 - rear foot at the take's 45 deg: which knee setting puts the rear knee inside BOTH bars? (sweep, measure only)

Status: OPEN (S474, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
docs/KNEESWEEP1_RESULT.md (read the S474 follow-up at its end): turning the rear toes to the take's 45 deg
(scripts/fight3d/BoxerFootwork.gd REAR_YAW_DEG -32 -> -45) moves the rear knee half way to the take with footwork green;
adding KNEE_TURN_DEG 15 or REAR_BAND_DEG 26 (scripts/fight3d/BoxerFootworkRig.gd) passes guard_knee's mean but breaks the
rear valgus bar (24-25 deg, bar 20). The answer is likely between: find it.

## What to do (measure only - every number back to main at the end)
In YOUR worktree, set REAR_YAW_DEG to -45.0 for every run, then one at a time:
- KNEE_TURN_DEG: 20, 25, 30, 35, 40 (REAR_BAND 18)
- REAR_BAND_DEG: 20, 22, 24 (KNEE_TURN 45)
- REAR_YAW_DEG -50 alone (KNEE_TURN 45, REAR_BAND 18)
For every run record from tests/guard_knee_test.gd: boxer 0 and 1 rear mean, lead mean, guard frames, GUARD_KNEE failures;
from tests/boxer_footwork_test.gd: worst rear valgus per boxer and BOXER_FOOTWORK failures.
Write docs/KNEESWEEP2_RESULT.md: one table (setting, value, b0 rear, b1 rear, b0 lead, b1 lead, frames b0/b1, guard_knee
failures, worst rear valgus, footwork failures), then ONE paragraph: which setting (if any) has rear means within 0.03 of
+0.0291 AND footwork 0 failures. If none, the closest and by how much. Commit only the doc; `git diff -- scripts` must be empty.

## Pass lines
RESULT: docs/KNEESWEEP2_RESULT.md -> KNEESWEEP2 runs=9

## Contract
OWNS: docs/KNEESWEEP2_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures= (stays as main: measure only)
REGRESSION: guard_knee_test (unchanged from main), boxer_footwork_test (BOXER_FOOTWORK failures=0 on main)
VISUAL: no
NOT YOURS: no script change is committed - scripts/fight3d/* are edited only for a run and put back.
Runs only through `python ops/Tools/godot_slot.py run --who kneesweep2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/guard_knee_test.gd`
(same for boxer_footwork_test; add `-- verbose` after the script only if you need per-frame lines). Never the _console exe,
never a window, never wrapped in `timeout`. One run at a time.

## Prior research
docs/KNEESWEEP1_RESULT.md (both sweeps), docs/PELVIS1_RESULT.md (take: rear toe yaw -45.4 deg), tools/stance_raw.py,
tests/guard_knee_test.gd and tests/boxer_footwork_test.gd headers (how each ruler reads the knee).
## What would a human do?
Put the foot where the take has it first, then nudge the knee until both the side view and the front view agree.
## Prefab check
None: our own rig.
