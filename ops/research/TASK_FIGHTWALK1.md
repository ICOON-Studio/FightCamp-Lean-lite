# TASK FIGHTWALK1 - CURSOR (Composer 2.5, Fast OFF) - the walks around the fight, 5.5 -> 7

Status: OPEN (S397, Claude). Discipline: boxing (the ring walks: corner to centre, centre to corner, the corner crew). No BJJ, no gym floor.

## Contract
OWNS: scripts/fight3d/CornerCrew.gd, tools/walk_cycle.gd, assets/anim/baked/ow_walk.res, tests/fight_walk_test.gd
RED_TEST: tests/fight_walk_test.gd -> FIGHT_WALK failures=0
REGRESSION: fight_polish_test, corner_warm_test, foot_plant_test, corner_lens_test, ring_feet_test
VISUAL: yes
FILM: --resolution 1920x1080 --script res://tools/corner_film.gd -- E:/FightCamp/tmp/fightwalk1 film

## Why
Operator S397: "are the walking animations progressing? is anyone working constantly on animation as i have asked".
Blind judges, S396 (ops/research/FIGHT_TESTS_S396.md): walking 5 -> 5.5. Boxers walk on ow_walk, a real capture
(CMU 07_01, tools/walk_cycle.gd), joined from the guard over 0.8 s (S396). What still reads wrong:
- The corner crew (coach, seconds, cutman) still walk on af_walk (CornerCrew.gd line ~167), which limps on our bodies (S377).
- `turn()` turns a body on the spot: the feet do not step, so it reads as a spin on ice.
- knockdown_film "he steps to the corner, the planted foot holds": slide p90 1.45 m/s (S379), never fixed.
- The walk start and stop: ground speed and leg cycle can disagree at the ends (skate).
- ring_feet_test FAILS ON CI since the S396 walk ease-in (1734190e): "a director's walk arrives (0 frames left)" and "... on its
  mark" (run 42369396937), while it passes on this PC: the eased-in walk now arrives on the last frame of the test's budget, so a
  slower machine misses. Fix the cause in the walk (arrive with margin), not the test's budget.
- One cycle, one speed: a tired boxer after round 3 walks to her corner exactly like a fresh one.

## Do
1. Write tests/fight_walk_test.gd FIRST, headless (extends SceneTree; build a CornerCrew on a bare Node3D stage the way
   FightView does, two boxers and the crew, then call walk()/turn() and step the tree). It prints `FIGHT_WALK failures=<n>`.
   Bars (do not loosen them later):
   a. planted foot: while a foot is the support foot of ow_walk, its world position slides p90 < 0.12 m/s, max < 0.30 m/s;
   b. start and stop: over the first and last 0.8 s of a walk, the same bar as (a);
   c. a turn of 60 deg or more moves the feet (each foot changes position by at least 0.08 m) and no foot slides past bar (a);
   d. no crew member plays af_walk or af_walk_carry for a walk (only the real capture or a capture cut from it);
   e. a walk's ground speed stays within 10% of the playing clip's own ground speed times its rate (no skate, no moonwalk).
   Run it on main first and write the red numbers into the PR body (it must be red on main for a, c or d).
2. Make it green: the crew walk on ow_walk (carry: keep the arms from the carry take only, the legs from ow_walk, or slow ow_walk
   for the stool carry); turns become a step turn (a short walk on an arc, or two in-place steps from ow_walk's own frames);
   the start/stop joins keep ground speed tied to the leg phase.
3. Tired walk: when the boxer's legs are tired (read how HudBars / tired legs read it, scripts/rules/TiredLegs.gd or what the corner
   strip uses), the walk to the corner runs at a lower rate (about 0.8 of today's) with the head a little lower. Same bars hold.
4. Keep every REGRESSION test green. Do not touch FootPlant.gd, RingFeet.gd, RingCamera.gd, HudBars.gd (other owners).

## Rules
- Real captures only (no Meshy, no MPFB, no generated motion). CMU clips need the credit line (already in assets/data/credits.json).
- Male boxers bare-chested, women in singlets, everyone in boots: do not change the bodies.
- Files under 500 lines; if CornerCrew.gd would pass 500, move the walk into scripts/fight3d/CrewWalk.gd and add it to OWNS
  in your PR body (Claude approves).
- Commit with clear messages. No edits to ops/, tools/run_tests.sh or any gate file.

## Result lines (PR body)
RESULT: FIGHT_WALK before (main) a=<p90/max> b=<..> c=<..> d=<..> e=<..>
RESULT: FIGHT_WALK after  a=... b=... c=... d=... e=...
RESULT: regression <pass/fail per test>
