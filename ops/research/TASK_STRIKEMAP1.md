# TASK_STRIKEMAP1 - the boxing move map: 8 position cards, every combo a move from one card to another (Qwen)

Model: Qwen (qwen3-coder, qwen_task.cmd). Discipline: BOXING = demo work (operator Q-S294-61 "Yes, in that order", step 1 of 4).
Repo: **E:\FightCamp\Lean** (worktree E:\FightCamp\wt\LEAN_STRIKEMAP1, branch `qwen/strikemap1`). Lean rules: its CLAUDE.md,
no script over 500 lines, Godot headless only, nothing opens on the screen.

## Why
Our boxing combos (`scripts/rules/Combos.gd` BOOK, 10 combos) have no idea WHERE they start or end. Coaches teach and plan
by range and ring place. The operator approved a boxing version of the ground-move map: position cards, and every combo,
step and defence is a move FROM one card TO another (design: E:\FightCamp\Game\research\STRIKEMAP_S335.md). Later
steps (not this task) put it in a browser, on the Training page, and on the coach's whiteboard plan.

## Spec - NEW `scripts/rules/StrikeMap.gd` (extends RefCounted, static functions only, may preload Combos.gd, nothing else)
`const CARDS` (exactly these 8, in this order; `range_m` = [near, far] metres between the two boxers, [] when it is a ring place):
| id | name | what | range_m |
|---|---|---|---|
| outside | Outside | Out of range, feinting, hands low enough to move | [1.4, 3.0] |
| long | Long range | Jab range | [1.05, 1.4] |
| mid | Mid range | Hook and uppercut range | [0.7, 1.05] |
| inside | Inside | Heads close, short punches | [0.45, 0.7] |
| clinch | Clinch | Tied up until the referee breaks it | [0.0, 0.45] |
| own_ropes | On the ropes | Her back on the ropes or in a corner: she is trapped | [] |
| opp_ropes | She has her on the ropes | The opponent's back is on the ropes | [] |
| corner | Corner trap | She has the opponent trapped in a corner | [] |

`const MOVES` (exactly these 30 rows; `kind` = combo (a Combos.BOOK id in `combo`), step, defence, or forced (it happens TO her:
never chosen, only listed as a way in); `id` = combo id, or combo id + "@" + from when a combo appears a second time):
| id | name | kind | combo | from | to |
|---|---|---|---|---|---|
| step_in | Step in | step | | outside | long |
| 1-1-2 | Double jab, cross | combo | 1-1-2 | outside | long |
| feint | Feint and draw | step | | outside | outside |
| 1-1 | Double jab | combo | 1-1 | long | long |
| 1-2 | One-two | combo | 1-2 | long | long |
| 2-3 | Cross, hook | combo | 2-3 | long | mid |
| 1-2-3 | One-two-hook | combo | 1-2-3 | long | mid |
| 1-2-3-2 | One-two-hook-cross | combo | 1-2-3-2 | long | mid |
| 1-2-3b | One-two, body hook | combo | 1-2-3b | long | mid |
| step_out | Step out | step | | long | outside |
| cut_off | Cut off the ring | step | | long | opp_ropes |
| 1-6-3 | Jab, uppercut, hook | combo | 1-6-3 | mid | inside |
| 3b-3 | Body hook, head hook | combo | 3b-3 | mid | inside |
| slip 2-3 | Slip, cross, check hook | combo | slip 2-3 | mid | mid |
| step_back | Step back | step | | mid | long |
| backed_up | Backed onto the ropes | forced | | mid | own_ropes |
| tie_up | Tie up | defence | | inside | clinch |
| roll_out | Roll under and out | defence | | inside | mid |
| 3b-3@inside | Body hook, head hook | combo | 3b-3 | inside | inside |
| break | Referee breaks | forced | | clinch | long |
| push_off | Push off | step | | clinch | mid |
| pivot_out | Pivot off the ropes | step | | own_ropes | mid |
| tie_up@own_ropes | Tie up | defence | | own_ropes | clinch |
| slip 2-3@own_ropes | Slip, cross, check hook | combo | slip 2-3 | own_ropes | mid |
| 1-2@opp_ropes | One-two | combo | 1-2 | opp_ropes | opp_ropes |
| 3b-3@opp_ropes | Body hook, head hook | combo | 3b-3 | opp_ropes | inside |
| herd | Walk her into the corner | step | | opp_ropes | corner |
| 3b-3@corner | Body hook, head hook | combo | 3b-3 | corner | corner |
| 1-6-3@corner | Jab, uppercut, hook | combo | 1-6-3 | corner | corner |
| spins_out | She spins out | forced | | corner | mid |
Each row is a Dictionary `{"id", "name", "kind", "combo", "from", "to"}` (`combo` = "" when not a combo).

Functions (all static):
- `card(id: String) -> Dictionary` ({} when unknown); `move(id: String) -> Dictionary` ({} when unknown).
- `outs(card_id: String) -> Array` - rows with `from == card_id` and kind != "forced", in MOVES order.
- `ins(card_id: String) -> Array` - rows with `to == card_id` (forced included), in MOVES order.
- `grey_reason(row: Dictionary, mastery: Dictionary) -> String` - "" when she can use it. A combo row whose punches are not all
  learned (`Combos.missing(row.combo, mastery)` not empty) -> "Learn the " + missing punches joined with " and " + " first"
  (e.g. "Learn the Lead hook first"). A forced row -> "It happens to her". Steps and defences -> "".
- `route(from_id: String, to_id: String) -> Array` - the shortest chain of row ids (breadth-first over outs() then forced rows,
  MOVES order breaks ties) from one card to another; [] when from == to or unreachable.

## Contract
OWNS: Lean/scripts/rules/StrikeMap.gd, Lean/tests/strike_map_test.gd
RED_TEST: tests/strike_map_test.gd -> PASS strike_map_test
REGRESSION: combos_test
VISUAL: no (data + rules; the browser screen is a later task)

## The test (write it FIRST; it fails before StrikeMap.gd exists)
`tests/strike_map_test.gd` (extends SceneTree, style of tests/combos_test.gd; `_check(ok, what)` prints `  ok   ` / `  FAIL `):
1. 8 cards, ids unique and in the order above; 30 moves, ids unique.
2. Every move's `from` and `to` is a card id; every combo row's `combo` is a Combos.BOOK id.
3. Every Combos.BOOK id appears in at least one row (the whole book is on the map).
4. Every card has at least one way out (outs() not empty) and one way in (ins() not empty).
5. From `outside`, every card is reachable (route non-empty for each other card), and every card reaches `long`.
6. Range sense: no combo row whose punches include a hook, body hook or uppercut (Combos.row(id).beats has "lead_hook",
   "body_hook" or "rear_uppercut") starts at `outside`.
7. `grey_reason`: with an empty mastery dict, row "1-2-3" names "Lead hook"; with every punch name at 50, every combo row
   gives ""; "break" gives "It happens to her"; "step_in" gives "".
8. `route("outside", "clinch")` chains: each row's `to` is the next row's `from`, the first `from` is outside, the last `to`
   is clinch. Print it.
Ends `PASS strike_map_test` or `FAIL <n>`, quit(0/1).
Command: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/strike_map_test.gd`
then `... --script res://tests/combos_test.gd`. The plain exe only (never the console build).

## PR body / final answer
`RESULT: tests/strike_map_test.gd -> PASS strike_map_test`, the printed route, and the last lines of both test runs.

## Prior research
`python Tools/prior_research.py ring position range combo ropes` -> STRIKEMAP_S335.md (this design), FIGHT_PLANS_RESEARCH.md
(plans by range and situation), topics/footwork.md. Ranges: jab ~1.2 m, hook 0.75-0.85, clinch < 0.65 (CLIPREVIEW1, S259).

## What would a human do?
A boxing coach draws a game plan by range and ring place: "at long range double the jab, step in behind the 1-2-3, if she
puts you on the ropes pivot out, inside tie her up". Each instruction is a move from one situation to the next. That is
this table.

## Prefab check
No boxing move graph exists to reuse (STRIKEMAP_S335: coaches draw strike trees by hand in Miro or draw.io; GrappleMap is
grappling only). A 30-row table and four lookups is our own code. Licence: ours.

## The trap
Do not change Combos.gd or its BOOK: this map points at the book by id. Do not invent extra rows; the table is the design.
