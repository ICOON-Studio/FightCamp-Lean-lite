# FITPROBE2 + TRAINBALANCE Result

Probe run: 2026-11-19T12:23:33. Coach fit design v8 (approved Q-235).
Map: `ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md` 2.1 (fit multiplies the drill units on pad and sparring nights, and the stat gain on mornings), 12 (pass lines).

## Question

Does a TOP fit bring moves to Sharp sooner on the EVENINGS? FITPROBE1 scaled the morning stat gain only and Sharp did not move
(0.00 weeks sooner, docs/FITPROBE1_RESULT.md): the evenings were never scaled. A pads coach who suits a boxer gets the combination
into her hands weeks sooner - that is what this probe times.

## Method

- `tools/fit_probe2.gd` only, a COPY of `tools/fit_probe.gd`: the same population (60 boxers, seeds 6100..6159), the same paired seeds, the same arms (AVERAGE fit 50, TOP fit 82, CONTROL untouched) and the same bout harness. Nothing in `scripts/` or `tests/` is touched. Part 1: 26 weeks (182 days) of `Sim.step_day` - the game's own week, plan and FOCUS, twist cards, injuries, phase and drilling (`DrillWeek.run` / `PadWeek.run_week`). Luke Reid (sessional, pads 74) in every arm, load normal, no bout (camp mult 1.0).
- THE EVENING LEVER (new): after each week's drills ran (`DrillWeek.run` inside `Sim.end_week`, reached through `Sim.step_day` on the Sunday), every move whose mastery rose this week gets `(CoachFit.gain_mult(fit) - 1) x` THAT WEEK'S RISE (after - before over the week), through `CoachFit.capped(gain_mult, camp mult)` so the x1.6 stack cap holds, never past mastery 100. The week's rise, never the mastery total - scaling the total would compound every week.
- THE MORNING LEVER (FITPROBE1's, unchanged): after each day the probe adds `gain_mult(fit) - 1` of the gain that day gave the FOCUS stat through the same stack cap, and scales the tiredness the day ADDED (its load over the night's recovery, `WeekPlan.fatigue_keep`) by `tired_mult(fit)`; the week's peak the injury roll reads follows it. At fit 50 both multipliers are exactly 1.0, so neither lever writes anything: AVERAGE is the untouched run and CONTROL must equal it to the digit. The headroom clamp is ON: `TrainingPreview.headroom` = (pot - stat)/25 clamped 0.10..1.25, the game's own rule. Sharp = mastery 60.0, read from the constant `FireLevel.SHARP_AT` (the tier a planned line fires at 0.75; `MoveMastery.tier` agrees). Weeks to Sharp counts the first week any move reaches it; 27 = not reached in the window.
- Part 2 (TRAINBALANCE): each week-26 boxer of both arms fights 40 bouts from the same snapshot (no bout teaches into the next), `Bouts.fight_step` + `LiveRound` as `tools/adapt_probe.gd` and `tools/exchange_balance.gd` play them: no shouts, `BoutRules.auto_corner` between rounds, film 1, no camp, morale 60, tiredness 20. One fixed opponent set (`Data.OPPONENTS`), each rated to the boxer's AVERAGE-arm week-26 paper (`BoutRules.fight_power`), the SAME rating in both arms - an equal-paper matchup, the baseline win share measured, not assumed 50%. The baseline printed here is THIS run's measurement, not FITPROBE1's (the game code moves between probes); the paired TOP - AVERAGE diff is the fit's effect.

## Pass lines (map 12)

- FITPROBE2: a move reaches Sharp 2-4 weeks sooner under a TOP fit than under an average one (fit 50).
- TRAINBALANCE: TOP wins +4 to +8 in 100 over AVERAGE, under a good plan's +14 (59 against 45), headroom clamp on.
- CONTROL: AVERAGE against an untouched run of the same seeds must match to the digit.
- The FOCUS stat bar (+3..+5) is FITPROBE1's and the designer's question: today's base morning gain is +3.5 in 26 weeks, so x1.32 can only add ~1. It is printed here as information, not judged.

## Measured (the probe's own output)

```text
FITPROBE2 + TRAINBALANCE (S525): does a TOP fit bring moves to Sharp sooner on the EVENINGS? Map: DESIGN_COACHFIT1_V8 2.1, 12. A copy of tools/fit_probe.gd plus the evening lever; nothing in scripts/ or tests/ is touched.
Arms on the SAME seeds (paired): AVERAGE fit 50, TOP fit 82 (CoachFit.word -> TOP FIT), CONTROL = untouched. fit 50: gain_mult=1.000 tired_mult=1.000 (both must be 1.000: yes). TOP: gain_mult=1.320 tired_mult=0.920, stack cap x1.6 through CoachFit.capped.
EVENING lever: after each week's DrillWeek.run, every move that rose gets (gain_mult - 1) x THE WEEK'S RISE through the stack cap, never past mastery 100. MORNING lever (FITPROBE1's, unchanged): the day's FOCUS gain x gain_mult, the day's added tiredness x tired_mult. Sharp = mastery 60.0, the constant FireLevel.SHARP_AT (a planned line fires at 0.75). Headroom clamp ON (TrainingPreview.headroom): (pot - stat)/25 clamped 0.10..1.25.
Part 1: 26 weeks (182 days) of Sim.step_day - the game's own week, plan and focus, twists, injuries, phase, drilling. Part 2: 40 bouts a boxer per arm, one fixed opponent set, film 1, no camp, morale 60, tiredness 20, auto corner, no shouts.
Population: 60 boxers, seeds 6100..6159, Data.fighter_state on 6 bases (Lucy + the 5 prospects), stats +-6, varied ages, styles, stances, potentials, week cards and FOCUS. Identical rows: 0. Ages 16..27. FOCUS spread: { "power": 9, "speed": 9, "technique": 9, "defense": 9, "conditioning": 8, "fight_iq": 8, "chin": 8 }. Coach in every arm: Luke Reid (sessional, pads 74). Load normal, no bout in part 1 (camp mult 1.0).
TRAINBALANCE fixed opponent set (every boxer, both arms): Maria Ortega (Pressure fighter), Priya Nair (Counter-puncher), Erin Doyle (Volume puncher). Each opponent's rating = the boxer's AVERAGE-arm week-26 paper (BoutRules.fight_power), the SAME rating in both arms - exchange_balance's equal-paper convention, the baseline win share measured, not assumed 50%.
Pilot (4 boxers): 443 ms a training run, 78.1 ms a bout -> projected 7.6 min for 180 runs + 4800 bouts (budget 90 min).
CONTROL determinism (seed 6100 AVERAGE twice): match
FITPROBE2 arm=AVERAGE fit=50 Sharp weeks mean=7.77 p10=7.00 p90=8.00 | reached 59/60 (not reached counted as 27) | on those: mean=7.44 p10=7.00 p90=8.00 | first Sharp move { "Lead hook": 44, "Body hook": 12, "Jab": 3 }
  arm=AVERAGE mastery at week 26: drilled move (Uppercut) mean=31.47 | all 6 moves mean=48.70 p10=45.64 p90=50.93 | weapons (mastery >= 30) 6.00 of 6 | per move: Jab 54.94, Cross 48.57, Lead hook 65.70, Body hook 49.49, Uppercut 31.47, Check hook 42.01
  arm=AVERAGE FOCUS gain mean=+3.530 p10=+0.000 p90=+8.321 (morning lever) | tiredness mean=47.8 peak=55.0 | injured days=56 | week drills ran=1560 | evening lever: +0.00 mastery points a boxer, 0 move-weeks scaled in 0 weeks, 0 move-weeks past MoveMastery.cap | stack cap bound on 0 days/weeks
FITPROBE2 arm=TOP fit=82 Sharp weeks mean=6.23 p10=5.00 p90=7.00 | reached 59/60 (not reached counted as 27) | on those: mean=5.88 p10=5.00 p90=6.20 | first Sharp move { "Check hook": 30, "Lead hook": 23, "Body hook": 3, "Jab": 3 }
  arm=TOP mastery at week 26: drilled move (Uppercut) mean=40.18 | all 6 moves mean=50.24 p10=46.53 p90=53.72 | weapons (mastery >= 30) 6.00 of 6 | per move: Jab 56.50, Cross 50.50, Lead hook 49.26, Body hook 45.26, Uppercut 40.18, Check hook 59.74
  arm=TOP FOCUS gain mean=+4.483 p10=+0.000 p90=+10.469 (morning lever) | tiredness mean=37.8 peak=50.4 | injured days=56 | week drills ran=1560 | evening lever: +40.53 mastery points a boxer, 2286 move-weeks scaled in 890 weeks, 0 move-weeks past MoveMastery.cap | stack cap bound on 0 days/weeks
FITPROBE2 arm=CONTROL fit=50 Sharp weeks mean=7.77 p10=7.00 p90=8.00 | reached 59/60 (not reached counted as 27) | on those: mean=7.44 p10=7.00 p90=8.00 | first Sharp move { "Lead hook": 44, "Body hook": 12, "Jab": 3 }
  arm=CONTROL mastery at week 26: drilled move (Uppercut) mean=31.47 | all 6 moves mean=48.70 p10=45.64 p90=50.93 | weapons (mastery >= 30) 6.00 of 6 | per move: Jab 54.94, Cross 48.57, Lead hook 65.70, Body hook 49.49, Uppercut 31.47, Check hook 42.01
  arm=CONTROL FOCUS gain mean=+3.530 p10=+0.000 p90=+8.321 (morning lever) | tiredness mean=47.8 peak=55.0 | injured days=56 | week drills ran=1560 | evening lever: +0.00 mastery points a boxer, 0 move-weeks scaled in 0 weeks, 0 move-weeks past MoveMastery.cap | stack cap bound on 0 days/weeks
CONTROL AVERAGE against an untouched run of the same seeds (no probe scaling): match
TRAINBALANCE opponent rating = AVERAGE week-26 paper: mean 62.96, range 59.31..68.94 (fixed for both arms).
TRAINBALANCE arm=AVERAGE wins=724/2400 = 30.17 in 100
TRAINBALANCE arm=TOP wins=726/2400 = 30.25 in 100
PER BOXER (paired seeds): seed name age style div focus | gain A / T | Sharp wk A / T | all-move mastery A / T | wins A / T of 40
  6100 Alex Smith     20 Slugger          wlw  power        |  +4.72  +6.01 |  8  6 | 48.66 47.82 |  6  7
  6101 Sam Jones      22 Boxer-puncher    wfw  speed        |  +1.03  +1.34 |  8  6 | 48.47 47.10 |  7  7
  6102 Jordan Brown   19 Volume puncher   www  technique    | +11.01 +13.55 |  7  6 | 48.80 53.33 | 13 14
  6103 Taylor Wilson  22 Out-boxer        wmw  defense      |  +0.77  +1.02 |  8  6 | 48.74 47.58 | 12 12
  6104 Morgan Taylor  19 Counter-puncher  mlw  conditioning |  +8.71 +11.00 |  7  5 | 51.45 50.44 | 13 13
  6105 Casey Davies   24 Counter-puncher  mww  fight_iq     |  +3.94  +5.11 |  7  5 | 49.72 47.99 | 12 13
  6106 Riley Evans    24 Pressure fighter wlw  chin         |  +0.00  +0.00 |  7  6 | 48.70 52.86 | 13 13
  6107 Quinn Thomas   16 Pressure fighter wfw  power        |  +5.75  +7.59 |  7  5 | 52.04 51.90 |  8  7
  6108 Avery Roberts  18 Pressure fighter www  speed        |  +1.76  +2.29 |  8  6 | 45.77 43.52 | 13  9
  6109 Skyler Johnson 24 Volume puncher   wmw  technique    |  +4.46  +5.56 |  7  6 | 52.28 57.34 | 16 20
  6110 Jamie Walker   18 Out-boxer        mlw  defense      |  +1.21  +1.60 |  7  5 | 50.91 50.78 | 10  7
  6111 Drew Wright    26 Out-boxer        mww  conditioning |  +2.53  +3.15 |  7  6 | 48.59 53.06 | 13 13
  6112 Blake Robinson 24 Counter-puncher  wlw  fight_iq     |  +0.93  +1.22 | 27 27 | 42.76 46.42 | 13 15
  6113 Cameron White  17 Boxer-puncher    wfw  chin         |  +0.00  +0.00 |  8  8 | 47.22 52.38 | 12 12
  6114 Dakota Thompson 19 Out-boxer        www  power        |  +5.58  +7.06 |  9  6 | 47.38 45.09 | 14 12
  6115 Emerson Moore  21 Boxer-puncher    wmw  speed        |  +1.36  +1.77 |  7  6 | 45.77 49.50 | 15 16
  6116 Finley Clark   18 Counter-puncher  mlw  technique    |  +8.31 +10.46 |  7  6 | 49.24 53.84 | 12 13
  6117 Harper Lewis   22 Pressure fighter mww  defense      |  +1.01  +1.33 |  7  6 | 44.13 47.56 | 12 12
  6118 Hayden Hall    19 Pressure fighter wlw  conditioning |  +5.33  +6.75 |  6  5 | 53.07 53.71 | 15 14
  6119 Jesse Young    21 Pressure fighter wfw  fight_iq     |  +2.27  +2.99 |  7  6 | 48.66 53.69 | 10 11
  6120 Kai King       17 Pressure fighter www  chin         |  +0.00  +0.00 |  8  6 | 54.92 51.67 | 13 11
  6121 Lane Baker     27 Boxer-puncher    wmw  power        |  +4.51  +5.75 |  8  6 | 48.06 47.31 | 14 13
  6122 Logan Lee      21 Pressure fighter mlw  speed        |  +1.43  +1.87 |  8  6 | 50.33 50.64 | 15 14
  6123 Parker Green   24 Slugger          mww  technique    |  +5.81  +7.22 |  8  6 | 48.82 47.55 |  8 10
  6124 Reese Adams    21 Pressure fighter wlw  defense      |  +1.13  +1.49 |  7  5 | 50.07 50.17 | 14 14
  6125 Rowan Nelson   16 Slugger          wfw  conditioning |  +7.41  +9.34 |  7  5 | 48.38 47.07 |  9  8
  6126 Sage Mitchell  16 Slugger          www  fight_iq     |  +4.75  +6.20 |  8  6 | 50.91 49.17 | 11  7
  6127 Spencer Harris 21 Out-boxer        wmw  chin         |  +0.00  +0.00 |  8  8 | 45.16 49.70 | 10 11
  6128 Tatum Turner   19 Volume puncher   mlw  power        |  +4.97  +6.38 |  7  5 | 48.81 47.87 | 10 10
  6129 Winter Fox     24 Slugger          mww  speed        |  +1.94  +2.53 |  8  6 | 46.69 50.45 | 10 11
  6130 Alex Jones     23 Slugger          wlw  technique    |  +6.21  +7.83 |  8  6 | 49.35 49.46 | 14 14
  6131 Sam Brown      21 Out-boxer        wfw  defense      |  +1.09  +1.43 |  7  6 | 45.47 49.02 | 11 11
  6132 Jordan Wilson  16 Pressure fighter www  conditioning |  +8.56 +10.55 |  7  6 | 49.42 53.65 | 15 15
  6133 Taylor Taylor  21 Pressure fighter wmw  fight_iq     |  +1.97  +2.56 |  7  6 | 45.64 49.42 | 12 13
  6134 Morgan Davies  20 Pressure fighter mlw  chin         |  +0.00  +0.00 |  7  5 | 50.51 49.55 | 10  9
  6135 Casey Evans    23 Volume puncher   mww  power        |  +3.21  +4.09 |  9  8 | 45.60 50.45 |  8  9
  6136 Riley Thomas   21 Counter-puncher  wlw  speed        |  +0.75  +0.98 |  8  6 | 48.81 49.30 |  9  8
  6137 Quinn Roberts  18 Volume puncher   wfw  technique    |  +9.65 +12.18 |  8  6 | 45.64 45.48 |  9 11
  6138 Avery Johnson  18 Boxer-puncher    www  defense      |  +2.27  +2.99 |  8  6 | 48.87 46.54 | 12 10
  6139 Skyler Walker  27 Pressure fighter wmw  conditioning |  +4.90  +6.12 |  7  6 | 50.22 55.21 | 14 15
  6140 Jamie Wright   21 Out-boxer        mlw  fight_iq     |  +2.55  +3.32 |  7  5 | 51.05 50.96 | 13 12
  6141 Drew Robinson  21 Slugger          mww  chin         |  +0.00  +0.00 |  7  5 | 47.76 46.14 | 11 11
  6142 Blake White    20 Boxer-puncher    wlw  power        |  +8.23 +10.44 |  8  7 | 49.84 53.92 | 16 13
  6143 Cameron Thompson 22 Out-boxer        wfw  speed        |  +0.88  +1.16 |  8  7 | 48.20 53.41 | 13 15
  6144 Dakota Moore   18 Counter-puncher  www  technique    |  +9.18 +11.29 |  8  6 | 46.14 44.18 | 12 10
  6145 Emerson Clark  21 Boxer-puncher    wmw  defense      |  +0.53  +0.70 |  7  6 | 48.04 52.70 | 16 16
  6146 Finley Lewis   23 Counter-puncher  mlw  conditioning |  +7.57  +9.55 |  7  5 | 50.15 49.08 | 12 13
  6147 Harper Hall    26 Slugger          mww  fight_iq     |  +3.55  +4.60 |  9  6 | 50.85 54.82 | 11 12
  6148 Hayden Young   23 Counter-puncher  wlw  chin         |  +0.00  +0.00 |  7  5 | 50.59 48.99 | 12 11
  6149 Jesse King     22 Counter-puncher  wfw  power        |  +5.75  +7.59 |  7  5 | 50.44 49.47 | 13 14
  6150 Kai Baker      17 Boxer-puncher    www  speed        |  +2.73  +3.56 |  7  6 | 50.35 53.43 | 11 13
  6151 Lane Lee       21 Pressure fighter wmw  technique    |  +3.99  +4.98 |  7  6 | 47.15 50.77 | 16 17
  6152 Logan Green    19 Boxer-puncher    mlw  defense      |  +1.13  +1.49 |  7  5 | 49.11 47.71 | 10  9
  6153 Parker Adams   26 Out-boxer        mww  conditioning |  +7.98  +9.93 |  7  6 | 48.02 52.45 | 14 14
  6154 Reese Nelson   21 Volume puncher   wlw  fight_iq     |  +1.96  +2.57 |  6  5 | 48.07 52.15 | 15 16
  6155 Rowan Mitchell 18 Volume puncher   wfw  chin         |  +0.00  +0.00 |  7  6 | 49.94 54.97 | 12 12
  6156 Sage Harris    21 Counter-puncher  www  power        |  +3.12  +3.94 |  9  6 | 48.31 46.73 | 14 14
  6157 Spencer Turner 23 Out-boxer        wmw  speed        |  +1.83  +2.39 |  7  6 | 48.58 53.17 | 14 14
  6158 Tatum Fox      20 Out-boxer        mlw  technique    |  +8.46 +10.66 |  7  6 | 47.56 52.40 | 14 17
  6159 Winter Smith   22 Boxer-puncher    mww  defense      |  +1.09  +1.44 |  8  7 | 47.63 51.35 |  8  9
FITPROBE2 TOP - AVERAGE: Sharp 1.53 weeks sooner (bar 2..4: OUT) | paired on the 59 Sharp in both arms: 1.56 weeks sooner (57 sooner, 0 later, 2 the same week) | reached AVERAGE 59/60, TOP 59/60 (not reached counted as 27)
  Mastery at week 26: all 6 moves +1.543 (AVERAGE 48.70, TOP 50.24) | the drilled move (Uppercut) +8.705 (AVERAGE 31.47, TOP 40.18). FOCUS gain (morning lever, informational - the stat bar is the designer's question): +0.953 over 26 weeks.
TRAINBALANCE TOP - AVERAGE: +0.08 wins in 100 (bar +4..+8: OUT; under a good plan's +14, 59 against 45: yes) | FITPROBE2 fail (Sharp fail) | TRAINBALANCE fail (band fail, under the plan pass)
```

## Verdict

- Sharp weeks sooner: **+1.53** (bar 2..4); paired on the 59 boxers Sharp in both arms: +1.56 (57 sooner, 0 later).
- Mastery at week 26, all 6 moves: **+1.543** (AVERAGE 48.70, TOP 50.24). The drilled move (Uppercut): **+8.705** (AVERAGE 31.47, TOP 40.18).
- Wins in 100 difference: **+0.08** (bar +4..+8, under the plan's +14).
- FOCUS gain difference (morning lever, informational): **+0.953**.
- CONTROL (AVERAGE vs untouched): **match**. Determinism (one arm twice): **match**.
- **FITPROBE2 fail** | **TRAINBALANCE fail**

A gate FAIL is a finding for the designer, not a broken probe: the numbers above are what the mechanism did.

Elapsed: 838 s. Reproduce: `python ops/Tools/godot_slot.py run --who fitprobe2 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe2.gd`

## Findings (what the numbers say)

- The evening lever is live: TOP fit 82 (x1.320) scales every move's WEEKLY rise. Mean mastery of all 6 moves at week 26: +1.543 (AVERAGE 48.70 -> TOP 50.24); the move she started drilling (Uppercut): +8.705 (31.47 -> 40.18); weapons (mastery >= 30) 6.00 -> 6.00 of 6. The fit also REDISTRIBUTES the hand: a move that turns a weapon sooner hands the pad nights to the next one (DrillWeek.run's learning pick), so the per-move means above are not all higher - the read is the whole hand and the time to Sharp, not one move's mastery.
- Sharp comes only +1.53 weeks sooner, under the 2-4 week bar (paired on the 59 Sharp in both arms: +1.56; 57 sooner, 0 later). x1.320 on the weekly rise does not buy 2-4 weeks: the first Sharp move already lands in week 7.8 on average, and the ceiling `MoveMastery.cap(technique, fight_iq)` with the room-left factor `(1 - m/cap)` in `MoveMastery.gain` flattens each week's rise as the move nears it, so a multiplier on the rise buys less time the closer the move is to Sharp. The bar is the designer's question - the mechanism is measured here, not tuned.
- TRAINBALANCE: +0.08 wins in 100 (bar +4..+8), under a good plan's +14: a TOP fit is not too much on the plan's scale. The equal-paper baseline win share is printed above (the live round reads moves and plan, not paper alone), so the diff is not on the bar's 59-vs-45 scale; the band and the plan ceiling are read on the measured diff either way. The morning lever is FITPROBE1's and unchanged: FOCUS +0.953 over 26 weeks (FITPROBE1 measured +0.953) - the stat bar (+3..+5) stays out of reach of x1.320 on a base gain of ~+3.5, a design question for Claude, not this probe's. CONTROL holds: AVERAGE (fit 50, both multipliers exactly 1.0) equals an untouched run of the same seeds to the digit, so every difference above is the fit and nothing else.
