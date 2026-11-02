# TASK ROOMS2B - every room's door to the training floor is in view, sign whole

Model: Cline seat (OpenRouter model in Tools\cline_task.cmd). Owner: Cline. Worktree `E:/FightCamp/wt/CLINE`, new branch
`cline/rooms2b` from master 142afd69 or later (`git fetch` is not needed - the worktree shares the repo: `git checkout -B
cline/rooms2b master`). Part of ROOMSUI1 (Claude); Claude reviews and merges.

## Why
Operator S151: "i want the items that are clickable highlighted somehow so i knowwhere i can click". The door back to the
floor is a clickable. In four rooms its sign board over the lintel is cut by the view's left edge ("AINING / OOR"), and in
the OFFICE the whole door is off-view (only "F TRAINING" painted on the floor shows at the bottom-left).

## The problem (primary source - open these stills with your FILE tool first)
`previews/q232/office_s153.png`, `mat_s153.png`, `staff_s153.png`, `physio_s153.png` (1920x1080; the 3D view is
the 1608x944 rect from x=288, y=112). The door sits on the LEFT wall close to the camera, so its 2 m sign board runs toward
the lens and off the frame. Measured (S153, the check below), corners of the 'floor' door's SignBoard projected into the view:
- office: all 8 corners out (x -158 .. -1090) - the door itself is out of the shot.
- mat: 4 out (x -96 .. -179). staff: 4 out (x -121 .. -198). physio: 4 out (x -124 .. -203).

Door config = each room's `layout_for(...)["doors"]` entry `{"id": "floor", "wall": "left", "position": Vector3(0, 0, z)}`:
- `Godot/scripts/Office3D.gd` (1112 lines) line ~58: z 4.2; camera `_build_office_camera` ~line 900 (fov 47).
- `Godot/scripts/MatRoom3D.gd` (397 lines) line ~52: z 5.0; camera ~line 388 (fov 52).
- `Godot/scripts/StaffRoom3D.gd` (856 lines) line ~63: z 4.4; camera ~line 837 (fov 52).
- `Godot/scripts/PhysioRoom3D.gd` (561 lines) line ~62: z 4.4; camera ~line 534 (fov 54).
The door itself is built by `TrainingFloor3D._build_doors` / `_doorway` (do NOT edit that file).

## Build
1. Per room, move the floor door deeper along the left wall (smaller z, away from the camera) and/or re-aim the camera,
   until the check below passes. Whatever stood on the wall where the door goes moves with its click box (the trap).
   Prefer moving the door: the cameras were framed in ROOMS2 and the right-hand kit is near the right edge already.
2. Keep a walkway from the door to the room's centre; nothing stands on the door mat.
3. Stills: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q232_render.gd -- tag=rooms2b rooms=office,mat,staff,physio`
   (check the tool header for the room ids). OPEN each with your FILE tool; the door, its sign and its marker must read whole.

## Acceptance
- Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <files>`.
- Append the check in `AgentComms/prompts/ROOMS2B_door_sign_check.gd.txt` VERBATIM into `Godot/tests/room_click_marks_test.gd`,
  just before the `root.remove_child(panel)` line inside the per-room loop. On master today it reads 4 FAILs (office, mat,
  staff, physio) - run it first and record that red. After your change: 0 failures.
- `Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/<name>.gd` (exe in
  `%LOCALAPPDATA%\Programs\Godot\`), one at a time, for: room_click_marks, room_body_scale, office_room, mat_room,
  staff_room, physio_room, locker_room -> all 0 failures. (Run them one by one; the --only runner timed out for you in ROOMS2.)
- Four `_rooms2b` stills opened and described in `research/ROOMS2B_DIGEST.md` (one paragraph each + the test lines,
  including the red-before line).

## Owned files
`Godot/scripts/Office3D.gd` (the doors entry, the camera, and any wall object the door displaces - nothing else),
`Godot/scripts/MatRoom3D.gd`, `Godot/scripts/StaffRoom3D.gd`, `Godot/scripts/PhysioRoom3D.gd`,
`Godot/tests/room_click_marks_test.gd` (append only), `previews/q232/*_rooms2b.png`, `research/ROOMS2B_DIGEST.md`.
Do NOT edit TrainingFloor3D.gd, OfficeRoomPanel.gd, RoomClickMarks.gd or any *Panel.gd.

## The one trap
Office3D.gd is the BASE class of the locker room (`LockerRoom3D extends Office3D`) and the others; change only the
office's own `layout_for` door entry and `_build_office_camera`, never a shared helper, or the locker room moves too.
And a moved wall object needs its click box (`objects[id]["at"]`) moved with its mesh, or the click goes dead.

## Rules
Commit on `cline/rooms2b` and push `git push origin cline/rooms2b`. Never commit `*.import`. One Godot process at a time.
Never open a viewer or window on the operator's screens (file tool only; renders only through Tools\godot_hidden.ps1).
Never edit HANDOFF.md. Run `git` commands one at a time. Do not stop at a plan.

## Prior research
`python Tools/prior_research.py door sign view crop` -> J16 (gym floor plan), S91 (front door); ROOMS2 (this seat, S152:
the three rooms re-framed, 569d8235); TASK_ROOMS2_BIGGER_BACK_ROOMS.md step 3 already asked for "doorway sign readable" -
the stills show it was not met; this task closes it with a check that can fail.

## What would a human do?
A level designer puts the exit where the player can see it - on a wall the camera faces - then frames the shot so the
exit sign reads whole, and clicks it.

## Prefab check
No asset needed: same door, new placement.
