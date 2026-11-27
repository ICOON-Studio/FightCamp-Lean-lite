# COUNTERS1 - the two counters the famous exchanges are missing (S568)

Owner S568: "measure the two ideas for marquez and mayweather". Measured on today's page (order.html untouched, the feint rules
untouched); every rule lives in a tweak's `src` patches. Console worker, main checkout.

## Verdict
**No version passes all its bars. None goes on the page.** The check hook (H2) is the near one; the timed counter (M, M2)
makes waiting at Long a habit.

**For the owner:** none goes on the page yet. Closest is the check hook: you back off and throw the lead hook while he steps
in, and the story says "a check hook: off the pull as he cuts you off, +1". But it lands nearly every time it fires (98-100%),
and on seed 1 it costs a bar. The timed counter ("Wait, then the right hand") gets picked in one beat in six and misses two
times in three when he does not come in.

## The versions (tweaks in ops/research/s558_balance/)
- **M** (counters1_m.json), the timed counter. A plan with exactly ONE hand punch (a punch that does damage, so no feint or
  push) and no feet may put a Wait before it, so the punch goes in moment 2. There are 18 new plans (532 instead of 514), and
  plansFor gives them to both men and the look-ahead. When the other man stepped in during moment 1 of this beat, the punch is
  a timed counter: +1 health, and **his held hand does not cover it**. Otherwise the wait only costs the moment.
  *Why the cover rule was added (step 2):* M as first written (+1 only; scratch file wt_tmp/COUNTERS1/counters1_m0.json) did
  not flip the exchange. Marquez's overhand travels on the side line, and Pacquiao's rear hand held high blocks that line
  whatever the timing (scene_check: "blocked by Pacquiao's rear hand, held high"). Timing alone cannot land a right over a
  jab in our cover table. The man walking onto it is the one thing the moment adds.
- **M2** (counters1_m2.json), the ONE follow-up after M's trial stopped it: M, plus the Wait costs 1 stamina (sitting on a
  punch is a loaded stance, not a rest). Nothing else changed.
- **H1** (counters1_h1.json): a lead hook thrown after your own back off in the same beat keeps its pull +1 when his step in
  cuts you off. **It does not flip the exchange**: Hatton's held rear hand still blocks the hook. So no table was built for it
  (step 2: fix the rule first). H2 is that fix.
- **H2** (counters1_h2.json): H1, and that check hook is not blocked by his held rear hand (he turns into the angle).
- **MH** (counters1_mh.json): M plus H2. It was written and scene-checked (12 of 14), but **not measured**: the brief asks for
  it only when each part passes alone, and neither does.

## scene_check (full text: results/counters1_scenes.txt)
| version | checks | Marquez's overhand lands | Pacquiao goes down | Mayweather's hook lands | Hatton's hook does not land | Hatton goes down | any other check turned MISMATCH |
|---|---|---|---|---|---|---|---|
| today | 10 of 14 | MISMATCH | MISMATCH | MISMATCH | MATCH | MISMATCH | - |
| M0 (scratch) | 10 of 14 | MISMATCH (blocked) | MISMATCH | MISMATCH | MATCH | MISMATCH | none |
| M, M2 | 11 of 14 | **MATCH** (-5, a timed counter) | MISMATCH (7 -> 2) | MISMATCH | MATCH | MISMATCH | none |
| H1 | 10 of 14 | MISMATCH | MISMATCH | MISMATCH (blocked) | MATCH | MISMATCH | none |
| H2 | 11 of 14 | MISMATCH | MISMATCH | **MATCH** (-4, the check hook) | MATCH | MISMATCH (5 -> 1) | none |
| MH | 12 of 14 | MATCH | MISMATCH | MATCH | MATCH | MISMATCH | none |

The other 10 checks (Ali v Foreman, Hearns v Duran, Marquez beat 1) stay MATCH under every version. **The two knockdown checks
are about health, not timing.** The scene starts Pacquiao at 7 health and Hatton at 5. The biggest single punch our tables
allow is 6 (overhand 4, counter +1, pull or timed +1), and it lands 5 and 4 here. Those starting healths are the scene
writer's guesses; they were not seen on film. Fixing them belongs to scenes.js, or to a damage change the brief rules out,
so I left them alone. The bar "its exchange MATCHES" is met for each counter's own check (the punch lands) and not for the
knockdown that follows.

## Look-ahead tables and the one-rep trial (n=12, seed 1)
| version | table time | bars | step in | Long | counter chosen | lands when chosen | verdict |
|---|---|---|---|---|---|---|---|
| M | 896 s, jobs=3 | 5 of 9 | **21.96%** | **49%** | 25.9% | 36.0% | STOPPED (the brief: step in under 22% at n=12) |
| M2 | ~19 min, jobs=2 | 6 of 9 | 26.3% | 38.6% | 17.7% | 35.5% | went on to n=84 |
| H2 | 819 s, jobs=3 | 6 of 9 | 28.7% | 38.9% | 5.8% | (fired 7 of 7) | went on to n=84 |

## The nine bars, n=84 mirror (bars passed; each red bar's numbers)
Controls: the ONEACT1 runs of today's page (results/oneact_today_mirror_s1/_s2, _opps_s1). They used the same command, n=84,
jobs=1, so they have the same seed split, and the page's rules have not changed since. I re-ran seed 1 under my measurement
loader: its report lines are identical (results/counters1_today_measured_s1.txt), so they are the same runs.

| | seed 1 | seed 2 |
|---|---|---|
| **today** | **7 of 9**: Push off 3% (dead); Jab 67%, Lead uppercut 65%, Overhand 77% | **8 of 9**: Jab 67%, Body jab 66%, Overhand 73% |
| **M2** | **7 of 9** (= today): Push off 3%; Jab 71%, Body jab 66%, Overhand 74% | **8 of 9** (= today): Body jab 67%, Lead uppercut 68%, Overhand 73% |
| **H2** | **6 of 9** (one under today): Push off 3%; Lead hook short 41%, Overhand 77%, Rear uppercut short 42%; **the order: feet first in 60% of ordered beats** (bar: at most 60%; the unrounded value is over it) | **8 of 9** (= today): Jab 68%, Body jab 66%, Overhand 71% |

The mirror stays fair in every run: M2 48% / 43%, H2 54% / 53% (today 56% / 51%).

## The counter's own bars and the feedback loops
| run | step in (>= 22%) | Long (<= 45%) | counter plan chosen (2-15%) | plan lands when chosen (45-75%) | the counter fired / landed when fired | health a round (>= 90% of today) |
|---|---|---|---|---|---|---|
| today s1 | 32.5% | 34.9% | - (back off + hook 0.4%) | - | - | 14.72 |
| M2 s1 | 25.4% | 42.7% | **18.3%** | **36.9%** | 20.8% of waits / 88.6% | 14.11 (96%) |
| M2 s2 | 26.1% | 39.3% | **16.4%** | **37.5%** | 23.0% / 83.2% | 14.75 |
| H2 s1 | 30.7% | 35.6% | 4.8% | **33.3%** | 44 cut offs / **100%** | 14.61 (99%) |
| H2 s2 | 31.2% | 34.2% | 5.1% | **33.8%** | 49 cut offs / **98%** | 14.79 |

(Today, seed 2: health 43.0 a bout. M2: 43.8, H2: 43.3.)
- **M / M2: the loop the brief named is real.** When the waiting man can punish a step in, stepping in falls from 32-34% to
  25-26% (M2), or to 22% with no price (M), and Long climbs to 43-49%. The wait becomes a habit: 16-18% of beats even with
  a 1-stamina price. It mostly misses (the punch falls short at Long when he holds), yet when he does step in it lands 83-89%.
  It is a lottery ticket, not a read.
- **H2: chosen at a healthy rate (5%, today 0.4%), and stepping in barely moves (31%).** But it is all or nothing: the back
  off + hook plan lands 33% (he did not come, so the hook falls short), and when he does cut you off it lands 98-100%. Nothing
  answers it inside the beat. That certainty, plus the extra short hooks, cost seed 1 the order bar (a boundary) and the
  accuracy bar's numbers.
- How often each counter is chosen and lands, per man: results/counters1_<v>_*.txt, the COUNTERS1_METRICS line (wait, fired,
  timed, out; hookPlan, cut, chk, hookOut).

## Against the three men (n=84, seed 1, mix player; today = ONEACT1)
| | The Jabber | The Slugger | The Body Snatcher |
|---|---|---|---|
| today | wins 80% | wins 68% | wins 62% |
| M2 | wins 83% | wins 64% | wins 68% |
| H2 | wins 81% | wins 77% | wins 68% |
H2 helps the player most against the Slugger, who walks in (+9). That is its rule doing what it says, and it widens a gap the
page already has.

## The feint loop (probe_clinch.mjs n=60, the loop: feint + overhand, then clinch)
| | The Jabber | The Slugger | The Body Snatcher |
|---|---|---|---|
| today (FEINTFIX2's control) | 38% | 63% | 70% |
| M2 | 25% | 53% | 53% |
| H2 | 35% | 57% | 58% |
Not worse against any man under either version. The loop still beats the 30% bar against two of them: that is FEINTFIX2's job.

## What would make each pass (not built, ideas for a next brief)
- Check hook: make it a read, not a sure thing. One idea is that a held LEAD hand low or a step in with the lead hand held
  high still blocks it, so the man stepping in has an answer. Another is the pull +1 without the angle (H1), with the scene
  changed to a hook that comes in moment 1 while his rear hand is out throwing.
- Timed counter: the wait should not be worth taking at Long. For example, it could be allowed only at Mid and Inside (the
  Marquez step goes Long -> Mid, so the scene's own beat would need to start at Mid).

## Files and commands
- Tweaks: counters1_m.json, counters1_m2.json, counters1_h1.json, counters1_h2.json, counters1_mh.json. Tables (not in git):
  E:/FightCamp/wt_tmp/COUNTERS1/{m,m2,h2}.vt.json.
- Results: ops/research/s558_balance/results/counters1_*.txt. The measurement-only loader (it counts chosen and landed
  counters inside balance.mjs's bout loop in memory and changes no rule, draw or number) is printed in full at the bottom of
  counters1_m_n12.txt.
- `node proto/twohands/tools/scene_check.mjs [scene] [tweak=<f>]`: tweak= is new and add-only. Without it the output is byte
  for byte the same (checked). A tweak's `scenes` block may give a man a Wait.
- Regression: `node proto/twohands/tools/rules_test.mjs` -> RULES_TEST 37 passed. `scene_check.mjs` with no tweak -> 10 of 14,
  unchanged.
- PC: one RED at 92% CPU when the M2 table started beside the five H2 runs. I stopped it and restarted it at jobs=2. C: fell
  from 18 to 6 GB during the runs, and not from these runs (they write nothing to C:). The one large new file there is
  C:/Users/user/AppData/Local/AMD/PPC/sdkusage.csv (1.7 GB), an AMD GPU usage log. I left it alone: it is not mine.

COUNTERS1 DONE
