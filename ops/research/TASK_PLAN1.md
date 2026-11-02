# TASK_PLAN1 - the coach's plan board rules: arrows on a move map, one sport-free module (Qwen)

Model: Qwen (qwen3-coder). Discipline: boxing demo + the MMA prototype (operator Q-S294-62 "Yes, in that order", step 2 "ONE plan
board for boxing and wrestling - the coach links cards with arrows (your 'wire the in and outs' idea), the opponent's reaction
picks the branch"; Q-S294-61 the whiteboard plan game). Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_PLAN1, branch
`qwen/plan1`). Lean rules: its CLAUDE.md, no script over 500 lines, Godot headless only.

## Spec - NEW `scripts/rules/PlanBoard.gd` (extends RefCounted, static only, preloads nothing)
A MAP is an Array of move rows, each a Dictionary with at least `id`, `from`, `to` (ids of positions/cards), optional `kind`
("forced" rows can never be planned) and optional `reaction` (wrestling: what the opponent does; "" or missing in boxing).
A PLAN is an Array of arrows `{"move": <row id>}`; an arrow's place is its row's `from` + `reaction`.
- `const NEW_COACH := 4`, `const TOP_COACH := 9`. `arrow_limit(coach_skill: float) -> int` = clampi(4 + roundi((skill - 30) / 12),
  4, 9) (skill 30 -> 4, 90 -> 9).
- `row(map, id) -> Dictionary` ({} when unknown).
- `validate(plan, map, limit) -> Dictionary` {"ok": bool, "problems": Array[String]}: each problem a plain sentence - unknown move
  ("No move 'x' on this map"), a forced move ("'Backed onto the ropes' happens to her - it cannot be planned"), two arrows on the
  same place ("Two arrows from Mid range - pick one"; for a reaction: "Two answers when she pulls her arm away at Russian tie"),
  more arrows than the limit ("6 arrows - this coach can hold 4"). Use the row's `from`/`reaction` as written (no card names here).
- `pick(plan, map, at: String, reaction := "") -> String` - the planned move id at this place, "" when none.
- `coverage(plan, map) -> float` - planned places / plannable places (distinct from+reaction among non-forced rows), 0..1.
- `chains(plan, map, start: String, steps: int) -> Array` - following the plan from `start`: move ids in order, stopping at a place
  with no arrow, at `steps`, or when a place repeats (print-able as the plan's line).
- `change_one(plan, index: int, move_id: String) -> Array` - a copy with exactly arrow `index` replaced (the corner's one change).
- `rate(move_id, drilled: Array) -> float` - 1.0 when the move was drilled in camp, `UNDRILLED` (0.8) otherwise.

## Contract
OWNS: Lean/scripts/rules/PlanBoard.gd, Lean/tests/plan_board_test.gd
RED_TEST: tests/plan_board_test.gd -> PASS plan_board_test
REGRESSION: strike_map_test, wrestle_chains_test
VISUAL: no

## The test (write it FIRST; fails before PlanBoard.gd exists)
`tests/plan_board_test.gd` (extends SceneTree, `_check` style): uses BOTH maps -
boxing: `StrikeMap.MOVES` as is; wrestling: rows built in the test from `WrestleChains.ANSWERS` (id = tie + ":" + reaction,
from = tie, to = link or "finish", reaction = reaction).
1. arrow_limit(30) == 4, (90) == 9, (0) == 4, (200) == 9, (60) is 6 or 7.
2. Boxing plan [step_in, 1-2-3, 3b-3, tie_up] valid with limit 4; chains(..., "outside", 10) == those four in order.
3. Problems: adding "1-2" (a second arrow from long) -> a "Two arrows" problem; "backed_up" -> "cannot be planned"; "zzz" -> "No
   move"; 5 arrows with limit 4 -> the count problem. Each sentence printed.
4. Wrestling: two answers at russian_tie with different reactions are valid; the same reaction twice is a problem;
   pick(plan, map, "russian_tie", "pulls her arm away") returns that answer's id.
5. coverage: empty plan 0.0; the boxing plan above > 0 and < 1; a plan with one arrow per plannable place == 1.0 (build it from the map).
6. change_one changes exactly one arrow and leaves the input untouched; rate("1-2-3", ["1-2-3"]) == 1.0, rate("1-2-3", []) == 0.8.
Ends `PASS plan_board_test` / `FAIL <n>`, quit(0/1); a SCRIPT ERROR line is a failure even with exit 0.
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/plan_board_test.gd`
then strike_map_test and wrestle_chains_test the same way. The plain exe only.

## Final answer
`RESULT: tests/plan_board_test.gd -> PASS plan_board_test`, the printed problem sentences and chains, last lines of the three runs.

## Prior research / human / prefab
STRIKEMAP_S335.md s4 (whiteboard plan: arrow limit by coach, undrilled arrows weaker, one corner change a round), WRESTLE_S336.md
(GrappleFlows: cards + arrows; 223 Wrestling: the reaction picks the branch), C154 ("wire the in and outs"). A coach writes a game
plan as "from here, do this; if she does that, answer with this". Prefab: none (GrappleFlows is a web app, a reference only).
Trap: keep it sport-free - no StrikeMap or WrestleChains preload in the module; the maps come in as arguments.
