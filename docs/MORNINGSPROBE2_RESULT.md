# MORNINGSPROBE2 - coached mornings on the BUILT club week: does the week plan make a real choice?

Probe run: 2026-11-19T07:18:06. 40 seeds off 4421 (seeds 4421..4460), 112 days (16 weeks) a run, 480 runs, 440s. A measurement only: no rule or constant was changed.
## Population
The **TEST CLUB** (scripts/state/TestClub.gd): three boxers in three weight classes - **Lucy** (women's lightweight), **Kira** (women's featherweight), **Josh** (men's welterweight) - and **Ana** the no-gi grappler on the mats, who takes no mornings (MorningWire deals over c.fighters only). Coach **Reid** hired, run **sessional** (You 4 + coach 2 = 6 slots) and **full time** (4 + 3 = 7). Past the first-week guide and the first hour, on the classic calendar; cash floored at $20000 so money never binds. No two fighters in a measurement are identical: three distinct boxers against the game's own named rivals. The club is the SAME on every seed and in every arm - the paired comparison the brief's trap asks for. What the seed varies is the world around it: the rivals' invented pasts (RivalPast.seed), the bout dice (LiveRound / Injuries read c.seed), the week's twist card, the sheet and the rival gyms' calls. Starting abilities and potential as the game writes them:

| boxer | division | potential | power | speed | technique | defense | conditioning | fight_iq | weakest at day 0 |
|---|---|---|---|---|---|---|---|---|---|
| Lucy Jackson | wlw | 84 | 58.4 | 63.2 | 60.1 | 57.3 | 61.6 | 59.0 | defense |
| Kira Mensah | wfw | 86 | 54.0 | 66.5 | 59.0 | 57.5 | 58.0 | 57.0 | power |
| Josh Harper | mww | 79 | 63.0 | 56.0 | 55.5 | 55.0 | 65.0 | 56.0 | defense |

## Method
- 112 days through **Sim.step_day**, every sheet offer accepted and every bout fought by the sim, the fight week drafted and locked, the camp started, the weigh-in taken, pro offers declined, the rival gyms' calls answered by the run seed's policy - tools/ladder_probe.gd's own loop (_career / _answer / _week copied, that file never edited; tools/ladder_probe_offers.gd preloaded). The four policies are set on day 0 and again each Monday through the game's own plan setter **WeekPhase.edit** (the Training screen's `wday` act, scripts/ui/BoutActs.gd), after **WeekPhase.ensure** as WeekData.plan_of reads the week; a phase change drops the exceptions as the game does and the next Monday lays the policy again.
- **ALIGNED**: every boxer on the club's most common default week (WeekPlan.coach_of, exact cards, a tie takes the first boxer's) - the same ability on the same morning, so the coach can pair them. **WEAKEST**: each boxer's training mornings on the session that trains her own lowest fight ability (WeekPhase.FOCUS, the game's own camp map), the coach's intensity and rest days kept. **DEFAULT**: the plans the club starts with, untouched. **CONTROL**: DEFAULT plans, no coached mornings. **fight_iq has no morning session** (WeekPlan.SESSIONS trains only power, speed, technique, defense, conditioning and chin): WEAKEST aims at the lowest ability a morning CAN train, and the aim table still counts fight_iq as the true hole whenever it is one - the game's own FOCUS map would send that hole to shadow, which trains technique instead.
- **CONTROL needs no game edit, but it cannot hold the other two boxers.** CoachedMornings.owned() is at least YOU_OWNED (4) for every coach kind - no "none" the career can reach - and MorningWire.deal returns {} only below two boxers. So CONTROL runs each boxer ALONE on the books (the game's own one-boxer rule, v11 section 2, asserted by morning_deal_test), same seed, same DEFAULT plan, deal empty (0 shared + 0 solo slots in every CONTROL run). Confounds named: alone she never shares a fight-week film night (FilmSeats.owned), so her tape read can be fuller than in the three-boxer club, and a different bout result knocks on into rest, injury and morale. **The big one: the region's show-day rival bouts are drawn with ONE shared RNG walked division by division (Region.day_events, rng.seed = c.day * 97 + 11, the busy list built from our booked boxers), so with two boxers absent the draw sequence shifts for every later division and those boxers face different opponents' records and ratings.** Only the first division in Data.DIVISIONS keeps its paired world; the table below shows which boxer that is (identical nights, record and ladder in both arms). The **same nights** column counts the seeds where her bout nights matched DEFAULT's exactly; it does NOT promise the same opponents. A whole-club CONTROL of three boxers with no deal would need a game file change; that arm is not run.
- Slots are counted from **MorningWire.deal** after each day's step (the twist drawn, the phase synced): the entry for the day that ran, so a mid-week re-deal is counted too. A SHARED slot is ONE slot for two boxer-mornings; the tables halve the shared boxer-mornings. pts = every stat key gained over the 112 days (as MORNINGSPROBE1 summed them); weak = points on the ability weakest at day 0; power = BoutRules.fight_power gained; win% = the sim's amateur bouts (the career's results), draws counted as bouts not wins; rep = RankLine.rep at day 112, the club's sum in the main table and per boxer elsewhere.
## The choice: slots, points, record and ladder, per policy and coach kind
Per-seed means over 40 seeds. slots/wk = shared slots (one for a pair) and solo slots dealt a week; morns/wk = coached boxer-mornings; best = the share of seeds this policy had the best win rate, ties split.

| coach | policy | shared slots/wk | solo slots/wk | morns/wk | pts | weak | power | bouts | W-L-D | win% | rep (club) | best of 40 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| sessional | ALIGNED | 0.95 | 4.96 | 6.87 | 97.1 | 10.1 | 16.2 | 8.43 | 3.58-4.85-0.00 | 42.4% | 66.8 | 30.8% |
| sessional | WEAKEST | 0.89 | 5.20 | 6.98 | 106.9 | 26.7 | 17.8 | 8.43 | 3.55-4.88-0.00 | 42.1% | 67.8 | 34.6% |
| sessional | DEFAULT | 0.91 | 5.00 | 6.82 | 96.6 | 10.1 | 16.1 | 8.40 | 3.60-4.80-0.00 | 42.9% | 67.1 | 34.6% |
| full_time | ALIGNED | 0.95 | 5.82 | 7.72 | 97.3 | 10.1 | 16.2 | 8.43 | 3.58-4.85-0.00 | 42.4% | 66.8 | 30.8% |
| full_time | WEAKEST | 0.93 | 5.98 | 7.84 | 107.4 | 27.1 | 17.9 | 8.43 | 3.55-4.88-0.00 | 42.1% | 67.8 | 34.6% |
| full_time | DEFAULT | 0.91 | 5.85 | 7.67 | 96.8 | 10.1 | 16.1 | 8.40 | 3.60-4.80-0.00 | 42.9% | 67.1 | 34.6% |

## Per boxer (the same club in every arm)

| coach | policy | boxer | division | pot | weakest at 0 | pts | weak | power | W-L-D | win% | rep |
|---|---|---|---|---|---|---|---|---|---|---|---|
| sessional | ALIGNED | Lucy Jackson | wlw | 84 | defense | 34.4 | 3.0 | 5.7 | 1.63-1.23-0.00 | 57.0% | 31.4 |
| sessional | ALIGNED | Kira Mensah | wfw | 86 | power | 37.0 | 5.0 | 6.2 | 1.05-1.80-0.00 | 36.8% | 8.3 |
| sessional | ALIGNED | Josh Harper | mww | 79 | defense | 25.7 | 2.1 | 4.3 | 0.90-1.83-0.00 | 33.0% | 27.0 |
| sessional | WEAKEST | Lucy Jackson | wlw | 84 | defense | 37.2 | 8.9 | 6.2 | 1.65-1.20-0.00 | 57.9% | 31.7 |
| sessional | WEAKEST | Kira Mensah | wfw | 86 | power | 39.2 | 10.2 | 6.5 | 1.05-1.77-0.00 | 37.2% | 8.3 |
| sessional | WEAKEST | Josh Harper | mww | 79 | defense | 30.5 | 7.5 | 5.1 | 0.85-1.90-0.00 | 30.9% | 27.8 |
| sessional | DEFAULT | Lucy Jackson | wlw | 84 | defense | 34.2 | 3.0 | 5.7 | 1.63-1.23-0.00 | 57.0% | 31.4 |
| sessional | DEFAULT | Kira Mensah | wfw | 86 | power | 36.8 | 5.0 | 6.1 | 1.08-1.77-0.00 | 37.7% | 8.6 |
| sessional | DEFAULT | Josh Harper | mww | 79 | defense | 25.6 | 2.1 | 4.3 | 0.90-1.80-0.00 | 33.3% | 27.1 |
| full_time | ALIGNED | Lucy Jackson | wlw | 84 | defense | 34.4 | 3.0 | 5.7 | 1.63-1.23-0.00 | 57.0% | 31.4 |
| full_time | ALIGNED | Kira Mensah | wfw | 86 | power | 37.0 | 5.0 | 6.2 | 1.05-1.80-0.00 | 36.8% | 8.3 |
| full_time | ALIGNED | Josh Harper | mww | 79 | defense | 25.9 | 2.1 | 4.3 | 0.90-1.83-0.00 | 33.0% | 27.0 |
| full_time | WEAKEST | Lucy Jackson | wlw | 84 | defense | 37.2 | 8.9 | 6.2 | 1.65-1.20-0.00 | 57.9% | 31.7 |
| full_time | WEAKEST | Kira Mensah | wfw | 86 | power | 39.3 | 10.3 | 6.5 | 1.05-1.77-0.00 | 37.2% | 8.3 |
| full_time | WEAKEST | Josh Harper | mww | 79 | defense | 30.9 | 7.8 | 5.1 | 0.85-1.90-0.00 | 30.9% | 27.8 |
| full_time | DEFAULT | Lucy Jackson | wlw | 84 | defense | 34.2 | 3.0 | 5.7 | 1.63-1.23-0.00 | 57.0% | 31.4 |
| full_time | DEFAULT | Kira Mensah | wfw | 86 | power | 36.8 | 5.0 | 6.1 | 1.08-1.77-0.00 | 37.7% | 8.6 |
| full_time | DEFAULT | Josh Harper | mww | 79 | defense | 25.8 | 2.1 | 4.3 | 0.90-1.80-0.00 | 33.3% | 27.1 |

## CONTROL vs DEFAULT - what coached mornings are worth at all
Each boxer alone on the books (the game's own no-deal state), DEFAULT plan, same seed. d = CONTROL - DEFAULT; lower = seeds where her CONTROL win rate was below her DEFAULT win rate; same nights = seeds where her bout nights matched DEFAULT's exactly (the clean pairs).

| coach | boxer | DEFAULT pts | CONTROL pts | d pts | DEFAULT weak | CONTROL weak | d weak | DEFAULT win% | CONTROL win% | DEFAULT rep | CONTROL rep | d rep | lower | same nights |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| sessional | Lucy Jackson | 34.2 | 33.3 | -0.9 | 3.0 | 3.0 | +0.0 | 57.0% | 57.0% | 31.4 | 31.4 | +0.0 | 0/40 | 40/40 |
| sessional | Kira Mensah | 36.8 | 36.9 | +0.1 | 5.0 | 5.0 | +0.0 | 37.7% | 5.4% | 8.6 | 3.8 | -4.7 | 37/40 | 35/40 |
| sessional | Josh Harper | 25.6 | 21.1 | -4.5 | 2.1 | 1.4 | -0.7 | 33.3% | 97.3% | 27.1 | 39.4 | +12.2 | 2/40 | 34/40 |
| full_time | Lucy Jackson | 34.2 | 33.3 | -0.9 | 3.0 | 3.0 | +0.0 | 57.0% | 57.0% | 31.4 | 31.4 | +0.0 | 0/40 | 40/40 |
| full_time | Kira Mensah | 36.8 | 36.9 | +0.0 | 5.0 | 5.0 | +0.0 | 37.7% | 5.4% | 8.6 | 3.8 | -4.7 | 37/40 | 35/40 |
| full_time | Josh Harper | 25.8 | 21.1 | -4.7 | 2.1 | 1.4 | -0.7 | 33.3% | 97.3% | 27.1 | 39.4 | +12.2 | 2/40 | 34/40 |

## Which ability the deal trains (slots a week, by ability)
The lever MORNINGSPROBE1's S513 reading named: not the multiplier but WHICH ability a slot trains. shared = the pair's slot (counted once for the pair), solo = a 1-to-1 turn. The aim table below it counts the TRUE lowest ability on each WEAKEST Monday (fight_iq included, though no morning can train it).

| coach | policy | use | power | speed | technique | defense | conditioning | fight_iq | total/wk |
|---|---|---|---|---|---|---|---|---|---|
| sessional | ALIGNED | shared | 1.44 | 0.47 | 0.01 | 0.00 | 0.00 | 0.00 | 1.91 |
| sessional | ALIGNED | solo | 0.89 | 1.48 | 0.34 | 0.00 | 2.25 | 0.00 | 4.96 |
| sessional | WEAKEST | shared | 0.74 | 0.16 | 0.00 | 0.86 | 0.02 | 0.00 | 1.78 |
| sessional | WEAKEST | solo | 1.52 | 1.13 | 0.00 | 1.80 | 0.74 | 0.00 | 5.20 |
| sessional | DEFAULT | shared | 1.18 | 0.64 | 0.01 | 0.00 | 0.00 | 0.00 | 1.82 |
| sessional | DEFAULT | solo | 1.16 | 1.23 | 0.45 | 0.00 | 2.16 | 0.00 | 5.00 |
| full_time | ALIGNED | shared | 1.44 | 0.47 | 0.01 | 0.00 | 0.00 | 0.00 | 1.91 |
| full_time | ALIGNED | solo | 1.46 | 1.52 | 0.39 | 0.00 | 2.44 | 0.00 | 5.82 |
| full_time | WEAKEST | shared | 0.75 | 0.18 | 0.00 | 0.90 | 0.03 | 0.00 | 1.86 |
| full_time | WEAKEST | solo | 1.66 | 1.36 | 0.00 | 2.11 | 0.85 | 0.00 | 5.98 |
| full_time | DEFAULT | shared | 1.18 | 0.64 | 0.01 | 0.00 | 0.00 | 0.00 | 1.82 |
| full_time | DEFAULT | solo | 1.66 | 1.31 | 0.46 | 0.00 | 2.43 | 0.00 | 5.85 |


| coach | WEAKEST aimed at | boxer-Mondays | share |
|---|---|---|---|
| sessional | power | 286 | 14.9% |
| sessional | speed | 43 | 2.2% |
| sessional | technique | 0 | 0.0% |
| sessional | defense | 122 | 6.4% |
| sessional | conditioning | 0 | 0.0% |
| sessional | fight_iq | 1469 | 76.5% |
| full_time | power | 285 | 14.8% |
| full_time | speed | 43 | 2.2% |
| full_time | technique | 0 | 0.0% |
| full_time | defense | 121 | 6.3% |
| full_time | conditioning | 0 | 0.0% |
| full_time | fight_iq | 1471 | 76.6% |

## Reading
**sessional: A REAL CHOICE - BUT 36 of 40 seeds TIED on the record: most seeds had no win to move, so the band is met by ties, not by a choice (only 4 seeds had an outright winner)** - best by win rate on 40 seeds, ties split (36 seeds tied): ALIGNED 30.8% (0 outright, 35 joint); WEAKEST 34.6% (3 outright, 35 joint); DEFAULT 34.6% (1 outright, 37 joint). Slots a week: ALIGNED 0.95 shared + 4.96 solo; WEAKEST 0.89 shared + 5.20 solo; DEFAULT 0.91 shared + 5.00 solo. The built deal caps a boxer at ONE shared morning a week (week_deal's shared_n), so with three boxers at most ONE pair can share: ALIGNED cannot buy "many shared mornings", and in a base week the club's default weeks are already identical (WEEKS.base carries no camp focus), so ALIGNED and DEFAULT differ only where a fight week writes a different week. What would move it: NOT a multiplier - MORNINGSPROBE1's S513 control raised SHARED to x1.35 and the record did not move. The lever is WHICH ability the shared slot trains: the ability table above shows what each policy's pairs actually drill, and CoachedMornings.shared_focus only picks the pair's lowest-ranked ability among the mornings they BOTH already train - a plan that never matches cannot be paired at any multiplier.

**full_time: A REAL CHOICE - BUT 36 of 40 seeds TIED on the record: most seeds had no win to move, so the band is met by ties, not by a choice (only 4 seeds had an outright winner)** - best by win rate on 40 seeds, ties split (36 seeds tied): ALIGNED 30.8% (0 outright, 35 joint); WEAKEST 34.6% (3 outright, 35 joint); DEFAULT 34.6% (1 outright, 37 joint). Slots a week: ALIGNED 0.95 shared + 5.82 solo; WEAKEST 0.93 shared + 5.98 solo; DEFAULT 0.91 shared + 5.85 solo. The built deal caps a boxer at ONE shared morning a week (week_deal's shared_n), so with three boxers at most ONE pair can share: ALIGNED cannot buy "many shared mornings", and in a base week the club's default weeks are already identical (WEEKS.base carries no camp focus), so ALIGNED and DEFAULT differ only where a fight week writes a different week. What would move it: NOT a multiplier - MORNINGSPROBE1's S513 control raised SHARED to x1.35 and the record did not move. The lever is WHICH ability the shared slot trains: the ability table above shows what each policy's pairs actually drill, and CoachedMornings.shared_focus only picks the pair's lowest-ranked ability among the mornings they BOTH already train - a plan that never matches cannot be paired at any multiplier.

**What coached mornings are worth at all (sessional, CONTROL - DEFAULT, same boxer and seed):** Lucy Jackson: -0.9 pts, +0.0 on the hole, win 57.0% -> 57.0%, ladder +0.0; Kira Mensah: +0.1 pts, +0.0 on the hole, win 37.7% -> 5.4%, ladder -4.7; Josh Harper: -4.5 pts, -0.7 on the hole, win 33.3% -> 97.3%, ladder +12.2. **Read only the paired row** - the boxer whose nights, record and ladder read identical in both arms (the first division in Data.DIVISIONS keeps its opponents when the club is reduced to one): hers is the only difference that can be laid at the coaching's door. The other rows are NOT the value of coaching: Region.day_events draws every division's rival bouts off one shared RNG (rng.seed = c.day * 97 + 11, the busy list built from our booked boxers), so dropping two boxers re-deals the later divisions' opponents, and their win rates swing far beyond anything a morning multiplier does. A clean whole-club control of three boxers needs a game edit (a no-deal flag in MorningWire); this probe does not make one.

**What coached mornings are worth at all (full_time, CONTROL - DEFAULT, same boxer and seed):** Lucy Jackson: -0.9 pts, +0.0 on the hole, win 57.0% -> 57.0%, ladder +0.0; Kira Mensah: +0.0 pts, +0.0 on the hole, win 37.7% -> 5.4%, ladder -4.7; Josh Harper: -4.7 pts, -0.7 on the hole, win 33.3% -> 97.3%, ladder +12.2. **Read only the paired row** - the boxer whose nights, record and ladder read identical in both arms (the first division in Data.DIVISIONS keeps its opponents when the club is reduced to one): hers is the only difference that can be laid at the coaching's door. The other rows are NOT the value of coaching: Region.day_events draws every division's rival bouts off one shared RNG (rng.seed = c.day * 97 + 11, the busy list built from our booked boxers), so dropping two boxers re-deals the later divisions' opponents, and their win rates swing far beyond anything a morning multiplier does. A clean whole-club control of three boxers needs a game edit (a no-deal flag in MorningWire); this probe does not make one.

**The headroom trap (sessional):** WEAKEST gains 106.9 pts against DEFAULT's 96.6 and ALIGNED's 97.1, and 26.7 on the starting holes against DEFAULT's 10.1 - the clamp (potential - stat) pays the hole more per morning, so WEAKEST gains more points anyway. Beside it the record: WEAKEST 42.1%, DEFAULT 42.9%, ALIGNED 42.4%. Points moved and the record did not follow - MORNINGSPROBE1's lesson repeats on the built code.

**The headroom trap (full_time):** WEAKEST gains 107.4 pts against DEFAULT's 96.8 and ALIGNED's 97.3, and 27.1 on the starting holes against DEFAULT's 10.1 - the clamp (potential - stat) pays the hole more per morning, so WEAKEST gains more points anyway. Beside it the record: WEAKEST 42.1%, DEFAULT 42.9%, ALIGNED 42.4%. Points moved and the record did not follow - MORNINGSPROBE1's lesson repeats on the built code.

Fight-week locks refused: 0. Boxers who left mid-run: 0. Runs that closed early: 0.
Reproduce: `python ops/Tools/godot_slot.py run --who morningsprobe2 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --fixed-fps 60 --log-file E:/FightCamp/tmp/morningsprobe2.log --path . --script res://tools/mornings_probe2.gd -- seeds=40 seed=4421 days=112 control=3`
