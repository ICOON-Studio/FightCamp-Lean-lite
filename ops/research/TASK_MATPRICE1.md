# TASK MATPRICE1 - QWEN (qwen3-coder) - what each line of the no-gi athlete's plan costs and is worth: one pure module + its test

Status: OPEN (S439, Claude lead). Discipline: no-gi grappling (the fourth starter, in scope since the operator's S428 change; the mat plan map passed two critics at 7 and 7). Model: qwen3-coder.
Source: ops/research/MATPLAN_MAP_S433.md, build task M3 (section 9), the chips in section 4.3 (lines 105-121) and the
worked numbers at the end of section 5 ("Worked numbers ..."): READ THOSE FIRST, they are the spec. M2 is on main:
scripts/rules/MatLines.gd (the plan's lines; read it and tests/mat_lines_test.gd for the shapes it uses).
THIS task is only the pure rule module that prices ONE line: numbers and words, no screen, no wiring.

## Contract
OWNS: scripts/rules/MatPrice.gd, tests/mat_price_test.gd
RED_TEST: tests/mat_price_test.gd -> MAT_PRICE failures=0
REGRESSION: mat_lines_test, bjj_tree_test, file_limits_test
VISUAL: no
NOT YOURS: every other file. BjjTree.gd, BjjBody.gd, BjjBeat.gd, BjjWalk.gd, TheRead.gd and MatLines.gd are read, never
edited. If one lacks what you need, say so in the PR body with the line; do not change it.

## What exists (read before writing)
- scripts/rules/BjjTree.gd: `odds(e, m_att, m_ans, rules, chain, read, ...)` (THE chance formula: never re-derive it),
  `mf(m)`, `p_bad(m_ans)`, `answer_mastery(defender, e, rules)`, `mastery(f, move_id)`, `state(m)` (Learning / Felt /
  Owned / Signature), `edge(id)`, `node_value(node_id)`, `logit_add(p, shift)`, `chip_word(p)`, `rules_for(belt)`.
- scripts/rules/BjjBody.gd: GAS_COST by move kind, the miss cost, `shift` (the body shift on the logit, capped), and how
  cardio scales a cost (find the exact functions; the map's worked Tank line is "escape 0.06 x (1.5 - 0.58) = 5.5 of
  100; a miss 2.8 more").
- scripts/rules/BjjBeat.gd: the hand-fighting stack (+0.15 on the logit a stack, 2 at most) and the beat length (11 s).
- scripts/rules/TheRead.gd: `looks_needed` and the read weight (how a scripted step is read after N looks).
- scripts/rules/MatLines.gd: a line is `{at, edge, timing}` with timing at_once / frame_first / sit_tight / set_up.

## The job: scripts/rules/MatPrice.gd (pure, static, about 200 lines, under 300; it may preload the rule modules above)
`price(f, opp, line, rules, known := {}) -> Dictionary` for one line, every value from the functions the match itself
calls (no second formula, no typed multiplier):
- `chance`: BjjTree.odds for the line's edge with the fighter's mastery and the answer level AS KNOWN: `known` maps an
  answer move id to the level the player has found on film; a found "no answer" divides by the tree's no-answer floor;
  with nothing found the answer is rated as an even owned answer (30) and `chance_lo` / `chance_hi` give the range
  between "no answer" and "owned answer" (the chip shows a range while the answer is hidden).
- `chance_timed`: the same chance with the timing applied: frame_first and set_up add two hand-fighting stacks on the
  logit (BjjTree.logit_add with the stack value read from BjjBeat); at_once equals `chance`; sit_tight is 0 (no try).
- `points` and `lands_at`: the edge's points and the node it gives (edge `points`, `ok`).
- `miss_at`, `miss_gives`, `miss_slides`: where a miss lands (edge `bad`, `bad_gives`) and how often it slides there
  (BjjTree.p_bad of the known answer level).
- `tank`, `tank_miss`: what a try costs out of 100 and what a miss adds, by BjjBody's own cost functions for this
  fighter's cardio; frame_first / set_up add the work cost of two beats (read the constant; say which in the PR body).
- `time_s`: 0 for at_once, two beats for frame_first / set_up.
- `read_mult`: the factor a scripted line loses to the opponent's read by its third try, from TheRead for the
  opponent's belt (the map's example: x0.82 at white).
- `grade`: "Good" / "OK" / "Poor" from BjjBody's body shift for this move against this opponent (Good at +0.08 or more,
  Poor at -0.08 or less: the map marks these two cut points ESTIMATE; keep them as two named consts).
- `level` and `level_word`: the fighter's mastery and BjjTree.state of it.
- `chips`: an Array of short plain strings for the screen, in this order: chance, points, miss, tank, read, time
  (for example "42 in 100", "+2, to mount", "miss: mount, 4 (7 in 10)", "Tank -6, -8 on a miss"). No pronoun; "Tank" is
  the mat plan's word for the grappler's gas in this map: use the word the existing mat screens use (grep
  scripts/ui for the word shown to the player and use that one; say which you found).
`worth` (points a match from seeded walks) is NOT in this task: it needs the match walk (task M4). Leave a clearly
named stub function out; do not fake a number.

## The test FIRST: tests/mat_price_test.gd (red on main: the module does not exist; prints `MAT_PRICE failures=N`)
- THE WORKED NUMBERS of the map's section 5, to 0.005: build Ana and Rosa with the masteries the map states (hip bump
  sweep 32 against an answer of 38; Americana after the sweep with the chain, answer 35, read after 3 looks of 16;
  frame and recover guard 36 with no answer found; seatbelt escape 22 with no answer found; armbar from guard 28
  against 38; kimura grip entry with no answer) and assert 0.50, 0.154 and 0.197 (set up), 0.345 and 0.416 (frame
  first), 0.244, 0.143, 0.48, and the miss slide 0.7 (answer 21). Build them through the game's own makers where one
  exists (see how tests/mat_lines_test.gd and tests/bjj_tree_test.gd build athletes) and set only the masteries the
  map names. If a worked number does not come out of BjjTree.odds, DO NOT bend the module: report the number you get,
  the map's number and the inputs in the PR body (the map may be wrong; the code is the truth).
- every `chance` equals a direct call of BjjTree.odds with the same inputs (assert against the call, not a typed number);
  `chance_timed` for at_once equals `chance`; for frame_first it equals BjjTree.logit_add(chance, 2 x the stack value).
- a hidden answer gives chance_lo < chance_hi and a found answer gives chance_lo == chance_hi == chance.
- tank and tank_miss equal BjjBody's own functions for two athletes with DIFFERENT cardio (never identical fighters).
- sit_tight: chance_timed 0, time_s 0, no tank spent.
- grade flips at the two cut points (build shifts just each side of +0.08 and -0.08).
- chips: six strings, no pronoun, the chance chip equals "<round(chance_timed x 100)> in 100".
- MUTANTS inside the test: a copy of price() that ignores `known`, and one that adds the stacks for at_once: each must
  fail asserts above; print `MUTANT caught` for each; an uncaught mutant is a failure.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (type every Dictionary read; `%%` in format strings).
- A test that only your own function can pass is not a test: assert against BjjTree / BjjBody / TheRead calls.
- Do not fit a constant to reach a worked number. Do not edit the map.
- Write the PR body last, from the final run.

## Prior research
ops/research/MATPLAN_MAP_S433.md (the whole design), ops/research/TASK_MATLINES1.md (the sister task, delivered).

## What would a human do?
A no-gi coach prices every line of the plan the same way before an open: how often it works on this opponent, what it
scores, where a miss leaves you, what it costs in gas, and whether the opponent will have seen it by the third try.

## Prefab check
BjjTree, BjjBody, TheRead and BjjBeat already hold every formula: the module only assembles them for one line.

Test command: `<godot.exe> --headless --audio-driver Dummy --path . --script res://tests/mat_price_test.gd` (the plain
win64 exe, never the console one). Parse first: `--check-only` on both files.
RESULT lines for the PR body: `RESULT: tests/mat_price_test.gd -> MAT_PRICE failures=0`.
