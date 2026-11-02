# TASK CAMERA2B - make ludo_camera work in the club's FLOOR MODE (the mode the game actually runs) (S199)
Model: Cursor. Worktree E:/FightCamp/wt/CAMERA2B, NEW branch cursor/camera2b from origin/master
(`git worktree add E:/FightCamp/wt/CAMERA2B -b cursor/camera2b origin/master`).

## Evidence (Claude, game camera, S199)
CAMERA2 (merged 54117ebb) added `ludo_overview/zone/fighter` + switch `ludo_camera`; your test passed because it ran with floor view OFF.
In the real game (`as_game gym3d_main gym4_club club_zones gym_look2 ludo_camera`, `_floor_view_on and _floor_mode` true) the probe
`Godot/tools/gym_club_stills_ludo.gd` prints `LUDOCAM levels=["floor_far","floor_view","floor_close"] zoom=ludo_overview`: the wheel still walks the FLOOR levels,
so the Ludo stops are unreachable in the real game. Run that probe yourself (Tools\godot_hidden.ps1, see its header) and make `levels` print the three ludo names.

## Owned files
- `Godot/scripts/club_rooms/ClubRoomBase.gd` (read in windows; the floor-mode spots are `_active_zoom_levels` ~382, `focus` ~199/204, `_return_to_floor` ~644, line ~470 `Club.zoom_camera("floor_view")`, `zoom_pose` ~103, `set_zoom` roof logic ~164)
- `Godot/scripts/GymClub3D.gd` (2150 lines, sed windows only: build() ~236-248 sets "floor_view" first; `_follow_fighter` ~975)
- `Godot/tests/ludo_camera_test.gd` (EXTEND: add the floor-mode cases below; do not weaken existing ones)
- `Godot/tools/gym_club_stills_ludo.gd` (probe, mine; edit only if its prints need a fix)

## Spec
With `ludo_camera` ON and floor mode ON: (1) build() starts at `ludo_overview`; (2) `_active_zoom_levels()` == the three ludo names; (3) `focus(place)` -> `ludo_zone` on that place,
`focus("home")`/back button/`_return_to_floor` -> `ludo_overview`; (4) the fighter stop follows the fighter exactly as before; (5) walls: at the overview the NEAR (south, z=18) wall panels
must be cut away like `floor_view` does (`_update_wall_fade` / `walls_to_cut`) - today they stand in front of the front equipment strip. State which function you changed;
(6) roof stays hidden at all three stops; (7) rooms opened from the floor (`_open_room`) keep their own camera unchanged.
Switch OFF (and floor mode ON/OFF): byte-identical to master - the existing floor tests stay green.

## Test additions (ludo_camera_test.gd; same PRINT `LUDOCAM total=N fails=M`)
(a) floor mode ON + ludo ON: levels == 3 names, build() zoom == ludo_overview, focus("treadmill") -> ludo_zone with target near that place, focus("home") -> overview; (b) wheel steps clamp;
(c) the south wall alpha at ludo_overview < 0.99 (cut away) - use the club's own `wall_names()`/`wall_alpha()`; (d) switch OFF in floor mode: levels == FLOOR_ZOOMS. 2 real mutants red.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>`; ludo_camera_test; then every test that reads these: club_zones_test, club_fill_test, gym_look2_props_test, gym_club_3d_test,
gym_club_layout_test, gym_club_clearance_test, gym_hall_3d_test, floor_pick_station_test, and `python Godot/tools/run_tests.py --only gym_club --jobs 2`.
Godot only `Godot_v4.7.2-stable_win64.exe --headless` (NEVER _console.exe). Nothing opens on any monitor.
## The one trap
Cursor cannot see images: do not claim the frame looks right - the probe's printed levels/zoom + the wall-alpha test are your proof; Claude opens the still. Do not touch gym_club.json equipment rows.
Commit explicit paths, push the branch, never master. Typed GDScript; no reused local names in one function.
