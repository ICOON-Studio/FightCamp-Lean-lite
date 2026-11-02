# U211 digest — planted-foot slide by root owner

## Measurement

`tools/u211_slide_by_cause.gd` preserves the S139 gate: posed feet, each foot's 5th-percentile low point plus 0.04 m, 30 Hz samples, seeds 92012 / 94301 / 17701, 30 seconds each, `as_game`. Root ownership is recorded beside the room's placement write, including the `walk_to_engine` branch after a take ends. The table reports total planted slide across all six fighter-minutes; bucket shares sum to that total. P95 is the pooled planted-foot speed.

| Build / switch | Total cm | P95 m/s | Frames |
|---|---:|---:|---:|
| Master (U210 digest, no cause tags) | 16,796.7¹ | 2.649 | 8,117 |
| U210 planner, `footlock_cause=off` | 13,027.7 | 2.586 | 6,590 |
| U211 planner, `footlock_cause=on`, 0.24 m step threshold | 11,812.8 | 2.485 | 6,682 |

¹ U210_DIGEST reports 5,598.9 cm per fighter-minute; converted to the three-seed / six-fighter-minute total for this table. Master had no cause tags, so a master per-bucket split is unavailable; its aggregate is the S139 result recorded in U210_DIGEST.

## Cause split

The master column is unmeasured. U210 and U211 use the same branch and seeds, with only the U211 switch and planner threshold changed.

| Root owner / clip | Master slide cm | U210 frames / cm / share / p95 | U211 frames / cm / share / p95 |
|---|---:|---:|---:|
| footwork | — | 3,425 / 8,773.5 / 67.3% / 2.855 | 3,519 / 7,606.0 / 64.4% / 2.776 |
| sequence_step | — | 403 / 1,504.5 / 11.5% / 2.900 | 397 / 1,400.7 / 11.9% / 2.878 |
| strike_whole / boxing_jab_body | — | 340 / 967.9 / 7.4% / 3.138 | 347 / 1,030.0 / 8.7% / 3.039 |
| strike_whole / boxing_jab | — | 214 / 800.6 / 6.1% / 2.813 | 214 / 828.2 / 7.0% / 3.014 |
| strike_whole / boxing_rear_hook | — | 379 / 746.9 / 5.7% / 1.503 | 377 / 741.2 / 6.3% / 1.437 |
| strike_whole / boxing_slip | — | 1,794 / 194.7 / 1.5% / 0.000 | 1,793 / 169.2 / 1.4% / 0.000 |
| strike_whole / boxing_catch | — | 35 / 39.7 / 0.3% / 1.671 | 35 / 37.5 / 0.3% / 1.542 |

Cause table values are aggregate samples across the three seeds. Cause tags distinguish room root ownership from clip identity; whole-take clips are retained as separate rows.

## Fix and acceptance

Footwork was the largest bucket. The room now honors the existing planner's `hold_root` result in `_finish_root_frame`, so queued room travel is deferred while both feet wait for a planner step; the game switch is `footlock_cause` (on in game/demo mode, off in script runs). The planner step threshold was raised from 0.08 m to 0.24 m, still below its 0.35 m maximum step spend.

U211 lowered footwork slide by 13.3% versus U210 (8,773.5 to 7,606.0 cm) and bout-wide p95 by 3.9% (2.586 to 2.485 m/s). **Acceptance missed:** the top bucket was not halved, and p95 remains above 1.32 m/s. The first root-deferral-only run did not reduce the bucket; the measured improvement followed the larger planner threshold.

- Parse gate: `check_scripts.py` passed on all five touched scripts.
- Focused planner gate after threshold tuning: `SUITE total=1 fails=0`; test reports 13 checks, 0 failures.
- Affected suite before the final threshold tuning: `SUITE total=13 fails=2`. `fight_stage_technique_fidelity_test.gd` failed its fixture assertion (`NEAREST` branch reached 0 times); `fight_stage_realism_test.gd` timed out. Foot lock, leg IK, planner, and the other completed stage rows passed. The affected suite must be rerun after final tuning.
- C223 production gate: pending.
- Silent 20-second room recording: pending.

Godot emitted repeated `Reading less data than requested` warnings from `FightClipRetarget._load_fbx` during both measurements. They did not prevent the probes from completing, but the warnings and the unrelated nearest-clip fixture failure are recorded as evidence limits.
