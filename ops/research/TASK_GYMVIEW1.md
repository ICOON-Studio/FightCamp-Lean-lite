# TASK GYMVIEW1 - a CLEAR gym floor: the default club view shows ONLY the training floor; rooms open from their door

Model: Cursor (cursor_task.cmd). Worktree E:/FightCamp/wt/GYMVIEW1, branch cursor/gymview1 from master. Push the branch; never master.
Never open a window, image viewer or browser (no start / Invoke-Item / os.startfile / explorer). Windowed Godot ONLY via
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>` (hidden desktop). Look at stills with your FILE tool.
Headless: `Godot_v4.7.2-stable_win64.exe` (NEVER `_console.exe`) from `%LOCALAPPDATA%\Programs\Godot\`.

Operator S193 (verbatim): "why these are visible in the gym floor, i want a clear gym floor scene , ask ludo how to present the gym".
Operator approved the verdict on the board (Q-S192-2): "Approve - build it (Cursor)".

## Owned files
- `Godot/scripts/GymClub3D.gd` (1,590 lines - read in sed -n windows). Anchors: consts 21-94, `build` 188, `_build_building` 225,
  `_add_door_gap` 349, `_club_wall` 423, `_build_furniture` 446, `_build_manager` 480, zoom block 555-640 (`zoom_pose` 565,
  `set_zoom` 587, `focus` 617, `_place_camera` 630), wall fade 640-760 (`walls_hiding`, `walls_to_cut`), `_show_tags` ~743,
  goals HUD origin ~1005 (hud2_inset).
- `Godot/scripts/GymClubLayout.gd` (443 lines): `zoom_camera` ~128, front-block rooms ~63-70 (locker_room, physio, reception, office_room).
- `Godot/assets/data/gym_club.json`: `zoom_cameras` (~72) - ADD a `floor_view` block; never change the existing far/mid/close values
  (the OFF arm reads them).
- `Godot/tests/gym_floor_view_test.gd` (NEW), `Godot/tools/gym_floor_view_stills.gd` (NEW, may copy from `tools/gym_club_stills.gd`)
- `previews/gymview1/*.png` (NEW)

## Prior research
- THE design (read it first): `research/LUDO_GYM_VIEW_R18_S193.md` - Ludo's answer + "CLAUDE'S VERDICT" at the end. The verdict
  wins where they disagree: positions come from OUR GymClubLayout (Ludo's coordinates are only examples), stations are the ones we have,
  the HUD keeps today's regions.
- Our layout (GymClubLayout.gd header): z from the BACK wall (0) toward the street. The hall is z 0-12; the FRONT BLOCK (locker room,
  physio, reception, office) is z 12-16.5; the street beyond. Today's `mid` camera deliberately frames the building centre (10, 0, 8.25)
  so the front block shows in the bottom third - that is exactly what the operator rejected.
- Rulings that still hold: rooms stay 3D (D33); rooms are expansions opened from their place in the gym, not a menu (S172); the gym
  floor is a TRAINING floor - no baths/boards/chairs on it (S177); icons over text with tooltips via `UIKit.tip` (not tooltip_text).
- Topic page: `research/topics/gym_rooms_art.md`.

## What would a human do?
Look at the floor with a camera that cannot see the front block, hide the front-block rooms while you are on the floor, put one door
hotspot per room on the hall's front wall, and on a click glide the camera into that room with the wall between dissolving; Esc or a
back chevron glides back. Everything behind one switch so today's view is untouched until the operator OKs the stills.

## Prefab check
Godot built-ins only: Camera3D + Tween (already used by `set_zoom`), `Camera3D.is_position_in_frustum` / `unproject_position` for the
checks. No add-on needed.

## Spec
1. Switch `gym_floor_view` (career key + user arg, same pattern as `is_gym4_club_on` in GameState.gd ~17838 - add
   `is_gym_floor_view_on()` there; that GameState edit is the ONLY one allowed, a 3-line function). Default OFF. NOT in any demo set.
2. ON, floor mode (the default): a `floor_view` camera pose from gym_club.json (start from Ludo: pitch 46, FOV 38, target the HALL
   centre, distance chosen so the hall fills the frame) - tune the numbers until the checks below pass. Front-block rooms are NOT drawn:
   their walls, props, furniture, the manager/desk staff and any visitor standing inside the front block get `visible = false`
   (cull, do not delete). The hall's front wall (the z=12 line) stays a low cut-away stub with the door gaps.
3. ON: one door hotspot per front room on the hall side of that wall: a 0.6 m floor disc (bronze, idle pulse), brightens on hover,
   an icon + `UIKit.tip` naming the room ("Office: contracts and your desk", "Physio", "Reception: walk-ins wait here", "Locker room").
   If a walk-in is waiting at the desk (`_desk_waiters`), the Reception door shows a badge - nobody may be missed because the desk is hidden.
4. ON: click a door -> 0.45 s ease-in-out camera move to that room's pose (derive it from the room rect in GymClubLayout), the front
   block becomes visible, the wall between dissolves via the EXISTING wall-fade machinery (do not add a second fade system). Esc, a
   back chevron (icon + tip), or picking a training station -> 0.35 s back to floor mode, front block hidden again.
5. Mouse-wheel zoom keeps working in floor mode but the pan/zoom is clamped so floor mode NEVER frames the front block.
6. OFF arm: byte-identical behaviour - far/mid/close poses, wall cuts, tags unchanged (the existing club tests must stay green unedited).

## Done = (tier: script edited - parse, focused tests, related runs)
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.
- `gym_floor_view_test.gd` (NEW) builds the club headless at 1920x1080 AND 1280x720 and measures, from the live camera:
  a) ZERO front-block VisualInstance3D nodes that are visible AND inside the camera frustum in floor mode (test every corner of each
     node's transformed AABB, not just two);
  b) the hall floor rectangle (z 0-12) projected to the screen covers >= 70% of the screen area NOT covered by today's HUD Controls
     (measure the HUD rects from the live HUD nodes when hud2 is on; print the area numbers);
  c) every training station's work position projects inside that HUD-free area;
  d) clicking each door enters that room (front block visible, the room centre on screen) and Esc returns (front block hidden, a) holds);
  e) OFF: the switch off -> today's mid pose and the front block visible exactly as on master.
  Write it RED FIRST on today's tree with the switch forced on (a) must fail - the bottom strip shows the rooms); paste the red count.
- `python Godot/tools/run_tests.py --only gym_club --jobs 2` and `--only club_ --jobs 2` -> 0 fails, no existing test edited.
- STILLS (the game's own camera, windowed, hidden desktop, `-- as_game gym4_club gym_floor_view hud2`), saved to
  `previews/gymview1/`: `01_floor_1920.png` (default floor view), `02_floor_1280.png`, `03_door_hover.png` (a door lit with
  its tip), `04_office_open.png` (the office entered), `05_back_on_floor.png`. Gym views are not fight stills (still_framing does not
  apply), but every still must show the whole training floor with fighters/coach visible - no empty frames, no feet-only crops.
  Open every still with your file tool and describe in your final message what each shows.
Commit + push cursor/gymview1. Final message: red count, green results, the area numbers at both resolutions, the five stills.

## The one trap
Hiding the front block must not break anything that LIVES there: walk-ins still walk to the reception desk and the office (the
simulation runs; only `visible` changes), the day/goal HUD still reports them, and interviews still open from the Reception door.
Cull visuals only - never remove nodes, routes or the walk-in schedule.
