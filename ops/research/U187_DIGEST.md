# U187 digest — planted means planted (S92)

Instrument: `tools/u185_planted_slide.gd` at **c0b8ba95** (unchanged classification).

## Slide (seed 94301, both men)

| Mode | p50 | **p95** | fast_share |
|------|-----|---------|------------|
| BASELINE (planner off) | 0.0000 | **0.5731** | 0.232 |
| MUTANT (drag-root) | 0.0043 | **0.7686** | 0.318 |
| AFTER (U187) | 0.0002 | **0.6377** | 0.216 |

Gate wanted AFTER p95 ≤ **0.287** (50% of baseline). **Miss** — but down from U186 re-measure **0.981** on the same instrument (not the relabelled 0.261).

## Root cause (spikes > 0.3 m/s, `tools/u187_slide_spike.gd`)

166 lock-planted spikes in 3600 frames. Dominant pattern: engine root travel applied before foot IK, then `_finish_root_frame` / placement after `_lock_feet` — toe world position drifts while `state.lock` stays fixed. Secondary: `_rest_foot_lock()` on whole-strike take change re-seats locks mid footwork.

## Fix shipped

1. **Hold root before IK** when planner returns `hold_root`: subtract `hip_delta`, refresh animated toe samples, then `_bend_leg` to frozen world locks.
2. **`_prev_root_planar` synced after hold** (not the pre-hold engine root), so pending accumulation matches visual root.
3. **Removed spurious `hold_root` branch** when planner `advance` did not run (was subtracting root without a matching lock pass → p95 ~1.45).
4. **`lock_wants = true`** on boxing footwork for non-stepping legs so clip plant tables do not unplant pinned feet.
5. **`canvas_floor_world_y()`** for kneel probes (toe-rest canvas in world metres).

## Lag

`FightStepPlanner.stats().max_lag_m` still tracks pending; not printed by c0b8ba95 instrument — spot-check on AFTER run: pending stays ≤ 0.35 m during hold (planner `MAX_STEP_SPEND_M`).

## Kneel (`tools/u187_kneel_probe.gd`)

`rig_world_scale=1.0054`, `canvas_world_y=1.2812 m`, footwork_samples=462, **violations_below_0.25 m=924**. Gate miss — `_bend_leg` knee guard still uses hips−0.92×scale for IK attenuation; canvas-based probe shows many frames where knees measure low vs toe-rest floor. Needs follow-up: decouple kneel guard from slide fix (U187 ran out of gate headroom on slide).

## Tests

Parse gate: clean on touched `.gd`. Subset `run_tests.py --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage` hit missing `.godot/imported/...mp3` in this worktree (13/13 engine load errors) — not a planner regression.

## Preview

`tools/u187_render_feet.gd` writes PNG sequence under `docs/previews/u187/frames/`; combine with printed ffmpeg line for `feet.mp4` (10 s @ 30 fps, low camera) — run via `Tools/godot_hidden.ps1` on operator machine.

## Stop line

Slide gate **0.6377 > 0.287**; kneel gate open. Next slice: post-`_finish_root_frame` toe re-pin (without moving root) or foot lock after room root finish — owned hook likely needs `FightWorldLiveScreen` ordering or a `finish_foot_frame` pass.
