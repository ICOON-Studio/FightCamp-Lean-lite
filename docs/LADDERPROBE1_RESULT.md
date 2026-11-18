# LADDERPROBE1 result - does the season ladder's table stay sane over two years of real play?

Probe run: 2026-11-18T13:06:25. 30 seeds x 2 clubs = 60 runs of 728 days (seeds 4421..4450), 383s. A measurement only: no rule or constant was changed.

The scope (LADDERWIRE_SCOPE_S515) asks of every ladder stage: **a season's table stays sane - points spread 0-100, no boxer stuck at a cap, ranked top 3 turns over.** This probe plays two seasons and reads the table the game sorts (Region.rankings, ladder points first since S516) every 28 days.

## Population

- **QUICK**: a quick-start career, Lucy signed at reception (Sim.sign, the interview's three cards), Reid hired. One boxer (wlw).
- **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww) and Ana on the mats, Reid hired. Three boxers, three classes.
- Both past the first-week guide and the first hour. Rivals' invented pasts re-seeded to the run seed, so a replay agrees. No fighter is synthesized or copied: the clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical.
- 30 seeds a club, 728 days each through Sim.step_day - the real day loop: offers, camps, fight weeks, weigh-ins, the game's own bout sim, injuries, pull-outs, late asks, the region's own club shows (Region._rival_bout moves both rivals' points). Cash floored at $20000 as two_boxers_two_years_test does; money is not the measurement.
- Decisions in code, every open need answered as TestJump._tidy / _to_nationals answer them: every sheet offer accepted (Bouts.accept; the unsafe mismatch pair is left as the game leaves it), the fight week drafted and locked on the best-ranked free partners, the camp started, the weigh-in taken, the bout fought by the sim, the week review closed, the office goal five_round_engine, an injury past the bell pulled out, a fall-through answered with the replacement (else go home), a host's late ask declined (_tidy's NO), a rival club's approach matched so the boxer stays. Pro offers declined (Roster.decline_pro): the two years stay on the amateur ladder the probe measures. The nationals are never entered.

## How the table is read

- Every 28 days, for every division that has rivals, Region.rankings(c, div) is read and each row's points recorded (a row with no "rep" yet reads at its seed, RankLine.rep). Our boxers enter the table at 4 wins (Region.RANK_MIN_WINS) and leave it if they turn pro.
- **Stuck** = a row whose points are exactly where they were 84 days ago AND that had at least one bout in that window (a rival's RivalPast file, newest first; one of ours from Career.results, amateur bouts only). A row with no bout in the window is **idle**, not stuck: a never-boxing rival keeps a seed that cannot move (the brief's trap). **Cap-stuck** = stuck at 0 or 100. Stuck is counted at every sample from day 84 on; the day-0 column has no window yet. A row that was not in the table 84 days earlier (one of ours entering at 4 wins) counts as active, not stuck: there is no earlier reading to compare. **Never boxed** = a rival with no bout at all in the 728 days (her invented past is all before day 0), reported separately, never counted as stuck.
- **Top-3 turnover** = the different names that held a top-3 place at any sample over the two years; **bottom half** = a day-0 rank below the middle of that day's table (rank > rows/2); **new** = not in the day-0 table at all (our boxers enter at 4 wins); **kept** = of the day-0 top 3, still in the top 3 at the last sample.

## Per division: the points at day [0, 364, 728]

| division | day | rows | min | median | max | at 0 | at 100 | stuck (of active) | cap-stuck | idle |
|---|---|---|---|---|---|---|---|---|---|---|
| wlw | 0 | 660 | 10 | 22.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wlw | 364 | 720 | 0 | 33.0 | 66 | 94 (13.1%) | 0 (0.0%) | 10.5% (66/626) | 44 | 13.1% |
| wlw | 728 | 720 | 0 | 30.0 | 72 | 68 (9.4%) | 0 (0.0%) | 4.0% (26/652) | 10 | 9.4% |
| wfw | 0 | 300 | 10 | 20.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wfw | 364 | 329 | 0 | 30.0 | 78 | 44 (13.4%) | 0 (0.0%) | 2.3% (7/298) | 4 | 9.4% |
| wfw | 728 | 329 | 0 | 28.0 | 100 | 50 (15.2%) | 5 (1.5%) | 12.8% (37/289) | 36 | 12.2% |
| www | 0 | 300 | 14 | 22.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| www | 364 | 300 | 0 | 30.0 | 83 | 20 (6.7%) | 0 (0.0%) | 10.8% (26/240) | 13 | 20.0% |
| www | 728 | 300 | 0 | 26.0 | 100 | 58 (19.3%) | 13 (4.3%) | 28.8% (69/240) | 63 | 20.0% |
| wlm | 0 | 360 | 27 | 35.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wlm | 364 | 360 | 0 | 35.0 | 93 | 2 (0.6%) | 0 (0.0%) | 4.3% (13/300) | 0 | 16.7% |
| wlm | 728 | 360 | 0 | 32.0 | 100 | 34 (9.4%) | 43 (11.9%) | 17.3% (52/300) | 46 | 16.7% |
| wmw | 0 | 300 | 11 | 27.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| wmw | 364 | 300 | 0 | 32.0 | 89 | 41 (13.7%) | 0 (0.0%) | 2.1% (5/240) | 2 | 20.0% |
| wmw | 728 | 300 | 0 | 33.0 | 100 | 84 (28.0%) | 29 (9.7%) | 21.7% (52/240) | 49 | 20.0% |
| mfw | 0 | 240 | 34 | 43.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mfw | 364 | 240 | 18 | 34.5 | 91 | 0 (0.0%) | 0 (0.0%) | 2.2% (4/180) | 0 | 25.0% |
| mfw | 728 | 240 | 1 | 34.0 | 100 | 0 (0.0%) | 38 (15.8%) | 9.4% (17/180) | 9 | 25.0% |
| mlw | 0 | 240 | 26 | 41.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mlw | 364 | 240 | 14 | 33.0 | 89 | 0 (0.0%) | 0 (0.0%) | 2.2% (4/180) | 0 | 25.0% |
| mlw | 728 | 240 | 0 | 26.0 | 100 | 4 (1.7%) | 35 (14.6%) | 11.7% (21/180) | 15 | 25.0% |
| mww | 0 | 270 | 22 | 41.0 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mww | 364 | 270 | 2 | 35.0 | 98 | 0 (0.0%) | 0 (0.0%) | 1.3% (3/232) | 0 | 14.1% |
| mww | 728 | 270 | 0 | 29.0 | 100 | 15 (5.6%) | 50 (18.5%) | 19.6% (44/224) | 39 | 17.0% |
| mmw | 0 | 240 | 28 | 49.5 | 65 | 0 (0.0%) | 0 (0.0%) | - | 0 | - |
| mmw | 364 | 240 | 0 | 45.5 | 100 | 3 (1.3%) | 8 (3.3%) | 2.5% (6/240) | 0 | 0.0% |
| mmw | 728 | 240 | 0 | 41.0 | 100 | 55 (22.9%) | 51 (21.3%) | 40.0% (96/240) | 88 | 0.0% |

## Per division: the top 3 over two years (means a run)

| division | runs | distinct top-3 names | from bottom half | new to the table | day-0 top 3 kept | never boxed | rows at day 0 |
|---|---|---|---|---|---|---|---|
| wlw | 60 | 6.4 | 0.40 | 0.97 | 1.03 | 0.00 | 11.00 |
| wfw | 60 | 5.0 | 2.52 | 0.48 | 2.58 | 0.00 | 5.00 |
| www | 60 | 4.7 | 2.68 | 0.00 | 2.37 | 0.00 | 5.00 |
| wlm | 60 | 4.6 | 1.58 | 0.00 | 2.00 | 0.00 | 6.00 |
| wmw | 60 | 4.1 | 2.07 | 0.00 | 2.93 | 0.00 | 5.00 |
| mfw | 60 | 4.0 | 2.00 | 0.00 | 2.00 | 1.00 | 4.00 |
| mlw | 60 | 4.0 | 2.00 | 0.00 | 2.02 | 1.00 | 4.00 |
| mww | 60 | 4.4 | 2.40 | 0.00 | 1.98 | 0.50 | 4.50 |
| mmw | 60 | 3.9 | 1.93 | 0.00 | 2.92 | 0.00 | 4.00 |

## Our boxers' points (means a run; min-max across seeds)

| club | boxer | division | runs | left mid-run | day 364 | day 728 | bouts fought | w | l | rank | no legal name at end | same points at both marks |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | wlw | 30 | 0 | 40.0 (24-51) | 40.0 (24-72) | 8.8 | 10.5-2.3 | 4.0 | 23 | 23 |
| TEST | Josh Harper | mww | 30 | 0 | 34.0 (16-49) | 53.5 (16-66) | 14.8 | 13.6-7.2 | 2.2 | 7 | 7 |
| TEST | Kira Mensah | wfw | 30 | 0 | 39.0 (11-44) | 28.0 (11-59) | 14.3 | 11.2-4.1 | 3.1 | 11 | 11 |
| TEST | Lucy Jackson | wlw | 30 | 0 | 40.0 (24-51) | 40.0 (24-72) | 8.8 | 10.5-2.3 | 4.0 | 23 | 23 |

**Bouts fought** counts only the bouts of the run; **w-l** is the whole record, the walk-in's past included. **No legal name at end** = at day 728 our boxer was still a novice (AmateurBooking.NOVICE_MAX_BOUTS 10) while every name on her division's sheet (Data.DIVISIONS.opponents) had graduated past 10 bouts at the region's own shows: Bouts.legal_index falls back to the next name in turn, _offer flags it mismatch and Bouts.accept refuses a mismatch, so the clock runs on with no bout to take. **Same points at both marks** = the identical reading at day 364 and day 728 - the freeze that follows. This is the shipped novice rule measured, not changed: the wall FAVOURPROBE1 reported late in its year, here seen from the ladder's side.

## The three lines

**Points spread 0-100? YES** - at day 728, 2999 rows pooled: min 0, median 30.0, max 100; 368 rows at 0 (12.3%), 264 at 100 (8.8%).

**Anyone stuck at a cap? YES** - 2829 rows sat at 0 or 100 with a bout in the window and no points moved in 84 days (4972 stuck rows of 61608 active, all windows day 84-728).

**Does the top 3 turn over? YES** - 4.56 different names held a top-3 place over the two years (3 seats), 1.95 of them started in the bottom half, 0.16 were not in the day-0 table; 2.20 of the day-0 top 3 still hold a seat at day 728.

Read: 540 division-runs, 5.39 rows a table at day 0. Over every 84-day window from day 84 to 728, 4972 of 61608 active rows did not move (8.1%), 2829 of them at a cap; 10230 of 71838 rows were idle (no bout in the window). 0.28 rivals a division never boxed at all in the two years - their seed is the order they keep, and they are not counted as stuck. The bunching is uneven: at day 728 the rows sitting at a cap run from 9.4% (wlw) to 44.2% (mmw). The fight week lock refused 0 weeks; runs closed early: 0.

Reproduce: `python ops/Tools/godot_slot.py run --who ladderprobe1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/ladderprobe1.log --path . --script res://tools/ladder_probe.gd -- seeds=30 seed=4421 days=728`
