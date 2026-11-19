# FITPROBE1 + TRAINBALANCE Result

Probe run: 2026-11-19T09:43:35. Coach fit design v8 (board Q-S294-235 approved; Dola 7/7, John 7/6).
Map: `ops/research/DESIGN_COACHFIT1_V8_REVISE_KALLI_KALLI.md` 2.1-2.2 (fit), 12 (probes and pass lines).

## Question

Is a TOP fit worth having, and is it not too much? Two identical twins, two coaches, six months: the better-matched
coach's boxer should be clearly sharper on what they worked on, but not unbeatable - the plan still matters more.

## Method

- `tools/fit_probe.gd` only. Nothing in `scripts/` or `tests/` is touched; the arms differ inside the probe.
- Part 1: 26 weeks (182 days) of `Sim.step_day` - the game's own week, the boxer's own plan and FOCUS, the twist cards, injuries, the phase and the week's drilling (`DrillWeek` / `PadWeek`). Luke Reid (sessional, pads 74) in every arm, load normal, no bout.
- After each day the probe adds `gain_mult(fit) - 1` of the gain that day gave the FOCUS stat, through `CoachFit.capped(gain_mult, camp mult)` so the x1.6 stack cap holds, and scales the tiredness the day ADDED (its load over the night's recovery, `WeekPlan.fatigue_keep`) by `tired_mult(fit)`; the week's peak the injury roll reads follows it. At fit 50 both multipliers are exactly 1.0, so nothing is written.
- Part 2: each week-26 boxer of both arms fights 40 bouts from the same snapshot (no bout teaches into the next), `Bouts.fight_step` + `LiveRound` as `tools/adapt_probe.gd` and `tools/exchange_balance.gd` play them: no shouts, `BoutRules.auto_corner` between rounds, film 1, no camp, morale 60, tiredness 20. One fixed opponent set (`Data.OPPONENTS`), each rated to the boxer's AVERAGE-arm week-26 paper (`BoutRules.fight_power`), the SAME rating in both arms - exchange_balance's rating = paper convention, an equal-paper matchup (the baseline win share is measured, not assumed 50%).
- The headroom clamp is ON: `TrainingPreview.headroom` = (pot - stat)/25 clamped 0.10..1.25, the game's own rule.
- Sharp = mastery 60 (`MoveMastery`'s Sharp tier). Weeks to Sharp counts the first week any move reaches it; 27 = not reached in the window.

## Pass lines (map 12)

- FITPROBE1: TOP - AVERAGE = +3 to +5 on the FOCUS stat over 26 weeks; a drilled move reaches Sharp 2-4 weeks sooner.
- TRAINBALANCE: TOP wins +4 to +8 in 100 over AVERAGE, under a good plan's +14 (59 against 45), headroom clamp on.
- CONTROL: AVERAGE against an untouched run of the same seeds must match to the digit.

## Measured (the probe's own output)

```text
FITPROBE1 + TRAINBALANCE (S524): is a TOP fit worth having, and is it not too much?
Map: DESIGN_COACHFIT1_V8 2.1-2.2, 12. Probe only - the arms differ inside tools/fit_probe.gd, nothing in scripts/ or tests/.
Arms on the SAME seeds (paired): AVERAGE fit 50, TOP fit 82 (CoachFit.word -> TOP FIT), CONTROL = untouched, no probe scaling.
fit 50 equals today exactly: gain_mult(50)=1.000 tired_mult(50)=1.000 (both must be 1.000: yes)
TOP fit 82: gain_mult=1.320 tired_mult=0.920; stack cap x1.6 through CoachFit.capped(gain_mult, camp mult).
Headroom clamp ON (TrainingPreview.headroom): (pot - stat)/25 clamped 0.10..1.25 - the game's own gain rule, untouched.
Part 1: 26 weeks (182 days) of Sim.step_day - the game's own week, plan and focus, twists, injuries, phase, drilling.
Part 2: 40 bouts a boxer per arm, one fixed opponent set, film 1, no camp, morale 60, tiredness 20, auto corner, no shouts.
Population: 60 boxers, seeds 6100..6159, Data.fighter_state on 6 bases (Lucy + the 5 prospects), stats +-6, varied ages,
  styles, stances, potentials, week cards and FOCUS. Identical rows: 0. Ages 16..27. Styles 6. Sexes { "f": 40, "m": 20 }. Divisions 6.
  FOCUS spread: { "power": 9, "speed": 9, "technique": 9, "defense": 9, "conditioning": 8, "fight_iq": 8, "chin": 8 }. Coach in every arm: Luke Reid (sessional, pads 74). Load normal, no bout in part 1 (camp mult 1.0).
TRAINBALANCE fixed opponent set (every boxer, both arms): Maria Ortega (Pressure fighter), Priya Nair (Counter-puncher), Erin Doyle (Volume puncher).
  Each opponent's rating = the boxer's AVERAGE-arm week-26 paper (BoutRules.fight_power), the SAME rating in both arms
  (tools/exchange_balance.gd's rating = paper convention: an equal-paper matchup; the baseline win share is measured, not assumed 50%).
Pilot: 397 ms a training run, 48.3 ms a bout -> projected 5.1 min for 180 runs + 4800 bouts.
CONTROL determinism (seed 6100 AVERAGE twice): match
FITPROBE1 arm=AVERAGE fit=50 FOCUS gain mean=+3.530 p10=+0.000 p90=+8.321 | Sharp weeks mean=7.77 (reached 59/60, first Sharp move { "Lead hook": 44, "Body hook": 12, "Jab": 3 })
  arm=AVERAGE drilled move (Uppercut) Sharp weeks mean=27.00 | tiredness mean=47.8 peak=55.0 | injured days=56 | stack cap bound on 0 days
FITPROBE1 arm=TOP fit=82 FOCUS gain mean=+4.483 p10=+0.000 p90=+10.469 | Sharp weeks mean=7.77 (reached 59/60, first Sharp move { "Lead hook": 44, "Body hook": 12, "Jab": 3 })
  arm=TOP drilled move (Uppercut) Sharp weeks mean=27.00 | tiredness mean=37.8 peak=50.4 | injured days=56 | stack cap bound on 0 days
FITPROBE1 arm=CONTROL fit=50 FOCUS gain mean=+3.530 p10=+0.000 p90=+8.321 | Sharp weeks mean=7.77 (reached 59/60, first Sharp move { "Lead hook": 44, "Body hook": 12, "Jab": 3 })
  arm=CONTROL drilled move (Uppercut) Sharp weeks mean=27.00 | tiredness mean=47.8 peak=55.0 | injured days=56 | stack cap bound on 0 days
CONTROL AVERAGE against an untouched run of the same seeds (no probe scaling): match
TRAINBALANCE opponent rating = AVERAGE week-26 paper: mean 62.96, range 59.31..68.94 (fixed for both arms).
TRAINBALANCE arm=AVERAGE wins=721/2400 = 30.04 in 100 (stoppages 19)
TRAINBALANCE arm=TOP wins=737/2400 = 30.71 in 100 (stoppages 21)
PER BOXER (paired seeds): seed name age style div focus | gain A / T / diff | Sharp wk A / T | wins A / T of 40
  6100 Alex Smith     20 Slugger          wlw  power        |  +4.72  +6.01  +1.29 |  8  8 |  6  6
  6101 Sam Jones      22 Boxer-puncher    wfw  speed        |  +1.03  +1.34  +0.32 |  8  8 |  7  7
  6102 Jordan Brown   19 Volume puncher   www  technique    | +11.01 +13.55  +2.54 |  7  7 | 13 14
  6103 Taylor Wilson  22 Out-boxer        wmw  defense      |  +0.77  +1.02  +0.25 |  8  8 | 12 12
  6104 Morgan Taylor  19 Counter-puncher  mlw  conditioning |  +8.71 +11.00  +2.29 |  7  7 | 13 13
  6105 Casey Davies   24 Counter-puncher  mww  fight_iq     |  +3.94  +5.11  +1.17 |  7  7 | 12 12
  6106 Riley Evans    24 Pressure fighter wlw  chin         |  +0.00  +0.00  +0.00 |  7  7 | 13 13
  6107 Quinn Thomas   16 Pressure fighter wfw  power        |  +5.75  +7.59  +1.84 |  7  7 |  8  8
  6108 Avery Roberts  18 Pressure fighter www  speed        |  +1.76  +2.29  +0.53 |  8  8 | 12 12
  6109 Skyler Johnson 24 Volume puncher   wmw  technique    |  +4.46  +5.56  +1.10 |  7  7 | 16 19
  6110 Jamie Walker   18 Out-boxer        mlw  defense      |  +1.21  +1.60  +0.39 |  7  7 | 10 10
  6111 Drew Wright    26 Out-boxer        mww  conditioning |  +2.53  +3.15  +0.62 |  7  7 | 13 13
  6112 Blake Robinson 24 Counter-puncher  wlw  fight_iq     |  +0.93  +1.22  +0.29 | 27 27 | 13 13
  6113 Cameron White  17 Boxer-puncher    wfw  chin         |  +0.00  +0.00  +0.00 |  8  8 | 12 12
  6114 Dakota Thompson 19 Out-boxer        www  power        |  +5.58  +7.06  +1.48 |  9  9 | 14 14
  6115 Emerson Moore  21 Boxer-puncher    wmw  speed        |  +1.36  +1.77  +0.41 |  7  7 | 15 16
  6116 Finley Clark   18 Counter-puncher  mlw  technique    |  +8.31 +10.46  +2.15 |  7  7 | 12 12
  6117 Harper Lewis   22 Pressure fighter mww  defense      |  +1.01  +1.33  +0.32 |  7  7 | 12 12
  6118 Hayden Hall    19 Pressure fighter wlw  conditioning |  +5.33  +6.75  +1.42 |  6  6 | 15 15
  6119 Jesse Young    21 Pressure fighter wfw  fight_iq     |  +2.27  +2.99  +0.72 |  7  7 | 10 10
  6120 Kai King       17 Pressure fighter www  chin         |  +0.00  +0.00  +0.00 |  8  8 | 13 13
  6121 Lane Baker     27 Boxer-puncher    wmw  power        |  +4.51  +5.75  +1.25 |  8  8 | 14 14
  6122 Logan Lee      21 Pressure fighter mlw  speed        |  +1.43  +1.87  +0.44 |  8  8 | 15 15
  6123 Parker Green   24 Slugger          mww  technique    |  +5.81  +7.22  +1.41 |  8  8 |  8  8
  6124 Reese Adams    21 Pressure fighter wlw  defense      |  +1.13  +1.49  +0.36 |  7  7 | 14 14
  6125 Rowan Nelson   16 Slugger          wfw  conditioning |  +7.41  +9.34  +1.93 |  7  7 |  9  9
  6126 Sage Mitchell  16 Slugger          www  fight_iq     |  +4.75  +6.20  +1.45 |  8  8 | 11 11
  6127 Spencer Harris 21 Out-boxer        wmw  chin         |  +0.00  +0.00  +0.00 |  8  8 | 10 10
  6128 Tatum Turner   19 Volume puncher   mlw  power        |  +4.97  +6.38  +1.41 |  7  7 | 10 11
  6129 Winter Fox     24 Slugger          mww  speed        |  +1.94  +2.53  +0.59 |  8  8 | 10 10
  6130 Alex Jones     23 Slugger          wlw  technique    |  +6.21  +7.83  +1.61 |  8  8 | 14 14
  6131 Sam Brown      21 Out-boxer        wfw  defense      |  +1.09  +1.43  +0.35 |  7  7 | 11 11
  6132 Jordan Wilson  16 Pressure fighter www  conditioning |  +8.56 +10.55  +1.99 |  7  7 | 14 14
  6133 Taylor Taylor  21 Pressure fighter wmw  fight_iq     |  +1.97  +2.56  +0.59 |  7  7 | 12 12
  6134 Morgan Davies  20 Pressure fighter mlw  chin         |  +0.00  +0.00  +0.00 |  7  7 | 10 10
  6135 Casey Evans    23 Volume puncher   mww  power        |  +3.21  +4.09  +0.88 |  9  9 |  8  9
  6136 Riley Thomas   21 Counter-puncher  wlw  speed        |  +0.75  +0.98  +0.23 |  8  8 |  9  9
  6137 Quinn Roberts  18 Volume puncher   wfw  technique    |  +9.65 +12.18  +2.53 |  8  8 |  9 10
  6138 Avery Johnson  18 Boxer-puncher    www  defense      |  +2.27  +2.99  +0.72 |  8  8 | 12 12
  6139 Skyler Walker  27 Pressure fighter wmw  conditioning |  +4.90  +6.12  +1.22 |  7  7 | 14 14
  6140 Jamie Wright   21 Out-boxer        mlw  fight_iq     |  +2.55  +3.32  +0.77 |  7  7 | 13 13
  6141 Drew Robinson  21 Slugger          mww  chin         |  +0.00  +0.00  +0.00 |  7  7 | 11 11
  6142 Blake White    20 Boxer-puncher    wlw  power        |  +8.23 +10.44  +2.21 |  8  8 | 16 16
  6143 Cameron Thompson 22 Out-boxer        wfw  speed        |  +0.88  +1.16  +0.27 |  8  8 | 13 13
  6144 Dakota Moore   18 Counter-puncher  www  technique    |  +9.18 +11.29  +2.12 |  8  8 | 11 12
  6145 Emerson Clark  21 Boxer-puncher    wmw  defense      |  +0.53  +0.70  +0.17 |  7  7 | 16 16
  6146 Finley Lewis   23 Counter-puncher  mlw  conditioning |  +7.57  +9.55  +1.98 |  7  7 | 12 13
  6147 Harper Hall    26 Slugger          mww  fight_iq     |  +3.55  +4.60  +1.05 |  9  9 | 11 11
  6148 Hayden Young   23 Counter-puncher  wlw  chin         |  +0.00  +0.00  +0.00 |  7  7 | 12 12
  6149 Jesse King     22 Counter-puncher  wfw  power        |  +5.75  +7.59  +1.84 |  7  7 | 13 14
  6150 Kai Baker      17 Boxer-puncher    www  speed        |  +2.73  +3.56  +0.82 |  7  7 | 11 11
  6151 Lane Lee       21 Pressure fighter wmw  technique    |  +3.99  +4.98  +0.99 |  7  7 | 16 17
  6152 Logan Green    19 Boxer-puncher    mlw  defense      |  +1.13  +1.49  +0.36 |  7  7 | 10 10
  6153 Parker Adams   26 Out-boxer        mww  conditioning |  +7.98  +9.93  +1.95 |  7  7 | 14 14
  6154 Reese Nelson   21 Volume puncher   wlw  fight_iq     |  +1.96  +2.57  +0.60 |  6  6 | 15 15
  6155 Rowan Mitchell 18 Volume puncher   wfw  chin         |  +0.00  +0.00  +0.00 |  7  7 | 12 12
  6156 Sage Harris    21 Counter-puncher  www  power        |  +3.12  +3.94  +0.83 |  9  9 | 14 14
  6157 Spencer Turner 23 Out-boxer        wmw  speed        |  +1.83  +2.39  +0.56 |  7  7 | 14 15
  6158 Tatum Fox      20 Out-boxer        mlw  technique    |  +8.46 +10.66  +2.19 |  7  7 | 14 17
  6159 Winter Smith   22 Boxer-puncher    mww  defense      |  +1.09  +1.44  +0.35 |  8  8 |  8  8
FITPROBE1 TOP - AVERAGE: FOCUS gain +0.953 (bar +3..+5: OUT) | Sharp 0.00 weeks sooner (bar 2..4: OUT)
  Sharp weeks: not reached within 26 weeks counted as 27. Paired on the 59 boxers Sharp in both arms: 0.00 weeks sooner.
  FOCUS trained on 52/60 boxers (AVERAGE gain > 0); on those the diff is +1.100. The other 8 gain 0: the coach's BASE week is fixed and its FOCUS session enters only in camp phases, so the multiplier has nothing to scale on them.
TRAINBALANCE TOP - AVERAGE: +0.67 wins in 100 (bar +4..+8: OUT; under a good plan's +14, 59 against 45: yes)
FITPROBE1 fail (gain fail, Sharp fail) | TRAINBALANCE fail (band fail, under the plan pass)
```

## Verdict

- FOCUS gain difference: **+0.953** (bar +3..+5). On the 52 boxers whose FOCUS trained in the base week: **+1.100**.
- Sharp weeks sooner: **+0.00** (bar 2..4); paired on the 59 boxers Sharp in both arms: +0.00.
- Wins in 100 difference: **+0.67** (bar +4..+8, under the plan's +14).
- CONTROL (AVERAGE vs untouched): **match**. Determinism (one arm twice): **match**.
- **FITPROBE1 fail** | **TRAINBALANCE fail**

A gate FAIL is a finding for the designer, not a broken probe: the numbers above are what the mechanism did.

Elapsed: 282 s. Reproduce: `python ops/Tools/godot_slot.py run --who fitprobe1 -- <godot> --headless --audio-driver Dummy --path . --script res://tools/fit_probe.gd`

## Findings (what the numbers say)

- The gain bar (+3..+5) is out of reach of the specified mechanism: x1.32 on the game's own 26-week FOCUS gain adds +0.95 overall (+1.10 on the 52 boxers whose FOCUS the BASE week trains; the other 8 gain 0 - the coach's BASE week is fixed and its FOCUS session enters only in camp phases, so the multiplier has nothing to scale on them).
- The Sharp bar (2-4 weeks sooner) does not move (+0.00): this probe scales the FOCUS stat and tiredness only, NOT the evening drill units (design 2.1's other lever). Weeks to Sharp ride on drilling and the mastery cap (technique/fight_iq), which the fit barely touches; the drilled move (Uppercut) never reaches Sharp in 26 weeks in either arm.
- The bout bar (+4..+8) is far off (+0.67) yet under the plan's +14: a TOP fit as specified is not too much, it is too little to meet the bar - one stat's gain is a small paper edge and weapons/mastery are unchanged. The equal-paper baseline win share is printed above (the live round reads moves and plan, not paper alone), so the diff is not on the bar's 59-vs-45 scale; it is far under +4 either way. The tiredness lever is real (per-arm means above) but stays under the overreach (80) and injury lines, so it barely feeds back; the stack cap never binds without a camp (camp mult 1.0, fit x camp 1.32 < 1.6).
