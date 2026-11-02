# TASK COACHWALK1 - the coach WALKS to the fighter's station and works beside him (S238, LOOP1 slice 2 part 1)

Seat: Grok Dev (gbot `--to dev`, own Linux box, Godot 4.7.2, no LFS). Branch `grok/coachwalk1`, PR to master; Claude merges by diff.
Model: Grok Dev default. Discipline: BOXING (the demo).

Operator S237 (verbatim): "you look for a coach to assign to him and watch them work together". Approved verdict (board Q-S237-1,
research/LOOP1_VERDICT_S238.md loop step 4). Lead designer Ludo r102 (`research/ludo_rx/LUDO_R102_LOOP1_raw.txt` section D):
"The coach walks smoothly from their idle/office node along the designated aisles to station workpoint", stands ~1.5 m from the
fighter, and a speech line pops over the station ("His jab is dragging, Coach. Pull him off the bags!").
Audit S229 (Ludo r81 #3): "coach proximity feels decorative".

## What is on master (read; GymHall3D.gd is ~3,900 lines - use `sed -n` windows, never read it whole)
- `Godot/scripts/GymHall3D.gd` `coach_to(place_id)` (~line 2780): TELEPORTS the Coach node: `coach.position = work_position(place_id)
  + Vector3(0.9, 0, 0)` and floats "COACH WITH HIM". `_coach_place` is set at once.
- The fighter walks: `send_to(place_id)` (~line 731) takes `_layout().route(from_place, place_id)` -> {ok, points, metres} and
  walks `_route_points` over walk minutes (see `_route_points`, `_walk_total`, `_is_walking()` and how the fighter's node follows the
  points each minute - reuse that interpolation for the coach; do not write a second path-finder).
- `GymClub3D.gd` `_walker_clip(node, walking, speed)` (~line 996) switches a body between idle and walk clips.
- Coach effects already exist: a block counts as coached when `_coach_place == _place` (gain mods, DayPlan coach_mods, the meters'
  `coached` flag - rules/TrainingMeters warns one zone earlier when coached).

## Do
1. `coach_to(place_id)`: the coach WALKS the aisle route from where he stands (his seat place, or his last station) to the station,
   at walking speed on the same game clock as the fighter; `_coach_place` becomes the station only when he ARRIVES (until then the
   block is not coached). He faces the fighter on arrival and stands at a coach anchor ~1.2-1.5 m from the fighter's work point,
   never inside equipment (check with the route/clearance helpers the fighter uses).
2. While walking: the walk clip; on arrival: idle (the work clips come next round from Ludo - leave a `coach_work_clip(station_kind)`
   hook returning "" for now, called on arrival).
3. A coached block shows one speech line over the station on arrival (pick from 3 boxing lines per station kind - pads, heavy bag,
   ring, footwork, cardio; plain words, no MMA), via the existing `_float_text`.
4. `coach_to("")` sends him back to his seat the same way.
5. Keep `coach_to` returning {"ok": true} at once (callers expect it), plus "walk_minutes" / "metres".

## Tests (red on master first - paste the red lines in the PR body)
New `Godot/tests/coach_walk_test.gd` modelled on `tests/spar_block_floor_test.gd` (build the club with load_models false, start_day,
advance_minutes). Population printed: a male welterweight boxer "Coach Walk Tester" and coach "Ray Holl". Assert: right after
coach_to(station) the coach is NOT at the station and the block is not coached; after enough minutes he IS there (distance to the
fighter 1.0-1.8 m) and the block is coached; his position moved along the route (sampled mid-walk positions lie near the route
points, not a straight line through equipment); a speech line was floated; coach_to("") walks him back. Control: the old teleport
behaviour is gone (no frame where he is at the station before walking).
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/coach_walk_test.gd`, then
`python Godot/tools/run_tests.py --jobs 2 --only coach,floor_gain,day_plan,training_meters` and paste the SUITE line + any FAIL's own line.
Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/GymHall3D.gd Godot/tests/coach_walk_test.gd`.

## Rules
GDSCRIPT_TRAPS.md (`signal` is a keyword - never a variable name). Do not edit rules/*.gd. THE ONE TRAP: a test that breaks because the
coach now arrives later gets its wait extended - never the teleport put back.

## Prior research
LUDO_R102_LOOP1_raw.txt section D, LOOP1_VERDICT_S238.md, TASK_SPARWIRE1.md (your last floor round), S229 audit (Ludo r81 #3).

## What would a human do?
The coach puts his coffee down, walks over between the bags, stops at the fighter's shoulder and says one thing.

## Prefab check
None - our club's own routes and walkers.
