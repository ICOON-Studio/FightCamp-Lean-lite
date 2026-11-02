# U188 digest — below the baseline (S94)

Instrument: `tools/u185_planted_slide.gd` at **c0b8ba95** (unchanged).

## Slide (seed 94301, both men)

| Mode | p50 | **p95** |
|------|-----|---------|
| BASELINE (planner off) | 0.0000 | **0.5731** |
| MUTANT (drag-root) | 0.0043 | **0.7686** |
| AFTER (U188) | 0.0016 | **1.1787** |

Merge gate: AFTER p95 **below 0.573** — **miss** (target 0.287). U188 improves U187 repro on this worktree (~1.45 → **1.18**) via kneel-guard no-bailout + post-room toe repin; still worse than planner-off baseline.

## Root cause (spikes > 0.3 m/s, `tools/u188_slide_spike.gd`)

**85** lock-planted spikes (was 166 on U187). Residual spikes show **high lock_err** (0.35–0.47 m) while `state.planted` — `_bend_leg` cannot reach frozen world lock under deep knee poses; occasional **31 m/s** frames are take/lock resets (`lock_err≈0`, large `root_d`).

## Fixes shipped

1. **`_bend_leg` kneel guard** uses `canvas_floor_world_y()`; removed early `return` that skipped IK (main slide regression with planner on).
2. **`_finish_boxing_planted_feet_after_room()`** at start of `finish_hand_frame` — re-bends planted toes to world locks after `_finish_root_frame`; syncs `_prev_root_planar` after room correction.
3. **`_enforce_boxing_knee_floor()`** after repin on footwork beats.
4. **Skip `_rest_foot_lock()`** on lower-take change during active boxing footwork planner beats.

## Kneel (`tools/u188_kneel_probe.gd`)

`canvas_world_y=1.2812 m`, footwork_samples=461, **violations_below_0.25 m=922** (gate: 0). Canvas-based floor is wired; knees still dip on frames with no foot IK error.

## Tests

Parse gate clean on touched `.gd`. Subset `run_tests.py --jobs 2 --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage`: **13/13 engine load errors** (missing `.godot/imported/...mp3` in worktree), same as U187 — not a planner regression.

## Preview

`tools/u188_render_feet.gd` → `docs/previews/u188/frames/`; combine with printed ffmpeg line for `feet.mp4` (operator / `Tools/godot_hidden.ps1`).

## Stop line

Slide and kneel gates open. Next: owned room hook after `finish_hit_physics_frame`, or planner-only path that matches baseline hip_delta=0 while both feet planted without relabelling swing feet.
