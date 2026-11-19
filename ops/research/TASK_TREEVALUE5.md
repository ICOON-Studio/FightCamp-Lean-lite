# TASK TREEVALUE5 - the step probe keeps a punch on the step's destination card, then reruns the ten steps

Status: OPEN (S528, Claude main). Discipline: boxing. Model: qwen3-coder (PC seat). Phase 2 of ops/research/STEPS_SCOPE_S528.md.

## Why
Your own STEPTUNE2 (docs/STEPTUNE2_RESULT.md) proved the step table cannot be sized while (s3) the probe's plan surgery
strands the opening and (s1, s2) the fight never charged a wrong step. S528 phase 1 (Claude, on main) changed the fight:
- `StepWire.open_edge`: a planned STEP line now passes the opening on to the punch after it; only a planned punch spends
  it, an unplanned pick wastes it. Two steps in a row keep the bigger opening (not the sum).
- `StepWire.levers(..., fit)`: a planned step on a "wrong" fit (`PlanFight.fit`, LiveRound's fit_now) lets
  `WRONG_COST` 0.2 more of her punches land that exchange (the row's `wrong_extra_damage` when it has one).
Read `ops/research/STEPS_SCOPE_S528.md` first, then your STEPTUNE2_RESULT.md s3-s4.

## What to do
1. `tools/treevalue_probe.gd` `_plan_for`: after the S464 surgery removes the punch lines that share the swept step's
   `when`, make sure the step's DESTINATION card (StrikeMap.move(step).to - outside / long / mid / inside / clinch / ropes)
   still holds one planned PUNCH line that answers the game most played there (take it from the base PLAN; if the
   surgery removed the only one, put back the first PLAN punch line whose `when` differs from the step's, retargeted to
   ANY TIME on that card). Print, per step, the plan it plays (one line) so the next reader can check it.
2. Run the ten steps on main (phase 1 is in), the full probe (`tools/treevalue_probe.gd`, no `only=`), GREEN PC. If the PC
   goes RED for long, run it in `-- only=` halves and join the cells. Write `docs/TREEVALUE5_RESULT.md`: the cells per step
   and style (with / without wins, fires a bout), the per-fire invariant I(best, wrong) table again (your s4 method),
   and which three-leg windows opened compared to STEPTUNE2. The RESULT line: `TREEVALUE2 done pass=<n>/10`.
3. Do NOT change `StepEffect.TABLE` numbers (phase 4 sizes them after this). Do not touch `scripts/`.

## Contract
OWNS: tools/treevalue_probe.gd, docs/TREEVALUE5_RESULT.md
RED_TEST: tools/treevalue_probe.gd prints TREEVALUE2 done pass=<n>/10
REGRESSION: tests/step_levers_test.gd, tests/step_effect_test.gd
VISUAL: no

## Prior research
docs/STEPTUNE2_RESULT.md; ops/research/S527_PROBES.md; docs/TREEVALUE4_ROLLOUT_PUSHOFF.txt; E:/FightCamp/tmp/treevalue3.txt.
## What would a human do?
A coach drills the step WITH the punch it sets up; a step alone, with nothing to throw after it, is worth nothing.
## Prefab check
None: our own probe.
