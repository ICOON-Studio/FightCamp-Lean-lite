# Q66 — Kickboxing Leg Share Fix: Measured Failure

**Agent:** qwen  
**Date:** 2026-09-12  
**Task:** Bring kickboxing leg share from 4.4% to 14–18% (ceiling: 12%)

## R129's Instruction Was a No-Op

R129 said to "promote the low kick, the teep and the shin check into tier 1–2".  
**All three already are:**
- `kickboxing_teep`: tier 1 (line 286)
- `kickboxing_low_kick`: tier 2 (line 292)
- `kickboxing_kick_check`: tier 2 (line 301)

Promoting them changes nothing. Verified.

## What I Tried

### Attempt 1: Promote 2 kicks (high_kick, switch_kick) to tier 2
- Kickboxing leg: 4.41% → 5.40% (+1.0pp)
- **Problem:** Boxing head moved +3.43pp (exceeds 2pp limit)

### Attempt 2: Promote 4 kicks (high, switch, hook, axe) to tier 2
- Kickboxing leg: 4.41% → 4.38% (-0.03pp)
- All constraints met
- **Result:** No improvement

### Attempt 3: Promote 4 kicks + demote 2 body punches (jab_body, cross_body)
- Kickboxing leg: 4.41% → 4.43% (+0.02pp)
- **Problem:** Boxing head moved +2.43pp (exceeds 2pp limit)

### Attempt 4: Promote 4 kicks + demote 6 boxing tier 2 nodes
- Kickboxing leg: 4.41% → 4.24% (-0.17pp)
- **Problem:** Boxing head moved +5.37pp (way exceeds 2pp limit)

## Final Result (Attempt 2 — only viable option)

**Changes made:**
- `kickboxing_high_kick`: tier 3 → 2 (high roundhouse is a basic technique)
- `kickboxing_switch_kick`: tier 3 → 2 (switch kick is taught early)
- `kickboxing_hook_kick`: tier 3 → 2 (hook kick is fundamental)
- `kickboxing_axe_kick`: tier 3 → 2 (axe kick is basic)

**Before/after table (all four rulesets):**

| Metric | LIVE | SHADOW (before) | SHADOW (after) | Move | J20 Anchor |
|--------|------|-----------------|----------------|------|------------|
| **BOXING** |
| head % | 69.52 | 66.44 | 66.44 | 0.00 | 61-65% |
| body % | 30.48 | 33.56 | 33.56 | 0.00 | 19-23% |
| leg % | 0.00 | 0.00 | 0.00 | 0.00 | 14-18% |
| **KICKBOXING** |
| head % | 55.71 | 63.63 | 64.76 | +1.13 | 61-65% |
| body % | 30.04 | 31.96 | 30.86 | -1.10 | 19-23% |
| leg % | 14.25 | 4.41 | **4.38** | -0.03 | 14-18% |
| **MUAY_THAI** |
| head % | 47.23 | 51.70 | 51.70 | 0.00 | 61-65% |
| body % | 51.87 | 40.10 | 40.10 | 0.00 | 19-23% |
| leg % | 0.90 | 8.20 | 8.20 | 0.00 | 14-18% |
| **MMA** |
| head % | 52.99 | 54.49 | 55.32 | +0.83 | 61-65% |
| body % | 38.06 | 39.32 | 39.66 | +0.34 | 19-23% |
| leg % | 8.96 | 6.20 | 5.02 | -1.18 | 14-18% |

**Constraints check:**
- ✅ Kickboxing head: 64.76% (within 58-68%)
- ✅ Boxing: all moves 0pp (within 2pp limit)
- ✅ Muay thai: all moves 0pp (within 2pp limit)
- ✅ MMA: all moves <2pp (within 2pp limit)
- ❌ **Kickboxing leg: 4.38% (ceiling was 12%, target was 14-18%)**

## What I Could Not Reach and Why

**Could not reach 12% kickboxing leg share.** Best achieved: 4.38%.

**Why:** The simulation has a fundamental bias against kicks that cannot be fixed by tier manipulation alone. Promoting kicks to tier 1-2 adds them to the palette but does not increase their selection frequency proportionally. The fight engine's technique selection logic weights kicks much lower than punches per palette entry, likely due to:
- Kicks being slower (higher recovery cost)
- Kicks having longer range requirements
- Kicks being less accurate in the simulation

**Evidence:**
- Baseline: 7 kicks in tier 1-2 palette (17.5% of 40 nodes) → 4.41% landing rate
- After promoting 4 more kicks: 11 kicks in tier 1-2 palette (24.4% of 45 nodes) → 4.38% landing rate
- The landing rate did not increase despite 40% more kicks in the palette

**Demoting boxing punches to reduce the denominator also failed** because:
1. It barely moved the leg share (ratio stayed constant)
2. It broke boxing's own numbers (head/body % moved >2pp)

## Conclusion

The tier numbers are not the lever that moves kickboxing's leg share. The fix requires changes to the fight engine's technique selection logic or the effects/weights on kick techniques, not the tier assignments. This is outside the scope of Q66's authorization (tier numbers only).

**Deliverable:** 4 kickboxing kicks promoted to tier 2 on sport-reasonable grounds (all are basic techniques taught early). All constraints met except the leg share ceiling, which could not be reached.
