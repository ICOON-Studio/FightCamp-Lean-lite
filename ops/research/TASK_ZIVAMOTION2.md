# TASK ZIVAMOTION2 - the overlap fix stops dragging planted feet, and the two as_game reds it sits beside go green (boxing)

Model: Ziva Smart, reasoning MAX (wt/ZIVA, branch ziva/playtest). Discipline: BOXING (demo).

## Why
S267 collected ziva/playtest on master (96e16bd6): six switches ON. Ziva's own census says `overlap_in_takes` costs the feet:
planted p95 34.7 -> 204.8 mm (the separation drags a planted foot up to one 50 mm cap before the next frame re-pins). A planted
foot sliding 20 cm is the skate the operator called out in S257 ("legs fly not walk"). Two as_game tests are red on master WITH
and WITHOUT the merge (Claude's control run S267):
- `tests/fight_body_overlap_test.gd`: "no refused penetration in 900 frames (worst 0.3178 m leg=leg at frame 627)".
- `tests/fight_world_live_test.gd`: footwork beats counted 0 (walk / stance degrade readouts) and "the bout reached its end inside
  600 steps" FAILS.

## Items (one at a time, a commit each, red number first)
1. OVERLAP WITHOUT SKATE: keep `overlap_in_takes`' gain (census 220 -> <= 192 frames over 20 mm, worst <= 0.27 m) AND bring
   planted p95 back to <= 40 mm (red 204.8). What a human does: when two boxers crowd, the one pushed STEPS - the feet move as a
   step (lift, place), they never slide. Options to measure, not guess: the separation hands the planted foot to the step
   planner (a re-plant), or the separation moves only an UNPLANTED body (whichever man is mid-step), or the separation is split
   so the planted side's share goes to the other man. FIGHTGAP1 note: "push-out must be a step".
2. `fight_body_overlap_test` leg=leg 0.318 m at frame 627: find what the pair is doing at f627 (take? walk?), fix the cause.
3. `fight_world_live_test`: why the footwork beat readouts read 0 and the bout runs past 600 steps as_game (passes OFF?).
   Fix the game side if it is a game bug; fix the test only if the test reads a retired route - say which, with the evidence.

## Owned files
`Godot/scripts/FightWorldLiveScreen.gd` (8,000+ lines - read in windows: `_correct_refused_overlap` ~:4510, `_process` ~:1995),
`Godot/scripts/FightStagePlayer.gd` (foot lock / re-pin), `Godot/tests/*` new tests, `Godot/tools/probe_body_overlap.gd`,
`Godot/tools/fight_motion_probe.gd`. Not `FightRealtime.gd` (the engine) unless item 3 proves the engine is the cause - say so first.
First: `git fetch origin && git merge origin/master` (master is 13+ commits ahead: skinned boots f3f0f0c8, station focus spec).

## Tests (tier: a script edited -> parse, the focused test, then the named ones)
`python Godot/tools/check_scripts.py <touched .gd>`;
`python Godot/tools/run_tests.py --jobs 2 --as-game --only fight_body_overlap_test,fight_world_live_test,overlap_in_takes_test,foot_repin_test,guard_ik_pass_test`
Census re-prints (your S266 commands): probe_body_overlap.gd seed=95501 frames=1200, fight_motion_probe.gd seconds=40 seed=95501.

## Prior research
S264_zivamotion1_handover.md (your S266 section: the overlap cost + the limb-rule next slice), FIGHTMOTION1 (S257/S258 single root
solver, planted_skate probe), FIGHTGAP1 / CLIPREVIEW1 (spacing ranges: jab ~1.2 m, hook 0.75-0.85, clinch < 0.65; push-out = a step).

## What would a human do?
A boxer crowded at close range either steps back/around (feet lift and land) or clinches - his planted foot never glides.

## Prefab check
None - this is our own solver; no plugin solves a two-body boxing separation with planted feet.

## The one trap
A separation that moves the ROOT re-pins the foot next frame: the foot looks planted in the census but the drawn toe still travelled.
Measure the DRAWN toe, not the pin.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/FightWorldLiveScreen.gd, Godot/scripts/FightStagePlayer.gd, Godot/tools/probe_body_overlap.gd, Godot/tools/fight_motion_probe.gd
RED_TEST: Godot/tests/fight_body_overlap_test.gd -> PASS
REGRESSION: overlap_in_takes_test, foot_repin_test, guard_ik_pass_test, fight_world_live_test
VISUAL: yes
