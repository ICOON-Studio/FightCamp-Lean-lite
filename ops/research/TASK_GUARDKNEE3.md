# TASK GUARDKNEE3 - the rear guard knee back on the source take WITH the footwork rig on (headless)

Status: OPEN (S469, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/guard_knee_test.gd is red on main: the rear knee in pro_idle reads -0.065 (share of leg, + = towards her midline)
against the source take's +0.0291; the lead knee is fine. GUARDKNEE2 (your bisect, docs/GUARDKNEE2_RESULT.md on branch
qwen/guardknee2, PR 275) found the first bad commit: 79665239 "HUMANFIGHT1 collected by diff" - the footwork rig
(scripts/fight3d/BoxerFootworkRig.gd) became the default, and its hip offset from `plan.pose()` bows the rear knee out.
GUARDKNEE2's fix was NOT merged: it set the rig's `want` and `w` to 0 while pro_idle plays. That switches the whole rig
off in her guard (the rig IS her stance, bounce and steps there), snaps its weight instead of easing it, and added 3
block_meet_test failures because the standing gap moved 1-3 cm.

## What to do
Keep the rig fully on in pro_idle. Make the rear knee's bend plane follow the source take while the rig moves the hips:
1. Measure first (print, do not guess): in pro_idle with the rig on, the rear leg's hip, knee and ankle before and after
   `BoxerFootworkRig` (its `early()` hips move, then its leg solve in `_process_modification`), and the knee's out-of-plane
   value as tools/knee_plane_probe.gd reads it. Say which step bows the knee: the hips moving sideways over a planted
   foot (the leg solve keeping an old pole), or the leg solve's own pole direction.
2. Fix it in BoxerFootworkRig.gd's leg solve: the knee's pole comes from the CLIP's pose of that leg (the bend plane the
   source take has before the rig moves the hips), carried onto the moved hip-ankle line - not from the rig's own
   default direction. Ease, never snap. Lead knee and both feet stay where they are.
3. Write docs/GUARDKNEE3_RESULT.md: the measured table (step, rear knee value), the cause in two lines, the fix.

## Pass lines
- guard_knee_test: `GUARD_KNEE failures=0` (rear mean within 0.03 of +0.0291, both boxers).
- REGRESSION, each no worse than main on the same day (run main's number yourself first and print both):
  block_meet_test, hit_frame_test, punch_range_test, foot_plant_test if it exists.

## Contract
OWNS: scripts/fight3d/BoxerFootworkRig.gd (currently under 500 lines: keep it under 500), docs/GUARDKNEE3_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=
REGRESSION: block_meet_test, hit_frame_test, punch_range_test
VISUAL: yes - Claude checks a guard still on the game camera before merge; you only run headless.
NOT YOURS: tests/ (never change a bar), FightStage.gd, RingFeet.gd, KneeTrack.gd, FootPlant.gd, every other file. If the
cause turns out to be in one of those, STOP and report it in the result doc instead of editing it.
Runs only through `python ops/Tools/godot_slot.py run --who guardknee3 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/guard_knee_test.gd`
(never the _console exe, never a window). Tests are the OFF control arm; do not add opt-in flags.
PR body: `RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0` and one line per regression test (main's number, yours).

## Prior research
docs/GUARDKNEE2_RESULT.md (branch qwen/guardknee2), tests/guard_knee_test.gd header (S408 measure),
tools/knee_plane_probe.gd, scripts/fight3d/KneeTrack.gd header (S370: knees over the toes), ops/research/GDSCRIPT_TRAPS.md.
## What would a human do?
A boxer's rear knee in guard sits slightly in, loaded over the foot, while her hips bounce and shift; it never bows out.
## Prefab check
None: our own rig layers.
