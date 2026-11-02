# TASK GYMLOOK1A - the gym floor is ZONED like a real gym (floor materials + zone signs), first step of GYMLOOK1

Model: Codex luna (medium). Worktree E:/FightCamp/wt/GYMLOOK1, branch codex/gymlook1. Never master, never HANDOFF.md, never AgentComms/.
Operator S196 (verbatim): "why cant make a gym like that ?" - two reference pictures (saved: previews/gymlook_refs/): (1) a 4000 sq ft gym cut
away, with a black-rubber strength/cardio floor, a GREEN TURF functional strip, a wood-floor group studio, labelled zones (CARDIO ZONE, STRENGTH
TRAINING, TURF FUNCTIONAL TRAINING), lockers/office/lounge/reception beside it; (2) a large top-down hall with distinct floor areas (cardio,
weights, HIIT turf, stretch/yoga mats, free-weight rubber) each with its name. Our floor today (docs/previews/gymview2/01_floor_1920.jpg) is ONE
grey carpet with props scattered on it. This step: make the floor read as ZONES. Equipment density and the building shell are GYMLOOK1B/C.

## Owned files
- `Godot/scripts/GymClub3D.gd` (~2,000 lines - NEVER read whole; grep + `sed -n` windows). The hall floor is built in the hall/room build code
  (grep `Floor`, `_box(`, `hall`); stations come from `Godot/assets/data/gym_club.json` `nodes` (kind station/decor, `zone` rect = x0,z0,x1,z1 metres).
  After ROOMSPLIT1 the four front rooms live in `scripts/club_rooms/`; do not touch them.
- NEW `Godot/scripts/club_zones/ClubZones.gd` (pure data helper: zone kind of each station -> floor patch rect + material id) and NEW
  `Godot/scripts/club_zones/ClubZoneFloor.gd` (builds the patches + signs as one Node3D, mounted by GymClub3D).
- `Godot/assets/data/gym_club.json`: add a `floor_zones` block (id, label, rect, material: rubber|turf|wood|mat) - data, not code.
- NEW `Godot/tests/club_zones_test.gd`.
- Switch `club_zones` (default OFF, NOT in DEMO_SWITCHES); copy how `club_routes` / `gym_floor_view` are wired. OFF = tree byte-identical.

## Prior research
- `python Tools/prior_research.py gym floor zone rubber turf` first; research/topics/gym_rooms_art.md + training_floor.md.
- GYMVIEW1 operator ruling: the training floor holds ONLY the floor (no other rooms), bright and alive (CLAUDE.md s10: gym art is bright).
- Facility numbers: `assets/data/gym_tiers.json` (T2 = 30 x 18 m start hall).

## What would a human do?
Look at the reference: you read the gym by its floors before its machines. Black rubber under weights and machines, a green turf strip for
sled/ladder work, mats for stretching, wood for the open middle - and a small painted name on each. Draw patches 1-2 cm proud of the carpet.

## Spec
1. `floor_zones` in gym_club.json for the current 30 x 18 hall: STRENGTH (weights, power rack, olympic platform) = dark rubber; CARDIO
   (treadmill, bike) = dark rubber; TURF (agility ladder + a 2 m x 8 m sled lane) = green turf; STRETCH (recovery) = blue mat; BAG LINE
   (heavy + speed bags) and PADS/DEFENCE/MIRROR = light wood. Patches may not overlap each other or the ring; each station's `zone` rect must sit
   fully inside exactly one patch (the test derives this from the JSON - no copied coordinates).
2. A zone sign per patch: a small floor-level label (Label3D or a decal quad, readable at the game camera; text from `label`, uppercase, like
   "STRENGTH TRAINING", "TURF FUNCTIONAL"), icons-over-text rule N/A (these are signs). Tips not needed.
3. Materials: flat colours + a simple procedural texture (noise/stripes) - NO new image files; turf = green with slight stripe pattern.
4. Switch OFF: nothing added (no node). Switch ON: one `ClubZones` node under the club root, patches + signs only; stations/pads/routes untouched.
5. Do not change hall size, station positions, camera, or any other switch.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <files>`.
- `club_zones_test.gd`: RED first on master (no ClubZones node -> fails; paste the count), then green: patches don't overlap, every station inside one
  patch, sign text = label, OFF has no node, ON adds exactly one root node; two different tiers' data still load (gym_tiers T1/T2 read).
- `python Godot/tools/run_tests.py --only club_ --jobs 2`, `--only gym_floor --jobs 2`, `--only gym_club --jobs 2` -> 0 fails.
- STILLS (visual task): on the game camera via `Godot/tools/gym_floor_view_stills.gd` (see its header for the exact godot_hidden.ps1 command, add
  `club_zones` to the switch list), save to `previews/gymlook1a/` - 01_floor_1920 and 02_floor_1280 with the switch ON. You CANNOT see
  images: report only the geometric checks (patch rects, no overlap) and the file paths; Claude opens the stills.
Final message: red count, green results, still paths.

## The one trap
Z-fighting: patches 1-2 cm above the carpet fight the station pads (gold pad 0.03 m, `_paint_pads` ~1236) and the CLUBROUTES ribbons - put zone patches
BELOW both (y 0.012-0.02) and assert the order in the test.
