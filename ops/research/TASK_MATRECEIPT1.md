# TASK MATRECEIPT1 - the mat plan's receipt per line after an open (pure rule, MATPLAN M7)

Status: OPEN (S515, Claude main line). Discipline: BJJ (no-gi; the club's grappler, inside the agreed scope S428).
Model: qwen3-coder (or any seat that runs Godot). A PURE module + its test; Claude wires the open result and the week
review after it lands.

## Contract
OWNS: scripts/rules/MatReceipt.gd, tests/mat_receipt_test.gd
RED_TEST: tests/mat_receipt_test.gd -> MAT_RECEIPT PASS
REGRESSION: mat_lines_test, mat_plan_walk_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py mat plan receipt`. Map: ops/research/MATPLAN_MAP_S433.md sections 4.6 and 4.7 (and
the M7 row of section 9). Built since S515: the plan's lines reach the match (scripts/rules/BjjBeat.gd `_choose` takes
`MatLines.pick`; a line's attempt is in the walk's `path` as [edge_id, actor, "hit"|"miss"|"reset", t]). Read
scripts/rules/MatLines.gd (plan shape, `brought`), scripts/rules/BjjOpen.gd (`sim_bout` rows: each bout row has "path",
"win", "opp", "style"), scripts/rules/PlanRecord.gd `verdict` (works / fails / even / too early). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
After the open the coach goes down the plan: "your back escape: tried 3, worked 2; the americana: never got there". Over
several opens the coach says which lines work.

## Prefab check
None: the data is the walk's own path.

## The job: scripts/rules/MatReceipt.gd (extends RefCounted, preloads MatLines + BjjTree + PlanRecord only, static, < 200 lines)
1. `line_receipt(line: Dictionary, rows: Array) -> Dictionary`: over the open's bout rows, Ana's (actor 0) tries of the
   line's edge: {at, edge, tried, landed, missed (slid: the walk wrote "miss"), reset, first_t} and `words`:
   "<move name>: <landed> of <tried>" + ", never reached" when tried is 0. Rows without a path (a live bout) are skipped.
2. `receipt(plan: Dictionary, f: Dictionary, rows: Array, rules: Dictionary) -> Array`: one line_receipt per BROUGHT line
   (MatLines.brought), in the brought order.
3. `season_add(book: Dictionary, receipts: Array) -> Dictionary`: adds an open's receipts into a running book keyed by
   edge id ({used, won} like PlanRecord rows) and returns it; `verdict_of(book, edge) -> String` = PlanRecord.verdict on
   that row (works at 55 %+, fails at 35 % or less, on 6 tries or more, else even / too early).
4. `teach(receipts: Array) -> Dictionary` (map 4.6 BOUTS TEACH, ESTIMATE): {move_id: gain}: +1 a landed try, +0.5 a
   missed or reset one, at most +3 a move an open.

## tests/mat_receipt_test.gd (SceneTree, headless)
Hand-made rows with known paths: a line tried 3 / landed 2 -> "2 of 3"; a line never reached -> "never reached";
the opponent's (actor 1) tries of the same edge are not counted; a live row (no path) is skipped; receipt keeps the
brought order and drops a not-brought line; season_add over two opens sums; verdict "too early" under 6 tries, "works"
at 4 of 6, "fails" at 2 of 6; teach caps at 3 and counts 0.5 a miss. Plus ONE real open: NoGi.athlete with a plan whose
lines come from MatLines.draft, BjjOpen.run_open on a seeded rng: the receipt's tried counts equal a direct count of the
rows' paths. Last line `MAT_RECEIPT PASS` (or FAIL n).

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`, `--log-file E:/FightCamp/tmp/<run>.log`. No screens.
Nothing outside OWNS; never touch scripts/fight3d/. No he / she words in any string the player reads.

## The one trap
The path's actor is the SIDE (0 = Ana); the edge ids are the tree's own, mirrored for side 1 - never count side 1's rows.
