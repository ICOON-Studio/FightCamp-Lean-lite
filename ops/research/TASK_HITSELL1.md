# TASK HITSELL1 - QWEN (qwen3-coder) - a landed punch must read as landed, a blocked one as blocked

Status: OPEN (S397, Claude). Discipline: boxing (the live 3D fight). No BJJ, no walks (FIGHTWALK1 on Cursor owns CornerCrew).

## Contract
OWNS: scripts/fight3d/HitSnap.gd, scripts/fight3d/HitStun.gd, scripts/fight3d/HitImpact.gd, tests/hit_sell_test.gd
RED_TEST: tests/hit_sell_test.gd -> HIT_SELL failures=0
REGRESSION: hit_snap_gain_test, hit_flash_test, fight_polish_test, counter_cut_test, body_keep_test
VISUAL: yes

## Why
Operator S397: he wants agents working on animation all the time. Both blind judges, S396 (ops/research/FIGHT_TESTS_S396.md),
top fault of the whole fight: "Hits do not sell: no hit reaction strong enough to read a blow; up close a landed shot looks like
a blocked one". S396 already added the trunk giving way behind a head snap (HitSnap GIVE_*). On the broadcast lens it still reads
as nothing, and a block and a landed hook look the same in the pocket.

## Do
1. Read HitSnap.gd, HitStun.gd, HitImpact.gd and who calls them (grep scripts/fight3d for snap(, brace(, fold(, stun).
2. Write tests/hit_sell_test.gd FIRST (extends SceneTree, headless; drive the modifiers' own step functions on their frame clock the
   way tests/hit_snap_gain_test.gd does, or on a small Skeleton3D you build in the test). It prints `HIT_SELL failures=<n>`.
   Bars (do not loosen them later), measured from contact over 0.35 s:
   a. a landed head shot moves the head (Head bone, world) at least 2.5x as far as a blocked head shot of the same punch;
   b. a blocked head shot moves the head no more than 0.04 m; the gloves take it (the guard arm gives, the head does not);
   c. a landed power shot (cross, hooks, uppercuts) turns the head at least 25 deg and a jab at least 10 deg, peak inside 0.06 s
      (fast in, slow out: back to 20% by 0.35 s);
   d. a landed body shot folds the trunk toward the hit side at least 8 deg; a blocked one (elbow brace) at most 3 deg;
   e. nothing pops: no bone rotates more than 30 deg between two frames at 60 fps.
   Run it on main first; it must be red on main for a, b or c. Put the before numbers in the PR body.
3. Make it green inside the OWNS files. Ideas, your choice: a blocked shot drives the guard glove back into the face and the
   forearm, not the head; a landed one skips that and gives a bigger, faster head turn plus the trunk give; a short hit-stop
   (2-3 frames) only on landed shots (HitStun); keep the warm flash rule (HitImpact) for big shots only.
4. Keep every REGRESSION test green. Files stay under 500 lines.

## Rules
- No new clips or generated motion; this is code on the skeleton. Do not touch FootPlant.gd, RingFeet.gd, CornerCrew.gd,
  RingCamera.gd, HudBars.gd. No edits to ops/, tools/run_tests.sh or gate files.

## Result lines (PR body)
RESULT: HIT_SELL before (main) a=<ratio> b=<m> c=<deg power/jab, peak s> d=<deg landed/blocked> e=<max deg/frame>
RESULT: HIT_SELL after  a=... b=... c=... d=... e=...
RESULT: regression <pass/fail per test>
