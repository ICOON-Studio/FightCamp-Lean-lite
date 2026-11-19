# STEPS_SCOPE_S528 - footwork steps: fix the wiring before any more sizing (CLAUDE.md item 8)

Source: Qwen STEPTUNE2 (docs/STEPTUNE2_RESULT.md, S527-S528). Verdict: the METHOD is wrong, not the numbers.
STEPTUNE1 and STEPTUNE2 both tried to size `StepEffect.TABLE` against the 1.5-5-in-100 gate; STEPTUNE2 proved
(per-fire invariant, s4) that NO table number can pass it for any of the ten steps, because:
1. Eight TABLE keys are read by nothing in the fight (open_on, distance, break_to, ends_early, self_tank,
   opp_steps_less, opp_counter_edge, wrong_extra_damage). The screens and the map describe effects that do not exist.
2. `StepValue.TARGET` (what the learn card and the Why show the player a step is worth against a style) disagrees
   with `PlanFight.ANSWERS` (what the fight grades) for six of ten steps: the wrong style is not wrong in the fight.
3. `StepWire.open_edge` spends the opening on the next exchange even when that is another step line, so the OPEN
   lever (the one the map leans on for step_in / feint / push_off) mostly does nothing; the probe also starves it
   (its plan surgery leaves no punch on the step's destination card).

METHOD (until phases 1-3 land): no session tunes StepEffect.TABLE numbers; work finishes the phases below.

## Phase 1 - wiring (Claude, S528)
- `StepWire.open_edge`: a planned STEP line passes the opening on (it is not spent); a planned punch spends it; an
  unplanned pick (her instinct) spends it for nothing. Real boxing: a step that makes the opening is followed by the
  punch, often after a second step.
- Wrong-fit cost: a planned step that fires where `PlanFight.fit` says "wrong" costs its `wrong_extra_damage` share
  of the opponent's landed punches as extra damage that exchange (the row's key, today only step_in's 0.20, becomes a
  default WRONG_COST for every step that has none). Control arm: `StepWire.levers_on = false`.
- Test: tests/step_levers_test.gd checks both (red first).

## Phase 2 - the probe (Qwen, TREEVALUE5)
- `tools/treevalue_probe.gd`: keep one punch line on the swept step's destination card (the plan surgery must not
  strand the opening). Rerun the ten steps on the phase-1 code. Output: the per-step cells and the I(best, wrong)
  invariants again, so we see which windows opened.

## Phase 3 - truth on the screens (Claude)
- `StepValue.TARGET`: each step's wrong style = a style whose main mode (`Exchanges.MODE_V`) lists the step in
  `ANSWERS.wrong`; where no style does, the row has no wrong style (the learn card says "no style punishes it").
  Once TREEVALUE5 has measured cells, the learn card shows the MEASURED worth (STEPVALUE1's "step worth on the learn
  card"), not the map's estimate.
- Unwired keys: CUT from TABLE and from the hovers/map unless phase 1 wired them (distance, break_to, ends_early,
  self_tank, opp_steps_less, opp_counter_edge, open_on). step_effect_test pins two of them - update it.

## Phase 4 - sizing (Qwen), only after 1-3
- STEPTUNE3 sizes TABLE on TREEVALUE5's cells with the gate unchanged. If a step still has an empty window, the step
  gets a design change (Dola critic), not a number.

## Board
Roadmap plan: STEPSCOPE1 (claude, phases 1 + 3), TREEVALUE5 (qwen, phase 2), STEPTUNE3 (qwen, after).

## Done S528 (Claude)
- Phase 1: StepWire.open_edge passes the opening through a step line; StepWire.levers(.., fit) - a wrong-fit step lets
  WRONG_COST 0.2 more punches land. step_levers_test (new checks), step_effect, golden_path green.
- Phase 3 (first half): StepValue.TARGET follows ANSWERS - step_in wrong vs Pressure (was Counter), step_out wrong vs
  Out-boxer (was Counter), feint / tie_up / push_off / roll_out no wrong style; wrong_style() = "" when none punishes.
  step_value_test updated to the fight's truth; step_why, study_pick_walk green.
- The unread TABLE keys reach no screen (grep: only StepEffect.gd), so nothing misleads the player; they are left as
  data until TREEVALUE5 says whether any needs wiring. Phase 2 = Qwen TREEVALUE5 (launched S528).
