# TASK GYMFILL1 - the starting club floor is FULL: zones cover the hall and every zone is packed with its equipment (S197)
Model: Cursor (default model). Worktree E:/FightCamp/wt/GYMFILL1, branch cursor/gymfill1 (from master).
Operator on the zoned floor still (board Q-S194-7, verbatim): "half the gym is empty are you serious ?"
What he saw: docs/previews/gymlook1a/02_floor_1280.jpg - the 30 x 18 m hall (D45) has a bag line top-left, cardio and two
strength zones bottom-left, a stretch mat, and the WHOLE RIGHT HALF (east of the ring and below it) is bare floor with one
thin turf lane and one yellow mat; each zone holds 1-4 items with gaps between them.

## Goal
With `club_zones` ON (career key or user arg), the T1 starting club reads as a busy real boxing gym: the zones tile the
whole usable floor (walkways between them, ring clearance kept) and each zone is packed with its own items at real-gym
density, using the 95-item catalogue `Godot/assets/data/equipment_catalog.json` (real metre footprints, `zone`, `min_tier`)
and the packer `Godot/scripts/club_capacity/ClubCapacity.gd` + `assets/data/club_capacity_rules.json` (it already knows how
many of each fit). Boxing first: a long bag line (6-10 heavy bags), speed-bag + double-end platforms, a second ring-side
bag/pad area, cardio row (treadmills, bikes, rowers, ski), two strength zones (racks, benches, dumbbell rack, plates),
turf lane with sled, stretch/mat area, a small sparring/shadow area marked on the floor. Only items with min_tier T1.

## What to do
1. Data first: rewrite the zone layout in the club zones data (`Godot/scripts/club_zones/ClubZones.gd` + its json - find it
   from ClubZones.gd) so zones tile the hall: every point of the floor that is not ring, ring clearance, a doorway lane or a
   1.2 m walkway belongs to a zone. Give each zone an `items` list (catalogue ids + positions in hall metres + yaw) packed
   by `ClubCapacity` rules (footprint + its clearance), no overlaps, no item crossing a wall, a zone edge, the ring
   clearance (`gym_club_clearance_test`) or a door.
2. Build: `ClubZoneFloor.gd` / `GymClub3D.gd` place those items (reuse the existing station/greybox builders - grep how
   `_club_capacity_refresh` and the station builder place catalogue items; do not invent a second builder).
3. Test `Godot/tests/club_fill_test.gd` (new, geometric - you cannot see images, so the test is the eye):
   (a) zone area / usable floor area >= 0.85; (b) per zone, sum of item footprints (incl. clearance) / zone area >= 0.45;
   (c) no two item footprints overlap; none crosses a wall/zone edge/ring clearance/door lane; (d) at least 6 heavy bags,
   3 cardio machines, 2 racks; (e) the EAST half of the hall (x > hall centre) holds >= 35% of all item footprint area
   (the operator's complaint). Print the numbers achieved beside the thresholds. Prove the test red on master first
   (paste that output in your final message), then green.
4. Keep `club_zones` default OFF (the operator turns it on); `club_capacity` (the packed-assortment debug view) untouched.

## Owned files
`Godot/scripts/club_zones/ClubZones.gd` (38), `ClubZoneFloor.gd` (86), the zones json, `Godot/tests/club_fill_test.gd` (new),
`Godot/scripts/GymClub3D.gd` (2,146 lines - NEVER read whole: grep then `sed -n` windows <= 150 lines; the zones hook is at ~1535).

## Gates
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`
- Focused: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/club_fill_test.gd`
  (NEVER _console.exe). Pass = exit 0, no SCRIPT ERROR, no FAIL line.
- Related: `python Godot/tools/run_tests.py --only club_ --jobs 2` and `--only gym_club --jobs 2`: no new red.

## Prior research
topics/training_floor.md, topics/gym_rooms_art.md, GYMCAP1_REPORT.md (T1 hall 30 x 18: max copies per item), S196_DIGEST.md
(GYMLOOK1A zones, EQUIP2 catalogue, GYMCAP2 view - note: GYMCAP2 once pushed stations through the east wall by aligning to the
ring; use HALL coordinates), feedback rule "Gym floor = training floor" (no bath/board/chairs on the floor).
## What would a human do?
A gym designer fills the floor plan zone by zone from the equipment list until it reads like the reference photos - wall to wall,
aisles only where people walk.
## Prefab check
Equipment models are greyboxes for now (EQUIP3 = sourcing, operator buys) - not in this task.

## The one trap
Packing the assortment view (club_capacity) again is NOT this task - that is a debug view of one-of-each. This is the real
zoned floor, dense and deliberate. Commit on cursor/gymfill1 and push; never master; never open an image viewer or window.
Final message: red-on-master output, green output with the numbers, files changed.
