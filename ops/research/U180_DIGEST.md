# U180 — speed bag and skipping station clips

## Speed bag (passes gate; bound)

- **Anchor:** fixed bag centre `(0, 1.72, 0.38)` m — `TrainingFloor3D` `wall_board` greybox (board 1.9 m, bag sphere 1.72 m / z=0.05 in prop space, fighter standoff 0.75 m). C212 `place_prop` now uses this anchor instead of fitting the cylinder to the hands.
- **IK:** `tools/u180_station_ik.gd` bakes `FightLegIK` two-bone hand solves on strike frames into `speedbag_station.res`.
- **Gaps (C212 fixed-prop measure):** strike peak |gap| p95 **0.151 m → 0.00058 m**; no positive signed gap at strike peaks (was fists past the bag toward +Z).
- **Bound:** `TrainingFloor3D` `STATION_CLIPS["speed_bag"]` → `speedbag_station.res`. Test expects `speedbag_station` when a fighter is on `speed_bag`.

## Jumping rope (seam only; not bound)

- **IK pass:** hip root-offset bake (C209-style) + loop seam blend + hip velocity match at wrap.
- **Gaps:** root velocity seam **0.836 → 0.0 m/s**; planted-foot slip p95 **0.246 → 0.253 m/s** (gate ≤ 0.08 not met).
- **Bound:** `cardio_floor` stays **idle** (no `STATION_CLIPS` entry).

## Previews

`docs/previews/u180/speedbag_before.mp4` and `jumping_rope_before.mp4` copied from pre-U180 C212 MP4s. Re-render after MP4s once a load-only audition path exists (full `c212_mixamo_audition.gd` re-retargets from FBX and overwrites `.res`).

## Tests

Parse gate on touched `.gd`. `training_floor_3d_test.gd`: **0 failures** (direct Godot run). `run_tests.py --only training_floor` failed in this worktree on missing `.godot` audio import (environment), not on floor assertions.
