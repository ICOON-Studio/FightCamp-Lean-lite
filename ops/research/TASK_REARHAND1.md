# TASK REARHAND1 - QWEN (qwen3-coder) - does the hand really drop to the hip before a punch, and in how many clips

Status: OPEN (S413, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/hand_path_probe.gd, docs/REARHAND1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/CLIPFULL1_SCORES.md: a blind judge reading large stills said that in most punch clips the hand drops to or behind the hip before the punch and the guard sags afterwards. It scored the playing pro_right_hook 4 of 10. A judge reading stills can be fooled by a circling camera, so this is a claim to measure. tools/hit_react_drawn.gd is the right way to read a bone: inside skeleton_updated, with modifiers off (ops/research/HITREACT notes: an earlier probe outside it read half the true travel). Only tools/hit_react_drawn.gd's reading method is reused, not its output. tools/clip_orbit.gd lists how clips load. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch where each glove is relative to the chin, frame by frame, on the clips that are said to be wrong and on clips that are not, and write the numbers down.

## Prefab check
tools/hit_react_drawn.gd already reads bones the right way. Only the table is new.

## The job
You measure. You change no clip and no game code.
1. Clips: every `pro_*` punch clip the fight can pick, plus the benched ones in BeatClips.OFF_TAKES, plus two controls: the guard idle (both hands should stay near the chin) and pro_left_jab (the judge's best).
2. For each clip and each frame at 30 fps, read in skeleton_updated with modifiers off: each hand's distance from the chin (head bone) and each hand's height against the hips, both as a share of the boxer's height. Use glb=mh_boxer_10.
3. From that, per clip: which hand punches (the one that gets furthest from the chin); for the OTHER hand, the largest distance from the chin and the lowest height, with the frame; for the punching hand, how far it moves AWAY from the target line or BELOW its guard height before it goes forward (the wind-up), with the frame; and at the last 10% of the clip, each hand's distance from the chin against where it started (the guard sag).
4. docs/REARHAND1_RESULT.md: one row per clip with those numbers, sorted worst wind-up first, the controls marked. Then one short paragraph: how many clips have the non-punching hand leave the chin by more than the guard idle's largest value, and how many have a wind-up. State the numbers only: no guess at the cause.

## Rules
scripts/ is out of bounds. Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script tools/hand_path_probe.gd`. Never the console build. Any test that reads a playing clip sets Engine.max_fps = 30. Write no images and nothing outside the OWNS files.

## The one trap
A probe that reads the bone outside skeleton_updated reads the rest pose or the previous frame, and every row still looks like a finished number. Check the method first: the guard idle's hands must stay close to the chin on every frame, and pro_left_jab's lead hand must leave the chin by at least 30% of body height at full extension. If either control fails, stop and report the failure: do not write the table.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
