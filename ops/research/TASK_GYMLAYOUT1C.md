# TASK GYMLAYOUT1C - design YOUR boxing-club floor plan as game data (one of three competing layouts)

Model: Cursor (default model). Worktree E:/FightCamp/wt/GYMLAYOUT1C, branch cursor/gymlayout1c from master. Commit + push the branch;
never master, never HANDOFF.md, never AgentComms/. Never open a window, image viewer, video player or browser - look at stills
ONLY with your file tool (and you cannot see images: judge stills by the geometric checks below, never describe a picture).
Windowed Godot ONLY via `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`; headless with
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`); `timeout 300` on every Godot run.

Operator S201 (verbatim, Q-S199-2): "you author one and ludo makes one and we keep the best also use other agents tat can
deliver the exact design in game (no fucking random generation images , i want the real screen i will be using in the game".
You are the "other agent". Claude and Ludo each make their own; the operator picks the best from REAL game-camera stills.
Do NOT open `Godot/assets/data/club_layouts/claude.json` or `Tools/gym_layouts/author_claude.py` - your design must be your own.

## Owned files
- `Tools/gym_layouts/author_cursor.py` (NEW) - writes your layout; every coordinate written by hand in it (NO packing loop, NO
  random, NO "fill the zone" search). Comment the plan at the top in plain words.
- `Godot/assets/data/club_layouts/cursor.json` (NEW, written by the script).
- `previews/s201_layout_cursor/*` (stills).

## How a layout works (read these, edit none)
- `Godot/scripts/GymClubLayout.gd` `_load_club` + `layout_variant()`: `club_layout=<name>` loads
  `assets/data/club_layouts/<name>.json`; its top-level keys REPLACE the base `Godot/assets/data/gym_club.json` keys. Override
  `room` (aisle bands, walk_limit_m), `places`, `nodes`, `edges`, `floor_zones`, `wall_places` - keep everything else.
- The base file is your format reference: copy each place's record and change its coordinates (zone [x0,z0,x1,z1], work, approach,
  node, bag/board for bags, steps+platform for the ring). Hall 30 x 18 m; x west wall 0 -> east wall 30; z back wall 0 -> front
  wall 18 (room doors at x 1.8 locker, 7.2 physio, 11.3 reception, 14.1 office, 25.0 store; the street walk-in comes through
  reception at x 11.3 to `walk_in.points.floor_walk` [11.3, 9.0] - keep that line clear of solid zones).
- Keep EVERY station place id (heavy_bag_1-4, speed_bag_1-2, mirror_strip, pads, defence_drill, weights, treadmill, bike, ring,
  recovery, agility_ladder, olympic_platform, power_rack) and its `station`. Decor places (bench_water, glove_rack) are yours to
  place; drop `expansion_bay` (an empty block). Extra kit goes in `floor_zones` items ({id, x, z, yaw}; x/z = the item's corner).

## The rules your floor must meet (real boxing gyms: `research/G121_REAL_GYM_FLOOR_PLANS.md`, audit of today's junk:
`research/GYM_ZONE_AUDIT_S200.md` - read both first)
- 8-12 heavy bags, EVERY one hung on a wall (<= 1.2 m from the back/west/east wall), >= 1.5 m apart, nothing behind a bag.
- 2 speed bags on the back wall (the layout test wants speed-bag boards on the back wall). One first-aid kit, on a wall.
- Ring with >= 1 m clear to any wall; its apron empty.
- ONE strength corner on rubber; cardio secondary and out of the boxing traffic; a quiet recovery corner; open floor for shadow
  boxing, pads, slip rope and skipping; a clear walk from the reception door; every door with 1.2 m clear floor in front.
- No item in a zone of the wrong kind (a bag is never in STRENGTH TRAINING; a first-aid kit is never a stretch mat).

## Done (tier: new data + tool)
- `timeout 300 Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_club_layout_test.gd -- club_layout=cursor`
  -> `GYM CLUB LAYOUT PASS checks=70` (paste it). Also run it with no club_layout (today's floor must still PASS).
- Stills on the REAL game camera: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot
  --resolution 1920x1080 --script tools/real_drawer_stills.gd -- as_game club_layout=cursor out=docs/previews/s201_layout_cursor`
  -> `1_drawer_closed.jpg` is the overview the operator judges. Never a generated image.
- A table in your final message: every heavy bag (x, z, nearest wall, distance), the ring zone and its wall clearance, each zone.
Commit + push cursor/gymlayout1c.

## Prior research
G121_REAL_GYM_FLOOR_PLANS.md, GYM_ZONE_AUDIT_S200.md, `research/topics/gym_rooms_art.md`, GYM4_REDESIGN_S178.md.

## What would a human do?
A coach designing his own gym: bags on the long wall, ring where everyone can see it, weights in a corner on rubber, a quiet mat
corner, and a clear path from the front door so nobody walks through a sparring session.

## The one trap
The layout test checks aisle nodes sit inside the `room` aisle bands and that no aisle edge crosses a SOLID zone - design the walk
graph (nodes on the bag lane / cross aisle / front aisle, lanes between zones) together with the zones, not after.
