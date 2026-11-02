# TASK GYMFILL2 - repack the club zones with their OWN equipment (no locker filler) (S198)
Model: Cursor (default model). Worktree E:/FightCamp/wt/GYMLOOK2B (reuse: import cache built). NEW branch cursor/gymfill2:
`git fetch && git checkout -B cursor/gymfill2 origin/master`.

## Owned files
- `Godot/assets/data/gym_club.json` (the `floor_zones[].items` lists only)
- `Godot/tests/club_fill_test.gd` (read-only for you EXCEPT `_zone_fill_area`, see the trap)

## What is wrong (Claude opened the game-camera stills, S198)
`previews/gym_look2_s198/03_close.jpg` + `02_mid.jpg`: 29 `focus_mitts_locker` (1.8 m tall, 1x1) stand in rows across
weights_west (7), turf_ladder (1), strength_racks (11), stretch (6) and sled_lane (4). GYMFILL1 used the 1x1 locker as filler to
pass the fill gate. A real boxing gym has one or two mitt lockers against a wall.
`club_fill_test.gd` now has `_check_zone_kinds` (Claude, S198) and is RED on master with 8 failures:
`ZONE_KIND ... wrong=N`, `strength zone ... varied`, `LOCKERS=29 max=2`.

## Do
Rewrite the `items` of those zones with catalogue items of the zone's own kind (`Godot/assets/data/equipment_catalog.json`
`category`; the allowed kinds per zone are `ZONE_CATEGORIES` in the test). Footprints are in metres (`footprint`), clearances in
`assets/data/club_capacity_rules.json`; use the packer `Godot/scripts/club_capacity/ClubCapacity.gd` the way GYMFILL1 did.
- weights_west / strength_racks / strength_east: racks, benches (flat/adjustable/olympic), dumbbell_rack / rubber_dumbbell_rack,
  bumper_plate_set, weight_tree_plates, kettlebell_set, cable_crossover, smith_machine, battle_ropes ... >= 3 distinct each,
  no single id more than half the zone's items.
- stretch: recovery items (yoga_mat_area, foam_roller_set, mobility_stretch_station, stability_ball_set, high_density_rubber_mat_zone).
- sled_lane: turf_sled_lane (+ plyo_box_set / slam_ball_set / medicine_ball_set); turf_ladder: footwork_ladder_set, jump_rope_station,
  reaction_footwork_grid, plyometric_step_rig.
- Keep at most 2 lockers in the hall, in a bag zone, against a wall.
Only `min_tier` T1 items if the catalogue has that field.

## Gates
- `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/club_fill_test.gd`
  exit 0, `club_fill_test: N checks, 0 failure(s)` (every ZONE_FILL / ZONE_COVERAGE / EAST_HALF / COUNTS / ZONE_KIND line passes).
- `python Godot/tools/run_tests.py --only club_ --jobs 2` and `--only gym_club --jobs 2`: no new red.
- Do NOT run anything windowed; Claude takes the stills.

## Prior research
topics/training_floor.md, topics/gym_rooms_art.md, TASK_GYMFILL1.md (the original brief and its numbers), GYMCAP1_REPORT.md
(T1 30 x 18 hall: max copies per item), feedback rule "Gym floor = training floor".

## What would a human do?
A gym fit-out designer fills the strength area with racks, benches, dumbbell racks and plate trees, the stretch area with mats and
rollers, the sled lane with a sled and plyo boxes - and puts storage lockers on the wall.

## Prefab check
Equipment models are greyboxes for now (EQUIP3 = sourcing). Not in this task.

## The one trap
Do NOT weaken any check in club_fill_test.gd (thresholds, ZONE_CATEGORIES, MAX_LOCKERS, STRENGTH_ZONE_MIN_DISTINCT) and do not add
new area exceptions to `_zone_fill_area` - if a zone cannot reach 0.45 with real items, resize the zone rect in gym_club.json instead.
`Tools/ci_arena.py guard` and Claude's diff review catch a loosened test. Commit on cursor/gymfill2, push; never master; never open an
image viewer or window. Final message: red output (master) and green output with every number.
