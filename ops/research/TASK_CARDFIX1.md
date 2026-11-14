# TASK CARDFIX1 - which card-table fix lets every best answer fire, without breaking the win balance? (probe, no screen)

Status: OPEN (S465, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
CARDVISIT1 (docs/CARDVISIT1_RESULT.md, tools/cardvisit_probe.gd on main, Claude reran it S465) found the "outside" card is
never reached (0 of 8382 exchanges): PlanFight.GAME_CARD (scripts/rules/PlanFight.gd:22) never names "outside", and the only
way in is a WON step_out from "long" (StrikeMap row "to"). So step_in, feint and 1-1-2 (all "from": "outside") can never fire,
and several PlanFight.ANSWERS "best" pairs sit on a card their situation never puts the fight on (the static list at the end of
ops/research/TASK_CARDVISIT1.md). This is a design question: Claude picks the fix from your numbers. You measure the arms.

## What to build (tools/cardfix_probe.gd; start from tools/cardvisit_probe.gd on main - it parses and runs)
Same fighters (60, seeds 7100-7159), same four opponents, same CALIBRATE block, 2 bouts per fighter per opponent, bars 45,
BASE plan = cardvisit's PLAN. The probe keeps a LOCAL card table per arm and sets lv["at"] from it exactly where LiveRound
does (the same way cardvisit's mutant arm forces at - a local copy of the loop, never an edit in scripts/):
- ARM A (today): PlanFight.GAME_CARD as it is.
- ARM B: GAME_CARD with "counter": "outside" (a counter-puncher waits out of reach; boxing: you feint to find the timing).
- ARM C: ARM B plus "she_tired": "long" (tired, she gets out to range to breathe; step_out/step_back/1-1 are its best answers).
- ARM D: ARM C plus "range": "outside" (a long-range jabber keeps it out of reach until someone steps in).
For each arm print: the card x situation table (as cardvisit), REACH for every ANSWERS pair, and WINS per opponent style
(out of the cell's bouts) for the BASE plan, plus wins with every step/defence bar at 0 vs 70 for step_in, feint, step_out
(the TREEVALUE question: does the node now change results?).

## Pass lines (print each, yes/no, per arm)
- every StrikeMap card reached >= 1 in 100 (outside, long, mid, inside, clinch, own_ropes, opp_ropes, corner)
- every ANSWERS "best" pair REACH >= 1 in 100 (list the failures)
- BASE wins per opponent stay within 40-60 of 100 (calibrated at ~50: a fix must not make one style trivial)
- step_in, feint, step_out each read a different win count at 0 and 70 (bar 70 - bar 0 >= 1.5 wins in some cell)
Final line: `CARDFIX best_arm=<A|B|C|D|none> A:never_best=<n> B:never_best=<n> C:never_best=<n> D:never_best=<n>`.
CONTROL: the same seeds twice give identical tables; ARM A must reproduce cardvisit's table (outside 0.0%) - if it does not, your
local loop differs from LiveRound and every arm is void: say so and stop.

## Contract
OWNS: tools/cardfix_probe.gd, docs/CARDFIX1_RESULT.md (written by the probe's own writer from the run, never by hand)
RED_TEST: tools/cardfix_probe.gd -> CARDFIX best_arm=
REGRESSION: plan_bout_test, fire_level_test
VISUAL: no
NOT YOURS: every file in scripts/ and tests/ (read-only). Never change a rule; report the arms.
Runs only through `python ops/Tools/godot_slot.py run --who cardfix1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/cardfix_probe.gd`.
Under 500 lines (split a helper file under tools/ if needed). PR body: `RESULT: tools/cardfix_probe.gd -> CARDFIX best_arm=...`.

## Prior research
docs/CARDVISIT1_RESULT.md, docs/TREEVALUE1_RESULT.md, tools/cardvisit_probe.gd, tools/treevalue_probe.gd; scripts/rules/
PlanFight.gd (GAME_CARD, LOST_CARD, ANSWERS, where_next), StrikeMap.gd (from/to), PlanBoard.gd:74, scripts/state/LiveRound.gd:262,
LiveRoundAfter.gd:44, RingDuel.gd:337 (read-only). S450: a probe that reads the same in both arms is void.

## What would a human do?
A coach asks where each kind of opponent makes you fight, then drills the moves for that place. If the map of places is wrong,
the drills are wasted; fix the map, then check nobody became unbeatable.

## Prefab check
None: the probe reuses the game's bout.

## The one trap
Typing the result page, or arms that differ only in a column nobody reads. Claude reruns on the same seeds and diffs the page
(S461/S462: two seat probes invented pages).
