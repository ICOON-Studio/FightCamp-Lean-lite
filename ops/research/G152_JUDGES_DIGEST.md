# G152 — Judges disagree on close rounds

Boxing seats three judges. On master they turned in the same card. A margin lean, centred so the middle judge reads the true margin, lets a close round split and leaves a clear round unanimous.

One mechanism. One AUTHORED constant: `MARGIN_READ_WIDTH = 4.0` in `JudgePanel.gd`. `RoundScoring.gd` is unchanged. Knockdowns, the 10-8 gate, and one-judge rulesets are unchanged.

## Anchors

Every rate below is a band. The label is on the claim, not on the sim.

| Claim | Label | Band | Source |
| --- | --- | --- | --- |
| Share of pro boxing **decisions** that are split or majority | **NO STUDY** | — | No population rate for professional boxing turned up. BoxRec's wiki defines UD / SD / MD and does not publish the mix. Lee, Cork & Algranati, JRSS Series D 51(2):129–146 (2002), is two fights. Balmer, Nevill & Lane, J Sports Sci 23(4):409–416 (2005), is home-win probability. |
| Working band used as the acceptance window for this change | **SECONDARY** | **10–30% of decisions** | Widened around a mixed-martial-arts count, because the boxing rate is NO STUDY. FightMatrix "UFC Fight Outcomes By Year", summed for 2023–2025 (page read 2026-09-30): 836 judged outcomes, 657 unanimous, 161 split, 9 majority, 9 draws. Split + majority = 170/836 = **20.3% of judged outcomes**. Same totals in AgentMMA, 2026-07-24. This is UFC, not boxing. |
| Three judges agree on the **round winner** | **DOCUMENTED** | **70–80% of rounds** (so 20–30% do not) | "Interpretable Prediction and Large-Scale Analysis of Judging in Professional Boxing", Paper Track Other Sports, Paper ID 145. Title page prints no author. PDF metadata names Benjamin Bohr and is dated 27 January 2026. Of 5,348 matches, 1,003 had complete BoxRec round cards: **7,864 rounds. 73.1% (5,745) unanimous on the winner, 26.9% (2,119) not.** Their word "split" here means the round, not the bout. 93.1% of rounds were only 10-9/9-10; 6.8% were excluded from the model. Pairwise agreement on the rounds they kept is 81% (page 11). That 81% is pairs of judges, not three-judge unanimity. |
| Share of pro bouts that go to the cards | **DOCUMENTED** | about **45–55%** decisions, so KO+TKO sits near the complement | Same paper, introduction, citing its reference [1]: 46.5% of matches are decided by scorecards rather than knockout or stoppage. The pass band used here is the one already printed for this census: **KO+TKO 40–55%**. |
| Pro boxing draw rate | **PROXY** | **2–3% of all bouts** | `G146_BOXING_DRAW_RATE.md`. No sourced 2015+ figure. The booked census printed **5.8%**. This change was not allowed to move the draw rate off that printed census figure. |

`split%` and `maj%` in the census table are shares of **all bouts**. `smDec%` and `sm_of_dec` are shares of **decisions**. 11.7% of bouts is 23.0% of decisions on the same card.

## Why the cards agreed

`judge_sigma` is 0.06. It multiplies secondary weights only. Damage and knockdowns are never perturbed. Boxing's damage weight is 1.0; volume is 0.2 and the only nonzero zone is body-hand at 0.3. A round is often 20–30 points, and `margin_wide` is 15, so a 6% wobble on the small weights does not cross 0 or the 10-8 line. The booked census on master found no split and no majority.

## What changed

After the existing weight draw (those deltas are the same numbers they were), each judge with `judge_sigma > 0` draws a lean

`N(0, judge_sigma * margin_wide * MARGIN_READ_WIDTH)`

and the median lean is subtracted. The middle judge's lean is 0, so the consensus card — the median card — is the true card. The two wings lean opposite ways. The lean is added to fighter A's points before `RoundScoring.card`, and only for `ten_point_must`. A one-judge ruleset returns before any draw. `judge_sigma` 0 draws no lean.

Shipped boxing lean, one standard deviation: `0.06 * 15 * 4.0 = 3.6` points. That flips a one-point round. It does not flip a round that is already a 10-8 by a wide margin. A knockdown still overwrites the point card inside `card()`, so a knockdown round stays the same on all three cards.

`MARGIN_READ_WIDTH` is **AUTHORED**. It is not fitted to a published judging variance. The 4.0 is the value at which the booked census below landed inside the SECONDARY 10–30% band without moving KO+TKO or draws.

## Census

Same career both times. Iron Fist Gym, Las Vegas, weeks=40, roster of three, only the boxing light-heavyweight's offers counted (120 bouts; 120 non-boxing offers skipped). Seed `hash("booked|athlete_id|offer_id|week")`. BEFORE is `tools/q212_booked_census.gd` on the pre-change code. AFTER is `tools/_s119_q212_check.gd` with the lean in. KO+TKO, decisions, draws, knockdowns and mean rating gap printed to the same tenth, so the fight stream did not move. The judge stream did.

Percentages in the old columns are of all bouts. Counts under the table are the integers that reproduce those tenths. Draws are inside the decision count.

### BEFORE (master code)

| tier | bouts | KO+TKO | dec | draw | unanim | split | maj | sm of decisions | udraw | sdraw | mdraw |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| local | 40 | 42.5% | 57.5% | 10.0% | 47.5% | 0.0% | 0.0% | 0/23 = 0% | 10.0% | 0 | 0 |
| regional | 40 | 45.0% | 52.5% | 7.5% | 45.0% | 0.0% | 0.0% | 0/21 = 0% | 7.5% | 0 | 0 |
| featured | 40 | 45.0% | 42.5% | 0.0% | 42.5% | 0.0% | 0.0% | 0/17 = 0% | 0 | 0 | 0 |
| POOLED | 120 | 44.2% | 50.8% | 5.8% | 45.0% | 0.0% | 0.0% | **0/61 = 0%** | 5.8% | 0 | 0 |

Pooled counts: KO+TKO 53, decisions 61, draws 7 (all unanimous draws), unanimous wins 54, split 0, majority 0. Split + majority is 0% of decisions and 0% of bouts. Six bouts were neither a KO/TKO nor a decision. KD bouts 32.5%, mean rating gap 17.9.

### AFTER (margin lean)

| tier | bouts | KO+TKO | dec | draw | unanim | split | maj | smDec | udraw | sdraw | mdraw | rndSplit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| local | 40 | 42.5% | 57.5% | 10.0% | 25.0% | 17.5% | 5.0% | 39.1% | 0.0% | 0 | 10.0% | 27.8% |
| regional | 40 | 45.0% | 52.5% | 7.5% | 37.5% | 2.5% | 5.0% | 14.3% | 2.5% | 0 | 5.0% | 18.9% |
| featured | 40 | 45.0% | 42.5% | 0.0% | 37.5% | 2.5% | 2.5% | 11.8% | 0 | 0 | 0 | 9.8% |
| POOLED | 120 | 44.2% | 50.8% | 5.8% | 33.3% | 7.5% | 4.2% | **23.0%** | 0.8% | 0 | 5.0% | 19.0% |

`Q212_OF_DECISIONS POOLED bouts=120 decisions=61 split=9 majority=5 sm_of_dec=23.0% sm_of_bouts=11.7% cards_disagree_of_dec=32.8% rounds=685 round_split=19.0% round_winner_split=18.1%`

Pooled counts: unanimous wins 40, split 9, majority 5, unanimous draws 1, majority draws 6, split draws 0. Those six decision types sum to 61. The 7 draws are the same 7 as before; they were retyped (6 majority draws, 1 unanimous draw) and the draw rate stayed 5.8%. Split + majority wins are 14/61 = 23.0% of decisions and 14/120 = 11.7% of bouts. Cards that are not a unanimous result, counting split and majority draws and not counting a unanimous draw, are 20/61 = 32.8% of decisions.

### Against the bands

| Measure | Before | After | Band | Label |
| --- | --- | --- | --- | --- |
| Split + majority, share of decisions | 0/61 = 0% | 14/61 = 23.0% | 10–30% | SECONDARY. After is inside. |
| Split + majority, share of all bouts | 0/120 = 0% | 14/120 = 11.7% | — | Same bouts, other denominator. Printed so the two are not mixed. |
| KO+TKO, share of bouts | 53/120 = 44.2% | 44.2% | 40–55 | Census band already printed. Unmoved. |
| Draw, share of bouts | 7/120 = 5.8% | 5.8% | printed 5.8%; PROXY ceiling 2–3% | Unmoved. |
| Rounds where the three cards differ | not measured on the before tool | 19.0% of 685 | — | Card text, so a 10-9 and a 10-8 count. |
| Rounds where the three judges do not agree on the winner | not measured on the before tool | 18.1% disagree, so 81.9% agree | 20–30% disagree (70–80% agree) | DOCUMENTED centre is 26.9% disagree. Pooled sim is a little more agreed than that sample. |

The pooled round figure sits just outside the documented band, on the side of more agreement. That is the booked mix. Local bouts (mean rating gap 5.2) disagree on 27.8% of cards, next to the documented 26.9%. Featured bouts (gap 30.9) disagree on 9.8%. A knockdown round is identical on all three cards because `card()` overwrites the lean, and that rule was left alone. Raising the lean until the pooled rate hit 26.9% would split clear rounds. The acceptance window in the task is the decision share, and 23.0% is inside 10–30%.

Local decisions are 9/23 = 39.1% split or majority, above the 10–30% window. Those are the close shows. Featured are 2/17 = 11.8%, inside it. The window is for the pooled booked population, which is what the old "0 of 54" finding was about. This run's pooled decision count is 61, not the 54 in `Q212_DIGEST.md`: same gym and the same tool shape, remeasured on this worktree's master before the edit.

## Tests

- Parse: `check_scripts.py` on `JudgePanel.gd`, `RoundScoring.gd`, `judge_panel_test.gd`, `_s119_q212_check.gd`. fails=0.
- `judge_panel_test.gd`: 0 failures, no SCRIPT ERROR. T12: a boxing round of margin 38.5 is 10-8 on all three cards at the shipped sigma; the same round at `judge_sigma` 1.0 is 9-10 / 10-8 / 10-8; a one-point round at the shipped sigma is 9-10 / 10-9 / 10-9.
- `run_tests.py --jobs 2 --only judge`: 1 test, 0 fails. `--only result`: 6 tests, 0 fails.
- T4/T8R consensus rows did not move. Four decision types did, and they were re-pinned from the test's own printed actual, both runs agreeing: `boxing_11` unanimous_draw → split_draw, `boxing_9` unanimous_draw → majority_draw, `boxing_20` unanimous → split, `muay_thai_17` unanimous → majority. The assertion is still exact equality.

## Files

- `Godot/scripts/JudgePanel.gd` — the lean.
- `Godot/tests/judge_panel_test.gd` — T12, and the four decision-type re-pins.
- `Godot/tools/_s119_q212_check.gd` — the booked census plus `smDec%`, both denominators, and the round columns. `split%` and `maj%` are still shares of all bouts.
- `Godot/tools/q212_booked_census.gd` — not edited. It is the BEFORE measurement.
