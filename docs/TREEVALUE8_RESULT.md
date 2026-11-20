# TREEVALUE8 Result (S531) - the footwork re-read after phases 5d, 5e and 5b

Run 2026-11-20 15:58-18:19 on the PC (8,443 s). Same probe and seeds as TREEVALUE6; the page the probe writes is kept
below as it came out. What changed since TREEVALUE6: 5d the deny follows the step's fit to her game this exchange
(StepWire.DENY_FIT best 1.0 / ok 0.5 / none 0.15 / wrong 0), 5e the after-round energy reads RingDuel's (the drifted copy
missed the opponent's drain), 5b each exchange records its step fit and the probe prints the wrong share (w%).

## S531 read (Claude) - against TREEVALUE6

| Step | mean v6 | mean v8 | change | spread v6 | spread v8 |
|------|---------|---------|--------|-----------|-----------|
| step_in | +0.45 | +0.42 | -0.03 | 0.7 | 0.6 |
| step_out | +1.77 | +1.28 | -0.48 | 1.7 | 1.5 |
| step_back | +2.30 | +1.92 | -0.38 | 6.1 | 6.1 |
| pivot_out | +0.75 | +0.73 | -0.02 | 2.0 | 2.0 |
| cut_off | -1.37 | -1.28 | +0.08 | 2.7 | 2.8 |
| herd | -0.20 | -0.22 | -0.02 | 0.3 | 0.3 |
| feint | +1.13 | +1.22 | +0.08 | 2.9 | 2.8 |
| tie_up | +2.38 | +2.40 | +0.02 | 2.3 | 2.2 |
| roll_out | +0.40 | +0.25 | -0.15 | 2.4 | 1.9 |
| push_off | -0.02 | -0.02 | +0.00 | 0.2 | 0.2 |

- 5d did what it says, but small: the deny steps lost 0.15-0.48 a style on average, and the wrong-fit cells went the
  right way (step_back vs the Out-boxer -0.5 -> -1.0, Boxer-puncher +0.3 -> -0.4, Counter-puncher -0.1 -> -0.3).
- The spread did not move: step_back still gives +4.9 / +5.1 / +3.2 to Pressure fighter / Slugger / Volume puncher.
  That edge is not the deny lever (removing the deny from wrong fits barely touched it): it is the step's base value
  against forward styles - the card it leads to and the punch planned there. Sizing the lever rows cannot fix it.
- 5b now measures it: on average 15% of a step's fires were on the wrong fit; step_back against the Out-boxer 62%,
  cut_off 50-55% against Pressure / Slugger / Volume, herd 33-62% everywhere. Those are planner picks, not luck: the
  planner fires a step whatever the opponent's game is this exchange.
- cut_off stays negative for every style (-0.6 .. -2.8) and herd stays ~0: both fire rarely (f0.1-1.2) and half the
  time on a wrong fit.
- Gate, verbatim: **TREEVALUE2 done pass=0/10**. Determinism 205/205, without-arm fires 0.

Next (STEPS_SCOPE_S528, decided): not table sizing yet - the wrong-fit share is the lever the numbers point at. Phase 6:
the planned step fires only when its fit to her game this exchange is ok or best (wrong = the boxer holds the step and
fights the card), then re-read; cut_off/herd need a reason to exist against their best style before any size change.

---

## The probe page as written (it still titles itself TREEVALUE5)

Probe run: 2026-11-20T17:51:50. Phase 2 of STEPS_SCOPE_S528 on the phase-1 fight: StepWire.open_edge passes a step's opening on to the punch after it; a wrong-fit step lets WRONG_COST more of her punches land. 400 bouts a cell per arm per seed set, 3 sets, amateur 3x3, 60 fighters, Sharp 60, OK grade.

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

- OK grade on every swept step: yes. Determinism: 205 / 205 wins (fires 849 / 849). Without-arm planned fires: 0 (must be 0).
- Calibration (full BASE plan, 120 bouts): { "Maria Ortega": "60/120", "Jade Cooper": "58/120", "Holly Price": "59/120", "Priya Nair": "62/120", "Erin Doyle": "61/120", "Dana Whitfield": "61/120" }. Ratings: { "Maria Ortega": 52.88671875, "Jade Cooper": 56.3671875, "Holly Price": 54.6953125, "Priya Nair": 53.29296875, "Erin Doyle": 53.01953125, "Dana Whitfield": 52.640625 }.

## Cells: win difference in 100 [with / without wins] fires/bout (TARGET beside it)

| Step | Pressure fighter | Slugger | Out-boxer | Counter-puncher | Volume puncher | Boxer-puncher |
|------|------|------|------|------|------|------|
| step_in | +0.1 (t-2.5) [574/573] f0.48 w12% | +0.2 (t+0.5) [533/531] f0.41 w16% | +0.7 (t+3.0) [542/534] f1.02 w10% | +0.6 (t+0.5) [596/589] f1.80 w12% | +0.3 (t+0.5) [580/577] f0.41 w7% | +0.6 (t+0.5) [565/558] f0.74 w12% |
| step_out | +1.1 (t+1.0) [577/564] f1.41 w7% | +1.1 (t+2.5) [547/534] f1.39 w5% | +1.8 (t-1.0) [564/542] f1.61 w5% | +0.8 (t+1.0) [619/609] f1.37 w8% | +0.7 (t+1.0) [589/581] f1.69 w9% | +2.2 (t+1.0) [587/561] f1.54 w6% |
| step_back | +4.9 (t+3.5) [590/531] f2.14 w14% | +5.1 (t+1.0) [556/495] f2.11 w17% | -1.0 (t-1.5) [554/566] f1.46 w62% | -0.3 (t+1.0) [611/615] f0.85 w43% | +3.2 (t+1.0) [603/565] f2.51 w33% | -0.4 (t+1.0) [579/584] f1.85 w44% |
| pivot_out | +1.8 (t+2.5) [581/559] f2.78 w0% | +1.0 (t+0.0) [544/532] f3.40 w0% | +0.1 (t-0.5) [556/555] f0.96 w0% | -0.2 (t+0.0) [616/618] f1.00 w0% | +1.3 (t+0.0) [596/580] f2.21 w0% | +0.4 (t+0.0) [580/575] f1.88 w0% |
| cut_off | -1.7 (t-1.5) [599/619] f0.91 w54% | -1.4 (t+0.0) [567/584] f0.97 w50% | -0.6 (t+3.5) [600/607] f1.12 w10% | +0.0 (t+0.0) [646/646] f0.99 w12% | -2.8 (t+0.0) [593/626] f1.18 w55% | -1.2 (t+0.0) [595/609] f1.09 w28% |
| herd | -0.3 (t-1.5) [621/624] f0.18 w62% | -0.2 (t+1.0) [586/588] f0.13 w54% | -0.3 (t+1.0) [610/614] f0.19 w33% | +0.0 (t+1.0) [651/651] f0.22 w38% | -0.2 (t+2.0) [629/631] f0.26 w50% | -0.3 (t+1.0) [614/617] f0.22 w43% |
| feint | +0.9 (t+0.5) [634/623] f1.15 w8% | +0.5 (t+0.5) [622/616] f0.94 w6% | +1.3 (t+0.5) [596/581] f1.98 w8% | +3.3 (t+4.0) [634/595] f5.07 w8% | +0.5 (t+0.5) [659/653] f0.79 w10% | +0.8 (t+0.5) [624/615] f1.59 w9% |
| tie_up | +3.5 (t+0.0) [621/579] f2.37 w12% | +1.8 (t+3.0) [569/547] f1.22 w4% | +2.7 (t+0.0) [537/505] f1.74 w5% | +1.3 (t+0.0) [604/589] f1.48 w6% | +2.3 (t+0.0) [627/599] f1.59 w4% | +2.8 (t+0.0) [583/550] f1.60 w5% |
| roll_out | +1.3 (t+1.0) [579/564] f2.39 w0% | +0.9 (t+3.0) [547/536] f1.20 w0% | -0.6 (t+1.0) [523/530] f1.82 w0% | +0.4 (t+1.0) [583/578] f1.53 w0% | -0.1 (t+1.0) [587/588] f1.62 w0% | -0.4 (t+1.0) [566/571] f1.63 w0% |
| push_off | +0.0 (t+1.5) [558/558] f0.82 w0% | -0.1 (t+0.0) [541/542] f0.39 w0% | +0.0 (t+0.0) [508/508] f0.51 w0% | +0.1 (t+0.0) [567/566] f0.46 w0% | -0.1 (t+0.0) [575/576] f0.47 w0% | +0.0 (t+0.0) [543/543] f0.49 w0% |

## The gate's three legs and the per-fire invariant I(best,wrong) vs STEPTUNE2

I(best,wrong) = cell_best - (F_best/F_wrong) x cell_wrong (F = fires/bout): no TABLE number moves it; the gate needs I > 1.5 for the best (1.5..5) and wrong (<0) legs to coexist. 'Window' = the leg count that can pass.

| Step | best | wrong | I now | I ST2 | I>1.5 | legs now | legs ST2 | window |
|------|------|-------|-------|-------|-------|----------|----------|--------|
| step_in | Out-boxer | Pressure fighter | +0.488 | +0.415 | no | 1 | 1 | still shut |
| step_out | Slugger | Out-boxer | -0.493 | -0.598 | no | 0 | 0 | still shut |
| step_back | Pressure fighter | Out-boxer | +6.384 | +5.960 | yes | 2 | 2 | still shut |
| pivot_out | Pressure fighter | Out-boxer | +1.593 | +1.330 | yes | 1 | 0 | opened |
| cut_off | Out-boxer | Pressure fighter | +1.463 | +2.073 | no | 1 | 1 | still shut |
| herd | Volume puncher | Pressure fighter | +0.191 | +0.361 | no | 1 | 1 | still shut |
| feint | Counter-puncher |  | n/a | -1.422 | no | 2 | 1 | opened |
| tie_up | Slugger |  | n/a | -0.038 | no | 2 | 1 | opened |
| roll_out | Slugger |  | n/a | +0.070 | no | 1 | 1 | still shut |
| push_off | Pressure fighter |  | n/a | +0.128 | no | 1 | 2 | still shut |

**TREEVALUE2 done pass=0/10** (gate legs: best in 1.5..5, wrong < 0, others 0..1).

Windows that opened vs STEPTUNE2: pivot_out (0->1 legs), feint (1->2 legs), tie_up (1->2 legs).

## One line per FAIL (the StepEffect row that would move it; TABLE is NOT changed here)

- FAIL step_in: StepEffect.TABLE.step_in (open 0.12, drain 0.40, tank 0.30, wrong_extra_damage 0.20, distance inside, open_on inside) is the row that would move it - best cell Out-boxer +0.7 outside 1.5-5; wrong cell Pressure fighter +0.1 not negative. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_out: StepEffect.TABLE.step_out (deny 0.25, tank 0.50, clears_ropes, break_to boxing, deny_on all) is the row that would move it - best cell Slugger +1.1 outside 1.5-5; wrong cell Out-boxer +1.8 not negative; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_back: StepEffect.TABLE.step_back (deny 0.35, open 0.10, tank 0.30, ropes +1, distance long, deny_on power, open_on counter) is the row that would move it - other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL pivot_out: StepEffect.TABLE.pivot_out (open 0.08, tank 0.50, clears_ropes, distance mid, open_on any) is the row that would move it - wrong cell Out-boxer +0.1 not negative; other styles outside 0 to +1 (first: Counter-puncher). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL cut_off: StepEffect.TABLE.cut_off (drain 0.60, opp_steps_less 0.30, tank 0.50, opp_ropes +1) is the row that would move it - best cell Out-boxer -0.6 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL herd: StepEffect.TABLE.herd (open 0.12, tank 0.60, opp_ropes +1, open_on power) is the row that would move it - best cell Volume puncher -0.2 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL feint: StepEffect.TABLE.feint (open 0.12, opp_counter_edge -0.10, tank 0.15, open_on any) is the row that would move it - other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL tie_up: StepEffect.TABLE.tie_up (self_tank 0.80, tank -0.80, ends_early, break_to boxing) is the row that would move it - other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL roll_out: StepEffect.TABLE.roll_out (deny 0.40, open 0.10, tank 0.30, deny_on head_hooks, open_on counter) is the row that would move it - best cell Slugger +0.9 outside 1.5-5; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL push_off: StepEffect.TABLE.push_off (drain 0.30, tank 0.40, distance mid) is the row that would move it - best cell Pressure fighter +0.0 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.

Elapsed: 8443 s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue5 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`
