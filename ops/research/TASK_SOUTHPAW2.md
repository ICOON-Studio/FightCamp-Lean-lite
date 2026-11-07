# TASK SOUTHPAW2 - CURSOR (GPT-5.6 Sol High) - the guard knock-knee, round 2: a test that FAILS on main first

Status: OPEN (S399, Claude main). Rework of SOUTHPAW1 (PR #74, NOT merged, closed). Discipline: boxing.

## Why round 1 was not kept (measured S399)
- Its tests/southpaw_legs_test.gd PASSES ON MAIN unchanged: south knock_in=0.017, knee_gap 0.39 vs ankle_gap 0.48 - all bars
  ok. The brief said main must FAIL. A test that passes before the fix proves nothing.
- Its fix is a no-op: negating `fl` flips the sign of `n`; the plane n.(knee - t) = 0 is the same plane, and t1/t2 just swap
  (phi -> phi+PI, ac -> PI-ac), so the smaller |th| picks the same knee. Argon after-film: "can't confirm the southpaw fix".
- Its `knock_in` measured the ANKLE's offset from the hip. Knock-knee (valgus) is the KNEE falling inside the hip -> ankle line
  while the feet stay wide - exactly what E:/FightCamp/tmp/fighterlook/legs_diag.jpg shows (blue top-middle: knees nearly
  touching, ankles wide). Argon on the main film: "both boxers, blue most clearly, stand knock-kneed in their guard poses
  (0:21, 0:30, 0:51)" - so it may not be southpaw-only.

## Round 2 - do in this order
1. MEASURE RIGHT. Per leg per frame: H = upper-leg (thigh) bone origin, K = knee (shin bone origin), A = foot bone origin, all
   global. Work in the boxer's frontal plane (drop the component along her facing). valgus = signed distance of K from the line
   H->A in that plane, POSITIVE toward her midline (toward the other leg's hip). Bar b: valgus <= 0.03 m every frame in guard.
   Also print knee_gap / ankle_gap (a knock-knee reads < 0.75).
2. REPRODUCE ON MAIN before any fix: build the scene the way tools/fighter_look_still.gd does (branch
   claude/fighter-look-4bc1d9; `git show origin/claude/fighter-look-4bc1d9:tools/fighter_look_still.gd`) - the same two boxers,
   the same stage, the same clips - and the film setup (`tools/fight3d_film.gd ... short`, frames around 0:21 / 0:30 / 0:51).
   The test must print a FAILING valgus for blue on main. Write main's numbers (blue AND red) in the PR body. If you cannot make
   main fail, STOP and say so in the PR body with the numbers - do not fix anything.
3. Only then find the cause (file:line) and fix it inside OWNS. If red fails too, the cause is not the southpaw path: look at the
   knee pole / bend plane for both sides (the guard clip's own knee bend vs the rig's solve). If the cause is outside OWNS, name it
   and stop.

## Contract
OWNS: scripts/fight3d/BoxerFootworkRig.gd, scripts/fight3d/BoxerFootwork.gd, tests/guard_valgus_test.gd
RED_TEST: tests/guard_valgus_test.gd -> GUARD_VALGUS failures=0
REGRESSION: ring_feet_test, foot_plant_test, boxer_footwork_test, fight_polish_test, corner_warm_test, knee_track_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/southpaw1 short

## What round 1 started from (measured by the S398 "Fighter look" session, tools/fighter_look_still.gd on branch claude/fighter-look-4bc1d9)
A SOUTHPAW boxer standing in her guard at rest on main is knock-kneed: knees touching, feet almost in one line (still:
E:/FightCamp/tmp/fighterlook/legs_diag.jpg - blue). Isolated: the same Maria as ORTHODOX stands normally; with `nofeet` (no
FootPlant) normal; with `nofootwork` (no S391 footwork rig) normal. So it is the S391 footwork rig's southpaw path, the rig
(BoxerFootworkRig) over FootPlant, in the leg / knee solve for the mirrored side. BoxerFootwork's plan mirrors fine: offset(),
foot_yaw() and the rig's leg order [1,0] for side < 0 were checked. Suspects to check (not guesses to act on): `_legs` is built in
the order [1,0] for a southpaw (BoxerFootworkRig.gd ~87) - every later use of `_legs[i]` vs `plan.feet[i]` / `p["feet"][i]` must
pair the same leg with the same foot; `_solve` (~213-260) puts the knee "over the foot's line" from the foot's sideways axis `n`
(cross with UP) and picks t1/t2 - a sign that assumes the left leg leads would fold a southpaw's knees in; `_reach_pitch`.

## Do
1. Write tests/guard_valgus_test.gd FIRST, headless (FightStage + two real boxers as tests/ring_feet_test.gd builds it, the rig
   on, stage processing, AnimationPlayers advanced on a fixed clock), one boxer orthodox and one southpaw, both in their guard at
   rest for 4 s, then in the pocket for 4 s. Every frame, per boxer, from the pose AS SHOWN: knee gap (distance between the two
   knee bones), ankle gap, stance width (feet apart across her facing) and length (along it), and each knee's offset from the
   line hip -> ankle (in = toward the other leg). Bars (main must FAIL them for the southpaw):
   - a. the southpaw's knee gap, stance width and length are each within 15% of the orthodox boxer's (same body: run Maria
     both ways, as the look session did);
   - b. no knee falls inside the hip -> ankle line by more than 0.03 m (no knock-knee) for either stance;
   - c. the knee gap is never under 0.18 m in guard at rest;
   - d. the orthodox boxer is unchanged from main (all its numbers within 2%).
   Print the numbers per stance; write main's numbers in the PR body.
2. Fix the cause in the rig's southpaw path (inside OWNS). Say in the PR body exactly which line paired the wrong leg / sign.
3. Keep every REGRESSION test green. Run the tests yourself (your shell works: the dispatcher hides Claude's hooks from Cursor).
   Do not touch FootPlant.gd, RingFeet.gd, KneeTrack.gd, CornerCrew.gd, CornerMinute.gd, the fight model (scripts/rules,
   scripts/state, scripts/world), ops/ or tools/run_tests.sh. Do not loosen any bar (S397: a seat filtered samples out of its own
   bars to pass - that round was not kept).

## Rules
Real captures only. Bodies unchanged (men bare-chested, women in singlets, everyone in boots). Files under 500 lines. Headless.

## Result lines (PR body)
RESULT: GUARD_VALGUS main  ortho knee_gap=.. width=.. length=.. | south knee_gap=.. width=.. length=.. knock_in=..
RESULT: GUARD_VALGUS after ...
RESULT: cause <file:line> <one line>
RESULT: regression <pass/fail per test>

## Prior research
BoxerFootworkRig.gd / BoxerFootwork.gd S391-S392 notes; tests/ring_feet_test.gd, tests/knee_track_test.gd; tools/fighter_look_still.gd
(branch claude/fighter-look-4bc1d9) for the stills.

## What would a human do?
Stand a southpaw next to an orthodox and mirror one in their head: the same width, the same knees over the toes.

## Prefab check
No asset.
