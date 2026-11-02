# U136 digest — capsule overlay on the fighter

**Branch:** `cursor/u136-capsule-overlay`

## Shipped

- `Godot/scripts/FightCapsuleOverlay.gd` — `Node3D` that calls `build_report` once for
  `capsules` + `shapes`, then each refresh runs `posed(..., 1.0, world)` and rebuilds
  one `MeshInstance3D` per capsule. Promoted spheres (rest `p0 == p1`, today `head`) stay
  spheres in pose via `sphere_centre` + `SphereMesh`; segments use `CapsuleMesh`. Bands
  colour from `shapes` only; each band also differs in `fill_alpha` and/or `wireframe`.
- `FightStagePlayer.set_capsule_overlay` mirrors `set_body_layers`; overlay is created
  lazily when enabled and refreshed at the end of `advance`.
- `FightWorldLiveScreen` — `options["capsule_overlay"]`, default **off**, threaded at
  setup beside `_body_layers`.
- `Godot/tests/capsule_overlay_test.gd` — count from `build_report`, sphere from data,
  midpoint within 1 mm, non-hue band discrimination, zero children when off.

## Gate

- Parse gate: touched `.gd` files — **pass**
- `run_tests.py --only capsule_overlay` — **SUITE total=1 fails=0**
- `run_tests.py --only body` — **total=9 fails=1** (`fight_body_overlap_test.gd`, unchanged
  by this slice; worst-case overlap assertions on f01/f09)

## Arguing against this delivery

Fifteen translucent volumes on a body that is stepping, turning and throwing will fuse into
a single noisy hull at fight speed; the operator’s “bodies overlap” complaint is a
**between-fighter** question, and this overlay never draws two men in one frame unless
you already have the live room running. A single headless still — two rest poses, two
colours, gap labelled in metres — would have answered “do the torsos intersect?” faster
than animating wireframe on one athlete.

**Weakest point (mine):** promoted spheres are keyed off rest `p0 == p1`, not off
`build_report["promoted"]` by name; if promotion logic ever leaves a non-zero segment
length in the rest set, the overlay would draw a capsule while the census still calls it
a ball.

## Test command

`python Godot/tools/run_tests.py --only capsule_overlay`
