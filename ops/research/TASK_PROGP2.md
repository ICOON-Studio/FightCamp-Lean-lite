# TASK PROGP2 - the Sharp choice measured: "cheaper" or "faster", for each punch (S563, probe P2 of DESIGN_PROGRESSION1)

Kind: probe. Model: Arena (cloud). Discipline: boxing (order.html). Seat: Arena on ICOON-Studio/FightCamp-Lean-lite.
Estimate: 2-3 hours of balance runs.

## Why
Owner S561, Q-340 (at Sharp, pick one of two upgrades for each move): "Yes, a choice". DESIGN_PROGRESSION1 3b: at Sharp
(mastery 60) the player picks ONE upgrade for that move, for that fighter, for good: "cheaper" (1 stamina less, min 1) or
"faster" (one speed step: slow -> medium -> fast). Before any screen or critic, the balance tool must say whether the
choice is a real one: an upgrade that is useless is a dead card, an upgrade that is always right is a clog (not a choice).

## What to build (new files only: proto/twohands/tools/probe_sharp.mjs + probe_sharp_test.mjs)
Follow `proto/twohands/tools/probe_attributes.mjs` (on main since S563: it loads the page's rules through `rules.mjs`
with a text patch, so `order.html` is never edited, and plays the solved mix A v B). Here the patch gives each man his
own copy of the punch table, so man A's Cross can cost 1 while man B's costs 2: every place the rules read a punch's
stamina or speed for a man must read HIS table (cost of a plan, who lands first in a moment). Name each replaced text in
the probe; throw if a text is not found on the page (as probe_attributes does).
For each punch in ACT with a cost or a speed to give (jab, bjab, hook, lup, lbody, cross, over, rup, rbody):
- A = the same man with that ONE punch upgraded, B = today's man. Two runs a punch: A cheaper v B, A faster v B.
- An upgrade that does nothing (the jab already costs 1 and is already fast) is NOT run: list it as "no upgrade possible -
  needs its own pair" (the design already says some moves get a different pair).
- One-rep trial first: n=24 for the Cross both ways; if either is over 75%, stop and report (the upgrade is far too big).
- Then n=84 a run (balance.mjs `play who=mix opp=mirror`-style, both men draw from solveBeat, iters=400, jobs=your cores).

## Bars (DESIGN_PROGRESSION1 5.3 and 6)
- Each upgrade: A wins 52-58% of decided bouts. Under 52 = a dead card. Over 58 = too strong for one level.
- The CHOICE: for each punch, cheaper and faster within 6 points of each other (if one beats the other by more, the
  player always takes it: a clog, not a choice). Say for each punch which upgrade the mix used more, and how its use of
  that punch changed (share of beats, A v B).
- Stoppages 10-40% in every pair.

## Feedback loops
- Upgrade -> more use of that punch -> more wins -> (in the game) more mastery: capped in the game by the per-bout mastery
  cap and the technique ceiling; here, report how much more A throws the upgraded punch (a punch thrown 2x as often is a
  sign the upgrade bends the whole fight).
- Cheaper -> more stamina -> more punches each beat: capped by the stamina bar (8) and the cost floor (min 1).
- One-rep trial first (above); stop if it trips.
- The look-ahead table vtable.json was built for equal men: say so in the result (as PROGP3 did); it reads both men's
  punches at today's numbers.

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs or any existing test; delete no test. Commit and push every result txt
as it finishes (`ops/research/s558_balance/results/sharp_<punch>_<cheaper|faster>.txt`); never commit `*.vt.json`. One
pull request at the end; never merge it.

## Contract
- OWNS: proto/twohands/tools/probe_sharp.mjs, proto/twohands/tools/probe_sharp_test.mjs,
  ops/research/s558_balance/results/sharp_cross_cheaper.txt (and one txt per run, same pattern), docs/PROGP2_RESULT.md
- RED_TEST: proto/twohands/tools/probe_sharp_test.mjs (red first: module not found; then: equal tables replay a
  balance.mjs mirror bout for bout with the same seed; a man whose Cross costs 1 pays 1 for it in cost(); a man whose
  Cross is fast lands it before a medium punch in the same moment)
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed, probe_attributes_test.mjs 5 passed
- VISUAL: none

## Result
`docs/PROGP2_RESULT.md`: one table - punch | cheaper: A wins % | faster: A wins % | gap | which the mix threw more |
stoppages - then the punches whose pair works, the dead or clogging ones, and for each of those a different pair to try
(one line each, not measured). End with `PROGP2 DONE` or `PROGP2 BLOCKED: <why>`.

## Prior research
ops/research/DESIGN_PROGRESSION1.md (3b, 5, 6), docs/PROGP3_RESULT.md (how the per-man patch was done and its limits),
docs/RINGSWITCH_S558.md (the bars).

## What would a human do?
A card designer prints both upgrade cards for every move and plays each against the plain card until neither card is
always the pick and neither is never the pick.

## Prefab check
Not applicable (our rules).
