# Q13 DIGEST — RingSpace.gd

## What landed

- `Godot/scripts/RingSpace.gd` — all-static module, zero preloads, six functions:
  `distance`, `clamp_to_floor`, `step`, `place_of`, `is_cornered`, `pressure`.
- `Godot/tests/ring_space_test.gd` — 37 checks covering every function, every
  degenerate case (half_width ≤ 0), boundary inclusivity, and the three-word
  contract (CENTRE/ROPES/CORNER).

## Decisions

- `place_of` duplicates the three strings by contract (no preload of RingPlace).
- `step` with zero direction or non-positive metres returns `clamp_to_floor(pos)`
  — the "(clamped)" ruling in the task — so a fighter already off the floor
  gets pulled back even when not moving.
- `pressure` uses `abs(axis) / half_width`, larger of the two axes, clamped 0..1.

## Gate

Parse 2/0, own test PASS, suite total=194 fails=0.
