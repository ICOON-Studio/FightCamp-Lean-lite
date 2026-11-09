# TASK CLIPFULL1 - QWEN (qwen3-coder) - large pictures of the five benched takes beside the plain takes that play

Status: OPEN (S413, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/clip_sheets.py, docs/CLIPFULL1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/CLIPRESCORE1_SCORES.md: judged from 250 px frames, so feet and joints were coarse. Five takes that are out of play rose to 6 there. ops/research/CLIP_SCORES_S390.md has their old scores. scripts/fight3d/BeatClips.gd holds OFF_TAKES. tools/clip_orbit.gd films one clip on a grey grid and writes `<out>/<id>/f0000.jpg` frames. tools/clip_rows.py is last round's row-maker: reuse its checks. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Put each benched take next to the take that plays instead, big enough to see the feet, and look at them without knowing which is which.

## Prefab check
tools/clip_orbit.gd already films every clip. Only the sheet-maker is new (Pillow).

## The job
You make the pictures. You cannot see images and you do not score anything: Claude's judges do that afterwards.
1. The eight clips. Benched: pro_left_hook_miss, pro_left_hook_special, pro_left_jab_miss, pro_right_hook_hurt, pro_right_hook_hurt_ft. Playing: pro_left_hook, pro_left_jab, pro_right_hook.
2. Film each with tools/clip_orbit.gd, arguments `mods=game glb=mh_boxer_10 once`, window resolution 1920x1080, output `E:/FightCamp/tmp/s413_clips/frames`.
3. Write tools/clip_sheets.py. For one clip folder: take eight evenly spaced moments from the frames where the clip is actually playing, and save two sheets, moments 1-4 and moments 5-8. A sheet is 2 frames by 2 frames, 1500 x 1500 px, each frame a centre-cropped square of the film frame scaled to 750 x 750. Save as `E:/FightCamp/tmp/s413_clips/sheets/<random 6 letters>_a.jpg` and `_b.jpg` (same six letters for one clip), quality 90. No clip name on the picture or in the file name. `E:/FightCamp/tmp/s413_clips/KEY.txt` maps each six letters to its clip, in shuffled order.
4. docs/CLIPFULL1_RESULT.md: one row per clip: name, benched or playing, was it found in the game, frames filmed, frames counted as playing, sheets made yes/no. Do not put the KEY's letters in this document.

## Rules
scripts/ is out of bounds: this task only makes pictures. Godot through `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=3600 <godot.exe> --path . --windowed --resolution 1920x1080 --script res://tools/clip_orbit.gd -- out=... ids=... mods=game glb=mh_boxer_10 once`. Never the console build. Dummy audio. Frames stay under E:/FightCamp/tmp, never in the repo: E: is short of space, so delete each clip's frames once its sheets are saved and checked. Keep the sheets and the KEY.

## The one trap
tools/clip_orbit.gd films at least MIN_S seconds, so a short punch may be followed by a long hold. Moments taken evenly across the whole folder would then be mostly the hold, and every sheet would look finished. Read clip_orbit.gd, work out how many frames are the clip itself (its length at 30 fps) and take the moments from those only. Then check each sheet: the boxer is present (a frame is not nearly one colour) and the moments differ from each other (mean absolute pixel difference between moment 1 and moment 3 above a small bar). A sheet that fails goes in the table as a failure.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
