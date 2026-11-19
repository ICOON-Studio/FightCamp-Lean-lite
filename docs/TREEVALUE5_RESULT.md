# TREEVALUE5 Result

Probe run: 2026-11-19T21:33:37. Phase 2 of STEPS_SCOPE_S528 on the phase-1 fight: StepWire.open_edge passes a step's opening on to the punch after it; a wrong-fit step lets WRONG_COST more of her punches land. 400 bouts a cell per arm per seed set, 3 sets, amateur 3x3, 60 fighters, Sharp 60, OK grade.

## The probe fix (STEPTUNE2 s3)

_plan_for keeps one planned PUNCH on the swept step's destination card (StrikeMap.move(step).to): the punch already there, else the base PLAN punch the surgery removed (ANY TIME), else the map's own punch there, answering the game most played on the card. It is in BOTH arms, so the delta isolates the step. Per step:

- step_in -> long: 2-3
- step_out -> outside: 1-1-2
- step_back -> long: 2-3
- pivot_out -> mid: 1-6-3
- cut_off -> opp_ropes: 3b-3@opp_ropes
- herd -> corner: 3b-3@corner
- feint -> outside: 1-1-2
- tie_up -> clinch: NO punch move leaves this card (clinch); the opening rides push_off on to mid
- roll_out -> mid: 1-6-3
- push_off -> mid: 1-6-3

## Controls

- OK grade on every swept step: yes. Determinism: 203 / 203 wins (fires 861 / 861). Without-arm planned fires: 0 (must be 0).
- Calibration (full BASE plan, 120 bouts): { "Maria Ortega": "60/120", "Jade Cooper": "59/120", "Holly Price": "64/120", "Priya Nair": "62/120", "Erin Doyle": "60/120", "Dana Whitfield": "59/120" }. Ratings: { "Maria Ortega": 52.88671875, "Jade Cooper": 55.9453125, "Holly Price": 54.2421875, "Priya Nair": 53.29296875, "Erin Doyle": 53.01953125, "Dana Whitfield": 52.640625 }.

## Cells: win difference in 100 [with / without wins] fires/bout (TARGET beside it)

| Step | Pressure fighter | Slugger | Out-boxer | Counter-puncher | Volume puncher | Boxer-puncher |
|------|------|------|------|------|------|------|
| step_in | +0.1 (t+0.5) [557/556] f0.47 | -0.1 (t+0.5) [539/540] f0.40 | +0.7 (t+3.0) [560/552] f1.01 | +0.5 (t-2.5) [591/585] f1.79 | +0.3 (t+0.5) [571/568] f0.40 | +0.7 (t+0.5) [561/553] f0.73 |
| step_out | +0.8 (t+1.0) [562/552] f1.37 | +0.4 (t+2.5) [556/551] f1.38 | +1.8 (t+1.0) [590/569] f1.60 | +0.8 (t-1.0) [614/604] f1.35 | +0.3 (t+1.0) [583/579] f1.67 | +1.7 (t+1.0) [578/558] f1.52 |
| step_back | +3.5 (t+3.5) [571/529] f2.15 | +3.2 (t+1.0) [564/526] f2.15 | -1.7 (t-1.5) [575/595] f1.49 | -0.8 (t+1.0) [605/615] f0.85 | +2.5 (t+1.0) [594/564] f2.51 | -0.9 (t+1.0) [571/582] f1.85 |
| pivot_out | +1.2 (t+2.5) [564/550] f2.83 | +1.3 (t+0.0) [559/544] f3.39 | +0.0 (t-0.5) [581/581] f0.95 | +0.1 (t+0.0) [612/611] f1.01 | +1.3 (t+0.0) [589/574] f2.22 | +0.3 (t+0.0) [572/569] f1.88 |
| cut_off | -1.9 (t-1.5) [582/605] f0.89 | -0.8 (t+0.0) [578/588] f0.96 | -0.3 (t+3.5) [624/627] f1.11 | +0.1 (t+0.0) [640/639] f0.99 | -2.8 (t+0.0) [587/620] f1.17 | -1.0 (t+0.0) [589/601] f1.09 |
| herd | -0.3 (t-1.5) [605/608] f0.18 | -0.2 (t+1.0) [589/591] f0.13 | -0.2 (t+1.0) [635/637] f0.20 | -0.1 (t+1.0) [644/645] f0.21 | -0.2 (t+2.0) [625/627] f0.26 | -0.3 (t+1.0) [604/608] f0.22 |
| feint | +1.1 (t-1.0) [624/611] f1.14 | +0.5 (t+0.5) [640/634] f0.93 | +1.5 (t+0.5) [623/605] f1.95 | +3.3 (t+4.0) [631/592] f5.05 | +0.6 (t+0.5) [653/646] f0.79 | +0.8 (t+0.5) [619/610] f1.58 |
| tie_up | +3.3 (t+0.0) [608/568] f2.38 | +1.8 (t+3.0) [580/558] f1.23 | +2.8 (t-1.0) [564/531] f1.76 | +1.3 (t+0.0) [601/586] f1.49 | +2.4 (t+0.0) [620/591] f1.61 | +2.6 (t+0.0) [577/546] f1.61 |
| roll_out | +0.8 (t+1.0) [559/549] f2.44 | -0.3 (t+3.0) [537/540] f1.24 | -0.6 (t+1.0) [544/551] f1.83 | +0.0 (t+1.0) [572/572] f1.56 | -0.4 (t-1.0) [573/578] f1.64 | -0.9 (t+1.0) [552/563] f1.66 |
| push_off | +0.0 (t+1.5) [543/543] f0.83 | +0.0 (t+0.0) [552/552] f0.41 | -0.1 (t-0.5) [532/533] f0.52 | +0.1 (t+0.0) [565/564] f0.46 | +0.0 (t+0.0) [570/570] f0.47 | +0.0 (t+0.0) [537/537] f0.49 |

## The gate's three legs and the per-fire invariant I(best,wrong) vs STEPTUNE2

I(best,wrong) = cell_best - (F_best/F_wrong) x cell_wrong (F = fires/bout): no TABLE number moves it; the gate needs I > 1.5 for the best (1.5..5) and wrong (<0) legs to coexist. 'Window' = the leg count that can pass.

| Step | best | wrong | I now | I ST2 | I>1.5 | legs now | legs ST2 | window |
|------|------|-------|-------|-------|-------|----------|----------|--------|
| step_in | Out-boxer | Counter-puncher | +0.383 | +0.415 | no | 0 | 1 | still shut |
| step_out | Slugger | Counter-puncher | -0.437 | -0.598 | no | 0 | 0 | still shut |
| step_back | Pressure fighter | Out-boxer | +5.909 | +5.960 | yes | 2 | 2 | still shut |
| pivot_out | Pressure fighter | Out-boxer | +1.167 | +1.330 | no | 0 | 0 | still shut |
| cut_off | Out-boxer | Pressure fighter | +2.126 | +2.073 | yes | 1 | 1 | still shut |
| herd | Volume puncher | Pressure fighter | +0.202 | +0.361 | no | 1 | 1 | still shut |
| feint | Counter-puncher | Pressure fighter | -1.545 | -1.422 | no | 1 | 1 | still shut |
| tie_up | Slugger | Out-boxer | -0.098 | -0.038 | no | 1 | 1 | still shut |
| roll_out | Slugger | Volume puncher | +0.064 | +0.070 | no | 1 | 1 | still shut |
| push_off | Pressure fighter | Out-boxer | +0.132 | +0.128 | no | 2 | 2 | still shut |

**TREEVALUE2 done pass=0/10** (gate legs: best in 1.5..5, wrong < 0, others 0..1).

Windows that opened vs STEPTUNE2: none.

## One line per FAIL (the StepEffect row that would move it; TABLE is NOT changed here)

- FAIL step_in: StepEffect.TABLE.step_in (open 0.12, drain 0.40, tank 0.30, wrong_extra_damage 0.20, distance inside, open_on inside) is the row that would move it - best cell Out-boxer +0.7 outside 1.5-5; wrong cell Counter-puncher +0.5 not negative; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_out: StepEffect.TABLE.step_out (deny 0.25, tank 0.50, clears_ropes, break_to boxing, deny_on all) is the row that would move it - best cell Slugger +0.4 outside 1.5-5; wrong cell Counter-puncher +0.8 not negative; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_back: StepEffect.TABLE.step_back (deny 0.35, open 0.10, tank 0.30, ropes +1, distance long, deny_on power, open_on counter) is the row that would move it - other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL pivot_out: StepEffect.TABLE.pivot_out (open 0.08, tank 0.50, clears_ropes, distance mid, open_on any) is the row that would move it - best cell Pressure fighter +1.2 outside 1.5-5; wrong cell Out-boxer +0.0 not negative; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL cut_off: StepEffect.TABLE.cut_off (drain 0.60, opp_steps_less 0.30, tank 0.50, opp_ropes +1) is the row that would move it - best cell Out-boxer -0.3 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL herd: StepEffect.TABLE.herd (open 0.12, tank 0.60, opp_ropes +1, open_on power) is the row that would move it - best cell Volume puncher -0.2 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL feint: StepEffect.TABLE.feint (open 0.12, opp_counter_edge -0.10, tank 0.15, open_on any) is the row that would move it - wrong cell Pressure fighter +1.1 not negative; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL tie_up: StepEffect.TABLE.tie_up (self_tank 0.80, tank -0.80, ends_early, break_to boxing) is the row that would move it - wrong cell Out-boxer +2.8 not negative; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL roll_out: StepEffect.TABLE.roll_out (deny 0.40, open 0.10, tank 0.30, deny_on head_hooks, open_on counter) is the row that would move it - best cell Slugger -0.3 outside 1.5-5; other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL push_off: StepEffect.TABLE.push_off (drain 0.30, tank 0.40, distance mid) is the row that would move it - best cell Pressure fighter +0.0 outside 1.5-5. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.

Elapsed: 12519 s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue5 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`
