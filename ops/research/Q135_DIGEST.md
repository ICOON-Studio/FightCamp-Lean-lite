# Q135 DIGEST — SOUND PASS 2

**Date:** 2026-09-22
**Agent:** qwen
**Task:** TASK_SOUND.md Pass 2

## What landed

### 1. Crowd bed on the Crowd bus
- Synthetic PCM generated at startup: 2s of low-pass-filtered noise with
  slow amplitude breathing, looped via `AudioStreamWAV.LOOP_FORWARD`.
- `_crowd_player` on the Crowd bus, starts/stops via `start_crowd()` /
  `stop_crowd()`.
- `crowd_swell(intensity)` raises volume from -18 dB base toward -6 dB,
  decays back over 2.5s via `_process`.
- Grade-3 grapples trigger a 0.6 swell; grade-2 triggers 0.3.

### 2. Grade-based routing
- Action beats now read `significant`: significant head → `punch_head_sig`,
  significant body → `punch_body_sig`. Non-significant unchanged.
- Grapple grade 3+ → `punch_body_sig` (was `punch_body`); grade 2 unchanged.
- Two new impact presets: `punch_head_sig` (brighter, harder transient),
  `punch_body_sig` (deeper, longer decay, more body).

### 3. Sync budget, enforced
- `last_beat_t_s` records the beat's `t_s` at routing time.
- `last_decision_us` records `Time.get_ticks_usec()` at routing time.
- Test drives a 5-beat sequence with known `t_s` values and proves:
  - Each beat's sound is attributed to the RIGHT beat (not off-by-one).
  - The decision happens in the same call frame (offset ~0 us).
  - Achieved offset printed beside budget: all within [-45..+80 ms].

## Achieved-beside-wanted timing table

| Beat | t_s (s) | Achieved offset | Wanted budget | Status |
|------|---------|-----------------|---------------|--------|
| 0    | 0.0     | 0.0 ms (~2 us)  | [-45..+80 ms] | OK     |
| 1    | 14.0    | 0.0 ms (~7 us)  | [-45..+80 ms] | OK     |
| 2    | 28.0    | 0.0 ms (~6 us)  | [-45..+80 ms] | OK     |
| 3    | 42.0    | 0.0 ms (~4 us)  | [-45..+80 ms] | OK     |
| 4    | 56.0    | 0.0 ms (~3 us)  | [-45..+80 ms] | OK     |

The offset is 0 because `on_beat()` is called synchronously in the same
call frame as `advance_beat()`. The budget is a ceiling, not a target —
J22B says cage TOF is single-digit ms, far under 80 ms.

## Mutant table

| # | Mutation                                  | Fails | Caught by                        |
|---|-------------------------------------------|-------|----------------------------------|
| 1 | `_generate_crowd` early-returns            | 3     | crowd stream, active, swell      |
| 2 | Significant head → `punch_head` (not _sig) | 2     | grade routing + sync beat 4      |
| 3 | `last_beat_t_s` pinned to 0.0             | 5     | all sync attribution checks      |
| 4 | `crowd_swell` early-returns                | 1     | swell raises volume              |

All four mutants went red. All four restored green.

## Test numbers

| Gate                        | Before | After |
|-----------------------------|--------|-------|
| fight_audio_test.gd total   | 51     | 103   |
| fight_audio_test.gd fails   | 0      | 0     |
| run_tests.py --only fight_audio | 1/0 | 1/0   |
| run_tests.py --only fight_beat  | 7/0 | 7/0   |
| Parse gate                  | 0      | 0     |

## Files touched

- `Godot/scripts/FightAudio.gd` — 170 → 288 lines
- `Godot/tests/fight_audio_test.gd` — 165 → 222 lines

## One thing for pass 3

The crowd swell decays via `_process`, but nothing in the fight screens
calls `start_crowd()` or `stop_crowd()` yet — the seam exists but is not
wired. Pass 3 should add those calls to `FightNightScreen` and
`FightWorldLiveScreen` at round start/end, and wire `crowd_swell` to
significant strikes and knockdowns so the crowd actually reacts during a
real fight.
