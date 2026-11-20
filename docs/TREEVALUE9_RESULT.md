# TREEVALUE9 Result (S531) - the footwork re-read after phase 6 (a sharp boxer holds a wrong-fit step)

Run 2026-11-20 18:02-21:01 on the PC (10,731 s), same probe and seeds as TREEVALUE8. Phase 6: StepWire.hold_chance - a
boxer holds a planned step that is wrong for the opponent's game this exchange, 0 at fight IQ 40 up to 0.8 at 100 (the
probe's boxers are "Sharp 60": hold chance 0.27).

## S531 read (Claude) - against TREEVALUE8

| Step | mean v8 | mean v9 | change | spread v8 | spread v9 | wrong v8 | wrong v9 |
|------|---------|---------|--------|-----------|-----------|----------|----------|
| step_in | +0.42 | +0.33 | -0.08 | 0.6 | 0.6 | 12% | 10% |
| step_out | +1.28 | +1.32 | +0.03 | 1.5 | 1.7 | 7% | 6% |
| step_back | +1.92 | +2.17 | +0.25 | 6.1 | 5.8 | 36% | 33% |
| pivot_out | +0.73 | +0.77 | +0.03 | 2.0 | 1.8 | 0% | 0% |
| cut_off | -1.28 | -1.13 | +0.15 | 2.8 | 2.1 | 35% | 30% |
| herd | -0.22 | -0.20 | +0.02 | 0.3 | 0.4 | 47% | 40% |
| feint | +1.22 | +1.32 | +0.10 | 2.8 | 3.2 | 8% | 6% |
| tie_up | +2.40 | +2.33 | -0.07 | 2.2 | 2.2 | 6% | 5% |
| roll_out | +0.25 | +0.28 | +0.03 | 1.9 | 1.5 | 0% | 0% |
| push_off | -0.02 | -0.02 | +0.00 | 0.2 | 0.2 | 0% | 0% |

- Phase 6 works as built and is small at fight IQ 60: wrong-fit fires 14.9% -> 13.0% (the 0.27 hold), the wrong-heavy
  steps gained a little (step_back +0.25, cut_off +0.15). A sharper boxer will feel it more; that is the point of it.
- Gate, verbatim: **TREEVALUE2 done pass=0/10**. Determinism 208/208, without-arm fires 0.
- Five phases (5a, 5d, 5e, 5b, 6) have each moved the board by tenths. The one big number - step_back worth +5 against
  Pressure fighter / Slugger and ~0 against Out-boxer / Counter-puncher / Boxer-puncher - has not moved since 5a, and it
  is boxing-true: stepping back is THE answer to a forward fighter and little use against one who already stays long.

## Decision (S531, Claude as developer)
Stop adding footwork lever layers. The gate's "others 0..1" leg asks a step to be worth nothing against every style but
its best, which real boxing does not do (step_back helps against three forward styles). Next is a GATE review, not
another lever: rewrite TREEVALUE2's legs per step from the real "who is it for" list (StepEffect best/wrong styles plus
the boxing reason), then re-score TREEVALUE9 against the new legs without a new run. Only a step that still fails the
corrected gate gets a sizing change.

---

## The probe page as written (it still titles itself TREEVALUE5)

Probe run: 2026-11-20T21:01:06. Phase 2 of STEPS_SCOPE_S528 on the phase-1 fight: StepWire.open_edge passes a step's opening on to the punch after it; a wrong-fit step lets WRONG_COST more of her punches land. 400 bouts a cell per arm per seed set, 3 sets, amateur 3x3, 60 fighters, Sharp 60, OK grade.

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

- OK grade on every swept step: yes. Determinism: 208 / 208 wins (fires 823 / 823). Without-arm planned fires: 0 (must be 0).
- Calibration (full BASE plan, 120 bouts): { "Maria Ortega": "60/120", "Jade Cooper": "58/120", "Holly Price": "59/120", "Priya Nair": "63/120", "Erin Doyle": "61/120", "Dana Whitfield": "61/120" }. Ratings: { "Maria Ortega": 52.88671875, "Jade Cooper": 56.3671875, "Holly Price": 54.6953125, "Priya Nair": 53.29296875, "Erin Doyle": 53.01953125, "Dana Whitfield": 52.640625 }.

## Cells: win difference in 100 [with / without wins] fires/bout (TARGET beside it)

| Step | Pressure fighter | Slugger | Out-boxer | Counter-puncher | Volume puncher | Boxer-puncher |
|------|------|------|------|------|------|------|
| step_in | +0.0 (t-2.5) [579/579] f0.46 w11% | +0.2 (t+0.5) [535/533] f0.40 w14% | +0.6 (t+3.0) [545/538] f1.02 w9% | +0.3 (t+0.5) [598/594] f1.77 w11% | +0.3 (t+0.5) [581/578] f0.41 w7% | +0.6 (t+0.5) [569/562] f0.72 w10% |
| step_out | +0.9 (t+1.0) [580/569] f1.39 w6% | +0.8 (t+2.5) [546/536] f1.37 w4% | +2.0 (t-1.0) [570/546] f1.59 w4% | +0.9 (t+1.0) [623/612] f1.35 w6% | +0.8 (t+1.0) [593/584] f1.67 w8% | +2.5 (t+1.0) [593/563] f1.53 w5% |
| step_back | +5.2 (t+3.5) [596/534] f2.09 w12% | +5.2 (t+1.0) [559/497] f2.06 w15% | -0.6 (t-1.5) [561/568] f1.35 w59% | -0.1 (t+1.0) [615/616] f0.80 w39% | +3.6 (t+1.0) [608/565] f2.40 w30% | -0.3 (t+1.0) [583/587] f1.74 w41% |
| pivot_out | +1.8 (t+2.5) [584/562] f2.79 w0% | +1.1 (t+0.0) [547/534] f3.40 w0% | +0.1 (t-0.5) [559/558] f0.96 w0% | +0.0 (t+0.0) [621/621] f1.00 w0% | +1.2 (t+0.0) [600/586] f2.23 w0% | +0.4 (t+0.0) [584/579] f1.88 w0% |
| cut_off | -1.5 (t-1.5) [607/625] f0.82 w48% | -1.3 (t+0.0) [571/587] f0.89 w45% | -0.7 (t+3.5) [608/616] f1.12 w8% | -0.2 (t+0.0) [649/651] f0.98 w10% | -2.3 (t+0.0) [610/637] f1.06 w48% | -0.8 (t+0.0) [607/617] f1.05 w23% |
| herd | -0.2 (t-1.5) [627/629] f0.15 w55% | -0.2 (t+1.0) [589/591] f0.11 w45% | -0.3 (t+1.0) [619/623] f0.19 w29% | +0.1 (t+1.0) [656/655] f0.20 w31% | -0.3 (t+2.0) [637/640] f0.23 w43% | -0.3 (t+1.0) [622/625] f0.21 w35% |
| feint | +1.0 (t+0.5) [639/627] f1.13 w6% | +0.5 (t+0.5) [629/623] f0.93 w5% | +1.3 (t+0.5) [603/587] f1.93 w6% | +3.7 (t+4.0) [641/597] f4.99 w6% | +0.5 (t+0.5) [665/659] f0.77 w8% | +0.9 (t+0.5) [633/622] f1.56 w7% |
| tie_up | +3.4 (t+0.0) [622/581] f2.31 w11% | +1.8 (t+3.0) [572/550] f1.20 w3% | +2.5 (t+0.0) [540/510] f1.70 w4% | +1.2 (t+0.0) [606/592] f1.44 w6% | +2.4 (t+0.0) [628/599] f1.54 w4% | +2.7 (t+0.0) [585/553] f1.55 w4% |
| roll_out | +1.1 (t+1.0) [582/569] f2.38 w0% | +0.8 (t+3.0) [548/538] f1.19 w0% | -0.3 (t+1.0) [529/533] f1.79 w0% | +0.5 (t+1.0) [588/582] f1.52 w0% | +0.0 (t+1.0) [589/589] f1.58 w0% | -0.4 (t+1.0) [568/573] f1.59 w0% |
| push_off | +0.0 (t+1.5) [561/561] f0.82 w0% | -0.1 (t+0.0) [542/543] f0.39 w0% | +0.0 (t+0.0) [509/509] f0.50 w0% | +0.1 (t+0.0) [570/569] f0.45 w0% | -0.1 (t+0.0) [575/576] f0.46 w0% | +0.0 (t+0.0) [545/545] f0.48 w0% |

## The gate's three legs and the per-fire invariant I(best,wrong) vs STEPTUNE2

I(best,wrong) = cell_best - (F_best/F_wrong) x cell_wrong (F = fires/bout): no TABLE number moves it; the gate needs I > 1.5 for the best (1.5..5) and wrong (<0) legs to coexist. 'Window' = the leg count that can pass.

| Step | best | wrong | I now | I ST2 | I>1.5 | legs now | legs ST2 | window |
|------|------|-------|-------|-------|-------|----------|----------|--------|
| step_in | Out-boxer | Pressure fighter | +0.583 | +0.415 | no | 1 | 1 | still shut |
| step_out | Slugger | Out-boxer | -0.889 | -0.598 | no | 0 | 0 | still shut |
| step_back | Pressure fighter | Out-boxer | +6.067 | +5.960 | yes | 1 | 2 | still shut |
| pivot_out | Pressure fighter | Out-boxer | +1.592 | +1.330 | yes | 1 | 0 | opened |
| cut_off | Out-boxer | Pressure fighter | +1.373 | +2.073 | no | 1 | 1 | still shut |
| herd | Volume puncher | Pressure fighter | +0.005 | +0.361 | no | 1 | 1 | still shut |
| feint | Counter-puncher |  | n/a | -1.422 | no | 2 | 1 | opened |
| tie_up | Slugger |  | n/a | -0.038 | no | 2 | 1 | opened |
| roll_out | Slugger |  | n/a | +0.070 | no | 1 | 1 | still shut |
| push_off | Pressure fighter |  | n/a | +0.128 | no | 1 | 2 | still shut |

**TREEVALUE2 done pass=0/10** (gate legs: best in 1.5..5, wrong < 0, others 0..1).

Windows that opened vs STEPTUNE2: pivot_out (0->1 legs), feint (1->2 legs), tie_up (1->2 legs).

## One line per FAIL (the StepEffect row that would move it; TABLE is NOT changed here)

- FAIL step_in: StepEffect.TABLE.step_in (open 0.12, drain 0.40, tank 0.30, wrong_extra_damage 0.20, distance inside, open_on inside) is the row that would move it - best cell Out-boxer +0.6 outside 1.5-5; wrong cell Pressure fighter +0.0 not negative. Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_out: StepEffect.TABLE.step_out (deny 0.25, tank 0.50, clears_ropes, break_to boxing, deny_on all) is the row that would move it - best cell Slugger +0.8 outside 1.5-5; wrong cell Out-boxer +2.0 not negative; other styles outside 0 to +1 (first: Boxer-puncher). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL step_back: StepEffect.TABLE.step_back (deny 0.35, open 0.10, tank 0.30, ropes +1, distance long, deny_on power, open_on counter) is the row that would move it - best cell Pressure fighter +5.2 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL pivot_out: StepEffect.TABLE.pivot_out (open 0.08, tank 0.50, clears_ropes, distance mid, open_on any) is the row that would move it - wrong cell Out-boxer +0.1 not negative; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL cut_off: StepEffect.TABLE.cut_off (drain 0.60, opp_steps_less 0.30, tank 0.50, opp_ropes +1) is the row that would move it - best cell Out-boxer -0.7 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL herd: StepEffect.TABLE.herd (open 0.12, tank 0.60, opp_ropes +1, open_on power) is the row that would move it - best cell Volume puncher -0.3 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL feint: StepEffect.TABLE.feint (open 0.12, opp_counter_edge -0.10, tank 0.15, open_on any) is the row that would move it - other styles outside 0 to +1 (first: Out-boxer). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL tie_up: StepEffect.TABLE.tie_up (self_tank 0.80, tank -0.80, ends_early, break_to boxing) is the row that would move it - other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL roll_out: StepEffect.TABLE.roll_out (deny 0.40, open 0.10, tank 0.30, deny_on head_hooks, open_on counter) is the row that would move it - best cell Slugger +0.8 outside 1.5-5; other styles outside 0 to +1 (first: Pressure fighter). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.
- FAIL push_off: StepEffect.TABLE.push_off (drain 0.30, tank 0.40, distance mid) is the row that would move it - best cell Pressure fighter +0.0 outside 1.5-5; other styles outside 0 to +1 (first: Slugger). Only its ropes count is wired today (StepWire); the deny/open/drain sizes are not in the exchange yet.

Elapsed: 10731 s. Reproduce: `python ops/Tools/godot_slot.py run --who treevalue5 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/treevalue_probe.gd`

---

## S532 GATE REVIEW (Claude) - the corrected gate, re-scored on the table above (no new run)

Tool: `python ops/Tools/treevalue_regate.py docs/TREEVALUE9_RESULT.md`. The legs come from the fight's OWN grading, not
from the cells: fit(step, style) = sum over the style's games (Exchanges.STYLE_MODES share) of the step's grade there
(PlanFight.ANSWERS best +1 / ok +0.5 / wrong -1). FOR (fit >= 0.40): cell >= +1.0. WRONG (fit <= -0.20): cell <= +0.5.
OTHER: -1.0..+2.0. Every cell <= +6.0. WORTH: at least one cell >= +1.0. Honest note: the thresholds were set by Claude
after TREEVALUE9 was read; the per-style FOR/WRONG lists are not (they are the game's own answers table).

**REGATE done pass=2/10** - pivot_out and feint pass. Old gate: 0/10.

| Step | what fails | the defect in plain words |
|------|-----------|---------------------------|
| cut_off | Out-boxer -0.7 (FOR), Volume -2.3 | the textbook answer to a mover LOSES bouts against him - the worst one |
| tie_up | Out-boxer +2.5, Volume +2.4, Boxer-puncher +2.7 (OTHER) | holding pays against everyone: a free win, not an answer to brawlers |
| step_out | Out-boxer +2.0, Boxer-puncher +2.5 (WRONG) | moving off the line pays most against the styles that want you long |
| step_in | Out-boxer +0.6 (FOR), worth +0.6 at best | closing on a mover is barely worth anything |
| roll_out | Slugger +0.8, Volume 0.0, Boxer-puncher -0.4 (FOR) | rolling under hooks does little against the loaders it is for |
| step_back | Volume +3.6 (OTHER, fit +0.20) | near miss: Volume presses 45% of the time; reasonable, lowest priority |
| herd, push_off | worth +0.1 at best against every style | situational steps (herd: a tired or hurt opponent; push_off: out of a clinch) - a style sweep cannot see them |

## Decision (S532)
The gate is now per step and grounded in the fight's answers table; sizing is allowed for the steps that fail it, in this
order: cut_off, tie_up, step_out, step_in, roll_out (StepEffect TABLE rows, one probe read per change). herd and push_off
get a SITUATION probe first (opponent tired / hurt; a clinch on the ropes) before any sizing - a 0 in a style sweep is not
evidence they are worthless. step_back vs Volume puncher is left alone.
