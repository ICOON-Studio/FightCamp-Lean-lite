# TASK BLOCKMEET2 - QWEN (qwen3-coder) - a blocked head punch lands ON the blocking glove

Status: OPEN (S419, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: BLOCKMEET1 (docs/BLOCKMEET1_RESULT.md, on main; Claude re-ran the probe, CTRL_LANDED read 0.001 to 0.021 m on all 12 rows, so the ruler holds). In the fight a blocked punch reads as a hit: in 11 of 12 fight rows the blocking glove is NOT between the punch and the face, it sits 0.11 to 0.19 m below the face, and the jab and cross end 0.02 to 0.10 m from the face. In the Moves preview the block starts earlier and the glove is between in 3 of 3 rows, but the punch still stops 0.15 to 0.19 m from that glove and 0.06 m from the face.

## Contract
OWNS: scripts/fight3d/BeatFire.gd, scripts/fight3d/FightStage.gd, scripts/fight3d/PunchReach.gd, scripts/fight3d/MoveStudio.gd, tools/block_meet_probe.gd, tests/block_meet_test.gd, docs/BLOCKMEET2_RESULT.md
RED_TEST: tests/block_meet_test.gd -> BLOCK_MEET failures=0
REGRESSION: head_aim_test, beat_clips_test, move_tip_test
VISUAL: Claude films it after the merge (tools/head_aim_film.gd and a fight film). Do not render.

## Prior research
- docs/BLOCKMEET1_RESULT.md and tools/block_meet_probe.gd (main): the ruler. Reuse its reads, its reset and its VOID rule. Its header has the run line.
- docs/HEADAIM2_RESULT.md, tests/head_aim_test.gd: how a punch's height is fitted (FightStage.aim_height -> PunchReach.aim_height, latched when the punch starts).
- FightStage.land (line 123) carries a LANDED glove onto the face on all three axes. That machinery exists: a blocked punch needs the same carry, onto a different point.
- BeatFire.gd line 199: `var when := at * (0.8 if d == "block" else 0.35)`. With a contact near 0.27 s the block clip starts about 0.05 s before the punch arrives. MoveStudio.defend starts it BLOCK_SET_S 0.25 s before contact.
- The block is ONE clip, mc_to_block (BeatClips.DEFENCE["block"]). A body hook is blocked with the elbow (HitSnap.brace): NOT this task, leave it.
- ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A boxer who blocks has the glove up in front of the face BEFORE the punch arrives, and the punch thuds into that glove and stops there. Freeze the film at contact: the puncher's glove is touching the blocking glove, the blocking glove is between the punch and the face, at face height.

## Prefab check
None: our own stage and clips.

## The job, two changes
1. THE BLOCK IS SET IN TIME. In the fight the block clip starts early enough that the glove is up when the punch arrives: one shared constant (the preview's 0.25 s before contact, never before time 0), read by both BeatFire and MoveStudio. A slip, weave or step back keeps its own timing.
2. THE PUNCH GOES TO THE GLOVE. A blocked HEAD punch (jab, cross, lead hook, rear hook; not the body hook) is carried onto the nearer blocking glove at contact, all three axes, the way a landed punch is carried onto the face. It stops on the glove's surface: it does not pass through the glove and does not reach the face. If the blocking glove sits low, raise where the block holds the glove (a small fitted lift of the blocking hand toward the line from the punch to the face) rather than aiming the punch at the chest. A SLIPPED or missed punch is unchanged (head_aim_test must stay green without edits).

## Bars (tests/block_meet_test.gd, headless, the probe's ruler)
Same pairs as BLOCKMEET1 (A = mh_boxer_10, B = mh_boxer_12; A_B, B_A, A_A), the four punches, fight path for all four and preview path for the jab. On the frame where the puncher's glove front is nearest the blocking glove, in the FINAL pose:
- `touch`: puncher's glove front to the SURFACE of the nearer blocking glove <= 0.04 m, and not more than 0.03 m inside it.
- `between`: yes on every row (BLOCKMEET1's definition, unchanged).
- `to_face` >= 0.10 m on every row: the punch does not reach the face.
- `glove_y_minus_face_y` between -0.08 and +0.06 m: the block is at face height.
- `gap` 0.80 to 1.10 m, else the row is VOID and the test fails.
- CTRL_LANDED still under 0.05 m on all 12.
- The test is RED on main (11 of 12 fight rows fail `between`): run it on main first and paste that line into the PR body.
tools/block_meet_probe.gd prints the new table to docs/BLOCKMEET2_RESULT.md (every row, the BLOCKMEET1 number beside each new one), then three plain sentences.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tests/block_meet_test.gd` (never the console build). `Engine.max_fps = 30`. No file over 500 lines (FightStage.gd is 420: put new code in PunchReach.gd or a new small script under scripts/fight3d and say so). No he or she in the result text. New behaviour is ON by default, no switch.

## The one trap
Do not make a bar pass inside the measurement. No tolerance added to a read, no frame picked because it passes, no bar loosened: if a row cannot reach a bar, leave it red and say which row and by how much. Claude reads the test's every comparison at collect (a seat inverted a check to pass in S418, and another eased a read by 2.5 points in S416).

## Result lines (PR body)
RESULT: tests/block_meet_test.gd -> BLOCK_MEET failures=0
RESULT: tests/head_aim_test.gd -> HEAD_AIM failures=0
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/move_tip_test.gd -> MOVE_TIP PASS
