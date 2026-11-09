# TASK REARHAND2 - QWEN (qwen3-coder) - is the right hook's low hand in the bought capture or made by our bake

Status: OPEN (S414, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: Claude corrected REARHAND1's probe on main (tools/hand_path_probe.gd) and read the table in docs/REARHAND1_RESULT.md.

## Contract
OWNS: tools/raw_hand_path.py, tools/hook_strike_probe.gd, docs/REARHAND2_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/REARHAND1_RESULT.md and its "Reading this" section. tools/hand_path_probe.gd is the corrected way to read a hand in the game: reuse its method and its definitions, do not write new ones. tools/raw_fbx_feet.py and tools/raw_fbx_knee.py read the source FBX in Blender (same import, same rig map). The source takes are in E:/FightCamp/packs/mocaponline_punch_pro; find which take each clip came from by searching tools/ for the clip name. ops/research/KNEEPLANE_S408.md and memory of S407: raw and game columns have disagreed before through a sign or a scale, so prove they agree first. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Put the original capture and our version side by side, on the same ruler, and check the ruler on a punch both should agree on.

## Prefab check
tools/raw_fbx_feet.py already opens these files. Only the hand numbers are new.

## The job
You measure. You change no clip and no game code.
1. tools/raw_hand_path.py (Blender): for each source take, per frame at 30 fps, the same numbers as hand_path_probe: hand to Head distance, hand height against Hips, hand against Hips on the actor's forward axis. Body height is the Head joint above the foot joint in the rest pose, measured on that skeleton, so the actor's size cancels.
2. Clips: all right hooks in docs/REARHAND1_RESULT.md (pro_right_hook and every pro_right_hook_* take), plus the controls pro_left_jab, pro_right_cross and pro_left_hook.
3. tools/hook_strike_probe.gd (game, same read as hand_path_probe): REARHAND1's window ends at the frame furthest from the chin, and on a hook that can be the low point itself. Find the strike as the frame of the hand's highest speed forward after the lowest frame. Report that frame, the hand's height against the hips and against the chin at it, and how many frames pass between the lowest point and the strike.
4. docs/REARHAND2_RESULT.md: one row per clip: game low-over-hips, raw low-over-hips, game ahead-of-hips, raw ahead-of-hips, the difference for each, the strike frame and the hand's height at it. Then one short paragraph with numbers only: on how many right hooks the raw take also reaches hip height and goes behind the hip. No guess at a cause and no proposed fix.

## Rules
scripts/ is out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tools/hook_strike_probe.gd`. Any read of a playing clip sets Engine.max_fps = 30 and reads inside skeleton_updated with modifiers off. Write no images and nothing outside the OWNS files. No file over 500 lines.

## The one trap
Two rulers that differ by a sign or a scale make every row look like a finding. Controls first: on pro_left_jab, pro_right_cross and pro_left_hook the game and raw low-over-hips and ahead-of-hips must agree within 0.03 of body height. If any control misses that, stop and report it: do not write the table.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
