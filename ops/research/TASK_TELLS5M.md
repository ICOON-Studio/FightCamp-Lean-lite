# TASK TELLS5M - the tells: catching his fake pays, and the Jabber's blind cover costs (S567, measure loop, LAST round)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Puncher's chance, order.html).
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-4 hours.

## Why
TELLS4M (`docs/TELLS4M_RESULT.md`, read it first; brief `ops/research/TASK_TELLS4M.md`): version 4 passes 4 of 7 bars, the
same count as version 3, but the bar that matters moved: obeying every cue blind is worth +5.9 / +5.3 / +9.4 points over
the no-tell control (was +8 / +10 / +29; bar +5) and still takes less health against all three men. Two things are left:
- CATCHING THE LIE PAYS NOTHING: the fixed reader bot (BOT 2, `fix=1`) is right on 60-79% of its doubts, and its reward is
  one extra jab on 36-48% of them. 0 of 3 men.
- THE JABBER'S BLIND COVER COSTS NOTHING: his hidden 3 is the lead uppercut Inside, and he is rarely Inside (2 of 279 fakes).
This is the FOURTH tells round (v2, v3, v4). It is the last: after it the tell goes to the owner as it stands, keep or cut.

## What to measure, in this order (one run at a time; commit and push after each)
Version 5 in `tells.mjs` = a NEW branch beside 2, 3 and 4 (`tells.mjs` and `play_cli.mjs` are imported live by running
playtests: every old call keeps its output). It is version 4, plus:
1. V5a - CAUGHT LOADING: a punch that lands on him in a beat where his cue was a fake does +1 damage. Nothing else changes.
   n=12 seed=1 trial for BOT 0 / 1 / 2 (fixed) v the three men + the mirror; if no pair is over 60% stoppages, n=84 seed=2.
2. V5b - V5a, plus the Jabber's shoulder fake may hide his LEAD HOOK TO THE BODY (3 damage or under; if the page's body
   hook is over 3, use the biggest body-side punch of 3 or under and say which) at the ranges it reaches. Same two runs.
3. Stop there. Say which of V4 / V5a / V5b is the one to show the owner, and whether it is ready for the page.

## The bars (all against the same-seed BOT 0 control; V4's numbers from TELLS4M beside each)
- BOT 1 <= BOT 0 + 5 points, each man (V4: +5.9 / +5.3 / +9.4).
- BOT 1 takes less health than BOT 0 for at least 2 of 3 men (V4: 3 of 3).
- BOT 2 (fixed) >= BOT 1 + 5 points OR takes >= 1.5 less health, at least 2 of 3 men (V4: 0 of 3; the bar is lowered from
  +10 / 2.0 on purpose: a read should pay a little, not decide the bout).
- His fakes on 15-30% of beats. The real beat behind a fake never more than 3 damage, never two punches (count: 100%).
- Stoppages 10-40% (the Jabber pairs reported beside their control). BOT 0 v the mirror 40-60%.
- NEW: knockdowns a bout within 0.3 of the same-seed V4 number for every pair (the +1 must not turn into a knockdown rule).

## Feedback loops
- +1 on a punch into a fake -> punching into every shoulder cue pays -> the bot (and the player) attacks every cue -> he is
  hit more -> he is hurt and fakes on his low-state condition more -> more +1s. Caps: his 2 fakes a round and never two beats
  running (so at most 2 bonus points a round); the knockdown bar above; report the +1s landed per bout for each pair. A
  version where BOT 2 beats BOT 1 by MORE than 15 points against any man has gone too far: report it as failed.
- The Jabber hiding a body hook -> blind high cover is punished -> the bot stops covering the Jabber's cue -> the tell is
  ignored against him: the floor is "BOT 1 takes less health than BOT 0" - if that fails against the Jabber, V5b failed.
- One-rep trial first: n=12 before any n=84.

## Not allowed
No page, no `rules.mjs` / `balance.mjs` / `play_cli.mjs` edit, no test deleted or loosened. `probe_tells.mjs`, `tells.mjs`
and `probe_tells_test.mjs` may be extended (v=2, v=3 and v=4 output unchanged: prove it by the test and by one v=4 pair run
again, byte for byte). ONE pull request at the end; never merge it.

## Contract
- OWNS: proto/twohands/tools/probe_tells.mjs, proto/twohands/tools/tells.mjs, proto/twohands/tools/probe_tells_test.mjs,
  ops/research/allplay2/tells5m_*.txt, docs/TELLS5M_RESULT.md
- RED_TEST: TELLS4M at n=84: BOT 2 fixed behind or level with BOT 1 for every man; BOT 1 +5.9 over the control v the Jabber
- REGRESSION: probe_tells_test.mjs 8, rules_test.mjs 37, page_play_test.mjs 4
- VISUAL: none

## Result
`docs/TELLS5M_RESULT.md`: the TELLS4M table for V5a and V5b, the bars with their numbers, the +1s landed per bout, then
three plain lines: which version to show, what the player would see, what is still wrong. End with `TELLS5M DONE` or
`TELLS5M BLOCKED: <why>`.

## Prior research
docs/TELLS4M_RESULT.md, docs/TELLS3M_RESULT.md, ops/research/DESIGN_TELLS2.md, memory S563 / S564 / S566 (5 of 5 testers:
one body tell, never his plan; bars against the control).

## What would a human do?
A boxer who reads a feint steps in and hits the man while his weight is still loading: the read pays at once, a little.

## Prefab check
Not applicable (our rules).
