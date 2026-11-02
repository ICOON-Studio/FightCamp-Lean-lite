# C103 — facing relations

## DECISIONS

Facing is measured from floor-plane joint positions for pelvis, chest and feet. The head uses its global basis applied to the calibrated chest rest facing. Each body's perpendicular sign is selected once from its rest toes direction.

| relation | OFF mean / p95 / max (deg) | ON mean / p95 / max (deg) |
|---|---:|---:|
| chest_pelvis | 2.24 / 3.91 / 179.92 | 3.21 / 5.67 / 179.96 |
| left_foot_pelvis | 7.27 / 15.47 / 179.85 | 7.55 / 22.87 / 179.41 |
| right_foot_pelvis | 10.95 / 27.30 / 179.86 | 10.34 / 179.43 / 179.99 |
| head_chest | 31.87 / 123.44 / 179.87 | 2.36 / 179.69 / 179.99 |

Worst relation by maximum error is `head_chest`: 179.87° OFF and 179.99° ON. By mean error it is also `head_chest` OFF (31.87°); ON the largest mean is `right_foot_pelvis` (10.34°).

The C102 silhouette fix fixes facing partly: it reduces head-to-chest mean error from 31.87° to 2.36°, but does not remove the near-180° frame discontinuities; chest-to-pelvis mean increases from 2.24° to 3.21°, left-foot mean is nearly unchanged (7.27° to 7.55°), and right-foot mean improves slightly (10.95° to 10.34°).

The operator-facing remaining issue is sign-stable floor-plane facing across motion: head calibration helps, but torso and feet still need continuity-aware facing correction rather than another bend or silhouette adjustment.

## Ten worst rows OFF

Rows are ordered by the sum of the four per-row OFF maxima; values below are the largest relation error in each row.

1. `H2H_KnockDown02.FBX` 0.00–2.00s — `f01_m_box_welter` — 178.60°
2. `H2H_KnockDown02.FBX` 0.00–2.00s — `f02_m_box_heavy` — 179.89°
3. `H2H_RightCutKick_InPlace.FBX` 0.00–1.00s — `f12_f_bare_welter` — 178.91°
4. `H2H_KneeStrike_Forward.FBX` 0.00–0.90s — `f01_m_box_welter` — 178.50°
5. `H2H_KneeStrike_Forward.FBX` 0.00–0.90s — `f12_f_bare_welter` — 179.85°
6. `H2H_KnockDown02.FBX` 0.00–2.00s — `f12_f_bare_welter` — 179.62°
7. `H2H_RightCutKick_InPlace.FBX` 0.00–1.00s — `f02_m_box_heavy` — 178.40°
8. `H2H_StaggerLarge04_LowHit.FBX` 8.83–11.53s — `f11_f_bare_feather` — 179.67°
9. `H2H_StaggerLarge04_LowHit.FBX` 8.83–11.53s — `f09_m_bare_welter` — 179.84°
10. `H2H_StaggerLarge04_LowHit.FBX` 8.83–11.53s — `f01_m_box_welter` — 179.86°

The complete per-row and per-relation measurements are in `C103_facing.json` (336 rows: 28 windows × 12 fighters).
