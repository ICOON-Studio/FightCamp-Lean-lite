# Q210 DIGEST - Separation Round 2

**Owner:** qwen  
**Date:** 2026-09-28  
**Branch:** `qwen/q210-nightly-reds`

## RNG Shift Hypothesis: REFUTED

Claude's review of 04bf1771 asked to prove or refute that Q208 back control shifted the shared RNG sequence in boxing. 

**Finding:** Q208 did NOT shift the boxing RNG sequence.

**Evidence:**
1. Q208 added 7 `rng.randf()` calls, all inside `_grapple_back_control()` and `_grapple_ground()`
2. Boxing has `ground_policy: none` - no grappling runs in boxing bouts
3. Q208 created `_rng_back_control` stream for all rulesets except judo (including boxing), but this is a SEPARATE stream (seed + offset), not a draw from the shared sequence
4. The stream is never used in boxing because `_grapple_back_control` never executes (ground_policy: none)

**Also checked:**
- Q206 fence pin: added 1 `rng.randf()` in `_grapple_clinch`, gated by `_has_cage()`. Boxing uses a ring, not a cage, so this doesn't run in boxing
- Q207 one down / one up: added `_rng_one_down` stream, but only for MMA (`if ruleset_id == "mma"`)

**Conclusion:** Neither Q206, Q207, nor Q208 added or removed RNG draws on paths that boxing executes. The RNG shift hypothesis is refuted.

## What Actually Changed Boxing Separation

**Finding:** Q183 footwork_economy default ON (commit 4f789137, 2026-09-26)

Q183 changed `footwork_economy` default from per-ruleset (MMA ON, boxing/kickboxing OFF) to ON for ALL rulesets:
```gdscript
var footwork_economy: bool = bool(options.get("footwork_economy", true))
```

This changed how boxing fighters move (burst/hold patterns, circling, retreating), which affects the gap between fighters and thus `longest_below_floor_ticks`.

The original formula `0.85 * scale / PUSH_CAP_MPS * hz + 2` was calibrated for simple back-and-forth movement. With footwork ON, fighters have more complex movement patterns that can keep them below the floor longer than the formula predicts.

## 8-Seed Population Test

Replaced single-seed gate with 8-seed population test (Claude's rule: never gate an extremum).

**Results:**
```
Boxing 8-SEED POPULATION (Realtime A reach=183 vs Realtime B reach=176):
  seed=94301 longest_below=10
  seed=12345 longest_below=4
  seed=67890 longest_below=11
  seed=54321 longest_below=17  <- MAX
  seed=99999 longest_below=13
  seed=11111 longest_below=3
  seed=22222 longest_below=2
  seed=33333 longest_below=11
8-SEED MAX: 17 (seed 54321), cap=9

MMA 8-SEED POPULATION:
  seed=94301 longest_below=8
  seed=12345 longest_below=2
  seed=67890 longest_below=14  <- MAX
  seed=54321 longest_below=6
  seed=99999 longest_below=1
  seed=11111 longest_below=4
  seed=22222 longest_below=0
  seed=33333 longest_below=1
8-SEED MAX: 14 (seed 67890), cap=9
```

**Analysis:** The formula cap (9) is 47-88% below the observed maximum (17 boxing, 14 MMA). The formula doesn't account for:
1. Fighter approach during recovery (both fighters moving toward each other at ~0.6 m/s each)
2. Footwork patterns (burst/hold, circling) that keep fighters in close proximity
3. Wall/rope clamping effects

The theoretical ramp is `0.85 m / 2.5 m/s = 0.34 s = 6.8 ticks`, plus 2-tick buffer = 8.8 ticks (rounds to 9). But the effective recovery rate is not 2.5 m/s (push cap) but ~1.3 m/s (push cap minus fighter approach), giving `0.85 m / 1.3 m/s = 0.65 s = 13 ticks`. The observed 17 ticks suggests additional edge cases.

## Recommendation

The separation test is PARKED pending a formula recalibration that accounts for fighter approach dynamics and footwork patterns. The current formula is a theoretical lower bound, not a practical gate.

**Options:**
1. Adjust coefficient from 0.85 to ~1.60 to account for fighter approach (cap becomes 19, passes 8-seed test)
2. Extend Q202 wall-aware push to boxing (currently MMA-only) to improve gap recovery
3. Park the test until the separation logic is reviewed holistically

## Files Changed

- `Godot/tests/fight_separation_test.gd` - 8-seed population test
- `Godot/tools/q210_boxing_rng_probe.gd` - RNG probe (diagnostic, not used in final analysis)

## Gates

- Parse: `check_scripts.py` on fight_separation_test.gd - PASS
- fight_separation_test: FAIL (expected - formula cap too low)
