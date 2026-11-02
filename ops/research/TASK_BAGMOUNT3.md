# TASK_BAGMOUNT3 - operator markup on BAGMOUNT2 (S284)

Model: cursor (Godot gameplay scripts). Discipline: boxing = demo.
Source: operator markup of `previews/s282_gym_build/03_bag_wall_close.jpg` (Feedback/2026-10-21-01..03/README.md), board comments C125-C127, Q-S277-4 stays OPEN.

## Marks (quote verbatim)
1. Frame bag (WRONG): "this doesnt look good,use it as a square construction that can hang 1 bag on each side so 4 total"
2. Wall-arm bag (WRONG): "this is not rotated correctly"
3. Floor patch (WRONG): "change this texture to wooden one or add textures so that the player can change.i do not want to see another still with different floor colours"

## Owned files
- `Godot/scripts/TrainingFloor3D.gd` `_add_bag_mount` (line ~2390, frame branch ~2414, wall branch ~2395) and `_bag_footprint` (~2361)
- `Godot/scripts/club_rooms/BuildMode.gd` lines ~1166-1340, 1451 (bag shop ids, mount, yaw)
- `Godot/scripts/rules/RoomWorkRules.gd` line ~62 `bag_mounts()` rows
- `Godot/tests/bag_mount_test.gd` (existing, extend)
- floor material: the training-floor surface material in TrainingFloor3D.gd / the drawn training-floor zone (find where the grey surface is made; do not read the file whole)

## What to build
1. Frame = a square cage (4 legs, a square top rail) that hangs ONE bag on EACH of its four sides (4 bags per frame). Decide the pricing/slot model (one purchase = 4 bag slots, or 4 placed bags sharing one frame), keep `bag_mount_test` rules coherent, say what you chose in the PR.
2. Wall-arm bag: the arm and plate must face INTO the room from the wall it is on, for all four wall yaws (0/90/180/270). Today the wall_sign logic only handles yaw 0/180 (line ~2402). Add a test per yaw: arm tip is on the room side of the plate and the chain is over the bag centre.
3. Training floor surface: default WOOD (not the grey patch). Add floor-surface choices the player can change (wood, rubber, mat) as data, one selector in BUILD; the stills must never show a different floor colour again, so the default is wood everywhere.

## Prior research / What would a human do? / Prefab check
- `python Tools/prior_research.py bag mount frame floor texture` first. A human gym: a 4-sided rig (quad station) is real; wood or rubber flooring are real choices.
- Prefab check: Godot Asset Library / Fab for wood floor textures (name the licence); procedural wood is acceptable.

## Contract
OWNS: Godot/scripts/TrainingFloor3D.gd, Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/rules/RoomWorkRules.gd, Godot/tests/bag_mount_test.gd
RED_TEST: Godot/tests/bag_mount_test.gd -> BAG_MOUNT failures=0
REGRESSION: room_work_rules_test
VISUAL: see below

## VISUAL GATE
Closes only on a still from the game's own camera (`gym_build_stills.gd`, saved through `clean_view.gd` `save_if_clean`), opened by Claude: frame with 4 bags, wall bag on two different walls, floor wood. Then the operator's OK. A test alone closes nothing. New features ship ON (`GameSwitches.GAME_ON`); plain `--script` tests stay the OFF control arm.

## Acceptance
Parse gate `python Godot/tools/check_scripts.py <touched .gd>`, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/bag_mount_test.gd` (never `_console.exe`). RESULT line in PR body: `RESULT: tests/bag_mount_test.gd -> BAG_MOUNT failures=0`.
Never display anything on the operator's monitors; stills via `Tools\godot_hidden.ps1`.
