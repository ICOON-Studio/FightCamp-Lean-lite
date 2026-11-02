# TASK ISOCAM1 - the gym on an orthographic isometric camera; every room visible; only LIVE objects clickable (S240)

Seat: cloud Cursor (Godot gameplay scripts). Branch `cursor/issue-<n>`, Claude merges by diff. Model: Cursor default.
Discipline: BOXING (the demo) - the gym club camera only; the fight camera is untouched.

## Why (operator ruling, board Q-S239-1, verbatim)
"3D World + Orthographic Isometric Projection): STRONGLY RECOMMEND. Keep every single 3D asset, mocap clip, MetaHuman rig, and material
as-is. Simply swap the camera projection to PROJECTION_ORTHOGONAL at standard isometric angles (35.264 pitch, 45 yaw) [...] Add all the
rooms we have rdy so their opjects )desk PC in Office) can be accessed with unzooming gym floor a bit and and clicking it. we switch on
other objects on rooms (rooms should still render as designed only objects can't be interacted yet) 1 at a time when mechanics enforce it"
+ "yes of course we enable whaever is necessary for this loop and make interactable". Lead designer Ludo r108 agreed (spec below).

## Spec (Ludo r107 + r108 - research/ludo_rx/LUDO_R107_raw.txt, LUDO_R108_raw.txt)
1. New switch `iso_camera` in `GameSwitches.GAME_ON` (read with `GameSwitches.on("iso_camera")`, never a raw cmdline check). When ON, in
   the club FLOOR VIEW (`_floor_view_on`, `FLOOR_ZOOMS = ["floor_far","floor_view","floor_close"]`, ClubRoomBase.gd line 12):
   - `camera.projection = Camera3D.PROJECTION_ORTHOGONAL`, pitch -35.264 deg, yaw one of 45/135/225/315 - pick the one that keeps the
     hall's ring/back brick wall at the top of the screen (say which in the PR), roll 0. near 0.1, far 200.
   - `camera.size` per step: floor_far = 36.0 (WHOLE CLUB: every room in frame), floor_view = 16.0 (DEFAULT), floor_close = 7.0.
     Zoom steps tween size (0.25 s, sine). Panning keeps working; the camera position = target - forward * 60 m (distance does not zoom).
   - Room views (`_enter_room`, `_room_camera_pose`, ClubRoomBase.gd ~933/~1082) use the same projection, size 7.0, centred on the room.
   - Front (camera-facing) walls: cut to 0.45 m or faded (the existing `_update_wall_fade` path); back walls full height.
   - OFF (plain `--script` tests, the control arm): today's perspective cameras exactly as now (fov from gym_club.json zoom_cameras).
2. LIVE OBJECTS ONLY: a room prop answers hover/click ONLY if its `"<room>:<prop id>"` is in a new data list
   `gym_club.json` -> `"live_objects": ["office:desk"]` (the desk opens the PC, route `office_pc`; Claude wires the screen). Every other
   prop: no hover text, no cursor change, a click does nothing (silent) - but it still renders exactly as now. Keep LIVE also whatever
   the playable loop already uses from the rooms (check tests/playable_loop_test.gd and the room scripts' `_targets`; today the loop uses
   the top nav, not room props - confirm and list what you found). Hook: the room scripts' `object_at_ray` (ClubRoomOffice.gd 140,
   ClubRoomReception.gd, ClubRoomPhysio.gd, ClubRoomLocker.gd, ClubRoomEquipmentStore.gd) and `GymClub3D.thing_at` (line 1298) - filter in
   ONE place (thing_at), not in five copies.
   - The office desk click box = the desk plus 0.5 m (2.2 x 1.2 x 1.4 m), so it is easy to hit at size 36.
   - Room props must be clickable FROM THE FLOOR VIEW (no entering the room needed) when live.
3. Inactive rooms (no live object): key light x0.85 and cooler (4200 K) vs live rooms 1.0; never dark.
4. A billboard tag over the office desk at y = 2.1 m: "OFFICE PC" (dark slate #0F172A 85 %, 1 px gold #F59E0B border, ~160x34 px on
   screen at every zoom - fixed_size); `set_office_badge(text)` shows an amber pill above it ("[!] 2 NEW BOUTS"), "" hides it.

## Tests (red on master first - paste the red line in the PR body)
New `Godot/tests/iso_camera_test.gd` (extends SceneTree, prints `ISO_CAMERA failures=N`, quit(1) on fail). Build the club like
tests/goal_settle_floor_test.gd `_day()` (GymClub3D, load_models false). Set `career["iso_camera"] = true` for the ON arm, false for OFF.
Check: ON -> projection ORTHOGONAL, size 16 at floor_view, 36 at floor_far, 7 at floor_close; pitch -35.264 +-0.01; at floor_far every
room's floor rect corners (Club.rooms()) unproject inside the 1920x1080 viewport; `thing_at` over the office desk from floor_far returns
route office_pc; over the physio table / a locker returns {} (silent); OFF -> PROJECTION_PERSPECTIVE and the old fov. Then
`python Godot/tools/run_tests.py --only club --jobs 2` and `--only gym_hall --jobs 2`: no NEW reds vs master (paste both SUITE lines).
Command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/iso_camera_test.gd`. Parse gate first:
`python Godot/tools/check_scripts.py <touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md. ClubRoomBase.gd (1,747 lines) and GymClub3D.gd (2,988) - grep + read windows, never whole. Do not touch GymHall3D.gd's
goal/meter code (Claude is editing it). New features ship ON (GAME_ON); plain --script tests stay the OFF arm.
THE ONE TRAP: never delete or weaken a test to go green; never change the fight camera.

## Prior research
LUDO_R107_raw.txt (camera: sizes, pitch/yaw, wall cut-away), LUDO_R108_raw.txt (live objects, desk click box, office tag, inactive-room
light), U177_HUB_DISPLAY_EVAL.md / G106_HUB_DISPLAY_EVAL.md (Two Point / Mad Games Tycoon 2), LUDO_GYM_VIEW_R18_S193.md.

## What would a human do?
Play Two Point Hospital: one fixed iso angle, scroll out to see the whole building, click the one thing that does something.

## Prefab check
Godot's built-in Camera3D orthographic projection - nothing to download.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <the defect>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
