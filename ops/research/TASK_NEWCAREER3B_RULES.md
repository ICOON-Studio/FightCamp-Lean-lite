# TASK NEWCAREER3B-RULES (S221) - the gym zone editor's rules: move, swap, blocked, resize, rotate, undo, reset (pure module + blind test)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.
No LFS-loading code or tests (no models, no scenes). Do not delete or shorten any existing test. Touch no other file.
Approved: operator board Q-S220-1 "Approve, and add resize/rotate" on `research/LUDO_ROUND57_VERDICT_S220.md` (read it whole).

## Why
New Career step 3 shows the player's real gym; the player moves the training zones before OPEN GYM. The screen (Cursor, NEWCAREER3A/3B)
needs ONE rules module that says what a drag/drop/resize/rotate does to the layout, so the UI only renders and every rule is tested.

## Data (read `Godot/assets/data/gym_club.json`, do not change it)
- `floor_zones`: Array of {id, label, rect:[x0, z0, x1, z1] in metres, material, sign:[x, z], items:[{id, x, z, yaw}]}. 9 zones.
  Items and the sign are in WORLD metres (not relative to the zone).
- `room`: {w 30.0, d 22.5, hall_d 18.0, front_aisle [16.4, 18.0], middle_aisle [10.4, 11.6], bag_strip [2.7, 3.5], ...}.
- The ring is NOT a floor zone; the caller passes its rect as a fixed rect.

## Do - new file `Godot/scripts/ZoneEditRules.gd`
`extends RefCounted`; all `static`; NO preloads, autoloads, nodes, file reads, RNG. Works on plain Dictionaries/Arrays and returns NEW
ones (never mutates its inputs - deep-copy). A "layout" is `{"zones": Array (floor_zones shape), "history": Array}`.
```gdscript
const SNAP_M := 1.0                 # moves and resizes go in whole metres (deltas; canonical rects are NOT on a 1 m grid - keep them)
const CLEARANCE_M := 0.5            # per side, around the zone's items, for the minimum footprint
const MIN_SIDE_M := 2.0             # no zone side smaller than 2 m even when empty
## Fixed rects the zones may not overlap: built by the caller from room + ring. Each {kind, rect:[x0,z0,x1,z1]}; kind is one of
## "aisle" | "wall" | "ring" | "door". Helper that builds them from the room dict: the two aisles across the full width
## (z ranges from front_aisle and middle_aisle, x 0..w), and the hall bounds: a rect is "wall"-blocked when it leaves
## x -0.5 .. w + 0.5 or z -0.5 .. hall_d (the canonical bag zones hang over the wall line: bag_line_east z0 -0.35,
## bag_wall_east x1 30.4 - the 0.5 m tolerance keeps them legal). ring_rect is passed in.
static func fixed_rects(room: Dictionary, ring_rect: Array) -> Array
static func new_layout(zones: Array) -> Dictionary                         # history []
## Snap a delta to whole metres (round half away from zero): 0.49 -> 0, 0.5 -> 1, -1.5 -> -2.
static func snap(delta_m: float) -> float
## The first blocker for a candidate rect of zone `zone_id`, or "" when free. Order: "WALL" (outside the hall), "AISLE", "RING",
## "OVERLAP" (another zone, edges touching is NOT overlap). Returns the UI text "BLOCKED: AISLE" etc.
static func blocker(layout: Dictionary, zone_id: String, rect: Array, fixed: Array) -> String
## Move zone by (dx, dz) snapped. Items and the sign move with it. Returns {ok, layout, blocked} - when blocked, ok false, layout
## unchanged (the UI springs back) and blocked = the blocker text. A successful move pushes an undo entry.
static func move(layout: Dictionary, zone_id: String, dx: float, dz: float, fixed: Array) -> Dictionary
## Drop zone A onto zone B = SWAP: A takes B's rect position and B takes A's (each keeps its OWN size, anchored at the other's
## top-left x0,z0); items/sign travel with their zone. Blocked if either result is blocked (check A's new rect ignoring B and B's
## new rect ignoring A, then the pair against each other). Pushes ONE undo entry.
static func swap(layout: Dictionary, zone_a: String, zone_b: String, fixed: Array) -> Dictionary
## Minimum footprint [w, d]: the items' bounding box (item points) + CLEARANCE_M per side, each side at least MIN_SIDE_M, rounded
## UP to 0.1 m. An empty zone = [2, 2].
static func min_footprint(zone: Dictionary) -> Array
## Resize by moving one edge: edge in "x0" | "x1" | "z0" | "z1", delta snapped. Refused with "BLOCKED: TOO SMALL" if a side drops
## below min_footprint, or with the blocker text. Items stay where they are in the world (they must still be inside the rect, which
## min_footprint plus the edge check guarantees - if an item would fall outside, refuse with "BLOCKED: TOO SMALL").
static func resize(layout: Dictionary, zone_id: String, edge: String, delta: float, fixed: Array) -> Dictionary
## Rotate 90 degrees clockwise (seen from above, +x right, +z down) about the zone centre: w and d swap, the centre stays, items and
## the sign rotate about the centre, each item's yaw += 90 (mod 360). Blocked -> springs back (ok false, layout unchanged).
static func rotate90(layout: Dictionary, zone_id: String, fixed: Array) -> Dictionary
## Undo the last successful edit (move/swap/resize/rotate); undo on an empty history returns ok false. Max 50 entries (oldest dropped).
static func undo(layout: Dictionary) -> Dictionary
## Canonical layout again (history cleared): reset(canonical_zones).
static func reset(canonical_zones: Array) -> Dictionary
## Floor area in use: sum of zone areas, m2 rounded to 0.1.
static func floor_used_m2(layout: Dictionary) -> float
```

## Test - new `Godot/tests/zone_edit_rules_test.gd`
`extends SceneTree`; prints `ZONE_EDIT_RULES_TEST PASS (<n> checks)` or `FAIL ...` lines; `quit(0)`/`quit(1)`. Load the module with
`load("res://scripts/ZoneEditRules.gd")`. Read `res://assets/data/gym_club.json` with FileAccess + JSON (plain JSON, not LFS).
Ring rect for the test: [11.6, 3.5, 22.1, 10.4]. Blind, from THIS contract. Checks:
1. snap: 0.49 -> 0, 0.5 -> 1, -1.5 -> -2, 2.0 -> 2.
2. The canonical layout has no blocker for any zone (all 9 free in place).
3. move timing by (0, +1): blocked "BLOCKED: AISLE" (front aisle) and the layout is unchanged (deep-equal), history still empty.
4. move boxing_floor by (+1, 0): "BLOCKED: RING"; by (-1, 0): "BLOCKED: WALL".
5. move footwork by (+0.2, 0) -> snapped to 0 -> ok true, rect unchanged, and NO history entry pushed.
6. Swap stretch <-> footwork: each takes the other's x0/z0, keeps its own size; result blocked or not must be what blocker() says
   for those rects (compute expected from the contract, not from the module); then undo -> deep-equal to canonical.
7. Swap that would overlap -> ok false, layout unchanged.
8. Items travel: move bag_wall_east is blocked (wall) or not - pick a move that is free in the canonical layout (search dx,dz in
   -2..2 in the test for the first free one using blocker()); after it every item x/z and the sign moved by exactly (dx,dz).
9. min_footprint: strength (one dumbbell_rack) >= [2,2]; an empty zone == [2,2]; bag_line_east (two bags 3 m apart) w >= 4.0.
10. resize: shrinking cardio's x1 until below its min -> "BLOCKED: TOO SMALL"; growing timing's z1 by +1 -> "BLOCKED: AISLE".
11. rotate90 of a square-ish free zone keeps the centre (within 1e-6), swaps w/d, item yaw 0 -> 90, 270 -> 0; four rotations (if each
    is free) return to the original rect (within 1e-6); a rotation that collides -> ok false, unchanged.
12. undo after 3 edits x3 -> canonical; undo on empty -> ok false; history capped at 50 (do 55 free +1/-1 moves, history size 50).
13. reset after edits -> canonical, history empty. floor_used_m2(canonical) equals the sum computed in the test from the JSON.
14. Inputs are never mutated: keep a deep copy of the input layout before each call and compare after.
15. Mutants inside the test, each proving an assertion goes red: (a) touching edges counted as overlap; (b) swap keeps the zone's own
    position (no-op); (c) rotate about the rect origin instead of the centre.

## Gate (CI runs it)
Parse gate on the 2 new files, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/zone_edit_rules_test.gd`
prints the PASS line.

## VISUAL GATE
Not a visual task: a pure rules module. The screen that uses it (NEWCAREER3B UI) closes on game-camera stills + the operator.

## Prior research
LUDO_ROUND57_VERDICT_S220.md (items 3-5 + the operator ruling), LUDO_ROUND57_REPLY_S220.txt (Ludo's editor spec), GymClubLayout.gd
(how floor_zones are read; zone_rect), gym_club.json.

## What would a human do?
A tools programmer writes the editor's rules as pure functions over the layout data with an undo stack, tests every rule, and only
then hooks the mouse up to it.

## Prefab check
Godot has no grid-layout editor prefab for arbitrary rect zones on a fixed hall; ~300 lines of our own rules.

## The one trap
Canonical rects are not on the 1 m grid (11.6, 3.5, 27.3...). Snap the DELTA, never the rect, or the untouched layout moves on the
first click. And never mutate the input arrays (Godot passes Dictionaries/Arrays by reference) - deep-copy first.
