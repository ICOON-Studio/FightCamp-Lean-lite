# TASK GYMART1A - the building shell: thick walls, real floors, cove base, trusses + lamps, the street outside (S199)
Model: Cursor. Worktree E:/FightCamp/wt/GYMART1A, NEW branch cursor/gymart1a from origin/master
(`git worktree add E:/FightCamp/wt/GYMART1A -b cursor/gymart1a origin/master`). Everything behind the EXISTING switch `gym_look2` (default OFF; never change the OFF path).

## Evidence (Claude, game camera, S199, stills in previews/s199_club/ and s199_ludo_camera/)
Mid/overview shots: the building is a thin white-cream shell floating in a pure black void; the roof (far shot) is a flat grey slab; floor zones are flat dark/tan slabs with no
texture response. Operator ruling S198: everything looks BRAND NEW (factory finish).

## Prior research
LUDO_ROUND33_S198.txt section 1.1 items 1, 2, 4, 6 (lines 33-81) and 1.3 (lines 198-225): exact colours/roughness/dimensions there. `python Tools/prior_research.py gym_look2 wall floor`.
Existing: `Godot/scripts/club_look/GymLook2.gd` (144 lines: `apply`, `apply_env`, `surface`), `GymLook2Dress.gd` (216), data `Godot/assets/data/gym_look2.json` (6.8 KB), `GymHall3D.gd` line ~480 calls `GymLook2.apply`. Wall nodes: ClubRoomBase `_walls` (MeshInstance3D, metas axis/c).

## What would a human do?
Walk out of the door and see a street, not a void; look up and see steel trusses and lamps; look down and see a rubber floor with seams.

## Prefab check
Procedural only (BoxMesh/materials, no imported art). Textures: generate tiny procedural noise/seam textures in code or use Godot's built-in NoiseTexture2D; no downloads. Keep the .pck light.

## Owned files
- `Godot/scripts/club_look/GymLook2.gd`, `GymLook2Dress.gd`, NEW `Godot/scripts/club_look/GymLook2Shell.gd` (put the new geometry here, keep the old files small)
- `Godot/assets/data/gym_look2.json` (new keys only)
- NEW `Godot/tests/gym_look2_shell_test.gd`
Read-only: GymHall3D.gd, ClubRoomBase.gd, gym_club.json.

## Spec (all values from Ludo r33 1.1/1.3; with the switch ON)
1. Walls: render thickness 0.45 m (do NOT change collision/hall rects that other tests read: add a visual-only inner/outer slab), dark steel cap beam along every wall top: albedo #1E232A, rough 0.45, metal 0.85.
2. Floors per zone material kind (data already has material wood/rubber/turf/mat): rubber #20242B rough 0.72 + a 2 mm pebble normal (NoiseTexture2D, tiling 60x60); turf #14532D rough 0.88 with white yard-lines every 1.0 m (#E2E8F0);
   cardio floor #2A2E37 rough 0.65 with 500 mm square seam lines. NO wear/grunge/chips (operator: brand new).
3. Cove base: continuous perimeter strip 0.10 high x 0.025 deep, #18181B rough 0.80. No staining decals.
4. Trusses: 4 open-web steel joists running N-S at x = 4.5, 11.5, 18.5, 25.5, y = 6.2, #262626 rough 0.52 metal 0.80, plus 8 high-bay lamps hung at y=5.4 with emissive lens (#FFFFFF, emission #E2E8F0, energy 8.0).
   Put them on a visual layer / node group `gym_look2_overhead` that hides at the close and fighter stops and at the roof view so they never block the camera (use the existing zoom level name from `zoom_level()`).
5. Exterior (1.3, only what is cheap): ambient/background colour #0A0E17 (twilight) instead of black; a wet-asphalt strip 3.5 m wide along the north and east walls (#1A1D20 rough 0.22), a kerb (#4B5563), a 2.8 m chain-link-look fence (thin box + #64748B metallic 0.9), 6-8 low box "tenement" silhouettes (#3E2723 desaturated) 15-40 m out, one white box van and two green (#14532D) dumpsters. Low-poly boxes only. Nothing may overlap the hall footprint or the entrance walk-in path.
6. Budget: the whole addition under 4000 triangles and no new texture files; frame time must not noticeably rise (report the mean ms of 120 frames at the overview, with and without the switch, same machine).

## Test `gym_look2_shell_test.gd` (extends SceneTree; prints `GYMSHELL total=N fails=M`; quit(1) on fail, never quit(0) on pass)
(a) switch OFF: the hall's node tree is identical to master (count children + a node-name list hash); (b) ON: cap beams exist on all 4 walls with the exact material values above; (c) 4 trusses at the exact x, 8 lamps with emission energy 8.0;
(d) overhead group hidden at `close`/`ludo_fighter`/`far`, visible at mid/overview; (e) floor materials per kind have the exact albedo; (f) background colour == #0A0E17; (g) no exterior node intersects the hall rect or the door path (use the club layout);
(h) triangle count of the added nodes < 4000. 3 real mutants red.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>`; the test; then ALL of: gym_look2_props_test, gym_club_3d_test, gym_hall_3d_test, gym_club_layout_test, gym_club_clearance_test, club_zones_test, club_fill_test, ludo_camera_test, floor_pick_station_test
(these read the same scene; two broke S199 when only one was run). Godot only `Godot_v4.7.2-stable_win64.exe --headless` (NEVER _console.exe). Nothing opens on any monitor.
## The one trap
Cursor cannot see images: do NOT claim it looks right. Prove the numbers in the test; Claude shoots the game-camera stills (`as_game gym3d_main gym4_club club_zones gym_look2`) and judges. Do not touch equipment rows or `gym_club.json`.
If a Godot class cache error ("Identifier not found: SomeClass") appears for a class that exists, run `Godot --headless --path Godot --import` once. Commit explicit paths, push the branch, never master. Typed GDScript, no reused local names in one function.
