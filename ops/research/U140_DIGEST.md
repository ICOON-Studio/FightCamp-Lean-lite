# U140 digest — hold decay shape (`cursor/u140-decay-shape`)

## What changed

`control_units_decayed` in `GroundGraph.gd` now implements the ladder the header
already described:

- Full value while `held_ticks < gate_ticks * DECAY_GATES` (unchanged grace).
- After grace, units above `CONTROL_FLOOR` slide down **one integer at a time**.
- **`span > 1`:** ceil-spread across `span * window` decay ticks (contract probe
  `flat=100` gets 99 steps).
- **`span == 1` (side/mount/back paying 2):** the single integer step is delayed
  until the end of that same `span * window` band so long holds stay at 2 through
  roughly a second full grace window instead of cliffing at tick 120.

`current` / `graph` arms still return `flat_units` unchanged. `DECAY_GATES` and
`CONTROL_FLOOR` untouched.

## Half guard (`flat_units == 1`)

With `CONTROL_FLOOR == 1`, integer control cannot fall below 1 without violating
the contract. Half-guard **payout** therefore still never decays. The chooser’s
`hold_value` term still calls `control_units_decayed(2, …, "decay")`, so mount/side
**hold** scoring in the graph *does* feel the new shape; half-guard ticks do not.

## S58 control arm (verbatim)

`MATCH, integer for integer: seat ticks, control units, exits, methods, side entries, the gate and the spells.`

## S58 before → after

| arm | units/100t before | after | Δ |
|-----|------------------:|------:|---|
| current | 8.01 | 8.01 | 0 (control) |
| decay | 5.85 | 6.66 | +0.81 payout only |
| graph | 7.54 | 7.54 | 0 |
| both | 5.60 | 6.36 | +0.76 payout + chooser |

Side-control `mean_held_s` (all arms): unchanged — 14.98 on `current`/`decay`,
14.11 on `graph`/`both`.

### Seat share (ground ticks)

| arm | guard | half | side | mount | back |
|-----|------:|-----:|-----:|------:|-----:|
| current/decay before & after | 27.34% | 6.45% | 28.23% | 37.86% | 0.11% |
| graph/both before | 29.36% | 8.81% | 30.15% | 29.21% | 2.47% |
| graph/both after | 29.36% | 8.81% | 30.15% | 29.21% | 2.47% |

Seat **ticks** unchanged on every arm (expected: decay arm does not run the
chooser).

### Chooser-only delta (graph arm, same seeds)

`side_hold` decisions 122 → 130 (+8); `side_to_mount` 80 → 72 (−8). Other edges
unchanged. **Payout vs chooser on `both`:** the +0.76 `units/100t` vs `graph` is
the sum of (a) higher per-tick decay payout on held seats and (b) slightly more
`side_hold` because `hold_value` stays at 1.0 longer before the delayed step;
seat-share table did not move, so the chooser effect is second-order inside the
same ground-time total.

## Representative integers (gate=60, `DECAY_GATES=2`)

| held | flat=2 (payout seats) | flat=1 (half payout) | hold_value `decayed(2)/2` |
|-----:|----------------------:|---------------------:|--------------------------:|
| 0 | 2 | 1 | 1.00 |
| 119 | 2 | 1 | 1.00 |
| 120 | 2 | 1 | 1.00 |
| 238 | 2 | 1 | 1.00 |
| 239 | 1 | 1 | 0.50 |

Old shape paid 1 from tick 120; new shape keeps 2 until tick 239 for 2-unit
seats and keeps `hold_value` at 1.0 over the same interval.

## Tests

- `check_scripts.py Godot/scripts/GroundGraph.gd` — pass
- `run_tests.py --only ground_graph` — `fails=0`
- `run_tests.py --only grapple` — `fails=0`
- `s58_ground_arms.gd` — `S58 total=1 fails=0`, control MATCH line above

## Coupling note (S57 trap)

One function still feeds both scored control (`decay`/`both` payout) and
`score_edge`’s `hold_value` (hardcoded `flat_units=2`, arm `"decay"` on every
graph arm). This stage could not split those without touching `FightRealtime` or
`score_edge`; delayed span==1 step softens both together.
