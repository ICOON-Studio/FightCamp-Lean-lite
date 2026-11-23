# STEPPAY4 (S538-S539) - the wrong style punishes the step

Briefs: ops/research/TASK_STEPPAY4.md (S538, the rule) and ops/research/TASK_STEPPAY5.md (S539, the finish). Branch
s538/steppay4, not merged. Built on STEPPAY3 (docs/STEPPAY3_RESULT.md, "Not done" 1).

## Result in one table - the STEPPAY3 gate, all ten steps, same population
tools/treevalue_probe.gd `when=best`, 400 bouts x 3 seed sets a cell, the plan with the step's lines minus the same plan
without them, wins in 100. Same 60 generated fighters, one shipped opponent a style, re-rated so the base plan wins about
half. Bold = the style the step is FOR. "Before" = docs/STEPPAY3_RESULT.md's table. The third leg is BY SITUATION
(tools/step_fire_fit_probe.gd `legs=`): every other style within 2.0 of worth x its best fires a bout, never above 5.

| step | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher | FOR leg (1.5..5) | wrong leg (< 0) before -> after | others |
|---|---|---|---|---|---|---|---|---|---|
| step_in | -1.58 | +0.42 | **+4.33** | +1.25 | +2.17 | +2.75 | +4.08 -> +4.33 | Pressure +0.50 -> **-1.58** | yes |
| step_out | +2.17 | **+3.00** | -2.75 | +1.17 | +2.58 | +4.00 | +3.08 -> +3.00 | Out-boxer +2.92 -> **-2.75** | yes |
| step_back | **+4.67** | +1.92 | -4.92 | +1.17 | +3.00 | +1.58 | +4.83 -> +4.67 | Out-boxer +0.67 -> **-4.92** | yes (Slugger was NO) |
| pivot_out | **+3.25** | +4.00 | -3.50 | +0.75 | +2.83 | +2.33 | +3.08 -> +3.25 | Out-boxer +0.42 -> **-3.50** | yes |
| cut_off | -0.25 | -0.58 | **+4.75** | +1.33 | +2.08 | +1.17 | +3.92 -> +4.75 | Pressure -0.25 -> -0.25 | yes |
| herd | -1.92 | +0.42 | +3.75 | +1.75 | **+1.92** | +2.00 | +1.92 -> +1.92 | Pressure +1.25 -> **-1.92** | yes |
| feint | +0.50 | +0.25 | +1.75 | **+4.92** | +0.50 | +0.58 | +4.92 -> +4.92 | none | yes |
| tie_up | +3.83 | **+1.75** | +2.33 | +1.67 | +2.50 | +2.33 | +1.75 -> +1.75 | none | yes |
| roll_out | +2.08 | **+2.67** | -0.42 | -0.08 | +0.92 | +0.92 | +2.67 -> +2.67 | none | yes |
| push_off | **+3.00** | +2.42 | +0.25 | +0.33 | +2.75 | +0.50 | +2.67 -> +3.00 | none | yes |

**All three legs: 10 of 10 (STEPPAY3: 5 of 10; the first STEPPAY4 gate: 8 of 10).** FOR leg 10 of 10 in the band. The five
wrong legs this task was for now read below 0 (step_in -1.58, step_out -2.75, step_back -4.92, pivot_out -3.50, herd -1.92).

Thin margins, said plainly (a cell is 1,200 paired bouts, about +-1.1):
- cut_off +4.75 sits near the band's top (5.0); its three seed sets read +6.75 / +4.00 / +3.50. A re-run with other seeds can
  read it over.
- feint +4.92 near the top, tie_up +1.75 and herd +1.92 near the floor (unchanged from STEPPAY3).
- cut_off's wrong leg -0.25 and step_in's -1.58 are the closest to 0.
- cut_off v Boxer-puncher: +1.17 against a by-situation +2.95 (1.78 inside the 2.0 tolerance).

## What was built (S538, STEPPAY4)
`scripts/rules/StepWrong.gd` (new, pure, zero preloads), wired in `state/RingDuel.gd` (step, step_bias, settle),
`state/StepWire.gd` (ride) and one line of `state/LiveRound.gd` (the planned step passed to RingDuel.step):
- A planned step that came off GIVES the opponent a game: step in / herd -> "press"; step out / step back / pivot out ->
  "range". Only a style that LIVES on that game (half her fight or more in Exchanges.STYLE_MODES) takes it: she plays it
  6x as often for the rest of the round (until your boxer wins an exchange without such a step) and each exchange of it is
  hers by 30 x her share of it in power points.
- She MEETS the step: the exchange it is taken in is hers by the same price, and the fight grades it WRONG in the record
  (arrow_fit; the result page and the Why read it).
- The step is only a step against her: no punch rides with it.
- The line of the loaded shot: step back against a boxer whose MAIN game is the loaded shot (the Slugger), while she loads
  up, is met and bare the same way.

## What STEPPAY5 changed (S539)
1. **cut_off had regressed (+3.92 -> +6.25 against the Out-boxer).** Measured first (quick cells, `step_fire_fit_probe.gd delta`):
   StepWrong off +4.92, StepWrong without the meet +5.42, StepWrong on +6.33; keeping the given range for 1 or 2 exchanges
   instead of the round changed nothing (+6.42 / +6.25). So it was the MEET: the base plan's any-time step back / pivot out
   are met by the Out-boxer in both arms, and in the with-arm cut_off takes some of those exchanges. That is boxing-true
   (cutting the ring beats backing off an out-boxer), but it pushed cut_off over the band. A fight-IQ hold of a step she
   would meet was tried and changed nothing (+6.58), so it was taken out again.
   **The rule (StepWrong.slides, read in StepWire.ride): a boxer who lives on the range slides off the first cut of a
   round.** Cutting the ring on a mover is slow work: the first cut takes her room (StepWire's ring_cut) but she slides
   along the ropes and out - only a step, nothing rides. Once the ring is cut she is trapped and the next cut rides as
   before. Only the Out-boxer (range 0.6) lives on the range among the six; every other style is untouched. Cut_off rides
   against the Out-boxer fell from 2.19 to 0.52 a bout; the gate cell +6.25 -> +4.75. step_in's cells and every calibrated
   rating are identical to the run before the rule, so nothing else moved through the re-rating.
2. **step_back v Slugger over the situation bar (+6.73 by situation, the cell +1.92).** The Slugger rule (LINE, above) was
   already in: the cell itself was in place. The by-situation number counted a step the fight GRADES WRONG (she met it on
   the line of her loaded shot) as a best fire, because the fit probe re-graded from the answer table. The fit probe now
   counts each fire by the fight's own grade (`arrow_fit`, what the result page shows). Step back against the Slugger:
   2.35 -> 0.96 best fires a bout (62% of its fires are met), by situation +6.73 -> +2.75 against the cell's +1.92: in.
   That is a change of the MEASURE, not of the game; it only differs from the old count where StepWrong met a step (the
   five wrong styles, whose cells the third leg does not check, and step back against the Slugger).
3. `tools/treevalue_cells.gd`: the summary prints the three legs per step (S538). Its "pass=" count still uses the old
   STEPPAY2 TARGET test and reads 2/10; the gate verdict is the `legs=` line above.

## The whole game (tools/place_value_probe.gd, STEPPAY3 "Not done" 4)
Exchange win share for your boxer by place, before (main) -> after (this branch). Re-run after the slide rule: identical to
the run before it (that probe's plan has no cut off line).
- Against the Out-boxer the mix moves: mid 45.2 -> 36.6 (the plan's step back is met there), own ropes 38.5 -> 27.8 (pivot
  out), long 48.9 -> 45.8 (step out), the CONTROL cell 46.8 -> 44.4, the game sim's share 43.5 -> 42.0.
- Every other style moves 1.7 points or less (Pressure outside 45.8 -> 44.1, opp ropes 50.2 -> 48.8, rest under 1).
- Read: a player whose plan steps back from an out-boxer loses more of those exchanges - the point of the rule. The gate
  re-rates the Out-boxer (shipped 59.0: 55.15 -> 54.24) so its cells stay comparable; the shipped opponent is not re-rated.
- The probe's own CONTROL check reads FAIL on main too (mix_before), not caused by this branch.

## Tests
- tests/step_wrong_test.gd: the five rules, the line rule, the meet, the bare step, played bouts and the control arm
  (red on main: no rule file); S539 adds the slide (first cut bare against Holly Price, the next one rides, a
  counter-puncher's first cut rides, control arm rides). PASS (0 failures).
- Regression PASS on the final rules (0 FAIL / SCRIPT ERROR lines, rc 0 each): golden_path_test (GOLDEN_PATH failures=0),
  plan_fight_test, step_ride_test, place_edge_test, step_levers_test, step_ropes_test, step_contract_test,
  step_effect_test, step_value_test, step_moment_short/landed/flurry/smother/drift_test, line_grade_test, grade_wire_test,
  fight_why_test, line_swap_test, p4p_corner_eye_test, plan_bout_test, balance_harness_test, exchanges_test,
  debut_read_test, ropes_contract_test, ropes_lines_test, file_limits_test.

## Outside the brief's first OWNS list (said, not hidden)
- `scripts/state/LiveRound.gd`: one changed line (S538), none in S539 (the hold experiment was reverted).
- `scripts/state/StepWire.gd`: the ride check (S538) now also reads StepWrong.slides (S539, three lines).
- `scripts/state/RingDuel.gd`: the wire (S538), unchanged in S539.
- `tools/treevalue_probe.gd` is 533 lines on main already (over the 500 rule before this task); one line changed here.

## Not done / seen
- cut_off sits at +4.75: if a later change nudges it, it goes over first.
- No screen says "she slid off the cut" or "she met your step back": the record carries `met` / `trap` and the grade
  (wrong); the result page's words read only the grade.
- tools/run_tests.sh's list does not have step_wrong_test (nor STEPPAY3's five moment tests).
- Raw probe output in the worktree's .probe_out/ (not committed): g_1..g_5.txt (S538 gate), g6_a.txt (S539 cut_off +
  step_in), fit6.txt, legs6.txt, m1_*/m2_*/m3_* (sizing), mix_before/after/mix6.txt, tests6.txt.

Reproduce: `python ops/Tools/godot_slot.py run --who steppay5 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
--path . --script res://tools/treevalue_probe.gd -- when=best only=<2 steps>` (five parts), then
`... tools/step_fire_fit_probe.gd -- n=120 when=best`, then `... -- legs=<the gate files, then the fit file, comma separated>`.
