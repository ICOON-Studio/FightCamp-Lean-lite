# U133 — Arena art pass 5 (cursor)

## Gate (numeric, session-paired)

Metric: horizontal FFT band power in mat ROI `520×220 @ (380,260)` on `1280×720`, `seed=5150`, `discipline=mma`, `shot=standing`, `bare=1`, `frame=60`. **Lower achieved toward floor = less `fence_5` moire.**

Tool: `Godot/tools/measure_arena_moire_session.gd` — one windowed Godot run prints **baseline / achieved / floor** (floor = same frame with `hide_arena=fence_5`). Pass 4 PNG-only gate remains in `measure_arena_mat_banding.gd`.

| candidate | baseline | achieved | floor | ship? |
|-----------|----------|----------|-------|-------|
| coverage mips only (pass 4 on this GPU) | 740.01 | 740.01 | 636.70 | reference |
| + distance fade 7–15 m | 740.01 | 725.23 | 635.73 | no (small gain) |
| + distance fade 6–13 m | 740.01 | 568.15 | 561.65 | no (tune) |
| **+ distance fade 5–12 m** (`FENCE_DISTANCE_FADE`) | 740.01 | **559.32** | **562.64** | **yes** |

Shipped: **pixel-alpha distance fade** on fence panels atop coverage mips (`FENCE_FADE_MIN_M=5`, `FENCE_FADE_MAX_M=12`). Session gate: achieved ≈ floor (within ROI noise).

Also: `measure_arena_moire_session.gd` (live paired gate); `capture_arena_art_frame.gd` configures **before** `add_child` so `seed`/`discipline` are not locked out by `_ready`.

## Frame

`previews/arena_art/diag_pass5_achieved.png`

## Tests

- `check_scripts.py` ArenaRig + measure/capture tools: ok
- `run_tests.py --only arena`: total=4 fails=0
- `run_tests.py --only fight_camera`: total=2 fails=0

## Still wrong

- Arena is still flat-coloured primitives: no mat weave/logo, post padding material, or crowd-side darkness.
- Distance fade may read slightly soft on the back panel at some shots; re-check on operator recording, not only ROI FFT.

## Measure command

```text
Godot_v4.7.2-stable_win64.exe --path Godot --script tools/measure_arena_moire_session.gd \
  --rendering-method forward_plus --resolution 1280x720
```

Optional: `baseline=740.0077` to pin pass-4 achieved as the first column.
