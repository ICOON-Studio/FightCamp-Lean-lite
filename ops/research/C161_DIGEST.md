# C161 — THE OCTAGON STANDS ON A SQUARE

Owner: codex. Completed 2026-09-29.

## What was already in the tree

`Godot/scripts/ArenaRig.gd:_add_deck` already builds an N-gon prism for `sides >= 3`
(using `CylinderMesh.radial_segments = sides`, circumradius = apothem / cos(π/n),
rotated by π/sides) and keeps the circle (`sides == 0`) and square ring (`sides == 4`)
paths intact. This geometry fix landed in commit `e3ffa7a4` (U155) before this pass.

This pass delivered the **contract test and the verification** that the fix is
regression-proof.

## Gate results

- Parse gate: `CHECK total=2 fails=0` (`ArenaRig.gd`, `arena_deck_shape_test.gd`).
- Focused suite: `python Godot/tools/run_tests.py --only arena` → `SUITE total=4 fails=0`.

## Mutant table

| mutant | result | note |
|---|---|---|
| control | GREEN | `ARENA_DECK_SHAPE_TEST PASS checks=20` |
| remove π/sides rotation | RED | 8 alignment failures |
| `radial_segments = sides + 1` | RED | 11 failures (mesh/alignment/radius) |
| apothem as radius | RED | 9 failures (canvas sticks past fence) |
| BoxMesh for `sides >= 3` | RED | 6 failures (mesh type / null cast now fails gracefully) |

`total=4 red=4 missed=0`.

The test was hardened so the BoxMesh mutant fails by assertion rather than by a
null-deref hang: the cage-canvas cast is guarded before `radial_segments`, the
radius check, and the alignment routine are entered.

## Render

One standing frame captured from seed 5150, MMA, bare pair:
`previews/c161/standing_5150.png`. The octagonal canvas now sits under
an octagonal fence; no mat sticks past the panels and there are no square-apron
gaps at the corners.

## What is still wrong

This is a geometry-only pass. The room around the cage is still the placeholder
grey void and chain-link fence from earlier arena work (ARENA_ART owns the venue
art). The fighters, lighting, and crowd-side dressing are unchanged.
