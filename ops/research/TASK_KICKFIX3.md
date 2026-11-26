# TASK KICKFIX3 - E2 and E3 measured, the limp loop capped where it fires (S563, measure loop)

Kind: probe. Model: Arena (cloud). Discipline: kickboxing (owner S559 "Yes, kickboxer first").
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite. Estimate: 2-3 hours of balance runs.

## Why
KICKFIX2 (`docs/KICKFIX2_RESULT.md`, read it first) stopped after E1's N=12 trial, as its brief asked: E1 passed 4 of 9
bars, its low kick landed 93% (71 of 76) and 5 of 9 stoppages had a limp by the stopping beat - the loop "low kicks -> limp
-> no back off -> more low kicks land" ran uncapped. E1 is dead. E2 and E3 are PREPARED
(`ops/research/s558_balance/kick_fix_e2.json`, `kick_fix_e3.json`) and never measured. E2 is the one built against that
loop: a man who holds or backs off checks by reflex, so only a man stepping in or kicking has his lead leg planted. S563
read: E1 lacked the reflex check, so its limp alarm says nothing yet about E2.

## What to measure, in this order (one run at a time; commit and push after each)
1. E2 at N=12, then E3 at N=12, exactly as prepared. Count the limp as KICKFIX2 did (bouts reaching a limp, how they end,
   the share of stoppages with a limp by the stopping beat).
2. ONLY for a version whose limp alarm fires (over half of its stoppages after a limp): the same version with the limp
   capped, `N.limp` 4 -> 6 (kick.html's header: 8-12 clean thigh kicks to a limp in a K-1 fight; 4 was that scaled to 18
   beats, so 6 is still inside the real range). Name it `kick_fix_e2c.json` / `kick_fix_e3c.json`, N=12.
3. N=56 for every version that survived its N=12 trial (no switch over 40%, no kick landing over 90%, the limp alarm
   quiet).
4. Stop there. If nothing survives, say which bar killed each version and what you would try next (do not run it).
Bars: the nine of `balance.mjs` (call `balance.mjs table tweak=<f> out=<vt> iters=300 jobs=<your cores>` then
`balance.mjs play who=mix opp=mirror n=<N> tweak=<f> table=<vt>`). Out folder `tmp_kick/` in the clone; DO commit each
result as `ops/research/s558_balance/results/<name>.txt`; never commit `*.vt.json`.

## Feedback loops
- The limp: low kicks -> limp -> no back off -> more low kicks. E2's reflex check is the first cap (a limping man who holds
  checks); `N.limp` 6 is the second, used only where the first does not hold. Stop and report if over half of all
  stoppages follow a limp in a capped version too.
- Stamina: a body kick shortens his stamina bar -> he throws less -> more kicks. Cap in the rules: `N.capMin` 4. Report
  the average stamina bar at the last bell.
- One-rep trial first: N=12 for each version before any N=56.

## Not allowed
Change no page and no test (tweak files only; `src` pairs are exact text of kick.html, no trailing newline). If a tweak
changes a tested rule, say which test and why, and do not edit it. Open ONE pull request at the end with
docs/KICKFIX3_RESULT.md; never merge it.

## Contract
- OWNS: ops/research/s558_balance/kick_fix_e2c.json, ops/research/s558_balance/kick_fix_e3c.json,
  ops/research/s558_balance/results/kick_fix_e2_n12.txt, ops/research/s558_balance/results/kick_fix_e3_n12.txt,
  ops/research/s558_balance/results/kick_fix_e2c_n12.txt, ops/research/s558_balance/results/kick_fix_e3c_n12.txt,
  ops/research/s558_balance/results/kick_fix_e2_n56.txt, ops/research/s558_balance/results/kick_fix_e3_n56.txt,
  docs/KICKFIX3_RESULT.md
- RED_TEST: B's bars (6 of 9: dead kicks, low kick 70%, 2.7 knockdowns); E1 4 of 9
- REGRESSION: kick_test.mjs 12 passed, page_parse ok (the page is not edited)
- VISUAL: none

## Result
`docs/KICKFIX3_RESULT.md`: one table - version | N | bars passed | each red bar with its number | low kick lands | body /
head kick used and lands | limp bouts and stoppages after a limp | knockdowns | stoppages - then which version should go
on kick.html and what it changes for the player, in three plain lines. End with `KICKFIX3 DONE` or `KICKFIX3 BLOCKED: <why>`.

## Prior research
docs/KICKFIX2_RESULT.md, ops/research/TASK_KICKFIX2.md (the versions and why), docs/RINGSWITCH_S558.md (the bars),
ops/research/topics/kicks_legs.md.

## What would a human do?
A designer caps a spiral where it starts (the man who holds checks), and only then by the number (more kicks to a limp).

## Prefab check
Not applicable (our rules).
