# TASK CORNERLENS1 - the corner minute's lens never sits inside a body (S386, Goose)

Model: Goose on GOOSE_QWEN_MODEL. Discipline: boxing (the demo).

## Why
Film S384 DEFFLOW2 r2, 3:17 (the "ice" shot of the corner minute): the camera ends INSIDE the boxer - about 0.24 m from her
neck at the left shoulder; "reverse" ends about 0.1 m behind her head. Cause (ops/research/DEFFLOW2_AUDIT_S385.md, "Not
DEFFLOW's bugs" 2): `CornerShots.inside()` (scripts/fight3d/CornerShots.gd ~line 110) walks a lens that is outside the
ropes up to 90% of the way toward its look point and has NO keep-out from bodies.

## What to build (owned files ONLY)
OWNS: scripts/fight3d/CornerShots.gd, tests/corner_lens_test.gd (new), tools/run_tests.sh (add `corner_lens_test` to TESTS).
1. In CornerShots.gd add `const KEEP_M := 0.45` and a pure static `keep_out(fr: Dictionary, bodies: Array) -> Dictionary`:
   `bodies` = Array of Vector3 points (drawn Head, Neck, Chest/UpperChest, both shoulders of every person near the lens).
   If the lens `pos` (or `pos + drift`) is closer than KEEP_M to any point, move the lens AWAY from that point along the
   look->pos line (back off from the look point) until every point is >= KEEP_M, staying inside the ropes (`_in`), then
   narrow `fov` by the distance gained so the framing holds (inverse of the widen formula inside() uses; clamp 15-70 deg),
   update `focus` if > 0. If no position on that line satisfies both, keep the nearest-to-valid one and set `fr["blocked"] = true`.
2. Call it: wherever CornerMinute.gd calls `CornerShots.inside(...)`, the caller must pass the bodies. Do NOT edit
   CornerMinute.gd (not owned) - instead make `inside(fr, bodies := [])` take the optional array and run keep_out after its
   own walk; CornerShots already reads bones (`bone(actor, "Head")`), so add `static func body_points(ctx) -> Array`
   that collects Head/Neck/UpperChest/LeftShoulder/RightShoulder for ctx["her"], ctx["coach"], ctx["blue_coach"] when present,
   and call `inside(fr, body_points(ctx))` from `frame()`'s callers inside CornerShots only. If CornerMinute calls
   inside() directly with no bodies, report that line in the PR body (Claude wires it).
3. Never exceed 500 lines in CornerShots.gd (now 165).

## Test (pure, headless, no models): tests/corner_lens_test.gd (extends SceneTree)
Cases with made-up Vector3s: (a) lens 0.24 m from a neck point -> after keep_out >= 0.45 m from every point and `_in`;
(b) lens 0.1 m behind a head -> >= 0.45; (c) lens already clear -> unchanged pos/fov; (d) fov narrows (not widens) when the
lens backs off; (e) a lens boxed in against the ropes -> `blocked` true, still `_in`; (f) drift end inside a body -> drift
shortened so the end is >= KEEP_M. Print `PASS <case>` lines and `CORNER_LENS failures=<n>`; quit(1) on any failure.
Run: `godot --headless --audio-driver Dummy --path . --script res://tests/corner_lens_test.gd`
Then the neighbours: corner_card_test, corner_jobs_test, corner_stats_test, golden_path_test must still pass.

## PR body
`RESULT: tests/corner_lens_test.gd -> CORNER_LENS failures=0` and one line per neighbour test; the CornerMinute.gd call
sites of inside() (file:line) and whether they pass bodies.

## The one trap
GDScript: no Variant `:=` from Dictionary reads (`var p: Vector3 = fr["pos"]`), `%` needs `%%` in format strings
(ops/research/GDSCRIPT_TRAPS.md). The exit code alone is not a pass: any SCRIPT ERROR line is a fail.

## Contract
Added S392, after the work was collected by diff in S386 (76cea38c). It records what that work owned; it reruns nothing.
OWNS: tests/corner_lens_test.gd
RED_TEST: tests/corner_lens_test.gd
REGRESSION: corner_lens_test
VISUAL: yes
