# TASK STATIONS4 - four new training stations on the enlarged floor, each with a real training effect and a per-discipline fit (data + greybox models)

Model: Codex luna (CODEX_MODEL=gpt-6-luna), medium. Worktree E:/FightCamp/wt/STATIONS4, branch codex/stations4 from master. Push the branch; never master, HANDOFF.md, AgentComms/. No windows/viewers/browser; windowed Godot ONLY via
`Tools\godot_hidden.ps1`; `timeout` 300 s on every headless Godot run; parse gate first (`python Godot/tools/check_scripts.py <touched .gd>`).

Operator S195 (Q-S194-5, verbatim): "yes build the four and make sure we have relliastic training stations ( their use impacts fighters in some way) , what boxers use , what grapplers use , what bjj use , what kickboxer use ,
what karate uses etc and everyting need to be displayed so players understand what each stations trains and how it impacts the fighter". Ludo R24 designed the zones (research/LUDO_ROUND24_S195.md); Claude verified them.

## Owned files
- `Godot/assets/data/gym_club.json` - add four places (zones below), their nodes + edges, dressing/prop ids. The hall is 20 x 18 m; aisle bands: bag_strip [2.4,3.0], middle [7.6,8.4], extra_aisles open strip [10.6,12.0], front [16.4,18.0].
  Existing weights: zone [0.4,12.2,4.6,15.6] work [2.5,13.9] approach [2.5,11.4] node mw_w2. New (id | kind | zone | work | approach | node on band):
  agility_ladder | station | [5.8,12.2,7.2,15.8] | [6.5,14.0] | [6.5,16.6] | fa_ladder (front)
  olympic_platform | station | [8.4,12.2,11.0,15.2] | [9.7,13.7] | [9.7,16.6] | fa_platform (front)
  power_rack | station | [12.2,12.2,14.4,14.8] | [13.3,13.5] | [13.3,11.4] | os_rack (open strip)
  expansion_bay | decor | [17.0,13.6,18.8,16.0] | [17.9,14.8] | [17.9,16.6] | fa_bay (front) - an EMPTY marked square reserved for a future station (yellow hatch decal, no equipment)
  (Ludo's film console and mobility mat are NOT built: monitors may not stand on the floor (GYM4 5), the mat duplicates the stretch corner.) Keep >= 1.2 m between neighbouring zones (the expansion bay is moved to x 17.0-18.8 for that).
  Link the new nodes into the aisle graph: front-aisle nodes at z 16.6 join the existing fa_* nodes (z 17.2) and each other; os_rack joins mw_w2 along z 11.4.
- `Godot/assets/data/day_lap_stations.json` - add `agility_ladder`, `olympic_platform`, `power_rack` with `trains` using ONLY attributes that already exist there (conditioning, power, hand_speed, technique, ring_iq, defence)
  and a `drain_per_hour`. Realistic: ladder = footwork/technique + a little conditioning; Olympic platform = power (explosive, high drain); power rack = power (strength, high drain). Rates in the existing range 2-7.
- NEW `Godot/assets/data/station_discipline_fit.json` - for EVERY station in day_lap_stations.json (existing + new) and EVERY discipline in discipline_development_profiles.json (15), a fit multiplier 0.3-1.3 with a one-line `why`
  (what that sport really does there: e.g. heavy bag boxing/kickboxing/muay_thai/karate/taekwondo high, bjj/judo/wrestling low; power rack + platform wrestling/judo/sambo high; ladder karate/taekwondo/boxing/capoeira high, bjj low).
  BOXING must be 1.0 on every existing station so the boxing demo does not change. Add a `summary` per station: one sentence "what it trains and for whom".
- Training application: where a station's `trains` rate is applied to a fighter (grep `drain_per_hour` / `day_lap_stations` in Godot/scripts), multiply by the fighter's discipline fit ONLY when switch `station_discipline_fit`
  is ON (default OFF, off = byte-identical). Same switch pattern as GameState.is_gym_floor_view_on (S195: ON in the game via empty_gym_start(); `--script` tests stay OFF).
- `Godot/scripts/GymClub3D.gd` `_place_model` (grep it): greybox models by catalog id - agility_ladder = 10 painted rungs on the floor (yellow/white, flat), olympic_platform = wood + rubber box platform with a bar and two plate discs,
  power_rack = 4 steel uprights + 2 crossbars + a bar on pegs, expansion_bay = yellow hatch square decal. Flat/greybox only (real models come later from Ludo 3D). Keep them inside their zones.
- Tests: NEW `Godot/tests/station_discipline_fit_test.gd`; extend nothing else's assertions. Existing `gym_club_layout_test`, `gym_club_3d_test`, `gym_floor_view_test`, `club_*`, `floor_*` must stay green.

## Prior research
`python Tools/prior_research.py stations discipline fit equipment` ; LUDO_ROUND24_S195.md ; equipment_catalog.json already has discipline_tags + training_modifiers for footwork_ladder_set, plyometric_step_rig, grappling_dummy, judo_tatami_area, modular_combat_mat - reuse wording.

## Done (tier: data + script edit)
- RED first: `station_discipline_fit_test` fails on master (file missing). Green after: every station x every discipline present, fit in [0.3,1.3], boxing == 1.0 on all existing stations, summaries non-empty, the three new stations exist in
  day_lap_stations + gym_club places, zones inside the hall, no overlap, >= 1.2 m gaps, approach points on the right band and outside every zone, switch OFF -> training gain unchanged (compare one station-hour for a boxer), ON -> a karateka at
  the heavy bag differs from a boxer by the data multiplier.
- `python Godot/tools/run_tests.py --only gym_ --jobs 2`, `--only club_ --jobs 2`, `--only floor_ --jobs 2`, `--only day_lap --jobs 2`, `--only training --jobs 2` -> 0 fails (list counts vs master).
- Stills via `Godot/tools/gym_floor_view_stills.gd` (`-- as_game gym3d_main gym4_club gym_floor_view hud2`, JPG): the floor with the four stations; report pixel facts, do not describe pictures you cannot see.
Commit + push codex/stations4. Final message: red count, green runs, the fit table summary (3 lines), stills path.
