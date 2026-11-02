# TASK CAMERA2 - Ludo's 3-stop gym camera behind a switch (S199)
Model: Cursor (Godot UI/gameplay). Worktree E:/FightCamp/wt/CAMERA2, NEW branch cursor/camera2 from origin/master
(`git worktree add E:/FightCamp/wt/CAMERA2 -b cursor/camera2 origin/master`, then work only there).

## Prior research
LUDO_ROUND33_S198.txt section 1.2 (lines 115-197), operator Q-S196-5 "yes ludos camera". Our camera is DATA-DRIVEN: `Godot/assets/data/gym_club.json`
"zoom_cameras" (far/mid/close/floor_far/floor_view/floor_close = target + distance + pitch + yaw + fov), read by `Club.zoom_camera(level)`;
`ClubRoomBase.gd` `zoom_pose` (line ~103) / `set_zoom` (~138) / `zoom_step` (~163) / `_active_zoom_levels()`; roof nodes show only at "far"/"floor_far".
`python Tools/prior_research.py camera zoom floor_view` first.

## What would a human do?
Mouse wheel steps between three stops: the whole hall from INSIDE the building (no roof, no black void), one zone, the fighter. Roof/street view is a
separate button, not a zoom stop.

## Prefab check
None - our own rig; do NOT paste Ludo's GymCameraController class (it moves a Camera3D by hand and ignores our tween/follow/floor mode).

## Owned files
- `Godot/assets/data/gym_club.json` ("zoom_cameras" add 3 entries only; do not touch other keys - GYMFILL2 just rewrote equipment rows)
- `Godot/scripts/club_rooms/ClubRoomBase.gd` (`_active_zoom_levels`, `zoom_pose`; read in windows)
- `Godot/scripts/GymClub3D.gd` (2148 lines - sed -n windows only; only where it picks levels/roof)
- NEW `Godot/tests/ludo_camera_test.gd`

## Spec
1. New switch `ludo_camera` (career key, then cmdline user arg, default OFF; same pattern as `skip_drawer` in GymHallPanel.gd `_use_skip_drawer`).
2. Add data entries (names fixed): `ludo_overview`, `ludo_zone`, `ludo_fighter`. Ludo's numbers are world positions; convert to our target/distance/pitch form
   and WRITE THE DERIVATION in a `ludo_cameras_note` key. Ludo: overview pos (15,16.5,26.2) look (15,0.4,8.5) FOV 38; zone pos (15,9.2,18.4) look
   (Target_X,0.8,Target_Z) FOV 42; fighter pos (Fighter_X,3.2,Z+4.2) look (Fighter_X,1.4,Fighter_Z) FOV 54. His stated pitches (-36.5/-32/-22) do NOT match
   his own coordinates (the coordinates give about 42 / 41 / 23 deg): USE THE COORDINATES, keep his FOV, and state the pitch you computed.
3. With the switch ON the active wheel levels are exactly `[ludo_overview, ludo_zone, ludo_fighter]`, the roof is hidden at all three, and the existing far
   (roof-on street view) stays reachable by its own call/button only. `ludo_zone` targets the focused place (like `_close_place`); `ludo_fighter` follows
   the fighter exactly like "close" does today (follow_close, line ~974 of GymClub3D.gd - extend the condition, do not copy the code).
4. Switch OFF: byte-identical behaviour (existing tests unchanged).
5. The overview must keep the right 38% free of important content (the drawer) - the FRAME is judged on the game camera by Claude afterwards, not by you.

## Test `ludo_camera_test.gd` (extends SceneTree; prints `LUDOCAM total=N fails=M`; quit(1) on fail, never quit(0) on pass)
(a) OFF: levels list == today's, `zoom_pose` for each equals the pre-change values; (b) ON: levels == the 3 names, step in/out clamps at both ends;
(c) ON: pose of ludo_overview projects the hall's four corner points (0,0,0),(30,0,0),(0,0,18),(30,0,18) inside a 1280x720 viewport (use Camera3D
unproject on a built camera, not mocked); (d) roof visibility false at all three stops; (e) fighter stop target tracks a moved fighter. 2 real mutants red.

## Gates
`python Godot/tools/check_scripts.py <touched .gd>`; focused test; then `python Godot/tools/run_tests.py --only gym_club --jobs 2` and `--only camera --jobs 2`.
Godot only via `Godot_v4.7.2-stable_win64.exe --headless` (NEVER _console.exe). Nothing opens on any monitor; view images with the file tool only.
## The one trap
Cursor cannot see images - do not claim the framing looks right; only the corner-projection test is yours. Commit explicit paths, push branch, never master.
GDScript: typed vars for Variant, no reused local names in a function.
