# TASK CAMPICK1 - a camera tool for the owner: the two men in guard, he turns the camera, saves the angle (S559)

Kind: build (a tool under `tools/`; nothing under scripts/). Model: claude-opus-5-5. Discipline: boxing (demo path).
Seat: console worker (claude_cm.ps1). Estimate: 1-2 hours.

## Why
Owner S559, on the Ring Switches pictures (side camera, level): "can you lift the camera a bit and angle it also a bit to
the right so that all limbs can be visible ? or can you make a tool for me to open the 2 fighters in the guard position
on our 3d engine and i will take a picture of the best angle i can find". He gets the tool; the angle he saves is what
every 2D picture is rendered with next (a second job, NOT this one).

## What exists (read these, do not rewrite them)
- `tools/pics2d_set.gd` (499 lines): builds the stage (`FightStage`, bodies by `set=m`, `art=toon`), an orthographic
  camera (`ORTHO_M` 2.55, `LOOK_Y` 1.02, `SIZE` 768), and `_aim(who)` at line ~456: the camera 8 m off on -X, raised by
  `pitch=<deg>` and turned by `yaw_deg`. `tools/pics2d_anim.gd` and `tools/pics2d_anim_more.gd` extend it.
- The guard and the holds: `tools/pics2d_anim_more.gd` `_hold_run` / `_home_guard(step_in, who)`; the three ranges are
  `RANGE_IN` ("" Long, "_r2" Mid 0.355 m, "_r1" Inside 0.71 m).
- Windowed Godot on the owner's screen is what he ASKED for here (he launches it himself). Your own test runs go through
  `python tools/hidden_desktop.py run ...` inside `python ops/Tools/godot_slot.py run --who CAMPICK1 -- ...`, never on his
  monitors, `--audio-driver Dummy`, never `_console.exe`.

## Build
1. `tools/camera_pick.gd` (extends `res://tools/pics2d_set.gd` so the stage, bodies, art and camera are exactly the
   pictures'): both men in the guard at Long, standing still (the guard's first picture held). Window 1600x900.
   Controls, shown in a small corner label with the live numbers (pitch, yaw, zoom = ortho size, look height):
   - drag with the left mouse button: yaw (left/right) and pitch (up/down); mouse wheel: zoom; drag with the right button
     or the arrow keys: look height and sideways shift
   - 1 / 2 / 3: Long / Mid / Inside; H: cycle the holds (both high, lead low + rear high, both low, guard)
   - R: reset to today's camera (pitch 0, yaw 0, ORTHO_M, LOOK_Y)
   - Enter or S: save. Writes `tools/pics2d_camera.json` {pitch, yaw, size, look_y, look_shift, saved_at} and a 768x768
     picture in the picture tool's own framing to `ops/previews/campick/campick_<n>.png`, and says "SAVED" on screen.
2. `tools/pics2d_set.gd`: if `tools/pics2d_camera.json` exists, `_aim` and the camera use its numbers as the defaults
   (command-line `pitch=` / `yaw=` still override). Without the file nothing changes (today's pictures stay identical).
3. `tools/camera_pick.cmd`: one double-click line that starts `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe
   --path E:\FightCamp\Lean --windowed --resolution 1600x900 --audio-driver Dummy --script res://tools/camera_pick.gd`
   (the plain exe, never _console).
4. An `auto=1 pitch=<d> yaw=<d>` mode for your test: sets the camera, saves once, quits.

## Contract
- OWNS: tools/camera_pick.gd, tools/camera_pick.cmd, tools/pics2d_set.gd (only the camera defaults read in `_aim` and setup)
- RED_TEST: none (a viewer); the check is the auto run below
- REGRESSION: with no tools/pics2d_camera.json, one picture run (`only=blue_both_high_high`) gives the same pixels as before
- VISUAL: the auto run's saved picture opened by you: both men head to feet, pitch 12 yaw 20 visibly from above-right

## The one test
`python ops/Tools/godot_slot.py run --who CAMPICK1 -- python tools/hidden_desktop.py run --timeout=300 <godot.exe> --path . --windowed --resolution 1600x900 --audio-driver Dummy --fixed-fps 60 --script res://tools/camera_pick.gd -- auto=1 pitch=12 yaw=20`
-> `tools/pics2d_camera.json` written, `ops/previews/campick/campick_1.png` shows both men whole; then DELETE that test
json (the owner's save is the real one). Parse first: `godot --headless --check-only` style or the repo's parse gate.

## Done
Commit by pathspec (`git commit -- <your files>`), push, and print the one line the owner double-clicks. Report in
`ops/research/CAMPICK1_RESULT.md` (5 lines: what he does, where it saves, what the next job is).

## Prior research
`tools/pics2d_set.gd` `_aim` (pitch / yaw already there), S553 "THE FIGHT MUST BE SEEN, SIDE VIEW, BOTH MEN CHEST TO THE
CAMERA" (render with south=blue), memory "No feet-only stills" (both men head to feet).

## What would a human do?
An artist opens the scene, orbits the camera, and bookmarks the view. This is that, with the numbers saved.

## Prefab check
Godot's own Camera3D and input events; no addon needed.

## Feedback loops
None: a viewer and a saved camera; nothing feeds back.
