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

## Phase 5 - the levers reach the score (S531, from STEPTUNE3 `docs/STEPTUNE3_RESULT.md` s3b + s3c)
STEPTUNE3 measured the phase-1 levers and found two DESIGN faults, not numbers (every sized row went back):
- 5a DONE S531 (Claude): DENY cut her landed punches only after `Exchanges.settle` had fixed the exchange, so it never
  reached the cards. `StepWire.deny_edge` now adds denied share x EDGE.best to the duel BEFORE settle (ESTIMATE);
  `levers` still cuts the landed punches after (body shots, guard). A wrong-fit step already loses margin through its plan
  line's grade (LineGrade), so WRONG_COST stays a landed-punch cost only.
- 5b OPEN, MEASURE FIRST: STEPTUNE3 s3b says a step fires on the card that grades it right. Claude's read (S531): since
  CARDFIX1 the card (`lv["at"]`) persists and the situation (`sit`) is the opponent's game rolled each exchange
  (LiveRound ~line 235), so a step CAN fire while she plays the game that grades it wrong (step_in at outside vs a
  presser). Grading on the destination card does NOT help (step_in lands at long = range, where it is best). Next: count,
  per step and per opponent style, the share of fires with fit "wrong" (a counter in StepWire.levers' out + the probe).
  If that share is near zero for a step whose wrong style is real, grade its wrong cost on her style's main game instead.
- 5c DONE S531 (probe tool): `tools/treevalue_cells.gd:78` errors when `StepValue.wrong_style` is "" (feint, tie_up, roll_out,
  push_off since phase 3) and the summary never prints: now the missing leg passes and the two that exist decide.
Then TREEVALUE6 (Qwen) re-reads the board on 5a(+5b); sizing only after it.
- TREEVALUE6 READ S531 (`docs/TREEVALUE6_RESULT.md`, PC run, 14,427 s, pass=0/10): 5a WORKS for the deny rows - mean win
  change per style vs TREEVALUE5: step_back +0.97 -> +2.30, step_out +0.97 -> +1.77, roll_out -0.23 -> +0.40; every
  non-deny step moved under 0.3. But the deny rows now help ALMOST EVERY style (step_back +5.3 Pressure, +5.6 Slugger,
  +3.2 Volume; step_out +1.1..+2.8 across all six), so the "others 0..1" and "wrong < 0" legs fail: the deny edge is
  style-blind. cut_off is still NEGATIVE for every style (-0.1..-2.8) and herd / push_off read ~0 (herd fires 0.2 a bout).
  NEXT (5d, design, before any sizing): make deny_edge scale with how much of HER game the step denies (deny_on power /
  head_hooks only against the punches she throws most - her style's punch mix), so it pays against its best style and not
  the rest; then 5b's wrong-fire count; cut_off's sign is its own defect (drain lowers HER output but the step costs his
  own exchange - check which side the drain is applied to). The FAIL lines' "only its ropes count is wired" text in the
  probe is stale since 5a (fix in tools/treevalue_probe.gd with 5d).
- 5d BUILT S531 (Claude): no per-style punch mix exists in the game (BoutBurn.MIX is one table), so instead of inventing one
  the deny edge follows the fight's OWN grade of the step against her game this exchange (PlanFight.fit = LiveRound's
  fit_now): StepWire.DENY_FIT best 1.0 / ok 0.5 / none 0.15 / wrong 0 (ESTIMATES; wrong pays WRONG_COST in levers).
  step_levers (new fit checks), step_contract, step_effect, golden_path PASS. TREEVALUE7 (PC, same probe) re-reads the board.
- 5e FIXED S531 (Claude, while looking for cut_off's sign): LiveRoundAfter kept its own copy of her_energy / opp_energy that
  had drifted from RingDuel's (no step DRAIN on the opponent, no per-bout body cost for her). The duel read the drain; the
  round's end state and the opponent's next mode did not. Both now call RingDuel's. NOTE: TREEVALUE7 started before this
  fix, so it measures 5d alone; cut_off / push_off need the run after it (TREEVALUE8) to show whether DRAIN now pays.
- 5b COUNTER BUILT S531: each exchange record carries "step_fit" (LiveRound's fit_now); tools/treevalue_cells.gd counts the
  planned fires whose step_fit was "wrong" and tools/treevalue_probe.gd prints it per cell (CELL ... wrong=%, the table's
  w%). TREEVALUE7 started before it; TREEVALUE8 (after 5d + 5e + this counter) gives the first wrong-share board.
