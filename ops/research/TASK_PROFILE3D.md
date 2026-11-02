# TASK PROFILE3D - "compare with opponent" rows for the fighter profile (pure module + test)

Model: Antigravity (agy, file tools only - it cannot run commands; Claude runs the parse gate and the test at collection).
Approved: operator board Q-S204-3 "yes build PROFILE3" (Ludo r39 s1 decision 3: COMPARE WITH OPPONENT, key C).

## Spec - NEW `Godot/scripts/rules/OpponentCompare.gd` (`extends RefCounted`, `class_name OpponentCompare`, static funcs, PURE:
no load/preload except the one below, no GameState/Node/files/randomness; never mutate arguments).
`const ScoutFidelity = preload("res://scripts/rules/ScoutFidelity.gd")` (on master: `attribute_view(value, level, offset)`
returns how much of a number the scouting level reveals; `offset_for(fighter_id)` the stable per-fighter range offset).
`const ROWS := [["power","POWER"],["technique","TECHNIQUE"],["speed","SPEED"],["stamina","STAMINA"],["chin","CHIN"],
["defense","DEFENCE"],["footwork","FOOTWORK"],["ring_iq","RING IQ"],["composure","COMPOSURE"]]` (the profile's 9 bars).
1. `static func rows(mine: Dictionary, theirs: Dictionary, opponent_id: String, scout_level: int) -> Array` - one row per ROWS
   entry: {"key", "label", "mine": int, "theirs_view": ScoutFidelity.attribute_view(theirs[key], scout_level,
   ScoutFidelity.offset_for(opponent_id)), "edge": "mine" | "theirs" | "even" | "unknown"}. edge is "unknown" unless
   scout_level >= 2; at level 2 compare against the MIDDLE of the revealed range, at level 3 against the exact value:
   difference >= 5 -> the bigger side, else "even". A key missing on either side -> mine 0 / edge "unknown".
2. `static func reach_line(my_reach_cm: float, their_reach_cm: float, scout_level: int) -> String` - level 0 ->
   "REACH: SCOUT HIM TO KNOW"; else |d| < 3 -> "REACH: EVEN"; d > 0 -> "YOU OUT-REACH HIM BY %d CM"; d < 0 ->
   "HE OUT-REACHES YOU BY %d CM" (d = my - their, rounded to int, shown as a positive number).
3. `static func summary(rows_out: Array) -> String` - "EDGES: YOU 3 - HIM 2 - EVEN 4" counting known edges, or
   "SCOUT HIM TO COMPARE" when every edge is unknown.

## Test - NEW `Godot/tests/opponent_compare_test.gd` (SceneTree `_initialize()`, prints `OPPONENT_COMPARE total=N fails=M`,
quit(1) on fail, `const OpponentCompare = preload("res://scripts/rules/OpponentCompare.gd")`). Two DIFFERENT fighters as
literals; checks: 9 rows in order; levels 0 and 1 all "unknown"; level 2 and 3 edges; the 5-point threshold both ways; a missing
key; reach_line all four branches incl. rounding; summary both branches; inputs not mutated; an inline MUTANT (threshold 5 -> 0)
must fail one of the checks.

## Owned files
The two new files only. Read Godot/scripts/rules/ScoutFidelity.gd (265 lines) first - do not edit it.
GDScript 4 syntax: `const` (never `static const`), `for x in arr` (never `for var x`), `dict.has()`, `is_empty()`, and a
SceneTree test uses `_initialize()`. Write the files into your workspace and stop; print the two file paths and a summary.

## Prior research
LUDO_ROUND39_VERDICT_S205.md (decision 3), ScoutFidelity.gd (merged S205).

## What would a human do?
Football Manager's compare view: side-by-side attributes, unknowns shown as unknown, never guessed.

## Prefab check
None.

## The one trap
Never reveal a number the scouting level hides - always go through ScoutFidelity.attribute_view.
