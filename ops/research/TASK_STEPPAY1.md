# TASK STEPPAY1 - phase 1 of the steps payoff scope: what is each place in the ring worth today? (measure, no game change)

Kind: probe
Status: DONE (S533, PR #430 collected: no place is an edge, see docs/STEPPAY1_RESULT.md). Discipline: boxing. Model: Grok Dev (after TIPFIX1). Branch `grok/steppay1`, a PR; never merge.

## Why
`ops/research/STEPS_PAYOFF_SCOPE_S533.md` (read it) and `docs/TREEVALUE9_RESULT.md` (S533 TREEVALUE11-13): the footwork step
"cut off the ring" never pays, even with its effects x5, because the place it takes you to is not an edge by itself. Before
anything changes in the game we need the numbers for every place.

## Build (tools only - nothing under scripts/ changes)
1. `tools/place_value_probe.gd` (headless, under 300 lines): for each of the 8 places (PlanLines.PLACES: outside, long, mid,
   inside, clinch, own_ropes, opp_ropes, corner), force the exchange to START at that place (set lv["at"] the way
   LiveRound.gd ~L234-238 reads it, through the same calls the game uses - trace RingDuel.settle / LiveRound.exchange, do not
   reimplement the round) and record over 400 exchanges x 3 seed sets x the 6 styles (StepValue.STYLES) as the opponent:
   exchange win share for your boxer, landed both ways, which line fired, and whether a range move (step_out / step_back /
   pivot_out) was even available to the opponent there. Two fighters who differ (never identical: different stats, styles);
   name the population in the output. A CONTROL arm: the same seeds with `at` left to the game - must reproduce the game's
   own share. A determinism check: the same seed twice gives the same numbers.
2. `docs/STEPPAY1_RESULT.md`: the 8 x 6 table of win shares (with each cell's seed spread), and a second table from the CODE:
   for each place, every rule that reads it (file + function + line), so we can see which places matter and why.

## Rules
- Do not edit anything under scripts/. If a place cannot be forced without a game change, say exactly why in the result.
- Bound values, never an exact count. A green control must be able to read worse (show it would catch a broken arm).

## Deliverable
The probe + the result doc in one PR. PR body: `RESULT: tools/place_value_probe.gd -> PLACE_VALUE done control=<ok> determinism=<ok>`.

## Contract
OWNS: tools/place_value_probe.gd, docs/STEPPAY1_RESULT.md
RED_TEST: tools/place_value_probe.gd
REGRESSION: none (no game change)
VISUAL: no

## Prior research
TREEVALUE2-13 (docs/TREEVALUE9_RESULT.md), STEPVALUE1 maps, Q-S294-231 (three in a round = on the ropes).
## What would a human do?
A coach counts how often his boxer wins the exchange when the other man is on the ropes, before he teaches cutting the ring.
## Prefab check
None.
