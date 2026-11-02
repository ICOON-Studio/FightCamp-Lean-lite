# Q43 Digest

**Task:** At what distance does a strike actually happen?
**Tool:** `Godot/tools/measure_exchange.gd` section 8 appended.
**Deliverable:** `research/Q43_THE_STRIKING_DISTANCE.md`

## Results

200 MMA bouts (seeds 220000–220199) + 200 boxing bouts (seeds 230000–230199).

| | MMA | Boxing |
|---|---|---|
| Scored strikes | 161,126 | 142,165 |
| Tick samples | 3,511,371 | 3,537,733 |
| T1 (POCKET\|MID) | 0.712 m | 0.695 m |
| T2 (MID\|LONG) | 0.929 m | 0.932 m |
| Floor (min) | 0.001 m | 0.000 m |
| Ticks > 1.1 m | 67.8% | 72.2% |

## Key findings

1. Strike distribution is continuous 0.0–1.1 m in both rulesets. No gaps.
2. Engine can produce 0.0 m separation (boxing hits it). No hard floor above zero.
3. Both rulesets peak at [1.05, 1.10) — ~11–12% of strikes.
4. Terciles nearly identical across rulesets (~0.70 m, ~0.93 m).
5. 68–72% of fight time is spent outside striking range.
6. Boxing has 5.6× more zero-range strikes than MMA (C85 effect).

## Recommendation

- MMA: POCKET|MID at 0.712 m, MID|LONG at 0.929 m.
- Boxing: POCKET|MID at 0.695 m, MID|LONG at 0.932 m.
- Shared cuts (if R101 wants one set): 0.70 m and 0.93 m.
