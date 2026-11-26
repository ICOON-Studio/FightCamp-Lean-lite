# TASK LONG2 - Long is a corridor: Kalli's pick, the cross he walks onto and the jab that meets him (S565, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches, order.html). Seat: Arena on
ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-4 hours on 2 cores (three versions, a table and two seeds each).
Sister of TASK_LONG1.md (running in another chat on its own branch: the stopping jab and the fence). Do not wait for it
and do not copy from it; the two are compared afterwards.

## Why
All five playtesters of ALLPLAY2: Long is "a corridor where only 1-damage pokes reach", the rear hand has nothing to do
there, the one choice is "step in now or poke first". Today's page (`ops/research/s558_balance/results/jabland_base.txt`
and `_s2`): 31-34% of beats are at Long, the jab is in 7-8% of beats.

Kalli (`ops/research/RINGSWITCH_LONG_BRIEF_KALLI.md`, design 1, her pick): THE WAITING CROSS - a cross thrown at Long
lands only on a man who steps in during its moment, as a counter; and a jab or body jab that lands on a man stepping in
from Long scores 2 points.

A FINDING FIRST (S565, `long2_check.mjs` lines 1-3): half of her rule is already on the page. A beat's step is played
before the punches of its moment, so a cross thrown at Long already lands on a man who steps in during that very moment
(3 health, 2 points; a high lead blocks it), and a cross at a man who did not come already falls short and hands him
counters. No tester found it, and nobody has counted how often the solver uses it. So this probe COUNTS it on today's
page (K0), then measures her two bonuses.

## Versions (tweak files on main; every anchor matches the page once; `node ops/research/s558_balance/long2_check.mjs`
prints `LONG2_CHECK 15 passed` - run it first)
- K0 = the page today, no tweak: the control, with the Long count.
- K1 `ops/research/s558_balance/long2_k1.json`: the cross he walks onto is a counter (+1: 4 health), AND a jab or body
  jab that lands in the moment he steps in from Long scores 2 points.
- K2 `ops/research/s558_balance/long2_k2.json`: the cross half only.
- K3 `ops/research/s558_balance/long2_k3.json`: the jab half only.
Kalli's cap "not two beats running" is NOT in these files: measure first whether the lazy plan appears at all (below).

Each version, in this order:
1. One-rep trial: `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=12 tweak=<f> seed=1 jobs=2` on the
   page's own table. If Long takes over 60% of beats or the stoppages leave 5-50% on the trial, STOP that version, write
   why, go to the next.
2. `node proto/twohands/tools/balance.mjs table tweak=<f> out=<your own folder>/<v>.vt.json jobs=2`
3. `play who=mix opp=mirror n=84 tweak=<f> table=<vt> seed=1 jobs=2`, then `seed=2`.
4. The Long count (below) on the same table, seed 1 and seed 2.
Outputs `ops/research/s558_balance/results/long2_<k0|k1|k2|k3>[_s2].txt` and `long2_<v>_count[_s2].txt`; commit and push
after each run.

## The Long count
A counting COPY of balance.mjs's bout loop under your own name, `proto/twohands/tools/probe_long2.mjs` (same args:
tweak=, table=, n=, seed=). Per version, for the beats that START at Long:
- how many beats a bout start at Long, and the share of them where nothing is thrown by either man;
- THE CROSS AT LONG: thrown a bout from Long (cross and body cross apart); landed on a man stepping in that moment;
  blocked by his high lead; fell short because he did not come; and the counters he then landed off that miss;
- the jabs at Long: thrown, landed, landed on a stepping man (the 2-point ones in K1 / K3);
- the step in from Long: tried a bout, with the lead held high or low, got in clean, got in hit (by what);
- points and health taken a bout by punches thrown from Long, by punch;
- rounds won 10-9 by the man who scored more from Long than his opponent did in the whole round;
- the lazy plans: the share of Long beats where the same man throws a cross from Long two beats running, and how those
  second crosses fare.

## Bars
- The page's nine bars: 8 or 9 of 9 on BOTH seeds, never fewer than K0 on the same seed.
- The rear hand has a job at Long: a cross thrown from Long in 5-15% of the beats that start at Long, landing 30-65% of
  the time (K0: count it).
- Long is fought at: the share of Long beats with nothing thrown DOWN against K0; points scored from Long a bout UP by
  at least half against K0; the jab in 10%+ of all beats.
- Long does not swallow the bout: Long at most 45% of beats, Inside at least 20%; stoppages 10-40%; knockdowns 0.5-2.5
  (a 4-health cross feeds knockdowns: this is the bar most at risk).
- The man walking in still gets in: of the steps in from Long at least 60% get in unhit, "step in" stays in 20%+ of
  beats, and "lead held high" does not become a must (over 40% of beats).
- No lazy plan: `who=sensible` and `who=random` against the mirror win no more than in K0 (n=42, seed 1, the version's
  table); a second cross running from Long lands under 40%.

## Feedback loops
- The cross he walks onto -> he steps in only behind a high lead -> the body jab lands under it (2 points in K1 / K3)
  -> he stops stepping in -> more beats at Long -> more waiting crosses that fall short. Where it settles is the
  measure: report "step in" by lead height and the cross's short share. Caps already on the page: a cross that falls
  short costs 2 stamina and hands him counters; a high lead blocks it.
- 4 health on a 3-health punch -> more knockdowns -> more stoppages -> shorter bouts -> fewer beats at Long: report
  knockdowns and stoppages per version (bar 0.5-2.5 and 10-40%). If K1 breaks it and K3 does not, K3 is the answer.
- 2-point jabs -> rounds are won by jabs -> nobody steps in -> draws on ground rise: report rounds level on points and
  draws (bar: draws at most 20%).
- The one-rep trial (n=12, each version) is run before any table.

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs or any test; delete no test; never commit `*.vt.json`. No new punch, no
new switch, no change to a number in N or ACT. One pull request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/results/long2_k0.txt (and the same pattern for k1, k2, k3, _s2, _count),
  proto/twohands/tools/probe_long2.mjs, docs/LONG2_RESULT.md
- RED_TEST: none (a probe; K0's Long count is the red)
- REGRESSION: rules_test.mjs 37 passed; ops/research/s558_balance/long2_check.mjs 15 passed
- VISUAL: none (no page change, no picture)

## Result
`docs/LONG2_RESULT.md`: one table, versions K0-K3 x seeds: bars passed, Inside / Mid / Long share, jab and cross use, the
Long count's lines, stoppages, knockdowns, the lazy plans. Then at most ten plain lines: how often the page ALREADY
catches a man stepping in with a cross (K0), what each bonus changes, whether the rear hand now has a job at Long. One
line "put on the page: <version>" (holds every bar on both seeds, the fewest changes) or "none: <the nearest and its
miss>". If none: the ONE change you would try next as a tweak pair. End with `LONG2 DONE` or `LONG2 BLOCKED: <why>`.

## Prior research
ops/research/RINGSWITCH_LONG_BRIEF.md (the problem), RINGSWITCH_LONG_BRIEF_KALLI.md (this design; her second, the
circle, needs a new foot switch and waits), RINGSWITCH_LONG_BRIEF_DOLA.md, TASK_LONG1.md (the sister probe);
docs/JABLAND1_RESULT.md ("a weaker strike lands MORE"); docs/RINGSWITCH_S558.md (the nine bars);
ops/research/topics/striking.md, topics/footwork.md. Verdict followed: the slice is balanced on the instrument, never by
hand (owner S555).

## What would a human do?
A boxing coach tells the outfighter to keep the right hand loaded for the man who walks in straight, and tells the
pressure fighter never to walk in straight: come behind a high glove, behind a feint, or after the right hand has been
thrown. A designer first counts whether the game already does this before adding a rule for it.

## Prefab check
Not applicable (our rules).
