# TASK U204 - menu and room effects: screens that move and rooms with air in them (UI/visual, Cursor)
Owner: Cursor (composer). Worktree D:/FightCamp/wt/U204, branch cursor/u204-menu-room-fx (from master).
Operator 2026-10-01, verbatim: "we also need effects special effect on the fight and on the menus an rooms".

## Why
No particle or transition effect exists in the game. Screens cut hard; rooms are still.

## Prior research
`python Tools/prior_research.py transition tween hover feedback particles dust light shaft`; `DesignLibrary/GLOSSARY.md`
(icon-with-tooltip direction); `research/topics/ui_screens.md`; `research/topics/gym_rooms_art.md`.
`Godot/scripts/UIKit.gd` is 8,338 lines - grep, never read whole; `Godot/scripts/SceneRouter.gd` (446 lines, the screen
push). Rooms: `Godot/scripts/TrainingFloor3D.gd` (`_build_environment`), Office3D.gd, Lobby3D.gd, LockerRoom3D.gd,
MatRoom3D.gd, StaffRoom3D.gd, PhysioRoom3D.gd.

## What would a human do?
Football Manager / Motorsport Manager polish: a screen change is a 180 ms fade + short slide; buttons scale 1.03 on
hover and dip on press; money and stat changes COUNT UP over ~0.6 s with a small glow; a reward or breakthrough gets a
brief particle pop. Rooms: slow dust motes in the window light (CPUParticles3D, 40-80 particles, very slow, warm), a soft
light shaft through the main window, nothing that flickers. Bright and alive (operator rule), never dark.

## Prefab check
Godot built-ins (Tween, CPUParticles2D/3D - GL Compatibility renderer). No downloads.

## Owned files
- NEW `Godot/scripts/UiFx.gd` (static helpers: fade_slide_in(control), hover_scale(button), count_up(label, from, to),
  pop(control)) + hooks in SceneRouter.gd (screen push) and UIKit.gd (button factory, money/stat labels). Name each
  edited line range in the digest.
- NEW `Godot/scripts/RoomFx.gd` (dust_motes(room: Node3D, window_rect: AABB), light_shaft(...)) + ONE call per room script.
- A switch so tests stay byte-stable: effects OFF under `--script`/headless (read how the fight room's switches do it).
- NEW `Godot/tests/ui_fx_test.gd`: helpers create and free their tweens/particles; switch OFF adds no nodes.
- Before/after stills of 3 screens + 3 rooms (hidden windowed runs via `Tools\godot_hidden.ps1`) ->
  `previews/u204/`. OPEN THEM. NEW `research/U204_DIGEST.md`.

## Tests
Parse gate on every touched .gd (`python Godot/tools/check_scripts.py <files>`), the test alone, then
`python Godot/tools/run_tests.py --jobs 2 --only ui_fx,screen,room,office,locker,lobby,staff,physio,mat_room,training_floor`.
Watchdog first: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`. Never the full suite.

## The one trap
Full-rect-anchored Controls: never assign `size` on mount - animate `modulate` and position offsets, not size.
`remove_child(node)` before `queue_free()` on UI rebuilds.

## Finish
git add by explicit path, commit, git push -u origin cursor/u204-menu-room-fx. Do not stop at "written".
