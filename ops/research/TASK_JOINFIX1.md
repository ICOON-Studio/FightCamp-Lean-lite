# TASK JOINFIX1 - GROK DEV - the lead uppercut's return to guard must not jump

Model: Grok Dev (Cursor replaced, operator S446). Discipline: boxing (demo).

## Contract
OWNS: scripts/fight3d/JoinSmoother.gd (200 lines), tests/join_return_test.gd (new), docs/JOINFIX1_RESULT.md
RED_TEST: tests/join_return_test.gd -> JOIN_RETURN failures=0
REGRESSION: punch_speed_test, punch_weight_test, fight_feel_test, beat_clips_test, head_aim_test, file_limits_test
VISUAL: no (Claude films it on the PC after the merge)
NOT YOURS: every other file. Never edit scripts/rules or scripts/state (the 3D fight never decides anything).

## The defect (measured on main after the POWER1 merge, docs/POWER1_STEP4_RESULT.md lines 112-116 and 213-215)
After a landed lead uppercut (clip pro_left_uppercut) the glove jumps up to 0.48 m in ONE frame on the cut back to guard
(26-28.6 m/s; a real glove returns at well under 10 m/s). Cause found by the step-4 author: at the join, JoinSmoother stores
the clip's raised arm (the pose BEFORE the modifier stack: PunchReach, ReachLimit, the head clearance) instead of the pose
that was DRAWN, so the dead blend starts from a place the glove never was. The join also waits up to two frames for the
new pose before it captures.

## The job
1. Red first: tests/join_return_test.gd stands the game's FightStage pair (copy the staging of tests/punch_speed_test.gd),
   plays a landed pro_left_uppercut and its return to guard, and reads the hitting glove bone in
   `Skeleton3D.skeleton_updated` (the drawn frame, after every modifier) every frame from the hit to 0.40 s after.
   Bar: no one-frame step faster than 9.0 m/s (the jab/cross band top 7.5 + 20 %). Print each frame's speed. Show it RED
   on main (expect ~26 m/s) and paste that line in the result.
2. Fix in JoinSmoother: capture the source pose from the drawn skeleton (the pose after the stack, e.g. read in
   skeleton_updated or from the last drawn frame) and capture it on the join frame itself, not up to two frames later.
3. Also run the same test for pro_right_uppercut, pro_left_hook, pro_right_cross (rows in the same test): all under the bar.
4. docs/JOINFIX1_RESULT.md: before/after table per punch, the exact pass line.

## Prior research
docs/POWER1_STEP4_RESULT.md (the diagnosis); JoinSmoother.gd header (SMOOTH3, Holden's dead blending);
ops/research/POWER1_AUDIT_S446.md; ops/research/GDSCRIPT_TRAPS.md.
## What would a human do?
A boxer's hand comes back to the guard along the path it went out on, fast but continuous: never a jump.
## Prefab check
None: our own join, already built on a published method (dead blending); this fixes its input.

## Rules
Repo ICOON-Studio/FightCamp-Lean, from main; branch `grok/joinfix1`; ONE PR to main. Godot: plain
`godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`. No file over 500 lines. Never delete or weaken
a test. Never "he" or "she" in game text.
RESULT lines for the PR body, copied from your final run:
RESULT: tests/join_return_test.gd -> JOIN_RETURN failures=0
RESULT: tests/punch_speed_test.gd -> its own failures= line (must not rise above 39)
