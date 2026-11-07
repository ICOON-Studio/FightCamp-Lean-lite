# TASK INSIDE3 - ARENA - up close, a folded boxer's face never sinks into the other's body (round 2 of INSIDE2)

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (inside range of the live 3D fight).
Repo: ICOON-Studio/FightCamp-Lean, branch main. Work on your own arena/ branch, open a PR, never merge.

## Contract
OWNS: scripts/fight3d/GloveClear.gd, tests/head_torso_clear_test.gd
RED_TEST: tests/head_torso_clear_test.gd -> HEAD_TORSO failures=0
REGRESSION: inside_beats_test, inside_exits_test, fight_polish_test, body_keep_test, foot_plant_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/inside3 short

## Why
Blind judges keep naming the fight's close range a tangle. In S393 (ops/research/INSIDE_WORK_S393.md) more punches inside lost a
blind test because of one fault, seen by both judges: a boxer folds over a body shot (reaction takes pro_hit_by_gutshot_v3 /
v2_short / v2, scripts/fight3d/BeatClips.gd "body_hook") and her face stays sunk in the other boxer's torso for ~0.5 s.
scripts/fight3d/GloveClear.gd (a SkeletonModifier3D) already keeps her head out of the other's HEAD (`_clear_head`, it bends her
spine and chest away, horizontal only) and her gloves out of his head. Nothing keeps her head out of his TORSO.
The full spec of round 1 is ops/research/TASK_INSIDE2.md - read it; its bars stand.

## What round 1 (Goose, branch goose/issue-67, commit bf7905cd) left
- It wrote tests/head_torso_clear_test.gd only (start from it: `git checkout origin/goose/issue-67 -- tests/head_torso_clear_test.gd`)
  and never changed GloveClear.gd.
- ITS HARNESS DOES NOT BRING THEM CLOSE: it sets the two boxer nodes 0.40 m apart, but the closest head-to-torso distance it
  measures on main is 0.555 m (Claude's headless run; Goose's CI run read 0.447), so its LIVE guard bar FAILS: the stage puts its
  boxers back where the fight holds them (each boxer's `pos` in FightStage, Footwork / RingFeet), so writing node.position does not
  stick. Place them through the stage's own state (or switch the footwork off for the test, as scripts/fight3d/MovePlayer.gd does
  with `_stage.feet.rig_on = false`), print the hips distance every 10 frames, and only measure once the hips are 0.50-0.60 m apart.
- Run Godot HEADLESS (`--headless --audio-driver Dummy`): round 1 ran it windowed under xvfb (~13 min a run) and timed out.

## Do
1. Fix the harness until the LIVE bar passes on main (B's head centre within 0.25 m of A's torso segment Hips -> UpperChest in
   at least one take), then keep bars a-d of TASK_INSIDE2.md: (a) never nearer than 0.20 m after the fix; (b) the fold keeps at
   least 85% of main's trunk angle per take; (c) no pop: at most 0.03 m more head motion frame to frame than main in the same take;
   (d) gloves >= 0.15 m from heads, heads >= 0.19 m apart.
2. Add `_clear_torso` in GloveClear.gd beside `_clear_head`, the same way (her spine and chest bend away from his torso with the
   same SOFT_M soft knee; she gives way, he does not move), run before the gloves; count it like head_pushes (torso_pushes).
3. The PR body lists main's numbers and yours: RESULT: HEAD_TORSO main live=.. a=.. b=.. c=.. d=.. / after ... and every
   REGRESSION test's pass line. Do not delete or weaken any test. Files under 500 lines (GloveClear.gd is 152).
4. Do not touch HitSnap.gd, BeatFire.gd (another seat), BeatClips.gd, FootPlant.gd, RingFeet.gd, Clinch.gd, the fight model
   (scripts/rules, scripts/state, scripts/world), ops/ or tools/run_tests.sh.

## Prior research
ops/research/INSIDE_WORK_S393.md; ops/research/TASK_INSIDE2.md; GloveClear.gd S315/S316 comments; BeatClips.gd S305/S310/S371 notes.

## What would a human do?
A boxer hurt by a body shot folds forward, but her head lands beside his shoulder or on his chest and slides off; she leans on
him, she does not pass through him.

## Prefab check
No asset; a skeleton modifier change on clips already in the project.
