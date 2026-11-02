# U158 digest — kick playback and smoother walk

Population: MMA R133 wrestle-grappler (A, 175 cm) vs striker (B, 185 cm), seed 92012, ruleset mma, default room options, 30 fps fixed presentation clock.

## Part 1 — what the room did to kicks (60 s probe)

Probe: `tools/u158_kick_and_walk_probe.gd` (1800 frames). Literature anchor for foot speed at impact: **~8–14 m/s** for roundhouse / TKD peaks (Robalino et al. 2025 lab roundhouse kinematics; Falco et al. 2009 taekwondo impact speeds — frame-differenced world m/s, not clip tempo).

| Finding | Before (operator take2 / master playback) | After U158 |
| --- | --- | --- |
| Combo `seek_s` into kicks | Could enter mid wind-up (leg already travelling) | `seek_s` clamped to ≤ `contact_s − 0.20 s` on kick throw roles |
| Strike tempo | Full Q60 band [0.85, 1.15] on all strikes | Kicks capped at **1.05×**; punches unchanged |
| Kick busy window | `min(clip_len, budget_s)` could under-price long kicks | Full presented duration `(len − seek) / tempo` for kick throws |
| Kicks logged in 60 s | (same bout) | **15** events; sample foot peaks (30 Hz diff): **5.5–26.1 m/s** (noisy; several knees/low samples inside literature band) |

Example after rows: `muay_thai_round_kick` native 0.700 s, presented 0.700 s, seek 0, tempo 1.0, foot_peak 21.4 m/s; combo knees with scheduled seek 0.067 s kept at 0.067 s applied (wind-up preserved).

## Part 2 — playback fixes (`FightStagePlayer.gd`)

- `_kick_playback()` — clamp seek and tempo for kick throw roles only.
- `_mark_busy()` — kicks use full presented length for occupancy.
- Punches and hand tempo path untouched (C186/C187).

## Part 3 — walk (`FightStagePlayer.gd`, `FightBodyLayers.gd`)

| Metric | After (probe) |
| --- | --- |
| Walk rate jumps ≥0.02 / frame while stepping | 1052 (eased toward target; max single jump 0.82 on clip change) |
| Planted-foot lock mean error | 0.219 m (unchanged; skate is join-era artefact) |
| Hips speed while stepping (mean / max) | 1.32 / 51.7 m/s |
| Lower-body crossfade | **0.18 s** (`LOWER_BLEND_S`; arms stay 0.10 s) |
| Walk rate easing | `WALK_RATE_SMOOTH` 0.12 per `walk_at` call |

## Part 4 — capture

- BEFORE: `research/_captures/watch_loop/take2_s65_seed92012.mp4` (master)
- AFTER: `research/_captures/watch_loop/take3_u158_seed92012.mp4` (**12.5 MB**, 60 s, 1920×1080 project recording)
- Sheet: `previews/u158_before_after.png` (0,5,…,55 s BEFORE | AFTER)

## Gate

- `check_scripts.py` on touched `.gd`: pass
- `run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,fight_walk`: **SUITE total=21 fails=1** (`fight_stage_realism_test.gd`; ceiling 8)
