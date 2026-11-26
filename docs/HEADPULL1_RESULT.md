# HEADPULL1 (S560) - the head-movement page with the pull counter: two 84-bout runs

The pull counter (a back off arms that man's next punch in the beat, +1) is measured WITH `proto/twohands/head.html`
(slip, roll, lean back, slip in), on a bigger sample than head_base's 56 bouts, to answer the owner's question about the
one red bar (lead uppercut landed 66%, one point over). Nothing on the page, no rule, no test and no tweak file was
touched; `ops/research/s558_balance/results/head_pull_1.txt` and `head_pull_2.txt` are the raw outputs.

## What was run
- Tweak loads: `node proto/twohands/tools/tweak_check.mjs ops/research/s558_balance/head_pull.json` - TWEAK_CHECK loads.
- `node proto/twohands/tools/balance.mjs table tweak=ops/research/s558_balance/head_pull.json out=tmp_head/head_pull.vt.json iters=300 jobs=2` - wrote in 8887 s (2 cores; layers 5 and 6 agree). The table is NOT committed.
- `node proto/twohands/tools/balance.mjs play who=mix opp=mirror n=84 tweak=... table=tmp_head/head_pull.vt.json seed=1` (5371 s) -> head_pull_1.txt; the same with `seed=2` (5142 s) -> head_pull_2.txt. `play` takes a `seed` (its header), so two seeds.
- Regression, run once, nothing edited: HEAD_TEST 11 passed, RULES_TEST 37 passed.

## The nine bars, head_base (56 bouts) against the two runs (84 bouts each)
| Bar | head_base | Run 1 (seed 1) | Run 2 (seed 2) |
|---|---|---|---|
| Every range is fought at (each 15-55% of beats) | PASS Inside 32%, Mid 35%, Long 33% | PASS Inside 31%, Mid 36%, Long 33% | PASS Inside 31%, Mid 37%, Long 32% |
| No switch is a must (none in over 40% of beats) | PASS back off 28%, step in 26%, Body cross 25% | PASS back off 30%, step in 26%, Body cross 23% | PASS back off 29%, step in 27%, Body cross 23% |
| No switch is dead (each in at least 3% of beats) | PASS none under 3% | PASS none under 3% | PASS none under 3% |
| Every punch lands 30-65% of the time and falls short at most 40% | FAIL Jab lands 65%, short 23%; Lead uppercut lands 66%, short 21% | FAIL Overhand lands 67%, short 26% | FAIL Jab lands 65%, short 14%; Overhand lands 68%, short 22% |
| Bouts end both ways (stoppages 10-40%, draws at most 20%, 0.5-2.5 knockdowns a bout) | PASS stoppages 11%, draws 2%, knockdowns 1.9 | PASS stoppages 12%, draws 7%, knockdowns 1.9 | PASS stoppages 15%, draws 7%, knockdowns 2.1 |
| One punch, two punches and holding all have their beats (two 15-45%, none 5-25%) | PASS two 16%, none 14% | FAIL two 15%, none 14% (two a hair under the 15% floor; the tool prints whole %) | PASS two 16%, none 15% |
| The clinch is a rescue, not a habit (at most 2 a bout) | PASS 1.3 | PASS 1.4 | PASS 1.4 |
| The order is a choice (no slot first in over 60% of ordered beats; an order to choose in 40%+ of beats) | PASS ordered 72%, most often first 48% | PASS ordered 74%, most often first 53% | PASS ordered 72%, most often first 53% |
| The mirror is fair (wins 40-60% of decided bouts) | PASS 56% | PASS 53% | PASS 46% |
| **Bars passed** | **8 of 9** | **7 of 9** | **8 of 9** |

## The head moves, share of beats (you / he, as the output prints them)
| Move | head_base | Run 1 | Run 2 |
|---|---|---|---|
| Slip | 9% / 10% | 8% / 7% | 6% / 7% |
| Roll | 3% / 3% | 2% / 1% | 2% / 2% |
| Lean back | 6% / 7% | 6% / 6% | 5% / 6% |
| Slip in | 3% / 3% | 5% / 5% | 4% / 5% |

Slip in gains about two points of beats over head_base; Slip and Lean back lose one to two; Roll is at 1-2% either way
(note: the dead-switch bar above reads the ACT switches, the head moves live in FEET, so it never scores them).

## The jab and the lead uppercut (lands / blocked / misses, you / he)
| Punch | head_base | Run 1 | Run 2 |
|---|---|---|---|
| Jab | 60% / 12% / 28% and 71% / 11% / 18% | 55% / 22% / 23% and 52% / 26% / 22% | 69% / 16% / 15% and 63% / 24% / 13% |
| Lead uppercut | 70% / 12% / 18% and 61% / 14% / 25% | 56% / 18% / 26% and 63% / 7% / 30% | 60% / 13% / 27% and 57% / 13% / 29% |

Both men pooled, the bars' way (weighted by throws): the jab lands ~65% (base), ~54% (run 1), ~65% (run 2); the lead
uppercut 66% (base, the red bar), ~59% (run 1), ~58% (run 2) - the punch that missed the bar by one point is two runs
inside the 30-65% band.

## The pull counter's "+1" punch
The output does NOT show how often the +1 punch was thrown: the tool counts punches by their id, and the +1 is folded
into that punch's damage on the page (there is no separate event for it). What the output does show is the arming move:
back off at 30% / 30% (run 1) and 29% / 30% (run 2) of beats, against head_base's 29% / 27% - backing off holds a
little more of the mix now that it pays, and the ground rule still caps it (two back offs and a man is on the ropes:
knockdowns 1.9 / 2.1 a bout, inside the bar).

## The verdict
9 of 9 in NEITHER run: 7 of 9 (seed 1) and 8 of 9 (seed 2). The bar that fails in both is "every punch lands 30-65% of
the time and falls short at most 40%", and the miss is the OVERHAND: it lands 67% in run 1 (2 points over the 65 cap)
and 68% in run 2 (3 points over), with run 2 also listing the jab at 65% (a hair over; the tool rounds to whole %) -
while head_base's one-point miss, the lead uppercut at 66%, is back inside the band in both runs. Run 1 alone also
dropped the two-punch bar by a rounding hair (two 15% printed, a fraction under the 15% floor); run 2 passes it.
