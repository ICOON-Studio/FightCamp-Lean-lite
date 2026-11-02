# U112 — paired 3D joint streams from broadcast footage

## METHOD

`track_pairs.py` gives per-person `world` landmarks in metres (hip-centred) and `img` landmarks in pixels.
Each pose is anatomically correct but the two men are not in one frame — fighter A's hips are always at
the origin of A's `world`, and likewise for B.

`pair_world.py` (PAIR_WORLD v1) places them in one space:

1. **Identity** — same hip-midpoint matching as `pair_events.py`: left-most man is fighter 0 (attacker
   convention), continuity by smaller total hip move, segment break on >1.0 T jump or dual >0.6 T cut.
2. **Horizontal placement** — fighter 0 at the origin; fighter 1's hip offset along x is
   `(hip1_x - hip0_x) * mean(torso_world / torso_px)` using each man's shoulder–hip length in metres vs pixels.
   No invented focal length — scale is each fighter's own real size against his image size.
3. **Depth (z)** — difference in MediaPipe image-landmark z at the hips, times mean hip width in metres
   from `world` (image z is in hip-width units).
4. **Floor** — shared ground plane: subtract the lower visible ankle y so floor is y = 0.

**Camera assumption:** side-on broadcast with slow pan. Holds for single-angle sparring (`-vPZqptk8jo`,
`HL261oRyURE`, `FCM7m6TJWUQ`, `wzUWvsviqTM` in standing segments). Breaks on hard cuts (UFC pilot,
`HFSZxKUUE98`) and when the angle swings past ~45° (`kuABaA2PY0U`, `XIja1S9SXI4` three-quarter passages)
— horizontal pixel gap then underestimates true separation.

## ERROR

Measured on `-vPZqptk8jo` (10 s, 501 two-fighter frames):

| axis | p50 err vs raw scale | p90 bound | note |
|---|---:|---:|---|
| horizontal (x) | 0.00 m (by construction) | **±0.15 m** | scale std ~7%; side-on only |
| depth (z) | — | **±0.35 m** | monocular; img z near zero on many frames |
| vertical (y) | floor-aligned | **±0.08 m** | ankle visibility |

**Usable for:** standing exchanges, footwork, punches and kicks at range where hip separation > 0.8 m.
**Not usable for:** ground grappling (hips near floor — height-in-T proxy fails), clinch with heavy
occlusion, or any shot where ankles are invisible (pushes depth error past ±0.5 m).

Inter-fighter distance must vary (cv > 0.8% on clean clip); constant distance means degenerate output.

## INVENTORY

Recomputed from `track/*.npz` on 2026-09-21 (98,136 two-person frames ≈ 38.1 min at ~42.9 effective fps).

| video | frames | 2-person | seconds | mean vis |
|---|---:|---:|---:|---:|
| `-vPZqptk8jo` | 6,139 | 5,933 | 118.7 | **0.898** |
| `HL261oRyURE` | 5,738 | 5,292 | 105.8 | **0.882** |
| `FCM7m6TJWUQ` | 6,056 | 2,525 | 50.5 | **0.877** |
| `XIja1S9SXI4` | 8,024 | 5,859 | 195.5 | 0.873 |
| `kuABaA2PY0U` | 5,505 | 3,095 | 103.3 | 0.815 |
| `wzUWvsviqTM` | 33,651 | 14,092 | 470.2 | 0.807 |
| `_Fc7QLzbQlQ` | 9,946 | 6,094 | 243.8 | 0.792 |
| `vOFmsN3JROs` | 6,277 | 3,998 | 66.7 | 0.742 |
| `xaXXD-w45b0` | 49,449 | 26,372 | 440.9 | 0.730 |
| `d_PSlBJheZI` | 33,699 | 19,879 | 331.6 | 0.711 |
| `yg_N42n_Jdk` | 7,312 | 3,889 | 129.8 | 0.666 |
| `isLkzN3d7rA` | 2,448 | 125 | 2.1 | 0.732 |
| `7pIskYcLKVw` | 508 | 152 | 5.2 | 0.722 |
| `2m1Ftv_l_Xc` | 635 | 117 | 4.7 | 0.717 |
| `cyXGrr7YTeg` | 3,121 | 237 | 9.5 | 0.642 |
| `HFSZxKUUE98` | 14,031 | 185 | 3.1 | 0.551 |
| `LfpNJ5fIYA4` | 565 | 292 | 4.9 | 0.480 |

Start with the three cleanest (bold): 4.5 min combined, visibility 0.877–0.898.

## STANDING VS GROUND

Standing: vis ≥ 0.75, both ankles visible on ≥ 50% of sampled two-person frames, hip-height-in-T p50 ≥ 1.2,
ground pose fraction < 25%. Ground: ≥ 25% of samples with hip-height-in-T < 1.2 (hips near ankles).

| video | standing | ground | note |
|---|---|---|---|
| `-vPZqptk8jo` | **yes** | no | clean side-on sparring |
| `HL261oRyURE` | **yes** | marginal | mostly standing; some clinch |
| `FCM7m6TJWUQ` | **yes** | no | short two-person coverage |
| `wzUWvsviqTM` | **yes** | no | long, good feet |
| `XIja1S9SXI4` | marginal | yes | three-quarter + ground spells |
| `kuABaA2PY0U` | marginal | yes | angle changes |
| `_Fc7QLzbQlQ` | no | yes | MMA, ground-heavy |
| `vOFmsN3JROs` | marginal | yes | clinch |
| `xaXXD-w45b0` | marginal | yes | long; mixed |
| `d_PSlBJheZI` | marginal | yes | long; mixed |
| `yg_N42n_Jdk` | no | yes | ground-heavy |
| `isLkzN3d7rA` | no | yes | tiny sample |
| `7pIskYcLKVw` | no | yes | tiny sample |
| `2m1Ftv_l_Xc` | marginal | yes | tiny sample |
| `cyXGrr7YTeg` | no | no | unusable vis |
| `HFSZxKUUE98` | no | no | slow-mo, cuts |
| `LfpNJ5fIYA4` | no | no | vis 0.48 |

**Retarget standing work from:** `-vPZqptk8jo`, `HL261oRyURE`, `FCM7m6TJWUQ`, `wzUWvsviqTM`.
**Do not retarget ground from any file yet** — depth error exceeds ±0.5 m when hips are below knee height.
