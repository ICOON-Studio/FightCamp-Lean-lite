# TASK ROOMDRAW1 - draw a room: the pure rules (snap, size, overlap, door, walls, cost)

Model: Qwen (cloud, label `qwen`). Discipline: BOXING (demo) - the gym building (GYMBUILD step B).

## Why (operator S276/S277, verbatim)
"the starting gym should be an emptu building , no room no nothing, player draws the limmits of each room";
"i can draw the rooms like in mad games"; S277: "focus on the new start, blank gym player designs everything with limited budget".
Plan: research/GYMBUILD_PLAN_S276.md. Claude wires the 3D side (GymClub3D builds walls from each room's `rect` + `door`
data already - `_build_building`, GymClub3D.gd ~line 380); this task is ONLY the pure decision module the drag tool calls.

## Build: `Godot/scripts/rules/RoomDrawRules.gd` (NEW, pure: `extends RefCounted`, static funcs, no scene, no autoload, may
## preload `res://scripts/rules/PlacementRules.gd` for GRID_M / snap / refund)
Coordinates: the floor plane (x, z) as Vector2, metres; the building is a Rect2 (today 30 x 22.5 at the origin).
1. `snap_rect(a: Vector2, b: Vector2) -> Rect2` - the two drag corners in any order -> a rect whose corners sit on the 0.5 m grid
   (PlacementRules.GRID_M), always positive size.
2. `check(rect: Rect2, room_type: Dictionary, building: Rect2, rooms: Array, blocked: Array, keep_clear: Array, cash: int,
   prices: Dictionary) -> Dictionary` returns `{ok: bool, code: String, reason: String, cost: int, door: Vector2, door_edge: String}`.
   `room_type` = {"id", "min_w", "min_d"} (min size either orientation: a 3 x 2.5 minimum accepts 2.5 x 3);
   `rooms` = Array of Rect2 (rooms already built); `blocked` = Array of Rect2 (placed stations/zones, the ring);
   `keep_clear` = Array of Vector2 (the street door and every existing door - a 1.2 m square in front of each must stay floor).
   Codes, checked in THIS order, first failure wins: `too_small`, `outside` (not fully inside `building`), `overlaps_room`
   (positive-area intersection; sharing an edge is allowed), `overlaps_item`, `blocks_door`, `no_door` (no valid door edge),
   `cash` (cost > cash). `reason` = one short player-facing line (<= 40 chars, no jargon), e.g. "Too small - a physio room needs 3 x 3 m".
3. `door_for(rect: Rect2, building: Rect2, rooms: Array, blocked: Array, toward: Vector2) -> Dictionary` `{ok, pos: Vector2, edge: String}`:
   the door goes on an edge that is NOT on the building's outer wall and NOT shared with another room, 1.0 m wide, its centre >= 0.5 m
   from each corner (+ half the width), with a 1.2 m deep, 1.0 m wide patch of free floor outside it (not in `rooms`/`blocked`/outside);
   among valid spots pick the one closest to `toward` (the hall's centre); edge names "north" (min z), "south" (max z), "west", "east".
   Ties: lowest x, then lowest z (deterministic).
4. `interior_walls(rect: Rect2, building: Rect2) -> Array` - the edges that need a NEW wall: every edge of `rect` minus the parts lying
   on the building's outer wall, as `[Vector2 a, Vector2 b]` segments; total length helper `wall_length(rect, building) -> float`.
5. `cost(rect: Rect2, building: Rect2, prices: Dictionary) -> int` = round(area * prices.per_m2 + wall_length * prices.per_wall_m +
   prices.door). Prices are INPUT - never hard-code money (the economy numbers come from a later design round).
6. `refund(cost: int, built_this_session: bool) -> int` - delegate to PlacementRules.refund (same rule as items).

## The proof: `Godot/tests/room_draw_rules_test.gd` (NEW, `extends SceneTree`, pure, no LFS; prints `ROOM_DRAW failures=<n>`)
Write it FIRST and show it red (module missing). At least: snap of reversed corners; every failure code once, each with a control
case one step on the passing side (e.g. 3.0 x 3.0 passes, 3.0 x 2.5 fails for physio 3 x 3; edge-sharing passes, 0.5 m overlap fails);
door never on the outer wall; door never on an edge shared with a room; door picks the edge nearest `toward`; a room in a corner of the
building has exactly 2 interior walls and the right length; cost formula on two different price sets (one with door 0);
determinism (same inputs twice -> same dictionary).
Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/rules/RoomDrawRules.gd Godot/tests/room_draw_rules_test.gd`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/room_draw_rules_test.gd` (NEVER _console.exe).
PR body: `RESULT: tests/room_draw_rules_test.gd -> ROOM_DRAW failures=0`.

## Owned files
Godot/scripts/rules/RoomDrawRules.gd (new), Godot/tests/room_draw_rules_test.gd (new). Touch NOTHING else.

## Prior research
GYMBUILD_PLAN_S276.md (target 2: draw a room, min sizes); PLACEMENT_VERDICT_S243.md (physio 3 x 3, office 3 x 2.5, locker 4 x 3);
PlacementRules.gd (S243, grid 0.5 m, refund rule); TWOPOINT_MUSEUM_STUDY_S243.md (room drawing on a grid); S277_GYM_EMPIRE_BENCHMARK.md.

## What would a human do?
Mad Games Tycoon 2 / Two Point: drag a rectangle on the grid, it goes red with one short reason when it cannot be built, green with its
price when it can; the door appears on the side facing the open floor.

## Prefab check
None needed - ~200 lines of pure geometry on our own grid rules; no Godot asset covers room-drawing validation.

## The one trap
Never weaken a check to make a case pass and never hard-code a price; every failure code needs a control case that passes.

## Contract
OWNS: Godot/scripts/rules/RoomDrawRules.gd, Godot/tests/room_draw_rules_test.gd
RED_TEST: Godot/tests/room_draw_rules_test.gd -> ROOM_DRAW failures=0
REGRESSION: placement_rules_test
VISUAL: no
