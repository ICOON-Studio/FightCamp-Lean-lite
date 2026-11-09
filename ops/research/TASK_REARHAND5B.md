# TASK REARHAND5B - QWEN (qwen3-coder) - the plain right hook keeps the hand up: blend, do not solve

Status: OPEN (S416, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: REARHAND5 stopped, honestly, on the two-bone solve and changed no clip (docs/REARHAND5_RESULT.md on the base branch). Drop the IK.

## Contract
BASE: qwen/rearhand5
OWNS: tools/rear_hook_lift.gd, tests/rear_hook_lift_test.gd, docs/REARHAND5_RESULT.md, assets/anim/baked/mc_Box1_M3_Right_Hook.res, assets/anim/baked/mc_Box1_M3_Right_Hook_FT.res
RED_TEST: tests/beat_clips_test.gd -> BEATCLIPS failures=0
REGRESSION: beat_clips_test
VISUAL: no

## Prior research
ops/research/TASK_REARHAND5.md (the aim and every bar; they all stand). tools/take_fix.gd `_blend_window`: S334 fixed six clips by blending rotation tracks toward another pose with smooth ramps. That is the method. tools/hand_path_probe.gd is the way to read a hand. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Keep the guard on the arm a little longer, so the hand leaves from the chin instead of from the hip.

## Prefab check
tools/take_fix.gd already does this kind of blend.

## The job
1. tools/rear_hook_lift.gd: remove LIFT_AMOUNT and the delta rotations. For the RightUpperArm, RightLowerArm and RightHand rotation tracks, the target pose is that same track's value at frame 0, the guard. Each key from the frame the hand starts to fall (f0) to the strike frame (fs) becomes `orig.slerp(guard, w)`. `w` rises smoothly from 0 at f0 to W over RISE frames, holds, then falls smoothly to 0 exactly at fs over FALL frames. Tune W (start 0.85), RISE (start 3) and FALL (start 5) to pass the bars, the same numbers for both clips. Frames outside f0..fs do not change. The tracks stay local to the parent, so the arm still turns with the body.
2. Print the f0, fs, W, RISE and FALL you used. Run it on the clips from git HEAD, not on an already edited one: `git checkout HEAD -- <the two .res files>` before each tuning run. Keep the meta guard for the final save.
3. Commit the two edited .res files. Without them this task delivers nothing.

## Fix the test first
tests/rear_hook_lift_test.gd has two holes.
a. It never proves its read. Before any bar, it must read the unedited clips and print `READ_CHECK pro_right_hook 0.019 got <x>`, the same for pro_right_hook_ft (0.058) and pro_left_hook (0.177). More than 0.01 off on any of them is a failure, and you stop and report. Read the unedited clips from `git show HEAD:<file>` into a temp resource: pro_left_hook is not edited, so it can load normally.
b. `_estimate_orig_max_move` is an estimate. Bar d must use the unedited clip's real largest frame-to-frame hand move, from the same read. Bar f (every other track equal, key for key) must compare against that unedited clip too.

## Rules
scripts/ is out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <tool>`. No images: Claude films it and judges. No file over 500 lines. Rewrite docs/REARHAND5_RESULT.md: before and after for each bar and each clip, the READ_CHECK lines, the numbers used, one paragraph of numbers only.

## The one trap
If W is high and FALL is short, the hand rushes from chin to target and bar d fails: the punch looks like a pop. If you cannot pass a and d together, stop and print the best pair you found. Do not loosen a bar.

## Result lines (PR body)
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/rear_hook_lift_test.gd -> REAR_HOOK_LIFT failures=0
