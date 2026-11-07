# TASK INSIDE2 - GOOSE (cloud) - up close, a folded boxer's face never sinks into the other's body

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (inside range of the live 3D fight).

## Contract
OWNS: scripts/fight3d/GloveClear.gd, tests/head_torso_clear_test.gd
RED_TEST: tests/head_torso_clear_test.gd -> HEAD_TORSO failures=0
REGRESSION: inside_beats_test, inside_exits_test, fight_polish_test, body_keep_test, foot_plant_test
VISUAL: yes
FILM: --resolution 1920x1080 --script res://tools/corner_film.gd -- E:/FightCamp/tmp/inside2 film

## Why
Blind judges keep naming "nobody works up close" (S396: up close "a tangle"). S393 tried more punches inside
(ops/research/INSIDE_WORK_S393.md, branch claude/insidework1) and both blind judges preferred the control: "more punches
inside gives the existing fault more chances". The fault, seen by both: one boxer folds (a body shot's reaction,
pro_hit_by_gutshot_v3 / v2, BeatClips "body_hook") and her face stays sunk in the other's torso for about 0.5 s (their film
0:53.6-54.0; control 1:10.1, 1:16.2). The inside work waits on this fix, then gets retested.
GloveClear.gd already keeps her head out of the other's HEAD (`_clear_head`, S316: rotates her spine and chest away, horizontal
only) and her gloves out of the other's head. Nothing keeps her head out of the other's TORSO: a fold drops her head to the
other's chest height, under the head-to-head check.

## Do
1. Write tests/head_torso_clear_test.gd FIRST, headless (extends SceneTree). Build FightStage with two real boxers the way
   tests/ring_feet_test.gd does, put them at inside range (hips 0.50-0.60 m apart, facing), and play the fold on boxer B:
   each of pro_hit_by_gutshot_v3, pro_hit_by_gutshot_v2_short, pro_hit_by_gutshot_v2 (and hurt takes from BeatClips "hurt").
   SKELETON MODIFIERS ONLY RUN WHEN THE SKELETON IS IN THE TREE AND PROCESSES (HITSELL1's test read 0 everywhere because they
   never ran): step real frames (`await process_frame`) with the stage processing, or call the modifiers' own steps on a fixed
   clock. Measure every frame, from the pose AS SHOWN (after every modifier): B's head centre (GloveClear's own head-centre
   formula) to A's torso, the segment Hips -> UpperChest, as a capsule.
   Bars (do not loosen them later):
   - LIVE (guard bar, must pass on main): on main the deepest fold brings B's head centre within 0.25 m of A's torso segment
     in at least one take (if it reads far, the harness is wrong, not the game: fix the harness until main reads close);
   - a. no frame has B's head centre nearer A's torso segment than 0.20 m (head ~0.09 + chest ~0.11: touching allowed, sunk
     not); print the worst distance and the frames under 0.20 m per take;
   - b. the fold still reads: B's trunk still folds at least 85% of main's trunk angle at its deepest per take (the S371
     BODYREACT1 bar is 18 deg on gutshot_v3); the fix moves her off his body, it does not straighten her;
   - c. no pop: B's head moves at most 0.03 m frame to frame more than it does on main in the same take (30 fps);
   - d. the existing clears still hold: glove centre to head >= 0.15 m and head to head >= 0.19 m in the same takes.
   Run it on main first and write main's numbers in the PR body (LIVE must pass, a must FAIL on main).
2. Make it green in GloveClear.gd: a `_clear_torso` next to `_clear_head`, the same way (bend her spine and chest away from
   his torso, eased in with the same SOFT_M knee, she gives way and he does not move), run before the gloves. Count it like
   head_pushes (torso_pushes) so a probe can read it. Keep the file under 500 lines (152 now).
3. Keep every REGRESSION test green. Do not touch HitSnap.gd / HitStun.gd / HitImpact.gd (HITSELL owns them), FootPlant.gd,
   RingFeet.gd, BeatClips.gd, Clinch.gd, nor the fight model (scripts/rules/*, scripts/state/*, scripts/world/*: another
   session is rebuilding it).

## Rules
- Real captures only (no Meshy, no MPFB, no generated motion). Bodies unchanged: male boxers bare-chested, women in singlets,
  everyone in boots.
- Files under 500 lines. Commit with clear messages. No edits to ops/, tools/run_tests.sh or any gate file.
- Run Godot headless only (`--headless --audio-driver Dummy`); nothing opens on screen. The dispatcher films before/after.

## Result lines (PR body)
RESULT: HEAD_TORSO main  live=<closest m> a=<worst m, frames < 0.20 per take> b=<deepest trunk deg per take> c=.. d=..
RESULT: HEAD_TORSO after live=... a=... b=... c=... d=...
RESULT: regression <pass/fail per test>

## Prior research
ops/research/INSIDE_WORK_S393.md (the blind test and the fault); GloveClear.gd S315/S316 comments (head and glove clears,
the SOFT_M knee, why horizontal only); BeatClips.gd S305/S310/S371 notes on the gut-shot takes; FIGHT_TESTS_S396.md.

## What would a human do?
A boxer hurt by a body shot folds forward, but her head lands beside his shoulder or on his chest and slides off; she leans
on him, she does not pass through him. An animator offsets the fold sideways at the hips and chest so the heads pass.

## Prefab check
No asset; a skeleton modifier change on clips already in the project.
