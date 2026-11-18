# STREAKPROBE1 - how often a boxer is ON A RUN, and how often corners DUCK her or come to OWE her the bout

Probe run: 2026-11-18T22:48:51. 30 seeds x 2 clubs = 60 runs of 735 days (seeds 4421..4450), 341s. A measurement only: no rule or constant was changed.

The map (ops/research/DESIGN_LADDER1_V6_DOLA.md R6) puts a boxer ON A RUN when she has won her last 3 bouts AND gained 15+ ladder points in the last 8 weeks (HotStreak.WINS / POINTS / WEEKS, read from c.results' "pts"). A corner 0-8 ladder points above her then leans No (-20 on the yes score, LadderRep.yes_score); such a No is DUCKED (once a week at most), two ducks inside 8 weeks make the next ask to that corner OWED (score 95, a Yes), and booking the owed bout clears the slate. Those numbers are the map's estimates: this probe plays two seasons and counts how often each of them happens.
## Population

- **QUICK**: a quick-start career, Lucy signed at reception, Reid hired. **TEST**: the TEST CLUB (scripts/state/TestClub.gd): Lucy (wlw), Kira (wfw), Josh (mww), Ana on the mats, Reid hired. Both past the first-week guide and the first hour, rivals' invented pasts re-seeded to the run seed. The clubs' own distinct boxers against the game's own named rivals; no two fighters in a measurement are identical. 30 seeds a club, 735 days each through Sim.step_day, cash floored at $20000. The career set-up and the open-needs answering are tools/ladder_probe.gd's own (_career, _answer, _week), copied not edited: every sheet offer accepted, the fight week drafted and locked, the camp started, the weigh-in taken, the bout fought by the sim, pro offers declined, the nationals never entered, and the rival gyms' calls answered by the run seed's policy (tools/ladder_probe_offers.gd) - so the population is LADDERPROBE4's and the points below compare with it.
- **The one exception**: each Monday, before the day's needs are answered, every boxer on a run (HotStreak.hot) whose Ask door (AskFlow.open) is open asks for the highest-points name on AskFlow.answers(c, f)["cards"] whose ladder points are 0-8 above hers (ties by name), at the soonest show AskFlow.shows would let her ask on (can_ask: the scale makes the class or the gap, and none of ours holds the night), through AskFlow.book kind "name" (the host keeps the gate). The lean is read before the book; the ducks and OWED after it. A hot Monday whose door is shut is counted in the gate table below, never as an ask.
## How it is read

- **Active week** = a Monday (day % 7 == 0, day 0 is Mon 5 Jan 2026) on which she had fought 3 or more amateur bouts in this career. The share ON A RUN is hot weeks / active weeks - the brief's trap: a 0-0 boxer is never on a run and says nothing about the threshold. The reading is taken at the day's end, after every open need is answered. **Longest run** = the longest stretch of consecutive active Mondays ON A RUN (weeks); **runs a season** = the separate stretches that start in a full calendar year (a year the run played 43+ weeks), averaged over those years. The longest win streak (bouts) is read beside it over every bout of the run, not only the Mondays.
- **Ducks** = a No logged by AskFlow.book while she was on a run from a name 0-8 points above (HotStreak.duck, once a week). **OWED reached** = is_owed turning true after an ask; the weeks from the first duck to that ask are kept. **Owed bouts booked** = an ask that booked while the card already read OWED (AskFlow.book clears the slate); its w-l is the career's own result on that night. A booked ask that never came off (missed weight, a pull-out, the run's end) is counted apart.

| club | boxer | division | runs | active weeks | ON A RUN weeks | share | longest run (weeks) | runs a season | longest win streak (bouts) | bouts a run | w-l a run |
|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | wlw | 30 | 2694 | 32 | 1.2% | 0.0 (0-8) | 0.17 | 10.5 (7-19) | 20.9 | 20.7-4.2 |
| TEST | Josh Harper | mww | 30 | 2596 | 40 | 1.5% | 0.0 (0-8) | 0.23 | 7.0 (3-18) | 18.8 | 17.2-7.7 |
| TEST | Kira Mensah | wfw | 30 | 2727 | 25 | 0.9% | 0.0 (0-5) | 0.12 | 6.5 (3-14) | 18.4 | 14.4-5.0 |
| TEST | Lucy Jackson | wlw | 30 | 2694 | 28 | 1.0% | 0.0 (0-8) | 0.15 | 10.5 (7-19) | 20.9 | 20.7-4.2 |


| club | boxer | hot Mondays | door open | no name / no show | asks | Leans Yes | Leans No | booked | ducks | OWED reached | first duck to owed (weeks) | owed bouts booked | owed w-l |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | 32 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - | 0 | 0-0 |
| TEST | Josh Harper | 40 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - | 0 | 0-0 |
| TEST | Kira Mensah | 25 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - | 0 | 0-0 |
| TEST | Lucy Jackson | 28 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - | 0 | 0-0 |


| the gate that stopped the ask on a hot Monday | Mondays | share |
|---|---|---|
| the Ask door: resting after a bout | 77 | 61.6% |
| the Ask door: a bout is booked | 41 | 32.8% |
| the Ask door: hurt | 7 | 5.6% |


| club | boxer | runs | day 364 | LADDERPROBE4 day 364 | day 728 | LADDERPROBE4 day 728 | change at day 728 |
|---|---|---|---|---|---|---|---|
| QUICK | Lucy Jackson | 30 | 40.0 (22-52) | 43.0 | 54.5 (43-76) | 59.0 | -10.0 |
| TEST | Josh Harper | 30 | 35.5 (17-55) | 33.0 | 53.0 (31-64) | 52.5 | +0.0 |
| TEST | Kira Mensah | 30 | 35.0 (20-42) | 35.5 | 29.5 (0-62) | 35.5 | -9.0 |
| TEST | Lucy Jackson | 30 | 40.0 (22-52) | 43.0 | 54.5 (43-76) | 59.0 | -10.0 |

The points are the same marks LADDERPROBE4 printed (docs/LADDERPROBE4_RESULT.md, "Our boxers' points"), read from that doc's own table. The only difference in the day loop is the hot Monday's ask: where it booked a night the sheet would have had, the points move with it.

| wins in a row | points in 8 weeks | ON A RUN weeks | share of active weeks | runs a season | note |
|---|---|---|---|---|---|
| 3 | 5 | 2417 | 22.6% | 2.21 |  |
| 3 | 8 | 1247 | 11.6% | 1.44 |  |
| 3 | 10 | 654 | 6.1% | 0.88 |  |
| 3 | 12 | 359 | 3.4% | 0.62 |  |
| 3 | 15 | 125 | 1.2% | 0.23 | the shipped threshold |
| 3 | 20 | 14 | 0.1% | 0.03 |  |
| 2 | 15 | 529 | 4.9% | 0.44 |  |
| 4 | 15 | 68 | 0.6% | 0.13 |  |

A read of the same active weeks at other numbers - nothing changed, nothing replayed. The denominator stays the weeks with 3+ bouts fought, so every row compares with the shipped one.
## The three lines

**Is ON A RUN rare enough to feel earned (10-30% of active weeks)? NO** - 125 of 10711 active weeks (1.2%), over the weeks she had fought 3+ bouts; longest run 0.0 (0-8) weeks, 0.17 runs a full season. The number that would hit the target: 3 wins in a row and +5 points in 8 weeks would read 22.6% (a read of the same weeks, not a change).

**Do ducks happen a few times a season (not never, not weekly)? NO - never** - 0 ducks over 240 full boxer-seasons (0.00 a season), from 0 asks made while on a run (0 Leans No, 0 Leans Yes). **Not one ask was made: the door was shut on every hot Monday** (125 of them). The sheet's next offer lands on the very day the rest after a bout ends (Bouts.AFTER_FIGHT 10 is both after_fight's next_offer_day and AskBout.open's due), so a gym that answers its own sheet at once has no open day between bouts: a next-offer gap of 17 (the rest plus a week) would leave a free Monday to ask on. The duck window itself was never reached.

**Does OWED ever fire? NO** - 0 OWED reached over the 60 runs (0 ducks in all), - weeks from the first duck to the owed ask; 0 owed bouts booked (w-l 0-0), 0 still owed at day 735. Two ducks inside 8 weeks (RivalOffer.DUCK_WINDOW) are needed, and a duck is logged once a week at most: the ask has to come round again while the boxer is still on a run.

Read: 60 runs, 12600 boxer-Mondays, 10711 active weeks pooled, 125 of them ON A RUN (1.2%). 125 hot Mondays: the door open on 0, shut on 125; 0 asks made (no card kind), 0 booked, 0 refused by the corner, 0 leaned Yes but would not book. The asks booked 0 bouts: 0-0 (0 drawn, 0 never came off). 0 ducks, 0 OWED reached, 0 owed bouts booked, 0 still owed at the run's end. The fight week lock refused 0 weeks; runs closed early: 0; boxers left mid-run: 0.

Reproduce: `python ops/Tools/godot_slot.py run --who streakprobe1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/streakprobe1.log --path . --script res://tools/streak_probe.gd -- seeds=30 seed=4421 days=735`
