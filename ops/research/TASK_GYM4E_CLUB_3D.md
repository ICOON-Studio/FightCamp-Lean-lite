# TASK GYM4E - The new club in 3D: GymClub3D.gd (behind a new switch `gym4_club`, default OFF) + its headless test

Model: Codex gpt-6-luna at medium (codex_task.cmd default, operator 2026-09-25). Owner: Codex. Worktree `E:/FightCamp/wt/GYM4E`, branch `codex/gym4e-club-3d` (created from
master). Commit, push the branch; NEVER push master, never merge. Tier: script edits -> parse gate on every touched .gd, the new
test, then `python Godot/tools/run_tests.py --only gym_hall --jobs 2` and `--only lap --jobs 2` and `--only career_root --jobs 2`.

## What it is
The operator OK'd the club on paper (S178: "OK, build it"; "Keep none"; interviews AT THE RECEPTION DESK; 2:00 day). Design of
record: `research/GYM4_REDESIGN_S178.md` (read it whole, 9.5K). The pure pieces are merged on master:
- `scripts/GymClubLayout.gd` + `assets/data/gym_club.json` - hall, places (stations), rooms (locker_room, physio, reception,
  office), street, `walk_in` waypoints, aisle graph, `zoom_cameras` far/mid/close. SAME API as `scripts/GymHallLayout.gd` plus
  `rooms()`, `room(id)`, `walk_in_path(a, b)`, `zoom_camera(level)`. Test: `tests/gym_club_layout_test.gd` (69 checks).
- `scripts/WalkIns.gd` + `assets/data/walk_ins.json` - `day_schedule(day, fame, ads, seed)` -> arrivals {id, kind,
  arrive_minute, leave_minute, path, interview...}; `inside_at(schedule, minute)`.
- `scripts/ThingActions.gd` - the click ring's rows (Cursor builds the ring UI in TASK_GYM4F; you only emit the click).
- `scripts/DayGoals.gd` - day/week goal + auto-pause rules (wiring is NOT in this task).
This task builds the 3D club from that data, as a NEW scene script. `scripts/GymHall3D.gd` (1474 lines) stays the control: with
`gym4_club` OFF nothing a player sees changes.

## Owned files
- `Godot/scripts/GymClub3D.gd` - NEW. `extends "res://scripts/GymHall3D.gd"` so the day lap, walking fighter, coach, clock and
  move cards come for free; it swaps the layout module to GymClubLayout and builds the building around it.
- `Godot/tests/gym_club_3d_test.gd` - NEW, headless, `extends SceneTree`, ok/FAIL lines, final `GYM CLUB 3D PASS checks=<n>` or
  `GYM CLUB 3D FAILS=<n>` + exit 1.
- `Godot/scripts/GymHall3D.gd` - the SMALLEST change that lets a subclass swap the layout module (e.g. a `func _layout() ->
  GDScript` returning `HallLayout`, used where an instance calls HallLayout). Statics stay as they are. gym_hall tests byte-green.
- `Godot/scripts/CareerRoot.gd` (anchor `_gym3d_main()` ~line 202, `GYM3D_ROUTES` ~line 219): when gym3d_main AND gym4_club are
  ON, the gym routes open GymClub3D instead of GymHall3D.
- `Godot/scripts/GameState.gd` - ONLY `is_gym4_club_on()` next to `is_gym3d_main_on()` (~line 18026), same shape (user arg
  `gym4_club` or career key). NEVER read GameState.gd whole: `sed -n '18000,18060p'`.

## Build (all numbers from gym_club.json / the modules - no copied constant)
1. Building: hall floor + walls from `hall()`; each room in `rooms()` gets floor, 4 walls with a door gap at its door points,
   a ceiling; the street (sidewalk + road bands); one ROOF over the whole building. Walls are separate MeshInstance3D nodes in a
   group `club_walls`, each with its own material (`transparency = ALPHA_HASH`, so a fade dithers instead of sorting).
2. Props: every place's `prop`/`dressing` row as GymHall3D places them today. "Keep none" means the operator gets NEW models: each
   prop stays ONE data row (`glb`, `height`) so the swap is a data edit - do NOT hunt for models in this task; use the existing
   `assets/models/props/gym/*.glb` as placeholders. Rooms: reception desk + bell at `desk_front/desk_back`, office desk at
   `office_desk` (THE PLAYER STARTS HERE), the coach's chair at the office window onto the floor, locker benches, physio table +
   cold_water_tub IN PHYSIO (never on the hall floor - the operator's S177 complaint was a bathtub on the gym floor).
3. Zoom: three levels from `GymClubLayout.zoom_camera("far"|"mid"|"close")`, mouse wheel / +/- step between them, eased over
   CAMERA_EASE_S. ROOF visible only at `far`; at `mid` and `close` it is hidden. At `close`, every wall that crosses the segment
   camera -> focused fighter (or camera -> target) fades to alpha <= 0.25 over ~0.3 s; a wall behind the target stays alpha 1.
   A wall NEVER hides the fighter. Public: `set_zoom(level: String)`, `zoom_level() -> String`, `wall_alpha(wall_name) -> float`.
4. Walk-ins: `WalkIns.day_schedule(day, fame, ads, seed)`; each arrival is a simple walker (reuse how GymHall3D builds the coach
   body, or a plain mannequin) moving along `GymClubLayout.walk_in_path` waypoints at walking speed, minute by minute off the same
   clock as the day lap. Interviews: a candidate stops at `desk_front` (the reception desk). Public: `walkers_inside() -> Array` of
   ids that must equal `WalkIns.inside_at(schedule, minute)` ids.
5. Click: `thing_at(screen_point: Vector2) -> Dictionary` {kind: fighter|coach|station|office_window|walk_in, id} by a physics
   ray or projected-rect pick; a left click emits `signal thing_clicked(kind: String, id: String, screen_point: Vector2)`. No UI.
6. Switch: `gym4_club` OFF -> CareerRoot routes exactly as today (GymHall3D).

## Acceptance (gym_club_3d_test.gd; numbers read from the data or the modules)
1. Every place id of GymClubLayout has a node at `work_position(place)`; every room has 4 walls and a door gap at each door point.
2. No physio/locker prop lies inside the hall rect (read the room/hall rects; cold_water_tub is in physio).
3. `set_zoom` far/mid/close puts the camera at that level's distance and pitch (within 1 cm / 0.5 deg after the ease); roof
   visible at far only.
4. At close with the fighter at a station, every wall crossing camera->fighter has `wall_alpha <= 0.25`; at least one wall NOT on
   that segment keeps alpha 1.0 (a control that can fail: fading every wall would pass a naive check - this one would not).
5. `thing_at(camera.unproject_position(station work position))` returns that station; same for the fighter.
6. For three minutes of a seeded busy day, `walkers_inside()` ids == `WalkIns.inside_at(...)` ids; a candidate reaches desk_front.
7. The player's start position is the office desk waypoint; the coach's start is the office window.
8. Control: with gym4_club OFF, CareerRoot's gym route instantiates GymHall3D (not GymClub3D).
MUTANTS (comment block at the bottom; run each, each must turn the test red, revert): fade every wall at close; never hide the
roof; walkers from a different seed; cold_water_tub placed in the hall.

## Parse gate + tests (the PC's Godot, headless; NEVER the _console.exe - it opens a window on the operator's screen)
`python Godot/tools/check_scripts.py Godot/scripts/GymClub3D.gd Godot/tests/gym_club_3d_test.gd Godot/scripts/GymHall3D.gd Godot/scripts/CareerRoot.gd Godot/scripts/GameState.gd`
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_club_3d_test.gd`
then the three `run_tests.py --only ... --jobs 2` lines above. No stills, no windowed Godot, no image or video opened: Claude takes
the game-camera stills after the merge. Nothing may appear on the operator's screens.

## Prior research
GYM4_REDESIGN_S178.md (the design of record: J64 click-a-thing, K87 pacing, Chef read from its code = authored waypoints, no
crowd sim; Two Point / The Sims = roof off when zooming in, near walls cut), GYM3D1_LAYOUT.md (route/camera mechanics that stay),
G113/G121 (real club sizes and plans).

## What would a human do?
Subclass the working hall scene, point it at the new layout data, add walls/roof as separate nodes so each can fade, and test the
fade with a ray from the camera to the fighter - the same thing Two Point Hospital does when you zoom in.

## Prefab check
Wall fade = an engine feature (ALPHA_HASH material + alpha), no addon. Furniture placeholders: existing props + Kenney Furniture
Kit (CC0) if already in the repo. The radial ring is Cursor's (Asset Library #3469, MIT).

## The one trap
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`); a variable name reused in one function is a
parse error; a code-made MeshInstance3D has an EMPTY skeleton path (draws unskinned at rest) - reuse GymHall3D's body builders.
