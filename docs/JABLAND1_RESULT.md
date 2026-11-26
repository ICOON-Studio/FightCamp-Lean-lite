# JABLAND1 - the jab and the overhand land too often (S562)

Task: `ops/research/TASK_JABLAND1.md`. Node only. No page touched, no test deleted: every rule change lives in a tweak file
(`ops/research/s558_balance/jabland_<a|b|c>.json`, `src` patches and `ACT` numbers). `proto/twohands/tools/rules_test.mjs`:
37 passed after the work (the page is the same).

How each run was made (2 cores):
- base: `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84 seed=<1|2>` with no tweak (the page's own `vtable.json`).
- each version: one-rep trial `play n=12 jobs=6 tweak=<f>` on the page's table first, then `table tweak=<f> jobs=2` (its own
  look-ahead, 20-26 min each), then `play n=84 seed=1` and `seed=2` with `tweak=<f> table=<its table>`.
- Files: `ops/research/s558_balance/results/jabland_<x>.txt` (n=84 seed 1, with the n=12 trial kept at the bottom) and
  `jabland_<x>_s2.txt` (seed 2). A commit and push after every finished run.

## What the jab and the overhand beat (watched before any change)
A scratch tracer (both men on the solved mix, every hit tagged with why it got through) on today's page:
- **The jab** lands at Long, where only the two jabs reach. It lands on a lead hand held **low** (covering the body jab, and
  the body punches that are 44% of beats) or a lead hand that is **out in the same moment** (a jab trade: both are fast, both
  land). The rear hand has no job at Long: high it covers the side line and low the uppercut line, and neither reaches there.
  That is the owner's question ("is there any point in holding both hands up?"): at Long, today, there is none.
- **The overhand**, when it reaches, is blocked under 10% of the time. Most of the hits come **off a feint** (feint, then
  overhand: the drawn hand cannot cover). Its other misses are short (10-22%).

## The three versions (one line each: why it should cut the jab's and the overhand's landing)
- **a - cheaper, not weaker** (`ACT`: jab 0 stamina, body jab 0, overhand 2). The S555 memory turned around: a weaker strike
  lands more because the mix throws it only where it is safe. A cheaper one is thrown into more guards, so a smaller share
  lands. The body jab is cheapened too, so the high/low guess at Long stays even.
- **b - the guard answers** (2 `src` patches). (1) The rear glove held high **catches the jab** in the moment the lead hand
  is out punching ("you jab, the rear glove stays at the chin"), which ends the free jab trade. (2) The overhand is **too slow
  for the feint's opening**: the drawn hand is back by the time it lands. No number is changed.
- **c - b's guard, cheaper punches** (b's patches + `ACT`: jab 0, overhand 2; the body jab stays 1). b brought the landing down
  but killed both punches (2% and 1% of beats). a showed that cheaper means thrown more and landing less. So: the guard keeps
  the landing down and the price keeps them in the mix.

## The table (two equal men on the solved mix, 84 bouts each)
Bars in order: 1 every range fought, 2 no must, 3 no dead, **4 landing**, 5 bouts end both ways, 6 one/two/none punches,
7 clinch a rescue, 8 order a choice, 9 mirror fair. P = pass, F = fail. Land % is both men pooled (weighted by throws, from
the per-man lines; it can differ by 1 point from the bar line). "Use" = share of beats a man throws it.

| Version, seed | Bars | 1-9 | Jab | Body jab | Cross | Body cross | Overhand | Lead hook | Body hook | Lead upper | Rear upper | Must bar: back off / step in | Mirror | KD a bout / stoppages | Jab / overhand use |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| base, 1 | 8 | PPP**F**PPPPP | **73%** | 57% | 45% | 45% | **68%** | 40% | 56% | 62% | 50% | 35% / 32% | 50% | 2.4 / 24% | 8% / 5% |
| base, 2 | 7 | PPP**FF**PPPP | **68%** | 63% | 44% | 51% | **82%** | 37% | 56% | 61% | 49% | 34% / 33% | 47% | **2.6** / 30% | 7% / 5% |
| a, 1 | 6 | PP**FFF**PPPP | 61% | 61% | **37% (short 44%)** | 46% | 65% | 40% | 60% | 60% | 59% | 37% / 32% | 45% | **3.2** / **43%** | 9% / 14% |
| a, 2 | 6 | PP**FFF**PPPP | 62% | **66%** | 38% | 49% | 58% | **27%** | 64% | **70%** | 54% | 36% / 35% | 43% | **3.2** / **45%** | 8% / 15% |
| b, 1 | **8** | PP**F**PPPPPP | 43%* | 56% | 45% | 44% | 38%* | 38% | 63% | 65% | 49% | 35% / 32% | 48% | 2.1 / 18% | **2% / 1%** |
| b, 2 | **8** | PP**F**PPPPPP | 45%* | 58% | 45% | 46% | 40%* | 39% | 61% | 61% | 54% | 35% / 32% | 51% | 2.1 / 14% | **2% / 1%** |
| c, 1 | 7 | PPP**FF**PPPP | 42% | 65% | 48% | 47% | **27% (short 44%)** | 43% | 55% | 62% | 56% | 35% / 33% | 51% | **2.6** / 25% | 9% / 5% |
| c, 2 | 7 | PPP**FF**PPPP | 37% | 61% | 47% | 52% | **26% (short 40%)** | 35% | 60% | 60% | 64% | 35% / 33% | 47% | **2.5**+ / 30% | 9% / 5% |

\* thrown under once a bout (b: jab 0.3-0.4, overhand 0.2 a bout), so the landing bar no longer counts them.
\+ shows 2.5 rounded; the bar reads it as over 2.5 and fails.

What failed, word for word from the bar lines:
- base: jab 73% / 68%, overhand 68% / 82% (the RED, as the task expected); seed 2 also knockdowns 2.6.
- a: body hook dead (2%) on both seeds. Landing: cross 37% short 44% (seed 1); body jab 66%, lead hook 27%, lead uppercut 70%
  (seed 2). Knockdowns 3.2 with 43-45% stoppages. The overhand is thrown three times as often (0.7 to 2.2 a bout) and lands
  58-65%, so the damage runs away.
- b: dead, jab 2% and overhand 1% (both seeds). Nothing else.
- c: overhand lands 27% / 26% (short 44% / 40%): at 2 stamina it is thrown speculatively at Long and falls short. Knockdowns
  2.6 / 2.5+.

Trials (n=12, on the page's table): a 6 of 9 (body jab 71%, knockdowns 3.1), b 5 of 9 (jab 36%, overhand 48%, both nearly dead,
mirror 25% on 12 bouts), c 6 of 9 (jab 37%, overhand 43%, both alive). Each trial pointed the same way as its 84-bout runs.

## Feedback loops (as asked)
- Less landing feeds fewer knockdowns: b cut them from 2.4-2.6 to 2.1 a bout, with stoppages 14-18% (over the 10% floor).
- More throwing feeds more damage: a's cheaper overhand ran knockdowns up to 3.2 a bout and stoppages to 43-45%. c's guard held
  that to 2.5-2.6, still just over the bar.
- The read of a habit was not changed (still the last three punching beats). No bout ran longer: the must bar (back off 34-37%,
  step in 32-35%) and the ranges (29-37% each) barely move in any version.

## Verdict
**none: the nearest is b**. It holds 8 of 9 on both seeds and the landing bar passes (jab 43-45%, overhand 38-40%). But its miss
is the jab and the overhand themselves going **dead** (2% and 1% of beats, about 0.3 and 0.2 a bout). The landing bar passes
partly because they are thrown too seldom to count. It meets the wording "8 with the landing bar now passing". I do not
recommend putting it on the page: the problem moves to the same two punches instead of being solved, and the Jabber's own punch
would be dead. c keeps both alive and the jab right (37-45%, 9% of beats), but the cheap overhand overshoots: it lands 25-27%
and falls short 40-44%, with knockdowns 2.5-2.6.

What the three say together:
- **The jab is solved** by c's jab half: the rear glove catches the jab while the lead is out, and the jab costs 0. On both
  seeds it lands 37-45% and is thrown in 9% of beats. The guard answer is the one the owner's question asked for: at Long, holding
  the rear hand up now matters.
- **The overhand has no number between 2 and 3 stamina that works**. At 3 without the feint it is dead (b); at 2 it is thrown
  from too far and falls short (c); at 2 with the feint it piles up knockdowns (a). The next probe should keep c's jab half and
  give the overhand a different lever, not a price. One idea: keep the feint opening for it, but only at Inside, where it
  cannot fall short.

JABLAND1 DONE
