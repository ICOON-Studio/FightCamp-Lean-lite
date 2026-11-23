# TASK MOTIONRULERS1 - main session (animation order): three fight-motion rulers red after S503/S504

Status: DONE S540 (the three rulers measure the old player: out of the nightly list; player2_test in, with a FLOOR row - docs/MOTIONRULERS1_RESULT.md). Was OPEN (S540: Fable reset, owner "keep going"; was HELD (nightly review 2026-11-17, Claude). Discipline: boxing. Model: main session (Opus) or Ziva - fight motion.
Source: ops/AgentComms/nightly/suite_2026-11-17.log (commit a05c139ea). All three were green at the 2026-11-16 run (859acea5) and in S502's digest.

## What is red
- rokoko_clips_test: `rk_guard_b: leg snaps 2 <= raw 0`; `strafe_right: the clip carried her 0.11 m` (needs more than half the ask); `strafe_right while she travels: planted slide 0.341 m <= raw 0.209 + 0.05`.
- human_feet_test: `boxer 1 never stands under the canvas (deepest 4.1 cm, 1 frames)` (SINK_M bar).
- guard_knee_test: `boxer 0 held a guard for 5 frames` (MIN_GUARD_FRAMES 15). The knee readings themselves are inside the bar (lead mean -0.024, rear +0.028); the test ran out of settled guard frames to measure.

## Most likely causes (not bisected; read the diffs)
- 92e253e1b (S503 day 8, "a step lifts, travels, sets down": scripts/fight3d/BoxerFootwork.gd +43, RingFeet.gd): the strafe now travels less inside the clip and slides on a planted foot; the lifted step can set a foot 4 cm under the canvas for a frame; leg snaps on rk_guard_b. Fits rokoko_clips + human_feet.
- 96196cc48 (S503, "a paw and a feint on their own clocks": scripts/fight3d/GuardLife.gd +57): the paw/feint breaks the settled guard often, so boxer 0 had 5 settled frames out of 1320. Fits guard_knee.
- Less likely: 519bbd165 (S504 RingFeet/RingPlace one-line changes with the hit-stop).


## S540 first step (the METHOD line: fight animation = FIGHTPLAYER2, no new correction layer in scripts/fight3d)
Today's nightly reds are rokoko_clips_test, human_feet_test, head_aim_test (guard_knee_test is green again). FIRST establish
which player each test drives: the shipped v2 player (scripts/fight3d/v2/) or the retired path. A test of the retired path is
retired (moved out of the nightly list with a line saying why), not patched. A test of v2 is bisected (git bisect over the
range since its last green nightly) and fixed at the cause in v2 - never a new correction layer on top. Visual gate as above.

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

## Added 2026-11-18 (nightly review, suite_2026-11-18.log, commit 902d6948d)
- head_aim_test now red too: `A_A_lv jab depth flat_diff=0.236 > 0.200` (aimed flat 0.405 vs no-aim 0.169; the other 11 rows pass).
  Green on 2026-11-17. Most likely f9089b106 (S510 anim loop r14: "gloves nearer the face", glove in flight 3-4 frames) - the
  no-aim jab's flat reach dropped, the aimed one did not. Not bisected.
- rokoko_clips: now only the planted slide row (0.309 m <= raw 0.209 + 0.05); the leg-snap and travel rows pass. human_feet still red.
  guard_knee is green again.
- Still HELD: CLAUDE.md item 8 METHOD - fight animation is FIGHTPLAYER2; no new fix layer in scripts/fight3d until it is built.
  These rulers measure the old player; decide with the FIGHTPLAYER2 work whether they are fixed, moved to v2 or retired.

## Added 2026-11-22 (NIGHTFIX537, S538)
- The likely causes above are ruled out by their own control arms: `-- oldswing` leaves human_feet (4.0 cm) and the strafe slide
  unchanged, `-- oldflight` / `-- oldguard` leave head_aim at 0.235 / 0.227. Bisect instead. Details: docs/NIGHTFIX537_RESULT.md.
- human_feet_test now runs at FIXED_FPS 30 in the runner and names the move: pro_left_hook_v2 -> guard, 4.0-4.4 cm, 1-2 frames.
