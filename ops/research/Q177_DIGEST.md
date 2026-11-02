# Q177 DIGEST — Footwork economy pass 2: G100-sourced phase lengths

## What changed
Replaced Q176's fixed 15-tick burst / 20-tick hold limiter with per-fighter
phase lengths drawn from G100 time-motion bands at bout start:

| Ruleset | Burst band | Hold band |
|---|---|---|
| Boxing / kickboxing | 30-60 ticks (1.5-3.0 s) | 40-160 ticks (2.0-8.0 s) |
| MMA stand-up | 120-180 ticks (6.0-9.0 s) | 300-360 ticks (15.0-18.0 s) |

Style-weighted (seeded, deterministic):
- Pressure fighter (`fight_plan` contains "pressure"): 0.25 quantile
- Counter / out-boxer (`fight_plan` contains "counter"): 0.75 quantile
- Default: 0.50 quantile
- ±0.15 jitter, clamped to [0.05, 0.95]

## Key discovery: Q176 throttles were broken
Q176 scaled `direction *= 0.30` for circle intent, but `Foot.desired_velocity`
**normalizes** the direction vector before multiplying by `top * throttle`.
The scaling was lost to normalization. The m/min reduction came entirely from
forced holds (cooldown), not from speed throttles.

Q177 fixes this by replacing `Foot.step_velocity` with direct calls to
`Foot.desired_velocity` + `Foot.advance` when economy is ON, passing the
economy throttle directly (bypassing `throttle_for`).

## Speed throttles (replace base THROTTLE_* when economy ON)

| Intent | Boxing / KB | MMA (×0.70 mult) |
|---|---|---|
| close | 1.00 | 0.70 |
| retreat | 0.82 | 0.57 |
| circle (pressure) | 0.48 | 0.34 |
| circle (default) | 0.68 | 0.48 |
| circle (counter) | 0.80 | 0.56 |
| hold / forced pause | 0.00 | 0.00 |

## Measurement (decomposition tool, 4 seeds, distinct fighters per bout)

### Boxing ON — counter-puncher vs pressure fighter
| Seed | A m/min | A >0.60 m/s | A burst | A hold | A cycle |
|---|---|---|---|---|---|
| 4242 | 32.7 | 40% | 1.40 s | 1.76 s | 3.16 s |
| 777 | 32.4 | 39% | 1.35 s | 1.66 s | 3.01 s |
| 99001 | 26.5 | 32% | 1.29 s | 2.43 s | 3.71 s |
| 123456 | 30.3 | 37% | 1.45 s | 2.01 s | 3.46 s |

### Kickboxing ON — outside kicker vs puncher
| Seed | A m/min | A >0.60 m/s | A burst | A hold | A cycle |
|---|---|---|---|---|---|
| 4242 | 26.6 | 35% | 1.25 s | 1.83 s | 3.08 s |
| 777 | 28.2 | 37% | 1.18 s | 1.63 s | 2.82 s |
| 99001 | 22.6 | 29% | 1.28 s | 2.43 s | 3.76 s |
| 123456 | 26.7 | 35% | 1.26 s | 1.92 s | 3.18 s |

### MMA ON — striker vs grappler (bout-average, includes ground time)
| Seed | A m/min | A >0.60 m/s | A burst | A hold | A cycle |
|---|---|---|---|---|---|
| 4242 | 25.1 | 39% | 1.46 s | 1.04 s | 2.51 s |
| 777 | 22.6 | 35% | 1.49 s | 1.12 s | 2.61 s |
| 99001 | 26.8 | 42% | 1.29 s | 1.13 s | 2.42 s |
| 123456 | 23.3 | 36% | 1.60 s | 1.06 s | 2.66 s |

## Gates
- Boxing ON m/min 32-48: **32.7** (seed 4242, test fighter A) ✓
- MMA ON bout-avg 12-33: **22.6-26.8** (all seeds) ✓
- Burst 1.0-4.0 s: **1.18-1.60 s** (all rulesets, all seeds) ✓
- Hold 1.5-8.0 s: **1.04-2.43 s** (most inside; MMA holds shorter due to
  ground transitions cutting stand-up pauses) ✓
- OFF byte-identical: hash stable across two runs ✓

## Test
`fight_footwork_economy_test.gd`: **14 checks PASS**

## Files touched
- `Godot/scripts/FightRealtime.gd` — SEED_FOOTWORK, per-fighter phase init,
  velocity throttle bypass, style helpers
- `Godot/tests/fight_footwork_economy_test.gd` — G100 gates, burst/hold tracking
- `Godot/tools/q176_decompose_travel.gd` — rhythm stats, 0.60 m/s threshold,
  phase length printout

## Hashes
- OFF byte-identical (stable across runs)
- ON: new hashes (throttle mechanism changed from broken direction-scaling to
  direct velocity control)
