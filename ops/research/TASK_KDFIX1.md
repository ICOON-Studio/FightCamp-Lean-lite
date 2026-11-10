# TASK KDFIX1 - QWEN (qwen3-coder) - a downed boxer's upper body sways

Status: OPEN (S419, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: the operator after watching fights, 2026-11-10: "the upeer boddy moves left and right when the fighter is knockdedown also there is no countdown when someone is koed".

## Contract
OWNS: scripts/fight3d/KnockdownLayers.gd (new), scripts/fight3d/GuardWeave.gd, scripts/fight3d/RangeBreath.gd, scripts/fight3d/TiredSag.gd, scripts/fight3d/GuardLife.gd, scripts/fight3d/BoxerBuild.gd, tools/knockdown_probe.gd (new), tests/knockdown_still_test.gd (new), docs/KDFIX1_RESULT.md
RED_TEST: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
REGRESSION: knockdowns_test, knockdown_ring_test, bout_stoppage_test, fight_flow_test, golden_path_test
VISUAL: Claude films a knockdown and a knockout after the merge. Do not render.

## Prior research
- scripts/fight3d/KnockdownCount.gd header (S377): the count is designed to run to the mandatory 8 on a knockdown and to 10 on a "KO". So a knockout with no count is a path that skips or cuts it, not a missing feature: find the path. The file is 524 lines, over the 500 rule: this task must bring it under (move a part to KnockdownLayers.gd or another small script).
- Claude grepped GuardWeave, HitSnap, CornerIK, TiredSag, GuardLife and RangeBreath for any read of "down": none. So the layers that sway, breathe or weave a standing boxer's trunk very likely keep running on a boxer who is on the canvas. Prove which, do not assume: HitSnap.gd, PunchReach.gd, FightStage.gd, BeatFire.gd and MoveStudio.gd are NOT yours (another branch holds them); if one of those is the cause, name it with numbers and leave it.
- docs/ANIM_REBUILD_DESIGN.md section 1.1: the per-frame writer table (check its line numbers, they are from 11-07).
- tests/head_aim_test.gd: a FightStage built headless, read on Skeleton3D.skeleton_updated. tests/knockdowns_test.gd and knockdown_ring_test.gd: how a knockdown is forced.
- ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Watch a boxer who has just been dropped: the body lies or kneels as the fall clip left it and moves only with that clip (breathing, the rise). Nothing rocks the chest side to side. And a knockout is counted out loud to ten over the boxer on the canvas before anything else happens: the count IS the drama.

## Prefab check
None: our own stage.

## The job
1. THE RULER FIRST (tools/knockdown_probe.gd, headless, final pose on skeleton_updated): for a downed boxer, from the end of the fall to the start of the rise, read the chest's sideways travel relative to the hips (cm, peak to peak, and reversals per second). Two controls: the fall clip alone on the body with every modifier off reads its own number (print it: that is the floor); a standing boxer in guard reads the guard's sway (print it: the probe can see a sway).
2. Run it as the game plays a knockdown (as_game, two different legal boxers, a knockdown that is beaten and a knockout), then with each trunk layer switched off in turn. Name the layer or layers that move a downed boxer.
3. FIX: from the fall's first frame until the boxer is handed back to the guard, the layers that pose a standing boxer's trunk, neck and arms do not write on that boxer (weight to zero with a short ease, back with a short ease). One place decides "down" and the layers ask it.
(The missing count and the fight not moving on after a knockout were fixed separately in S419 by Claude: scripts/fight3d/KnockdownCount.gd and KnockdownReplay.gd are NOT yours; ask "is this boxer down" through what they already expose.)

## Bars
tests/knockdown_still_test.gd: both controls read as said; a downed boxer's chest travel is within 0.5 cm of the fall clip's own floor number, in both a beaten knockdown and a knockout, on each boxer; the layers are back at full weight within 0.5 s of the boxer standing. RED on main: paste the line.
docs/KDFIX1_RESULT.md: the tables and the layer that swayed.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tests/knockdown_still_test.gd` (never the console build). No file over 500 lines. No he or she in the result text. New behaviour is ON, no switch.

## The one trap
Do not pass a bar inside the measurement (no tolerance added to a read, no case dropped). If a case cannot pass, leave it red and name it. Claude reads every comparison at collect.

## Result lines (PR body)
RESULT: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
RESULT: tests/knockdowns_test.gd -> (its pass line)
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
