# TASK CLUBROUTES1 - the day plan painted on the club floor (colour-coded drill routes), behind `club_routes` (default OFF)

Model: Cursor (cursor_task.cmd). Worktree E:/FightCamp/wt/CLUBROUTES1, branch cursor/clubroutes1 from master. Push the branch; never
master, never HANDOFF.md, never AgentComms/. Never open a window, image viewer or browser; windowed Godot ONLY via
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`. `timeout` on every Godot run (300 s headless).
Your image tool may be blocked: prove every visual claim with a geometric/pixel check, and say in your first line if it is blocked.

Operator S188 ("yes all picks", CLUBROUTES1): "Painted, colour-coded drill routes on the club floor showing the day plan". Ludo's mock:
`previews/ludo_s188/gym_topdown_drill_routes.jpg`. Ludo R18 (LUDO_GYM_VIEW_R18_S193.md s4.3): the routes pulse at 12%
opacity during the day and brighten to 85% while the day plan is being edited or a station is hovered.

## Owned files
- `Godot/scripts/GymClub3D.gd` (~2,500 lines after GYMVIEW1 - windows only; you know it from GYMVIEW1). Hooks: the day schedule
  (`_schedule`, `_plans`, grep `day_plan` / `_schedule`), station work positions (`work_position(place_id)`), the floor view switch
  (`_floor_view_on`), hover (grep `hover` / `set_door_highlight`).
- `Godot/scripts/GameState.gd` - ONLY `is_club_routes_on()` beside `is_gym_floor_view_on()` (same pattern).
- `Godot/tests/club_routes_floor_test.gd` (NEW), `Godot/tools/club_routes_stills.gd` (NEW), `previews/clubroutes1/*.jpg`.

## Prior research
- Pure rules merged S194 (a3e90edc): `Godot/scripts/rules/ClubRoutes.gd` (`build_day_spline_points`, `get_station_color`,
  `evaluate_route_progress`, `calculate_shader_pulse_offset`) + `Godot/assets/data/club_routes.json` (categories + colours). REUSE them.
  The json's station positions are Ludo's examples - positions come from OUR layout (`work_position`), only categories/colours from the json.
- Gym floor = a training floor (S177): the routes are paint on the floor, flat, under people and equipment (never floating).

## Spec
1. With `club_routes` on: for the selected fighter's day plan, a flat ribbon on the floor (y = floor + 0.01 m) through his stations in
   order, coloured per segment by the station's category; dashes animate along it (calculate_shader_pulse_offset); 12% opacity normally,
   85% while hovering a station on the route or while the day plan is open; the segment already done (evaluate_route_progress) is dimmer.
2. Works in both the old club view and `gym_floor_view`; OFF -> no node added, the club byte-identical.
3. Ribbons never cross a station's footprint (route around it by the station's work position) and never leave the hall rect.

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate on every touched .gd.
- `club_routes_floor_test.gd` (headless): two DIFFERENT fighters' day plans -> ribbon points follow their station order; segment colours
  = the category colours; points stay inside the hall rect and outside every station footprint; opacity 0.12 idle / 0.85 on hover;
  OFF -> no ribbon node. RED first on master (paste the count), then green.
- `python Godot/tools/run_tests.py --only gym_club --jobs 2`, `--only club_ --jobs 2`, `--only gym_floor --jobs 2` -> 0 fails.
- Stills (game camera, hidden desktop) `-- as_game gym3d_main gym4_club gym_floor_view club_routes hud2`: 01_routes_idle, 02_routes_hover
  -> saved as JPG under `previews/clubroutes1/`. Describe each from your checks.
Commit + push cursor/clubroutes1. Final message: red count, green results, the stills.

## The one trap
The day plan changes during the day (the coach re-plans, a station is taken): rebuild the ribbon from the plan when it changes, and
`remove_child` before `queue_free` - never stack a new ribbon on the old one.
