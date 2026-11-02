# TASK ROOMSLOTS1 - each gym room's REQUIRED item slots + defaults (pure module, Arena) - S245

Model: Arena (cloud, free). Discipline: BOXING (demo). Owner: Arena; Claude reviews + collects (FAST LANE: pure module + its test).
Frame: research/TWOPOINT_ALIGNMENT.md section 3 (the Two Point room model: a room is valid only when every REQUIRED slot holds
an item people can reach; each slot has a DEFAULT item placed when the room is built) and section 5 checklist.

## Spec
New file `Godot/scripts/rules/RoomSlots.gd` (`extends RefCounted`, static functions only, ZERO preloads, no autoloads, no file IO).
- `const SLOTS := {...}` - room id -> Array of slot rows `{"slot": String, "accepts": Array[String], "default": String}`, default
  always inside accepts, door slot first. Exactly these rooms and required slots (item ids are the ones in assets/data/gym_club.json
  rooms.<id>.props; "door" and "ring" are built by the room itself):
  | room id | required slots (slot: accepts, default first) |
  |---|---|
  | training_hall | door: [door]; ring: [ring] |
  | office | door: [door]; desk: [desk, coach_desk]; pc: [pc]; filing: [filing_cabinet] |
  | reception | door: [door]; counter: [counter]; phone: [phone] |
  | physio | door: [door]; table: [physio_table]; cold_tub: [cold_water_tub] |
  | equipment_store | door: [door]; shelving: [shelving] |
  | locker_room | door: [door]; lockers: [lockers]; bench: [bench] |
- `static func room_ids() -> Array` - sorted room ids.
- `static func required_slots(room_id: String) -> Array` - deep copy of the rows; unknown room -> [].
- `static func defaults(room_id: String) -> Array` - the default item id of each slot, in slot order.
- `static func check(room_id: String, placed: Array) -> Dictionary` - `placed` = Array of `{"id": String, "reachable": bool}`
  (missing "reachable" counts as true). Returns `{"valid": bool, "missing": Array[String] slot names with no accepted item,
  "unreachable": Array[String] slot names whose accepted items are all unreachable, "filled": {slot: item id}}`. One item fills
  at most one slot (a "desk" placed once cannot fill two slots); slots fill in table order. Unknown room ->
  `{"valid": false, "missing": [], "unreachable": [], "filled": {}, "error": "unknown room"}`.
  valid == missing.is_empty() and unreachable.is_empty().
- Optional items (decor) never affect validity; extra unknown ids are ignored.

## Test (write it FIRST, red before the module exists)
`Godot/tests/room_slots_test.gd` (`extends SceneTree`, prints `OK`/`FAIL` lines, ends `ROOM_SLOTS failures=<n>`, quit(0|1)).
At least: every room's defaults() placed as reachable -> valid; each room with one required slot's item removed -> invalid with that
exact slot in missing (every room, every slot); the same item unreachable -> in unreachable, not missing; coach_desk fills office desk;
one "bench" cannot fill two slots; decor-only list -> invalid; unknown room -> error; required_slots returns a copy (mutating it does
not change SLOTS); every default is inside its accepts; door is slot 0 of every room. A mutant check: the test must fail if check()
ignores "reachable" (say so in the PR body).
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/room_slots_test.gd` (parse gate first:
`python Godot/tools/check_scripts.py Godot/scripts/rules/RoomSlots.gd Godot/tests/room_slots_test.gd`).
PR body: `RESULT: tests/room_slots_test.gd -> ROOM_SLOTS failures=0`.

## Owned files
Only the two new files. Touch nothing else (no GymClub3D, no gym_club.json). Wiring into build mode is a later Claude task.

## The one trap
GDScript `:=` on a Variant from a Dictionary fails the parse gate - type it (`var row: Dictionary = ...`). See
research/GDSCRIPT_TRAPS.md. CI has no LFS: the test must not load any model/texture.

## Prior research
TWOPOINT_ALIGNMENT.md s3/s5, TWOPOINT_MUSEUM_STUDY_S243.md (room model measured from the install), PLACEMENT_VERDICT_S243.md,
scripts/rules/PlacementRules.gd (slice A - the same pure style).

## What would a human do?
Write the room checklist a sim designer keeps: each room lists what it cannot work without, and the build tool places those for you.

## Prefab check
Pure data rule - no asset or addon applies.
