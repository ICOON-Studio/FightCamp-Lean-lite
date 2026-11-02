# TASK ROOMS2 - the staff room, the physio and the locker room become bigger and read as rooms

Model: Cline seat (OpenRouter model in Tools\cline_task.cmd). Owner: Cline. Worktree `E:/FightCamp/wt/CLINE`, branch
`cline/rooms2` (from master dd2e16e3). Part of ROOMSUI1 (Claude); Claude reviews and merges.

## Why (operator, verbatim)
S151: "i think i like the 3d aspect better and seems pretty much done only some rooms need to be bigger and repurposed maybe".
S151 on the floor: "this room needs to be bigger".

## The problem (primary source - open these stills with your FILE tool first)
`previews/q232/staff_ui1.png`, `physio_ui1.png`, `locker_ui1.png`, `office_ui1.png` (1920x1080):
- STAFF ROOM (`Godot/scripts/StaffRoom3D.gd`, 827 lines, `STAFF_W 8.0` x `STAFF_D 6.0` at line 22): the table, sofa,
  lockers and two seated coaches fill the floor wall to wall; the camera is so close the side walls are cut.
- PHYSIO (`Godot/scripts/PhysioRoom3D.gd`, 534 lines, `PHYSIO_W 8.0` x `PHYSIO_D 6.0` at line 27): bath, treatment
  bed, chairs and four people crowd one strip; the chart wall is jammed into the back corner.
- LOCKER ROOM (`Godot/scripts/LockerRoom3D.gd`, 564 lines, `LOCKER_W 9.0` x `LOCKER_D 6.0` at line 20): the opposite
  fault - the room is a small box in the middle of the view (about 45% of the view width), black around it.
- The OFFICE (`Office3D.gd`, 8.0 x 6.0, camera `_build_office_camera` ~line 899) is the reference that reads well:
  the room fills the view, the furniture has floor around it.

## Build
1. Staff room and physio: grow each room to 10.0 x 7.5 m (W x D; wall height unchanged) and RE-LAY its furniture and
   people across the bigger floor - nothing touching a wall it does not belong against, a walkway from the door
   (`doors[0]` position) to the room's centre, the clickable objects (`layout_for(...)["objects"]`) still in sight. Move
   each object's `"at"` with its mesh: the click box IS `objects[id]["at"]/["size"]` (`clickable_boxes()` in
   `TrainingFloor3D.gd`), so a mesh moved without its box makes a dead click.
2. Locker room: grow to 10.0 x 7.0 and re-frame its camera so the room fills the view like the office (the room's
   floor spans >= 80% of the view width at its front edge).
3. Each room's camera: whole room in frame, no side wall cut, doorway sign readable, title slot (top-left plate) not
   covering an object marker.
4. Stills: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q232_render.gd -- tag=rooms2 rooms=staff,physio,locker`
   (check the tool's own `rooms=` ids in its header first) -> `previews/q232/*_rooms2.png`. OPEN each with
   your FILE tool, compare against the `_ui1` stills, and write in the digest what changed and what still looks wrong.

## Acceptance
- Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <files>`.
- `python Godot/tools/run_tests.py --only staff_room,physio_room,locker_room,room_click_marks,office_room --jobs 2`
  -> all green. `room_click_marks_test` proves every marker sits on a clickable and a hover over each object's box
  hits it - if it goes red you moved a mesh without its box.
- A new check in `Godot/tests/room_click_marks_test.gd` (append, do not rewrite): for staff/physio/locker, the room
  shell is the new size (read `layout["shell"]`), and every object's marker point lies inside the view rect
  (`marker_points()` vs the view size 1608 x 944).
- Three `_rooms2` stills opened and described in `research/ROOMS2_DIGEST.md` (one paragraph each + the test lines).

## Owned files
`Godot/scripts/StaffRoom3D.gd`, `Godot/scripts/PhysioRoom3D.gd`, `Godot/scripts/LockerRoom3D.gd`,
`Godot/tests/room_click_marks_test.gd` (append only), `previews/q232/*_rooms2.png`,
`research/ROOMS2_DIGEST.md`. Do NOT edit Office3D.gd, TrainingFloor3D.gd, OfficeRoomPanel.gd, RoomClickMarks.gd or
any *Panel.gd (Claude is changing them).

## The one trap
The click box and the mesh are two separate numbers: `layout_for()`'s `objects[id]["at"]` and the `_build_*` function's
mesh position. Move both, every time, or the click lands on empty floor.

## Rules
Commit on `cline/rooms2` and push `git push origin cline/rooms2`. Never commit `*.import`. One Godot process at a time.
Never open a viewer or window on the operator's screens (file tool only; renders only through Tools\godot_hidden.ps1).
Never edit HANDOFF.md. Run `git` commands one at a time (the worktree index lock trips on parallel git calls).
Do not stop at a plan.

## Prior research
`python Tools/prior_research.py staff room physio locker bigger` -> S151_DIGEST (D33 rooms stay 3D), SCENETREE2
(Tools/scene_tree_analysis.py: staff_room / physio / locker_room entries), M41_SCENE_TREE_ART_REVIEW.md (art direction
per room), topics/gym_rooms_art.md.

## What would a human do?
A level artist widens the room, spreads the props so each reads on its own with floor around it, and re-frames the
camera until the room fills the shot - then clicks every object to check nothing went dead.

## Prefab check
No asset needed: same props, new placement.
