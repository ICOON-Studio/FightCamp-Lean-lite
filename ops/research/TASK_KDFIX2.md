# TASK KDFIX2 - QWEN (qwen3-coder) - a downed boxer's upper body sways, round 2: a ruler that sees the layers

Status: OPEN (S421, Claude main). Discipline: boxing. Model: qwen3-coder. Animation item (operator S401).
Source: the operator after watching fights, 2026-11-10: "the upeer boddy moves left and right when the fighter is knockdedown".
Round 1 is PR 159 (branch qwen/kdfix1): read its diff and docs/KDFIX1_RESULT.md. Start your branch FROM qwen/kdfix1.

## Why round 1 was not collected (Claude, S421, read on the branch)
1. The test cannot see what it tests. `_chest_side_travel` calls `skel.get_bone_global_pose()` from the test: that is the pose
   BEFORE the modifiers (GuardWeave, TiredSag, RangeBreath, GuardLife...) write, so a layer that sways the chest is invisible
   to it and every bar can only pass. Read the FINAL pose: a BoneAttachment3D on Hips and on Chest (tests/block_meet_test.gd
   `_attach`, line 276, proven in S420), or a read inside `Skeleton3D.skeleton_updated` (tests/head_aim_test.gd).
2. It never plays a knockdown the way the game does: `stage.set_process(false)` then `ap.seek()` every 0.1 s. The layers ease
   over time inside `_process_modification`; frozen and seeked, they never run. Play it with the stage processing at a fixed
   30 fps, through the game's own knockdown (scripts/fight3d/KnockdownCount.gd `start(down, stop_how, up_at, fall_in)`, as the
   fight calls it; tests/knockdown_ring_test.gd shows how one is forced).
3. `_measure_floor` and `_measure_knockdown_sway` are the same code, so the control equals the case. The standing control read
   0.27 cm: a ruler that sees the guard weave must read it far above the fall clip alone. The knockout passed at exactly 0.50.
4. GuardWeave: down clips were never in `free_clips`, so `and not is_down(clip)` changes nothing there. Name the layer that
   moves a downed boxer from a switched-off run, do not assume it.

## Contract
OWNS: scripts/fight3d/KnockdownLayers.gd, scripts/fight3d/GuardWeave.gd, scripts/fight3d/RangeBreath.gd, scripts/fight3d/TiredSag.gd, scripts/fight3d/GuardLife.gd, scripts/fight3d/BoxerBuild.gd, tools/knockdown_probe.gd, tests/knockdown_still_test.gd, docs/KDFIX1_RESULT.md
RED_TEST: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
REGRESSION: knockdowns_test, knockdown_ring_test, bout_stoppage_test, fight_flow_test, golden_path_test, block_meet_test, head_aim_test
BASE: qwen/kdfix1
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
1. The ruler (tools/knockdown_probe.gd and the test share one function): the chest's sideways travel relative to the hips, cm
   peak to peak and reversals a second, read on the FINAL pose, stage processing at 30 fps. Three controls, printed every run:
   (a) the fall clip with every trunk layer switched off = the floor; (b) a standing boxer in guard with the layers ON must read
   at least 3 times the floor, else the ruler is blind: stop and say so; (c) the same standing boxer with GuardWeave off reads lower than (b).
2. On MAIN's code (git stash nothing: run the probe from a worktree of origin/main): a beaten knockdown and a knockout through
   KnockdownCount, two different legal boxers. Then switch each trunk layer off in turn. A table: layer off -> travel. Paste it.
3. The fix: keep round 1's one-place `KnockdownLayers.is_down`, and make every layer that the table shows moving a downed boxer
   ask it (ease to 0, ease back within 0.5 s of standing). If the table shows a layer outside OWNS (HitSnap, CornerIK...),
   name it in the result and leave it.

## Bars
tests/knockdown_still_test.gd: controls (b) >= 3 x (a) and (c) < (b); a downed boxer's travel within 0.5 cm of (a) in the knockdown
and the knockout, on each boxer; the layers back at full weight within 0.5 s of standing. RED ON MAIN: paste the failing line
from a run against origin/main's layers in the PR body. No tolerance added inside a read, no case dropped.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tests/knockdown_still_test.gd` (never the console build). No file over 500 lines. No he or she in the result text. New behaviour is ON, no switch.

## The one trap
A ruler that reads the pose before the modifiers sees nothing and passes everything. Control (b) is there to prove it can read a sway; if (b) is not well above (a), the ruler is wrong, not the fix.

## Result lines (PR body)
RESULT: tests/knockdown_still_test.gd -> KNOCKDOWN_STILL failures=0
RED ON MAIN: <the line>
