# U141 digest — ground chooser wiring contract (blind)

**Branch:** `cursor/u141-wiring-contract`  
**Deliverable:** `Godot/tests/ground_arm_wiring_test.gd` only.

## Population

MMA `measure_ruleset_sweep.style_fighter` index 0 vs 1 (wrestle-grappler grapple 82 vs striker grapple 34). Stats printed in test output; mismatch guard fails if blocks are equal.

## Witness

Scan `990000..990199` on `ground_arm: "graph"`; first seed with `ground_decisions >= 10` is **990000**. Non-vacuity (floor seat + chooser count) runs before all other properties.

## Readings taken

1. **Default / fallback:** omitting `ground_arm` must match `"current"` on verdict, `control_units`, and full log; unknown string resolves `state["ground_arm"]` to `"current"` and matches `current` outcomes.
2. **Roll uniformity:** aggregate `ground_rolls` across the same scan cohort; require ≥80 rolls; each band within **3×** of the mean (defends against a broken roll stream dominating weights).
3. **RNG budget:** compare standing log prefix (events before first ground `grapple/seat`) between `current` and `graph` on the witness seed. **Would miss:** divergence after the first ground seat, or differences only in grapple events before that seat marker.

## Gate

```
python Godot/tools/check_scripts.py Godot/tests/ground_arm_wiring_test.gd
python Godot/tools/run_tests.py --only ground_arm_wiring
```

`SUITE total=1 fails=0` (post single-pass scan refactor).

## Mutant exercise (assertions inverted; engine untouched)

| Property | Mutant | Result |
|----------|--------|--------|
| Non-vacuity | `decisions >= MIN+99999` in scan | RED (no witness) |
| Default = current | verdict `!=` | RED |
| Determinism | second run `witness_seed+1` | RED |
| Arms differ | require graph edges == 0 | RED |
| Roll uniform | tolerance ratio 1.02 | RED |
| Skill term | `skill_live > 999999` | RED |
| RNG budget | prefix `!=` | RED |

No property left green under mutation. **Hole:** RNG check is prefix-only (see above).

## Findings vs engine

None on `origin/master` at witness seed; test is green. Any future red run is a wiring finding, not a test defect.
