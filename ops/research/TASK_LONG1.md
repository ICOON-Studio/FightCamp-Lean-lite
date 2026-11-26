# TASK LONG1 - Long is a corridor: two ideas for the lead hand at Long, measured before anything is built (S565, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches, order.html). Seat: Arena on
ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-4 hours on 2 cores (three versions, a table and two seeds each).

## Why
All five playtesters of ALLPLAY2 named it: every round opens at Long, only the two jabs reach (1 damage), so Long is "a
corridor where only 1-damage pokes reach" - the one choice is "step in now or poke first". The page today
(`ops/research/s558_balance/results/jabland_base.txt` and `_s2`): 31-34% of beats are AT Long, yet the jab is in only
7-8% of beats and the body jab in 17-18% - a third of the bout is spent where almost nothing is decided. We do not want
Long removed and we do not want a long-range bomb. We want Long to be a place the better distance man can WIN on points,
and a man who walks in carelessly can lose.

Two ideas, both about the lead hand at Long, neither a new punch or a new switch:
- Antigravity (ALLPLAY2 report): a jab that lands as he steps in should stop him.
- Dola (`ops/research/RINGSWITCH_LONG_BRIEF_DOLA.md`, design 2, "the threatened lead"): a lead hand held high at Long is a
  fence - it makes his way in dearer.

## Versions (tweak files on main; every anchor matches the page once; `node ops/research/s558_balance/long1_check.mjs`
prints `LONG1_CHECK 13 passed` - run it first, it is the proof each rule does what its note says)
- L1 `ops/research/s558_balance/long1_l1.json` THE STOPPING JAB: a jab to the head that LANDS in the very moment he steps
  in from Long stops him - the men are still at Long and he has paid for the step. A lead hand held high blocks it (so he
  can walk in behind a high lead; the body jab then lands on him and does not stop him).
- L2 `ops/research/s558_balance/long1_l2.json` THE FENCE: at Long a lead hand kept home and held high all beat makes his
  step in cost 1 stamina more (2 in all; never below 0). A lead that jabs, feints or is held low is no fence.
- L3 `ops/research/s558_balance/long1_l3.json`: both. The lead hand has two jobs at Long and does one a beat.
- L0 = the page today, no tweak: the control, run by the same count tool on the same seeds (never quote the old numbers
  for it).

Each version, in this order:
1. One-rep trial: `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=12 tweak=<f> seed=1 jobs=2` on the
   page's own table. If Long takes over 60% of beats or the stoppages fall under 5% on the trial, STOP that version,
   write why, go to the next.
2. `node proto/twohands/tools/balance.mjs table tweak=<f> out=<your own folder>/<v>.vt.json jobs=2`
3. `play who=mix opp=mirror n=84 tweak=<f> table=<vt> seed=1 jobs=2`, then `seed=2`.
4. The Long count (below) on the same table, seed 1 and seed 2.
Outputs `ops/research/s558_balance/results/long1_<l0|l1|l2|l3>[_s2].txt` and `long1_<v>_count[_s2].txt`; commit and push
after each run.

## The Long count (the page's bars cannot see the problem: add this)
A counting COPY of balance.mjs's bout loop under your own name, `proto/twohands/tools/probe_long.mjs` (same args: tweak=,
table=, n=, seed=). Per version it prints, for the beats that START at Long:
- how many beats a bout start at Long, and the share of them where NOTHING is thrown by either man;
- points scored and health taken a bout by punches that land while the men are at Long (by punch);
- the step in from Long: tried a bout, got in, stopped by the jab (L1), paid the fence tax (L2);
- the lead hand at Long, share of those beats: jab, body jab, feint, held high, held low;
- rounds won 10-9 by the man who scored more AT Long than his opponent did in the whole round (the outfighter's round);
- how many beats the first step in of a round comes after (today: count it - the "walk through" in a number).

## Bars
- The page's nine bars: 8 or 9 of 9 on BOTH seeds, and never fewer than L0 on the same seed. The punches-landing bar may
  still fail on the overhand (JABLAND2 is fixing that apart) but the JAB must not land more than it does in L0.
- Long is fought at, not walked through: the jab in 12%+ of all beats (L0: 7-8%), the share of Long beats with nothing
  thrown DOWN against L0, points scored at Long a bout UP by at least half against L0.
- Long does not swallow the bout: Long at most 45% of beats, Inside at least 20%; stoppages 10-40%; knockdowns 0.5-2.5.
- The man walking in still gets in: of the steps in from Long, at least 60% get in (L1), and "step in" stays in 20%+ of
  beats; nobody is a must (no switch over 40%).
- No lazy plan: `who=sensible` and `who=random` against the mirror do not win more than they do in L0 (run each n=42,
  seed 1, on the version's table) - "jab every beat at Long" must not be a plan that wins by itself.

## Feedback loops
- A stopped step -> more beats at Long -> more jabs thrown at Long -> more stopped steps: the loop that could turn the
  bout into three rounds of jabs. Its caps: only the head jab stops, a high lead blocks it, the stop is only in the very
  moment of the step. The bar is Long at most 45% of beats; the one-rep trial's stop rule (over 60%) comes first.
- The fence -> he is poorer when he arrives at Mid -> he throws less there -> the fence holder wins Mid too -> everyone
  fences: report stamina on arrival at Mid (mean, by who stepped) and "lead held high" as a share of all beats (a must at
  over 40% fails the page's own bar). Cap: the fence holder's lead hand throws nothing that beat, so he scores nothing
  at Long while he fences.
- Fewer beats Inside -> fewer big punches -> fewer knockdowns and stoppages: report both per version; the floor is the
  bar (stoppages 10%+, Inside 20%+).
- The one-rep trial (n=12, each version) is run before any table.

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs or any test; delete no test; never commit `*.vt.json`. No new punch, no
new switch, no change to a number in N or ACT (a version that needs one is a finding to write down, not to try). One
pull request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/results/long1_l0.txt (and the same pattern for l1, l2, l3, _s2, _count),
  proto/twohands/tools/probe_long.mjs, docs/LONG1_RESULT.md
- RED_TEST: none (a probe; L0's Long count is the red: a third of the beats at Long, the jab in 7-8% of beats)
- REGRESSION: rules_test.mjs 37 passed; ops/research/s558_balance/long1_check.mjs 13 passed
- VISUAL: none (no page change, no picture)

## Result
`docs/LONG1_RESULT.md`: one table, versions L0-L3 x seeds: bars passed, Inside / Mid / Long share, jab and body jab use,
jab landing, the Long count's lines, stoppages, knockdowns, the lazy plans. Then in plain words, at most ten lines: what
a man does at Long in each version and whether the careful outfighter now wins rounds there. One line "put on the page:
<version>" (holds every bar on both seeds, the fewest changes) or "none: <the nearest and its miss>". If none: the ONE
change you would try next, as a tweak pair (anchor text, replacement). End with `LONG1 DONE` or `LONG1 BLOCKED: <why>`.

## Prior research
ops/research/RINGSWITCH_LONG_BRIEF.md (the problem as the testers said it) and RINGSWITCH_LONG_BRIEF_DOLA.md (three
designs; this probe takes her second; her first, the half step, needs a new foot switch and waits);
ops/research/allplay2/antigravity/ALLPLAY2_ANTIGRAVITY.md; docs/JABLAND1_RESULT.md (the jab lands 68-73% today: "a weaker
strike lands MORE"); docs/RINGSWITCH_S558.md; ops/research/topics/footwork.md. In order.html `N.keep` (off since S554: a
landed jab forbade his step in NEXT beat) is the nearest rule we tried - L1 differs: it acts in the same moment and only
from Long. Verdict followed: the slice is balanced on the instrument, never by hand (owner S555).

## What would a human do?
A boxing coach teaches the outfighter two things with the lead hand at range: the stop jab that meets a man as he comes,
and the long guard that makes him go round it. He teaches the pressure fighter to come in behind a high glove or to make
the jab miss first. A designer then counts whether both men still have a reason to pick each.

## Prefab check
Not applicable (our rules).
