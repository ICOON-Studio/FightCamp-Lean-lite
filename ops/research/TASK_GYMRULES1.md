# TASK GYMRULES1 - a real-gym rule checker for the club floor plan (pure module + test)

Model: Qwen (qwen3-coder). Worktree E:/FightCamp/wt/GYMRULES1, branch qwen/gymrules1 from master. Commit + push the branch; never
master, never HANDOFF.md, never AgentComms/. Never open a window, viewer or browser. Headless Godot only:
`%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/club_layout_rules_test.gd`
(NEVER `_console.exe`), with a 300 s timeout.

## Why
Operator S200/S201 (Q-S199-2): the gym floor was filled by a packing script to hit test quotas ("6 first-aid cabinets, 7 speed
bags, a bag in the weights, freestanding bags mid-floor"). Three competing hand-made layouts are coming (Claude, Ludo, another
agent). Each must pass REAL-GYM RULES, not "45% full". You write the rule checker.

## Owned files
- `Godot/scripts/rules/ClubLayoutRules.gd` (NEW, `extends RefCounted`, ZERO preloads, static funcs only).
- `Godot/tests/club_layout_rules_test.gd` (NEW, `extends SceneTree`).

## Input data (read, never edit)
- `Godot/assets/data/gym_club.json` (41 KB): `room` {w, hall_d, front_aisle [z0,z1], middle_aisle [z0,z1], ...}; `places` {id: {kind
  "station"|"decor", station, zone [x0,z0,x1,z1], solid, prop, bag [x,z] (heavy bags only) ...}}; `floor_zones` [{id, label, rect
  [x0,z0,x1,z1], items [{id, x, z, yaw}]}] - item x/z are hall metres; `nodes` {id: [x,z]}; `edges` [[a,b]].
  Hall: x 0 (west wall) -> w (east wall), z 0 (back wall) -> hall_d (front wall with the room doors).
- `Godot/assets/data/equipment_catalog.json`: `items` [{id, category ("bags","cardio","strength","recovery","ring","analysis"),
  footprint [w,d] metres ...}]. Floor items whose id is not in the catalogue (e.g. "speed_bag", "heavy_bag", "first_aid",
  "cardio_floor") use this fallback category map: heavy_bag/speed_bag/double_end_ball -> bags; first_aid -> medical;
  cardio_floor/jump_rope_area -> cardio.

## API (exact)
`static func check(club: Dictionary, catalog: Dictionary) -> Array` - one Dictionary per violation:
`{"rule": "<R id>", "item": "<zone id or place id>/<item id>", "detail": "<plain words with the numbers>"}`; empty = passes.
Rules (the real-gym sources are in `research/G121_REAL_GYM_FLOOR_PLANS.md`, the audit in `GYM_ZONE_AUDIT_S200.md`):
- R1 BAGS ON WALLS: every heavy bag (floor item `heavy_bag`, or a place with station `heavy_bag` - use its `bag` point, else zone
  centre) is <= 1.2 m from the back wall (z=0), the west wall (x=0) or the east wall (x=w). Never mid-floor.
- R2 NOTHING BEHIND A BAG: no other floor item or solid place lies between a heavy bag and its nearest wall (inside the strip from
  the wall to the bag, +-0.6 m either side of the bag along the wall).
- R3 BAG SPACING: two heavy bags on the same wall are >= 1.5 m apart (centre to centre).
- R4 WALK CLEAR: no SOLID place zone and no floor item point lies inside the front aisle band (room.front_aisle z range) - that is
  the walk from the street door.
- R5 RIGHT ZONE: a floor item's category must fit its zone's label: "BAG LINE" -> bags; "CARDIO ZONE" -> cardio; "STRENGTH
  TRAINING" -> strength; "TURF FUNCTIONAL" -> strength or cardio; "STRETCH"/"RECOVERY" -> recovery; any other label -> no check.
- R6 SANE COUNTS: speed bags (floor items + speed_bag places) <= 3; first_aid <= 1; the same item id at the same (x,z) within
  0.3 m twice = duplicate.
`static func summary(violations: Array) -> Dictionary` - {rule id: count}.

## Test (club_layout_rules_test.gd) - prints PASS/FAIL lines, ends `quit(0)` only if all pass, `quit(1)` otherwise
1. TODAY'S FLOOR IS CAUGHT (the checker can read worse): loading `gym_club.json` -> R1 >= 5 (bag_line 2 + bag_east 3 + the bag in
   strength_east), R2 >= 1 (speed bags behind heavy bags 1-4 in bag_row), R5 >= 1 (heavy_bag in "STRENGTH TRAINING"), R6 reports
   first_aid 6 and speed bags 9. Print the summary.
2. A small hand-built CLEAN club dict (two bags on the back wall 2 m apart, a rack in a STRENGTH zone, one first_aid) -> [].
3. One fixture per rule that breaks ONLY that rule -> exactly that rule fires (6 fixtures).
4. Pure: the module has no `preload`/`load(`/`GameState` (read its own source text and assert).
Run it red first (before the module exists = parse error/fail), then green; paste both outputs in your final message.

## Prior research
G121_REAL_GYM_FLOOR_PLANS.md (real gyms, sourced), GYM_ZONE_AUDIT_S200.md (zone-by-zone verdicts), G121 rules quoted in
`research/topics/gym_rooms_art.md`. Prefab check: no Godot/GDScript floor-plan rule library exists for this; it is 6 geometric
rules on our own JSON.

## What would a human do?
A boxing coach walks the floor: bags hang on the walls with room to move, nothing hides behind a bag, the walk from the door is
clear, weights live with weights, and there is one first-aid kit on the wall, not six.

## The one trap
Do NOT make today's floor pass: test 1 must FIND the junk. A checker that passes today's floor is wrong.
