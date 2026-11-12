# TASK MATLINES1 - QWEN (qwen3-coder) - the no-gi athlete's plan lines: one pure module + its test

Status: OPEN (S439, Claude main). Discipline: no-gi grappling (the fourth starter, in scope since the operator's S428 change; the mat plan map passed two critics at 7 and 7). Model: qwen3-coder.
Source: ops/research/MATPLAN_MAP_S433.md, build task M2 (section 9), mechanics in sections 4.1, 4.2 and 4.5 (lines
60-103 and 140-148: READ THEM FIRST, they are the spec). THIS task is only the pure rule module: no screen, no
wiring into the match. The wiring (BjjBeat._choose calling pick) is a later task and is NOT yours.

## Contract
OWNS: scripts/rules/MatLines.gd, tests/mat_lines_test.gd
RED_TEST: tests/mat_lines_test.gd -> MAT_LINES failures=0
REGRESSION: bjj_tree_test, file_limits_test
VISUAL: no
NOT YOURS: every other file. BjjTree.gd, BjjBeat.gd, BjjWalk.gd, BjjBody.gd, BjjOpp.gd and assets/data/bjj_tree.json are
read, never edited. If one of them lacks what you need, say so in the PR body with the line; do not change it.

## What exists (read before writing)
- assets/data/bjj_tree.json: `nodes` (49; id, side "neutral"/"top"/"bottom", family), `moves` (80; id, kind, belt),
  `edges` (135; id, move, from, ok, bad, points, bad_gives, answers), `routes`.
- scripts/rules/BjjTree.gd (static): data(), node(id), move(id), edge(id), edges_from(node_id), mastery(f, move_id),
  state(m) ("Learning" under 15 / "Felt" / "Owned" / "Signature"), usable(m), rules_for(belt), legal(move_id, rules),
  odds(e, m_att, m_ans, rules, chain, read, ...), p_bad(m_ans), answer_mastery(defender, e, rules), IQ (by belt:
  white 40, blue 55, purple 70, brown/black 85), plan_of(f, rules), route_ok(steps).
- The A-game today: f["bjj_plan"] = {goal, steps, name}. The pace dial: f["mat_call"] ("hunt" / "steady" / "hold",
  BjjBody.CALLS).
- scripts/rules/BjjBeat.gd `_choose` (line 141) and BjjWalk.choose: the shape of a pick Dictionary and of ctx / st
  (read them to return the SAME shape from pick; do not guess keys).

## The job: scripts/rules/MatLines.gd (pure, static, about 220 lines, under 300)
The plan shape (stored on the fighter as f["bjj_plan"], the three old keys unchanged, the new keys optional so an old
save still loads):
`{goal, steps, name, opening, lines: [{at, edge, timing}], board: {level, ahead, behind}}`
- `opening`: "pull" / "shoot" / "snap" / "wait".
- a line: `at` = a node id (the position Ana is in), `edge` = an edge id leaving that node, `timing` = "at_once" /
  "frame_first" / "sit_tight" for an ESCAPE line (at is a "bottom" position), "at_once" / "set_up" for a FINISH line
  (the edge's move kind is "submission").
- `board`: each of level / ahead / behind is "push" / "steady" / "save".
Functions:
1. `validate(f, plan, rules) -> Array` of plain-word problems (empty = fine). A line is refused when: its edge does
   not exist; the edge's `from` is not the line's `at`; the move is not usable by this fighter (BjjTree.usable of
   BjjTree.mastery: a Learning move is refused); the move is not legal under `rules` (BjjTree.legal); the timing word
   does not belong to that kind of line; two lines share one `at`.
2. `hand_size(belt) -> int`: lines brought besides the A-game: 3 at white, 4 at blue, 5 at purple and up (read
   BjjTree.IQ: 40 -> 3, 55 -> 4, 70 or more -> 5; do not type a second belt table).
3. `brought(f, plan, rules) -> Array`: the valid lines in the ESCAPE ORDER, worst position first (back taken, mount
   bottom, side control bottom, knee on belly bottom, north-south bottom, turtle, then the leg positions, then finish
   lines), cut to hand_size. Find the real node ids for those positions in bjj_tree.json; keep the order as ONE const
   array of node ids and test that every id in it exists in the tree.
4. `draft(f, leaks, rules, opp = {}) -> Dictionary`: Coach's draft of lines and board. `leaks` is an Array of node
   ids, worst first (the caller gets it from the seeded walks; you never run a walk here). For each leak position: the
   usable, legal escape edge with the best chance (BjjTree.odds with Ana's mastery and, as the answer, the opponent's
   BjjTree.answer_mastery when `opp` is given, else an even owned answer 30); timing "frame_first" when a miss slides
   1 time in 2 or more (BjjTree.p_bad of that answer >= 0.5), else "at_once". For the end position of the A-game
   route (the `ok` of the last step): the best usable legal finish; "set_up" when its chance at once is under 0.25,
   else "at_once". Board: level "steady", ahead "save", behind "push". A position with no usable escape gets no line
   (the caller shows the Learning one).
5. `pick(ctx, st, s) -> Dictionary`: called before the walk's own choice. On a position that has a brought line for
   side `s`: return the pick for that line's edge in the SAME shape BjjWalk.choose returns, with `why` = "line", and a
   key `wait` = true while timing is frame_first / set_up and that side's hand-fighting stack in `st` is under 2 (find
   the real key of the stack in BjjBeat.walk; say in the PR body which key you read). "sit_tight" returns
   `{why = "line", sit = true}` and no attempt. On any other position, or with no lines in the plan: return `{}`
   (the caller then runs today's path unchanged).
6. `board_call(plan, my_points, their_points) -> String`: "push" / "steady" / "save" from the board row for the score
   now (level when equal), mapped by the caller onto BjjBody.CALLS (push = "hunt", save = "hold"); return the CALLS
   key so no second table exists. A plan with no board returns the fighter's own f["mat_call"] or "steady".
7. `lines_using(plan, move_id) -> Array`: the lines whose edge uses that move (for the Playbook's chip).

## The test FIRST: tests/mat_lines_test.gd (red on main because the module does not exist; prints `MAT_LINES failures=N`)
Build two DIFFERENT athletes from the game's own makers (find how tests/bjj_tree_test.gd builds a white belt and a
blue belt; never two identical fighters, never typed mastery tables where the game can make them). Assert:
- a line on a Learning move is refused by validate with a problem naming the move; the same line is accepted once the
  move's mastery is 15 or more;
- a line whose `at` is not the edge's `from` is refused; an illegal move under the white-belt rules is refused;
- a white belt with five valid lines brings 3, in the escape order (the back line before the side-control line
  whatever order they were written in); a blue belt brings 4;
- draft: against an opponent who OWNS the answer (p_bad >= 0.5) the escape is "frame_first"; against one with no
  answer it is "at_once" (assert against BjjTree.p_bad of the same answer, not a typed number); a finish under 0.25
  at once is "set_up" (assert against BjjTree.odds of the same call);
- pick returns the line's edge only on its own position and `{}` on every other node of the tree (loop all 49); with
  an empty `lines` it returns `{}` on all 49 (today's path);
- pick's `wait` is true at stack 0 and 1 and false at 2 for frame_first; at_once never waits; sit_tight never
  attempts;
- board_call: level / ahead / behind each read its own row; no board = the fighter's own call;
- every node id in the escape-order const exists in the tree and is a "bottom" position.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (Variant `:=` on Dictionary reads: type the variable; `%%` in format strings).
- A test that only your own function can pass is not a test: every chance, slide share and legality is asserted
  against the BjjTree function the match itself calls, never against a number you typed.
- Do not fit a threshold to make an assert pass. 0.5 and 0.25 are the map's numbers; if the tree gives no case on one
  side of a threshold, SAY SO in the PR body with the nearest values; do not move the threshold or invent a move.
- Words for the player: "Coach", never a surname; no pronoun for a fighter in a built string.
- Write the PR body last, from the final run.

## Prior research
ops/research/MATPLAN_MAP_S433.md (the whole design, scored 7 and 7), ops/research/GAMETREE (the tree's own notes:
`ls ops/research | grep -i GAMETREE`).

## What would a human do?
A no-gi coach writes exactly this list before an open: how to start, the route, what to do first when it goes wrong
("never give the back"), where to finish, and what to do by the score. The module is that list and its checks.

## Prefab check
BjjTree already has the odds, the slide share, legality and mastery: the module only arranges them. No outside asset.

Test command: `<godot.exe> --headless --audio-driver Dummy --path . --script res://tests/mat_lines_test.gd` (the plain
win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/mat_lines_test.gd -> MAT_LINES failures=0`.
