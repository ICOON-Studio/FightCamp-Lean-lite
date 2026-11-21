# STEPPAY2 phase 3 (S533) - THE STEP SPENDS LESS WHEN IT IS RIGHT

Scope: ops/research/STEPS_PAYOFF_SCOPE_S533.md phase 3. Built on phase 2 (docs/STEPPAY2_PHASE2.md, the place pays).

## What was built
A planned step in its BEST situation costs no exchange: the exchange is fought, there and then, on the card the step leads
to (`StepWire.ride`, two lines in `LiveRound.exchange` after the step's own fire roll).
- "Best" is the fight's own grading of the step against her game that exchange (`PlanFight.fit` = "best" - the table every
  plan line is graded by). StepEffect's own best lists disagree with it in places (cut off the ring when YOUR boxer is tired),
  so they are not used.
- The step stays the exchange's line: its answer to her game, its levers, its ropes count and the plan's tally are as before.
- The place pays NOW (phase 2): cut off the ring in its moment and this exchange is on her ropes (+5.0, her range game gone);
  pivot out from a presser and this exchange is in the middle, not on your ropes (-5.0 avoided).
- If the plan has a punch line on that card and it comes off (its own fire roll), its plan points are added: the step and the
  punch in one exchange (`LineGrade.edge` adds `pick["ride_edge"]`).
- A card with no punch to throw (the clinch: tie up), a wrong or half-right situation, a step thrown on instinct: the step
  costs the exchange where she stands, as before. `StepWire.ride_on = false` is the control arm.
- On the record: `rec["rode"]`, `rec["rode_from"]`, `rec["rode_punch"]`. No screen shows it yet (see "Not done").

## Two findings on the way (both measured, tools/step_fire_fit_probe.gd, 120 bouts a cell)
1. **The gate's plan never let cut_off fire when it is best.** TREEVALUE plans the swept step "any time"; the plan's own
   "when she boxes at range" punches take the long card first. Against the Out-boxer cut_off fired in a best situation 15% of
   the time, and 4.1 exchanges a bout that were its best moment went to another line. Fixed in the instrument, not the game:
   `when=best` also plans the swept step WHEN each situation it is best in (the without-arm still has none of its lines).
   Steps no other line was taking from are unchanged by it.
2. **Two ride designs were tried and dropped, each on a measurement.** (a) Ride only onto a PLANNED punch that fits the
   moment: it rode 0-9% of fires (the plan rarely has that punch). (b) Swap the exchange's line for the punch: the step
   dropped out of the plan's right answers (reads, pressure) - pivot_out against the Pressure fighter read +0.0. The built
   design keeps the step as the line.

fires a bout / in a best situation / best moments taken by another line (default plan, before `when=best`), by style
(Pressure, Slugger, Out-boxer, Counter, Volume, Boxer-puncher):

| step | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher |
|---|---|---|---|---|---|---|
| cut_off | 0.65 / 13% / 0.34 | 0.78 / 12% / 0.41 | 1.13 / 15% / 4.12 | 0.82 / 33% / 1.58 | 0.87 / 23% / 2.32 | 0.97 / 22% / 2.63 |
| step_back | 2.02 / 90% / 1.08 | 1.93 / 87% / 2.39 | 1.30 / 42% / 0.52 | 0.70 / 65% / 0.40 | 2.25 / 74% / 0.45 | 1.52 / 57% / 1.14 |
| pivot_out | 3.02 / 55% / 0.00 | 3.48 / 42% / 0.00 | 0.95 / 21% / 0.00 | 1.00 / 29% / 0.00 | 2.55 / 54% / 0.00 | 1.82 / 28% / 0.00 |
| step_in | 0.45 / 7% / 0.00 | 0.47 / 7% / 0.00 | 1.01 / 34% / 0.00 | 1.72 / 33% / 0.00 | 0.40 / 21% / 0.00 | 0.84 / 23% / 0.00 |
| step_out | 1.16 / 39% / 0.00 | 1.37 / 34% / 0.00 | 1.61 / 46% / 0.00 | 1.22 / 48% / 0.00 | 1.41 / 39% / 0.00 | 1.45 / 45% / 0.00 |
| herd | 0.14 / 18% / 0.00 | 0.14 / 24% / 0.00 | 0.15 / 28% / 0.00 | 0.15 / 28% / 0.00 | 0.17 / 10% / 0.00 | 0.19 / 26% / 0.00 |
| feint | 1.21 / 54% / 0.00 | 1.10 / 43% / 0.00 | 1.96 / 57% / 0.00 | 5.17 / 69% / 0.00 | 0.80 / 49% / 0.00 | 1.64 / 49% / 0.00 |
| tie_up | 2.38 / 90% / 0.01 | 1.33 / 92% / 0.01 | 1.74 / 91% / 0.00 | 1.50 / 87% / 0.01 | 1.63 / 92% / 0.01 | 1.58 / 93% / 0.02 |
| roll_out | 2.35 / 9% / 0.00 | 1.33 / 15% / 0.00 | 1.80 / 8% / 0.00 | 1.52 / 9% / 0.00 | 1.65 / 9% / 0.00 | 1.65 / 10% / 0.00 |
| push_off | 0.85 / 0% / 0.00 | 0.36 / 0% / 0.00 | 0.45 / 0% / 0.00 | 0.47 / 0% / 0.00 | 0.49 / 0% / 0.00 | 0.53 / 0% / 0.00 |

## The measurement - tools/treevalue_probe.gd when=best, 400 bouts x 3 seed sets a cell, with the step's lines minus without
Win difference in 100. Control arm = the same run with `ride=off` (phase 2's game: the place pays, every step costs its exchange).

| step | arm | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher |
|---|---|---|---|---|---|---|---|
| cut_off (FOR Out-boxer, target +3.5) | ride off | -1.42 | -0.42 | +4.33 | +2.50 | +2.17 | +2.42 |
| cut_off | **ride on** | -1.00 | +0.25 | +6.75 | +3.33 | +3.58 | +2.67 |
| pivot_out (FOR Pressure, target +2.5) | ride off | +0.92 | +1.58 | -0.33 | +0.08 | +1.33 | +0.58 |
| pivot_out | **ride on** | +3.83 | +4.58 | +0.08 | +0.75 | +3.08 | +1.92 |
| step_back (FOR Pressure, target +3.5) | ride off | +6.58 | +6.58 | -0.75 | +0.50 | +3.08 | +2.17 |
| step_back | **ride on** | +8.75 | +8.17 | -0.67 | +0.42 | +6.00 | +1.67 |

fires a bout / share of fires that rode (ride on): cut_off 1.09 / 41% | 1.22 / 39% | 3.34 / 85% | 1.84 / 69% | 2.22 / 74% | 2.42 / 78%; pivot_out 2.69 / 50% | 3.25 / 45% | 0.95 / 23% | 0.99 / 27% | 2.25 / 50% | 1.87 / 34%; step_back 2.48 / 92% | 2.99 / 93% | 1.62 / 52% | 0.96 / 70% | 2.54 / 74% | 2.24 / 73%.

READ
- **cut_off FOR the Out-boxer: -0.75 (start of the scope) -> +4.33 with the place paying and the step planned in its moment
  (ride off) -> +6.75 with the ride.** The scope's leg (+1.5..+5) is met by phase 2 once the instrument lets the step fire
  when it is best; the ride takes it past the top of the band.
- **pivot_out FOR the Pressure fighter: +0.92 -> +3.83.** The ride is what makes it pay: getting off the ropes this exchange.
- **step_back FOR the Pressure fighter: +6.58 -> +8.75.** It was over the band before the ride and is further over.
- The wrong legs hold or nearly (cut_off vs Pressure -1.0, step_back vs Out-boxer -0.7; pivot_out vs Out-boxer +0.1).
- "Other styles 0..+1" fails widely: a step that pays in its best situation pays against every style that plays that
  situation sometimes. That is phase 4's table to judge, not a size to guess here.
Nothing is sized in this phase. The overshoot (cut_off, step_back) goes to phase 4 with these numbers.

## Controls
Determinism: the same cell twice -> the same wins and fires, each run. The without-arm fired the swept step 0 times. OK grade
forced on every swept step. `ride=off` = the control arm above (rides 0%). place_value_probe with the ride on: see phase 4's page.

## Tests
`step_ride_test` (new): PASS, 15 checks with the control arm. Regression PASS: place_edge_test, step_levers_test,
step_ropes_test, step_contract_test, step_effect_test, line_grade_test, grade_wire_test, plan_bout_test, plan_fight_test,
p4p_corner_eye_test, balance_harness_test, golden_path_test. file_limits_test fails on scripts/fight3d/v2/Player2.gd (501
lines) - another session's file; LiveRound.gd is at its limit minus two.

## Not done / seen
- No screen says a step rode ("Cut off the ring - on the ropes with it"). The record carries it; the result page and the
  corner's eye are the P4PBUILD1 session's files.
- The offer's win read (BoutRead) knows neither the place nor the ride: debut_read_test is red by one line since phase 2
  (read 0.618 against a played 0.553). Brought back in line at the end of phase 4, on the final rules.
