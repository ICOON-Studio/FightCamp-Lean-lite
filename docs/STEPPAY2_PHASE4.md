# STEPPAY2 phase 4 (S533) - THE GATE, all ten steps, and what the sizing measurements say

Scope: ops/research/STEPS_PAYOFF_SCOPE_S533.md phase 4. The game measured is phases 2 + 3 (docs/STEPPAY2_PHASE2.md,
docs/STEPPAY2_PHASE3.md): the place pays, and a step in its best situation costs no exchange.

## The gate table - tools/treevalue_probe.gd when=best, 400 bouts x 3 seed sets a cell
Wins in 100, the plan with the step's lines minus the same plan without them. In brackets: fires a bout / share of fires that
cost no exchange. Bold = the style the step is FOR. Step at Sharp, OK grade; opponents re-rated so the base plan wins about half.

| step | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher | best leg (1.5..5) | wrong leg (< 0) | others 0..+1 |
|---|---|---|---|---|---|---|---|---|---|
| step_in | +0.58 (0.47/8%) | +0.17 (0.41/6%) | **+0.83** (1.03/40%) | +1.00 (1.79/31%) | +0.17 (0.40/22%) | +0.67 (0.73/26%) | Out-boxer +0.83 (t+3.0): under | Pressure +0.58 NOT negative | yes |
| step_out | +1.00 (1.45/33%) | **+1.08** (1.46/27%) | +2.75 (1.58/44%) | +1.17 (1.35/45%) | +1.50 (1.68/35%) | +2.25 (1.52/41%) | Slugger +1.08 (t+2.5): under | Out-boxer +2.75 NOT negative | no |
| step_back | **+8.75** (2.48/92%) | +8.17 (2.99/93%) | -0.67 (1.62/52%) | +0.42 (0.96/70%) | +6.00 (2.54/74%) | +1.67 (2.24/73%) | Pressure +8.75 (t+3.5): OVER | Out-boxer -0.67 ok | no |
| pivot_out | **+3.83** (2.69/50%) | +4.58 (3.25/45%) | +0.08 (0.95/23%) | +0.75 (0.99/27%) | +3.08 (2.25/50%) | +1.92 (1.87/34%) | Pressure +3.83 (t+2.5): in the band | Out-boxer +0.08 NOT negative | no |
| cut_off | -1.00 (1.09/41%) | +0.25 (1.22/39%) | **+6.75** (3.34/85%) | +3.33 (1.84/69%) | +3.58 (2.22/74%) | +2.67 (2.42/78%) | Out-boxer +6.75 (t+3.5): OVER | Pressure -1.00 ok | no |
| herd | -0.08 (0.15/16%) | -0.25 (0.12/18%) | -0.33 (0.19/24%) | -0.25 (0.20/30%) | **+0.17** (0.22/22%) | -0.33 (0.21/24%) | Volume +0.17 (t+2.0): under | Pressure -0.08 ok | no |
| feint | +0.50 (1.17/52%) | +0.42 (0.94/47%) | +1.08 (1.93/61%) | **+4.17** (4.99/70%) | +0.58 (0.76/50%) | +0.92 (1.58/54%) | Counter +4.17 (t+4.0): in the band | none | no |
| tie_up | +3.17 (2.29/0%) | **+2.00** (1.24/0%) | +2.25 (1.69/0%) | +1.17 (1.43/0%) | +2.00 (1.57/0%) | +2.75 (1.55/0%) | Slugger +2.00 (t+3.0): in the band | none | no |
| roll_out | +1.58 (2.36/8%) | **+0.75** (1.22/14%) | +0.17 (1.76/8%) | +0.58 (1.50/9%) | +0.17 (1.61/8%) | -0.33 (1.59/10%) | Slugger +0.75 (t+3.0): under | none | no |
| push_off | **+0.00** (0.82/0%) | +0.00 (0.41/0%) | -0.08 (0.51/0%) | +0.08 (0.45/0%) | +0.00 (0.46/0%) | +0.00 (0.48/0%) | Pressure +0.00 (t+1.5): under | none | no |

**Three legs together: 0 of 10 pass.** By leg: the FOR style is in the band for 3 (pivot_out, feint, tie_up), OVER it for 2
(step_back, cut_off), under it for 5 (step_in, step_out, herd, roll_out, push_off). At the scope's start (TREEVALUE9) the FOR leg was in the band for 2
(feint, tie_up) and cut_off, the step the scope was written about, read -0.7.

What moved, FOR style, TREEVALUE9 -> now: cut_off -0.7 -> 6.75; pivot_out +1.8 -> 3.83; step_back +5.2 -> 8.75;
feint +3.7 -> 4.17; tie_up +1.8 -> 2.00; step_out +0.8 -> 1.08; step_in +0.6 -> 0.83; roll_out +0.8 -> 0.75;
herd -0.3 -> 0.17; push_off +0.0 -> 0.00.

"Others 0..+1" fails for nine: a step that pays in its best situation pays against every style that plays that situation
some of the time (cut_off against the Counter-puncher and the Boxer-puncher, who also box at range). That leg was written for
a step with one style; the fight grades by the situation, not the style.

## Sizing: three measurements, and no number changed
The brief: size a StepEffect TABLE number only with its measurement. Each lever was measured first; none of them is the
lever, so nothing is sized.

| measurement (same cells) | cut_off FOR Out-boxer | step_back FOR Pressure | pivot_out FOR Pressure |
|---|---|---|---|
| ride off (every step costs its exchange) | +4.33 | +6.58 | +0.92 |
| **the game (ride on)** | **6.75** | **8.75** | **3.83** |
| ride on, no punch-line points on it (`ride=0.0`) | +6.25 | +8.83 | - |
| ride on, the step's whole StepEffect row halved (`scale=0.5`) | - | +7.83 | - |

- The punch line's points riding with the step are worth 0.5 at most: not the overshoot. `ride_keep` stays 1.0.
- step_back's own row (deny 0.35, open 0.1, tank 0.3, its ropes count) halved takes 0.92 off 8.75: with the row at zero it
  would still read about 6.9. It was over the band before this scope (+5.2). Its size is its ANSWER: PlanFight grades it "best"
  against pressing and loading, 9 plan points, 2.5 times a bout at 92% in its moment. No TABLE number brings it into the band.
- cut_off is in the band with the place paying and the step costing its exchange (+4.33) and 1.75 over with the ride. The
  ride is the same rule that takes pivot_out from +0.92 to 3.83; it is kept for every step (one rule).

DECISION (developer): no StepEffect.TABLE number is changed. The five steps under the band are under because they rarely get
their moment, which no row size fixes (tools/step_fire_fit_probe.gd, docs/STEPPAY2_PHASE3.md): herd fires 0.15-0.2 a bout;
push_off is never "best" in the fight's grading (0%); roll_out is best 9% of its fires; step_in fires 0.4-1.0 a bout at
7-34% best; step_out is best 34-48% but its best situations are your boxer's own trouble.

## What is left, in order (not built here)
1. The answer table gives five steps no moment (herd, push_off, roll_out, step_in, step_out). That is PlanFight.ANSWERS and
   where the fight puts the cards - a design piece, measured first with step_fire_fit_probe.
2. step_back and cut_off pay more than +5 for a plan that uses them in every best moment. If +5 is a hard cap, the lever is
   the answer's points for a step (9, the same as a punch line), not StepEffect.
3. The gate's "others 0..+1" leg should be re-written by situation (it cannot pass for a step whose moment several styles share).

## The game as a whole
- place_value_probe with phases 2 + 3: controls ok, determinism ok. opp_ropes 50.0 (+4.1 against the game's own mix), corner
  51.8 (+6.0), own_ropes 39.6 (-6.2). The game's own mix is 45.9 (46.2 before the scope, 44.7 after phase 2
  alone): a plan with a pivot-out line gets her off the ropes at once, so most of phase 2's cost to the player is given back.
- exchanges_test PASS (all 14 checks, the bar re-based in phase 2; run with phases 2 + 3, before the win-read change below,
  which touches no played bout).

## The win read follows the new rules (asked by the main session: debut_read_test went red with phase 2)
BoutRead walks the duel in expectation and had no card, so the shown chance drifted above the played bouts (0.618 shown, 0.553
played). Now `RingDuel.mean_edges(..., place_read = true)` adds what the ropes cost on an average exchange:
`PlaceEdge.read` = -5.0 x her pressing + loading share x the share of exchanges lost x 0.60 (0.45 with a pivot-out line planned).
The two factors are measured (tools/place_read_probe.gd, 150 bouts x 6 styles x 2 plans): the played mean was 0.49-0.74 of the
plain forecast without a pivot line, 0.36-0.58 with one.
Read against played, Lucy's pro debut, 1,200 nights a gap: 0.593 / 0.573, 0.686 / 0.673, 0.762 / 0.762 (all within 0.02).
debut_read_test PASS; its sample went 300 -> 1,200 nights (300 is +-0.029 a cell against a 0.05 band: one cell drew 0.540).

## Tests (this phase)
PASS: place_edge_test (25 checks), step_ride_test, debut_read_test, exchanges_test, step_levers_test, step_ropes_test,
step_contract_test, step_effect_test, line_grade_test, plan_bout_test, plan_fight_test, balance_harness_test, golden_path_test.

## Not done / seen
- No screen names the ropes edge or a step that cost no exchange. The exchange record carries both (`place_edge`, `rode`,
  `rode_from`, `rode_punch`); the result page and the corner's eye belong to the P4PBUILD1 session.
- StepEffect's own "best" lists disagree with the fight's grading (cut off when YOUR boxer is tired). They are read by nothing
  in the fight; the learn card should not quote them.
- file_limits_test is red on scripts/fight3d/v2/Player2.gd (501 lines), not a file of this task.
- StyleName.plan_mult's dead mid_edge / counter_edge read (STEPPAY1 "seen, not fixed") was not touched: that file was not edited.
