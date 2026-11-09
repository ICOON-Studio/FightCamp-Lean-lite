# TASK REARHAND3 - QWEN (qwen3-coder) - fix the forward ruler, then the right-hook table

Status: OPEN (S415, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: docs/REARHAND2_RESULT.md (merged, PR 133). It stopped at its control check, correctly.

## Contract
OWNS: tools/raw_hand_path.py, tools/hook_strike_probe.gd, docs/REARHAND3_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/REARHAND2_RESULT.md: low-over-hips agrees on all three controls (0.019, 0.022, 0.025; bar 0.03). Ahead-of-hips does not (0.054, 0.043, 0.059), always with the raw take further ahead, and the forward axes are 1 degree apart. docs/REARHAND1_RESULT.md and tools/hand_path_probe.gd define the game's read. ops/research/KNEEPLANE_S408.md: raw and game columns have disagreed before through the ruler. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Two people of different build throw the same punch. Measure the reach against each one's own arm, not their height, and check the ruler on a punch both should agree on.

## Prefab check
Both probes exist on main. Add columns to them; no new tool.

## The job
You measure. You change no clip and no game code.
1. On both skeletons, in the rest pose, print: body height (as now), arm length (shoulder to elbow plus elbow to hand) and the Hips joint's position relative to the point midway between the two thigh joints.
2. Add a second ahead-of-hips column: the same distance divided by that skeleton's own arm length. Keep the body-height column.
3. Controls pro_left_jab, pro_right_cross and pro_left_hook: the arm-length column, game against raw, must agree within 0.05 of arm length.
4. docs/REARHAND3_RESULT.md, in this order:
   a. The rest-pose numbers for both skeletons.
   b. The control table with both ahead-of-hips columns and whether the bar held.
   c. Always, whether or not (b) held: one row per right hook (pro_right_hook and every pro_right_hook_* take in docs/REARHAND1_RESULT.md): game low-over-hips, raw low-over-hips, difference. This column already passed its controls.
   d. Only if (b) held: per right hook, game and raw ahead-of-hips in the arm-length column, plus the strike frame and the hand's height at it.
   e. One short paragraph, numbers only: on how many right hooks the raw take also reaches hip height, and (if d exists) goes behind the hip. No guess at a cause and no proposed fix.

## Rules
scripts/ is out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tools/hook_strike_probe.gd`. Any read of a playing clip sets Engine.max_fps = 30 and reads inside skeleton_updated with modifiers off. Write no images and nothing outside the OWNS files. No file over 500 lines.

## The one trap
Do not tune the ruler until the controls pass. If arm length does not close the gap, say so with the numbers and stop at 4c: a bar loosened to pass is worth nothing.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
