# TASK BAGMOUNT1 - every heavy bag hangs from something: wall-arm bag $550, free-standing bag $950

Model: Grok Dev (cloud coding seat, own Godot 4.7.2, no LFS). Discipline: BOXING (demo) - gym building, GYMBUILD.
Operator S278: "you may need to add assets for the heavy abgs and light bags to hang". Approved verdict (board Q-S277-1, S279
"Approve all"): research/LUDO_S278_ROOMSWORK_VERDICT.md section 3 - Wall arm bag $550, snaps to a wall, 1.4 x 1.6 m, you can't
circle it; Free-standing bag $950, steel frame, 2.2 x 2.2 m, stands anywhere; speed bag $450 wall only; double-end bag $380 anywhere
with a 1.6 m clear circle. Beam-clamp bag is LATER (not this task).

## Today (master, traced by Claude S279)
- BUILD > OBJECTS sells single pieces: `BuildMode.station_shop()` (Godot/scripts/club_rooms/BuildMode.gd ~L1121) groups the
  canonical station places by prop, price = `catalog_price(prop)` (equipment_catalog.json heavy_bag 850, speed_bag 620,
  double_end_bag 950). A bought piece = `career.club_places_bought` + `club_place_moves` (GymClubLayout.places_bought ~L676,
  `_apply_single_place_move`).
- Bags are drawn by TrainingFloor3D; the only mount is the S206 code-built ceiling beam (`ClubZoneFloor._add_beams`,
  Godot/scripts/club_zones/ClubZoneFloor.gd ~L108) which exists only for bags in a PLACED data zone (`_in_placed_zone`). A heavy bag
  bought on its own stands in mid-air with no mount - the defect.

## Do
1. RED TEST FIRST: `Godot/tests/bag_mount_test.gd` - as_game, buy one heavy bag on a drawn training floor: on master it fails
   "the bought heavy bag has a mount node".
2. The shop sells the heavy bag as TWO items: "Wall-arm bag" $550 and "Free-standing bag" $950 (labels plain English); speed bag
   $450 wall only; double-end bag $380. Prices from the verdict, not the catalogue (keep the catalogue rows; add the mount price as a
   data row, e.g. a `bag_mounts` table in Godot/assets/data/room_types.json or a new small json - your call, one place only).
3. Wall-arm bag + speed bag: placement is legal only with the bag's back within 0.6 m of a wall (building wall or a drawn room's wall);
   the ghost snaps to the nearest wall and faces out; refused elsewhere with the words "Put it against a wall".
4. Free-standing bag: legal anywhere on a training floor; footprint 2.2 x 2.2 m (blocks other pieces).
5. The MOUNT is drawn: code-built meshes in the S206 beam style (steel material from `_add_beams`): wall arm = a wall plate + a
   horizontal arm out to the chain; frame = 4 legs + top bars (an A-frame or box frame) with the chain from its top. The chain ends at
   the bag model's top (heavy_bag model is fitted 1.6 m tall from the floor - ClubZoneFloor.gd L13). No new download; if you use a
   model, name its licence (Polytoon Gym CC0 speed bag platform is a candidate - GYMDECOR1_JOHN.md, format unverified).
6. Bags already standing in placed data zones keep the S206 beam exactly as today (plain arm byte-identical).
7. New behaviour reads `GameSwitches.on("bag_mounts")`, added to `GAME_ON` (operator S221: new features ship ON); plain `--script`
   tests are the OFF control arm.

## Test - Godot/tests/bag_mount_test.gd (extends SceneTree; as_game + plain arm; last line `BAG_MOUNT failures=<n>`)
as_game: the shop lists Wall-arm bag 550 and Free-standing bag 950; a wall-arm bag at 3 m from every wall is refused with "Put it
against a wall", at 0.3 m it is accepted and its node has a child "Mount" whose top is >= 1.6 m; a free-standing bag mid-floor is
accepted, its Mount has 4 legs touching y = 0 (+-0.02); cash drops by exactly the price; a placed-zone bag still has its beam.
Plain arm: shop and beams identical to today.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master: a bought heavy bag has no mount - paste the FAIL line.
2. Gym stills only via the game's gym camera and `Godot/tools/clean_view.gd` `save_if_clean` after `CleanView.clear` (no Day Plan /
   drawer / pop-up): a wall-arm bag, a free-standing bag, both with a boxer working on them.
3. For every still report: the chain meets the mount / the mount meets the wall or the floor / nothing floats / bag height.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.

## Contract
OWNS: Godot/scripts/club_zones/ClubZoneFloor.gd, Godot/scripts/GameSwitches.gd, Godot/tests/bag_mount_test.gd
RED_TEST: Godot/tests/bag_mount_test.gd -> BAG_MOUNT failures=0
REGRESSION: build_single_piece_test, ring_purchase_test, item_palette_test
VISUAL: yes

(BuildMode.gd / BuildWindow.gd / GymClubLayout.gd are ALSO being edited by Cursor SPARPIT1 #317 right now: keep your changes there
small and in their own functions so the two diffs apply side by side; merge origin/master before you push.)

## Prior research
research/LUDO_S278_ROOMSWORK_VERDICT.md s3, research/TWOPOINT_ALIGNMENT.md (every gym item brief cites it: per-room item
slots), GYMDECOR1_JOHN.md (CC0 sources), S206 beam (ClubZoneFloor.gd L95-L175), S278_DIGEST.md (single pieces), GDSCRIPT_TRAPS.md.

## What would a human do?
Build the frame from boxes first and see the bag hang from it, then the wall snap, then the shop rows.

## Prefab check
Code-built steel (the S206 beam's way) - no asset needed; Polytoon Gym CC0 only for the speed-bag platform if its format imports.

## The one trap
Grok Dev has no LFS: tests that load MetaHuman/LFS models cannot run there - keep bag_mount_test on `load_models = false` (as
build_single_piece_test does) and say in the PR which checks need the PC.

## Output
PR from grok/issue-<n> with `RESULT: tests/bag_mount_test.gd -> BAG_MOUNT failures=0` (both arms) + regression lines.
