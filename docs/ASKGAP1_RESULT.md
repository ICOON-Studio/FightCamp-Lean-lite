# ASKGAP1 - the Ask door opens the day after a bout (S520), STREAKPROBE1 rerun on it

The change (scripts/rules/AskBout.gd rest_gap / ASK_AFTER_DAYS, scripts/state/AskFlow.gd rest_end): the 10-day rest after a
bout (Bouts.AFTER_FIGHT) gates the BOUT, not the phone call. The Ask door opens the day after a bout; the shows it offers
and books still fall after the rest; nothing asked = the sheet's offer comes when the rest ends, as before. The host's
short-notice ask (LateAskWire.ready_for) still waits out the whole rest. HotStreak.POINTS is 8 (S519).

Before (docs/STREAKPROBE1_RESULT.md, git history at a6713760d): the door was open on 0 of 125 hot Mondays (61.6% resting,
32.8% booked, 5.6% hurt) - 0 asks, 0 ducks, 0 OWED in 240 boxer-seasons.
After (below): open on 671 of 1377 hot Mondays; 187 asks, 64 booked; 123 ducks, 48 OWED reached, 18 owed bouts booked.
The door is now shut mostly by a bout already booked (88.5%). Points at day 728 within a few of LADDERPROBE4.
Read: Josh (mww) asked 24 times and was refused 24 times - every ask of his went to a name 0-8 points above, all ducks;
he reached OWED 10 times but booked 0 owed bouts because the probe's policy asks the highest name, not the corner that
owes him. A player picks the owing corner (the Ask card says OWED); the probe does not. Next: the probe's ask could pick
an owing name first (a probe policy, not a rule).

# STREAKPROBE1 - how often a boxer is ON A RUN, and how often corners DUCK her or come to OWE her the bout

Probe run: 2026-11-18T23:26:00. 30 seeds x 2 clubs = 60 runs of 735 days (seeds 4421..4450), 1346s. A measurement only: no rule or constant was changed.

The map (ops/research/DESIGN_LADDER1_V6_DOLA.md R6) puts a boxer ON A RUN when she has won her last 3 bouts AND gained 8+ ladder points in the last 8 weeks (HotStreak.WINS / POINTS / WEEKS, read from c.results' "pts"). A corner 0-8 ladder points above her then leans No (-20 on the yes score, LadderRep.yes_score); such a No is DUCKED (once a week at most), two ducks inside 8 weeks make the next ask to that corner OWED (score 95, a Yes), and booking the owed bout clears the slate. Those numbers are the map's estimates: this probe plays two seasons and counts how often each of them happens.
## Population

- **QUICK**: a quick-start career, Lucy signed at reception, Reid hired. **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww), Ana on the mats, Reid hired. Both past the first-week guide and the first hour, rivals' invented pasts re-seeded to the run seed. The clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical. 30 seeds a club, 735 days each through Sim.step_day, cash floored at $20000. The career set-up and the open-needs answering are tools/ladder_probe.gd's own (_career, _answer, _week), copied not edited: every sheet offer accepted, the fight week drafted and locked, the camp started, the weigh-in taken, the bout fought by the sim, pro offers declined, the nationals never entered, and the rival gyms' calls answered by the run seed's policy (tools/ladder_probe_offers.gd) - so the population is LADDERPROBE4's and the points below compare with it.
- **The one exception**: each Monday, before the day's needs are answered, every boxer on a run (HotStreak.hot) whose Ask door (AskFlow.open) is open asks for the highest-points name on AskFlow.answers(c, f)["cards"] whose ladder points are 0-8 above hers (ties by name), at the soonest show AskFlow.shows would let her ask on (can_ask: the scale makes the class or the gap, and none of ours holds the night), through AskFlow.book kind "name" (the host keeps the gate). The lean is read before the book; the ducks and OWED after it. A hot Monday whose door is shut is counted in the gate table below, never as an ask.
## How it is read

- **Active week** = a Monday (day % 7 == 0, day 0 is Mon 5 Jan 2026) on which she had fought 3 or more amateur bouts in this career. The share ON A RUN is hot weeks / active weeks - the brief's trap: a 0-0 boxer is never on a run and says nothing about the threshold. The reading is taken at the day's end, after every open need is answered. **Longest run** = the longest stretch of consecutive active Mondays ON A RUN (weeks); **runs a season** = the separate stretches that start in a full calendar year (a year the run played 43+ weeks), averaged over those years. The longest win streak (bouts) is read beside it over every bout of the run, not only the Mondays.
- **Ducks** = a No logged by AskFlow.book while she was on a run from a name 0-8 points above (HotStreak.duck, once a week). **OWED reached** = is_owed turning true after an ask; the weeks from the first duck to that ask are kept. **Owed bouts booked** = an ask that booked while the card already read OWED (AskFlow.book clears the slate); its w-l is the career's own result on that night. A booked ask that never came off (missed weight, a pull-out, the run's end) is counted apart.

| club | boxer | division | runs | active weeks | ON A RUN weeks | share | longest run (weeks) | runs a season | longest win streak (bouts) | bouts a run | w-l a run |
|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | wlw | 30 | 2694 | 476 | 17.7% | 8.0 (0-16) | 1.45 | 9.0 (4-20) | 21.4 | 21.0-4.5 |
| TEST | Josh Harper | mww | 30 | 2596 | 224 | 8.6% | 4.0 (0-14) | 0.85 | 7.0 (2-18) | 18.8 | 17.2-7.7 |
| TEST | Kira Mensah | wfw | 30 | 2727 | 190 | 7.0% | 4.0 (0-8) | 0.67 | 6.5 (3-14) | 18.5 | 14.4-5.1 |
| TEST | Lucy Jackson | wlw | 30 | 2694 | 487 | 18.1% | 8.0 (0-16) | 1.52 | 9.0 (6-19) | 21.2 | 20.8-4.4 |


| club | boxer | hot Mondays | door open | no name / no show | asks | Leans Yes | Leans No | booked | ducks | OWED reached | first duck to owed (weeks) | owed bouts booked | owed w-l |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | 476 | 223 | 145 | 78 | 30 | 48 | 30 | 48 | 18 | 1.0 (1-3) | 9 | 5-4 |
| TEST | Josh Harper | 224 | 122 | 98 | 24 | 0 | 24 | 0 | 24 | 10 | 1.0 (1-1) | 0 | 0-0 |
| TEST | Kira Mensah | 190 | 94 | 83 | 11 | 3 | 8 | 3 | 8 | 4 | 1.0 (1-3) | 2 | 0-1 |
| TEST | Lucy Jackson | 487 | 232 | 158 | 74 | 31 | 43 | 31 | 43 | 16 | 1.0 (1-3) | 7 | 2-5 |


| the gate that stopped the ask on a hot Monday | Mondays | share |
|---|---|---|
| the Ask door: a bout is booked | 625 | 88.5% |
| the Ask door: hurt | 76 | 10.8% |
| the Ask door: a sheet offer waits | 5 | 0.7% |


| club | boxer | runs | day 364 | LADDERPROBE4 day 364 | day 728 | LADDERPROBE4 day 728 | change at day 728 |
|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | 30 | 37.0 (23-50) | 40.0 | 59.0 (40-76) | 54.5 | -4.0 |
| TEST | Josh Harper | 30 | 35.0 (18-55) | 35.5 | 53.5 (33-62) | 53.0 | +0.0 |
| TEST | Kira Mensah | 30 | 35.0 (19-42) | 35.0 | 30.0 (5-63) | 29.5 | +1.0 |
| TEST | Lucy Jackson | 30 | 37.0 (23-50) | 40.0 | 60.0 (47-77) | 54.5 | -2.0 |

The points are the same marks LADDERPROBE4 printed (docs/LADDERPROBE4_RESULT.md, "Our boxers' points"), read from that doc's own table. The only difference in the day loop is the hot Monday's ask: where it booked a night the sheet would have had, the points move with it.

| wins in a row | points in 8 weeks | ON A RUN weeks | share of active weeks | runs a season | note |
|---|---|---|---|---|---|
| 3 | 5 | 2393 | 22.3% | 2.26 |  |
| 3 | 8 | 1377 | 12.9% | 1.47 | the shipped threshold |
| 3 | 10 | 857 | 8.0% | 1.13 |  |
| 3 | 12 | 454 | 4.2% | 0.77 |  |
| 3 | 15 | 172 | 1.6% | 0.38 |  |
| 3 | 20 | 23 | 0.2% | 0.08 |  |
| 2 | 15 | 622 | 5.8% | 0.72 |  |
| 4 | 15 | 89 | 0.8% | 0.19 |  |

A read of the same active weeks at other numbers - nothing changed, nothing replayed. The denominator stays the weeks with 3+ bouts fought, so every row compares with the shipped one.
## The three lines

**Is ON A RUN rare enough to feel earned (10-30% of active weeks)? YES** - 1377 of 10711 active weeks (12.9%), over the weeks she had fought 3+ bouts; longest run 7.0 (0-16) weeks, 1.12 runs a full season. The shipped numbers sit in the band: nothing to name.

**Do ducks happen a few times a season (not never, not weekly)? YES - a few** - 123 ducks over 240 full boxer-seasons (0.51 a season), from 187 asks made while on a run (123 Leans No, 64 Leans Yes).

**Does OWED ever fire? YES** - 48 OWED reached over the 60 runs (123 ducks in all), 1.0 (1-3) weeks from the first duck to the owed ask; 18 owed bouts booked (w-l 7-10), 0 still owed at day 735.

Read: 60 runs, 12600 boxer-Mondays, 10711 active weeks pooled, 1377 of them ON A RUN (12.9%). 1377 hot Mondays: the door open on 671, shut on 706; 187 asks made (sheet 47; step_up 135; name 5), 64 booked, 123 refused by the corner, 0 leaned Yes but would not book. The asks booked 60 bouts: 33-27 (0 drawn, 4 never came off). 123 ducks, 48 OWED reached, 18 owed bouts booked, 0 still owed at the run's end. The fight week lock refused 0 weeks; runs closed early: 0; boxers left mid-run: 0.

Reproduce: `python ops/Tools/godot_slot.py run --who streakprobe1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/streakprobe1.log --path . --script res://tools/streak_probe.gd -- seeds=30 seed=4421 days=735`
