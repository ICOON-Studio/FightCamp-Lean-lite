# TASK BOXERLEAN1 - QWEN (qwen3-coder) - does the guard lean as far forward as the capture does?

Status: OPEN (S408, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/torso_lean_probe.gd, tools/torso_lean_raw.py, docs/BOXERLEAN1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
tests/boxer_footwork_test.gd has been red since the idle was re-baked: its torso lean reads 11.3-14.0 deg against a bar of 8-12. At commit 54840341 (7 November, before the re-bake) the same test read 9.2-10.3 and passed; at 5fbb83e2 it read 11.4-13.9, so the Proguard switch is not the cause. scripts/fight3d/BoxerFootworkRig.gd `_torso` only tops the lean up to LEAN_DEG (10), it never takes lean away, so anything over 10 is the clip's own. The re-bake: ops/research/TASK_RETARGET2*.md names the Punch PRO source file and the bake route. How the test reads lean: `tests/boxer_footwork_test.gd` line 282, `atan2(tor.dot(fwd), tor.y)` with `tor` = neck minus hips. tools/knee_plane_probe.gd shows reading inside skeleton_updated and proving which clip played; tools/knee_plane_raw.py shows reading a source file in Blender. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Stand the original capture and our boxer side by side, side-on, and hold a ruler from hips to neck. Same slope: the clip is right and the old limit is out of date. Steeper on ours: the bake added lean.

## Prefab check
tools/knee_plane_probe.gd and tools/knee_plane_raw.py already read both sides. Copy their bone reading, write no new maths beyond the lean.

## The job
1. One lean definition in both tools: the neck minus the hips, against her facing, in degrees, + = forward. Her facing is horizontal and square to the line between the hips, on the side her toes point. Do not take the test's forward from memory: read how it builds `fwd` and use the same thing. A self-check first: a made-up torso 10 deg forward reads 10, 10 deg back reads -10, and a hip line turned 30 deg changes nothing.
2. Arms, each one process, both boxers (orthodox red, southpaw blue), clip pro_idle only:
   SOURCE: the Punch PRO idle source file, Blender.
   CLIP: pro_idle in the game with every SkeletonModifier3D off.
   GAME: nothing switched off.
   TEST: the rig on as tests/boxer_footwork_test.gd switches it on (rig.w 1.0, GuardWeave off).
3. Report min, mean and max per arm, on the same frames of the idle (say which).
4. Run CLIP and GAME for mh_boxer_01 and mh_boxer_10 as well, because those are the bodies the test fails on.
5. docs/BOXERLEAN1_RESULT.md: the table, then in plain words: how far does our guard lean against the capture, is it the bake or a layer that adds the difference, and do the two bodies differ. Name no cause without the arm that shows it.

## Rules
scripts/ and tests/ are out of bounds: this task only measures. Engine.max_fps = 30 and Godot with --fixed-fps 30. Every row states which clip played and for how many frames, from current_animation; a row with 0 frames of its clip is a failure, not a number. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Blender: "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b --factory-startup.

## The one trap
Blender is Z-up and the rig's forward differs from the game's. Get the sign of one row by hand from a side view of the numbers before trusting the column: a boxer bent over her toes must read positive in both tools.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
