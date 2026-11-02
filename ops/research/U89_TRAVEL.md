## SEND-BACK 6

Merge `605f3b2`. Part A BASELINE (`travel=off gap=legacy`) R3 **0.172** ±0 (master `087a3c9`). Watchable-gap contract implemented in WIP (uncommitted): `is_gap_free`, stepped `_step_gap_watchable`, `WALK_MPS`/`GAP_DEADBAND_M` sweep. **No variant beat BASELINE** — best 0.50/0.08 at R3 **0.224**. STOP per task; implementation not committed.

### Sweep table (PRODUCTION unless noted)

| run | R3 mean | R3 p95 | gap_not_walking fr | gap_not_walking m | mean \|gap err\| | R6 body m/s | R2b/R3b/R4 |
|-----|---------|--------|--------------------|-------------------|------------------|-------------|------------|
| BASELINE | 0.172 | 0.941 | 20823 | 76.1 | 0.040 | 0.019 | PASS/PASS/PASS |
| 0.35/0.04 | 0.244 | 1.511 | 469 | 3.0 | 0.210 | 0.088 | PASS/PASS/PASS |
| 0.35/0.08 | 0.230 | 1.452 | 0 | 0.0 | 0.245 | 0.085 | PASS/PASS/PASS |
| 0.50/0.04 | 0.235 | 1.439 | 460 | 2.9 | 0.168 | 0.090 | PASS/PASS/PASS |
| 0.50/0.08 | 0.224 | 1.398 | 227 | 1.5 | 0.204 | 0.086 | PASS/PASS/PASS |

**Reading:** gap_not_walking collapsed (227 vs 20823; gate wants ≤10% = 2082). Skate moved to `gap_walking` / `loc_advance` (0.46–0.61 m/s ×8–13k frames). Idle unmoved ~0.06–0.07 m/s. travel 37/0, walk 13/13 on WIP.

## TRACE 3 (from send-back 5, unchanged)

| reason | role | PROD frames | PROD mean | travel=off frames |
|--------|------|-------------|-----------|-------------------|
| below_min_rate | idle | 3202 | 0.614 | 4749 |
| busy_take | react_body | 1721 | 0.629 | 2548 |
| busy_take | react_head | 659 | 0.438 | 4115 |

| speed bucket | frames | mean skate |
|--------------|--------|------------|
| 0.15–0.30 m/s | 4637 | 0.607 |
| ≥0.30 m/s | 2046 | 0.655 |
