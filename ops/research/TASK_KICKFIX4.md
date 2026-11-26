# TASK KICKFIX4 - E3 plus the three fixes KICKFIX3 named, measured (S566, measure loop)

Kind: probe. Model: Arena (cloud). Discipline: kickboxing (owner S559 "Yes, kickboxer first").
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-5 hours of balance runs.

## Why
KICKFIX3 (`docs/KICKFIX3_RESULT.md`, read it first): E3 holds 5 of 9 bars at N=56 and is the base. The limp loop is capped
(3 of 28 stoppages after a limp). Four bars are red and the result names a cause for each: the low kick lands 87% (bar
65%) because a check costs the kicker only 1 health; knockdowns 3.1 and stoppages 50% (bars 2.5 / 40%) and the overhand
lands 73% because every rear-leg kick, the low kick too, drops the rear hand; two-hand plans 8% (bar 15%).

## What to measure, in this order (one run at a time; commit and push after each; base = kick_fix_e3.json)
- F1: E3 + `N.checkHurt` 1 -> 2 (a checked low kick costs the kicker 2 health).
- F2: E3 + the low kick no longer drops the rear hand (`rearLeg` off `low` only; body and head kick keep it).
- F3: E3 + both.
- F4, ONLY if F3 still has the low kick landing over 65%: F3 + a teep also covers the lead leg in its moment.
1. N=12 trial for F1, F2, F3. A version survives when no switch is over 40%, no kick lands over 90% and under half of its
   stoppages follow a limp.
2. N=56 for each survivor, on TWO seeds (seed=1 and seed=2).
3. Stop there. If nothing reaches 8 of 9 on both seeds: which bar killed each, and what you would try next (do not run it).
Bars: the nine of `balance.mjs` (`table tweak=<f> out=<vt> iters=300 jobs=<cores>`, then `play who=mix opp=mirror n=<N>
tweak=<f> table=<vt>`). THE PLAN-MIX BAR: report it both ways - as balance.mjs counts it (hand punches only) and counting a
kick as a strike (lead + rear + kick); do not edit balance.mjs, count the second from the play json. Out folder
`tmp_kick/`; commit each result as `ops/research/s558_balance/results/<name>.txt`; never commit `*.vt.json`.

## Feedback loops
- The limp: low kicks -> limp -> no back off -> more low kicks. Capped by the reflex check of E3; report limp bouts and
  stoppages after a limp for every run; stop a version whose share passes half.
- checkHurt 2 -> fewer low kicks -> more holding at range -> fewer strikes at all: report strikes thrown a beat for each
  version beside those of E3; a version under 80% of that volume is reported as "too passive", not as a pass.
- Stamina: body kicks shorten his bar -> he throws less -> more kicks. Cap `N.capMin` 4. Report the bar at the last bell.
- One-rep trial first: N=12 before any N=56.

## Not allowed
Change no page, no tool and no test (tweak files only; `src` pairs are exact text of kick.html, no trailing newline). If a
tweak changes a tested rule, say which test and why, and do not edit it. ONE pull request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/kick_fix_f1.json, ops/research/s558_balance/kick_fix_f2.json,
  ops/research/s558_balance/kick_fix_f3.json, ops/research/s558_balance/kick_fix_f4.json,
  ops/research/s558_balance/results/kick_fix_f*.txt, docs/KICKFIX4_RESULT.md
- RED_TEST: E3 at N=56: 5 of 9 (low kick 87%, knockdowns 3.1, stoppages 50%, two-hand plans 8%)
- REGRESSION: kick_test.mjs 12 passed, page_parse ok (the page is not edited)
- VISUAL: none

## Result
`docs/KICKFIX4_RESULT.md`: one table - version | N | seed | bars passed | each red bar with its number | low kick lands |
overhand lands | knockdowns | stoppages | plan mix both ways | strikes a beat - then which version should go on kick.html
and what it changes for the player, in three plain lines. End with `KICKFIX4 DONE` or `KICKFIX4 BLOCKED: <why>`.

## Prior research
docs/KICKFIX3_RESULT.md, docs/KICKFIX2_RESULT.md, docs/RINGSWITCH_S558.md (the bars), ops/research/topics/kicks_legs.md.

## What would a human do?
Make the checked kick hurt the way a shin on a shin does, and let the cheapest kick keep the guard up: a thigh kick is
thrown with the rear glove by the chin.

## Prefab check
Not applicable (our rules).
