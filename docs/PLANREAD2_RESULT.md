# PLANREAD2 - the card must not promise a plan the bout does not pay (S547)

**The cause, in one sentence:** the read priced her plan in her own trouble (she_tired) on the "inside" card, at
PLAN_REACH x PLAN_CARRY (1.425) of its edge and with no fire share. Since S466 the ring fights that exchange on the card she
is standing on, so the tie-up line the read paid for was almost never thrown. On top of that, the read had no term for
S540's combo counter, which takes every repeated plan line's exchange 35% of the time (61% against a counter-puncher).

**What changed:** the plan term moved out of `BoutRead` into a new small module `scripts/rules/PlanReadFit.gd`, and the read
now follows the ring's own firing rule (`PlanChain.walk_ring`):
- her own trouble walks the card chain like every other situation, on her own card, at the line's fire share and her grade
  (`LineGrade.attrs_for`, as LiveRound). The separate she_tired term in `BoutRead._game_edge_of` is gone (6 lines out);
- each round reads its own phase lines (`PlanFile.arrows_for(..., n, rounds)`, as LiveRound);
- the opponent's combo counter is carried as expected throws per line, round to round (the film line half-read at the first
  bell, FADE at each bell). Each exchange's countered share is `fire x P(thrown >= read_at) x ComboCounter.chance(style)`
  (Poisson on the mean). Countered exchanges are lost, so the round's exchange odds become `(1 - countered) x win_odds(e)`,
  turned back into an edge (`PlanReadFit.countered`).
- **No constant was fitted.** `PLAN_CARRY` 1.9 stays: on the ring's own records (LiveRound `rec.plan_edge` and
  `rec.read_edge`, 60 cells, plans of 1 to 5 lines, 500 bouts a cell), (plan_edge + read_edge) / plan_edge = **1.945**.
  Since nothing was fitted, no bouts were "fitted on"; the held-out split below is reported anyway.

Files: `scripts/rules/BoutRead.gd` (499 -> 493 lines), `scripts/rules/PlanChain.gd` (86 -> 141: `walk_ring`, `read_odds`;
`walk` and `round_mean` unchanged for their callers), `scripts/rules/PlanReadFit.gd` (new, 74), `tests/plan_read_fit_test.gd`
(new, red first: commit a23f803), `tools/planread2_probe.gd` (the probe). Nothing in LiveRound, BoutNight or the fight changed.

## The table that shows it (tools/planread2_probe.gd, 10 types x 6 styles, 500 paired bouts a cell, 186,000 bouts)

The plans are PLANWORTH1's arm C chooser (greedy on the read before the fix, blank file of the style, any-time lines),
frozen in `E:/FightCamp/tmp/planread2/plans.json`; "n lines" = the first n of that plan. The greedy stopped at 4 lines for 54
of 60 cells and 5 for 6 (the limit is 6); no cell reached 6 to 9. Wins in 100; the gain is against the same cell with no plan.
The read's terms and the ring's records are power points per exchange.

| lines | cells | bout | read before (gain) | read after (gain) | bout gain | read: she_tired term | ring: she_tired | read: chain | ring: other situations | ring: plan's exchange swing |
|---|---|---|---|---|---|---|---|---|---|---|
| 0 | 60 | 42.8 | 42.5 (+0.0) | 42.5 (+0.0) | +0.0 | 0.00 | 0.00 | 0.00 | 0.00 | 0.00% |
| 1 | 60 | 44.6 | 50.9 (+8.4) | 44.2 (+1.7) | +1.8 | 1.77 | 0.49 | 0.45 | 0.40 | 0.52% |
| 2 | 60 | 45.1 | 54.3 (+11.8) | 45.4 (+2.8) | +2.3 | 2.24 | 0.53 | 0.89 | 0.71 | 0.73% |
| 3 | 60 | 45.5 | 55.8 (+13.2) | 46.0 (+3.4) | +2.7 | 2.24 | 0.59 | 1.28 | 1.04 | 0.86% |
| 4 | 60 | 45.8 | 56.4 (+13.8) | 46.4 (+3.9) | +3.0 | 2.24 | 0.60 | 1.37 | 1.19 | 0.99% |
| 5 | 6 | 59.1 | 72.4 (+15.7) | 60.4 (+3.7) | +3.0 | 1.58 | 0.46 | 2.95 | 2.64 | 0.58% |

The over-read did not grow with the number of lines in the chain. The chain term (the opponent's games, walked on her real
cards) sat within 15% of what the ring recorded at every count. It came from the she_tired term: 1.77 points on the first
line against 0.49 in the ring, mostly a `tie_up` the greedy put first because the read priced it on "inside". The second
gap is the swing: the ring's edge of 1.78 a point bought only 0.99% more exchanges.

## The arm that rules the other suspects out: the ring without the counter (`ComboCounter.on = false`, its own switch)

Types 0-1 x 6 styles, 500 paired bouts a cell, the same plans; the read is identical in both arms (before the fix):

| lines | read gain | bout gain, counter on (the game) | bout gain, counter off | plan's exchange swing on | off | ring edge per exchange on | off |
|---|---|---|---|---|---|---|---|
| 1 | 5.8 | 0.5 | 2.5 | 0.03% | 1.18% | 0.92 | 0.98 |
| 4 | 13.1 | 2.7 | 6.4 | 0.74% | 2.96% | 2.36 | 2.49 |

With the counter off, the ring turns its recorded edge into won exchanges at the read's own rate (2.96% on 2.49 points =
1.2% a point; the read's win_odds slope is 1.4%). The ring's recorded edge (2.49) then sits 1.5 times under the read's term
(3.71), and the she_tired line accounts for that gap. So, suspect by suspect:
1. PLAN_CARRY fitted on 1-4 lines: **ruled out**. The ring's own (plan + read) / plan ratio is 1.945, and the chain's
   gain per line did not fall away from the ring's.
2. `when` lines counted wrong: not in play here (the style plans hold any-time lines). The C2 arm, which holds `when` lines,
   is still read +3.6 over its bout (below): the one place left where this suspect may live.
3. p_win read before the plan term: harmless. The walk's p_win only moves her card, and the swing matched the slope with the
   counter off.
4. Lines the ring never reaches: **yes, for her own trouble** (the she_tired line on "inside"); for the opponent's games
   the walk already followed the cards.
5. What the S434 fit could not see: **yes, the S540 combo counter** (and GRADE1 on her own-trouble line).

## Read v bout by arm: PLANWORTH1's table again (its own 300 files and plans, 100 fresh paired bouts a file and arm, 240,000 bouts)

The plans are the ones PLANWORTH1's greedy chose on the old read (`E:/FightCamp/tmp/planworth1/full_a|b.jsonl`), so both read
columns are read on the same plans; "read before" is PLANWORTH1's stored read (B58 for types 0-4 from its b58 replay).

| Arm | bout | read before | before - bout | read after | after - bout |
|---|---|---|---|---|---|
| A no plan | 42.8 | 42.5 | -0.3 | 42.5 | -0.3 |
| B58 coach | 44.1 | 44.7 | +0.7 | 43.4 | -0.7 |
| B74 coach | 44.6 | 45.7 | +1.2 | 43.7 | -0.9 |
| C style plan | 45.8 | 56.4 | +10.6 | 46.4 | +0.6 |
| C2 file plan | 47.5 | 59.1 | +11.6 | 51.1 | +3.6 |
| D one line | 44.5 | 51.5 | +7.0 | 45.2 | +0.7 |
| E careless | 43.3 | 50.2 | +6.9 | 42.4 | -0.9 |
| F worst | 38.2 | 32.4 | -5.8 | 33.8 | -4.4 |

The plan's worth on the card is now the bout's. C - B58 (the plan against the coach's): bout +1.8, read before
+11.6, read after +3.0. C - A: bout +3.0, before +13.9, after +3.9.
Per file (100 bouts, 2 SE about 10 points) the rms of read - bout after the fix: A 4.7, B58 4.5, B74 4.9, C 5.5, C2 6.1, D 5.0, E 6.9, F 8.3.
Raw: `E:/FightCamp/tmp/planread2/pw_0.log`, `pw_5.log`.

## Held-out error

Nothing was fitted, so there is no fit set. The split is reported anyway (the probe's cells, read - bout in wins in 100; the
gain error = read gain - bout gain, cells with a plan):

| | cells | read - bout mean / rms / worst | gain error mean / rms |
|---|---|---|---|
| before, types 0 2 4 6 8 | 156 | 8.5 rms 10.1 worst 18.0 | mean 10.2 rms 10.8 |
| before, types 1 3 5 7 9 | 150 | 6.1 rms 8.1 worst 16.1 | mean 8.6 rms 8.9 |
| after, types 0 2 4 6 8 | 156 | -0.0 rms 4.4 worst 9.2 | mean -0.3 rms 3.4 |
| after, types 1 3 5 7 9 | 150 | 0.4 rms 5.0 worst 11.5 | mean 1.4 rms 3.6 |

A cell holds 500 bouts: 2 SE about 4.4 points on a level, less on a paired gain.

By type, the 4-line plan's gain (read before, read after, bout):

| Type | read before | read after | bout |
|---|---|---|---|
| Lucy Jackson | 15.4 | 3.4 | 3.1 |
| Kira Mensah | 10.8 | 6.7 | 2.4 |
| Samira Khan | 17.1 | 2.7 | 3.7 |
| Tess Reilly | 13.8 | 2.4 | 2.1 |
| Danny Osei | 12.0 | 4.3 | 2.5 |
| Josh Harper | 14.4 | 2.3 | 4.0 |
| Nell Ward | 14.7 | 3.8 | 4.0 |
| Reece Doyle | 11.2 | 5.0 | 2.6 |
| Bayo Adams | 17.4 | 3.1 | 5.4 |
| Kai Turner | 11.4 | 5.2 | 0.3 |

## Tests

- `RESULT: tests/plan_read_fit_test.gd -> PLAN_READ_FIT PASS: 6 cells, 1800 bouts an arm, 96.2 s`. Kira, Josh and Kai (odd types)
  x Pressure fighter and Out-boxer, 300 paired bouts an arm. After: arm A read 34.7 / bout 36.3, D 37.2 / 39.3, C 39.3 / 39.4;
  gain read +4.6 against bout +3.1 (bar <= 9.2). RED on main c3d0f866e: C read 46.7 / bout 39.4 (+7.4, bar 4), gain +12.0
  against +3.1. I decided the bars are pooled over the six cells: a single cell at 300 bouts has 2 SE of about 5.5 points, so
  a per-cell 4-point bar would fail on noise. The style plan holds 4 lines (the greedy stopped there), not 6.
- Green on the fix, each run alone through godot_slot: `plan_chain_test` (PLAN_CHAIN failures=0), `bout_read_test` whole
  (BOUT_READ PASS: the S434 arms inside their old bounds, no bound moved), `the_read_test` (THE_READ PASS), `plan_read_test`
  (failures=0), `plan_read_shown_test` (exit 0), `fade_read_test` (FADE_READ PASS), `pro_read_test` (failures=0),
  `debut_read_test` (failures=0).

## Feedback loops (checked)

- The card's win band, `BoutRead.likely` / `band` / `chance`, and `ProPair.read` (through `round_edges`) all take the
  fixed term. pro_read_test and debut_read_test are green, and the pro bands' clamps in ProStart are untouched.
- `CoachPlan` never calls the read, so the coach's plan is the same before and after; B58 needed no new measurement.
- The probes' greedy chooser: every before/after table above fights plans frozen from the old read.
- Nothing feeds back into the bout.

## What the read still gets wrong

- **C2 (the whole-file plan with `when` lines) still reads +3.6 over its bout**, and the worst plan (F) reads -4.4 under. Both
  sit at the ends the greedy chose on the old read. Not chased here: a `when` line's own situation share (suspect 2), and the
  ring's `StepWire.holds` (she holds a wrong step on her fight IQ), which the read does not model and which would soften F.
- `PlanRead.ADJUST` (a right answer used past FREE_USES in a round pays 0.7x each further use) is not in the read. It is
  probably most of the chain's remaining +15%.
- The counter is read on the mean (Poisson on expected throws, a mean fade at the bell). The ring's countered exchanges also
  send her card where a loss goes, which the walk does not follow.
- Kira Mensah (+6.7 read against +2.4 bout on her 4-line plan) and Kai Turner (+5.2 against +0.3) are still over-read; the
  other eight types sit within 2.5 points (Reece +2.4 over, Bayo -2.3 under).

## Prior research read

`docs/PLANWORTH1_RESULT.md` (whole), the TELLPLAY1 fade fix (BoutRead l.247 before this task), `tests/bout_read_test.gd`
header, `ComboCounter.gd` (S540, docs/REPEATBITE1 numbers), LiveRound l.150-330 (the exchange: plan_edge, read_edge, the
counter after settle, plan_swing on the same dice).
