# TASK REARHAND5 - QWEN (qwen3-coder) - the plain right hook keeps the hand up before it swings

Status: OPEN (S416, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: Claude opened the sheets of pro_right_hook and pro_left_hook (E:/FightCamp/tmp/s413_clips/sheets/orhoxa_a.jpg, xvahmr_a.jpg). On the right hook the hand falls to the hip before the punch. On the left hook it does not. One blind judge gave pro_right_hook 4/10 for it (docs/CLIPFULL1_SCORES.md).

## Contract
OWNS: tools/rear_hook_lift.gd, tests/rear_hook_lift_test.gd, docs/REARHAND5_RESULT.md, assets/anim/baked/mc_Box1_M3_Right_Hook.res, assets/anim/baked/mc_Box1_M3_Right_Hook_FT.res
RED_TEST: tests/beat_clips_test.gd -> BEATCLIPS failures=0
REGRESSION: beat_clips_test, owned_mocap_test
VISUAL: no

## Prior research
docs/REARHAND1_RESULT.md (the game's own read; the column you need is "Low over hips"). REARHAND3 and 4: the low hand is in the bought capture, in every right hook, so no re-bake and no swap can fix it. Do NOT use REARHAND4's numbers: its left-hook rows disagree with REARHAND1 and REARHAND2, and its strike column is void. tools/hand_path_probe.gd is the way to read a hand: reuse its method and definitions. tools/hook_strike_probe.gd finds the strike frame. tools/take_fix.gd is how a baked clip was edited and saved before (S334). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
An animator keeps the punch and the follow-through and only lifts the arm in the wind-up, then checks nothing pops.

## Prefab check
SkeletonIK and TwoBoneIK3D solve at run time; this is a one-off edit of two saved clips, so a small analytic two-bone solve in the tool is the right size. Nothing to buy.

## The job
Today, from REARHAND1, low over hips, share of body height: pro_right_hook 0.019, pro_right_hook_ft 0.058. The plain left hooks read 0.177 and 0.134. Those two right-hook clips are the only ones you change. The hard takes stay low on purpose.
1. tools/rear_hook_lift.gd, headless: on each of the two clips, from the frame the hand starts to fall to the strike frame, raise the right hand along world up by a smooth bump that is zero at both ends. Solve the right upper arm and lower arm by two-bone IK with the elbow staying in the arm's own plane, and turn RightHand back so the glove keeps its world orientation. Write ONLY the RightUpperArm, RightLowerArm and RightHand rotation tracks.
2. Refuse to run twice on one clip: set a meta `rear_hook_lift` on the saved Animation and stop if it is there.
3. tests/rear_hook_lift_test.gd prints `REAR_HOOK_LIFT failures=<n>`, read through hand_path_probe's method, modifiers off, max_fps 30, on the saved clips. Bars:
   a. Low over hips at least 0.12 on both clips.
   b. At the strike frame and every later frame, the hand within 0.01 of body height of the original (read the original from `git show HEAD:<file>` into a temp resource, or store the numbers from the unedited clip in the test as constants, printed with where they came from).
   c. Reach within 0.01 of REARHAND1's: 0.432 and 0.431.
   d. No pop: the hand's largest frame-to-frame move is at most 1.1 times the original clip's largest.
   e. Elbow angle never above 175 degrees.
   f. Every track other than the three named bones equals the original, key for key.
4. docs/REARHAND5_RESULT.md: before and after for each bar and each clip, then one paragraph of numbers only.

## Rules
scripts/ is out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <tool>`. No images and no windowed runs: Claude films it and judges. No file over 500 lines.

## The one trap
A hand read outside skeleton_updated, or with modifiers on, gives numbers that look right and are not (HITREACT and KNEERAW lost whole sessions to it). Prove your read first: on the unedited clips, your test must reproduce REARHAND1's low over hips within 0.01 for pro_right_hook, pro_right_hook_ft and pro_left_hook (0.019, 0.058, 0.177). If it does not, stop and report that. Change nothing.

## Result lines (PR body)
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/rear_hook_lift_test.gd -> REAR_HOOK_LIFT failures=0
