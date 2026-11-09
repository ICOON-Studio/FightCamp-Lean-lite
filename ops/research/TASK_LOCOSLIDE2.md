# TASK LOCOSLIDE2 - QWEN (qwen3-coder) - which way does the planted foot creep, and what brings it back to the source?

Status: OPEN (S408, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/foot_slide_probe.gd, tools/loco_slide_raw.py, docs/LOCOSLIDE2_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/LOCOSLIDE1_RESULT.md and its CLAUDE'S READING note at the top: read the note first, it lists what that table cannot say. All layers off and nothing off read the same, so the modifier layers are out. What is left is how the clip is built and how the body is moved. scripts/fight3d/RkRetarget.gd: `build` scales the floor travel, `_hold_contacts` makes the hips take up the planted feet's difference, `xz_gain` is the floor gain (tools/rokoko_feet_probe.gd sets it from `rkxz=<k>`), `-- rknocontact` turns the hold off. scripts/fight3d/RkLoco.gd: `register` takes the hips' floor travel out into a curve, `tick` moves the body by it. scripts/fight3d/RkClips.gd CLIPS: each clip's window and `cycles`. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch one planted foot on the worst clip, and see whether it drifts the way she is walking or against it. Drift with the walk means the body travels too little for the legs; against it means too much. Then try the two existing switches and see which one stops it.

## Prefab check
tools/foot_slide_probe.gd and tools/loco_slide_raw.py already read both sides. Extend them, write no new ruler.

## The job
Clips: rk_loc_in, rk_loc_back, rk_loc_left, rk_loc_right. Run Godot with `--fixed-fps 30` in every arm, so two runs of one arm print the same numbers (show that once).

1. Compare like with like. Measure ONE cycle in both tools: the source window, and in the game the second cycle of the chained clip (`cycles` in CLIPS; rk_loc_in has one). Never 150 looped game frames against one source pass.
2. For every planted stretch print: clip, foot, first frame, clip time, frames long, PATH (the summed travel LOCOSLIDE1 reported), NET (straight line first to last), ALONG (NET's part along the body's travel for those frames, + = the same way she is walking), BODY (how far the body travelled in those frames), and the share ALONG / BODY.
3. Print the slide also as a share of leg length, in both tools, because the two bodies differ (game 0.838 m, source 0.842-0.889 m).
4. Replace SNAPS: count only a jump of over 3 cm in one frame on a frame inside a planted stretch or next to one, and count the loop seam apart. A swinging foot is not a snap.
5. Arms in the game, one process each: GAME, `-- rknocontact`, `rkxz=0.9`, `rkxz=1.1`. Add the rkxz knob to the probe the way tools/rokoko_feet_probe.gd does, set before stage.setup.
6. docs/LOCOSLIDE2_RESULT.md: the table, then in plain words: on each clip does the planted foot creep with the walk or against it, is ALONG / BODY about the same on every clip (one wrong scale) or different (something else), and which arm comes closest to SOURCE. Then the worst stretch: clip, foot, first frame, clip time, for a still.

## Rules
scripts/ is out of bounds: this task only measures. Engine.max_fps = 30 stays. Every row states which clip played and for how many frames, from current_animation; a row with 0 frames of its clip is a failure, not a number. Extend the self-check: a made-up foot creeping along the body's travel reads a positive ALONG, against it a negative one. Say only what a table shows: no cause gets named without the arm that proves it. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Blender: "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe" -b --factory-startup.

## The one trap
`rk_loc_in` is mirrored: its left foot in the game is the source's right foot, and ALONG must use the mirrored travel. Get the sign of one row by hand before trusting the column.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
