# TASK BAGMOUNT2 - a heavy bag bought on its own hangs from a wall arm or a free-standing frame (replaces BAGMOUNT1)

Model: Cursor (cloud). Discipline: BOXING (demo) - gym building, GYMBUILD.
Operator S278: "you may need to add assets for the heavy abgs and light bags to hang". Approved verdict (board Q-S277-1, S279 "Approve
all"): research/LUDO_S278_ROOMSWORK_VERDICT.md section 3 - wall arm bag $550 (snaps to a wall, 1.4 x 1.6 m), free-standing bag
$950 (steel frame, 2.2 x 2.2 m, stands anywhere), speed bag $450 wall only, double-end bag $380 anywhere. Prices live in ONE place
already: `RoomWorkRules.bag_mounts()` (Godot/scripts/rules/RoomWorkRules.gd L62) - read them from there.

## Why BAGMOUNT1 (Grok, 3 rounds) was not collected - do not repeat it
It sold new station ids ("wall_arm_bag") that `GymClubLayout.canonical_station_zones()` (L373) does not know, so a bought one has no
place to draw from; and it drew the frame in `ClubZoneFloor._add_equipment`, which draws bags INSIDE PLACED DATA ZONES - those must keep
the S206 beam unchanged. No test was ever written.

## Route today (traced by Claude S281)
- BUILD > OBJECTS: `BuildMode.station_shop()` (Godot/scripts/club_rooms/BuildMode.gd ~L1171) groups unbought canonical places by prop
  (heavy_bag x N), price `catalog_price(prop)` (equipment_catalog heavy_bag 850). Buying = `career["club_places_bought"]` + a
  `career["club_place_moves"][pid]` row (GymClubLayout.places_bought ~L790, `_apply_single_place_move` ~L914).
- The bag is drawn by `TrainingFloor3D._place_model` (Godot/scripts/TrainingFloor3D.gd, 2,572 lines - sed -n windows): ~L717-L720
  `if str(prop["shape"]) == "hanging_bag":` hangs a Chain up to `BAG_CEILING_M` 3.6 m - in the empty shell there is no beam: it floats.

## Do
1. RED TEST FIRST (below) - on master "a bought heavy bag has a Mount node" fails.
2. Shop: with `GameSwitches.on("bag_mounts")` (ADD to GAME_ON) the heavy_bag group becomes TWO rows - "Wall-arm bag" 550 and
   "Free-standing bag" 950 - both buy the next unbought heavy_bag place (same pid scheme as today) and store the choice as
   `"mount": "wall" | "frame"` in that place's club_place_moves row. speed_bag sells at 450 and is wall-only; double_end_bag at 380.
   `count` = places really left.
3. Placement: wall-arm and speed bag are legal only with the station centre within 0.6 m of the building wall or a drawn room's wall
   (`_station_reason`, ~L1236); refused with exactly "Put it against a wall"; the ghost turns to face out from that wall. Frame: anywhere
   on a training floor, footprint 2.2 x 2.2.
4. Drawing, in TrainingFloor3D at the hanging_bag branch ONLY for a place that carries a `mount` (bought single piece): no ceiling Chain;
   instead a child "Mount" of steel boxes (copy the S206 beam material from `ClubZoneFloor._add_beams`): wall = a plate on the wall side +
   a horizontal arm out over the bag + a short chain down to the bag top; frame = 4 legs (bottoms at y = 0) + top bars + a short chain.
   Build the chain as a vertical `_cyl` (the helper already used there) - no look_at on nodes not yet in the tree. Every other bag
   (placed zones, older saves, switch off) byte-identical to today.
5. Read the place's mount through the layout row the renderer already receives (trace how `prop` gets `condition`; add `mount` the same way).

## Test - Godot/tests/bag_mount_test.gd (extends SceneTree; models off is fine; last line `BAG_MOUNT failures=<n>`)
Seed like Godot/tests/sparring_pit_test.gd (empty shell + a drawn training floor). Checks: the shop lists Wall-arm bag 550 and
Free-standing bag 950 (and no plain heavy bag row); a wall-arm bag 3 m from every wall is refused with "Put it against a wall", at 0.3 m
accepted, cash drops by exactly 550, its station node has "Mount" whose highest point >= 1.6 m and NO ceiling "Chain"; a free-standing
bag mid-floor accepted, cash -950, Mount has 4 legs with bottoms at y = 0 (+-0.02); speed bag refused mid-floor. CONTROL ARM: switch
off (`GameSwitches` test seam or a career without club_rooms_built) -> shop row "heavy bag" at the catalogue price and the ceiling
Chain as today.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First on master: a bought heavy bag in the empty shell has a chain to nothing - paste that check's FAIL line.
2. Gym stills only from the game's gym camera via `Godot/tools/clean_view.gd` `save_if_clean` after `CleanView.clear` (no Day Plan,
   drawer or pop-up): one wall-arm bag, one free-standing bag. Commit under previews/bag_mount/.
3. Per still: the chain meets the mount / the mount meets the wall or the floor / nothing floats / bag height.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/club_rooms/BuildMode.gd, Godot/scripts/TrainingFloor3D.gd, Godot/scripts/GymClubLayout.gd, Godot/scripts/GameSwitches.gd, Godot/tests/bag_mount_test.gd
RED_TEST: Godot/tests/bag_mount_test.gd -> BAG_MOUNT failures=0
REGRESSION: build_single_piece_test, sparring_pit_test, training_floor_3d_test
VISUAL: yes

PR body: `RESULT: tests/bag_mount_test.gd -> BAG_MOUNT failures=0` + each regression's last line + the still paths.

## Prior research
LUDO_S278_ROOMSWORK_VERDICT.md s3, TWOPOINT_ALIGNMENT.md (per-room item slots - every gym item brief cites it), S206 beam
(ClubZoneFloor.gd L95-L175), S278_DIGEST.md (single pieces), TASK_BAGMOUNT1.md (the failed route), GDSCRIPT_TRAPS.md.

## What would a human do?
Keep the bag a heavy bag; make "how it hangs" one saved field on the bought piece, and draw the hanger where the bag is already drawn.

## Prefab check
Code-built steel like the S206 beam - no download. (Polytoon Gym CC0 speed-bag platform is a later look pass, not this task.)
