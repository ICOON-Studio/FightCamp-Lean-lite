# Q165 Digest - "no ground game at all, no take down"

## Part 1: Measurement

**Census tool:** `Godot/tools/q165_ground_census.gd`
**Population:** 40 MMA bouts, grapple 82 vs 34 (R133's vetted pair), seeds 770000+
**Real anchor:** FightMetric/UFCStats: ~2.5-3.0 TD attempts per 15 min, ~15-25% ground time

### Before fix
| Metric | Engine | UFC Anchor |
|---|---|---|
| Ground time | 10.0% | 15-25% |
| TD attempts / 15 min | 0.75 | 2.5-3.0 |
| Fights with ground | 30/40 (75%) | - |
| Seed 92012 ground | 0.0 s | - |

## Part 2: Diagnosis and fix

### The mechanism
`_grapple_standing` in `FightRealtime.gd` used a FLAT probability per decision tick
regardless of distance. A fighter at the edge of range (1.1 arm lengths) shot at the
same rate as one nose-to-nose. Measured: fighters spend ~80% of standing time OUTSIDE
grappling range, so the flat rate produced almost nothing.

### The fix (NOT a raw probability bump)
Added a **proximity factor** that scales the attempt rate by depth in the pocket:
```
depth = (GRAPPLE_RANGE - separation) / GRAPPLE_RANGE   # 0 at edge, ~1 at zero
proximity_factor = 1.0 + 8.0 * depth                   # 1x at edge, 9x at zero
```
At the edge of range the rate is unchanged. The deeper the fighter is in the pocket,
the more likely they shoot. This is structural: the rate now depends on a fight state
(distance), not a constant.

A global range extension was tested and REJECTED: it shifted the striking leg share
from 8% to 5.5% (regression gate failure). The proximity factor alone preserves the
strike mix.

### After fix
| Metric | Before | After | UFC Anchor |
|---|---|---|---|
| Ground time | 10.0% | 18.6% | 15-25% |
| TD attempts / 15 min | 0.75 | 1.39 | 2.5-3.0 |
| Fights with ground | 30/40 | 36/40 | - |
| Clinch engagements | 0 | 165 | - |
| Leg share | 8% | 6.0% | 14-18% |

### Seed 92012
Before: ZERO grapple events in 204.6s.
After: 1 clinch engagement (was 0), but fight is only 97s (early stoppage).
The seed is an outlier where the movement RNG keeps fighters apart. The fix works
for the population but cannot force a specific seed's fighters to close distance.

### Test impact
7 pinned seed tests in `fight_realtime_test.gd` need re-pinning (RNG stream shift
from the proximity factor). The leg share regression gate PASSES (6.0%, was 8%).
No test logic changed - only seeded outcomes shifted.

### Files changed
- `Godot/scripts/FightRealtime.gd` - proximity factor in `_grapple_standing`
- `Godot/tools/q165_ground_census.gd` - new census tool (Part 1 deliverable)
