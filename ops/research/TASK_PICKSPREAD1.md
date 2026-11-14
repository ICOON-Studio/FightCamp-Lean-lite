# TASK PICKSPREAD1 - is any "what to learn next" card always the right pick? (a probe; headless, no fix)

Status: OPEN (S473, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror).

## Why now
The owner approved the progression plan (Q-211 "Yes, go ahead"); its build order item 12 asks for the probes, one of them
PICKSPREAD1 (ops/research/PROGRESSION_MAP_S448.md line ~281). The game shows the coach's three cards for what a fighter
studies next (scripts/rules/LearnSlots.gd `cards(f, opp_style, gains)`, 143 lines). If one card position, or one move, is
nearly always best, the pick is not a decision - the design would need changing before more screens are drawn on it.

## What to do (measure only - change no game script)
Write tools/pickspread_probe.gd (extends SceneTree, headless, under 500 lines). Reuse tools/treevalue_probe.gd's setup
(468 lines: its 60 generated fighters via AttrGen, its four style opponents OPPS, its PLAN, its bout loop and FireLevel on)
by copying the few functions you need - do not edit treevalue_probe.gd.
For each of 60 generated fighters (fixed seeds), for the first FIVE picks in a row:
1. Ask LearnSlots.cards(f, opp_style, gains) for the three cards (opp_style rotates through the four OPPS styles by fighter).
2. For EACH card: copy the fighter, put that move in the study slot (LearnSlots.pick), play 6 weeks of pad-night gain on
   it (the probe's existing mastery step - name the function you used in the doc), then play N bouts against each of the
   four OPPS and record the win share.
3. The card with the best win share is that pick's "best"; continue the career with the card the coach would put first
   (card 0) so the next pick sees a real state.
Print one line per pick: `PICK fighter=<i> n=<1..5> cards=<a,b,c> win=<x,y,z> best=<position>`, then the summary lines:
`PICKSPREAD position_best=<p0,p1,p2 shares> coach_first_best=<share> node_best_max=<node:share> pivot_share=<share>`
and `PICKSPREAD pass=<0|1> why=<which gate failed>`.
Gates (from the map): no card position best in more than 6 in 10; the coach's first card best in under 5 in 10; no single
node best in more than 4 in 10 of the picks it appears in. Also report Pivot's share among all cards shown.
N: enough bouts that the dice of one share is under 2 in 100 (say which N and why); keep the run under 20 minutes.
Then docs/PICKSPREAD1_RESULT.md: the table of shares, which gates pass, and ONE paragraph in plain words: is the pick a real
choice, and if not, which card or move dominates and why (read LearnSlots' scoring to say why).

## Pass lines
- `PICKSPREAD pass=` printed; 300 PICK lines (60 x 5); the result doc.
- RESULT: tools/pickspread_probe.gd -> PICKSPREAD pass=

## Contract
OWNS: tools/pickspread_probe.gd, docs/PICKSPREAD1_RESULT.md
RED_TEST: tools/pickspread_probe.gd -> PICKSPREAD pass= (a new probe; nothing is red on main - it has no file yet)
REGRESSION: none (no game script changes)
VISUAL: no
NOT YOURS: every script under scripts/, every test under tests/, tools/treevalue_probe.gd. No number changed anywhere.
Run: `godot --headless --audio-driver Dummy --path . --script res://tools/pickspread_probe.gd` (Godot 4.7.2). No .glb/.png/
audio is loaded by these rule modules, so the lite mirror runs it. Work on your own arena/ branch, open a PR, never merge.

## Prior research
ops/research/PROGRESSION_MAP_S448.md sections 9-10 (the probe table); tools/treevalue_probe.gd and docs/TREEVALUE1_RESULT.md
(the same fighters and bouts); scripts/rules/LearnSlots.gd (the cards and their scoring); docs/NODEREAD1_RESULT.md (which
moves a bout reads at all - a move no bout reads can never be "best").
## What would a human do?
Play the same fighter down each of the three roads for six weeks and see whether one road always wins.
## Prefab check
None: our own rules.
