# TASK GUARDKNEE2 - which commit bowed the rear guard knee out, and the smallest fix (bisect, headless)

Status: OPEN (S467, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/guard_knee_test.gd is red on main since the 2026-11-12 nightly (green 2026-11-11):
`FAIL boxer 0 rear knee stays on the source (-0.0652 v 0.0291)`, boxer 1 -0.0689. The rear knee in pro_idle now sits 6.5 cm
(share of leg) the OTHER way from the source take Box1_M3_Idle (+0.0291). Lead knee is fine.
Suspects (fight3d commits 2026-11-11..12, `git log --since=2026-11-10 --until=2026-11-13 -- scripts/fight3d`):
cddf2815 POWER1 step 1 "the body goes into the punch", 74a910de POWER1 steps 2-4 merge, 2779c313 JOINFIX1, c724c01d BLOCKLOOK2.

## What to do
1. Bisect in your worktree (git bisect, NOT in E:/FightCamp/Lean): good = the last commit of 2026-11-11, bad = main.
   At each step run only guard_knee_test and read the rear `mean=` line. Name the first bad commit and the file + lines.
2. Fix on main's code in the file that commit changed, so the idle guard's rear knee returns within 0.03 of +0.0291
   without undoing that commit's purpose (read its message; e.g. a hip/torso turn meant for punches must not run on the idle).
3. Write docs/GUARDKNEE2_RESULT.md: the bisect table (commit, rear mean), the cause, the fix.

## Pass lines
- guard_knee_test: GUARD_KNEE failures=0.
- REGRESSION each no worse than main today: punch_range_test, hit_frame_test, block_meet_test.

## Contract
OWNS: scripts/fight3d/FightStage.gd, scripts/fight3d/PunchWeight.gd, scripts/fight3d/JoinSmoother.gd, scripts/fight3d/BoxerBuild.gd, docs/GUARDKNEE2_RESULT.md (touch only the one of these the first bad commit changed; if it is another file, stop and report it)
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=
REGRESSION: punch_range_test, hit_frame_test, block_meet_test
VISUAL: yes - Claude checks a guard still on the game camera before merge; you only run headless.
NOT YOURS: tests/ (never change a bar), every other scripts file.
Runs only through `python ops/Tools/godot_slot.py run --who guardknee2 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/guard_knee_test.gd`.
PR body: `RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0` and the regression lines.

## Prior research
tests/guard_knee_test.gd header (S408 measure), tools/knee_plane_probe.gd, docs/NIGHTLY_TRIAGE_S466.md.
## What would a human do?
A boxer's rear knee in guard sits slightly in, loaded, over the foot; it does not bow outward.
## Prefab check
None: our own rig layers.
