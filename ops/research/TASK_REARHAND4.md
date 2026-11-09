# TASK REARHAND4 - QWEN (qwen3-coder) - is there a right hook we own that does not drop the hand to the hip

Status: OPEN (S415, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: docs/REARHAND3_RESULT.md: on all eight Punch PRO right hooks the raw capture reaches the same height as the game (within 0.03 of body height), so the low hand is in the bought capture and no bake change removes it.

## Contract
OWNS: tools/raw_hand_census.py, docs/REARHAND4_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
REGRESSION: guard_knee_test
VISUAL: no

## Prior research
docs/REARHAND1_RESULT.md (the game table), docs/REARHAND3_RESULT.md, docs/CLIPFULL1_SCORES.md (pro_right_hook scored 4: "hand behind the hip, gloves sag, rear foot floats"). tools/raw_hand_path.py is the working reader of a source FBX in Blender: import from it, do not rewrite it. Queue row ROKOKO1 notes earlier sources (Meshy, Rokoko). The packs are under E:/FightCamp/packs. ops/research/GDSCRIPT_TRAPS.md is not needed: no GDScript here.

## What would a human do?
Before fixing a bad take by hand, go through the shelf of takes already paid for and see if a better one is there.

## Prefab check
tools/raw_hand_path.py already reads a take. Only the list of takes is new.

## The job
You measure. You change no clip, no game code and no asset.
1. tools/raw_hand_census.py (Blender): list every FBX under E:/FightCamp/packs whose file name contains hook (any case) and is a punch, then measure each with raw_hand_path's functions: the punching hand's lowest height above the Hips during the wind-up, as a share of that skeleton's body height (the low_h column), and the hand's height at the strike. Find the punching hand from the file name where it says left or right; where it does not, take the hand that moves furthest and say so in the row.
2. Controls first, through the census's own code path: pro_left_jab must read 0.284 and pro_right_cross 0.273 within 0.01 (docs/REARHAND2_RESULT.md, Raw low_h). If either misses, stop and report it: do not write the table.
3. docs/REARHAND4_RESULT.md: one row per take, sorted by low_h, highest first: pack folder, file, hand, low_h, strike height, frames, and whether the FBX failed to load. Then one short paragraph with numbers only: how many right hooks have low_h above 0.15 and above 0.20, and which pack each is in. No proposed fix and no opinion of which looks best. A take outside Punch PRO must carry the pack's folder name, so its licence can be checked before anyone uses it.

## Rules
scripts/ and assets/ are out of bounds. Blender headless only, no images, nothing outside the OWNS files. No file over 500 lines. Skip any single FBX that takes over 120 seconds and list it as skipped.

## The one trap
A take whose name says hook may be a combination or a body shot. Print the frame count and the strike height in the row, and do not drop any row: Claude reads the table.

## Result lines (PR body)
RESULT: tests/guard_knee_test.gd -> GUARD_KNEE failures=0
