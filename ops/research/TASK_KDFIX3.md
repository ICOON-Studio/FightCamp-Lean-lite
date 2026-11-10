# TASK KDFIX3 - QWEN (qwen3-coder) - a downed boxer's upper body sways, round 3: fix the two layers KDFIX2 named

Status: OPEN (S422, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: the operator after watching fights, 2026-11-10: "the upeer boddy moves left and right when the fighter is knockdedown".
Round 2 (branch qwen/kdfix2, commit 4a5190bd, read its message and tests/knockdown_still_test.gd there) gave a ruler that reads
the FINAL pose (BoneAttachment3D on Hips and Chest, stage processing at 30 fps) and this table, chest side travel on a knockdown:
all layers on 1.91 cm | GuardWeave off 0.70 | FighterLife off 1.04 | TiredSag off 2.09 | the fall clip alone (floor) 0.18.
Start your branch FROM qwen/kdfix2.

## What Claude read in the code (S422)
- scripts/fight3d/FighterLife.gd header: "Punches and hits keep their clip: the layer fades to a FIFTH while one plays" - BUSY
  holds "fall", "down", "knock". So a boxer on the canvas keeps 20% of the standing breath and weight drift. That is the 0.87 cm.
- scripts/fight3d/GuardWeave.gd: off (eased over EASE_OFF_S 0.4 s) outside `free_clips`; `pos` keeps its last value while the
  weight eases. Part of its 1.21 cm may be the ONE unwinding of the lean as the boxer goes down (a settle, not a sway), part may
  be a fall clip that is in free_clips. Measure which before changing anything: travel in the first 0.5 s vs after.

## Contract
OWNS: scripts/fight3d/FighterLife.gd, scripts/fight3d/GuardWeave.gd, scripts/fight3d/KnockdownLayers.gd, tests/knockdown_still_test.gd, docs/KDFIX1_RESULT.md
RED_TEST: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
REGRESSION: knockdowns_test, knockdown_ring_test, bout_stoppage_test, fight_flow_test, golden_path_test, block_meet_test, head_aim_test, guard_weave_test, fighter_pose_test
BASE: qwen/kdfix2
VISUAL: Claude films a knockdown and a knockout after the merge. Do not render.

## The job
1. Keep KDFIX2's ruler. Replace its control (b) "standing guard >= 3x floor" (a bar Claude guessed in the KDFIX2 brief; the
   guard really reads 0.27 cm) with the control that is proven to see the layers: the knockdown with all layers on must read
   >= 3x the knockdown with GuardWeave AND FighterLife off. Print both.
2. FighterLife: when KnockdownLayers.is_down(clip) (or the boxer's down state KnockdownLayers already keeps), ease to 0, not to
   a fifth - no breath on the trunk side, no weight drift, no head look. Breathing may stay ONLY as the chest's rise (forward
   axis), never sideways; say in the PR body which you kept. Standing boxers: unchanged (fighter_pose_test proves it).
3. GuardWeave: print travel in the first 0.5 s and after it, with GuardWeave on and off. If the part after 0.5 s is over 0.3 cm,
   find why the weave still runs on a downed boxer (is the fall clip in free_clips? grep where free_clips is built) and stop it
   when down. If it is only the settle, set `pos` toward 0 while eased off so the lean unwinds with the weight, not after.
4. The bars: a knockdown and a knockout each within 0.5 cm of the floor (the fall clip alone).
5. docs/KDFIX1_RESULT.md: a "Round 3" section, the table again with the fix in, five sentences.

## Prior research
Branch qwen/kdfix2 (the ruler), tests/block_meet_test.gd `_attach` (line ~276), scripts/fight3d/KnockdownLayers.gd,
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch a boxer lying on the canvas and switch off, one at a time, the things that make a standing boxer look alive.

## Prefab check
None: our own layers.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`.
No file over 500 lines (FighterLife.gd is 331). Never "he" or "she" in text. Write no check that can only pass: run each bar once
on the KDFIX2 tree (before your fix) and say in the PR body which went red.

## Result lines (PR body)
RESULT: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
RESULT: tests/fighter_pose_test.gd -> the test's own pass line
