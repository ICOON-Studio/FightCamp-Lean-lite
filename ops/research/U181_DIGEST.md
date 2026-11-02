# U181 — skipping clip contact + cardio floor bind

## Gate (u180_station_ik on `jumping_rope_station.res`)

| Metric | Before | After | Gate |
|--------|--------|-------|------|
| Planted toe slip p95 (toe contacts, height + horizontal speed) | 0.205 m/s | **0.072 m/s** | ≤ 0.08 |
| Root velocity seam | ~0 m/s | **0 m/s** | ≤ 0.15 |
| Toe min Y | −0.028 m | **−0.004 m** | ≥ −0.005 |
| Flight phases / s | 2.34 | **2.34** | ≥ 1 |

**Bound:** `TrainingFloor3D` `STATION_CLIPS["cardio_floor"]` → `jumping_rope_station.res`. Test expects `jumping_rope_station` on `cardio_floor`.

## Method

- Skipping contacts: toe within 0.03 m of per-toe floor **and** horizontal speed &lt; 0.25 m/s (avoids height-only plants that glue hops).
- `FightLegIK` two-bone pin on `LeftToes` / `RightToes` with 3-frame target lerp at run edges; locked XZ per contact run.
- U180 hip-offset + seam blend retained; +18 mm late Hips Y lift + hip velocity re-match clears floor penetration without killing flight.

## Previews

Load-only `c212_mixamo_audition.gd` (`load_station render preview=…`) — no FBX retarget:

- `docs/previews/u181/jumping_rope_before.mp4`
- `docs/previews/u181/jumping_rope_after.mp4`

## Tests

Parse gate on touched `.gd`. `training_floor_3d_test.gd`: **0 failures** (direct Godot). `run_tests.py --only training_floor` fails in this worktree on missing `.godot` audio import (environment), not floor assertions.
