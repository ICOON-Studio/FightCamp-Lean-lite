# TASK MOVETREE1 - GOOSE (cloud, pure module) - the boxing move tree as rules and data

Status: OPEN (S448 side session, for the S449 lead). Discipline: boxing. Model: Goose + qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M1 (the tree,
day 0, old saves, row locks), M2 (slots) and M4 (style sets) - READ THEM. This task is the PURE module and its tests only: nothing in the
game calls it yet (wiring is later tasks STEPMASTERY1 and SLOTS1).

## Contract
OWNS: scripts/rules/MoveTree.gd, tests/move_tree_test.gd
RED_TEST: tests/move_tree_test.gd -> MOVE_TREE failures=0
REGRESSION: move_mastery_test, combos_test, fire_level_test, plan_fight_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- scripts/rules/BjjTree.gd (the pattern: a pure tree of nodes with needs, states learning / felt / owned).
- scripts/state/Data.gd MOVES (line ~234, the 6 punch names) and `fighter_state` (~242, f["moves"]).
- scripts/rules/StrikeMap.gd (lines 2-49): the step and defence ids: step_in, step_out, step_back, pivot_out, cut_off, herd, feint,
  tie_up, roll_out, push_off.
- scripts/rules/PunchStart.gd `mastery(technique, move)` (the start shares).

## What to build (MoveTree.gd under 300 lines; data as a const inside it, no json)
NODES: 16, each {id, branch, row, needs: {node_id: mastery}}:
- punches by Data names: Jab, Lead hook, Cross, Body hook (row 1); Uppercut (row 2, needs Cross 30 + step_in 30); Check hook (row 2,
  needs Lead hook 60).
- steps by StrikeMap ids: step_in, step_out (row 1); step_back (row 2, step_out 30); pivot_out (row 2, step_back 30); cut_off (row 3,
  step_in 60); herd (row 3, cut_off 30); feint (row 3, Jab 60).
- defences: tie_up (row 2, step_in 30); roll_out (row 2, Lead hook 30); push_off (row 3, tie_up 30).
- branches: lead, rear, footwork, defence (map M1 table).
ROWS: row 1 open at signing; row 2 open when 5 nodes are at 30+; row 3 when 9 are. A ROW'S LOCK ONLY STOPS LEARNING: a node already at
30+ in a locked row counts as known and usable.
STYLE SETS (map M4, v4.1): Out-boxer [Jab, step_out, step_back]; Volume puncher [Jab, Cross, pivot_out]; Boxer-puncher [Cross, step_in,
Uppercut]; Pressure fighter [step_in, Body hook, tie_up]; Slugger [Body hook, Lead hook, roll_out]; Counter-puncher [Lead hook, step_out,
Check hook].
Functions (pure static, mastery read from a dict {node_id: float}; punches from f["moves"], steps/defences from f["steps"] if present):
- `mastery(f, id) -> float` (steps/defences absent -> 0.0).
- `usable_count(f) -> int`, `row_open(f, row) -> bool`.
- `state(f, id) -> String`: "known" (30+), "open" (row open and needs met, under 30), "locked" (else).
- `open_nodes(f) -> Array` (state "open"), `opens(id) -> Array` (nodes whose needs name it).
- `day0_steps(footwork: float) -> Dictionary`: step_in and step_out = max(30, 0.55 x footwork); every other step/defence 0.
- `old_save_steps(plan_arrows: Array) -> Dictionary`: a step/defence in the plan 60, any other 30.
- `styles_held(f) -> Array`: the style names whose three moves are all at 60+.
- `places(id) -> Array`: for a step or defence, the [from, to] ring places of every StrikeMap row with that id (or id@place); for a
  punch, the places of the StrikeMap combinations that use it. Read them from StrikeMap.MOVES, never invent them.

## The test (red on main first: MoveTree.gd does not exist)
tests/move_tree_test.gd prints `MOVE_TREE failures=<n>`:
- 16 nodes; every punch id is in Data.MOVES; every step/defence id is a StrikeMap move.
- Each row-1 punch / step sits in exactly two style sets; every third move is in exactly one set; no node in three sets.
- Day 0 at Technique 60, Footwork 55 (PunchStart shares + day0_steps): 6 known (Jab, Cross, Lead hook, Body hook, step_in, step_out),
  row 2 open, row 3 closed, open_nodes contains Uppercut and step_back but not pivot_out or cut_off.
- Technique 45: Lead hook under 30 -> row 2 closed.
- A locked-row node at 30+ reads "known" (row lock stops learning only).
- styles_held: Jab 61, step_out 60, step_back 60 -> ["Out-boxer"]; drop step_back to 59 -> [].
- old_save_steps(["step_back"]) -> step_back 60, pivot_out 30.

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first. Pure static, one or two preloads only (StrikeMap, PunchStart). No game state, no Career.
- Never two identical fighters in a test that compares fighters. Do not delete or weaken any test.
- No he / she in any string (no_pronoun_test).

## Prior research
- ops/research/PROGRESSION_MAP_S448.md (approved v4.1) and PROGRESSION_RESEARCH_S448.md (why a small tree: 5-25 nodes, one screen).
- ops/research/SkillAwards header (GB Boxing Awards order: stance and moving, jab and rear hand, hooks, uppercuts and counters).

## What would a human do?
A club coach teaches the jab and moving in and out first, the hook off the jab next, the pivot after the step back, the check hook last.

## Prefab check
BjjTree.gd is the in-house pattern; no outside asset fits a 16-move boxing syllabus.

Test command: `godot --headless --audio-driver Dummy --path . --script res://tests/move_tree_test.gd`
RESULT line for the PR body: `RESULT: tests/move_tree_test.gd -> MOVE_TREE failures=0`.
