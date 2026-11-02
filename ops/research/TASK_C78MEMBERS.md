# TASK C78MEMBERS (S233) - 4 gym members training on the boxing floor (Ludo r94 "Life")

Seat: Goose (cloud, label `goose`). Model: any. Own branch goose/issue-<n> + PR; never master. Rebase on master first; the diff
touches only the files you name in your report.

## Why
Operator Q-S231-3: "Yes, build it" - Ludo r94's C78 floor = 7 props (ALREADY ON MASTER as `decor` rows `c78_*` in
`Godot/assets/data/gym_club.json`, GLBs in `Godot/assets/models/props/c78floor/`) + EXACTLY 4 member NPCs training there.
This task is the 4 members. Spec: `research/LUDO_ROUND94_REPLY_S232.md` PART A "Life".

## What to build
New file `Godot/scripts/club_look/BoxingFloorMembers.gd` (keep it under ~250 lines), called from the hall build right after
`GymFloorDetails.apply(hall)` in `Godot/scripts/club_look/GymLook2.gd` (line ~69), behind a NEW switch `boxing_floor_members`
added to `GameSwitches.GAME_ON` (read with `GameSwitches.on("boxing_floor_members")`; plain `--script` tests keep it OFF = the
control arm; `-- as_game` turns it on). Never a raw cmdline opt-in, never DEFAULT_OFF.

Four members, each a Node3D under a holder `BoxingFloorMembers`, at these hall positions (metres, our frame; y = 0):
| member | stands at (x, z) | faces | clip |
|---|---|---|---|
| m1 | (4.2, 8.6) footwork grid A | toward (4.2, 6.0) | shadowboxing - `res://assets/anim/c209/shadowboxing/take1/motion.glb` |
| m2 | (10.0, 8.4) footwork grid B | toward (9.0, 6.5) | skipping - `res://assets/anim/c209/skipping/take1/motion.glb` |
| m3 | (6.0, 7.75) in front of double-end bag 1 (6.0, 8.4) | the bag | the heavy-bag station clip `TrainingFloor3D.STATION_CLIPS["heavy_bag"]` |
| m4 | (10.9, 9.35) in front of double-end bag 2 (10.9, 10.0) | the bag | same as m3, start offset 0.9 s |
Stagger every loop's start (Ludo: staggered loops) so no two members move in sync.

BODIES - MetaHuman only (operator rule: never MPFB / the generator body / Tripo). Use the SAME route the floor's own fighters
take: `TrainingFloor3D._build_fighters()` (scripts/TrainingFloor3D.gd ~line 1097) -> `Rig.model_for_skin(...)` +
`_add_body(node, model, start, clip, id, row)` (~line 1762). Call the hall's `_add_body` (the hall node passed to `apply` IS the
TrainingFloor3D subclass) with a member row `{"sex": "male"|"female", "discipline": "boxing", "competition_weight_kg", "height_cm"}`;
pick 4 DIFFERENT bodies (2 men, 2 women; different weights/heights - never identical people) from the MetaHuman boxer set
`assets/models/metahuman/mh_boxer_01..10.glb` via whatever pool `model_pool_for` returns with `metahuman_bodies` on.
No name tags, no mastery pips, no station claim - they are ambience. If a clip cannot load, the body plays the idle (never a
T-pose, never an empty node) and `push_warning` names the clip.

## Gate
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- RED FIRST: new test `Godot/tests/c78_boxing_floor_members_test.gd` - builds the hall the way
  `Godot/tests/c78_boxing_floor_decor_test.gd` reads it (or instance the club scene headless with `load_models = false` if a body
  cannot load headless - then assert the 4 Stand-in nodes), with the switch forced ON in the test: exactly 4 member nodes, at the
  table's positions (+-0.05 m), each >= 2.0 m from the work points pads (4.8, 5.4) and defence_drill (9.2, 5.4), 4 distinct
  clip/start pairs, 4 distinct body rows. Paste its FAIL lines on master in the PR body; then green.
- `python Godot/tools/run_tests.py --jobs 2 --only c78_,gym_look,club_zone,gym_club` green (no test weakened or deleted).
- Paste the full headless output of the new test in the PR body.

## Prior research
`python Tools/prior_research.py member npc floor ambient`: LUDO_LOOPS_S188 Q3 ("members train in the background" - TAKE),
topics/training_floor.md, topics/gym_market.md (members on the floor = members x 0.20 - FloorVibe S230 keeps that number for
moments; these 4 are the drawn ambience Ludo asked for).

## What would a human do?
A level designer drops four looping background trainers on the open stations and staggers their loops so the floor breathes.

## Prefab check
Bodies = our MetaHuman boxer set; clips = our c209 takes and the shipped station clips. Nothing new to source.

## The one trap
The visual gate is Claude's on the PC (game camera stills, `still_framing.gd save_if_framed`) - do not claim anything visual;
deliver the code + the headless test only.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip/scene: it must read RED on the defect; paste that number in your report.
2. Stills only via record_room.gd / club_room_still.gd -- as_game + still_framing.gd save_if_framed (game camera; never a feet-only or mat shot).
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies (room stills: clipping, floating, paths, dark zones, HUD).
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
