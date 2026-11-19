# TREEVALUE2 Result

Probe run: 2026-11-19T07:12:47. 400 bouts a cell per arm per seed set, 3 seed sets (S427), amateur 3x3, 60 fighters, 6 style opponents.

## Question

Is each footwork / defence step worth 1.5-5 in 100 against its own style? (map section 9 gate 2)
Each step at Sharp mastery (StepMastery 60) and OK grade: the plan WITH its line minus the SAME plan without it,
win difference in 100. Gate: its best style's cell in 1.5-5 (the section 5 targets within +-1); its wrong style negative; the others 0 to +1.

## Method

- Fighters: TREEVALUE1's factory, seeds 7100-7159 (the same 60 in every seed set; the sets shift the fight-night dice).
- Seed sets (day offsets): [0, 10000, 20000]. A cell's value is the mean of its 3 seed-set deltas; each arm fights the same seeds.
- Plan: TREEVALUE1's PLAN with its S464 surgery per step (_plan_for): the swept step planned ANY TIME on its card,
  the other arrows sharing its `when` left out; the without-arm is that same plan minus the step's line. Nothing else differs.
- Mastery: the swept step at 60 (Sharp, fires 3 in 4), every other line at 45 (Usable, 1 in 2). fire_level key ABSENT = GAME_SHARES.
- Grade: OK forced on the swept step by setting both LineGrade.DONE_WITH attributes to 56 (mean 56: OK_AT 50 <= 56 < GOOD_AT 62).
  LineGrade's rule is the one the live round reads; StepEffect.grade_for (the map 4.2 ability pairs) is not wired into the bout.
- Opponents: shipped roster, one per style (OPPS + MISMATCH + RIVALS' Holly Price and Jade Cooper). Ratings CALIBRATED so the full
  BASE plan wins about half: { "Maria Ortega": 52.88671875, "Jade Cooper": 55.9453125, "Holly Price": 54.2421875, "Priya Nair": 53.29296875, "Erin Doyle": 53.01953125, "Dana Whitfield": 52.640625 }.
- fires/bout = exchanges where the step's arrow was PLANNED (the FireLevel roll came off), with-arm, over all 1200 bouts of the cell.
  A 0.0 delta with fires 0 means the line never came off; with fires > 0 it fired and did nothing.
- What the bout reads of StepEffect today: only the ropes count (StepWire). The deny/open/drain sizes are NOT in the exchange;
  a step's fight edge comes from PlanFight.ANSWERS fit through LineGrade, plus the ropes place it opens.

## Controls

- Determinism: the same cell twice -> 203 and 203 wins (fires 866 / 866). OK
- OK grade on every swept step: yes.
- Without-arm planned fires of the swept step (must be 0, the line is out): 0.
- Calibration control win shares (full BASE plan, 120 bouts): { "Maria Ortega": "60/120", "Jade Cooper": "60/120", "Holly Price": "65/120", "Priya Nair": "62/120", "Erin Doyle": "62/120", "Dana Whitfield": "61/120" }.

## Result: measured win difference in 100 (TARGET beside it, fires/bout beside both)

| Step | Pressure fighter | Slugger | Out-boxer | Counter-puncher | Volume puncher | Boxer-puncher |
|------|------|------|------|------|------|------|
| step_in | +0.0 (t+0.5) f0.47 | -0.1 (t+0.5) f0.39 | +0.9 (t+3.0) f1.09 | +0.4 (t-2.5) f1.83 | +0.2 (t+0.5) f0.42 | +0.4 (t+0.5) f0.75 |
| step_out | +0.8 (t+1.0) f1.36 | +0.5 (t+2.5) f1.36 | +1.8 (t+1.0) f1.58 | +0.9 (t-1.0) f1.34 | +0.5 (t+1.0) f1.64 | +1.9 (t+1.0) f1.52 |
| step_back | +3.8 (t+3.5) f2.17 | +2.8 (t+1.0) f2.15 | -2.7 (t-1.5) f1.47 | -1.0 (t+1.0) f0.84 | +2.2 (t+1.0) f2.53 | -0.8 (t+1.0) f1.85 |
| pivot_out | +1.0 (t+2.5) f2.86 | +1.5 (t+0.0) f3.43 | +0.0 (t-0.5) f0.95 | +0.3 (t+0.0) f1.02 | +1.3 (t+0.0) f2.25 | +0.4 (t+0.0) f1.90 |
| cut_off | -1.6 (t-1.5) f0.92 | -0.4 (t+0.0) f1.00 | -0.3 (t+3.5) f1.14 | +0.3 (t+0.0) f1.02 | -2.7 (t+0.0) f1.22 | -0.8 (t+0.0) f1.12 |
| herd | -0.3 (t-1.5) f0.18 | -0.2 (t+1.0) f0.14 | -0.2 (t+1.0) f0.20 | -0.3 (t+1.0) f0.22 | -0.3 (t+2.0) f0.28 | -0.3 (t+1.0) f0.23 |
| feint | +1.1 (t-1.0) f1.16 | +0.5 (t+0.5) f0.92 | +1.5 (t+0.5) f1.94 | +3.5 (t+4.0) f5.09 | +0.5 (t+0.5) f0.78 | +0.8 (t+0.5) f1.57 |
| tie_up | +2.8 (t+0.0) f2.33 | +1.4 (t+3.0) f1.21 | +2.3 (t-1.0) f1.70 | +1.1 (t+0.0) f1.44 | +2.5 (t+0.0) f1.51 | +2.2 (t+0.0) f1.55 |
| roll_out | +0.0 (t+1.0) f0.00 | +0.0 (t+3.0) f0.00 | +0.0 (t+1.0) f0.00 | +0.0 (t+1.0) f0.00 | +0.0 (t-1.0) f0.00 | +0.0 (t+1.0) f0.00 |
| push_off | +0.0 (t+1.5) f0.80 | +0.0 (t+0.0) f0.39 | -0.1 (t-0.5) f0.50 | +0.0 (t+0.0) f0.45 | +0.0 (t+0.0) f0.44 | -0.1 (t+0.0) f0.48 |

## Per step: the gate's three legs

- step_in: best Out-boxer +0.9 in 1.5-5: NO; wrong Counter-puncher +0.4 negative: NO; others 0 to +1: NO -> **FAIL**
- step_out: best Slugger +0.5 in 1.5-5: NO; wrong Counter-puncher +0.9 negative: NO; others 0 to +1: NO -> **FAIL**
- step_back: best Pressure fighter +3.8 in 1.5-5: yes; wrong Out-boxer -2.7 negative: yes; others 0 to +1: NO -> **FAIL**
- pivot_out: best Pressure fighter +1.0 in 1.5-5: NO; wrong Out-boxer +0.0 negative: NO; others 0 to +1: NO -> **FAIL**
- cut_off: best Out-boxer -0.3 in 1.5-5: NO; wrong Pressure fighter -1.6 negative: yes; others 0 to +1: NO -> **FAIL**
- herd: best Volume puncher -0.3 in 1.5-5: NO; wrong Pressure fighter -0.3 negative: yes; others 0 to +1: NO -> **FAIL**
- feint: best Counter-puncher +3.5 in 1.5-5: yes; wrong Pressure fighter +1.1 negative: NO; others 0 to +1: NO -> **FAIL**
- tie_up: best Slugger +1.4 in 1.5-5: NO; wrong Out-boxer +2.3 negative: NO; others 0 to +1: NO -> **FAIL**
- roll_out: best Slugger +0.0 in 1.5-5: NO; wrong Volume puncher +0.0 negative: NO; others 0 to +1: yes -> **FAIL**
- push_off: best Pressure fighter +0.0 in 1.5-5: NO; wrong Out-boxer -0.1 negative: yes; others 0 to +1: NO -> **FAIL**

**TREEVALUE2 pass=0/10**

## One line per FAIL: the StepEffect row that would move it (never changed here)

- FAIL step_in: StepEffect.TABLE.step_in (open 0.12, drain 0.40, tank 0.30, wrong_extra_damage 0.20, distance inside, open_on inside) is the row that would move it - best cell Out-boxer +0.9 outside 1.5-5; wrong cell Counter-puncher +0.4 not negative; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_out: StepEffect.TABLE.step_out (deny 0.25, tank 0.50, clears_ropes, break_to boxing, deny_on all) is the row that would move it - best cell Slugger +0.5 outside 1.5-5; wrong cell Counter-puncher +0.9 not negative; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_back: StepEffect.TABLE.step_back (deny 0.35, open 0.10, tank 0.30, ropes +1, distance long, deny_on power, open_on counter) is the row that would move it - other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL pivot_out: StepEffect.TABLE.pivot_out (open 0.08, tank 0.50, clears_ropes, distance mid, open_on any) is the row that would move it - best cell Pressure fighter +1.0 outside 1.5-5; wrong cell Out-boxer +0.0 not negative; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL cut_off: StepEffect.TABLE.cut_off (drain 0.60, opp_steps_less 0.30, tank 0.50, opp_ropes +1) is the row that would move it - best cell Out-boxer -0.3 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL herd: StepEffect.TABLE.herd (open 0.12, tank 0.60, opp_ropes +1, open_on power) is the row that would move it - best cell Volume puncher -0.3 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL feint: StepEffect.TABLE.feint (open 0.12, opp_counter_edge -0.10, tank 0.15, open_on any) is the row that would move it - wrong cell Pressure fighter +1.1 not negative; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL tie_up: StepEffect.TABLE.tie_up (self_tank 0.80, tank -0.80, ends_early, break_to boxing) is the row that would move it - best cell Slugger +1.4 outside 1.5-5; wrong cell Out-boxer +2.3 not negative; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL roll_out: StepEffect.TABLE.roll_out (deny 0.40, open 0.10, tank 0.30, deny_on head_hooks, open_on counter) is the row that would move it - best cell Slugger +0.0 outside 1.5-5; wrong cell Volume puncher +0.0 not negative. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL push_off: StepEffect.TABLE.push_off (drain 0.30, tank 0.40, distance mid) is the row that would move it - best cell Pressure fighter +0.0 outside 1.5-5; other styles outside 0 to +1 (first: Boxer-puncher). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.

## Seed spread (the best style's cell, delta per seed set)

| Step | Best style | set 0 | set 10000 | set 20000 | mean |
|------|-----------|------|------|------|------|
| step_in | Out-boxer | +0.5 | +1.5 | +0.8 | +0.9 |
| step_out | Slugger | +1.0 | -0.3 | +0.8 | +0.5 |
| step_back | Pressure fighter | +4.3 | +3.0 | +4.0 | +3.8 |
| pivot_out | Pressure fighter | +1.0 | +0.5 | +1.5 | +1.0 |
| cut_off | Out-boxer | -0.3 | -1.0 | +0.5 | -0.3 |
| herd | Volume puncher | -0.5 | +0.0 | -0.5 | -0.3 |
| feint | Counter-puncher | +2.3 | +4.0 | +4.3 | +3.5 |
| tie_up | Slugger | +1.5 | +2.0 | +0.8 | +1.4 |
| roll_out | Slugger | +0.0 | +0.0 | +0.0 | +0.0 |
| push_off | Pressure fighter | +0.0 | +0.0 | +0.0 | +0.0 |

## Without-arm win share (saturation check: a cell near 0 or 100 cannot show a step's worth)

- step_in: Pressure 0.45 Slugger 0.45 Out-boxe 0.45 Counter- 0.49 Volume p 0.46 Boxer-pu 0.45
- step_out: Pressure 0.46 Slugger 0.46 Out-boxe 0.47 Counter- 0.50 Volume p 0.49 Boxer-pu 0.47
- step_back: Pressure 0.44 Slugger 0.44 Out-boxe 0.50 Counter- 0.51 Volume p 0.48 Boxer-pu 0.48
- pivot_out: Pressure 0.46 Slugger 0.45 Out-boxe 0.48 Counter- 0.51 Volume p 0.48 Boxer-pu 0.47
- cut_off: Pressure 0.50 Slugger 0.49 Out-boxe 0.52 Counter- 0.54 Volume p 0.52 Boxer-pu 0.50
- herd: Pressure 0.50 Slugger 0.49 Out-boxe 0.53 Counter- 0.54 Volume p 0.52 Boxer-pu 0.51
- feint: Pressure 0.51 Slugger 0.53 Out-boxe 0.51 Counter- 0.50 Volume p 0.54 Boxer-pu 0.52
- tie_up: Pressure 0.48 Slugger 0.47 Out-boxe 0.45 Counter- 0.49 Volume p 0.50 Boxer-pu 0.46
- roll_out: Pressure 0.46 Slugger 0.45 Out-boxe 0.46 Counter- 0.48 Volume p 0.48 Boxer-pu 0.47
- push_off: Pressure 0.45 Slugger 0.46 Out-boxe 0.45 Counter- 0.47 Volume p 0.48 Boxer-pu 0.45

Elapsed: 9608 s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`
