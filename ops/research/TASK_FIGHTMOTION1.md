# TASK_FIGHTMOTION1 - one root writer per frame: the boxers stop skating, breathing and jumping

Model: Claude Opus (design-heavy rewrite of a hot path; the operator's top visual defect). Discipline: boxing (demo).
Raised by the operator S257 (2026-10-19): "The 3d fight looks terrible torso twists weird legs fly not walk".

## Evidence (S257, read on the live fight, seed 95501, as_game, 40 s, both men)
Instrument: `Godot/tools/fight_motion_probe.gd` (new, committed S257). Run:
`Tools\godot_hidden.ps1 --path Godot --script tools/fight_motion_probe.gd --fixed-fps 30 -- as_game seconds=40 [trace_from=4.0 trace_to=4.7] [off=<switch>]`

| measure (1,200 frames per man) | a | b |
|---|---|---|
| support (lower) foot moving > 0.25 m/s on the floor = SKATE | 293 (24%) | 309 (26%) |
| drawn root > 1.5 m/s | 231 | 229 |
| drawn root > 4 m/s (0.13 m in one frame; settled cap is 3 cm) | 8 | 9 |
| hips < 0.70 m above the lower foot | 159 | 39 |
| feet > 0.95 m apart (split) | 42 | 44 |
| mean drawn root speed | 0.75 m/s | 0.74 m/s |
Per clip the skate is worst inside punches: cross 44/67 frames, rear hook 35/51, lead hook 44/76, jab 68/180.

Root cause, traced per stage with `debug_stage_observer` (probe prints FIGHT_MOTION_STAGES):
- t=4.00-4.37 the ENGINE has both men standing still (eng_v 0.00, gap 0.557 m) while the DRAWN gap swings 0.61 <-> 0.83 m frame to
  frame: `_refuse_overlap_on_placed` (FightWorldLiveScreen.gd ~4018) sees the pair clear at the gap the separation just bought,
  targets 0 and gives back 5 cm; `_correct_refused_overlap` (~4315) later in the same frame finds them overlapping and buys it back.
- t=4.50-4.67 `contact_stop` moves the pair 0.16-0.20 m in ONE frame (6 m/s).
- 40 s stage totals (metres moved, both men): advanced (placement) 76.5, placement_cap 30.3, overlap 23.1, contact_stop 9.5,
  placement_cap_finish 9.2. The passes undo each other; the end-of-frame cap does not hold the settled 3 cm.
- A one-line hold on the separation release (S257 trial, reverted) made it WORSE (placement_cap 30 -> 83 m, root > 4 m/s 8 -> 17):
  the fight is between owners, not inside one of them. Do not patch one pass again.
- The engine itself keeps the pair at 0.557 m centre-to-centre in exchanges - chest to chest. FIGHTGAP1 (torsos merge) is the same
  defect seen from the camera.

## Prior research
- `topics/contact_collision.md` SETTLED: "No body teleports: a 3 cm / 10 deg per-frame cap on any root write" - this task makes it TRUE.
- `AUDIT_ANIM_S224_CODEX.md` s"call graph": "several independent owners of hips, arms, legs and wrists"; its proof method (per-writer
  deltas, toggle the first offending owner) is what the probe's stage log does.
- `LUDO_ANIMATION_S192.md` round 9: root from the sim capped 3 cm / 10 deg per frame; procedural shuffle legs.
- S255 digest: the both-boxers-sit-down fix (footwork placement carry, 480806ba) - keep its test green.
- `topics/footwork.md` for the gait (FightFootLock.push_pull, HUMAN2).

## What would a human do?
Shipped fighting/sports games (Fight Night, Undisputed, EA UFC) have ONE character mover per frame: the gameplay position is a target,
the mover follows it with a speed + acceleration limit (a critically damped spring), separation is a hard constraint inside that mover
(fixed body radii, not a per-frame posed-mesh tug), and the legs are driven from the mover's FINAL velocity (stride-matched
locomotion + foot IK). Nothing writes the root after the feet are planted.

## Prefab check
Godot 4 has no fighting-game root mover in the Asset Library; CharacterBody3D move_and_slide does not fit (no physics bodies here).
The spring is ~20 lines (`spacing_step` at ~3822 is already a zeta=1 spring - reuse it). No licence question.

## Spec
1. `FightWorldLiveScreen._process` keeps every pass that computes WHERE a body should be (engine track, strike warp, stance offset,
   rope clamp, overlap need, contact stop need), but they write a per-side TARGET/correction into one frame record instead of
   `_node_x.position`.
2. ONE solver (`_solve_roots(delta)`, new) runs once, after `_advance_bodies` has posed the bodies for this frame:
   target = engine spot + warp + stance offset; separation = max(engine gap, torso floor from FIXED capsule radii + the overlap
   need measured on THIS frame's pose), applied as a constraint on the pair, never as an eased value fed back into the next frame;
   move each root toward its target with a speed cap (boxing footwork: 1.8 m/s; strike lunge budget as today) and an
   acceleration cap (ROOT_ACCEL_MPS2), plus the settled 3 cm / 10 deg per-frame cap.
3. The gait (`_advance_human_shuffle`) and `_carry_shuffle_plants` read the solver's final root - nothing moves the root after them.
4. Switch `single_root_solver` in GameSwitches.GAME_ON (operator S221: new features ship ON); plain `--script` tests stay the OFF arm.
5. Engine spacing (0.557 m in exchanges) is FIGHTGAP1 - measure it after 1-4 and only then decide with Ludo whether the engine's
   range is wrong; do not change FightRealtime here.

## Contract
OWNS: Godot/scripts/FightWorldLiveScreen.gd, Godot/scripts/FightStagePlayer.gd, Godot/scripts/GameSwitches.gd, Godot/tests/fight_root_single_writer_test.gd, Godot/tools/fight_motion_probe.gd
RED_TEST: Godot/tests/fight_root_single_writer_test.gd -> FIGHT_ROOT_SINGLE_WRITER failures=0
REGRESSION: footwork_placement_carry_test, fight_room_ring_bounds_test, fight_contact_stop_test, boxing_output_test
VISUAL: yes

Contract notes (not parsed): FightWorldLiveScreen.gd is 6,678 lines - NEVER read whole; windows: _process 1930-2105,
_place_whole_bodies ~3600-3700, _place_bodies/_write_gap_positions 3708-3800, _finish_root_frame/_ease_root_speed 3863-3930,
overlap 4003-4100 and 4315-4390, contact_stop ~4870+; FightStagePlayer.gd shuffle section 3880-4060; GameSwitches.gd one key.
The red test: live room, seed 95501, 20 s, as_game switches - support-foot skate frames <= 5% per man, drawn root never > 0.03 m
in one 60 Hz frame outside a strike lunge, drawn-gap change <= 1 cm/frame on frames where the engine gap changed < 2 mm; red on
master (24% skate, 0.2 m jumps), green with the switch. Check each REGRESSION name exists (Glob) and add the room tests that call
_place_bodies (rule_guard caps --only at 40). VISUAL: visual-gate skill - red first on the shipped clip (s255_punch_timing_ab.mp4
shows the skate and the merge), a 20 s game-camera video --fixed-fps 30 before/after + stills via still_framing.save_if_framed
(guard and mid-punch), feet frame by frame; the operator closes it on the review board.

## VISUAL GATE
Paste the brief block from `.claude/skills/visual-gate/SKILL.md` at the start of the session that takes this task, and run it in order:
red on the shipped clip, game-camera stills via still_framing, gap/noses/wrists/feet per still, the operator closes it.

## Trap
The passes exist because each one fixed a seen defect (teleports S132, sit-down S255, hands through heads C191). Keep each one's NEED,
move only its WRITE. Run the probe after every step; a step that raises any probe number is reverted, not tuned.
