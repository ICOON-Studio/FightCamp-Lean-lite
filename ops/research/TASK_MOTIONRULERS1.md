# TASK MOTIONRULERS1 - main session (animation order): three fight-motion rulers red after S503/S504

Status: HELD (nightly review 2026-11-17, Claude). Discipline: boxing. Model: main session (Opus) or Ziva - fight motion.
Source: ops/AgentComms/nightly/suite_2026-11-17.log (commit a05c139ea). All three were green at the 2026-11-16 run (859acea5) and in S502's digest.

## What is red
- rokoko_clips_test: `rk_guard_b: leg snaps 2 <= raw 0`; `strafe_right: the clip carried her 0.11 m` (needs more than half the ask); `strafe_right while she travels: planted slide 0.341 m <= raw 0.209 + 0.05`.
- human_feet_test: `boxer 1 never stands under the canvas (deepest 4.1 cm, 1 frames)` (SINK_M bar).
- guard_knee_test: `boxer 0 held a guard for 5 frames` (MIN_GUARD_FRAMES 15). The knee readings themselves are inside the bar (lead mean -0.024, rear +0.028); the test ran out of settled guard frames to measure.

## Most likely causes (not bisected; read the diffs)
- 92e253e1b (S503 day 8, "a step lifts, travels, sets down": scripts/fight3d/BoxerFootwork.gd +43, RingFeet.gd): the strafe now travels less inside the clip and slides on a planted foot; the lifted step can set a foot 4 cm under the canvas for a frame; leg snaps on rk_guard_b. Fits rokoko_clips + human_feet.
- 96196cc48 (S503, "a paw and a feint on their own clocks": scripts/fight3d/GuardLife.gd +57): the paw/feint breaks the settled guard often, so boxer 0 had 5 settled frames out of 1320. Fits guard_knee.
- Less likely: 519bbd165 (S504 RingFeet/RingPlace one-line changes with the hit-stop).

## Contract
OWNS: scripts/fight3d/BoxerFootwork.gd, scripts/fight3d/RingFeet.gd, scripts/fight3d/GuardLife.gd
RED_TEST: tests/rokoko_clips_test.gd -> failures=0 (then the same for tests/human_feet_test.gd and tests/guard_knee_test.gd, REGRESSION)
REGRESSION: human_feet_test, guard_knee_test, knee_calm_test, boxer_footwork_test, range_breath_test, hit_step_test, fight_feel_test
VISUAL: yes - a fight still / film on the game camera after the fix (visual gate).

## Rules
- Never change a ruler's bar (SINK_M, MIN_GUARD_FRAMES, SLIDE_OVER_RAW_M, the raw table) to go green. If guard_knee's sample is the only problem (the paw/feint is wanted), the fix is that the paw/feint leaves the measured guard frames alone or the test samples the guard between paws - a main-session call, written down with the reason.
- Godot headless only, through `python ops/Tools/godot_slot.py run --who <seat> -- <godot cmd>`; watchdog first.

## Prior research
S503/S504 digests (feet slide 10.6 -> 0.40 m a round; wait beats). memory project_s503_feet_lift_wait_beats.

## What would a human do?
An animator would scrub the strafe and the lifted step frame by frame where the foot dips and the leg snaps, and fix the set-down, not the measuring stick.

## Prefab check
None: these are our own foot-lock and guard-idle layers.
