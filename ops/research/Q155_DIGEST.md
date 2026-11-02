# Q155 digest — U147 persist-trigger push is inert, removed

## Question
U147 added a persist-trigger branch to the overlap separation step: after >3 cm
overlap persists for >0.05 s, the hip-gap push speeds up from 2.5 m/s (cap 5 cm/frame)
to 5.0 m/s (cap 7 cm/frame). Its own digest printed identical before/after summary
numbers. Is the branch inert?

## Method
Throwaway script (`C:\Users\user\AppData\Local\Temp\q155_record_positions.gd`, not in
repo) records per-frame A and B root positions over one boxing round and one MMA round,
seed 94301, overlap_sep_ease on. Run on the UNCHANGED tree, then remove the U147
persist-trigger branch (4 constants, 1 var, 1 reset line, the depth-accumulator
if/else in `_sample_refused_overlap_render`, and the persist branch in
`_refuse_overlap_sep_step_m`), then run again.

## Side-by-side

| Metric | Boxing BEFORE | Boxing AFTER | MMA BEFORE | MMA AFTER |
|---|---|---|---|---|
| frames | 10796 | 10796 | 10847 | 10847 |
| overlap_max (m) | 0.318344 | 0.318344 | 0.275912 | 0.275912 |
| A sum distance (m) | 150.965555 | 150.965555 | 149.126471 | 149.126471 |
| B sum distance (m) | 163.030045 | 163.030045 | 157.548636 | 157.548636 |
| A max frame step (m) | 0.098405 | 0.098405 | 0.501298 | 0.501298 |
| B max frame step (m) | 0.097622 | 0.097622 | 0.501298 | 0.501298 |
| beats | 57 | 57 | 53 | 53 |
| A first pos | (-0.945131,2.14,0.342671) | (-0.945131,2.14,0.342671) | (-0.944192,1.0,0.342329) | (-0.944192,1.0,0.342329) |
| A last pos | (-1.396394,2.14,0.863531) | (-1.396394,2.14,0.863531) | (0.704367,1.02,0.841474) | (0.704367,1.02,0.841474) |
| B first pos | (0.943906,2.18,-0.345063) | (0.943906,2.18,-0.345063) | (0.944845,1.04,-0.345405) | (0.944845,1.04,-0.345405) |
| B last pos | (-0.619574,2.18,0.421676) | (-0.619574,2.18,0.421676) | (-0.030859,1.02,-0.044814) | (-0.030859,1.02,-0.044814) |

**Byte-identical.** Every metric matches to 6 decimal places.

## Why it was inert
The rendered-gap rate limiter (`RENDERED_GAP_MAX_STEP_M = 0.07`) downstream clamps
the visible gap change to 7 cm/frame regardless of the separation step. The U147
branch raised the internal step from 5 cm to 7 cm, but the limiter already allowed
7 cm — so the internal convergence was marginally faster but the rendered output
was clamped to the same trajectory.

## Action
Removed U147 persist-trigger code from `FightWorldLiveScreen.gd`:
- 4 constants: `OVERLAP_BUDGET_DEPTH_M`, `OVERLAP_BUDGET_PERSIST_S`,
  `OVERLAP_SEP_MAX_STEP_BUDGET_M`, `OVERLAP_SEP_MPS_BUDGET`
- 1 var: `_overlap_deep_s`
- 1 reset line in `_setup`
- Depth-accumulator if/else in `_sample_refused_overlap_render`
- Persist branch in `_refuse_overlap_sep_step_m` (now a single return)

U146 easing untouched.

## Gates
- Parse gate: `check_scripts.py FightWorldLiveScreen.gd` — 1/0
- `run_tests.py --only room` — 4/0
- `run_tests.py --only world` — 6/0
- `run_tests.py --only grapple` — 11/0

## Files touched
- `Godot/scripts/FightWorldLiveScreen.gd` (U147 lines removed)
- `research/Q155_DIGEST.md` (this file)
