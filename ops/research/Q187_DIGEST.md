# Q187_DIGEST — blind contract test for DrillMastery + FloorEvents

**Agent:** qwen **Model:** qwen3-coder, medium **Branch:** qwen/q187-drill-mastery-contract

## Result

**84 checks, 0 failures. All 3 mutants caught. Module matches the contract on every row.**

## Rows (DrillMastery)

| Row | Input | Contract expects | Result |
|-----|-------|-----------------|--------|
| pips | 5.999 / 6 / 15.99 / 16 / 139.99 / 140 / 500 | 0 / 1 / 1 / 2 / 4 / 5 / 5 | PASS |
| progress_to_next | 0 / 11 / 140 | 0.0 / 0.5 / 1.0 | PASS |
| hours_to_next | 0 / 11 / 140 | 6.0 / 5.0 / 0.0 | PASS |
| station_kind | strength / cardio / bags / ring | sc / sc / skill / skill | PASS |
| combo_family | (bags,[grappling]) / (bags,[]) / (ring,[]) / (strength,[]) | grappling / striking / striking / "" | PASS |
| gain_multiplier skill | 0 / 6 / 36 / 140 | 1.0 / 1.015 / 1.037 / 1.050 | PASS |
| gain_multiplier sc | 0 / 6 / 36 / 140 | 1.0 / 1.010 / 1.024 / 1.033 | PASS |
| level_factor | 30 / 50 / 60 / 70 / 80 / 95 | 1.8 / 1.4 / 1.0 / 0.825 / 0.65 / 0.65 | PASS |
| hours_for | (10,50) / (-1,50) | 7.1429 / 0.0 | PASS |
| bond_multiplier | 0 / 20 / 40 / 60 / 80 / 100 | 0.5 / 0.75 / 1.0 / 1.0 / 1.25 / 1.5 | PASS |
| breakthrough_chance | pip0 / pip2 / pip3 / pip5 / fat51 / rap100 | .06 / .06 / .02 / 0 / 0 / .09 | PASS |
| breakthrough_hours | roll 0 / .5 / 1 / 2(clamped) | 1.5 / 1.95 / 2.4 / 2.4 | PASS |

## Rows (FloorEvents)

| Row | Input | Contract expects | Result |
|-----|-------|-----------------|--------|
| roll_event cooldown | day=3, last=0 | {} (3 < 4) | PASS |
| roll_event day 4 | day=4, last=0 | fires (4 NOT < 4) | PASS |
| roll_event open | open_event non-empty | {} | PASS |
| roll_event no bags | bags=[] | {} | PASS |
| roll_event rate under | 2 bags, roll=0.033 < 2/60 | fires | PASS |
| roll_event rate at | 2 bags, roll=2/60 | {} (>= threshold) | PASS |
| roll_event pick | 3 bags, pick=0.99 | station_id=bag_2 | PASS |
| resolve close | choice=close | ok,cost40,cond+10,days1,!snap | PASS |
| resolve tape snap | choice=tape, roll=0.10 | cost0,cond-35,snapped | PASS |
| resolve tape wear | choice=tape, roll=0.50 | cond-3,!snapped | PASS |
| resolve unknown choice | choice=repair | ok=false | PASS |
| resolve unknown event | id=sparring | ok=false | PASS |

## Mutants (applied to scratch reference, not module)

1. **Pip thresholds +1h** [7,17,37,73,141]: pips(6)=0 ≠ 1 → **CAUGHT**
2. **Breakthrough 0.06 at pip III** (<=3 not <=2): bc(36,30,50)=0.06 ≠ 0.02 → **CAUGHT**
3. **Cooldown <= not <**: day4-last0 blocked → **CAUGHT**

## Disagreement

None. Module matches the contract on all 84 rows.

## Owned files

- `Godot/tests/drill_mastery_contract_test.gd` (new)
- `research/Q187_DIGEST.md` (this file)
