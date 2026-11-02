# U116 — does the clinch lean survive the retarget?

**Cursor · U116 · 2026-09-21 · partial: spine corrections, not the 30% gate**

## RESULT

**545% → 337%** on `att_lhand_to_vic_neck` (mean 0.471 m → 0.319 m). The 30% gate
was not reached; this is the best drift after the spine-correction pass. Hands are
still ~25 cm from the authored collar tie; head gap improved but not to the 6% seen
in one intermediate run.

| contact | authored | before | after | drift before | drift after |
|---|---:|---:|---:|---:|---:|
| att_lhand_to_vic_neck | 0.073 | 0.471 | 0.319 | 545% | **337%** |
| att_rhand_to_vic_neck | 0.097 | 0.473 | 0.315 | 387% | 224% |
| vic_rhand_to_att_larm | 0.083 | 0.733 | 0.837 | 783% | 908% |
| head_to_head | 0.216 | 0.318 | 0.340 | 47% | 58% |
| hip_to_hip | 0.746 | 0.778 | 0.778 | 4% | 4% |

`grapple_control` unchanged: `min_gap_m=0.302639 max_gap_m=0.304671`.

## THREE STEPS

1. **`_inherit_upper_chest` no-op** — drift unchanged at 545%. Not the primary cause.
2. **Spine locals at t=0** (`tools/u116_spine_probe.gd`): Cascy `stomach` 4.0°,
   `chest` 9.5°, `neck` 34.6° local. Retargeted: Spine 15.1°, Chest 16.1°,
   UpperChest **45.2°** local (was **63.4°** before the correction fix).
3. **Fix (Cascadeur-only, `is_cascadeur_clip` on reference path):**
   - `CASCADEUR_SILHOUETTE_SEGMENTS` — omit `Hips→Spine` and `Chest→UpperChest`;
     full silhouette re-aim straightened the 28° clinch lean.
   - `_cascadeur_corrections` — build from those segments, then set
     `UpperChest` correction = `Chest` (shared global inherit, mismatched
     corrections had landed 63° bogus local on the arm parent).

Arm interpolation, per-frame spine split, and plain `build_corrections` were tried;
none beat 337% on the left collar tie.

## OWNED CHANGES

- `FightClipRetarget.gd`: `_cascadeur_corrections`, `CASCADEUR_SILHOUETTE_SEGMENTS`,
  gated UpperChest correction copy.
- `tools/u116_spine_probe.gd`, `U116_check.py` (ceiling **337.0%** drift).

## REPRODUCE

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
python research/U116_check.py
```
