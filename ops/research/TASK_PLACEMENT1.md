# TASK PLACEMENT1 - build mode like Two Point: move, turn and buy stations on the iso floor (S244)

Discipline: BOXING (demo). Operator approval Q-S242-1 (S244 board, verbatim): "Approve and also I want to see the kudos doc 24
perspective" (the FOV 24 camera is a separate still, Claude's job). Verdict: research/PLACEMENT_VERDICT_S243.md (Ludo r109/r110
+ measured Two Point Museum values, TWOPOINT_MUSEUM_STUDY_S243.md). Switch: `build_mode` in `GameSwitches.GAME_ON` (ships ON,
operator S221); plain `--script` tests are the OFF control arm.

Three slices. A and B run in parallel now (one contract each, no shared file). C (the build-mode UI in GymClub3D, the ghost, the
hammer button, Ludo's look) is briefed when A and B are on master.

What the game does today (route traced S244): the iso gym is `GymClub3D.gd` reading `GymClubLayout.gd` over
`assets/data/gym_club.json` `places` (each row: `zone` [x0, z0, x1, z1], `work`, `approach`, `node`, `bag`/`board`/`rope`/`steps`
points, `dressing` [{glb, at: [dx, dz] from the zone centre, ...}]); the walk graph is `nodes` + `edges` (`GymClubLayout._graph_path`).
The positions are fixed in the JSON. A whole-floor variant already exists (`career["club_layout"]` -> a file in LAYOUTS_DIR replaces
top-level keys, `GymClubLayout._load_club`). The ring does not move in the demo (its fight scene, camera poses and steps hang on it).

## Slice A - Arena: `Godot/scripts/rules/PlacementRules.gd` + `Godot/tests/placement_rules_test.gd`
`extends RefCounted`, ZERO preloads, static functions only. Floor coordinates are metres on (x, z) as `Vector2(x, z)`; a `Rect2`
is (x, z, w, d). An ITEM is `{"size": [w, d], "clear": [front, back, left, right]}` in metres at yaw 0; at yaw 0 its FRONT faces +z.
At yaw 0 the four sides are: front = +z, back = -z, left = -x, right = +x. Yaw is degrees about +Y and turns all four sides
together: yaw 90 maps +z -> +x and +x -> -z (front = +x, back = -x, left = +z, right = -z); 180 and 270 follow the same way.

```
const GRID_M := 0.5
const STATION_YAW_STEP := 90
const DECOR_YAW_STEP := 45
const WALKER_CELLS := 2          # a 1.0 m walker = a 2 x 2 block of 0.5 m cells
const REFUND_USED := 0.65

static func snap(p: Vector2) -> Vector2                    # each axis to the nearest multiple of GRID_M (0.25 -> 0.5, -0.25 -> -0.5: round half away from zero)
static func snap_yaw(yaw: int, step: int) -> int           # nearest multiple of step, normalised to 0..359 (-90 -> 270, 405 -> 45 at step 45, 44 -> 0 at step 90)
static func body_rect(item: Dictionary, at: Vector2, yaw: int) -> Rect2      # centred on at; w/d swap at 90 and 270
static func clear_rect(item: Dictionary, at: Vector2, yaw: int) -> Rect2     # body grown by the four clearances, rotated with the item
static func check(item: Dictionary, at: Vector2, yaw: int, placed: Array, hall: Dictionary) -> Dictionary
static func aisle_ok(placed: Array, hall: Dictionary) -> Dictionary
static func refund(price: int, placed_this_session: bool, used: bool) -> int
```

`placed` = Array of `{"uid": String, "label": String, "item": ITEM, "at": Vector2, "yaw": int}` (the caller leaves out the item
being moved). `hall` = `{"size": [w, d], "door": Vector2 (centre of the doorway on the floor), "ring": Rect2 (platform),
"ring_apron_m": float, "blocked": [{"label": String, "rect": Rect2}], "cash": int, "price": int}`.

`check` returns `{"ok": bool, "code": String, "reason": String}`, the FIRST failing rule in this order (ok = `{"ok": true, "code":
"", "reason": ""}`). Touching edges are legal everywhere (Rect2.intersects with include_borders false).
1. body not fully inside Rect2(0, 0, w, d) -> `"outside"`, `"Outside the gym"`
2. body intersects a `blocked` rect -> `"blocked"`, `"Blocks the %s" % label`
3. body or clear rect intersects `ring.grow(ring_apron_m)` -> `"ring"`, `"Too close to the ring"`
4. body intersects another placed body -> `"overlap"`, `"Overlaps the %s" % label` (first in `placed` order)
5. its clear rect intersects another body, or another's clear rect intersects its body -> `"clearance"`, `"Too close to the %s" % label`
   (two clear rects may overlap each other: a shared aisle)
6. `aisle_ok(placed + [this one with uid "candidate"], hall).ok` is false -> `"aisle"`, `"No aisle path"`
7. `price > cash` -> `"cash"`, `"Can't afford"`

`aisle_ok` returns `{"ok": bool, "unreached": [uid ...]}` (sorted). Grid of GRID_M cells over the hall; a cell is SOLID when its cell
rect intersects any placed body, the ring platform or a blocked rect. The walker is a WALKER_CELLS x WALKER_CELLS block of non-solid
cells; it starts at the free block whose centre is nearest `door` (none free -> every uid unreached) and moves one cell at a time in 4
directions (BFS). A placed item is reached when a reachable walker block's rect intersects its clear rect WITH borders
(`intersects(r, true)`). ok = nothing unreached.

`refund`: `placed_this_session and not used` -> `price`; else `int(round(price * REFUND_USED))`.

Test `tests/placement_rules_test.gd` prints `PLACEMENT_RULES failures=0` and covers at least: snap (0.24, 0.26, -0.25), snap_yaw
(-90, 405 at 45, 44 at 90), body/clear rects at yaw 0 and 90 for an item with four DIFFERENT clearances (proves the rotation),
each of the 7 check codes on its own (and that the order holds when two rules fail at once: outside beats overlap), touching edges
legal, two clear rects overlapping legal, an aisle closed by a wall of bags across a 6 x 4 m hall -> unreached lists the far item,
the same wall with one 1.0 m gap -> ok, a 0.5 m gap -> not ok (the walker is 1 m), refund 100% / 65% / 65%.
Parse gate `python Godot/tools/check_scripts.py <both files>`; run
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/placement_rules_test.gd`.
PR body: `RESULT: tests/placement_rules_test.gd -> PLACEMENT_RULES failures=0`. Never touch any other file. No LFS-loading code.

## Slice B - Cursor: the saved layout in `Godot/scripts/GymClubLayout.gd` (494 lines) + `Godot/tests/club_place_moves_test.gd`
A career keeps the player's moves in `career["club_place_moves"]` = `{place_id: {"at": [x, z], "yaw": int}}` (at = the new centre of
the place's zone; yaw = the turn from the JSON pose, 0/90/180/270). Add, beside the `club_layout` variant (same `_load_club`):
- `static func set_place_moves(moves: Dictionary) -> void` (test seam; overrides the career's, `reload()` after),
  `static func clear_place_moves() -> void`, `static func place_moves() -> Dictionary` (the seam's if set, else the career's, else {}).
- `_load_club` applies each move AFTER the variant: for place p with old zone centre c, new centre `at`, turn yaw:
  every point key of the row that is a 2-number array (`work`, `approach`, `board`, `bag`, `rope`, `steps`, `apron` and any other
  [x, z] pair) -> rotate (x - c) by yaw about the centre (same rotation as PlacementRules: +90 maps +z to +x), then add `at`;
  `zone` -> the rotated rect (w/d swap at 90/270) centred on `at`; each `dressing[i].at` offset rotated by yaw, and
  `dressing[i]["yaw"] = yaw + its own yaw`; the row gets `"moved": true, "yaw": yaw`.
- Walk graph: a moved place gets its OWN node `"<place_id>__mv"` at its new `approach`, and its `node` points at it. Link it with
  one edge to the nearest existing node (Euclid) whose segment to the new node hits no `solid` zone of another place
  (`segment_hits_rect`); none -> no edge (the route then reports "no aisle path"). The old node stays (other places share nodes:
  `glove_rack` uses `sb_1`).
- The ring (`station == "ring_sparring"`) and unknown place ids are ignored (no error); an empty moves dict = byte-identical table.
- Test `tests/club_place_moves_test.gd`, pass line `CLUB_PLACE_MOVES failures=0`: no moves -> `hall()` equals the plain table;
  heavy_bag_4 moved to (25.0, 3.0) yaw 90 -> zone 2.0 x 1.8 centred there, work/bag/approach rotated + shifted (assert the numbers),
  dressing yaw 90, `route("heavy_bag_1", "heavy_bag_4").ok` true and its last point = the new work point; a move into a sealed
  corner -> route ok false with "no aisle path"; a ring move ignored; `reload()` + `clear_place_moves()` restore the plain table.
  Red on master first (paste it).
- Gates: parse gate; `python Godot/tools/run_tests.py --only gym_club,club_layout,iso --jobs 2` unchanged vs master (paste both SUITE
  lines).
THE ONE TRAP: `place()` is called every frame by the floor and walk code - apply the moves once in `_load_club` (cached), never
inside `place()`.

## Prior research
research/TWOPOINT_ALIGNMENT.md (operator S244: every agent aligned with Two Point Museum perspective + per-room items).
`python Tools/prior_research.py placement build mode grid` -> J16 THE GYM FLOOR PLAN (station_capacity/footprint are invented
gameplay numbers, not building code), PLACEMENT_VERDICT_S243.md, TWOPOINT_MUSEUM_STUDY_S243.md (0.5 m grid on 87% of 1,600 items),
Ludo r110 C2 table (footprints, clearances, refund 100/65).

## What would a human do?
Two Point Hospital/Museum: pick up an item, a ghost follows the cursor snapped to a half-metre grid, it turns red with the reason
on the cursor when it does not fit, a full refund until you leave build mode. The rules (A) and the saved floor (B) are what that
ghost asks every frame.

## Prefab check
No Godot asset covers grid placement + aisle reachability for an existing walk graph; Godot's AStarGrid2D could do the BFS but
the walker-block rule is 30 lines - pure GDScript, no dependency.
