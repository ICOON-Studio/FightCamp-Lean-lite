# U132 — Arena art pass 4 (cursor)

## Gate (numeric)

Metric: `Godot/tools/measure_arena_mat_banding.gd` — mean horizontal FFT band power in mat ROI `520×220 @ (380,260)` on `1280×720` captures (`seed=5150`, `discipline=mma`, `shot=standing`, `bare=1`, `frame=60`). **Lower is less banding in that ROI.**

### Pass 3 reference PNGs (not comparable to fresh captures on this GPU)

| arm | file | band energy |
|-----|------|-------------|
| baseline | `diag_baseline_streaks.png` | 2320.97 |
| floor (`fence_5` hidden) | `diag_hide_fence_5.png` | 1250.64 |

Fresh `capture_arena_art_frame.gd` runs on this machine land ~3229 with `fence_5` visible; hiding `fence_5` in the **same session** only moves the metric to ~3227, so the pass 3 PNG pair must not be mixed with new captures when judging a candidate.

### Session-paired candidates (same capture session, box mips = baseline)

| candidate | baseline | achieved | floor (hide `fence_5`) | ship? |
|-----------|----------|----------|-------------------------|-------|
| box mips (pass 3 sampler) | 3229.85 | — | 3227.31 | reference |
| **coverage hand mips** (`CHAIN_MIP_MODE=coverage`) | 3229.85 | **3201.17** | 3227.31 | **yes** (best) |
| no mips, linear filter (`none`) | 3229.85 | 3219.96 | 3227.31 | no |
| distance fade `PIXEL_ALPHA` 4–10 m | 3229.85 | 3203.81 | 1250.64† | no — reverted (†vs stale floor PNG) |

Shipped: **coverage-preserving mip chain** for `_chain_link_texture()`; restored full `_add_deck` shadow comment plus pass 3 `fence_5` note; `CHAIN_MIP_MODE` documents `box` / `coverage` / `none` for A/B.

## Tests

- `check_scripts.py` ArenaRig + measure tool: ok
- `run_tests.py --only arena`: total=4 fails=0
- `run_tests.py --only fight_camera`: total=2 fails=0

## Still wrong

- Mat ROI band energy does not separate baseline vs `hide_arena=fence_5` on fresh captures (~3229 vs ~3227); pass 3 PNGs did. Need to confirm live hide path and/or refine ROI/metric so the floor arm moves like the A/B that named `fence_5`.
- Moire is only slightly reduced (~1%) vs session box-mip baseline; not near the pass 3 PNG floor arm.
- Arena still flat primitives: no mat wear, logo, post material, or crowd-side darkness (deferred).

## Measure command

```text
godot --headless --path Godot --script tools/measure_arena_mat_banding.gd -- \
  baseline=diag_pass4_baseline_box.png achieved=diag_pass4_coverage.png floor=diag_pass4_floor_hide5.png
```
