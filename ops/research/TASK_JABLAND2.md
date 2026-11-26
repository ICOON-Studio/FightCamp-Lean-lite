# TASK JABLAND2 - the jab is solved; the overhand needs a lever that is not its price (S564, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches, order.html). Seat: Arena on
ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-4 hours on 2 cores (three versions, a table and two seeds each).

## Why
JABLAND1 (docs/JABLAND1_RESULT.md, S564, DONE - none): the page fails one bar, punches landing (jab 68-73%, overhand
68-82%). Version c's JAB half works on both seeds (the rear glove held high catches the jab while the lead is out; the jab
costs 0 - it lands 37-45%, thrown in 9% of beats). The overhand has no price between 2 and 3 stamina that works: at 3
without the feint it is dead (b), at 2 it is thrown from too far and falls short (c), at 2 with the feint knockdowns run
away (a). JABLAND1's next idea: keep the feint opening for it only Inside. Antigravity (ALLPLAY2,
ops/research/allplay2/antigravity/): "Step in -> Feint -> Overhand" landed 12 of 13 and ended all three stoppages; its fix:
a punch that lands on a man in his feint moment cancels the feint (+1 counter).

## Versions (tweak files on main; every anchor matches the page once - checked S564; all keep c's jab half, the overhand at 3)
- D `ops/research/s558_balance/jabland2_d.json`: the feint opens the overhand only Inside.
- E `ops/research/s558_balance/jabland2_e.json`: a punch that lands in the moment you feint catches you in it - the feint
  is wasted, his punch is a counter (+1). The overhand keeps the feint opening everywhere.
- F `ops/research/s558_balance/jabland2_f.json`: D and E together.
Each: one-rep trial `balance.mjs play n=12 tweak=<f>` on the page's table; then `balance.mjs table tweak=<f> out=<own
folder>/<v>.vt.json jobs=2`, then `play who=mix opp=mirror n=84 tweak=<f> table=<vt> seed=1 jobs=2` and `seed=2`. Outputs
`ops/research/s558_balance/results/jabland2_<d|e|f>[_s2].txt`; commit and push after each run.

## Bars
- 9 of 9 on both seeds (today 8 of 9 / 7 of 9). The landing bar passes with the jab AND the overhand thrown on at least 3%
  of beats (JABLAND1 b passed only because they went dead).
- The feint stays alive (3%+ of beats) and the "feint then overhand" pair lands under 65%: count it (the feint's next-moment
  punch, by punch: thrown, landed).
- Knockdowns 0.5-2.5 a bout, stoppages 10-40%.

## Feedback loops
- A wasted feint -> fewer openings -> fewer big landings -> fewer knockdowns -> fewer stoppages: report knockdowns and
  stoppages per version; the floor is the bar (stoppages 10%+). Cap: a feint is wasted only by a punch that LANDS in its
  own moment (blocked or short does nothing).
- A free jab -> thrown more -> E catches more feints with it (the jab is fast): report the jab's share and how many feints
  it caught. The one-rep trial comes first (n=12, each version).

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs or any test; delete no test; never commit `*.vt.json`. You may add a
counting copy of balance.mjs's bout loop under your own name for the feint-pair count. One pull request at the end; never
merge it.

## Contract
- OWNS: ops/research/s558_balance/results/jabland2_d.txt (and the same pattern for e, f, _s2),
  proto/twohands/tools/probe_feint.mjs (if you need the count), docs/JABLAND2_RESULT.md
- RED_TEST: none (a probe; JABLAND1's base is the red: jab 68-73%, overhand 68-82%)
- REGRESSION: rules_test.mjs 37 passed
- VISUAL: none

## Result
`docs/JABLAND2_RESULT.md`: the table as JABLAND1's (versions x seeds x bars x landing per punch x use), the feint pair, one
line "put on the page: <version>" (the one with 9 of 9 on both seeds and the fewest changes) or "none: <the nearest and its
miss>". End with `JABLAND2 DONE` or `JABLAND2 BLOCKED: <why>`.

## Prior research
docs/JABLAND1_RESULT.md, ops/research/allplay2/antigravity/ALLPLAY2_ANTIGRAVITY.md (section 5 item 1),
docs/RINGSWITCH_S558.md, memory project_s555_ring_switches_balance ("a weaker strike lands more").

## What would a human do?
A boxing coach answers the feint with a punch in the feint's own moment, and keeps the looping power punch for close range.

## Prefab check
Not applicable (our rules).
