# LADDERPROBE4 result - the ladder table over two years with newcomers, the R8 free week, the season close and the rival gyms' calls (R9)

Probe run: 2026-11-18T20:09:30. 30 seeds x 2 clubs = 60 runs of 735 days (seeds 4421..4450), 534s. A measurement only: no rule or constant was changed.

The scope (LADDERWIRE_SCOPE_S515) asks of every ladder stage: **a season's table stays sane - points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over.** This probe plays two seasons and reads the table the game sorts (Region.rankings, ladder points first since S516) every 28 days. LADDERPROBE1 (S516) and LADDERPROBE2 (S517, before these fixes) printed the same tables at the same marks [0, 364, 728], so the three compare. LADDERPROBE4 (S518) keeps every one of those tables and adds R9: the rival gyms' calls are answered here (the run seed's policy, tools/ladder_probe_offers.gd) instead of lapsing as a pass, so the numbers below differ from LADDERPROBE3's wherever a call took a night or paid points - the R9 section at the end reads the two side by side. The S517 fixes measured here: the newcomer sheet (Newcomers - a novice with nobody legal on her sheet gets a newcomer novice on it), the R8 free week (Region._free_week - the idle clock waits while our boxer is booked, injured or has no legal name in reach) and the season close (LadderSeason - 1 January keeps each division's final table). The run is 735 days so both closes (day 361 = 1 Jan 2027, day 726 = 1 Jan 2028) fall inside it; the last mark stays 728.
## Population

- **QUICK**: a quick-start career, Lucy signed at reception (Sim.sign, the interview's three cards), Reid hired. One boxer (wlw). **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww) and Ana on the mats, Reid hired. Three boxers, three classes.
- Both past the first-week guide and the first hour. Rivals' invented pasts re-seeded to the run seed, so a replay agrees. No fighter is synthesized or copied: the clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical. 30 seeds a club, 735 days each through Sim.step_day - the real day loop: offers, camps, fight weeks, weigh-ins, the game's own bout sim, injuries, pull-outs, late asks, the region's own club shows (Region._rival_bout moves both rivals' points), the newcomers' own shows and the season close. Cash floored at $20000 as two_boxers_two_years_test does; money is not the measurement.
- Decisions in code, every open need answered as TestJump._tidy / _to_nationals answer them: every sheet offer accepted (Bouts.accept; the unsafe mismatch pair is left as the game leaves it), the fight week drafted and locked on the best-ranked free partners, the camp started, the weigh-in taken, the bout fought by the sim, the week review closed, the office goal five_round_engine, an injury past the bell pulled out, a fall-through answered with the replacement (else go home), a host's late ask declined (_tidy's NO), a rival club's approach matched so the boxer stays, a rival gym's call answered the day it opens by the run seed's policy (seed % 3: accept / not_this_show / pass, tools/ladder_probe_offers.gd). Pro offers declined (Roster.decline_pro): the two years stay on the amateur ladder the probe measures. The nationals are never entered.
## How the table is read

- Every 28 days, for every division that has rivals, Region.rankings(c, div) is read and each row's points recorded (a row with no "rep" yet reads at its seed, RankLine.rep). Our boxers enter the table at 4 wins (Region.RANK_MIN_WINS) and leave it if they turn pro. **Top-3 turnover** = the different names that held a top-3 place at any sample over the two years; **bottom half** = a day-0 rank below the middle of that day's table (rank > rows/2); **new** = not in the day-0 table at all; **kept** = of the day-0 top 3, still in the top 3 at the last sample.
- **Stuck** = a row whose points are exactly where they were 84 days ago AND that had at least one bout in that window (a rival's RivalPast file, newest first; one of ours from Career.results, amateur bouts only). A row with no bout in the window is **idle**, not stuck: a never-boxing rival keeps a seed that cannot move (the brief's trap). A newcomer's invented past is seeded before her joined day, so it is not counted as her bout either. **Cap-stuck** = stuck at 0 or 100. Stuck is counted at every sample from day 84 on; the day-0 column has no window yet. A row that was not in the table 84 days earlier (one of ours entering at 4 wins) counts as active, not stuck: there is no earlier reading to compare. **Never boxed** = a rival with no bout at all in the 735 days, reported separately, never counted as stuck.
## Per division: the points at day [0, 364, 728]

| division | day | rows | min | median | max | at 0 | at 100 | stuck (of active) | cap-stuck | idle |
|---|---|---|---|---|---|---|---|---|---|---|
| wlw | 0 | 660 | 10 | 22.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wlw | 364 | 766 | 0 | 22.0 | 67 | 62 (8.1%) | 0 (0.0%) | 7.8% (58/742) | 44 | 3.1% |
| wlw | 728 | 754 | 0 | 18.0 | 69 | 113 (15.0%) | 0 (0.0%) | 8.7% (62/710) | 47 | 5.8% |
| wfw | 0 | 300 | 10 | 20.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wfw | 364 | 337 | 0 | 20.0 | 73 | 38 (11.3%) | 0 (0.0%) | 5.9% (18/307) | 10 | 8.9% |
| wfw | 728 | 311 | 0 | 23.0 | 94 | 63 (20.3%) | 0 (0.0%) | 16.2% (50/309) | 41 | 0.6% |
| www | 0 | 300 | 14 | 22.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| www | 364 | 300 | 0 | 22.0 | 74 | 48 (16.0%) | 0 (0.0%) | 4.2% (10/240) | 4 | 20.0% |
| www | 728 | 240 | 0 | 30.5 | 96 | 54 (22.5%) | 0 (0.0%) | 24.2% (58/240) | 50 | 0.0% |
| wlm | 0 | 360 | 27 | 35.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wlm | 364 | 360 | 0 | 31.5 | 90 | 58 (16.1%) | 0 (0.0%) | 3.3% (10/300) | 0 | 16.7% |
| wlm | 728 | 300 | 0 | 41.0 | 100 | 43 (14.3%) | 5 (1.7%) | 10.7% (32/300) | 20 | 0.0% |
| wmw | 0 | 300 | 11 | 27.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wmw | 364 | 300 | 0 | 23.0 | 83 | 53 (17.7%) | 0 (0.0%) | 6.7% (16/240) | 6 | 20.0% |
| wmw | 728 | 240 | 0 | 32.5 | 100 | 53 (22.1%) | 3 (1.3%) | 20.0% (48/240) | 41 | 0.0% |
| mfw | 0 | 240 | 34 | 43.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mfw | 364 | 180 | 19 | 42.0 | 82 | 0 (0.0%) | 0 (0.0%) | 7.2% (13/180) | 0 | 0.0% |
| mfw | 728 | 180 | 1 | 31.0 | 95 | 0 (0.0%) | 0 (0.0%) | 5.6% (10/180) | 0 | 0.0% |
| mlw | 0 | 240 | 26 | 41.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mlw | 364 | 180 | 10 | 41.0 | 85 | 0 (0.0%) | 0 (0.0%) | 3.9% (7/180) | 0 | 0.0% |
| mlw | 728 | 180 | 0 | 36.0 | 97 | 13 (7.2%) | 0 (0.0%) | 8.4% (15/179) | 6 | 0.6% |
| mww | 0 | 270 | 22 | 41.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mww | 364 | 247 | 0 | 35.0 | 90 | 2 (0.8%) | 0 (0.0%) | 4.1% (10/244) | 0 | 1.2% |
| mww | 728 | 247 | 0 | 37.0 | 100 | 27 (10.9%) | 4 (1.6%) | 11.8% (29/245) | 22 | 0.8% |
| mmw | 0 | 240 | 28 | 49.5 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mmw | 364 | 240 | 0 | 44.0 | 100 | 1 (0.4%) | 1 (0.4%) | 4.6% (11/240) | 0 | 0.0% |
| mmw | 728 | 240 | 0 | 41.5 | 100 | 57 (23.8%) | 12 (5.0%) | 39.6% (95/240) | 51 | 0.0% |

## Per division: the top 3 over two years (means a run)

| division | runs | distinct top-3 names | from bottom half | new to the table | day-0 top 3 kept | never boxed | rows at day 0 |
|---|---|---|---|---|---|---|---|
| wlw | 60 | 7.4 | 1.40 | 1.03 | 1.30 | 0.00 | 11.00 |
| wfw | 60 | 5.0 | 2.45 | 0.53 | 2.20 | 0.00 | 5.00 |
| www | 60 | 4.9 | 2.93 | 0.00 | 2.98 | 0.00 | 5.00 |
| wlm | 60 | 4.5 | 1.55 | 0.00 | 2.00 | 0.00 | 6.00 |
| wmw | 60 | 4.4 | 2.40 | 0.00 | 2.52 | 0.00 | 5.00 |
| mfw | 60 | 4.0 | 1.98 | 0.00 | 3.00 | 1.00 | 4.00 |
| mlw | 60 | 3.5 | 1.50 | 0.00 | 3.00 | 1.00 | 4.00 |
| mww | 60 | 4.0 | 1.92 | 0.03 | 2.47 | 0.50 | 4.50 |
| mmw | 60 | 4.0 | 1.95 | 0.00 | 2.90 | 0.00 | 4.00 |

## Our boxers' points (means a run; min-max across seeds)

| club | boxer | division | runs | left mid-run | day 364 | day 728 | bouts fought | w | l | rank | no legal name at end | same points at both marks |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | wlw | 30 | 0 | 43.0 (24-50) | 59.0 (51-69) | 19.5 | 20.2-3.2 | 1.1 | 0 | 0 |
| TEST | Josh Harper | mww | 30 | 0 | 33.0 (26-48) | 52.5 (34-64) | 18.1 | 16.0-8.1 | 2.1 | 0 | 1 |
| TEST | Kira Mensah | wfw | 30 | 0 | 35.5 (21-42) | 35.5 (4-62) | 18.0 | 14.5-4.6 | 2.7 | 0 | 1 |
| TEST | Lucy Jackson | wlw | 30 | 0 | 43.0 (24-50) | 59.0 (51-69) | 19.5 | 20.2-3.2 | 1.1 | 0 | 0 |

**Bouts fought** counts only the bouts of the run; **w-l** is the whole record, the walk-in's past included. **No legal name at end** = at day 728 our boxer was still a novice (AmateurBooking.NOVICE_MAX_BOUTS 10) while every name on the sheet the matchmaker actually offers (Newcomers.sheet: the division's own names plus its newcomers) had graduated past 10 bouts: Bouts.legal_index falls back to the next name in turn, _offer flags it mismatch and Bouts.accept refuses a mismatch, so the clock runs on with no bout to take. LADDERPROBE2 measured this on the division's own names alone, before Newcomers existed; here the sheet is the shipped one. **Same points at both marks** = the identical reading at day 364 and day 728 - the freeze that follows. Both should fall to ~0 with the S517 fixes: the newcomer refills the sheet, and the R8 free week stops the idle drain while no legal name is in reach. The shipped rules are measured, not changed.
## The newcomers (Newcomers.arrive, read at day 728)

A novice of ours with nobody legal on her sheet gets a newcomer novice on it (0-2 bouts, a little under the sheet's level, at most 3 a sheet; the oldest graduated one leaves the sheet and keeps her table row). She boxes at the region's shows like any rival, so she in turn graduates and the next one arrives. **Arrived** = newcomers on the division's books at day 728 (none is ever deleted). **Bouts** = her record w+l then, the number the matchmaker reads; **boxed** = real bouts since her joined day; **graduated** = past 10 bouts; **our bouts** = bouts she fought against our gym. A division where we have no boxer never needs a newcomer, so it shows 0.

| division | runs | arrived a run | still on the sheet | graduated | bouts at day 728 | boxed since joining | our bouts against her |
|---|---|---|---|---|---|---|---|
| wlw | 60 | 0.77 | 0.77 | 0.07 | 6.7 (4-15) | 5.2 (2-13) | 3.03 |
| wfw | 60 | 0.18 | 0.18 | 0.00 | 5.7 (3-8) | 4.2 (1-7) | 0.77 |
| www | 60 | 0.00 | 0.00 | 0.00 | - | - | 0.00 |
| wlm | 60 | 0.00 | 0.00 | 0.00 | - | - | 0.00 |
| wmw | 60 | 0.00 | 0.00 | 0.00 | - | - | 0.00 |
| mfw | 60 | 0.00 | 0.00 | 0.00 | - | - | 0.00 |
| mlw | 60 | 0.00 | 0.00 | 0.00 | - | - | 0.00 |
| mww | 60 | 0.12 | 0.12 | 0.00 | 5.1 (3-7) | 3.7 (2-5) | 0.43 |
| mmw | 60 | 0.00 | 0.00 | 0.00 | - | - | 0.00 |

## The season tables (LadderSeason.close on 1 January: day 361 = 1 Jan 2027, day 726 = 1 Jan 2028)

Points carry over untouched; each division's final table is kept on the career (c.seasons, newest last): the top 10 rows plus our own, with the full table's size beside them. One entry a division a season - 60 runs, so a division with a table in both seasons shows 60 runs below and 0 means it never had one. **Winner's points** is the leader's rep at the close, carried into the next season. Our boxers' place in each final table follows (means a run; min-max across seeds).

| division | season | runs with a table | rows kept | full table | our rows | winner's points |
|---|---|---|---|---|---|---|
| wlw | 2026 | 60 | 10.00 | 12.77 | 1.00 | 47.8 |
| wlw | 2027 | 60 | 10.00 | 12.57 | 1.00 | 59.3 |
| wfw | 2026 | 60 | 5.62 | 5.62 | 0.50 | 55.7 |
| wfw | 2027 | 60 | 5.18 | 5.18 | 0.50 | 76.5 |
| www | 2026 | 60 | 5.00 | 5.00 | 0.00 | 58.3 |
| www | 2027 | 60 | 4.00 | 4.00 | 0.00 | 79.0 |
| wlm | 2026 | 60 | 6.00 | 6.00 | 0.00 | 79.2 |
| wlm | 2027 | 60 | 5.00 | 5.00 | 0.00 | 90.3 |
| wmw | 2026 | 60 | 5.00 | 5.00 | 0.00 | 67.9 |
| wmw | 2027 | 60 | 4.00 | 4.00 | 0.00 | 87.5 |
| mfw | 2026 | 60 | 3.00 | 3.00 | 0.00 | 76.2 |
| mfw | 2027 | 60 | 3.00 | 3.00 | 0.00 | 82.7 |
| mlw | 2026 | 60 | 3.00 | 3.00 | 0.00 | 73.5 |
| mlw | 2027 | 60 | 3.00 | 3.00 | 0.00 | 83.0 |
| mww | 2026 | 60 | 4.12 | 4.12 | 0.50 | 80.1 |
| mww | 2027 | 60 | 4.12 | 4.12 | 0.50 | 85.6 |
| mmw | 2026 | 60 | 4.00 | 4.00 | 0.00 | 88.8 |
| mmw | 2027 | 60 | 4.00 | 4.00 | 0.00 | 97.5 |


| club | boxer | division | season | runs in the table | place | points | of (full table) |
|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | wlw | 2026 | 30 | 2.5 (1-6) | 40.4 (24-50) | 12.8 |
| QUICK | Lucy Jackson | wlw | 2027 | 30 | 1.1 (1-2) | 58.8 (51-68) | 12.6 |
| TEST | Josh Harper | mww | 2026 | 30 | 2.8 (2-4) | 35.8 (28-48) | 5.2 |
| TEST | Josh Harper | mww | 2027 | 30 | 2.1 (2-3) | 52.1 (34-64) | 5.2 |
| TEST | Kira Mensah | wfw | 2026 | 30 | 2.3 (1-4) | 34.3 (21-42) | 6.2 |
| TEST | Kira Mensah | wfw | 2027 | 30 | 2.9 (1-5) | 33.8 (4-62) | 6.4 |
| TEST | Lucy Jackson | wlw | 2026 | 30 | 2.5 (1-6) | 40.4 (24-50) | 12.8 |
| TEST | Lucy Jackson | wlw | 2027 | 30 | 1.1 (1-2) | 58.8 (50-68) | 12.6 |

## The three lines

**Points spread 0-100? YES** - at day 728, 2692 rows pooled: min 0, median 26.5, max 100; 423 rows at 0 (15.7%), 24 at 100 (0.9%).

**Anyone stuck at a cap? YES** - 2342 rows sat at 0 or 100 with a bout in the window and no points moved in 84 days (4829 stuck rows of 63277 active, all windows day 84-728).

**Does the top 3 turn over? YES** - 4.63 different names held a top-3 place over the two years (3 seats), 2.01 of them started in the bottom half, 0.18 were not in the day-0 table; 2.49 of the day-0 top 3 still hold a seat at day 728.

Read: 540 division-runs, 5.39 rows a table at day 0. Over every 84-day window from day 84 to 728, 4829 of 63277 active rows did not move (7.6%), 2342 of them at a cap; 5105 of 68382 rows were idle (no bout in the window). 0.28 rivals a division never boxed at all in the two years - their seed is the order they keep, and they are not counted as stuck. The bunching is uneven: at day 728 the rows sitting at a cap run from 0.0% (mfw) to 28.8% (mmw). The S517 fixes: 64 newcomers arrived over the 60 runs and boxed 254 bouts against our gym; our boxers ended with no legal name on the shipped sheet in 0 runs and the same points at both marks in 2. The fight week lock refused 0 weeks; runs closed early: 0.

## R9: the rival gyms' phone calls (LADDERPROBE4)

A measurement of the shipped R9 (scripts/rules/RivalOffer.gd, scripts/state/RivalOfferWire.gd, the card scripts/ui/RivalOfferCard.gd): every Monday a rival below our boxer on the ladder, in reach and legal, may ring for a bout at the next region show 7-21 days out. Only a ranked boxer is rung (4 wins, Region.RANK_MIN_WINS); at most one call every 4 weeks a boxer (RivalOfferWire.OFFER_GAP_WEEKS), and a rival rings again only after its own 8 weeks (RivalOffer.COOLDOWN_WEEKS). The call is answered here the day it opens, in the same pass that answers the host's late ask - LADDERPROBE3 left every call unanswered, to lapse as a pass (-2 points) four days later. Nothing is changed in the rules: the probe only answers.

The answer policy is the run seed's, so all three answers are measured on the same population: seed % 3 == 0 **accept** (books that show through the sheet's own path), 1 **not_this_show** (free once a season with that rival; when RivalOfferWire.view's nts_left is false it falls to **pass**), 2 **pass** (-2 ladder points to the challenger, free while hurt or booked). A refused answer - RivalOfferWire.answer returning a reason instead of "" - is counted in its own column; the call it leaves waiting lapses as the game's own pass, counted beside it. **A boxer-season** is one of our amateurs in one calendar year (Clock: day 0 is Mon 5 Jan 2026, so the two seasons played are 2026 and 2027 and the run's last days open a 2028 stub, reported on its own below). The means below are a boxer-season over every season in the group, a season with no call counting 0; **the offers median pools only the seasons that had a call** (the brief's trap: a season with no call is reported separately, never folded in).

| club | policy | boxer | division | season | boxer-seasons | offers a season, median (min-max) | weeks with a call / ranked weeks | offer bouts | sheet bouts | w-l in offer bouts | drawn | rivals that rang | points at 1 Jan | refused |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | accept | Lucy Jackson | wlw | 2026 | 10 | - | 0.0% (0/412) | 0.00 | 9.90 | 0.0-0.0 | 0.00 | - | 43.0 (24-49) | 0 |
| QUICK | accept | Lucy Jackson | wlw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 58.0 (53-63) | 0 |
| QUICK | not_this_show | Lucy Jackson | wlw | 2026 | 10 | - | 0.0% (0/416) | 0.00 | 10.10 | 0.0-0.0 | 0.00 | - | 41.5 (29-49) | 0 |
| QUICK | not_this_show | Lucy Jackson | wlw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 9.90 | 0.0-0.0 | 0.00 | - | 58.5 (51-68) | 0 |
| QUICK | pass | Lucy Jackson | wlw | 2026 | 10 | - | 0.0% (0/421) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 44.0 (30-50) | 0 |
| QUICK | pass | Lucy Jackson | wlw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 60.0 (52-67) | 0 |
| TEST | accept | Josh Harper | mww | 2026 | 10 | - | 0.0% (0/520) | 0.00 | 9.70 | 0.0-0.0 | 0.00 | - | 33.5 (28-45) | 0 |
| TEST | accept | Josh Harper | mww | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 56.5 (50-63) | 0 |
| TEST | accept | Kira Mensah | wfw | 2026 | 10 | - | 0.0% (0/254) | 0.00 | 10.40 | 0.0-0.0 | 0.00 | - | 37.0 (26-40) | 0 |
| TEST | accept | Kira Mensah | wfw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 9.90 | 0.0-0.0 | 0.00 | - | 37.0 (21-53) | 0 |
| TEST | accept | Lucy Jackson | wlw | 2026 | 10 | - | 0.0% (0/412) | 0.00 | 9.90 | 0.0-0.0 | 0.00 | - | 43.0 (24-49) | 0 |
| TEST | accept | Lucy Jackson | wlw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 58.0 (53-63) | 0 |
| TEST | not_this_show | Josh Harper | mww | 2026 | 10 | - | 0.0% (0/520) | 0.00 | 9.60 | 0.0-0.0 | 0.00 | - | 39.5 (29-48) | 0 |
| TEST | not_this_show | Josh Harper | mww | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.10 | 0.0-0.0 | 0.00 | - | 48.0 (40-64) | 0 |
| TEST | not_this_show | Kira Mensah | wfw | 2026 | 10 | - | 0.0% (0/221) | 0.00 | 9.60 | 0.0-0.0 | 0.00 | - | 34.5 (23-38) | 0 |
| TEST | not_this_show | Kira Mensah | wfw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 9.80 | 0.0-0.0 | 0.00 | - | 33.0 (4-62) | 0 |
| TEST | not_this_show | Lucy Jackson | wlw | 2026 | 10 | - | 0.0% (0/416) | 0.00 | 10.10 | 0.0-0.0 | 0.00 | - | 41.5 (29-49) | 0 |
| TEST | not_this_show | Lucy Jackson | wlw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 9.90 | 0.0-0.0 | 0.00 | - | 58.5 (51-68) | 0 |
| TEST | pass | Josh Harper | mww | 2026 | 10 | - | 0.0% (0/520) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 33.0 (29-41) | 0 |
| TEST | pass | Josh Harper | mww | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.10 | 0.0-0.0 | 0.00 | - | 51.5 (34-60) | 0 |
| TEST | pass | Kira Mensah | wfw | 2026 | 10 | - | 0.0% (0/235) | 0.00 | 9.90 | 0.0-0.0 | 0.00 | - | 34.5 (21-42) | 0 |
| TEST | pass | Kira Mensah | wfw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 9.40 | 0.0-0.0 | 0.00 | - | 34.0 (8-52) | 0 |
| TEST | pass | Lucy Jackson | wlw | 2026 | 10 | - | 0.0% (0/421) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 44.0 (30-50) | 0 |
| TEST | pass | Lucy Jackson | wlw | 2027 | 10 | - | 0.0% (0/530) | 0.00 | 10.00 | 0.0-0.0 | 0.00 | - | 60.0 (50-67) | 0 |

**Weeks with a call / ranked weeks** = the weeks a call came in over the weeks she was ranked at the day's end (the probe answers the day it opens, so a call is open for less than a day: this is the share of weeks the phone rang, not the share of days a card sat on the screen). **Offer bouts** = bouts booked with f["bout"]["rival_offer"] set; **sheet bouts** = the matchmaker's own offers accepted; both counted once a night a boxer, on the night they are for. **w-l** is the result of the offer bouts only (the career's own record, matched on the boxer and the night); a booked bout that never came off - missed weight, a pull-out, the run's end - is in offer bouts and not in w-l. **Rivals that rang** = the different callers a season, mean over the seasons that had a call. **Points at 1 Jan** = the season close's own table (LadderSeason.close keeps our rows), median (min-max) across the runs. **Refused** = answers the wire would not take.

The seasons with no call at all, kept out of the offers median: **not yet ranked** = she never reached 4 wins in that calendar year (the quick-start club signs Lucy at 0-0, so her first season is largely unranked); **ranked, nobody rang** = she was ranked and no rival below her in reach ever called.

| club | policy | boxer | boxer-seasons | with a call | not yet ranked | ranked, nobody rang |
|---|---|---|---|---|---|---|
| QUICK | accept | Lucy Jackson | 20 | 0 | 0 | 20 |
| QUICK | not_this_show | Lucy Jackson | 20 | 0 | 0 | 20 |
| QUICK | pass | Lucy Jackson | 20 | 0 | 0 | 20 |
| TEST | accept | Josh Harper | 20 | 0 | 0 | 20 |
| TEST | accept | Kira Mensah | 20 | 0 | 0 | 20 |
| TEST | accept | Lucy Jackson | 20 | 0 | 0 | 20 |
| TEST | not_this_show | Josh Harper | 20 | 0 | 0 | 20 |
| TEST | not_this_show | Kira Mensah | 20 | 0 | 0 | 20 |
| TEST | not_this_show | Lucy Jackson | 20 | 0 | 0 | 20 |
| TEST | pass | Josh Harper | 20 | 0 | 0 | 20 |
| TEST | pass | Kira Mensah | 20 | 0 | 0 | 20 |
| TEST | pass | Lucy Jackson | 20 | 0 | 0 | 20 |


**Why a ranked Monday brought no call** - every Monday a ranked amateur of ours was read through RivalOfferWire.monday's own gates, in its own order, before the day's needs were answered (the state the wire itself saw); "a rival rang" is the Monday a call was waiting. 11128 ranked Mondays over the 60 runs; the Ask door is AskFlow.open, the door the wire must find open before it rings.

| the gate that stopped it | accept | not_this_show | pass | all | share of ranked Mondays |
|---|---|---|---|---|---|
| the Ask door: a bout is booked | 2232 | 2185 | 2202 | 6619 | 59.5% |
| the Ask door: resting after a bout | 1300 | 1248 | 1276 | 3824 | 34.4% |
| the Ask door: hurt | 166 | 240 | 213 | 619 | 5.6% |
| the Ask door: a sheet offer waits | 10 | 10 | 16 | 36 | 0.3% |
| no rival below her on points | 10 | 6 | 9 | 25 | 0.2% |
| a host's late ask waits | 0 | 4 | 1 | 5 | 0.0% |


| policy | boxer-seasons | calls | accept | not this show | of them fell to pass | pass | pass free of cost | refused | lapsed after a refusal | points our boxers paid |
|---|---|---|---|---|---|---|---|---|---|---|
| accept | 80 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| not_this_show | 80 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| pass | 80 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |


Seasons kept out of every median above: a calendar year the run did not play in full (fewer than 300 days observed). The run is 735 days, so the last 1 January it crosses opens a season it only begins; a boxer who left mid-run would land here too.

| year | boxer-seasons | days observed | calls | offer bouts | left mid-run |
|---|---|---|---|---|---|
| 2028 | 120 | 10.0 (10-10) | 0 | 0 | 0 |

The points against LADDERPROBE3 (docs/LADDERPROBE3_RESULT.md, read from that doc's own "Our boxers' points" table): the same marks [0, 364, 728], the same clubs and boxers, the same day loop - the only difference is that here the phone is answered. LADDERPROBE3 left every call unanswered (each would lapse as a pass four days later); each policy here pools the seeds whose seed % 3 selects it. The brief's day 365 and 730 are read at these marks (day 364 and 728), the days the probe samples and LADDERPROBE3 printed. **No call came in any of the 60 runs**, so the three policies had nothing to answer: every offer column below reads 0, and the spread between policies is the seeds' (different bout outcomes), not the answer's. Where the tables above differ from LADDERPROBE3's it is not the phone - R8's 52-week leave (Region.INACTIVE_DAYS 364, built after LADDERPROBE3 was collected) takes idle rivals off the table, so there are fewer rival rows and fewer sitting at 0; our boxers' own points, bouts and w-l read exactly as LADDERPROBE3 printed them.

| club | boxer | policy | runs | day 364 | LADDERPROBE3 day 364 | day 728 | LADDERPROBE3 day 728 | change at day 728 |
|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | accept | 10 | 43.0 (24-49) | 43.0 | 58.0 (53-64) | 59.0 | -1.0 |
| QUICK | Lucy Jackson | not_this_show | 10 | 41.5 (29-49) | 43.0 | 59.0 (51-69) | 59.0 | +0.0 |
| QUICK | Lucy Jackson | pass | 10 | 44.0 (30-50) | 43.0 | 61.0 (54-67) | 59.0 | +2.0 |
| TEST | Josh Harper | accept | 10 | 33.0 (28-37) | 33.0 | 56.5 (50-63) | 52.5 | +4.0 |
| TEST | Kira Mensah | accept | 10 | 37.0 (26-40) | 35.5 | 37.0 (21-53) | 35.5 | +1.5 |
| TEST | Lucy Jackson | accept | 10 | 43.0 (24-49) | 43.0 | 58.0 (53-64) | 59.0 | -1.0 |
| TEST | Josh Harper | not_this_show | 10 | 40.0 (26-48) | 33.0 | 49.0 (40-64) | 52.5 | -3.5 |
| TEST | Kira Mensah | not_this_show | 10 | 34.5 (23-38) | 35.5 | 33.0 (4-62) | 35.5 | -2.5 |
| TEST | Lucy Jackson | not_this_show | 10 | 41.5 (29-49) | 43.0 | 59.0 (51-69) | 59.0 | +0.0 |
| TEST | Josh Harper | pass | 10 | 33.0 (29-46) | 33.0 | 51.5 (34-60) | 52.5 | -1.0 |
| TEST | Kira Mensah | pass | 10 | 34.5 (21-42) | 35.5 | 34.0 (8-52) | 35.5 | -1.5 |
| TEST | Lucy Jackson | pass | 10 | 44.0 (30-50) | 43.0 | 61.0 (52-67) | 59.0 | +2.0 |

### The three R9 lines

**A few a season, never weekly?** - 0 of 240 full boxer-seasons had a call (0 calls in all): median 0.0 offers a season (max 0), a call in 0.0% of the weeks the boxer was ranked (0 of 11128 weeks). The wire's own gap (one offer every 4 weeks a boxer, a rival rings again only after its own 8) caps a season at 13; the map's R9 reading is "a few a season, never weekly". **Why so few:** the wire rings only when the Ask door (AskFlow.open) is open; it was shut on 99.7% of the 11128 ranked Mondays (the biggest gate "the Ask door: a bout is booked", 6619), and on the 30 Mondays it stood open no rival below her in reach and legal was free to ring. This probe accepts every sheet offer the day it arrives, so the boxer is booked or in the 10-day post-bout rest (Bouts.AFTER_FIGHT) nearly every Monday: on a gym that answers its own sheet at once, R9 has almost no room to fire.

**Does Pass drain a boxer?** - at day 728, QUICK Lucy Jackson: pass 61.0, accept 58.0 (+3.0); TEST Josh Harper: pass 51.5, accept 56.5 (-5.0); TEST Kira Mensah: pass 34.0, accept 37.0 (-3.0); TEST Lucy Jackson: pass 61.0, accept 58.0 (+3.0). Under the pass policy our boxers paid 0 ladder points on 0 passes that cost (2 each, 0 calls in all); a pass while hurt or booked costs nothing, and LADDERPROBE3's own runs left every call to lapse as a pass four days late. **No call was answered under both policies, so that spread is the seeds' (different bout outcomes), not the answer's.**

**Does Accept crowd out the sheet?** - accept: 9.97 sheet bouts + 0.00 offer bouts = 9.97 nights a boxer-season; not_this_show: 9.89 sheet bouts + 0.00 offer bouts = 9.89 nights a boxer-season; pass: 9.93 sheet bouts + 0.00 offer bouts = 9.93 nights a boxer-season. **No offer bout was booked under any policy, so nothing crowded the sheet out: the sheet spread above is the seeds'.** The mechanism is there to measure - accepting marks the sheet offers still waiting answered (RivalOfferWire.answer) - but it never fired.

Reproduce: `python ops/Tools/godot_slot.py run --who ladderprobe4 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/ladderprobe4.log --path . --script res://tools/ladder_probe.gd -- seeds=30 seed=4421 days=735`
