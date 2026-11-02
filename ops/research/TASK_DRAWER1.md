# TASK DRAWER1 - the right-third drawer: every screen opens over the gym, time paused (S197)
Model: Arena (cloud) - one pure UI Control + one headless test, no LFS assets.
Operator S197 approved Ludo round 31 Part 1 ("approve all"): "The 3D gym is always the home. A screen is a drawer over the RIGHT
38% (734 px wide, x 1186-1920 at 1920x1080); 62% of the gym stays visible; opening a drawer pauses time."
Spec source: research/LUDO_ROUND31_S197.txt (Part 1 header + 1.1 panel style).

## Build (NEW files only)
1. `Godot/scripts/ui/DrawerHost.gd` - `extends Control`, `class_name DrawerHost`. Full-rect anchored overlay (mouse_filter IGNORE
   except the drawer). API:
   - `open(content: Control, title: String) -> void` - puts `content` in a drawer panel anchored right: width = 38.2% of the
     viewport width (734 px at 1920), full height; slides in from x+width to x in 0.22 s (ease out cubic) - use a
     `_process`-driven tween value so a headless test can call `step(delta)`; replaces any open content (one drawer at a time).
   - `close() -> void` - slides out 0.18 s, frees the content, emits `closed`.
   - `is_open() -> bool`, `step(delta: float) -> void` (public; `_process` calls it).
   - signals `opened(title)`, `closed`, `pause_requested(paused: bool)` - emits `pause_requested(true)` on open and
     `pause_requested(false)` on close (the game connects it to its clock; this module never touches GameState).
   - Esc closes; a click on the uncovered gym area (left 61.8%) does NOT close (the player may click the floor) - only Esc or the
     drawer's own close button (an "X" Button named "Close", 32x32, top-right of the drawer).
   - Style: StyleBoxFlat bg Color("#12161F") alpha 0.96, left border 1 px Color("#D69E2E"), shadow Color(0,0,0,0.65) size 24,
     offset (-8, 0), radius 0. Title Label (name "Title") 22 px, uppercase. Content area is a ScrollContainer (name "Body").
2. `Godot/tests/drawer_host_test.gd` - extends SceneTree, builds a DrawerHost in a 1920x1080 root from code, prints
   `DRAWER total=N fails=M`, quit(1) on fail. Checks: open -> pause_requested(true) once, after step(0.3) the drawer rect is
   x 1186 +-2 .. 1920, width 734 +-2; covers <= 38.5% of the width; title text set; a second open replaces content (child count 1);
   Esc (simulate InputEventKey KEY_ESCAPE via `_unhandled_input`) -> after step(0.3) closed, content freed, pause_requested(false);
   at 1280x720 width = 38.2% too. Write 3 mutants in the PR body (wrong width, no pause signal, click-outside closes) that each fail.

## Rules
Typed GDScript (never `:=` on a Variant), tabs. No preload of game scripts, no autoload. Do not edit any existing file.
Acceptance: `godot --headless --path Godot --script tests/drawer_host_test.gd` exits 0, `fails=0`, no SCRIPT ERROR.
Repository ICOON-Studio/FightCamp; work on your own arena/ branch, open a PR into master, never merge.
