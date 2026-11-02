# S258 DIGEST (2026-10-19) - FIGHTMOTION1 step 1: one root writer per fight frame

Operator S257: "The 3d fight looks terrible torso twists weird legs fly not walk". Model: Opus.

## What now works (8f6ba01f, switch `single_root_solver` in GAME_ON)
- `FightWorldLiveScreen._solve_roots`: placement and every later pass (spacing, aim, overlap, contact_stop, rope clamp) keep
  computing their NEED, but only as a target. The bodies stay at last frame's drawn root while the clip is posed
  (`_hold_drawn_roots`), so the gait reads the travel the viewer saw. One writer after contact_stop: critically damped spring
  (omega 14), ROOT_ACCEL_MPS2 20, 1.8 m/s (= 3 cm per 60 Hz frame; strike lunge / combination keep their budget), then the
  fixed torso-radius floor. Overlap need is stateless (`_overlap_sep_ease` off under the solver). The gait strides at the
  drawn speed (`_solver_vel`), not the engine's.
- `FightStagePlayer`: `relock_feet_after_root` re-pins planted locked feet after the solver; gait <-> foot-lock handovers
  start from the feet as last shown (`_feet_world_last`) - the 6.6 m/s foot pop on a punch's first frame is gone.
- OFF path byte-identical (every change behind `single_root_solver` / `relock_after_root`).

## Evidence
Probe `tools/fight_motion_probe.gd` (seed 95501, as_game, 40 s, 1,200 frames per man), master -> solver:
| measure | master a/b | solver a/b |
|---|---|---|
| planted skate (new: no foot on the canvas still) | 315 / 333 | 186 / 161 |
| support skate (lower-foot rule) | 293 / 309 | 168 / 152 |
| root > 4 m/s | 8 / 9 | 0 / 0 |
| root > 1.5 m/s | 231 / 229 | 140 / 66 |
| hips < 0.70 m | 159 / 39 | 116 / 5 |
| feet > 0.95 m apart | 42 / 44 | 25 / 29 |
| slide (any down foot > 0.35 m/s) | 584 / 537 | 551 / 618 |
| twist > 50 deg (a) | 17 | 19 |
slide_b and twist_a ROSE. slide_b: frames where ONLY the gait's swing foot moved went 231 -> 462 (the legs now step; a 3.5 cm
lift is under the probe's 6 cm "down" line), planted-foot slides 306 -> 156 - the instrument reads a step as a slide. twist_a
+2 frames (boxing_jab_body 1 -> 5) - not explained, open.
- `tests/fight_root_single_writer_test.gd` (new): both arms in one run. `-- as_game`: OFF skate 0.245/0.217, fast 0.068/0.052,
  gap jitter 0.281 (breaks all three bounds); ON 0.145/0.068, 0/0, 0.072 (holds). Runner (plain): FIGHT_ROOT_SINGLE_WRITER failures=0.
- Regressions (run_tests --jobs 2, 14 tests: footwork_placement_carry, fight_room_ring_bounds, boxing_output, fight_room_no_teleport,
  fight_room_positions, fight_body_overlap, fight_stance_offset, fight_strike_whole, human2, fight_world_live, fight_hit_physics,
  fight_human_speed, footwork_beats_reach_room, game_switches): SUITE total=14 fails=0.
- Video: `previews/s258_fightmotion/s258_fightmotion_ab.mp4` (left master, right solver, 20 s, game camera) + frames
  every 2 s; on the review board (S258). VISUAL GATE OPEN - the operator closes it. Claude's read of the frames: at 4-6 s the red
  man still crouches low with bent knees in the solver take (hips), master shows a wide split at 4 s; both still merge torsos in
  exchanges (FIGHTGAP1).

## Not done (FIGHTMOTION1 step 2)
- Planted skate is 13-15%, the brief's goal is <= 5%. What is left (solver trace): gait mid-step 118 frames (support leg left
  behind at 1.8 m/s - IK shortfall - and slow creep at 0.2-0.4 m/s), whole punches ~140 (the engine moves a man DURING his
  punch while the lock holds both feet; past the 0.35 m unplant radius the foot springs). Next: hold the root still while a
  whole punch has both feet planted and make up the distance after (or step the lead foot with the lunge), and check the gait
  support leg reach at speed.
- Twist +2 frames, low hips at 6 s on the video.
- FIGHTGAP1 (torsos merge, engine 0.557 m) - measure again now.

## Also this session
- Arena SHOUTCAL1 round 2 launched (new chat 01a15165..., same PR #268): CI log read for it - shout_levers_wire_test HUNG at
  600 s, cohort cut to <= 40 bouts, wall-clock diagnostics out.
- Briefs: SHOUTCAL1 Contract block + ROUND 2; PREVIEWLOOK1 visual-gate block; NIGHTLYPARK1 Status DONE.
- PC memory: RED at 93% twice (Chrome 8 GB, Codex app 6 GB with 8 idle chat MCP pairs, ChatGPT 3 GB, Ziva editor 1.9 GB idle)
  - told the operator what each is.
