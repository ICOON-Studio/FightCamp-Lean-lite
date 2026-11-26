# CLINCHFIX2 - the clinch pays too well: the push off gets a second job (S562)

No page was changed (order.html, punch.html, kick.html, head.html, body.html untouched) and no test was deleted.
Rule changes are tweak files only (`src` patches on order.html). Node only.

## How it was measured

- Read `proto/twohands/tools/probe_clinch.mjs` and `proto/twohands/tools/balance.mjs`.
- Checked each `src` anchor of the tweaks against today's `proto/twohands/order.html`:
  - `else if (clincher != null) { f[clincher].st = Math.min(f[clincher].cap, f[clincher].st + 2);` - still on the page (the clinch line, +2 stamina).
  - `(S.range === 1) { S.range = 2; say(k, { m: i, t: 'flat', a: 'pushes off',` - still on the page (the push-off line, Inside only).
  Both anchors match as-is; no anchor text had to be fixed and no rule was changed to fit.
  `tweak_check.mjs` loads all three tweak files (P0 has none).
- One-rep trial first: `node proto/twohands/tools/probe_clinch.mjs tweak=ops/research/s558_balance/clinch_half_push_counter.json n=12`
  loads and the loop is played (loop 17% / 17% / 33% v Jabber / Slugger / Body Snatcher at n=12, my clinches 4.4 / 7.7 / 6.9 a bout).
- Each version: `probe_clinch.mjs n=60` (the loop, and the same man who never clinches as control);
  then `balance.mjs table tweak=<file> out=tmp_clinch2/<p>.vt.json iters=300 jobs=2` (own out folder, never `proto/twohands/vtable.json`, tables not committed);
  then `balance.mjs play who=mix opp=mirror n=84 tweak=<file> table=tmp_clinch2/<p>.vt.json seed=1 jobs=2` and the same with `seed=2`.
  P0 is today's page with no tweak (table built the same way, no tweak argument).
- Outputs: `ops/research/s558_balance/results/clinch2_<p0|p1|p2>.txt` (seed 1 play), `clinch2_<p>_s2.txt` (seed 2 play),
  `clinch2_<p>_loop.txt` (probe_clinch n=60). Committed and pushed after each version.

## Versions

- **P0: today's page, no tweak** - the base on today's page (with the S560 pull counter on order.html).
- **P1: `ops/research/s558_balance/clinch_half_push_counter.json` as it is** (S559, never measured before):
  the clinch gives +1 stamina (not +2), the man tied up gets back half his smothered plan's stamina
  (`Math.floor(cost(P[o]) / 2)`), and a push off that lands puts him off balance:
  `opening[k] = 1` for the pusher, so the pusher's later punches that beat are counters (+1 health, `N.counter`),
  as after a miss or a block.
- **P2: `ops/research/s558_balance/clinch_push_counter_all.json` (new)** =
  `clinch_net0_back_all.json` (the clinch gives +1 stamina, net 0, AND the man tied up gets back all of his
  smothered plan, `cost(P[o])`) plus the same push-off counter as P1 (`opening[k] = 1` on a landing push off).

Caps already in the rules (unchanged by these tweaks): the counter lasts only the rest of that beat
(`opening` is a local of `resolve`, reset every beat); the clinch works Inside only
(`S.range > 1` is refused) and not twice running (`f[clincher].held = 2`, decremented in `endBeat`;
`plansFor` only offers a clinch when `!me.held`).

## The loop (probe_clinch, n=60 a man; wins %)

| Version | v The Jabber | v The Slugger | v The Body Snatcher | No-clinch control (same three) | My clinches a bout (loop) | His clinches a bout (loop) |
|---|---|---|---|---|---|---|
| P0 today's page | 38% | 63% | 70% | 12% / 13% / 7% | 4.5 / 7.2 / 6.3 | 0.1 / 0.2 / 0.3 |
| P1 half back + push counter | 20% | 23% | 27% | 7% / 20% / 13% | 4.7 / 7.4 / 6.6 | 0.1 / 0.1 / 0.1 |
| P2 all back + push counter | 15% | 18% | 17% | 7% / 15% / 7% | 4.4 / 7.0 / 6.5 | 0.1 / 0.1 / 0.1 |

RED_TEST note: `docs/RINGSWITCH_S558.md` records the loop at 43% / 53% / 43% on the page as it was then.
On today's page (S560 pull counter on order.html, page vtable rebuilt for it) P0 measures 38% / 63% / 70% -
the Jabber is close, the Slugger and especially the Body Snatcher are higher. The direction is the same and
much larger than the no-clinch control (12% / 13% / 7%): on today's page the clinch still pays too well.

## The 9 bars (balance play, who=mix opp=mirror, n=84; PASS/FAIL per seed)

The nine bars, in order: (1) every range 15-55% of beats, (2) no switch a must (>40%), (3) no switch dead (<3%),
(4) every punch lands 30-65% and falls short at most 40%, (5) bouts end both ways (stoppages 10-40%, draws <=20%,
0.5-2.5 knockdowns a bout), (6) two punches 15-45% and none 5-25%, (7) clinch at most 2 a bout,
(8) the order is a choice, (9) the mirror is fair (40-60% of decided bouts).

| Version / seed | Bars | 1 range | 2 must | 3 dead | 4 punch lands | 5 bouts end | 6 punches | 7 clinch | 8 order | 9 mirror |
|---|---|---|---|---|---|---|---|---|---|---|
| P0 seed 1 | 8 of 9 | PASS 31/36/33% | PASS back off 34% | PASS none under 3% | FAIL Overhand 73% lands, short 18% | PASS stoppages 29%, draws 2%, kd 2.5 | PASS two 17%, none 13% | PASS 1.2 | PASS ordered 67%, first 55% | PASS 59% |
| P0 seed 2 | 8 of 9 | PASS 30/36/35% | PASS back off 35% | PASS none under 3% | FAIL Jab 68%, Body jab 66%, Overhand 76% lands | PASS stoppages 23%, draws 5%, kd 2.3 | PASS two 17%, none 13% | PASS 1.2 | PASS ordered 68%, first 53% | PASS 59% |
| P1 seed 1 | 6 of 9 | PASS 32/34/35% | PASS back off 36% | FAIL Push off 3%, clinch 3% (under 3% unrounded) | FAIL Jab 69%, Overhand 68% lands | FAIL stoppages 24%, draws 5%, kd 2.6 | PASS two 16%, none 12% | PASS 0.8 | PASS ordered 69%, first 54% | PASS 45% |
| P1 seed 2 | 6 of 9 | PASS 34/34/32% | PASS back off 36% | FAIL Push off 3%, clinch 3% | FAIL Jab 71%, Overhand 79% lands | FAIL stoppages 27%, draws 5%, kd 2.7 | PASS two 16%, none 13% | PASS 0.7 | PASS ordered 69%, first 55% | PASS 46% |
| P2 seed 1 | 6 of 9 | PASS 33/33/34% | PASS back off 37% | FAIL Push off 2%, clinch 2% | FAIL Jab 71%, Lead uppercut 65%, Overhand 76% lands | FAIL stoppages 31%, draws 1%, kd 2.7 | PASS two 16%, none 13% | PASS 0.6 | PASS ordered 70%, first 56% | PASS 57% |
| P2 seed 2 | 6 of 9 | PASS 35/33/32% | PASS step in 34% | FAIL Push off 3%, clinch 2% | FAIL Jab 74%, Lead uppercut 68%, Overhand 75% lands | FAIL stoppages 36%, draws 2%, kd 2.8 | PASS two 16%, none 13% | PASS 0.6 | PASS ordered 69%, first 54% | PASS 52% |

## Push off share, push offs a bout, clinches a bout (balance play, per seed)

Push off share is the printed "Push off" % of beats, averaged over the two men (you / he in the output).
Push offs a bout per man = that share x 18 beats (3 rounds x 6 beats, the full bout length);
both men together is double that. Clinches a bout is the printed total (successful clinches, both men).

| Version / seed | Push off share (you / he, avg) | Push offs a bout per man (both) | Clinches a bout |
|---|---|---|---|
| P0 seed 1 | 3% / 4%, avg 3.5% | 0.63 (1.26) | 1.2 |
| P0 seed 2 | 4% / 4%, avg 4.0% | 0.72 (1.44) | 1.2 |
| P1 seed 1 | 2% / 3%, avg 2.5% | 0.45 (0.90) | 0.8 |
| P1 seed 2 | 3% / 2%, avg 2.5% | 0.45 (0.90) | 0.7 |
| P2 seed 1 | 2% / 2%, avg 2.0% | 0.36 (0.72) | 0.6 |
| P2 seed 2 | 3% / 3%, avg 3.0% | 0.54 (1.08) | 0.6 |

Feedback loop, as asked: the push-off counter was meant to feed counters, widen the health gap, make a man
behind clinch more, and make the push off more useful - so clinches and push offs would rise together from P0.
They did not. From P0, clinches a bout fell (1.2 / 1.2 to 0.8 / 0.7 in P1 and 0.6 / 0.6 in P2) and the push off's
share fell or stayed flat (3.5% / 4.0% to 2.5% / 2.5% in P1 and 2.0% / 3.0% in P2). Both fell together, neither rose.
The second job did not lift the push off out of the dead-switch bar; with the clinch paying less there are fewer
Inside clinch beats for the push off to answer, and the +1 counter on a later punch in the same beat is not
enough, in the solved mix, to make the shove worth choosing more often.

## Verdict

none: P2 (clinch_push_counter_all) is the nearest - it is the only version that brings the loop under 25%
against every man (15% / 18% / 17%, max 18%), but it holds only 6 of 9 bars on both seeds, missing 8 of 9 by
2 bars: the dead-switch bar (Push off 2-3% and clinch 2% of beats, under 3%) and the bouts-end bar
(knockdowns 2.7 / 2.8 a bout, over 2.5), on top of the punch-lands bar that already fails on today's page
(Jab / Overhand / Lead uppercut landing 65-76%). P1 is milder but fails both tests: 6 of 9 on both seeds
(same two extra bars, knockdowns 2.6 / 2.7) and the loop at 27% against the Body Snatcher, over 25%.
P0 holds 8 of 9 on both seeds but the loop is 38% / 63% / 70%.

Regression: `node proto/twohands/tools/rules_test.mjs` -> RULES_TEST 37 passed (no page touched).

CLINCHFIX2 DONE
