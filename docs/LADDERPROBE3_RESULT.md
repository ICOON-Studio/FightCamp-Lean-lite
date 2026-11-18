# LADDERPROBE3 result - the ladder table over two years with newcomers, the R8 free week and the season close

Probe run: 2026-11-18T16:54:20. 30 seeds x 2 clubs = 60 runs of 735 days (seeds 4421..4450), 303s. A measurement only: no rule or constant was changed.

The scope (LADDERWIRE_SCOPE_S515) asks of every ladder stage: **a season's table stays sane - points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over.** This probe plays two seasons and reads the table the game sorts (Region.rankings, ladder points first since S516) every 28 days. LADDERPROBE1 (S516) and LADDERPROBE2 (S517, before these fixes) printed the same tables at the same marks [0, 364, 728], so the three compare. The S517 fixes measured here: the newcomer sheet (Newcomers - a novice with nobody legal on her sheet gets a newcomer novice on it), the R8 free week (Region._free_week - the idle clock waits while our boxer is booked, injured or has no legal name in reach) and the season close (LadderSeason - 1 January keeps each division's final table). The run is 735 days so both closes (day 361 = 1 Jan 2027, day 726 = 1 Jan 2028) fall inside it; the last mark stays 728.
## Population

- **QUICK**: a quick-start career, Lucy signed at reception (Sim.sign, the interview's three cards), Reid hired. One boxer (wlw). **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww) and Ana on the mats, Reid hired. Three boxers, three classes.
- Both past the first-week guide and the first hour. Rivals' invented pasts re-seeded to the run seed, so a replay agrees. No fighter is synthesized or copied: the clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical. 30 seeds a club, 735 days each through Sim.step_day - the real day loop: offers, camps, fight weeks, weigh-ins, the game's own bout sim, injuries, pull-outs, late asks, the region's own club shows (Region._rival_bout moves both rivals' points), the newcomers' own shows and the season close. Cash floored at $20000 as two_boxers_two_years_test does; money is not the measurement.
- Decisions in code, every open need answered as TestJump._tidy / _to_nationals answer them: every sheet offer accepted (Bouts.accept; the unsafe mismatch pair is left as the game leaves it), the fight week drafted and locked on the best-ranked free partners, the camp started, the weigh-in taken, the bout fought by the sim, the week review closed, the office goal five_round_engine, an injury past the bell pulled out, a fall-through answered with the replacement (else go home), a host's late ask declined (_tidy's NO), a rival club's approach matched so the boxer stays. Pro offers declined (Roster.decline_pro): the two years stay on the amateur ladder the probe measures. The nationals are never entered.
## How the table is read

- Every 28 days, for every division that has rivals, Region.rankings(c, div) is read and each row's points recorded (a row with no "rep" yet reads at its seed, RankLine.rep). Our boxers enter the table at 4 wins (Region.RANK_MIN_WINS) and leave it if they turn pro. **Top-3 turnover** = the different names that held a top-3 place at any sample over the two years; **bottom half** = a day-0 rank below the middle of that day's table (rank > rows/2); **new** = not in the day-0 table at all; **kept** = of the day-0 top 3, still in the top 3 at the last sample.
- **Stuck** = a row whose points are exactly where they were 84 days ago AND that had at least one bout in that window (a rival's RivalPast file, newest first; one of ours from Career.results, amateur bouts only). A row with no bout in the window is **idle**, not stuck: a never-boxing rival keeps a seed that cannot move (the brief's trap). A newcomer's invented past is seeded before her joined day, so it is not counted as her bout either. **Cap-stuck** = stuck at 0 or 100. Stuck is counted at every sample from day 84 on; the day-0 column has no window yet. A row that was not in the table 84 days earlier (one of ours entering at 4 wins) counts as active, not stuck: there is no earlier reading to compare. **Never boxed** = a rival with no bout at all in the 735 days, reported separately, never counted as stuck.
## Per division: the points at day [0, 364, 728]

| division | day | rows | min | median | max | at 0 | at 100 | stuck (of active) | cap-stuck | idle |
|---|---|---|---|---|---|---|---|---|---|---|
| wlw | 0 | 660 | 10 | 22.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wlw | 364 | 766 | 0 | 22.0 | 67 | 62 (8.1%) | 0 (0.0%) | 7.8% (58/742) | 44 | 3.1% |
| wlw | 728 | 766 | 0 | 17.0 | 69 | 125 (16.3%) | 0 (0.0%) | 8.7% (62/710) | 47 | 7.3% |
| wfw | 0 | 300 | 10 | 20.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wfw | 364 | 337 | 0 | 20.0 | 73 | 38 (11.3%) | 0 (0.0%) | 5.9% (18/307) | 10 | 8.9% |
| wfw | 728 | 341 | 0 | 20.0 | 94 | 93 (27.3%) | 0 (0.0%) | 16.2% (50/309) | 41 | 9.4% |
| www | 0 | 300 | 14 | 22.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| www | 364 | 300 | 0 | 22.0 | 74 | 48 (16.0%) | 0 (0.0%) | 4.2% (10/240) | 4 | 20.0% |
| www | 728 | 300 | 0 | 22.0 | 96 | 114 (38.0%) | 0 (0.0%) | 24.2% (58/240) | 50 | 20.0% |
| wlm | 0 | 360 | 27 | 35.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wlm | 364 | 360 | 0 | 31.5 | 90 | 58 (16.1%) | 0 (0.0%) | 3.3% (10/300) | 0 | 16.7% |
| wlm | 728 | 360 | 0 | 27.0 | 100 | 103 (28.6%) | 5 (1.4%) | 10.7% (32/300) | 20 | 16.7% |
| wmw | 0 | 300 | 11 | 27.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wmw | 364 | 300 | 0 | 23.0 | 83 | 53 (17.7%) | 0 (0.0%) | 6.7% (16/240) | 6 | 20.0% |
| wmw | 728 | 300 | 0 | 21.0 | 100 | 113 (37.7%) | 3 (1.0%) | 20.0% (48/240) | 41 | 20.0% |
| mfw | 0 | 240 | 34 | 43.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mfw | 364 | 240 | 13 | 34.0 | 82 | 0 (0.0%) | 0 (0.0%) | 7.2% (13/180) | 0 | 25.0% |
| mfw | 728 | 240 | 0 | 23.5 | 95 | 60 (25.0%) | 0 (0.0%) | 5.6% (10/180) | 0 | 25.0% |
| mlw | 0 | 240 | 26 | 41.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mlw | 364 | 240 | 5 | 34.0 | 85 | 0 (0.0%) | 0 (0.0%) | 3.9% (7/180) | 0 | 25.0% |
| mlw | 728 | 240 | 0 | 24.0 | 97 | 73 (30.4%) | 0 (0.0%) | 8.4% (15/179) | 6 | 25.4% |
| mww | 0 | 270 | 22 | 41.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mww | 364 | 277 | 0 | 33.0 | 90 | 2 (0.7%) | 0 (0.0%) | 4.1% (10/244) | 0 | 11.9% |
| mww | 728 | 277 | 0 | 28.0 | 100 | 57 (20.6%) | 4 (1.4%) | 11.8% (29/245) | 22 | 11.6% |
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
| mlw | 60 | 3.7 | 1.67 | 0.00 | 2.78 | 1.00 | 4.00 |
| mww | 60 | 4.0 | 1.97 | 0.03 | 2.42 | 0.50 | 4.50 |
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
| wlw | 2027 | 60 | 10.00 | 12.77 | 1.00 | 59.3 |
| wfw | 2026 | 60 | 5.62 | 5.62 | 0.50 | 55.7 |
| wfw | 2027 | 60 | 5.68 | 5.68 | 0.50 | 76.5 |
| www | 2026 | 60 | 5.00 | 5.00 | 0.00 | 58.3 |
| www | 2027 | 60 | 5.00 | 5.00 | 0.00 | 79.0 |
| wlm | 2026 | 60 | 6.00 | 6.00 | 0.00 | 79.2 |
| wlm | 2027 | 60 | 6.00 | 6.00 | 0.00 | 90.3 |
| wmw | 2026 | 60 | 5.00 | 5.00 | 0.00 | 67.9 |
| wmw | 2027 | 60 | 5.00 | 5.00 | 0.00 | 87.5 |
| mfw | 2026 | 60 | 4.00 | 4.00 | 0.00 | 76.2 |
| mfw | 2027 | 60 | 4.00 | 4.00 | 0.00 | 82.7 |
| mlw | 2026 | 60 | 4.00 | 4.00 | 0.00 | 73.5 |
| mlw | 2027 | 60 | 4.00 | 4.00 | 0.00 | 83.0 |
| mww | 2026 | 60 | 4.62 | 4.62 | 0.50 | 80.1 |
| mww | 2027 | 60 | 4.62 | 4.62 | 0.50 | 85.6 |
| mmw | 2026 | 60 | 4.00 | 4.00 | 0.00 | 88.8 |
| mmw | 2027 | 60 | 4.00 | 4.00 | 0.00 | 97.5 |


| club | boxer | division | season | runs in the table | place | points | of (full table) |
|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | wlw | 2026 | 30 | 2.5 (1-6) | 40.4 (24-50) | 12.8 |
| QUICK | Lucy Jackson | wlw | 2027 | 30 | 1.1 (1-2) | 58.8 (51-68) | 12.8 |
| TEST | Josh Harper | mww | 2026 | 30 | 2.8 (2-4) | 35.8 (28-48) | 5.2 |
| TEST | Josh Harper | mww | 2027 | 30 | 2.1 (2-3) | 52.1 (34-64) | 5.2 |
| TEST | Kira Mensah | wfw | 2026 | 30 | 2.3 (1-4) | 34.3 (21-42) | 6.2 |
| TEST | Kira Mensah | wfw | 2027 | 30 | 2.9 (1-5) | 33.8 (4-62) | 6.4 |
| TEST | Lucy Jackson | wlw | 2026 | 30 | 2.5 (1-6) | 40.4 (24-50) | 12.8 |
| TEST | Lucy Jackson | wlw | 2027 | 30 | 1.1 (1-2) | 58.8 (50-68) | 12.8 |

## The three lines

**Points spread 0-100? YES** - at day 728, 3064 rows pooled: min 0, median 21.0, max 100; 795 rows at 0 (25.9%), 24 at 100 (0.8%).

**Anyone stuck at a cap? YES** - 2342 rows sat at 0 or 100 with a bout in the window and no points moved in 84 days (4829 stuck rows of 63277 active, all windows day 84-728).

**Does the top 3 turn over? YES** - 4.65 different names held a top-3 place over the two years (3 seats), 2.03 of them started in the bottom half, 0.18 were not in the day-0 table; 2.46 of the day-0 top 3 still hold a seat at day 728.

Read: 540 division-runs, 5.39 rows a table at day 0. Over every 84-day window from day 84 to 728, 4829 of 63277 active rows did not move (7.6%), 2342 of them at a cap; 9727 of 73004 rows were idle (no bout in the window). 0.28 rivals a division never boxed at all in the two years - their seed is the order they keep, and they are not counted as stuck. The bunching is uneven: at day 728 the rows sitting at a cap run from 16.3% (wlw) to 38.7% (wmw). The S517 fixes: 64 newcomers arrived over the 60 runs and boxed 254 bouts against our gym; our boxers ended with no legal name on the shipped sheet in 0 runs and the same points at both marks in 2. The fight week lock refused 0 weeks; runs closed early: 0.

Reproduce: `python ops/Tools/godot_slot.py run --who ladderprobe3 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/ladderprobe3.log --path . --script res://tools/ladder_probe.gd -- seeds=30 seed=4421 days=735`
