# TASK FIGHTWALK2 - CURSOR (Composer 2.5, Fast OFF) - round 2: walks that arrive, a corner crew that works

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (ring walks, the corner minute). No BJJ, no gym floor.
Round 1 (FIGHTWALK1, PR #66, branch cursor/fightwalk1, commit c0eeab59) is NOT kept: read why below.

## Contract
OWNS: scripts/fight3d/CornerCrew.gd, scripts/fight3d/CornerMinute.gd, scripts/fight3d/CrewWalk.gd, tools/walk_cycle.gd,
  tests/fight_walk_test.gd
RED_TEST: tests/fight_walk_test.gd -> FIGHT_WALK failures=0
REGRESSION: fight_polish_test, corner_warm_test, foot_plant_test, corner_lens_test, ring_feet_test, crowd_room_test
VISUAL: yes
FILM: --resolution 1920x1080 --script res://tools/corner_film.gd -- E:/FightCamp/tmp/fightwalk2 film

## Why round 1 failed (Claude measured it, then watched both films)
1. THE BOXER NEVER WALKS. Round 1 sent a boxer's ow_walk through `RingFeet.walking()`. That function only moves `walk_at`
   while it is less than WALK_LEAD_M (0.35 m) ahead of the guard-step rig's planned feet, and the rig does not step while
   ow_walk plays, so she walks on the spot forever. Probe (same harness on both trees, 60 fps): main walks her 3.0 m in
   3.55 s at 0.95 m/s top; round 1: 0.00 m in 10 s. Film (ops/previews/dispatch/FIGHTWALK1/after.mp4): her stool is empty
   at 1:48.5 and 1:59-2:00, she slumps mid-ring beside the blue boxer at 1:55-2:01 (main: on her stool, water at 1:50).
2. THE CREW DASH, THEN STICK. `stride = maxf(stride, dist / ARRIVE_FRAMES)` has no delta in it: every frame the coach covers
   10% of what is left. Probe: the coach's 2.0 m walk starts at 12 m/s, covers 1.8 m in 0.7 s, then stops 0.06 m short
   (the `dist > 0.06` floor and the arrival snap never meet) and plays ow_walk on the spot for good. Main: 2.0 m in 2.17 s at
   0.92 m/s. The boxer branch has the same catch-up (`dist < 0.6: spd = dist / (ARRIVE_FRAMES * delta)`): a 3.6 m/s lunge.
3. THE TEST MEASURED NOTHING. On round 1's branch every boxer bar read 0.000 (a, b, e, tired walk) because she never moved;
   bar e compared her speed with the playback rate the code itself sets, so it could not fail; no bar measured the crew.
4. Round 1 deleted the S-tagged "why" comments in CornerCrew.gd. Keep every existing comment; add your own the same way.

Worth keeping from round 1 (take it with `git checkout origin/cursor/fightwalk1 -- <file>` and fix it, or rewrite):
`WalkCycle.staff_stride()` (crew ground travel read from ow_walk's own root travel via StepRoot - the right idea), the
tired-legs rate (0.8x + TiredSag), the step turn on an arc for turns of 60 deg or more.

## Do
1. FIX THE TEST FIRST (tests/fight_walk_test.gd; round 1's file is the start). Every bar measures node and foot positions,
   never `speed_scale`. Bars (do not loosen them later):
   - LIVE (guard bar, must pass on main too): a boxer told to walk 2.0 m travels at least 1.9 m and arrives within 0.05 m
     of her mark in at most 1.3 x (2.0 / her clip's ground speed x rate) + 1.0 s; the same for the coach, the second and the
     cutman. Print metres travelled and seconds for each.
   - a. planted foot: while a foot is the lower foot of ow_walk, its world slide p90 < 0.12 m/s, max < 0.30 m/s, over at
     least 40 samples on a walk where each foot travels at least 1.0 m (print samples and foot travel).
   - b. start and stop: the first and last 0.8 s of each walk, the same bar as (a).
   - c. a turn of 60 deg or more moves each foot at least 0.08 m, no foot slides past bar (a).
   - d. no crew member plays af_walk or af_walk_carry for a walk.
   - e. ground speed, EVERY walker (boxers and crew): node speed p95 <= 1.15 x and max <= 1.3 x the clip's own ground speed
     x its rate at that frame (the root travel of ow_walk: StepRoot / tools/walk_cycle.gd), from the first frame to the
     arrival. No catch-up at the end.
   - f. the corner minute (CornerMinute, both corners): the coach never plays af_idle_foldarms; for at least 70% of the
     minute the coach stands or crouches within 0.9 m of the seated boxer's head, facing her (yaw off her by under 35 deg),
     and plays at least 2 different working clips over the minute (talk, crouch, nod, interact - clips already in the
     project; corner_probe.gd lists them). The second works too (water, towel, the stool), not a still idle.
   Run it on main first and write main's numbers into the PR body: LIVE and e must PASS on main (main's walks arrive at a
   true speed), d and f must FAIL on main.
2. Make it green. Boxers: keep main's ow_walk path (a plain stride eased in with the join, S395/S396), not RingFeet.walking.
   Crew: ow_walk with ground travel from the clip's own root travel (staff_stride), arriving on the mark with the clip's last
   step, not a catch-up. Carry: slower ow_walk (or the carry take's arms over ow_walk's legs). Step turns. Tired walk 0.8x.
3. The corner minute: replace the folded-arms coach (CornerMinute.gd ~line 205: `af_idle_foldarms` for red) with a coach
   who works on her: crouched or bent in front of her at the stool, talking, a nod; the second hands water / wipes from the
   apron. Real captured clips only (the af_* set and ow_walk). If CornerCrew.gd would pass 500 lines, move the walk code
   into scripts/fight3d/CrewWalk.gd (owned above).
4. Keep every REGRESSION test green. Do not touch FootPlant.gd, RingFeet.gd, RingCamera.gd, CornerShots.gd, HudBars.gd
   (other owners), nor the fight model (scripts/rules/*, scripts/state/*, scripts/world/*: another session is rebuilding it).

## Rules
- Real captures only (no Meshy, no MPFB, no generated motion). CMU clips keep their credit line (assets/data/credits.json).
- Male boxers bare-chested, women in singlets, everyone in boots: do not change the bodies.
- Files under 500 lines. Commit with clear messages. No edits to ops/, tools/run_tests.sh or any gate file.
- Run Godot headless only (`--headless --audio-driver Dummy`); nothing opens on screen. The dispatcher films before/after.

## Result lines (PR body)
RESULT: FIGHT_WALK main  live=<m, s per walker> a=<p90/max/n> b=.. c=.. d=.. e=<p95/max per walker> f=..
RESULT: FIGHT_WALK after live=... a=... b=... c=... d=... e=... f=...
RESULT: regression <pass/fail per test>

## Prior research
ops/research/FIGHT_TESTS_S396.md (blind judges: walking 5.5, "the coach stands with folded arms and does no work on her");
TASK_FIGHTWALK1.md; S395/S396 ow_walk notes in CornerCrew.gd comments.

## What would a human do?
A cornerman is through the ropes before the boxer sits: stool down, coach crouched in front of her eye to eye, talking fast,
a hand on her knee or glove; the second gives water and grease from the apron. Nobody stands with folded arms in the minute.

## Prefab check
No new asset: ow_walk (CMU 07_01) and the af_* corner clips are already in the project.
