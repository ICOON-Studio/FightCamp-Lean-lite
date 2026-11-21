# STEPPAY2 phase 2 (S533) - THE PLACE PAYS

Scope: ops/research/STEPS_PAYOFF_SCOPE_S533.md phase 2 (owner Q-S294-285 "Yes, build it"). Built on main after STEPPAY1.

## What was built
One new pure rule, `scripts/rules/PlaceEdge.gd`, read in ONE place of the exchange odds (`RingDuel.step` adds it to the duel
edge; `RingDuel.settle` keeps it apart on the record as `rec["place_edge"]`, so "the duel that decided it" still reads the duel).
- The opponent on the ropes: **+5.0** points on the exchange for your boxer. In the corner: **+6.5**.
- Your boxer on her own ropes: **-5.0** (the mirror: the opponent has her there).
- A trapped opponent has no range game: her "range" game gets weight 0 when the next game is picked (`RingDuel.step_bias` ->
  `Exchanges.next_mode`); if she was boxing at range when she got trapped she covers up and counters instead; nobody can ask
  for long range with her back on the ropes (your boxer's "Jab and move" does not move the fight off her own ropes).
- LiveRound.gd and PlanFight.gd were not touched. `PlaceEdge.on = false` is the control arm (the game before the rule).

## The size, and where it comes from
5.0 is the size of an OK corner call (`Exchanges.EDGE` ok = 5.0; a best call is 17). STEPPAY1 measured that a place moved an
exchange by -3.0..+3.2 against the game's own mix, with a 95% noise band of about +-2.8 on 1,200 exchanges - so a place had to
move the exchange by clearly more than 2.8 to be an edge at all, and stay well under a best call to be bounded. One point on
the exchange is worth about 1.1-1.3 points of exchange win share here (measured below), so 5.0 lands the ropes about two noise
bands out; the corner is 30% more.

## Gate 1 - tools/place_value_probe.gd (400 exchanges x 3 seed sets x 6 styles a cell, same population as STEPPAY1)
**RESULT: tools/place_value_probe.gd -> PLACE_VALUE done control=ok determinism=ok** (rule on, and rule off).

Exchange win share for your boxer by the place the exchange starts at:

| place | rule OFF, mean of 6 | Pressure | Slugger | Out-boxer | Counter | Volume | Boxer-puncher | rule ON, mean of 6 | vs CONTROL (on) | on minus off | opponent in her range game % (6 styles) |
|---|---|---|---|---|---|---|---|---|---|---|---|
| outside | 45.9 | 45.1 | 45.6 | 46.1 | 46.8 | 44.8 | 46.3 | 45.8 | +1.1 | -0.1 | 6 / 8 / 35 / 20 / 26 / 27 |
| long | 48.6 | 48.1 | 48.3 | 49.0 | 49.3 | 47.4 | 49.3 | 48.6 | +3.9 | -0.1 | 6 / 7 / 35 / 20 / 26 / 27 |
| mid | 46.8 | 48.4 | 50.0 | 43.4 | 46.1 | 45.9 | 47.0 | 46.8 | +2.1 | +0.0 | 6 / 7 / 36 / 21 / 26 / 27 |
| inside | 45.0 | 44.1 | 46.3 | 45.1 | 45.6 | 43.3 | 45.3 | 45.0 | +0.3 | -0.0 | 6 / 7 / 35 / 21 / 25 / 27 |
| clinch | 44.2 | 42.4 | 44.2 | 44.8 | 45.3 | 42.8 | 45.3 | 44.1 | -0.5 | -0.1 | 6 / 7 / 35 / 20 / 26 / 26 |
| own_ropes | 44.6 | 37.0 | 38.8 | 37.2 | 39.7 | 37.0 | 38.5 | 38.0 | -6.6 | -6.5 | 6 / 8 / 36 / 20 / 27 / 27 |
| opp_ropes | 44.6 | 50.2 | 48.8 | 49.8 | 50.5 | 50.0 | 50.4 | 50.0 | +5.3 | +5.4 | 0 / 0 / 0 / 0 / 0 / 0 |
| corner | 44.4 | 51.9 | 50.8 | 51.4 | 53.0 | 51.3 | 52.3 | 51.8 | +7.1 | +7.4 | 0 / 0 / 0 / 0 / 0 / 0 |
| CONTROL | 46.2 | 43.0 | 45.1 | 45.3 | 47.1 | 42.1 | 45.4 | 44.7 | +0.0 | -1.6 | 6 / 7 / 35 / 20 / 26 / 28 |

- **opp_ropes is 5.3 above CONTROL, the corner 7.1 above, own_ropes 6.6 below** (bounded: every place edge is
  under half of one best corner call). Before the rule all three were 1.7-1.8 BELOW the control and equal to each other.
- The trapped opponent's range game: 6-36% of exchanges before, **0% on opp_ropes and in the corner** now, in every style.
- The other five places did not move (within 0.2 of rule off).
- **Control arm, rule off (`-- place=off`): reproduces STEPPAY1's table** - CONTROL 46.2, opp_ropes 44.6, own_ropes 44.6, corner
  44.4, every style's cell the same to 0.1; the probe's own driver equals the game's "sim" on 0 of 400 exchanges differing, in
  both arms; a broken arm is read as broken (126 / 222 of 400 differ); the same seed twice gives the same cell.

## What it does to the game as a whole (said plainly)
The game's own mix of places (CONTROL) went from 46.2 to 44.7: your boxer is on her own ropes far more often than the
opponent is on hers (losing an exchange to a pressing or loading opponent walks her there; the opponent only gets there by a
cut-off, a herd or being hurt). So against opponents who press, the fight is a little harder unless the plan turns her off the
ropes. Measured on exchanges_test's even fight (tools/place_edge_exch_probe.gd, 2,000 bouts each): saying nothing wins 26.65%
with the rule off and **25.15%** with it on; wrong calls 11.45% -> 10.90%. Wrong calls still lose in the same proportion (0.43
of saying nothing, both arms); the test's absolute bar moved with the baseline (0.15 -> 0.135, the measurement in its comment).

## Gate 2 - tools/treevalue_probe.gd only=cut_off (400 bouts x 3 seed sets a cell, with its line minus without)
| cut_off vs | Pressure | Slugger | Out-boxer (FOR) | Counter | Volume | Boxer-puncher |
|---|---|---|---|---|---|---|
| before (S533 TREEVALUE11 base) | -1.67 | -1.50 | -0.75 | -0.17 | -2.25 | -1.08 |
| phase 2, the place pays | -1.8 | -0.8 | **-0.2** | +0.7 | -0.7 | -0.5 |
| target | negative | 0..+1 | +1.5..+5 | 0..+1 | 0..+1 | 0..+1 |

**The Out-boxer leg is NOT reached (-0.2, wanted +1.5..+5).** The step now loses less against five of six styles (about +0.5
to +1.5) and still costs against the Pressure fighter, as it should. It fires about once a bout, so one exchange a bout at
+5.0 cannot lift a bout's result by 1.5; getting there from the place alone would need an edge near 20 (more than a best
call) - not bounded, so it is not done. What is left is the exchange the step spends, which is phase 3.
(The per-cell lines of this run were lost with the console; the summary line above is from Godot's own log. Phase 3 re-runs
the same cells with full lines.)

## Tests
`place_edge_test` (new, red on main before the rule): PASS (22 checks, with the control arm). Regression: plan_bout_test,
plan_fight_test, step_ropes_test, step_contract_test, ropes_contract_test, step_effect_test, step_levers_test,
guard_state_test, fight_flow_test, clinch_rest_test, balance_harness_test, golden_path_test PASS. exchanges_test: 13 of its
14 checks PASS as they were; "wrong calls lose clearly more" read 0.1425 against the old bar 0.15 and is re-based to 0.135
(the measurement above; the test is re-run whole with phase 3).

## Not done here / seen
- The prediction page (BoutRead / RingDuel.mean_edges) does not read the place yet: it walks the duel in expectation and has
  no card. The live bout and the simulated bout both read it (same code path).
- No words on screen yet say "on the ropes: -5". `rec["place_edge"]` is on every exchange record for the result page / corner
  eye (files owned by the P4PBUILD1 session).
