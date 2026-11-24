# PLANWORTH1 - what the player's whole fight plan is worth against the coach's, in real bouts (S544)

**Question 1 first: YES, one written line switches the coach's plan OFF - in the ring and on the card.** The coach writes
only when the board is empty: `BoutNight.gd:198-200` (`if (f["bout"]["arrows"] as Array).is_empty(): ... CoachPlan.write(...)`,
round 1 only, after `LiveRound.gd:94-95` copied the fighter's `arrows` onto the bout), and the read does the same at
`BoutRead.gd:272-273` (`_read_copy`). A player who writes one line plays that line alone. Measured as arm D below: it is
**not a trap today** (D is never more than 1.8 under the coach's plan, bar 6 PASS), because the coach's own plan is worth
only +1.2 wins in 100.

**Verdict: (c) the plan barely beats the coach's.** The best plan a player can write knowing the opponent's style wins
**+1.7 in 100** more than the coach's plan (2 SE 0.5) and **+2.9** more than no plan at all; the whole-file plan +1.2 on top
of that. The card (the read) promises **+11.6** for the same plan: it over-reads every written plan by 4 to 7 times, the
same defect TELLPLAY1 found in the fade line, now on the whole plan.

Probe: `tools/planworth1_probe.gd` (stages trial / full / b58), tables `tools/planworth1_sum.py`. Raw:
`E:/FightCamp/tmp/planworth1/{trial.log,full_a.jsonl,b58_a.jsonl,full_b.jsonl,sum.md}`. Nothing under scripts/ or tests/
changed.

## Question 2: the coach's cards and the player's lines

- `CoachPlan.READ_AT` = [50, 70], `reads(rating)` = how many of those he passes: **coach 40 reads 0 cards (writes nothing),
  58 (Reid) reads 1, 74 (Hale) reads 2.** So arm B40 is the same plan as no plan; in the bout it equals arm A exactly
  (no other part of the bout reads the coach's rating: `BoutNight.gd:196-211` uses it for the plan and the line limit only).
- `PlanBoard.arrow_limit(r)` = clamp(4 + round((r - 30) / 12), 4, 9): **no coach 4, coach 40 5, 58 6, 74 8.**
  `StyleName.limit` adds one line for a named style (to MAX_LINES); none of the ten types holds a named style at week 4,
  so every type here writes **6 lines** with the gym's coach (58).

## The six bars (10 types, 300 files, 30 paired bouts a file and arm, 122,400 real bouts)

| Bar | Result | Numbers (real bouts, points of wins in 100) |
|---|---|---|
| (1) PLANNING PAYS: C-B58 >= 5 and C-B74 >= 3, 6 of 10 types | **FAIL** (1 of 10: Bayo) | C-B58 over all +1.7 +-0.5, by type -2.3 .. +5.0; C-B74 +1.4 +-0.5 |
| (2) THE TAPE PAYS: C2-C >= 3, 6 of 10 | **FAIL** (1 of 10: Kai) | C2-C over all +1.2 +-0.3, by type +0.2 .. +3.8 |
| (3) A CARELESS PLAN COSTS: E < B58, 6 of 10 | **PASS** (6 of 10, just) | E-B58 over all -0.2 +-0.6; by type -5.7 (Nell) .. +5.3 (Bayo) |
| (4) NOT ONE LINE: one line > 60% of C's gain in most styles for no more than half the types | **FAIL** (7 of 10 one-line) - but noise-bound, see below | C - A per type/style cell +0 .. +11, 2 SE about 2.5 |
| (5) NOT ONE PLAN: no type with one C2 plan on more than half its files | **PASS** | 6-13 different plans a type over 30 files; the commonest on 27-47% |
| (6) NO TRAP: D not below B58 by more than 2 | **PASS** | D-B58 over all +0.9 +-0.4; worst Danny -1.8 +-1.4 |

Bars 3, 5 and 6 pass for a reason that is not good news: a plan moves so few results that nothing - a careless plan, one
line alone - can cost much either. Bar 5 passes on the read's choice of plan; in the bout the plans it tells apart differ by
under 2 points.

## Per type: wins in 100, real bout (the read in brackets)

| Type | A no plan | B40 | B58 | B74 | C style | C2 file | D one line | E careless | F worst |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | 51.6 (56.7) | 51.6 (56.7) | 53.3 (59.1) | 54.2 (61.9) | 55.9 (72.4) | 57.8 (74.4) | 52.4 (62.9) | 50.9 (67.0) | 47.2 (46.6) |
| Kira Mensah | 43.9 (44.9) | 43.9 (44.9) | 44.4 (46.0) | 45.1 (48.3) | 44.7 (55.8) | 45.3 (57.5) | 44.9 (50.6) | 42.8 (53.8) | 40.4 (36.7) |
| Samira Khan | 33.0 (31.3) | 33.0 (31.3) | 33.7 (33.1) | 33.8 (33.2) | 36.2 (48.4) | 36.4 (52.4) | 36.4 (46.1) | 37.8 (44.1) | 31.3 (20.2) |
| Tess Reilly | 33.3 (30.6) | 33.3 (30.6) | 34.0 (32.5) | 34.2 (32.6) | 35.9 (44.4) | 36.6 (49.6) | 35.1 (42.0) | 35.9 (39.8) | 29.1 (19.0) |
| Danny Osei | 45.9 (51.0) | 45.9 (51.0) | 48.0 (53.5) | 48.3 (54.9) | 50.1 (63.0) | 51.2 (63.5) | 46.2 (57.1) | 44.1 (55.6) | 43.6 (42.0) |
| Josh Harper | 35.4 (39.6) | 35.4 (39.6) | 36.4 (41.8) | 36.2 (41.9) | 40.4 (54.0) | 40.8 (57.8) | 39.6 (51.5) | 39.8 (49.0) | 32.1 (26.2) |
| Nell Ward | 49.2 (56.2) | 49.2 (56.2) | 50.8 (61.1) | 51.2 (62.0) | 52.1 (70.9) | 54.2 (72.4) | 51.2 (62.9) | 45.1 (51.5) | 45.2 (46.3) |
| Reece Doyle | 43.8 (48.3) | 43.8 (48.3) | 45.0 (49.5) | 45.7 (51.8) | 45.0 (59.5) | 46.0 (61.1) | 44.8 (54.2) | 44.2 (57.6) | 40.7 (39.8) |
| Bayo Adams | 38.8 (35.2) | 38.8 (35.2) | 39.0 (37.3) | 39.0 (37.3) | 44.0 (52.7) | 44.2 (56.4) | 43.7 (50.3) | 44.3 (48.2) | 35.6 (23.1) |
| Kai Turner | 34.6 (31.3) | 34.6 (31.3) | 36.2 (33.3) | 36.4 (33.5) | 33.9 (42.8) | 37.7 (46.2) | 35.6 (37.2) | 34.2 (35.6) | 31.9 (24.3) |
| ALL | 40.9 (42.5) | 40.9 (42.5) | 42.1 (44.7) | 42.4 (45.7) | 43.8 (56.4) | 45.0 (59.1) | 43.0 (51.5) | 41.9 (50.2) | 37.7 (32.4) |

## Per type: the differences (real bout +- 2 SE, the read in brackets)

| Type | C-B58 | C-B74 | C2-C | E-B58 | F-A | D-B58 | C-A | C2-B58 |
|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | +2.6 +-1.8 (+13.3) | +1.7 +-1.6 (+10.5) | +1.9 +-1.2 (+2.1) | -2.4 +-1.9 (+7.9) | -4.3 +-1.6 (-10.1) | -0.9 +-1.4 (+3.8) | +4.3 +-2.1 (+15.7) | +4.4 +-1.9 (+15.3) |
| Kira Mensah | +0.2 +-1.6 (+9.8) | -0.4 +-1.6 (+7.5) | +0.7 +-0.9 (+1.7) | -1.7 +-1.8 (+7.7) | -3.4 +-1.7 (-8.2) | +0.4 +-1.5 (+4.6) | +0.8 +-1.5 (+10.8) | +0.9 +-1.7 (+11.4) |
| Samira Khan | +2.6 +-1.6 (+15.2) | +2.4 +-1.6 (+15.2) | +0.2 +-1.2 (+4.0) | +4.1 +-1.9 (+11.0) | -1.7 +-1.4 (-11.1) | +2.8 +-1.4 (+13.0) | +3.2 +-1.7 (+17.1) | +2.8 +-1.4 (+19.2) |
| Tess Reilly | +1.9 +-1.3 (+11.9) | +1.7 +-1.3 (+11.9) | +0.7 +-0.9 (+5.2) | +1.9 +-1.7 (+7.3) | -4.2 +-1.4 (-11.6) | +1.1 +-1.3 (+9.5) | +2.6 +-1.5 (+13.8) | +2.6 +-1.4 (+17.1) |
| Danny Osei | +2.1 +-1.3 (+9.5) | +1.8 +-1.2 (+8.1) | +1.1 +-0.9 (+0.4) | -3.9 +-1.8 (+2.1) | -2.3 +-1.2 (-9.0) | -1.8 +-1.4 (+3.5) | +4.2 +-1.5 (+12.0) | +3.2 +-1.4 (+9.9) |
| Josh Harper | +4.0 +-1.5 (+12.2) | +4.2 +-1.6 (+12.2) | +0.3 +-0.9 (+3.7) | +3.3 +-1.9 (+7.2) | -3.3 +-1.5 (-13.4) | +3.1 +-1.5 (+9.7) | +5.0 +-1.6 (+14.4) | +4.3 +-1.5 (+16.0) |
| Nell Ward | +1.3 +-1.4 (+9.8) | +0.9 +-1.5 (+8.9) | +2.1 +-1.1 (+1.5) | -5.7 +-2.0 (-9.7) | -4.0 +-1.5 (-9.9) | +0.4 +-1.1 (+1.7) | +2.9 +-1.8 (+14.7) | +3.4 +-1.5 (+11.3) |
| Reece Doyle | +0.0 +-1.4 (+9.9) | -0.7 +-1.4 (+7.7) | +1.0 +-0.9 (+1.6) | -0.8 +-1.5 (+8.0) | -3.1 +-1.5 (-8.5) | -0.2 +-1.3 (+4.6) | +1.2 +-1.3 (+11.2) | +1.0 +-1.6 (+11.6) |
| Bayo Adams | +5.0 +-1.8 (+15.4) | +5.0 +-1.8 (+15.3) | +0.2 +-1.2 (+3.7) | +5.3 +-1.9 (+11.0) | -3.2 +-1.5 (-12.1) | +4.7 +-1.6 (+13.0) | +5.2 +-1.8 (+17.4) | +5.2 +-1.7 (+19.1) |
| Kai Turner | -2.3 +-1.3 (+9.4) | -2.6 +-1.4 (+9.3) | +3.8 +-1.4 (+3.4) | -2.0 +-1.6 (+2.2) | -2.7 +-1.5 (-7.0) | -0.7 +-1.1 (+3.9) | -0.7 +-1.2 (+11.4) | +1.4 +-1.3 (+12.9) |
| ALL | +1.7 +-0.5 (+11.6) | +1.4 +-0.5 (+10.7) | +1.2 +-0.3 (+2.7) | -0.2 +-0.6 (+5.5) | -3.2 +-0.5 (-10.1) | +0.9 +-0.4 (+6.7) | +2.9 +-0.5 (+13.9) | +2.9 +-0.5 (+14.4) |

## Where the read and the bout disagree (flag: more than 3 points)

**Every written plan is flagged on every type** (C, C2, D, E; F on 7 types). Over all types:

| Arm | bout | read | read - bout |
|---|---|---|---|
| A no plan | 40.9 | 42.5 | +1.6 |
| B58 coach | 42.1 | 44.7 | +2.6 |
| B74 coach | 42.4 | 45.7 | +3.3 |
| C style plan | 43.8 | 56.4 | **+12.6** |
| C2 file plan | 45.0 | 59.1 | **+14.1** |
| D one line | 43.0 | 51.5 | **+8.5** |
| E careless | 41.9 | 50.2 | **+8.3** |
| F worst | 37.7 | 32.4 | **-5.3** |

The read's level is close for no plan and the coach's one or two lines (within 1.6-3.3), and it then grows with every
line written: a 6-line plan reads 12-14 points better than it fights, the worst plan 5 points worse. The read's plan term
(`BoutRead._round_edges` l.378, `PLAN_CARRY` x `PlanChain.walk` over the arrows) adds each line's card edge and sums them;
the ring (`LiveRound` l.231 onward) fires a line only in the exchanges where she stands on its card in its situation. The
card the player sees promises a plan the fight pays about a fifth of. Because the greedy chooser used the read, arms C/C2/F
are "the best/worst plan by the read" - a plan picked on the bout could be somewhat better, but the read-vs-bout gap on the
coach's single line (2.6) against a whole plan (12.6) says the over-read is per line, not a choice artefact.

## Question 4: where the worth sits (C minus one line)

Per type and opponent style (5 files x 30 bouts = 150 paired bouts a cell), each line's share of C's gain over no plan.
C - A is only +0 to +11 in a cell with a 2 SE of about 2.5, so the shares swing from -300% to +300%: **the bar reads FAIL
(7 of 10 types have one line over 60% in most styles) but that is mostly noise around a gain near zero.** What repeats
across cells: the any-time **tie_up** (in the clinch) carries most of the gain for Samira, Tess, Josh and Bayo (the 3b-3 /
slugger books), and **step_back** (mid range) for Lucy and Danny. Neither is a decision the player re-makes per opponent:
they are the same line in every one of that type's six style plans. Full table in the appendix.

## Question 5: does the best plan differ

Arm C2 (whole file, `when` lines allowed) finds 6-13 different best plans per type over 30 files; the commonest covers
27-47% of files. No type has one plan best on more than half (bar 5 PASS). But the plans share most of their lines (e.g.
Samira/Tess/Josh: 1-2, step_back when pressed, tie_up when tired, pivot_out when hurt, 3b-3 inside when she tires, on
33% of files), and in the bout C2 beats the one-per-style C by only +1.2. On the read the plan changes with the file; in the
ring the change is worth about one win in a hundred.

## Population, arms and what I decided

- **Types:** TURNPROBE18's ten at week 4 (`tools/tellplay1_rules.gd` `build_types`, preloaded, not edited): Lucy Jackson,
  Kira Mensah, Samira Khan, Tess Reilly, Nell Ward (women); Danny Osei, Josh Harper, Reece Doyle, Bayo Adams, Kai Turner
  (men); six styles, the same-rated opponent (night0), the 4-round debut card.
- **Files:** 30 of the 180 a type, 5 per opponent style, weapon and weakness rotated (`idx = (7j + 3si + ti) % 30`, as
  `tellplay1_probe.gd` stage_bout_base), so each type sees every style and spread weapons/weaknesses.
- **The bout:** `tellplay1_probe.gd` `bout()` copied (`BoutNight.play_out`, rule A off = the game's own mode_bias), paired
  dice (bout k = career day 50000 + 7k in every arm), 30 bouts a file and arm. Wins only (a draw is not a win).
- **The read:** the game's `BoutRead.CardOdds.result(BoutRead.round_edges(f, opp, camp, coach), FORM_SD)["win"]` - today's
  code, with the S544 fade fix in.
- **Arms:** A = empty board, no coach (`Sim.NO_COACH_RATING` 14.3). B40/B58/B74 = empty board, the bout's coach at that
  rating (the coach writes at the first bell, as the game). C = greedy on the read against a **blank file** of that style
  (style known, weapon and weakness empty), any-time lines only, one per place, up to the limit (6). C2 = greedy on the full
  file, any-time lines plus a `when` line per situation on its card (`PlanLines.place_for`) and the ropes card for press /
  load-up (`PlanFight.LOST_CARD`). D = C2's first line alone. E = her highest-mastery throwable moves (punches, drilled
  combinations, steps), one per place, skipping a move that is the best answer to the style's game on that card
  (`CoachPlan.cards`). F = greedy for the lowest read, same candidates as C2. C-i = C minus line i. Every player arm plays
  with the gym's coach at 58 (the rating only changes the coach's own plan and the line limit). Greedy stops when no line
  raises (lowers, for F) the read; after the first step it re-reads only the 10 best of the last step's gains (lazy).
- **Trial (one type, six files, every arm, one bout each, arrows printed):** arm B58's first-round arrows were exactly
  `CoachPlan.write`'s, and 20 of 20 paired bouts gave the same result with the board empty or with `CoachPlan.write`'s
  plan written by hand; C differed from B on every file (5 lines against 1). The control read (Lucy, coach's plan) read
  49.7-75.8 over the six files; TELLPLAY1's usual median for Lucy was 56.8 over 180 files - same range (the S544 fade fix
  moved the read a little since). A bout cost 27 ms, a read 6-8 ms.
- **A probe bug found and fixed in the run:** run a (types 0-4) played its B58 arm with no coach (my guard for an empty
  player plan matched B58 because the gym's coach is also 58). B58 for those types was replayed on the same files and dice
  (stage b58, 4,500 bouts) and the tables use the replay; the guard was fixed before run b (types 5-9).

## Honest limits

- 30 bouts a file and arm: 2 SE is 1.2-2.0 points per type on a difference, 0.3-0.6 over all types. Enough to say the plan's
  worth is 1-5 points per type, not enough to split it line by line inside one style (bar 4).
- C, C2 and F are chosen by the read. Since the read over-reads lines, a plan chosen on bouts might fight a little better;
  not measured (a bout-greedy plan costs about 50 times the bouts).
- One week (4), one rating (the same-rated man), the debut card; the auto corner plays rounds 2-4 (it may change one arrow
  between rounds, `BoutNight.gd:202-205`, the same in every arm).
- A `when` line was offered only on its situation's own card and the ropes card, not on every card.
- Earlier numbers this replaces (prior_research.py plan worth coach plan arrows; `tools/plan_effect_probe.gd` S397 and
  `DEPTH_AUDIT_S534` row 25): S397 none 45.0% / coach one card 52.8% / two 57.2% / a well-read plan 69.0% (one presser, 600
  close bouts), and S534's header comment good plan 59.0% / none 45.8% / bad 42.8%. **Today, over ten types and 300 files:
  none 40.9 / coach one card 42.1 / two 42.4 / the best style plan 43.8 / the best file plan 45.0 / the worst plan 37.7.**
  No plan to the best plan was 24 points (S397) and 13 (S534); it is now 4.1 (C2 - A). The coach's one card was worth 7.8 (S397), now 1.2.
  The read still shows numbers close to the old ones (none 42.5, best 59.1) - the old figures were read-sized.

## In plain words

(c) is true: **the plan barely beats the coach's.** Thinking about the plan wins about 2 more fights in 100 than letting the
coach write it, and reading the opponent's tape adds about 1 more. A careless plan or a single line costs about as little.
At the same time the plan card tells the player a good plan is worth 12-14 points: a player who designs carefully sees a big
number on the card and a small one in the results. Both numbers go to the coordinator; no design proposal here.

## Appendix: the summary script's full output (`python tools/planworth1_sum.py full_a.jsonl b58_a.jsonl full_b.jsonl`)

### Where the worth sits (arm C minus one line, real bouts): each line's share of C's gain over no plan (C - A)

| Type | opponent style | C's lines | C - A | each line's share (C - C-minus-i) / (C - A) | top share |
|---|---|---|---|---|---|
| Lucy Jackson | Boxer-puncher | 1-1, tie_up, step_back, pivot_out, 1-1-2 | +5.3 | 1-1 -12%, tie_up 0%, step_back 112%, pivot_out 12%, 1-1-2 62% | 112% |
| Lucy Jackson | Counter-puncher | 1-1, tie_up, step_back, 1-1-2, pivot_out | +0.7 | 1-1 200%, tie_up 0%, step_back 0%, 1-1-2 0%, pivot_out -300% | 200% |
| Lucy Jackson | Out-boxer | 1-2, tie_up, step_back, 1-1-2, pivot_out | +2.7 | 1-2 -50%, tie_up 0%, step_back -25%, 1-1-2 0%, pivot_out -50% | 0% |
| Lucy Jackson | Pressure fighter | tie_up, 1-1, step_back, pivot_out, 1-1-2 | +7.3 | tie_up 0%, 1-1 45%, step_back 45%, pivot_out 45%, 1-1-2 18% | 45% |
| Lucy Jackson | Slugger | tie_up, 1-1, step_back, pivot_out, 1-1-2 | +6.7 | tie_up 0%, 1-1 10%, step_back 50%, pivot_out 30%, 1-1-2 30% | 50% |
| Lucy Jackson | Volume puncher | 1-1, tie_up, step_back, pivot_out, 1-1-2 | +3.3 | 1-1 -20%, tie_up 0%, step_back 80%, pivot_out 100%, 1-1-2 0% | 100% |
| Kira Mensah | Boxer-puncher | 1-1, tie_up, pivot_out, 1-1-2 | -1.3 | 1-1 -50%, tie_up -0%, pivot_out -100%, 1-1-2 150% | 150% |
| Kira Mensah | Counter-puncher | 1-1, tie_up, 1-1-2, pivot_out | -0.7 | 1-1 -200%, tie_up -0%, 1-1-2 200%, pivot_out -0% | 200% |
| Kira Mensah | Out-boxer | 1-2, tie_up, 1-1-2, pivot_out | +1.3 | 1-2 -50%, tie_up 0%, 1-1-2 -50%, pivot_out 0% | 0% |
| Kira Mensah | Pressure fighter | 1-1, tie_up, pivot_out, 1-1-2 | +0.7 | 1-1 100%, tie_up 0%, pivot_out -200%, 1-1-2 100% | 100% |
| Kira Mensah | Slugger | 1-1, tie_up, pivot_out, 1-1-2 | +5.3 | 1-1 100%, tie_up 0%, pivot_out 0%, 1-1-2 25% | 100% |
| Kira Mensah | Volume puncher | 1-1, tie_up, pivot_out, 1-1-2 | -0.7 | 1-1 100%, tie_up -0%, pivot_out -0%, 1-1-2 -0% | 100% |
| Samira Khan | Boxer-puncher | tie_up, 1-2, step_back, pivot_out | +1.3 | tie_up 150%, 1-2 0%, step_back 0%, pivot_out 0% | 150% |
| Samira Khan | Counter-puncher | tie_up, 1-2, step_back, pivot_out | +4.0 | tie_up 117%, 1-2 -17%, step_back -33%, pivot_out 0% | 117% |
| Samira Khan | Out-boxer | tie_up, 1-2, step_back, pivot_out | +0.7 | tie_up 300%, 1-2 -200%, step_back -300%, pivot_out 0% | 300% |
| Samira Khan | Pressure fighter | tie_up, 1-2, pivot_out, step_back | +4.7 | tie_up 129%, 1-2 14%, pivot_out 0%, step_back -29% | 129% |
| Samira Khan | Slugger | tie_up, pivot_out, 1-2, step_back | +5.3 | tie_up 62%, pivot_out 0%, 1-2 50%, step_back 37% | 62% |
| Samira Khan | Volume puncher | tie_up, 1-2, step_back, pivot_out | +3.3 | tie_up 140%, 1-2 -40%, step_back -80%, pivot_out 0% | 140% |
| Tess Reilly | Boxer-puncher | tie_up, 1-2, step_back, pivot_out | +0.7 | tie_up 100%, 1-2 200%, step_back 0%, pivot_out 0% | 200% |
| Tess Reilly | Counter-puncher | tie_up, 1-2, step_back, pivot_out | +4.7 | tie_up 143%, 1-2 0%, step_back -14%, pivot_out 0% | 143% |
| Tess Reilly | Out-boxer | tie_up, 1-2, step_back, pivot_out | +3.3 | tie_up 20%, 1-2 60%, step_back 0%, pivot_out 0% | 60% |
| Tess Reilly | Pressure fighter | tie_up, 1-2, step_back, pivot_out | +2.7 | tie_up 125%, 1-2 50%, step_back -50%, pivot_out 0% | 125% |
| Tess Reilly | Slugger | tie_up, pivot_out, 1-2, step_back | +4.0 | tie_up 67%, pivot_out 0%, 1-2 100%, step_back -17% | 100% |
| Tess Reilly | Volume puncher | tie_up, 1-2, step_back, pivot_out | +0.0 | tie_up nan%, 1-2 nan%, step_back nan%, pivot_out nan% | nan% |
| Danny Osei | Boxer-puncher | tie_up, 1-2, step_back, pivot_out | +4.7 | tie_up 0%, 1-2 86%, step_back 86%, pivot_out 0% | 86% |
| Danny Osei | Counter-puncher | tie_up, 1-2, step_back, pivot_out | +0.0 | tie_up nan%, 1-2 nan%, step_back nan%, pivot_out nan% | nan% |
| Danny Osei | Out-boxer | 1-2, tie_up, step_back, pivot_out | +4.7 | 1-2 86%, tie_up 0%, step_back 14%, pivot_out 0% | 86% |
| Danny Osei | Pressure fighter | tie_up, step_back, 1-2, pivot_out | +5.3 | tie_up 0%, step_back 75%, 1-2 12%, pivot_out 25% | 75% |
| Danny Osei | Slugger | tie_up, step_back, 1-2, pivot_out | +0.0 | tie_up nan%, step_back nan%, 1-2 nan%, pivot_out nan% | nan% |
| Danny Osei | Volume puncher | tie_up, 1-2, step_back, pivot_out | +10.7 | tie_up 0%, 1-2 12%, step_back 69%, pivot_out 12% | 69% |
| Josh Harper | Boxer-puncher | tie_up, 1-2, step_back, pivot_out | +5.3 | tie_up 50%, 1-2 37%, step_back 0%, pivot_out 0% | 50% |
| Josh Harper | Counter-puncher | tie_up, 1-2, step_back, pivot_out | +4.0 | tie_up 150%, 1-2 -67%, step_back -17%, pivot_out 0% | 150% |
| Josh Harper | Out-boxer | tie_up, 1-2, step_back, pivot_out | +4.0 | tie_up 100%, 1-2 -33%, step_back -50%, pivot_out 0% | 100% |
| Josh Harper | Pressure fighter | tie_up, 1-2, pivot_out, step_back | +4.0 | tie_up 83%, 1-2 17%, pivot_out 0%, step_back 33% | 83% |
| Josh Harper | Slugger | tie_up, pivot_out, 1-2, step_back | +6.0 | tie_up 100%, pivot_out 0%, 1-2 11%, step_back 11% | 100% |
| Josh Harper | Volume puncher | tie_up, 1-2, step_back, pivot_out | +6.7 | tie_up 60%, 1-2 10%, step_back 40%, pivot_out 0% | 60% |
| Nell Ward | Boxer-puncher | tie_up, 1-1, slip 2-3, slip 2-3@own_ropes | +4.7 | tie_up 0%, 1-1 43%, slip 2-3 57%, slip 2-3@own_ropes -14% | 57% |
| Nell Ward | Counter-puncher | 1-1, tie_up, step_back, slip 2-3@own_ropes | -0.7 | 1-1 100%, tie_up -0%, step_back 100%, slip 2-3@own_ropes -0% | 100% |
| Nell Ward | Out-boxer | 1-2, tie_up, slip 2-3, pivot_out | -0.7 | 1-2 -400%, tie_up -0%, slip 2-3 -100%, pivot_out 100% | 100% |
| Nell Ward | Pressure fighter | slip 2-3, tie_up, 1-1, slip 2-3@own_ropes | +4.0 | slip 2-3 17%, tie_up 0%, 1-1 0%, slip 2-3@own_ropes -33% | 17% |
| Nell Ward | Slugger | slip 2-3, tie_up, 1-1, slip 2-3@own_ropes | +8.0 | slip 2-3 108%, tie_up 0%, 1-1 -17%, slip 2-3@own_ropes 8% | 108% |
| Nell Ward | Volume puncher | tie_up, slip 2-3, 1-1, slip 2-3@own_ropes | +2.0 | tie_up 0%, slip 2-3 -100%, 1-1 100%, slip 2-3@own_ropes 0% | 100% |
| Reece Doyle | Boxer-puncher | 1-1, tie_up, pivot_out, 1-1-2 | +2.7 | 1-1 -25%, tie_up 0%, pivot_out 0%, 1-1-2 50% | 50% |
| Reece Doyle | Counter-puncher | 1-1, tie_up, 1-1-2, pivot_out | -2.7 | 1-1 50%, tie_up -0%, 1-1-2 50%, pivot_out 25% | 50% |
| Reece Doyle | Out-boxer | 1-2, tie_up, 1-1-2, pivot_out | +1.3 | 1-2 -100%, tie_up 0%, 1-1-2 -50%, pivot_out 50% | 50% |
| Reece Doyle | Pressure fighter | 1-1, tie_up, pivot_out, 1-1-2 | +1.3 | 1-1 0%, tie_up 0%, pivot_out 50%, 1-1-2 0% | 50% |
| Reece Doyle | Slugger | 1-1, tie_up, pivot_out, 1-1-2 | +0.7 | 1-1 100%, tie_up 0%, pivot_out -200%, 1-1-2 0% | 100% |
| Reece Doyle | Volume puncher | 1-1, tie_up, pivot_out, 1-1-2 | +4.0 | 1-1 17%, tie_up 0%, pivot_out 0%, 1-1-2 0% | 17% |
| Bayo Adams | Boxer-puncher | tie_up, 1-2, step_back, pivot_out | +7.3 | tie_up 118%, 1-2 0%, step_back -18%, pivot_out 0% | 118% |
| Bayo Adams | Counter-puncher | tie_up, 1-2, step_back, pivot_out | +8.0 | tie_up 100%, 1-2 -8%, step_back 8%, pivot_out 0% | 100% |
| Bayo Adams | Out-boxer | tie_up, 1-2, step_back, pivot_out | +2.0 | tie_up 167%, 1-2 -33%, step_back -33%, pivot_out 0% | 167% |
| Bayo Adams | Pressure fighter | tie_up, 1-2, pivot_out, step_back | +3.3 | tie_up 120%, 1-2 0%, pivot_out 0%, step_back 20% | 120% |
| Bayo Adams | Slugger | tie_up, pivot_out, 1-2, step_back | +4.0 | tie_up 33%, pivot_out 0%, 1-2 33%, step_back 33% | 33% |
| Bayo Adams | Volume puncher | tie_up, 1-2, step_back, pivot_out | +6.7 | tie_up 140%, 1-2 -30%, step_back -40%, pivot_out 0% | 140% |
| Kai Turner | Boxer-puncher | tie_up, 1-1, step_back, pivot_out | -0.7 | tie_up -0%, 1-1 -100%, step_back 200%, pivot_out -0% | 200% |
| Kai Turner | Counter-puncher | tie_up, 1-1, step_back, pivot_out | -0.7 | tie_up -0%, 1-1 -0%, step_back 100%, pivot_out -0% | 100% |
| Kai Turner | Out-boxer | 1-2, tie_up, step_back, pivot_out | +2.7 | 1-2 100%, tie_up 0%, step_back 0%, pivot_out 0% | 100% |
| Kai Turner | Pressure fighter | tie_up, 1-1, step_back, pivot_out | -1.3 | tie_up -0%, 1-1 -50%, step_back 100%, pivot_out -0% | 100% |
| Kai Turner | Slugger | tie_up, 1-1, step_back, pivot_out | -2.7 | tie_up -0%, 1-1 125%, step_back 75%, pivot_out -0% | 125% |
| Kai Turner | Volume puncher | tie_up, 1-1, step_back, pivot_out | -1.3 | tie_up -0%, 1-1 -0%, step_back 150%, pivot_out -0% | 150% |

### Does the best plan differ (arm C2, one plan a file)

| Type | files | different C2 plans | most common plan: files | share |
|---|---|---|---|---|
| Lucy Jackson | 30 | 7 | 1-1-2@ + 1-1@ + 1-2@range + pivot_out@press + step_back@ + tie_up@: 11 | 37% |
| Kira Mensah | 30 | 6 | 1-1-2@ + 1-1@ + 1-2@range + pivot_out@press + tie_up@she_tired: 14 | 47% |
| Samira Khan | 30 | 8 | 1-2@ + 3b-3@inside@tiring + pivot_out@she_hurt + step_back@press + tie_up@own_ropes@loadup + tie_up@she_tired: 10 | 33% |
| Tess Reilly | 30 | 9 | 1-2@ + 3b-3@inside@tiring + pivot_out@she_hurt + step_back@press + tie_up@own_ropes@loadup + tie_up@she_tired: 10 | 33% |
| Danny Osei | 30 | 11 | 1-2@ + feint@counter + pivot_out@press + step_back@ + tie_up@she_tired: 8 | 27% |
| Josh Harper | 30 | 9 | 1-2@ + 3b-3@inside@tiring + pivot_out@she_hurt + step_back@press + tie_up@own_ropes@loadup + tie_up@she_tired: 10 | 33% |
| Nell Ward | 30 | 13 | 1-1@ + 1-2@range + pivot_out@press + slip 2-3@ + slip 2-3@own_ropes@ + tie_up@: 8 | 27% |
| Reece Doyle | 30 | 8 | 1-1-2@ + 1-1@ + 1-2@range + pivot_out@press + tie_up@she_tired: 9 | 30% |
| Bayo Adams | 30 | 10 | 1-2@ + 3b-3@ + 3b-3@inside@tiring + pivot_out@she_hurt + step_back@loadup + tie_up@she_tired: 11 | 37% |
| Kai Turner | 30 | 8 | 1-1@ + 1-2@range + 3b-3@inside@tiring + pivot_out@press + step_back@loadup + tie_up@she_tired: 8 | 27% |

### Arm C's plans (style only, one per opponent style) and arm E (careless)

- Lucy Jackson vs Boxer-puncher: C = 1-1, tie_up, step_back, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, 1-2 | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Lucy Jackson vs Counter-puncher: C = 1-1, tie_up, step_back, 1-1-2, pivot_out | B58 = 1-1-2 | B74 = 1-1-2, 1-2 | E = 1-1, step_in, herd, tie_up, push_off
- Lucy Jackson vs Out-boxer: C = 1-2, tie_up, step_back, 1-1-2, pivot_out | B58 = 1-2 | B74 = 1-2, 1-1-2 | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Lucy Jackson vs Pressure fighter: C = tie_up, 1-1, step_back, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, pivot_out | E = 1-1, step_in, herd, tie_up, push_off
- Lucy Jackson vs Slugger: C = tie_up, 1-1, step_back, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, tie_up@own_ropes | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Lucy Jackson vs Volume puncher: C = 1-1, tie_up, step_back, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, 1-2 | E = 1-1, step_in, herd, tie_up, push_off
- Kira Mensah vs Boxer-puncher: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, 1-2 | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Kira Mensah vs Counter-puncher: C = 1-1, tie_up, 1-1-2, pivot_out | B58 = 1-1-2 | B74 = 1-1-2, 1-2 | E = 1-1, step_in, herd, tie_up, push_off
- Kira Mensah vs Out-boxer: C = 1-2, tie_up, 1-1-2, pivot_out | B58 = 1-2 | B74 = 1-2, 1-1-2 | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Kira Mensah vs Pressure fighter: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, pivot_out | E = 1-1, step_in, herd, tie_up, push_off
- Kira Mensah vs Slugger: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, tie_up@own_ropes | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Kira Mensah vs Volume puncher: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, 1-2 | E = 1-1, step_in, herd, tie_up, push_off
- Samira Khan vs Boxer-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Samira Khan vs Counter-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Samira Khan vs Out-boxer: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Samira Khan vs Pressure fighter: C = tie_up, 1-2, pivot_out, step_back | B58 = 1-2 | B74 = 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Samira Khan vs Slugger: C = tie_up, pivot_out, 1-2, step_back | B58 = tie_up@own_ropes | B74 = tie_up@own_ropes, 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Samira Khan vs Volume puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Tess Reilly vs Boxer-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Tess Reilly vs Counter-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Tess Reilly vs Out-boxer: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Tess Reilly vs Pressure fighter: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Tess Reilly vs Slugger: C = tie_up, pivot_out, 1-2, step_back | B58 = tie_up@own_ropes | B74 = tie_up@own_ropes, 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Tess Reilly vs Volume puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Danny Osei vs Boxer-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = step_back | B74 = step_back, 1-2 | E = 1-2-3, step_in, pivot_out, herd, tie_up, push_off
- Danny Osei vs Counter-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = feint | B74 = feint, 1-2 | E = 1-2-3, step_in, herd, tie_up, push_off
- Danny Osei vs Out-boxer: C = 1-2, tie_up, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, feint | E = 1-2-3, step_in, pivot_out, herd, tie_up, push_off
- Danny Osei vs Pressure fighter: C = tie_up, step_back, 1-2, pivot_out | B58 = step_back | B74 = step_back, pivot_out | E = 1-2-3, step_in, herd, tie_up, push_off
- Danny Osei vs Slugger: C = tie_up, step_back, 1-2, pivot_out | B58 = step_back | B74 = step_back, tie_up@own_ropes | E = 1-2-3, step_in, pivot_out, herd, tie_up, push_off
- Danny Osei vs Volume puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = step_back | B74 = step_back, 1-2 | E = 1-2-3, step_in, herd, tie_up, push_off
- Josh Harper vs Boxer-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Josh Harper vs Counter-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Josh Harper vs Out-boxer: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Josh Harper vs Pressure fighter: C = tie_up, 1-2, pivot_out, step_back | B58 = 1-2 | B74 = 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Josh Harper vs Slugger: C = tie_up, pivot_out, 1-2, step_back | B58 = tie_up@own_ropes | B74 = tie_up@own_ropes, 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Josh Harper vs Volume puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 3b-3, step_in, herd, tie_up, push_off, 1-2-3-2
- Nell Ward vs Boxer-puncher: C = tie_up, 1-1, slip 2-3, slip 2-3@own_ropes | B58 = slip 2-3 | B74 = slip 2-3, 1-2 | E = pivot_out, roll_out, step_out, step_in, herd, push_off
- Nell Ward vs Counter-puncher: C = 1-1, tie_up, step_back, slip 2-3@own_ropes | B58 = feint | B74 = feint, 1-2 | E = roll_out, step_out, step_in, herd, push_off
- Nell Ward vs Out-boxer: C = 1-2, tie_up, slip 2-3, pivot_out | B58 = 1-2 | B74 = 1-2, feint | E = pivot_out, roll_out, step_out, step_in, herd, push_off
- Nell Ward vs Pressure fighter: C = slip 2-3, tie_up, 1-1, slip 2-3@own_ropes | B58 = slip 2-3 | B74 = slip 2-3, pivot_out | E = roll_out, step_out, step_in, herd, push_off
- Nell Ward vs Slugger: C = slip 2-3, tie_up, 1-1, slip 2-3@own_ropes | B58 = slip 2-3 | B74 = slip 2-3, tie_up@own_ropes | E = pivot_out, roll_out, step_out, step_in, herd, push_off
- Nell Ward vs Volume puncher: C = tie_up, slip 2-3, 1-1, slip 2-3@own_ropes | B58 = slip 2-3 | B74 = slip 2-3, 1-2 | E = roll_out, step_out, step_in, herd, push_off
- Reece Doyle vs Boxer-puncher: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, 1-2 | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Reece Doyle vs Counter-puncher: C = 1-1, tie_up, 1-1-2, pivot_out | B58 = 1-1-2 | B74 = 1-1-2, 1-2 | E = 1-1, step_in, herd, tie_up, push_off
- Reece Doyle vs Out-boxer: C = 1-2, tie_up, 1-1-2, pivot_out | B58 = 1-2 | B74 = 1-2, 1-1-2 | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Reece Doyle vs Pressure fighter: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, pivot_out | E = 1-1, step_in, herd, tie_up, push_off
- Reece Doyle vs Slugger: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, tie_up@own_ropes | E = 1-1, step_in, pivot_out, herd, tie_up, push_off
- Reece Doyle vs Volume puncher: C = 1-1, tie_up, pivot_out, 1-1-2 | B58 = step_back | B74 = step_back, 1-2 | E = 1-1, step_in, herd, tie_up, push_off
- Bayo Adams vs Boxer-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Bayo Adams vs Counter-puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Bayo Adams vs Out-boxer: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Bayo Adams vs Pressure fighter: C = tie_up, 1-2, pivot_out, step_back | B58 = 1-2 | B74 = 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Bayo Adams vs Slugger: C = tie_up, pivot_out, 1-2, step_back | B58 = tie_up@own_ropes | B74 = tie_up@own_ropes, 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Bayo Adams vs Volume puncher: C = tie_up, 1-2, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = step_in, 3b-3, tie_up, push_off, 1-2-3, herd
- Kai Turner vs Boxer-puncher: C = tie_up, 1-1, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = 1-2-3-2, step_in, 3b-3, herd, tie_up, pivot_out
- Kai Turner vs Counter-puncher: C = tie_up, 1-1, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 1-2-3-2, step_in, 3b-3, herd, tie_up, push_off
- Kai Turner vs Out-boxer: C = 1-2, tie_up, step_back, pivot_out | B58 = 1-2 | B74 = 1-2, tie_up@own_ropes | E = 1-2-3-2, step_in, 3b-3, herd, tie_up, pivot_out
- Kai Turner vs Pressure fighter: C = tie_up, 1-1, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 1-2-3-2, step_in, 3b-3, herd, tie_up, push_off
- Kai Turner vs Slugger: C = tie_up, 1-1, step_back, pivot_out | B58 = tie_up@own_ropes | B74 = tie_up@own_ropes, 1-2 | E = 1-2-3-2, step_in, 3b-3, herd, tie_up, pivot_out
- Kai Turner vs Volume puncher: C = tie_up, 1-1, step_back, pivot_out | B58 = 1-2 | B74 = 1-2 | E = 1-2-3-2, step_in, 3b-3, herd, tie_up, push_off

### Bars

- (1) PLANNING PAYS (C-B58 >= 5 and C-B74 >= 3, 6 of 10 types): 1 of 10 -> FAIL [Bayo Adams]
- (2) THE TAPE PAYS (C2-C >= 3, 6 of 10): 1 of 10 -> FAIL [Kai Turner]
- (3) A CARELESS PLAN COSTS (E < B58, 6 of 10): 6 of 10 -> PASS [Lucy Jackson, Kira Mensah, Danny Osei, Nell Ward, Reece Doyle, Kai Turner]
- (4) NOT ONE LINE (one line > 60% of C's gain in most styles, for no more than half the types): 7 of 10 types one-line -> FAIL [Kira Mensah, Samira Khan, Tess Reilly, Danny Osei, Josh Harper, Bayo Adams, Kai Turner]
- (5) NOT ONE PLAN (no type with one C2 plan on > half its files): 0 types with one plan -> PASS [none]
- (6) NO TRAP (D not below B58 by more than 2): 0 types below -> PASS [none]

### Read vs bout: arms where the mean read and the mean bout differ by more than 3 points

- Lucy Jackson A: bout 51.6, read 56.7
- Lucy Jackson B40: bout 51.6, read 56.7
- Lucy Jackson B58: bout 53.3, read 59.1
- Lucy Jackson B74: bout 54.2, read 61.9
- Lucy Jackson C: bout 55.9, read 72.4
- Lucy Jackson C2: bout 57.8, read 74.4
- Lucy Jackson D: bout 52.4, read 62.9
- Lucy Jackson E: bout 50.9, read 67.0
- Kira Mensah B74: bout 45.1, read 48.3
- Kira Mensah C: bout 44.7, read 55.8
- Kira Mensah C2: bout 45.3, read 57.5
- Kira Mensah D: bout 44.9, read 50.6
- Kira Mensah E: bout 42.8, read 53.8
- Kira Mensah F: bout 40.4, read 36.7
- Samira Khan C: bout 36.2, read 48.4
- Samira Khan C2: bout 36.4, read 52.4
- Samira Khan D: bout 36.4, read 46.1
- Samira Khan E: bout 37.8, read 44.1
- Samira Khan F: bout 31.3, read 20.2
- Tess Reilly C: bout 35.9, read 44.4
- Tess Reilly C2: bout 36.6, read 49.6
- Tess Reilly D: bout 35.1, read 42.0
- Tess Reilly E: bout 35.9, read 39.8
- Tess Reilly F: bout 29.1, read 19.0
- Danny Osei A: bout 45.9, read 51.0
- Danny Osei B40: bout 45.9, read 51.0
- Danny Osei B58: bout 48.0, read 53.5
- Danny Osei B74: bout 48.3, read 54.9
- Danny Osei C: bout 50.1, read 63.0
- Danny Osei C2: bout 51.2, read 63.5
- Danny Osei D: bout 46.2, read 57.1
- Danny Osei E: bout 44.1, read 55.6
- Josh Harper A: bout 35.4, read 39.6
- Josh Harper B40: bout 35.4, read 39.6
- Josh Harper B58: bout 36.4, read 41.8
- Josh Harper B74: bout 36.2, read 41.9
- Josh Harper C: bout 40.4, read 54.0
- Josh Harper C2: bout 40.8, read 57.8
- Josh Harper D: bout 39.6, read 51.5
- Josh Harper E: bout 39.8, read 49.0
- Josh Harper F: bout 32.1, read 26.2
- Nell Ward A: bout 49.2, read 56.2
- Nell Ward B40: bout 49.2, read 56.2
- Nell Ward B58: bout 50.8, read 61.1
- Nell Ward B74: bout 51.2, read 62.0
- Nell Ward C: bout 52.1, read 70.9
- Nell Ward C2: bout 54.2, read 72.4
- Nell Ward D: bout 51.2, read 62.9
- Nell Ward E: bout 45.1, read 51.5
- Reece Doyle A: bout 43.8, read 48.3
- Reece Doyle B40: bout 43.8, read 48.3
- Reece Doyle B58: bout 45.0, read 49.5
- Reece Doyle B74: bout 45.7, read 51.8
- Reece Doyle C: bout 45.0, read 59.5
- Reece Doyle C2: bout 46.0, read 61.1
- Reece Doyle D: bout 44.8, read 54.2
- Reece Doyle E: bout 44.2, read 57.6
- Bayo Adams A: bout 38.8, read 35.2
- Bayo Adams B40: bout 38.8, read 35.2
- Bayo Adams C: bout 44.0, read 52.7
- Bayo Adams C2: bout 44.2, read 56.4
- Bayo Adams D: bout 43.7, read 50.3
- Bayo Adams E: bout 44.3, read 48.2
- Bayo Adams F: bout 35.6, read 23.1
- Kai Turner A: bout 34.6, read 31.3
- Kai Turner B40: bout 34.6, read 31.3
- Kai Turner C: bout 33.9, read 42.8
- Kai Turner C2: bout 37.7, read 46.2
- Kai Turner F: bout 31.9, read 24.3
- ALL B74: bout 42.4, read 45.7
- ALL C: bout 43.8, read 56.4
- ALL C2: bout 45.0, read 59.1
- ALL D: bout 43.0, read 51.5
- ALL E: bout 41.9, read 50.2
- ALL F: bout 37.7, read 32.4

