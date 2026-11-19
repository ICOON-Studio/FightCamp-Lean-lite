# TREEVALUE3 (S525) - the same probe rerun AFTER the step levers were wired (StepWire.levers / open_edge, commit ba76104d9)

READ FIRST (Claude, S525): the probe's "Only its ropes count is wired today" lines are stale text - DENY / DRAIN / OPEN /
own tank DO reach the exchange since ba76104d9. Two findings:
1. roll_out and push_off show uses/bout 0.00 in every cell: the plan NEVER picks them (not a size problem). Check why
   PlanFight.choose skips them in the probe's plan (_plan_for surgery: roll_out "when: loadup", push_off "when: press";
   MoveTree needs Lead hook 30 / tie_up 30; are they in f.moves at StepMastery 60?) - and whether a real player's plan can
   pick them at all. That is the first thing to fix.
2. The rest barely moved from TREEVALUE2 (step_back v Pressure +3.8 -> +3.7, feint v Counter +3.5 -> +3.3): at today's
   ESTIMATE sizes the levers are small next to the plan edge. Size StepEffect deny / open / drain up for the steps whose
   best cell is under 1.5 (step_in, step_out, pivot_out, cut_off, herd); tie_up is +1.2..+3.2 everywhere (no style
   dependence: its own row has no deny/open, it lives on ClinchRest).

# TREEVALUE2 Result

Probe run: 2026-11-19T14:35:16. 400 bouts a cell per arm per seed set, 3 seed sets (S427), amateur 3x3, 60 fighters, 6 style opponents.

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

- Determinism: the same cell twice -> 204 and 204 wins (fires 861 / 861). OK
- OK grade on every swept step: yes.
- Without-arm planned fires of the swept step (must be 0, the line is out): 0.
- Calibration control win shares (full BASE plan, 120 bouts): { "Maria Ortega": "60/120", "Jade Cooper": "59/120", "Holly Price": "64/120", "Priya Nair": "63/120", "Erin Doyle": "60/120", "Dana Whitfield": "60/120" }.

## Result: measured win difference in 100 (TARGET beside it, fires/bout beside both)

| Step | Pressure fighter | Slugger | Out-boxer | Counter-puncher | Volume puncher | Boxer-puncher |
|------|------|------|------|------|------|------|
| step_in | +0.1 (t+0.5) f0.48 | +0.0 (t+0.5) f0.40 | +0.7 (t+3.0) f1.11 | +0.4 (t-2.5) f1.83 | +0.3 (t+0.5) f0.42 | +0.3 (t+0.5) f0.77 |
| step_out | +0.8 (t+1.0) f1.37 | +0.3 (t+2.5) f1.38 | +1.4 (t+1.0) f1.60 | +0.8 (t-1.0) f1.35 | +0.5 (t+1.0) f1.66 | +1.7 (t+1.0) f1.51 |
| step_back | +3.7 (t+3.5) f2.16 | +3.3 (t+1.0) f2.16 | -1.6 (t-1.5) f1.49 | -0.8 (t+1.0) f0.85 | +2.4 (t+1.0) f2.53 | -0.8 (t+1.0) f1.86 |
| pivot_out | +1.3 (t+2.5) f2.83 | +1.3 (t+0.0) f3.40 | +0.0 (t-0.5) f0.95 | +0.2 (t+0.0) f1.01 | +1.1 (t+0.0) f2.24 | +0.2 (t+0.0) f1.89 |
| cut_off | -1.8 (t-1.5) f0.89 | -0.8 (t+0.0) f0.96 | -0.3 (t+3.5) f1.13 | +0.4 (t+0.0) f0.99 | -2.7 (t+0.0) f1.19 | -0.9 (t+0.0) f1.10 |
| herd | -0.3 (t-1.5) f0.18 | -0.2 (t+1.0) f0.13 | -0.2 (t+1.0) f0.20 | -0.3 (t+1.0) f0.22 | +0.0 (t+2.0) f0.26 | -0.3 (t+1.0) f0.23 |
| feint | +1.1 (t-1.0) f1.15 | +0.5 (t+0.5) f0.93 | +1.5 (t+0.5) f1.95 | +3.3 (t+4.0) f5.06 | +0.5 (t+0.5) f0.80 | +0.8 (t+0.5) f1.58 |
| tie_up | +3.2 (t+0.0) f2.37 | +1.8 (t+3.0) f1.23 | +2.5 (t-1.0) f1.72 | +1.2 (t+0.0) f1.46 | +2.5 (t+0.0) f1.56 | +2.5 (t+0.0) f1.58 |
| roll_out | +0.0 (t+1.0) f0.00 | +0.0 (t+3.0) f0.00 | +0.0 (t+1.0) f0.00 | +0.0 (t+1.0) f0.00 | +0.0 (t-1.0) f0.00 | +0.0 (t+1.0) f0.00 |
| push_off | +0.0 (t+1.5) f0.83 | +0.0 (t+0.0) f0.41 | -0.1 (t-0.5) f0.52 | +0.1 (t+0.0) f0.46 | +0.0 (t+0.0) f0.45 | +0.0 (t+0.0) f0.48 |

## Per step: the gate's three legs

- step_in: best Out-boxer +0.7 in 1.5-5: NO; wrong Counter-puncher +0.4 negative: NO; others 0 to +1: yes -> **FAIL**
- step_out: best Slugger +0.3 in 1.5-5: NO; wrong Counter-puncher +0.8 negative: NO; others 0 to +1: NO -> **FAIL**
- step_back: best Pressure fighter +3.7 in 1.5-5: yes; wrong Out-boxer -1.6 negative: yes; others 0 to +1: NO -> **FAIL**
- pivot_out: best Pressure fighter +1.3 in 1.5-5: NO; wrong Out-boxer +0.0 negative: NO; others 0 to +1: NO -> **FAIL**
- cut_off: best Out-boxer -0.3 in 1.5-5: NO; wrong Pressure fighter -1.8 negative: yes; others 0 to +1: NO -> **FAIL**
- herd: best Volume puncher +0.0 in 1.5-5: NO; wrong Pressure fighter -0.3 negative: yes; others 0 to +1: NO -> **FAIL**
- feint: best Counter-puncher +3.3 in 1.5-5: yes; wrong Pressure fighter +1.1 negative: NO; others 0 to +1: NO -> **FAIL**
- tie_up: best Slugger +1.8 in 1.5-5: yes; wrong Out-boxer +2.5 negative: NO; others 0 to +1: NO -> **FAIL**
- roll_out: best Slugger +0.0 in 1.5-5: NO; wrong Volume puncher +0.0 negative: NO; others 0 to +1: yes -> **FAIL**
- push_off: best Pressure fighter +0.0 in 1.5-5: NO; wrong Out-boxer -0.1 negative: yes; others 0 to +1: yes -> **FAIL**

**TREEVALUE2 pass=0/10**

## One line per FAIL: the StepEffect row that would move it (never changed here)

- FAIL step_in: StepEffect.TABLE.step_in (open 0.12, drain 0.40, tank 0.30, wrong_extra_damage 0.20, distance inside, open_on inside) is the row that would move it - best cell Out-boxer +0.7 outside 1.5-5; wrong cell Counter-puncher +0.4 not negative. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_out: StepEffect.TABLE.step_out (deny 0.25, tank 0.50, clears_ropes, break_to boxing, deny_on all) is the row that would move it - best cell Slugger +0.3 outside 1.5-5; wrong cell Counter-puncher +0.8 not negative; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_back: StepEffect.TABLE.step_back (deny 0.35, open 0.10, tank 0.30, ropes +1, distance long, deny_on power, open_on counter) is the row that would move it - other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL pivot_out: StepEffect.TABLE.pivot_out (open 0.08, tank 0.50, clears_ropes, distance mid, open_on any) is the row that would move it - best cell Pressure fighter +1.3 outside 1.5-5; wrong cell Out-boxer +0.0 not negative; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL cut_off: StepEffect.TABLE.cut_off (drain 0.60, opp_steps_less 0.30, tank 0.50, opp_ropes +1) is the row that would move it - best cell Out-boxer -0.3 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL herd: StepEffect.TABLE.herd (open 0.12, tank 0.60, opp_ropes +1, open_on power) is the row that would move it - best cell Volume puncher +0.0 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL feint: StepEffect.TABLE.feint (open 0.12, opp_counter_edge -0.10, tank 0.15, open_on any) is the row that would move it - wrong cell Pressure fighter +1.1 not negative; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL tie_up: StepEffect.TABLE.tie_up (self_tank 0.80, tank -0.80, ends_early, break_to boxing) is the row that would move it - wrong cell Out-boxer +2.5 not negative; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL roll_out: StepEffect.TABLE.roll_out (deny 0.40, open 0.10, tank 0.30, deny_on head_hooks, open_on counter) is the row that would move it - best cell Slugger +0.0 outside 1.5-5; wrong cell Volume puncher +0.0 not negative. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL push_off: StepEffect.TABLE.push_off (drain 0.30, tank 0.40, distance mid) is the row that would move it - best cell Pressure fighter +0.0 outside 1.5-5. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.

## Seed spread (the best style's cell, delta per seed set)

| Step | Best style | set 0 | set 10000 | set 20000 | mean |
|------|-----------|------|------|------|------|
| step_in | Out-boxer | +0.3 | +0.8 | +1.0 | +0.7 |
| step_out | Slugger | +0.5 | -0.8 | +1.0 | +0.3 |
| step_back | Pressure fighter | +4.8 | +2.5 | +3.8 | +3.7 |
| pivot_out | Pressure fighter | +1.8 | +0.3 | +2.0 | +1.3 |
| cut_off | Out-boxer | -0.5 | -0.8 | +0.5 | -0.3 |
| herd | Volume puncher | -0.5 | +0.3 | +0.3 | +0.0 |
| feint | Counter-puncher | +3.0 | +2.5 | +4.5 | +3.3 |
| tie_up | Slugger | +1.8 | +2.5 | +1.0 | +1.8 |
| roll_out | Slugger | +0.0 | +0.0 | +0.0 | +0.0 |
| push_off | Pressure fighter | +0.0 | +0.0 | +0.0 | +0.0 |

## Without-arm win share (saturation check: a cell near 0 or 100 cannot show a step's worth)

- step_in: Pressure 0.46 Slugger 0.45 Out-boxe 0.45 Counter- 0.49 Volume p 0.45 Boxer-pu 0.45
- step_out: Pressure 0.46 Slugger 0.46 Out-boxe 0.48 Counter- 0.50 Volume p 0.48 Boxer-pu 0.46
- step_back: Pressure 0.44 Slugger 0.44 Out-boxe 0.50 Counter- 0.51 Volume p 0.47 Boxer-pu 0.48
- pivot_out: Pressure 0.46 Slugger 0.45 Out-boxe 0.48 Counter- 0.51 Volume p 0.48 Boxer-pu 0.47
- cut_off: Pressure 0.50 Slugger 0.49 Out-boxe 0.52 Counter- 0.53 Volume p 0.52 Boxer-pu 0.50
- herd: Pressure 0.51 Slugger 0.49 Out-boxe 0.53 Counter- 0.54 Volume p 0.52 Boxer-pu 0.51
- feint: Pressure 0.51 Slugger 0.53 Out-boxe 0.51 Counter- 0.49 Volume p 0.54 Boxer-pu 0.51
- tie_up: Pressure 0.47 Slugger 0.47 Out-boxe 0.45 Counter- 0.49 Volume p 0.49 Boxer-pu 0.46
- roll_out: Pressure 0.46 Slugger 0.45 Out-boxe 0.46 Counter- 0.48 Volume p 0.48 Boxer-pu 0.47
- push_off: Pressure 0.45 Slugger 0.46 Out-boxe 0.44 Counter- 0.47 Volume p 0.47 Boxer-pu 0.45

Elapsed: 12227 s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue2 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`
