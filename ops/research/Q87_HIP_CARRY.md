## DECISIONS

All heights are above each body's own rest floor (Hips y minus the rest lowest foot y).

| variant | floor_min (m) | float mean (m) | float p95 (m) | KD01 end hips (m) | KD02 end hips (m) |
|---------|--------------|----------------|---------------|-------------------|-------------------|
| none | -0.0708 | 0.0868 | 0.1877 | 0.9127 | 0.9127 |
| unscaled | -0.3460 | 0.0064 | 0.0344 | 0.0959 | 0.0941 |
| hip_ratio | -0.0263 | 0.0110 | 0.0314 | 0.1422 | 0.1404 |
| leg_ratio | -0.0257 | 0.0111 | 0.0317 | 0.1431 | 0.1414 |

**Chosen:** hip_ratio — floor_min -0.026 m, knockdown end hips 0.142 / 0.140 m above the floor.

- none: standing feet float up to 19 cm above the floor.
- unscaled: floor_min -0.346 m, knockdown end 0.095 m.
- leg_ratio: floor_min -0.026 m, knockdown end 0.142 m.
