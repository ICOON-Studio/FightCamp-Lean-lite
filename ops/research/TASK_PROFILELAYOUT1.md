# TASK PROFILELAYOUT1 - the fighter overview's geometry as a pure module (for PROFILE2B)

Model: Qwen (qwen3-coder, --yolo). Tier: a new pure module + its own test only (parse gate + that one test).

## Why
PROFILE2B (TASK_PROFILE2B.md) builds Ludo's approved 1920x1080 fighter overview. Every panel position, every tick segment and
the radar points are plain maths from Ludo's spec - one pure module keeps them exact and testable.

## Prior research
`research/LUDO_ROUND37_S202_reply2a.txt` lines 10-22 (grid), 72-109 (top bar, banner, columns), 133-214 (left + centre
panels, attribute card pitch, tick bar, radar), 215-261 (right column). Use ITS numbers.

## What would a human do?
Put every rectangle of a fixed-resolution screen in one table, so the screen code only reads it.

## Prefab check
None - Rect2/Vector2 maths.

## Owned files (create both; edit nothing else)
- `Godot/scripts/rules/ProfileLayout.gd` - `extends RefCounted`, `class_name ProfileLayout`, static funcs, PURE (no `preload`,
  `load(`, autoload, GameState, RNG, Node, file access).
- `Godot/tests/profile_layout_test.gd` - `extends SceneTree`; `PASS <name>` / `FAIL <name>: <detail>` per check, final
  `PROFILELAYOUT total=<n> fails=<m>`; `quit(0)` only when fails == 0.

## API (exact names)
1. `panels() -> Dictionary` of Rect2 at 1920x1080, keys: "top_bar" (24,16,1872,36), "banner" (24,58,1872,86), "portrait"
   (24,154,460,440), "body" (24,606,460,418), "attributes" (504,154,844,480), "radar_panel" (504,648,844,376), "bout"
   (1368,154,528,270), "camp" (1368,438,528,220), "form" (1368,866,528,158). (No contract panel - the verdict drops it.)
2. `attribute_card(index: int) -> Rect2` - index 0..8 row-major; card 268x148; x = 504 + (index % 3) * 288; y = 154 +
   (index / 3) * 156. Index outside 0..8 -> Rect2().
3. `tick_segments(card: Rect2) -> Array` - 20 Rect2, bar origin card.position + (14, 68), each 10 x 18, step 12 px.
4. `radar_points(values: Array, center: Vector2 = Vector2(720, 835), radius: float = 135.0) -> PackedVector2Array` - one point per
   value (9 for our 9 attributes, CHIN included), axis i at angle -PI/2 + i * TAU / n (first axis straight up, clockwise on
   screen), distance = radius * clamp(v, 0, 100) / 100. Empty input -> empty array.
5. `radar_ring(level: float, n: int = 9, center = Vector2(720, 835), radius = 135.0) -> PackedVector2Array` - the n-gon for a
   ring at `level` (25 / 50 / 75 / 100).

## Test checks (each its own line)
- every panel inside 0..1920 x 0..1080; no two panels of the same column overlap (portrait/body; bout/camp/form; attributes/radar_panel).
- attribute_card(0) == Rect2(504,154,268,148); (4) == Rect2(792,310,268,148); (8) == Rect2(1080,466,268,148); (9) == Rect2().
- the 9 cards fit inside panels()["attributes"].
- tick_segments: 20 rects; first at card + (14,68); last ends at card.x + 14 + 238; no overlap, 2 px gaps.
- radar_points([100] * 9): first point == (720, 700); every point 135 px from the centre (+-0.01); ([0] * 9) -> all at the centre;
  9 values -> 9 points; value 150 clamps to 135 px.
- radar_ring(50) has 9 points each 67.5 px from the centre.
- purity (source): read `res://scripts/rules/ProfileLayout.gd` as text; FAIL on `preload`, `load(`, `GameState`, `randf`, `randi`,
  `RandomNumberGenerator`.
- CAN READ WORSE: a deliberately broken card pitch inside the test (290 px) must fail the "card 8" check - assert it does.

## Gates and the one test
- Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/ProfileLayout.gd Godot/tests/profile_layout_test.gd`
- Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/profile_layout_test.gd`
  (never `_console.exe`). Pass = `PROFILELAYOUT total=<n> fails=0`, exit 0, no `SCRIPT ERROR`.

## The one trap
Integer division `index / 3` on ints is fine in GDScript but warns - write `int(index / 3)` or `index / 3` with both ints typed.
`var x := <call>` fails on a Variant return - type it. Never weaken a check to go green.
