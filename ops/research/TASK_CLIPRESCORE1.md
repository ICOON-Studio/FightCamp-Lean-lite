# TASK CLIPRESCORE1 - QWEN (qwen3-coder) - fresh pictures of the boxing clips that scored under 6

Status: OPEN (S412, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).

## Contract
OWNS: tools/clip_rows.py, docs/CLIPRESCORE1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
ops/research/CLIP_SCORES_S390.md: 47 of 122 clips scored under 6, judged from 8-frame rows of each clip alone on a grid, before the S401 re-bake (ops/research/RETARGET2B_RESULT.md). So those scores may be out of date. scripts/fight3d/BeatClips.gd holds OFF_TAKES. tools/clip_orbit.gd films one clip on a grey grid and writes `<out>/<id>/f0000.jpg` frames. ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Lay out eight moments of each clip in a row, the same way as last time, so a judge can compare like with like.

## Prefab check
tools/clip_orbit.gd already films every clip. Only the row-maker is new (Pillow).

## The job
You make the pictures. You cannot see images and you do not score anything: Claude's blind judges do that afterwards.
1. The clip list is every name in the table "Under 6 and still in play" plus the 12 names under "Taken out of play" in ops/research/CLIP_SCORES_S390.md. Read them from that file, do not retype them. The file lists 44 names although it says 47: report the 44, do not invent three.
2. Film each with tools/clip_orbit.gd, `mods=game`, `glb=mh_boxer_10`, output `E:/FightCamp/tmp/s412_clips/frames`. Pass ids in batches so one crash does not lose the run.
3. Write tools/clip_rows.py: for one clip folder, eight evenly spaced frames in one row, 2400 px wide, saved as `E:/FightCamp/tmp/s412_clips/rows/<random 6 letters>.jpg`. No clip name on the picture or in the file name. `E:/FightCamp/tmp/s412_clips/KEY.txt` maps each file to its clip. A folder with under 8 frames is a failure row, not a shorter picture.
4. docs/CLIPRESCORE1_RESULT.md: one row per clip: name, was it found in the game, frames filmed, its old score, row made yes/no. Then the count of clips not found, and why each was missing (read FightClips, do not guess). Do not put the KEY's file names in this document.

## Rules
scripts/ is out of bounds: this task only makes pictures. Godot through `python ops/Tools/godot_slot.py run --who qwen -- python tools/hidden_desktop.py run --timeout=3600 <godot.exe> --path . --windowed --resolution 960x540 --script res://tools/clip_orbit.gd -- out=... ids=... mods=game`. Never the console build. Dummy audio. Frames stay under E:/FightCamp/tmp, never in the repo: E: is short of space, so delete each clip's frames once its row is saved and checked.

## The one trap
A row that comes out with the same picture eight times, or a blank grid, looks like a finished file. After each row, check the eight frames differ from each other (mean absolute pixel difference between the first and fifth frame above a small bar) and the boxer is present (the frame is not nearly one colour). A row that fails goes in the table as a failure.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
