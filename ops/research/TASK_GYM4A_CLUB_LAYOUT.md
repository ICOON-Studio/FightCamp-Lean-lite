# TASK GYM4A - The new boxing club as pure geometry: GymClubLayout.gd + gym_club.json + its test

Model: any strong coder. Owner: Arena (cloud; own `arena/` branch, open a PR into master, NEVER merge).
Tier: new script + new data + new test -> parse gate on the new files + the new test. Headless, no LFS, no 3D.

## What it is
The operator rejected our 3D gym floor ("a bathtub in the gym floor") and approved a new plan drawn from real boxing gyms
(S178). The plan is DATA already: `research/GYM4_PLAN_S178.json` (rooms, zones, street, walk-in route, coach home,
player start; metres, x left->right, z from the BACK wall 0 toward the street). Picture: `previews/gym4_plan/
01_top_down_plan.jpg`. Design text: `research/GYM4_REDESIGN_S178.md`. Turn it into a game data file + a pure module
with the SAME API as the current `Godot/scripts/GymHallLayout.gd` (323 lines - read it whole; it is the pattern to copy) so
the 3D scene can switch modules later.

## Owned files (create; touch nothing else)
- `Godot/assets/data/gym_club.json` - NEW. Same top-level shape as `Godot/assets/data/gym_hall.json` (59 lines: `room`,
  `home_camera`, `nodes`, `edges`, `places`, `wall_places`) PLUS: `rooms` (locker_room, physio, reception, office: rect, route id,
  door points), `street` (sidewalk/road z bands, spawn points left/right), `walk_in` (named waypoints: street_left, street_right,
  door_out, door_in, desk_front, desk_back, office_door, office_desk, locker_door, floor_entry, exit), `zoom_cameras`
  (`far` ~40 m pitch ~55, `mid` ~22 m pitch ~50, `close` ~7 m pitch ~30 - target the hall centre for far/mid).
  Places (hall stations), each with zone/solid/work/approach/node/prop like gym_hall.json:
  heavy_bag_1..4 (station heavy_bag, bag line on the back wall, bag centres x 3.9/5.8/7.7/9.6, z 1.2), speed_bag_1..2 (station
  speed_bag, wall boards x 0.9/2.1 at the back wall), mirror_strip (station "move_cards", zone x 0.2-3.0 z 3.0-6.6, solid false),
  pads (x 3.6-6.6 z 3.2-6.6, solid false), defence_drill (slip rope x 7.0-10.2 z 3.2-6.6, solid false), ring (station
  ring_sparring, platform x 11.6-17.4 z 1.1-6.9, steps at the front-left corner like gym_hall.json's ring "steps"), weights
  (x 0.2-3.6 z 7.0-10.2), treadmill + bike (two places inside the cardio zone x 4.1-8.3 z 8.6-10.2), recovery (the STRETCH
  CORNER x 13.6-19.8 z 8.4-10.3, prop "stretch_mats" - NO tub, NO table), bench_water (decor, solid, x 19.0-19.8 z 2.4-7.6),
  glove_rack (decor, solid, x 8.6-9.9 z 9.6-10.2). Props in the PHYSIO room (not the hall): physio_table, cold_water_tub, first_aid.
  Aisle graph: a front aisle z 10.4-12.0 along the whole front wall (all room doors open onto it), a middle walk z ~7.6-8.4,
  the strip under the bags z ~2.4-3.0; links so every station reaches every other.
- `Godot/scripts/GymClubLayout.gd` - NEW. Copy GymHallLayout.gd's statics (hall/place/place_ids/places_for_station/zone_rect/
  route/height_at/camera_pose/zone_overlaps/route_blockers/segment_hits_rect/polyline_metres) reading `gym_club.json`, plus:
  `rooms()`, `room(id)`, `walk_in_path(from_waypoint, to_waypoint) -> {"ok", "points", "metres"}` (waypoints chain over
  `walk_in` links you define in the data), `zoom_camera(level: String) -> {"position","target","fov"}` for far/mid/close.
  Pure: no GameState, no autoload, no RNG, no preload; deep copies out, never the cache.
- `Godot/tests/gym_club_layout_test.gd` - NEW, `extends SceneTree`, prints ok/FAIL lines and `GYM CLUB LAYOUT PASS` or
  `GYM CLUB LAYOUT FAILS=<n>` + exit 1. Model it on `Godot/tests/gym_hall_layout_test.gd` (210 lines).

## Acceptance (the test must check ALL of these, reading every number from the data or the module, never a copied literal)
1. Every DayLap station id (`DayLap.stations()["stations"]` keys: treadmill, bike, weights, heavy_bag, speed_bag, pads,
   ring_sparring, defence_drill, recovery) has >= 1 place; `move_cards` has exactly 1 place (the mirror strip).
2. No two hall use zones overlap; every zone lies inside the hall (x 0-20, z 0-12); the ring keeps a 1.0 m empty apron
   (no other zone within 1 m of the platform).
3. Every station reaches every other over the aisles without crossing a SOLID zone (route_blockers empty); longest walk <= 26 m.
4. Every room door has 1.2 m of clear floor in front of it on the hall side (no solid zone there).
5. NEVER ON THE FLOOR: no hall place or hall dressing uses a prop/glb whose id contains any of: tub, physio, fridge, tv,
   television, rug, chair, whiteboard. The physio room DOES list cold_water_tub and physio_table.
6. walk_in_path("street_left", "office_desk") is ok, passes desk_front, and crosses no solid hall zone; walk_in_path
   ("door_in", "floor_entry") is ok.
7. zoom_camera("far").position is farther from its target than "mid", and "mid" farther than "close"; unknown level -> {}.
8. Callers cannot mutate the cache (edit a returned dict, re-read, unchanged).
9. CONTROL ARM: a straight segment from heavy_bag_1's work point to the recovery work point IS blocked (the ring) - proves the
   blocker check can read worse.
MUTANTS (list them in a comment block at the bottom, run them if you can, each must turn the test red): put cold_water_tub in a
hall place's dressing; delete one aisle edge so a station is cut off; shrink the ring apron to 0.5 m; swap far/close distances.

## Parse gate + test
`python Godot/tools/check_scripts.py Godot/scripts/GymClubLayout.gd Godot/tests/gym_club_layout_test.gd`
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_club_layout_test.gd`
If you have no Godot in your sandbox, say so in the PR body; do NOT build Godot from source (it takes ~25 min and kills the run).

## Prior research
GYM4_REDESIGN_S178.md (this design), G113 (real use-zone sizes), G121 (ring 1-2 m apron, bags on a long wall), GYM3D1_LAYOUT.md
(the rejected layout's routes/steps/camera mechanics - kept).

## What would a human do?
Copy the existing, tested module and data shape exactly, change only the numbers and the new keys, and let the test prove the plan.

## Prefab check
None needed: geometry only. Do not add 3D assets or touch any .tscn/.glb.

## The one trap
GDScript: `var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`); a variable name reused in one
function is a parse error even across blocks; `%` in a format string is `%%`.
