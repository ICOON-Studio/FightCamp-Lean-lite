# TASK LOCOWALK4 - CURSOR - the forward walk and the four guard steps, from the Ludo presets already downloaded

Status: OPEN (S379, Claude). Operator S377 on the fight's legs: "their legs dont really move they slide across", "the knees
seem to be trembling". Round 3 of LOCOWALK1/2 (LOCOWALK3 = Claude's collect of round 2).

## What round 2 (LOCOWALK2, yours) delivered and what was collected (S379, claude/locowalk3)
- `walk_back_guard` WORKS: Ludo's captured walk_backward on our boxer, tools/locowalk_bake.gd (its hips + legs,
  mc_Box1_M3_Idle's guard arms), StepRoot travel 0.75 m a loop, hips 0.049 m low. In the knockdown count the planted foot
  now HOLDS (drawn slide p90 0.34 -> 0.00 m/s). Collected with KnockdownCount.WALK_SPEED 1.0 (0.6 crept 0.24 m/s and the
  walker never reached the neutral corner).
- LEFT OUT (failed your own `locowalk_bake.gd -- bars`): walk_guard travel 0.169 m a loop, walk_relaxed 0.018 m (it does
  not walk at all), step_in_guard 0.387 m, step_out_guard 0.506 m (want 0.25-0.35), and every step clip read 13,228 bytes -
  check they are not the same clip.
- The bars' `knee_worst` compares a LOCAL knee rotation axis with a world hip axis - not the same space, so its number means
  nothing; replace it with the drawn knee check below.

## Your job
1. `walk_guard` - walking FORWARD, hands up (he comes back out after BOX!): from the downloaded `walk_forward` or
   `walk_confident` preset in E:/FightCamp/wt/LOCOWALK2_ludo/ (no new Ludo credits unless both fail - then at most 4).
   Find why its StepRoot travel reads 0.17 m a loop when walk_backward reads 0.75 (in-place crop? the foot the bake
   reads? a loop cut too short?) and fix the BAKE, not the bar. Bar: travel 0.5-1.5 m a loop, hips <= 0.08 m low.
2. The four guard steps `step_in_guard`, `step_out_guard`, `step_left_guard`, `step_right_guard` from `backstep`,
   `strafe_left`, `strafe_right` and `walk_forward` (one step cut out of each, stance kept: the near foot steps, the other
   follows). Bar: StepRoot travel 0.25-0.35 m each, hips <= 0.08 m low, four DIFFERENT clips (print a per-clip hash).
3. A drawn knee check in `locowalk_bake.gd -- bars`: the knee angle per frame from the drawn bones (the skeleton after its
   modifiers - read on `skeleton_updated`, as tools/knockdown_film.gd `_watch` does), jerk p95 <= 4.5 deg/frame^2 and
   direction flips <= 1.5 a second while the clip plays in place.
4. `tests/locowalk_bars_test.gd` (headless, extends SceneTree): runs the bars of walk_back_guard, walk_guard and the four
   steps and prints `LOCOWALK failures=<n>` - your RED_TEST.
5. Do NOT wire any of these into Footwork, KnockdownCount or the fight (FIGHT9's files on agy right now). Deliver the
   baked .res files, the bake tool and each clip's bar line in your output.

No clip is generated, keyed or built in code - every .res comes from a Ludo GLB through the bake. If a shell call fails,
stop and write the exact error at the top of your output.

## Contract
OWNS: assets/anim/baked/walk_guard.res, assets/anim/baked/step_in_guard.res, assets/anim/baked/step_out_guard.res, assets/anim/baked/step_left_guard.res, assets/anim/baked/step_right_guard.res, tools/locowalk_bake.gd, tests/locowalk_bars_test.gd
RED_TEST: tests/locowalk_bars_test.gd -> LOCOWALK failures=0
REGRESSION: beat_clips_test, golden_path_test
VISUAL: no
BASE: claude/locowalk3
