# TASK STEPTUNE1 - size the footwork steps' levers until each is worth its target (tuning, no screen)

Status: OPEN (S526, Claude main). Discipline: boxing. Model: Goose (cloud) - tuning with a headless probe.
Map: `ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md` section 9 gate 2 (each step worth 1.5-5 in 100 against its own
style). Targets per step x style: `StepValue.TARGET` in scripts/rules/StepValue.gd (best style positive, wrong style
negative, the rest small). Levers: `StepEffect.TABLE` in scripts/rules/StepEffect.gd (deny, open, drain, tank, ropes...).
Since S525 every lever reaches the fight (StepWire; tests/step_levers_test.gd). Baseline: docs/TREEVALUE3_RESULT.txt
(tools/treevalue_probe.gd, 400 bouts a cell x 3 seed sets, all 60 cells, on main after the wiring).

## Baseline against target (TREEVALUE3, in 100; target in brackets)
step_back Pressure +3.67 [3.5] ok, Out-boxer -1.58 [-1.5] ok, but Slugger +3.33 [1.0], Volume +2.42 [1.0] too high.
step_in Out-boxer +0.67 [3.0] low, Counter +0.42 [-2.5] wrong sign. step_out Slugger +0.25 [2.5] low, Counter +0.83 [-1.0].
pivot_out Pressure +1.33 [2.5] low. cut_off Out-boxer -0.25 [3.5] WRONG SIGN, Volume -2.67 [0.0]. herd fires 0.2 a bout
(too rare to be worth anything). feint, tie_up, roll_out, push_off: not in the partial baseline - your probe measures them first.

## The job
1. A quick probe `tools/steptune_probe.gd`: preload tools/treevalue_cells.gd and the probe's tables (read-only; copy what
   cannot be preloaded) and run ONLY each step's best and wrong style cells (20 cells), one seed set, 400 bouts a cell -
   print `CELL step style delta fires/bout` like TREEVALUE. Pilot first, print the projected minutes.
2. Change ONLY numbers in StepEffect.TABLE (and only rows whose best or wrong cell misses its target by more than 1.0)
   until each best cell is 1.5-5 and within 1.0 of its target, and each wrong cell is below 0. One lever per row per run,
   say why that lever (what the step does in boxing: a cut-off traps a mover on the ropes, so its value lives in
   opp_ropes / drain against the Out-boxer). If a row cannot reach its target by numbers alone, stop on that row and
   write why (which lever moves nothing - name the code path), as TURNTUNE1 did.
3. Final: the 20 cells on all 3 seed sets, written by the probe into docs/STEPTUNE1_RESULT.md with before / after per row.

## Contract
OWNS: scripts/rules/StepEffect.gd, tools/steptune_probe.gd, docs/STEPTUNE1_RESULT.md, tests/step_effect_test.gd
RED_TEST: tools/steptune_probe.gd -> STEPTUNE1 done
REGRESSION: step_effect_test, step_levers_test, step_ropes_test, step_value_test, step_why_test, golden_path_test
VISUAL: no
NOT YOURS: every other file. In StepEffect.gd change TABLE numbers only - no new keys, no code. tests/step_effect_test.gd
may change only where it pins a TABLE number you changed (say each one). PR body: `RESULT: tools/steptune_probe.gd ->
rows_in=<n of 10> misses=<step:why,...>`. Each file under 500 lines. Stop at 90 minutes of run time; report what you had.

## Prior research
`python ops/Tools/prior_research.py treevalue step value` -> TREEVALUE1/2 results, TASK_TREEVALUE2, DESIGN_STEPVALUE1_V1.

## What would a human do?
A coach knows what each move is for: you cut off a runner, you step back from a presser. Each number should make the
step pay where boxing says it pays and cost where it does not.

## Prefab check
None: reuses the TREEVALUE probe's cells.

## The one trap
Tuning on one seed set can fit noise: a cell's three seed values in TREEVALUE3 differ by up to 5 points. Only the final
3-set run counts; a row "in" on one set and out on three is out.
