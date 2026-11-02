# TASK WALKROUTE1 - a pure route rule: a visitor's walk never crosses a drawn room's wall except through a door (S286, Claude)

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo) - the gym every boxing career plays in; people walk in off the street.

## Why
The player draws his own rooms (MGT2 style, S277-S285). The walk-in graph (`GymClubLayout._shell_walk_in`) joins waypoints with
STRAIGHT legs, so a leg between two doors can cut through a third room's wall - known open since S278 ("two drawn rooms in a line can
still be cut across"). S286 made the reception cut its own street door, so every visitor now starts inside the reception; the next
leg out must leave by a door, never by a wall. We need ONE pure rule that checks and repairs a path.

## Build (pure module + its test; zero preloads, no autoloads, no file I/O, no Node)
`Godot/scripts/rules/WalkRouteRules.gd` (`extends RefCounted`, static funcs only):
1. `static func segment_crosses_wall(a: Vector2, b: Vector2, rooms: Array) -> bool`
   `rooms` = Array of Dictionaries `{"rect": Rect2, "doors": Array[Vector2]}` (each door is a point ON one of the rect's edges,
   1.0 m wide along that edge). True when the open segment a->b crosses any room edge OUTSIDE that edge's door spans. Touching
   or running along an edge does not count as a crossing; passing through a door span does not count.
2. `static func repair_path(points: Array, rooms: Array) -> Array`
   Returns a new polyline (Array of Vector2) with the same first and last point in which no leg crosses a wall: for each bad leg,
   route it through the door(s) of the room(s) it enters/leaves - door point plus a spot 0.7 m inside and 0.7 m outside the door,
   along the edge normal - and around a room it would merely cut across (go round a corner 0.5 m clear of the rect). Keep the
   path short: never add a waypoint the leg does not need. If no repair exists (a room with no door containing an end point),
   return `[]`.
3. `static func path_ok(points: Array, rooms: Array) -> bool` - every leg passes `segment_crosses_wall == false`.

## Test `Godot/tests/walk_route_rules_test.gd` (headless, `extends SceneTree`, prints `WALK_ROUTE failures=<n>`)
Use real gym numbers (building 30 x 22.5 m, street front at z = 22.5): a reception rect (22,18)-(27,22.5) with its street door at
(24.5,22.5) and its own door at (22,20); an office (2,18.5)-(6,22.5) door (6,20.5); a locker room (14,18)-(19,22.5) door (16.5,18).
Cases at least: a leg through a door span = ok; a leg from inside the reception to the training floor (10,10) straight through its
west wall = crosses, repaired path goes via (22,20); a leg (13,20)->(20,20) across the locker room = crosses, repaired path goes
round it (or through it only if both its doors line up - here it has one door, so round); a leg grazing an edge = ok; an end point
inside a room with no door = `[]`; every repaired path passes `path_ok`, starts and ends at the given points, and is no more than
1.6x the straight length for the go-round case. Each check prints `ok:` / `FAIL:` with the numbers.
Prove the test with mutants: break `segment_crosses_wall` to ignore door spans, and to ignore edges - say in the PR body that each
mutant turns the test red (paste the FAIL lines).

## Contract
OWNS: Godot/scripts/rules/WalkRouteRules.gd, Godot/tests/walk_route_rules_test.gd
RED_TEST: Godot/tests/walk_route_rules_test.gd -> WALK_ROUTE failures=0
REGRESSION: walk_route_rules_test
VISUAL: no

## Prior research
Godot/scripts/GymClubLayout.gd `_shell_walk_in` (the graph this will repair; read-only for you), `_door_sides` (0.7 m in/out
convention), tests/shell_walk_in_test.gd and tests/reception_makes_street_door_test.gd (the room fixtures), research/
GDSCRIPT_TRAPS.md (Variant `:=`, typed arrays).

## What would a human do?
Draw the rooms on squared paper, draw the straight line, and wherever it hits a wall away from a door, bend it through the nearest
door or round the nearest corner.

## Prefab check
Godot's AStar2D / NavigationServer2D would need a baked navmesh per drawn layout and a Node; this rule must stay pure and tiny
so the club graph can call it on every rebuild. Segment/rect intersection is ~30 lines - write it.

## The one trap
Do not touch GymClubLayout.gd or any game script - Claude wires it after collecting. No preloads in the module (the fast lane
collects only pure modules + their test).

## Output
PR from your arena branch. Body: the mutant FAIL lines and this line copied from your own run:
`RESULT: tests/walk_route_rules_test.gd -> WALK_ROUTE failures=0`
