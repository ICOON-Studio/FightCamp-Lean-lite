# STEPPAY3 (S537) - the five steps with no moment get one

Brief: ops/research/TASK_STEPPAY3.md. Built on STEPPAY2 (docs/STEPPAY2_PHASE3.md, docs/STEPPAY2_PHASE4.md "what is left" 1 and 3).
Branch s537/steppay3, not merged.

## Result in one table - the STEPPAY2 gate, all ten steps, same population
tools/treevalue_probe.gd `when=best`, 400 bouts x 3 seed sets a cell, the plan with the step's lines minus the same plan
without them, wins in 100. In brackets: fires a bout / share of fires that cost no exchange. Bold = the style the step is FOR.
Step at Sharp, OK grade; 60 generated fighters (all differ) against one shipped opponent a style, re-rated so the base plan
wins about half. "Before" = docs/STEPPAY2_PHASE4.md's table.

| step | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher | FOR leg before -> after (1.5..5) | wrong leg (< 0) | others by situation |
|---|---|---|---|---|---|---|---|---|---|
| step_in | +0.50 (0.53/23%) | +0.42 (0.47/23%) | **+4.08 (1.71/64%)** | +1.25 (1.88/38%) | +2.17 (0.79/64%) | +2.75 (1.15/55%) | Out-boxer +0.83 -> **+4.08**: in the band | Pressure +0.58 -> +0.50: NOT negative | yes |
| step_out | +2.42 (1.35/61%) | **+3.08 (1.45/60%)** | +2.92 (1.49/51%) | +1.17 (1.17/54%) | +2.58 (1.52/51%) | +4.00 (1.49/53%) | Slugger +1.08 -> **+3.08**: in the band | Out-boxer +2.75 -> +2.92: NOT negative | yes |
| step_back | **+4.83 (1.76/91%)** | +5.17 (2.23/94%) | +0.67 (0.95/65%) | +1.17 (0.65/82%) | +3.00 (1.54/76%) | +1.58 (1.48/79%) | Pressure +8.75 -> **+4.83**: in the band | Out-boxer -0.67 -> +0.67: NOT negative | NO (Slugger) |
| pivot_out | **+3.08 (2.31/47%)** | +4.00 (2.75/43%) | +0.42 (0.93/23%) | +0.75 (0.99/28%) | +2.83 (2.02/46%) | +2.33 (1.61/32%) | Pressure +3.83 -> **+3.08**: in the band | Out-boxer +0.08 -> +0.42: NOT negative | yes |
| cut_off | -0.25 (1.01/31%) | -0.58 (1.21/27%) | **+3.92 (2.81/77%)** | +1.33 (1.47/63%) | +2.08 (1.93/65%) | +1.17 (2.06/67%) | Out-boxer +6.75 -> **+3.92**: in the band | Pressure -1.00 -> -0.25: ok | yes |
| herd | +1.25 (0.46/72%) | +0.42 (0.41/78%) | +2.50 (1.06/88%) | +1.75 (0.98/88%) | **+1.92 (0.73/78%)** | +2.00 (0.89/83%) | Volume +0.17 -> **+1.92**: in the band | Pressure -0.08 -> +1.25: NOT negative | yes |
| feint | +0.42 (1.07/52%) | +0.25 (0.85/47%) | +1.50 (1.82/60%) | **+4.92 (4.46/68%)** | +0.50 (0.71/52%) | +0.58 (1.46/52%) | Counter-puncher +4.17 -> **+4.92**: in the band | none | yes |
| tie_up | +3.67 (2.56/0%) | **+1.75 (1.64/0%)** | +2.50 (1.53/0%) | +1.67 (1.44/0%) | +2.50 (1.67/0%) | +2.33 (1.59/0%) | Slugger +2.00 -> **+1.75**: in the band | none | yes |
| roll_out | +2.50 (2.67/22%) | **+2.67 (1.68/39%)** | +0.50 (1.59/14%) | -0.08 (1.50/15%) | +0.92 (1.76/22%) | +0.92 (1.63/22%) | Slugger +0.75 -> **+2.67**: in the band | none | yes |
| push_off | **+2.67 (1.61/45%)** | +2.42 (1.28/61%) | +0.08 (0.47/10%) | +0.33 (0.52/15%) | +2.75 (1.14/57%) | +0.50 (0.76/38%) | Pressure +0.00 -> **+2.67**: in the band | none | yes |

**The style-it-is-FOR leg: 10 of 10 in the band (before: 3 of 10).** The five this task was for: step_in +0.83 -> +4.08,
step_out +1.08 -> +3.08, herd +0.17 -> +1.92, roll_out +0.75 -> +2.67, push_off +0.00 -> +2.67. The three that were in the
band stay in (pivot_out +3.08, feint +4.92, tie_up +1.75). The two that were OVER it came down into it without any
StepEffect number changing: step_back +8.75 -> +4.83 and cut_off +6.75 -> +3.92, because the moments take some of the
exchanges those two used to answer every time.

All three legs together (third leg by situation, below): 5 of 10 pass (cut_off, feint, tie_up, roll_out, push_off). The five
that fail, fail on the WRONG leg (step_in, step_out, step_back, pivot_out, herd: the style that should punish the step does
not read below 0), and step_back also on one other style (+5.17 against the Slugger, above the band's top). Three of those
wrong legs failed before this task too; step_back's (-0.67 -> +0.67) and herd's (-0.08 -> +1.25) changed sign inside a
cell's noise (about +-1.1). The wrong leg was not this task's; it is the next piece (see "Not done").

Thin margins, said plainly: tie_up +1.75 and herd +1.92 sit near the band's floor (1.5), feint +4.92 near its top (5.0).
A cell is 1,200 paired bouts, about +-1.1; a re-run can read any of the three just outside.

## What was built
A MOMENT is a situation inside the opponent's game, dealt at a rate (never every exchange), where one step is the answer.
`scripts/rules/StepMoment.gd` (new, pure) says WHEN it is dealt and on which card it is fought; `PlanFight.ANSWERS` has its
row, graded like every other situation (fit, the ride, the levers). One rule a step:

| moment | step | dealt when (one exchange in ... that qualifies) | fought on | the row |
|---|---|---|---|---|
| short | step_in | she boxes at range, your boxer at long range or outside: her jab falls short (1 in 4) | outside | best step_in, 1-1-2; ok 1-2, 2-3, 1-1; wrong feint, step_out |
| landed | step_out | your boxer won the last exchange at long or mid range against a presser / a loader: the return is coming (1 in 4) | long | best step_out; ok 1-1, 1-2; wrong 1-2-3, 1-2-3-2 |
| flurry | roll_out | on your own ropes against a presser / a loader: she steps in close with hooks (1 in 4) | inside | best roll_out, tie_up; ok push_off, slip 2-3; wrong 3b-3 |
| smother | push_off | a presser at mid range or inside walks chest to chest (1 in 2) | clinch | best push_off; ok tie_up, 3b-3, 1-6-3 |
| drift | herd | your boxer won the last exchange against a mover (range, counter): she is on the ropes sliding off (1 in 2) | opponent on the ropes | best herd; ok 1-2 |

- Her own trouble (tired, hurt) and a tiring / hurt opponent deal no moment: those keep their own answers.
- In its moment the planned step rides (STEPPAY2 phase 3): step in is fought at long range with the punch line there, roll
  out is fought in the middle and off the ropes, push off leaves the clinch (and its body digs), herd is fought in the corner.
- Each of the five now also has a situation where it is WRONG (the DEPTH rule): rolling out or pushing off a TIRING opponent
  gives her the rest she wants (roll_out also against a hurt one). step_in, step_out and herd already had theirs.
- The wire in the live round is two lines (`LiveRound.exchange`: the deal before the plan's pick, the row for the grading).
  The record keeps her game in `psit` as before (the result page's words read it) and adds `moment`.
- Control arm: `StepMoment.on = false` = the game before (no moment dealt).

## Measured first (tools/step_fire_fit_probe.gd, 120 bouts a cell, when=best)
fires a bout / in a best situation / best fires a bout; after: (its moment dealt a bout).

| step (its moment) | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher |
|---|---|---|---|---|---|---|
| step_in before | 0.45 / 9% / 0.04 | 0.50 / 7% / 0.04 | 1.03 / 34% / 0.35 | 1.69 / 33% / 0.56 | 0.40 / 19% / 0.08 | 0.82 / 23% / 0.19 |
| step_in after (short) | 0.52 / 24% / 0.13 (0.13) | 0.47 / 13% / 0.06 (0.05) | **1.62 / 60% / 0.97 (0.95)** | 1.71 / 34% / 0.58 (0.36) | 0.69 / 53% / 0.37 (0.45) | 1.22 / 51% / 0.63 (0.61) |
| step_out before | 1.22 / 36% / 0.44 | 1.36 / 33% / 0.45 | 1.62 / 45% / 0.73 | 1.23 / 46% / 0.57 | 1.48 / 39% / 0.58 | 1.52 / 43% / 0.65 |
| step_out after (landed) | 1.16 / 62% / 0.72 (0.40) | **1.34 / 67% / 0.90 (0.63)** | 1.47 / 51% / 0.75 (0.10) | 1.12 / 51% / 0.57 (0.07) | 1.36 / 50% / 0.68 (0.25) | 1.47 / 55% / 0.80 (0.22) |
| herd before | 0.14 / 18% / 0.03 | 0.13 / 19% / 0.02 | 0.17 / 30% / 0.05 | 0.16 / 21% / 0.03 | 0.18 / 9% / 0.02 | 0.22 / 19% / 0.04 |
| herd after (drift) | 0.34 / 71% / 0.24 (0.32) | 0.39 / 79% / 0.31 (0.44) | 1.07 / 86% / 0.92 (1.25) | 0.78 / 85% / 0.67 (0.99) | **0.62 / 77% / 0.47 (0.61)** | 0.76 / 80% / 0.61 (0.85) |
| roll_out before | 2.36 / 9% / 0.21 | 1.35 / 15% / 0.20 | 1.79 / 8% / 0.14 | 1.53 / 9% / 0.14 | 1.55 / 9% / 0.14 | 1.63 / 10% / 0.16 |
| roll_out after (flurry) | 2.92 / 25% / 0.74 (0.72) | **1.85 / 37% / 0.69 (0.69)** | 1.60 / 13% / 0.20 (0.09) | 1.51 / 12% / 0.18 (0.08) | 1.98 / 26% / 0.53 (0.47) | 1.77 / 22% / 0.38 (0.35) |
| push_off before | 0.85 / 0% / 0.00 | 0.38 / 0% / 0.00 | 0.46 / 0% / 0.00 | 0.47 / 0% / 0.00 | 0.47 / 0% / 0.00 | 0.53 / 0% / 0.00 |
| push_off after (smother) | **1.59 / 41% / 0.66 (0.93)** | 1.09 / 59% / 0.64 (0.97) | 0.45 / 9% / 0.04 (0.06) | 0.53 / 13% / 0.07 (0.09) | 1.27 / 56% / 0.71 (0.96) | 0.74 / 35% / 0.26 (0.36) |

Read: before, herd had 0.02-0.05 best fires a bout and push_off none; now each of the five has 0.47-0.97 against the style it
is for, and the count follows how often a style plays the situation (push_off 0.66 against the Pressure fighter, 0.04 against
the Out-boxer).

## How the rates were sized (each on a measurement, none guessed twice)
1. First rates (short 0.14, landed 0.6 at long only, flurry 0.3, smother 0.14, drift 0.2): best fires a bout against the FOR
   style 0.70 / 0.84 / 0.80 / 0.22 / 0.28 - push_off and herd still short of the about one a bout the in-band steps have.
2. Quick cells (the probe's `delta` mode: the gate's own cell, FOR style only, old ratings): herd +1.17 at drift 0.3 ->
   +2.42 at 0.5; push_off +2.17 at smother 0.4; roll_out +4.08 at flurry 0.3 (near the top) -> lowered.
3. A first full gate run (stopped by the tool's 2-hour limit after 44 of 60 cells) showed: tie_up fell under the band
   (+1.17: the flurry graded it only half right) and step_out sat at +1.67 with landed dealt 9 times in 10 at long range
   only (no room left). Two changes: tie up also answers the flurry (boxing-true: under hooks on the ropes you roll out or
   tie up); landed is also dealt after a won exchange at MID range, fought at long range, at 1 in 4.
4. The gate above is the full re-run on the final rules, in three parts (4 + 3 + 3 steps, each under the 2-hour limit; the
   probe is deterministic and every part calibrates the same ratings).

## The third leg, rewritten BY SITUATION (docs/STEPPAY2_PHASE4.md "what is left" 3)
"Others 0..+1" could not pass for a step whose moment several styles share. The new leg, in
`tools/step_fire_fit_probe.gd legs=<gate outputs>,<fit outputs>` (no bout played, it reads the two runs):
- worth = the FOR cell / the FOR style's best fires a bout (what one fire in its moment is worth);
- every other style must read within 2.0 of worth x ITS best fires a bout, and never above the band's top (5).
So a step pays against a style as often as that style plays its situation - no more, no less. 9 of 10 pass it; step_back
fails on the Slugger (+5.17 > 5). The gate's own summary line (tools/treevalue_cells.gd, not a file of this task) still prints
the old leg and "pass=0/10".

worth of one best fire a bout: step_in +4.21, step_out +3.42, step_back +2.98, pivot_out +2.66, cut_off +1.81, herd +4.09,
feint +1.54, tie_up +0.99, roll_out +3.87, push_off +4.05.

## Controls
- Determinism: the same cell twice -> 219 wins, 718 fires both runs (each of the three parts). Without-arm planned fires of
  the swept steps: 0. OK grade forced on every swept step.
- Calibration (base plan, 120 bouts): Maria Ortega (Pressure fighter): shipped 61.5 -> calibrated 52.39, BASE wins 59/120; Jade Cooper (Slugger): shipped 57.0 -> calibrated 55.10, BASE wins 63/120; Holly Price (Out-boxer): shipped 59.0 -> calibrated 55.15, BASE wins 62/120; Priya Nair (Counter-puncher): shipped 63.5 -> calibrated 53.82, BASE wins 62/120; Erin Doyle (Volume puncher): shipped 65.5 -> calibrated 53.57, BASE wins 61/120; Dana Whitfield (Boxer-puncher): shipped 72.0 -> calibrated 51.98, BASE wins 64/120.
- `moments=off` in the fit probe and `StepMoment.on = false` in the tests = the control arm (no moment in the same bouts).

## Tests
New, red on main (run there in a throwaway worktree: 3-4 FAIL lines each - no row in the answer table, no rule), green here:
step_moment_short_test, step_moment_landed_test, step_moment_flurry_test, step_moment_smother_test, step_moment_drift_test
(shared checks in tests/step_moment_kit.gd: the row, the rule's yes / no cases, the control arm, the ride, and 30 played
bouts - dealt some rounds and not every round, on the step's card, graded best when the planned step came off).
Regression PASS on the final rules: golden_path_test, plan_fight_test, step_ride_test, place_edge_test, step_levers_test,
step_ropes_test, step_contract_test, step_effect_test, step_value_test, line_grade_test, grade_wire_test, fight_why_test,
line_swap_test, p4p_corner_eye_test, plan_bout_test, balance_harness_test, exchanges_test, debut_read_test, file_limits_test.

## Outside the brief's OWNS list (said, not hidden)
- `scripts/state/LiveRound.gd`: two lines changed, none added beyond one (the deal, the row, the record's `moment`); the
  fight cannot deal a situation without it. The file is at its own limit (470 lines), so the rule's preload sits in PlanFight.
- Existing rows of PlanFight.ANSWERS changed: roll_out added to "wrong" against a tiring / hurt opponent, push_off against a
  tiring one.
- `tools/run_tests.sh` was NOT edited: its list needs the five new tests before the 05:00 run can see them.

## Not done / seen
- The WRONG leg: five steps are not punished by the style that should punish them (table above). That is the next piece -
  the cost of a step in its wrong situation and the boxer holding it (StepWire.holds), not the moments.
- No screen names a moment. The plan board has no "when her jab falls short" line: a step fires in its moment from an
  any-time line (or a line planned for her game there). The coach's own plan (CoachPlan) and the offer's win read (BoutRead)
  do not know the moments; debut_read_test still passes (read and played within its band).
- StepValue.TARGET (the learn card's numbers) is unchanged; herd now pays more against the Out-boxer (+2.50) than against
  the Volume puncher it is listed FOR (+1.92), because the Out-boxer moves more.
- The game as a whole (tools/place_value_probe.gd's mix) was not re-run: drift gives your boxer the ropes more often, smother
  and landed take mid-range exchanges away. The gate's re-rating hides that shift; it should be read before the merge.
- Raw probe output is in the worktree's .probe_out/ (not committed): gate2_a/b/c.txt, fit_before.txt, fit_final*.txt, legs.txt.

Reproduce: `python ops/Tools/godot_slot.py run --who steppay3 -- <godot> --headless --audio-driver Dummy --fixed-fps 60
--path . --script res://tools/treevalue_probe.gd -- when=best only=<3-4 steps>` (three parts), then
`... --script res://tools/step_fire_fit_probe.gd -- n=120 when=best`, then `... -- legs=<the four files, comma separated>`.
