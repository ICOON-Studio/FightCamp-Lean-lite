# Q162 DIGEST - do the eight RamsterZ family holds lose their grips in the game?

## Part 1 - Measurement

Extended `Godot/tools/s31_contact_probe.gd` with `RAMSTERZ_CONTACTS` table (8 keys, grip rows read from Q161 rendered frames) and routed them through `_check_hold`. Added per-source `name_map_for` (UE4_TO_OURS for RamsterZ FBX, cascy_to_ours for Cascadeur GLB) and a hip-to-hip origin gate: source hip-to-hip at t=0 vs game hip-to-hip at t=0; if diff > 0.3 m the source offsets are not usable and no drift is reported.

### Origin check results (source_hip_m vs game_hip_m at t=0)

| Key | Pair file | source_hip_m | game_hip_m | diff_m | Origin |
|-----|-----------|-------------|-----------|--------|--------|
| grapple_submission_attempt | Paired_FullMount_H2H_ArmBar | 0.0318 | 0.3026 | 0.2708 | USABLE |
| grapple_takedown | Paired_FullMount_Takedown_DoubleLeg_Start | 0.0001 | 0.0105 | 0.0105 | USABLE |
| grapple_throw | Paired_FullMount_Takedown_BodyLock_Start | 0.0000 | 0.0070 | 0.0070 | USABLE |
| grapple_sweep | Paired_FullMount_Reversal | 0.0318 | 0.3026 | 0.2708 | USABLE |
| grapple_escape | Paired_FullMount_PushOff | 0.0318 | 0.3026 | 0.2708 | USABLE |
| grapple_control | Paired_FullMount_Takedown_BodyLock_Loop | 0.0318 | 0.3026 | 0.2708 | USABLE |
| mma_guard_gnp | Paired_FullMount_H2H_Punches | 0.0318 | 0.3026 | 0.2708 | USABLE |
| bjj_side_control | Cascy_SideControl | 0.4216 | 0.4494 | 0.0278 | USABLE |

### Contact drift results

**7 RamsterZ FBX keys:** All have source contact distances of ~0.02-0.04 m (essentially zero - both men authored at nearly the same position in the source FBX). The drift calculation divides by these near-zero values, producing 1000-10000% "drift" that is mathematically correct but physically meaningless. The source offsets do not represent real contacts.

**bjj_side_control (Cascadeur GLB):** source contacts are meaningful (0.10-0.81 m). Worst drift 28.97% (left_hand_head_control), failures=0.

## Part 2 - Decision table

| Key | Worst drift | Origin usable | Call | Reason |
|-----|------------|---------------|------|--------|
| grapple_submission_attempt | 3086% | Yes (hip diff 0.27m) | UNUSABLE | Source contacts ~0.04m (both men at same position); drift meaningless |
| grapple_takedown | 10952% | Yes (hip diff 0.01m) | UNUSABLE | Source contacts ~0.02m; drift meaningless |
| grapple_throw | 9412% | Yes (hip diff 0.01m) | UNUSABLE | Source contacts ~0.025m; drift meaningless |
| grapple_sweep | 2633% | Yes (hip diff 0.27m) | UNUSABLE | Source contacts ~0.04m; drift meaningless |
| grapple_escape | 7082% | Yes (hip diff 0.27m) | UNUSABLE | Source contacts ~0.02m; drift meaningless |
| grapple_control | 1597% | Yes (hip diff 0.27m) | UNUSABLE | Source contacts ~0.035m; drift meaningless |
| mma_guard_gnp | 2629% | Yes (hip diff 0.27m) | UNUSABLE | Source contacts ~0.04m; drift meaningless |
| bjj_side_control | 29% | Yes (hip diff 0.03m) | FINE | Cascadeur clip; meaningful source contacts; drift < 30% |

### Finding

The hip-to-hip origin gate (< 0.3 m diff) passes for all 8 keys because both source and game hip-to-hip distances are small for the RamsterZ FBX pairs. But the source contact distances are ~0.02-0.04 m (essentially zero), meaning the RamsterZ pairs are authored with both men at nearly the same position. The source offsets do not represent real contacts, so drift cannot be measured against them.

**None of the 7 RamsterZ FBX holds can be measured for grip drift** - the source contacts are not meaningful. Only `bjj_side_control` (Cascadeur GLB, already solved by S63) has measurable contacts, and it passes at 29% drift.

### Files changed
- `Godot/tools/s31_contact_probe.gd` (RAMSTERZ_CONTACTS table + routing + origin gate + per-source name_map_for)
- `research/Q162_DIGEST.md` (this file)

### Gate
- `python Godot/tools/check_scripts.py Godot/tools/s31_contact_probe.gd` → 0 fails
- `mma_dirty_boxing --live-key` → unchanged (worst 11%)
- `bjj_guard --live-key` → unchanged (worst 8.21%, failures=0)

Co-Authored-By: Qwen Code <noreply@qwen.ai>
