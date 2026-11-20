# TREEVALUE6 Result

Probe run: 2026-11-20T14:43:04. Phase 2 of STEPS_SCOPE_S528 on the phase-1 fight: StepWire.open_edge passes a step's opening on to the punch after it; a wrong-fit step lets WRONG_COST more of her punches land. 400 bouts a cell per arm per seed set, 3 sets, amateur 3x3, 60 fighters, Sharp 60, OK grade.

## S531 read (Claude) - against TREEVALUE5

Mean win change per style, TREEVALUE5 -> TREEVALUE6 (after phase 5a: a step's deny reaches the duel before it is settled):

| Step | TREEVALUE5 | TREEVALUE6 | change |
|------|-----------|-----------|--------|
| step_in | +0.37 | +0.45 | +0.08 |
| step_out (deny) | +0.97 | +1.77 | +0.80 |
| step_back (deny) | +0.97 | +2.30 | +1.33 |
| pivot_out | +0.70 | +0.75 | +0.05 |
| cut_off | -1.12 | -1.37 | -0.25 |
| herd | -0.22 | -0.20 | +0.02 |
| feint | +1.30 | +1.13 | -0.17 |
| tie_up | +2.37 | +2.38 | +0.02 |
| roll_out (deny) | -0.23 | +0.40 | +0.63 |
| push_off | +0.00 | -0.02 | -0.02 |

Did the DENY steps move more? YES - the three deny rows moved +0.63..+1.33; every other step under 0.3. But the deny edge
is style-blind: step_back gives +5.3 / +5.6 / +3.2 to three styles, so the gate's "others 0..1" and "wrong < 0" legs fail.
cut_off stays negative for all six styles. Gate line, verbatim: **TREEVALUE2 done pass=0/10**.
Next: STEPS_SCOPE_S528 phase 5d (deny scaled by her style's punch mix), then 5b, then sizing. (The FAIL lines below say
"only its ropes count is wired" - stale since 5a.)

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

- OK grade on every swept step: yes. Determinism: 207 / 207 wins (fires 850 / 850). Without-arm planned fires: 0 (must be 0).
- Calibration (full BASE plan, 120 bouts): { "Maria Ortega": "60/120", "Jade Cooper": "58/120", "Holly Price": "59/120", "Priya Nair": "62/120", "Erin Doyle": "62/120", "Dana Whitfield": "62/120" }. Ratings: { "Maria Ortega": 52.88671875, "Jade Cooper": 56.3671875, "Holly Price": 54.6953125, "Priya Nair": 53.29296875, "Erin Doyle": 53.01953125, "Dana Whitfield": 52.640625 }.

## Cells: win difference in 100 [with / without wins] fires/bout (TARGET beside it)

| Step | Pressure fighter | Slugger | Out-boxer | Counter-puncher | Volume puncher | Boxer-puncher |
|------|------|------|------|------|------|------|
| step_in | +0.1 (t-2.5) [576/575] f0.48 | +0.2 (t+0.5) [535/533] f0.41 | +0.8 (t+3.0) [547/538] f1.03 | +0.7 (t+0.5) [602/594] f1.80 | +0.3 (t+0.5) [581/578] f0.42 | +0.6 (t+0.5) [571/564] f0.75 |
| step_out | +1.7 (t+1.0) [587/567] f1.41 | +1.1 (t+2.5) [549/536] f1.40 | +2.1 (t-1.0) [571/546] f1.62 | +1.1 (t+1.0) [624/611] f1.36 | +1.8 (t+1.0) [603/582] f1.69 | +2.8 (t+1.0) [599/566] f1.54 |
| step_back | +5.3 (t+3.5) [595/531] f2.14 | +5.6 (t+1.0) [562/495] f2.11 | -0.5 (t-1.5) [560/566] f1.46 | -0.1 (t+1.0) [614/615] f0.85 | +3.2 (t+1.0) [603/565] f2.51 | +0.3 (t+1.0) [587/584] f1.84 |
| pivot_out | +1.9 (t+2.5) [584/561] f2.78 | +1.0 (t+0.0) [546/534] f3.39 | +0.1 (t-0.5) [561/560] f0.96 | -0.1 (t+0.0) [620/621] f1.00 | +1.3 (t+0.0) [598/582] f2.21 | +0.3 (t+0.0) [584/580] f1.88 |
| cut_off | -1.9 (t-1.5) [600/623] f0.91 | -1.5 (t+0.0) [569/587] f0.97 | -0.7 (t+3.5) [601/609] f1.13 | -0.1 (t+0.0) [648/649] f0.99 | -2.8 (t+0.0) [594/627] f1.18 | -1.2 (t+0.0) [594/608] f1.10 |
| herd | -0.3 (t-1.5) [624/627] f0.19 | -0.2 (t+1.0) [588/590] f0.13 | -0.3 (t+1.0) [612/616] f0.19 | +0.0 (t+1.0) [655/655] f0.22 | -0.2 (t+2.0) [630/632] f0.26 | -0.2 (t+1.0) [616/618] f0.22 |
| feint | +0.9 (t+0.5) [637/626] f1.15 | +0.3 (t+0.5) [625/622] f0.94 | +1.1 (t+0.5) [600/587] f1.97 | +3.2 (t+4.0) [636/598] f5.07 | +0.5 (t+0.5) [663/657] f0.79 | +0.8 (t+0.5) [629/620] f1.58 |
| tie_up | +3.6 (t+0.0) [624/581] f2.37 | +1.8 (t+3.0) [569/547] f1.22 | +2.8 (t+0.0) [540/506] f1.73 | +1.3 (t+0.0) [607/591] f1.46 | +2.3 (t+0.0) [627/600] f1.58 | +2.5 (t+0.0) [584/554] f1.59 |
| roll_out | +1.7 (t+1.0) [585/565] f2.37 | +0.9 (t+3.0) [548/537] f1.19 | -0.7 (t+1.0) [525/533] f1.81 | +0.5 (t+1.0) [587/581] f1.52 | +0.0 (t+1.0) [589/589] f1.61 | +0.0 (t+1.0) [571/571] f1.61 |
| push_off | +0.0 (t+1.5) [559/559] f0.82 | -0.1 (t+0.0) [542/543] f0.39 | +0.0 (t+0.0) [510/510] f0.51 | +0.1 (t+0.0) [570/569] f0.46 | -0.1 (t+0.0) [574/575] f0.47 | +0.0 (t+0.0) [546/546] f0.48 |

## The gate's three legs and the per-fire invariant I(best,wrong) vs STEPTUNE2

I(best,wrong) = cell_best - (F_best/F_wrong) x cell_wrong (F = fires/bout): no TABLE number moves it; the gate needs I > 1.5 for the best (1.5..5) and wrong (<0) legs to coexist. 'Window' = the leg count that can pass.

| Step | best | wrong | I now | I ST2 | I>1.5 | legs now | legs ST2 | window |
|------|------|-------|-------|-------|-------|----------|----------|--------|
| step_in | Out-boxer | Pressure fighter | +0.570 | +0.415 | no | 1 | 1 | still shut |
| step_out | Slugger | Out-boxer | -0.725 | -0.598 | no | 0 | 0 | still shut |
| step_back | Pressure fighter | Out-boxer | +6.069 | +5.960 | yes | 1 | 2 | still shut |
| pivot_out | Pressure fighter | Out-boxer | +1.676 | +1.330 | yes | 1 | 0 | opened |
| cut_off | Out-boxer | Pressure fighter | +1.707 | +2.073 | yes | 1 | 1 | still shut |
| herd | Volume puncher | Pressure fighter | +0.188 | +0.361 | no | 1 | 1 | still shut |
| feint | Counter-puncher |  | n/a | -1.422 | no | 2 | 1 | opened |
| tie_up | Slugger |  | n/a | -0.038 | no | 2 | 1 | opened |
| roll_out | Slugger |  | n/a | +0.070 | no | 1 | 1 | still shut |
| push_off | Pressure fighter |  | n/a | +0.128 | no | 1 | 2 | still shut |

**TREEVALUE2 done pass=0/10** (gate legs: best in 1.5..5, wrong < 0, others 0..1).

Windows that opened vs STEPTUNE2: pivot_out (0->1 legs), feint (1->2 legs), tie_up (1->2 legs).

## One line per FAIL (the StepEffect row that would move it; TABLE is NOT changed here)

- FAIL step_in: StepEffect.TABLE.step_in (open 0.12, drain 0.40, tank 0.30, wrong_extra_damage 0.20, distance inside, open_on inside) is the row that would move it - best cell Out-boxer +0.8 outside 1.5-5; wrong cell Pressure fighter +0.1 not negative. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_out: StepEffect.TABLE.step_out (deny 0.25, tank 0.50, clears_ropes, break_to boxing, deny_on all) is the row that would move it - best cell Slugger +1.1 outside 1.5-5; wrong cell Out-boxer +2.1 not negative; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_back: StepEffect.TABLE.step_back (deny 0.35, open 0.10, tank 0.30, ropes +1, distance long, deny_on power, open_on counter) is the row that would move it - best cell Pressure fighter +5.3 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL pivot_out: StepEffect.TABLE.pivot_out (open 0.08, tank 0.50, clears_ropes, distance mid, open_on any) is the row that would move it - wrong cell Out-boxer +0.1 not negative; other styles outside 0 to +1 (first: Counter-puncher). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL cut_off: StepEffect.TABLE.cut_off (drain 0.60, opp_steps_less 0.30, tank 0.50, opp_ropes +1) is the row that would move it - best cell Out-boxer -0.7 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL herd: StepEffect.TABLE.herd (open 0.12, tank 0.60, opp_ropes +1, open_on power) is the row that would move it - best cell Volume puncher -0.2 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL feint: StepEffect.TABLE.feint (open 0.12, opp_counter_edge -0.10, tank 0.15, open_on any) is the row that would move it - other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL tie_up: StepEffect.TABLE.tie_up (self_tank 0.80, tank -0.80, ends_early, break_to boxing) is the row that would move it - other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL roll_out: StepEffect.TABLE.roll_out (deny 0.40, open 0.10, tank 0.30, deny_on head_hooks, open_on counter) is the row that would move it - best cell Slugger +0.9 outside 1.5-5; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL push_off: StepEffect.TABLE.push_off (drain 0.30, tank 0.40, distance mid) is the row that would move it - best cell Pressure fighter +0.0 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.

Elapsed: 14427 s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue5 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`
