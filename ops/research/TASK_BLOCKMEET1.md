# TASK BLOCKMEET1 - QWEN (qwen3-coder) - does a blocked punch meet the blocking glove? Measure only

Status: OPEN (S418, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: Claude filmed the Moves preview's jab after HEADAIM2B (E:/FightCamp/tmp/s418_headaim/jab2.jpg). The slipped jab is right now: it flies where the face was. The BLOCKED jab is not: the partner's glove comes up to forehead height and the jab ends at the partner's chin, UNDER that glove. A "block" that reads as a hit. It looks the same with and without the height aim. This task measures it. It changes NO game code.

## Contract
OWNS: tools/block_meet_probe.gd, docs/BLOCKMEET1_RESULT.md
RED_TEST: tests/head_aim_test.gd -> HEAD_AIM failures=0
REGRESSION: head_aim_test, beat_clips_test
VISUAL: no

## Prior research
tests/head_aim_test.gd (on main, bc0a76b1) is the ruler to copy: a fresh FightStage per setup, `stg.set_process(false)` until `setup()` has run, positions reset before every clip, `stage.glove_front(who, hand)` and `stage.target_point(other, false)` read after the modifiers. docs/HEADAIM2_RESULT.md is its table. What Claude already knows from the code, so do not spend time finding it out:
- The block is ONE clip, `mc_to_block` (BeatClips.DEFENCE["block"]). Nothing fits it to the incoming punch.
- A blocked punch plays its bought clip; since HEADAIM2B only its HEIGHT is fitted, to the face height latched when the punch starts (FightStage.aim_height -> PunchReach.aim_height). Depth and sideways are the clip's.
- In the fight the defence is started by BeatFire._punch (line 181 on: `land == "blocked"`, the block starts at `at * 0.8`). In the Moves preview it is MoveStudio.defend (even jabs block, BLOCK_SET_S 0.25 s before contact).
- GloveClear leans a head away from a glove that would pass through it.
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Freeze the film at the moment the punch arrives and look at three things: the puncher's glove, the blocker's two gloves, the blocker's face. A block is good when the punch is touching a blocking glove and that glove is between the punch and the face.

## Prefab check
None: a probe on our own stage.

## The job: tools/block_meet_probe.gd
Headless SceneTree script. Pairs, all women, all legal: A = mh_boxer_10 (162 cm), B = mh_boxer_12 (178 cm). Setups: A punches B, B punches A, A punches A. Punches: pro_left_jab, pro_right_cross, pro_left_hook, pro_right_hook. Each punch is thrown as BLOCKED the way BeatFire does it (the same calls, the same `at * 0.8` start for mc_to_block, the height aim on), and for the jab also the way MoveStudio.defend does it. Read every frame from 0.10 s before contact to 0.05 s after, in the FINAL pose (connect Skeleton3D.skeleton_updated, as tools/movetip_heads_probe.gd does), and keep the frame where the puncher's glove front is nearest the blocker's face. On that frame print one row:

`ROW <setup> <path fight|preview> <clip> to_face=<m> to_glove=<m> glove_y_minus_face_y=<m> between=<yes|no> gap=<m>`

- `to_face`: puncher's glove front to `target_point(blocker, false)`.
- `to_glove`: puncher's glove front to the NEARER of the blocker's two glove centres (`boxers[i]["gloves"].gloves["l"|"r"].global_position`).
- `glove_y_minus_face_y`: that nearer blocking glove's height minus the face point's height (positive = the glove sits above the face).
- `between`: yes when the nearer blocking glove is closer to the puncher's shoulder than the face is AND within 0.15 m of the straight line from the puncher's glove front to the face.
- `gap`: hips to hips, as head_aim_test prints it.

Two control arms, same rows:
- `CTRL_LANDED`: the same punch LANDED (stage.land). It must read to_face under 0.05. If it does not, the ruler is wrong: stop and say so.
- `CTRL_NOBLOCK`: the punch thrown blocked but the defender never plays mc_to_block (stays in guard). It shows what the block clip itself adds.

docs/BLOCKMEET1_RESULT.md: the table as printed, every row, then three plain sentences: in how many of the blocked rows the punch arrives nearer the face than a blocking glove (`to_face < to_glove`), in how many the blocking glove is `between`, and whether the fight path and the preview path differ. No fix, no opinion on the cause beyond what the numbers show.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script res://tools/block_meet_probe.gd` (never the console build). `Engine.max_fps = 30` (clips run on real time). No file over 500 lines. scripts/ and tests/ are out of bounds. No he or she in the result text.

## The one trap
A row means nothing unless the two boxers were put back before the clip: print `gap` on every row and treat any row whose gap is outside 0.80 to 1.10 m as void (say VOID on it, do not drop it). Round 1 of HEADAIM2 was thrown away for this.

## Result lines (PR body)
RESULT: tests/head_aim_test.gd -> HEAD_AIM failures=0
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
