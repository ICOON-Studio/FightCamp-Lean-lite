# TASK STATIONINFO1 - the player sees what every station trains and how it impacts his fighter (floor UI, switch station_info)

Model: Cursor (cursor_task.cmd). Worktree E:/FightCamp/wt/STATIONINFO1, branch cursor/stationinfo1 from master. Push the branch; never master, HANDOFF.md, AgentComms/. No windows/viewers/browser; windowed Godot ONLY via
`Tools\godot_hidden.ps1`; your image tool is blocked: prove visuals with geometric/pixel checks and say so in your first line.

Operator S195 (verbatim): "everyting need to be displayed so players understand what each stations trains and how it impacts the fighter". Companion task STATIONS4 (Codex) adds `Godot/assets/data/station_discipline_fit.json`
(per station x 15 disciplines: fit 0.3-1.3 + a `why` + a per-station `summary`) and the stations agility_ladder / olympic_platform / power_rack. Until STATIONS4 merges, read that file with a safe fallback (no crash if missing).

## Owned files
- NEW `Godot/scripts/StationInfoCard.gd` (pure UI builder, UIKit patterns: `UIKit.tip`, never tooltip_text; icons with tooltips; the facility is a "gym"): a card for one place id showing
  1) title + the one-line summary, 2) TRAINS: each attribute and its rate per hour from `day_lap_stations.json` (`trains`, e.g. "Power +6.5 / hour") as small bars, 3) COSTS: stamina drain per hour,
  4) BEST FOR: the three disciplines with the highest fit and the fighter's own discipline fit with its `why` (e.g. "Heavy bag - karate x1.2: ..."), 5) CONDITION: the equipment wear/condition if the catalogue/upkeep data gives one (grep
  `equipment_catalog`, `maintenance_cost`; if the station has no wear model show nothing), 6) in the day planner the same card on hover of the station choice.
- `Godot/scripts/GymClub3D.gd` + `Godot/scripts/FloorPlay*`/`GymHallPanel.gd` (grep `floor_pick`, `thing_at`, `hover`): hovering a station on the floor shows the card near the cursor; clicking keeps today's behaviour.
- `Godot/scripts/GameState.gd` ONLY `is_station_info_on()` beside `is_gym_floor_view_on()`: default OFF; ON in the game via `empty_gym_start() or user arg station_info` (same pattern as is_gym_floor_view_on).
- NEW `Godot/tests/station_info_card_test.gd`, NEW `Godot/tools/station_info_stills.gd` (stills on the game camera, JPG in `previews/stationinfo1/`).

## Prior research
`python Tools/prior_research.py station info tooltip card` ; floor_pick_station_test (how stations are picked) ; UIKit.tip (tooltips) ; HUD2 pieces.

## Done (tier: script edit)
- Parse gate on every touched .gd. RED first: `station_info_card_test` fails on master; green after: the card for each of the 9 existing stations lists exactly the attributes in day_lap_stations.json with the same rates,
  names the fighter's discipline fit when the fit file exists, survives the file missing, OFF -> no card node, ON -> hovering heavy_bag / weights / pads builds the card, and the card never extends outside the 1280x720 viewport.
- `python Godot/tools/run_tests.py --only gym_ --jobs 2`, `--only floor_ --jobs 2`, `--only club_ --jobs 2` -> 0 fails.
- Stills (game camera, `-- as_game gym3d_main gym4_club gym_floor_view hud2 station_info`): the floor with a card open on the heavy bag and on the weights; report geometric/pixel facts (card inside viewport, text lines count).
Commit + push cursor/stationinfo1. Final message: red count, green runs, stills path.
