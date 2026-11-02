# TASK_BAGMOUNT4 - round 2 on the multi-bag rig (S284, operator: "needs another round")

Model: cursor. Discipline: boxing = demo. Round 1 = TASK_BAGMOUNT3 (collected 98aae199).
Operator words on the round-1 still (Feedback/2026-10-22-01..07, C128-C134): "dontlike how it looks , maybe make the bags attached near a wall only ?". Earlier (C125-C127): "use it as a square construction that can hang 1 bag on each side so 4 total". Q-S277-5 on the board is open; his answer there beats this brief if it differs.

## Direction (decided, no open question)
Replace the free-standing cage in the middle of the floor with a WALL RIG: a heavy rail bolted along a wall on two bracket plates, holding 4 bags in a row, 0.9 m apart, each on its own chain, hung from the rail. Placement: against a wall only (same refusal as the wall-arm bag: "Put it against a wall"), 4 bags per purchase, price stays 950. The single wall-arm bag stays as is. The cage and its 4-side logic go (keep the tests' coverage by rewriting them to the rig). Look: chunky powder-coated steel (not thin black lines), readable on the game camera at the iso angle; bags red with the white bands the other bags use; a small floor decal footprint like the other stations. NO DEFAULTS: if unsure of look, ask Ludo (Ask Ludo, FightCamp project) with the round-1 still uploaded as a picture, quote his answer in the PR.

## Owned files
Godot/scripts/TrainingFloor3D.gd (`_add_bag_mount` frame branch ~L2414, `_bag_footprint` ~L2361), Godot/scripts/club_rooms/BuildMode.gd (~L1166-1340, L1451), Godot/scripts/rules/RoomWorkRules.gd (L62), Godot/tests/bag_mount_test.gd. The floor-surface list from round 1 stays untouched.

## Prior research / What would a human do? / Prefab check
`python Tools/prior_research.py bag rail rack wall`. A human gym: a wall-mounted heavy-bag rail / bag rack along a wall is the standard multi-bag fixture. Prefab check: Fab / Asset Library for a bag rack model, name the licence; procedural boxes are acceptable.

## Contract
OWNS: Godot/scripts/TrainingFloor3D.gd, Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/rules/RoomWorkRules.gd, Godot/tests/bag_mount_test.gd
RED_TEST: Godot/tests/bag_mount_test.gd -> BAG_MOUNT failures=0
REGRESSION: room_work_rules_test
VISUAL: see below

## VISUAL GATE
Closes only on a still from the game's own camera (`Godot/tools/gym_build_stills.gd`, saved through `clean_view.gd` `save_if_clean`), opened by Claude: the rig on two different walls, all 4 bags visible, nothing floating, nothing inside the wall. Then the operator's OK. A test alone closes nothing. Ships ON (GAME_ON); plain `--script` tests stay the OFF control arm.

## Acceptance
Parse gate `python Godot/tools/check_scripts.py <touched .gd>`, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/bag_mount_test.gd` (never the console build). Tests: rig refused mid-floor ("Put it against a wall"); placed at 0.3 m from a wall on all four wall yaws; rail on the room side of the bracket plates; 4 chains each over a bag centre; 4 bag slots bought for 950. PR body: `RESULT: tests/bag_mount_test.gd -> BAG_MOUNT failures=0`. Nothing opens on the operator's monitors; stills via Tools\godot_hidden.ps1.
