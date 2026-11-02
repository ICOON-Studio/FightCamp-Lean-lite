# TASK_AUTOFILL1 (REWORK 3, S284) - ONE AUTO FILL preset: the original gym, every room, every item, the training floor

Model: cursor. Discipline: boxing = demo.
Operator, verbatim (S284), in this order:
1. "also add an auto fill button on the gym selection screen wiht specific presets being filled"
2. "with autofill presets i mean the bags etc to be autoplaced , similar to what was the preset we had before the blank start"
3. "make 1 preset to fill all the rooms and the necessary items and the gym floor too"
4. "make the rooms placed the way you had the gymfloor designed before we made it blank"
THIS REWORK SUPERSEDES the three-preset table (CANVAS & IRON / FIGHT CLUB / COMPOUND), Ludo's counts and "round 4". Delete `GymPresetRules.PRESETS`' three presets, the preset cycling and the pinned-sum tests; keep the AUTO FILL button on the gym step (GymStepPanel.gd) and the apply-at-OPEN-GYM wiring, and keep whatever of `BuildMode.apply_gym_preset` is reusable.

## The one preset: FULL GYM = the gym as it was designed before the blank start
- ROOMS: every data room of the original club layout, each at its ORIGINAL rect and door. Source of truth = the data rows the layout still carries (`GymClubLayout`: `_club().rooms` / `hall()` / `rooms()` and `Godot/assets/data/*` that `_apply_built_rooms` reads: `row["rect"]`, `row["door"]`, `street_door`) - NOT a new hand-made table. Plain `--script` tests still build this original layout (the control arm of the whole shell work), and `GameState.dev_built_gym` (GameState.gd L8415) + `generate_starter_boxing_floor` already restore it for tests: read them first, reuse what they do for the floor and items.
- ITEMS: every furniture/equipment row those rooms had (reception desk, locker banks, office PC, physio table, strength/rack pieces, bench, shower, etc. - exactly the original furniture list of each data room), placed at its original spot, written the way BuildMode writes a built room (`club_rooms_built[room] = {rect, door, items:[{id, furniture, at, yaw}]}`) so the rooms behave as drawn rooms afterwards (movable/sellable in BUILD).
- THE GYM FLOOR: the training floor at its original rect (`club_training_floors`), wood surface, with every station of the original floor (`Club.canonical_station_zones()`: heavy bags, speed bags, pads, ladder, bike, recovery, ...) bought and placed at its original position (`club_places_bought` + `club_place_moves`). Wall bags use the new wall snap (BuildMode `_wall_snapped`, WALL_BAG_CENTRE_M 0.82): where an original bag sat off the wall, snap it to the nearest wall; do not use `free_standing_bag` (removed S284).
- COST: AUTO FILL is an opt-in quick start; the original gym is placed FREE (cash stays the normal $25,000, nothing is charged, no second economy for it) and `career["autofilled"]=true` is recorded so the economy/rent/membership code can tell. No button = the blank shell exactly as today (control arm unchanged: empty tray, no places bought).
- ROSTER/STAFF: unchanged (the empty start's rules); only the building is filled.
- UI: one AUTO FILL button on the gym step; a second press clears it again (back to the blank shell). While filled, the right panel (floor preview, hidden under `quick_creation`) stays as the next task (TASK_AUTOFILL2) leaves it; this task only needs the button label/state ("AUTO FILL" / "CLEAR FILL") and the career state at OPEN GYM.

## Wall snap context (already on master, 4bc3ee17)
Wall-arm bags snap flush to the nearest hall wall at the right yaw (`BuildMode._wall_snapped`); `_nearest_wall` ignores walls the point is on the wrong side of. `gym_preset_autofill_test` is RED on master because it pins sums for the old presets: replace it with the new test below.

## Owned files
Godot/scripts/creation/GymStepPanel.gd, Godot/scripts/CreationFlowPanel.gd, Godot/scripts/rules/GymPresetRules.gd (reduce to the single FULL GYM: ids, label, which data it reads - no counts table), Godot/scripts/club_rooms/BuildMode.gd (apply entry that reads the original layout), Godot/tests/gym_preset_autofill_test.gd (rewrite).

## Prior research / What would a human do? / Prefab check
`python Tools/prior_research.py starter gym layout original rooms`. A human: a tycoon's "start with the default building" option. No prefab. Do not invent counts: the original layout data IS the spec.

## Contract
OWNS: Godot/scripts/creation/GymStepPanel.gd, Godot/scripts/CreationFlowPanel.gd, Godot/scripts/rules/GymPresetRules.gd, Godot/scripts/club_rooms/BuildMode.gd, Godot/tests/gym_preset_autofill_test.gd
RED_TEST: Godot/tests/gym_preset_autofill_test.gd -> GYM_PRESET_AUTOFILL failures=0
REGRESSION: bag_mount_test, reception_street_door_test, new_career_empty_gym_test
VISUAL: see below

## VISUAL GATE
Closes only on game-camera stills of the REAL route (new career -> gym step -> AUTO FILL -> OPEN GYM -> the filled gym) from `Godot/tools/gym_preset_stills.gd` (extend it: one preset, floor_far + floor_view, no tooltip over the BUILD panel): every room present at its original place, the gym floor furnished, nothing floating or inside a wall; opened by Claude, then the operator's OK. Ships ON (GAME_ON); plain `--script` tests stay the OFF control arm.

## Acceptance
Parse gate `python Godot/tools/check_scripts.py <touched .gd>`; test red on master first, then green both arms (`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_preset_autofill_test.gd`, plain and `-- as_game`; never the console build). ZERO SCRIPT ERROR lines. The test asserts, derived from the original layout data (never pinned numbers): the built rooms == the data rooms (ids, rects, doors); every data furniture item present; the training floor rect == the original; every canonical station bought and placed; wall bags flush to a wall; cash unchanged; `autofilled` true; and the blank start unchanged when AUTO FILL is not pressed. PR body: `RESULT: tests/gym_preset_autofill_test.gd -> GYM_PRESET_AUTOFILL failures=0`. Nothing opens on the operator's monitors; stills via Tools\godot_hidden.ps1. Edit code and tests only; do not edit this brief or HANDOFF.md.
