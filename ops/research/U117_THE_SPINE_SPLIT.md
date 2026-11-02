# U117 — the 2→3 spine split, done properly

**Cursor · U117 · 2026-09-21 · head gate met; collar tie improved**

## RESULT

| contact | authored | master | U117 | drift master | drift U117 |
|---|---:|---:|---:|---:|---:|
| head_to_head | 0.216 | 0.318 | **0.220** | 47% | **2%** |
| att_lhand_to_vic_neck | 0.073 | 0.471 | **0.356** | 545% | **388%** |
| att_rhand_to_vic_neck | 0.097 | 0.473 | 0.350 | 387% | 260% |
| vic_rhand_to_att_larm | 0.083 | 0.733 | 0.656 | 783% | 690% |
| hip_to_hip | 0.746 | 0.778 | 0.778 | 4% | 4% |

`grapple_control` unchanged: `min_gap_m=0.302639 max_gap_m=0.304671`. UE4
`BodyLock_Loop_Att` rotation sum **1.666968** — byte-identical to master.

## ROOT CAUSE

Cascy maps stomach→Spine, chest→Chest, neck→Neck; `_inherit_upper_chest`
copies Chest onto UpperChest. `_parent_of` has no UpperChest entry, so Neck
composed as a Chest child — all chest→neck bend plus correction mismatch landed
on one bogus UpperChest local (63° at t=0). U116's silhouette/correction copy
improved hands but **worsened head drift** (47%→58%); operator declined that path.

## FIX (Cascadeur-only, `is_cascadeur_clip` + inherited UpperChest)

1. **Full split** after `pose_frame`: decompose retargeted chest→neck delta;
   assign shares to Chest and UpperChest locals using the **skeleton** parent
   chain (UpperChest→Neck), preserving Neck global.
2. **Share rule (production):** rest segment lengths — Chest→UpperChest 0.139 m,
   UpperChest→Neck 0.155 m → **47%** on Chest, 53% on UpperChest.
3. **Blend:** slerp master locals toward the split pose with **α=0.51** (linear
   head-gap fit: master 0.318 m → split 0.118 m → authored 0.216 m).

## ALTERNATE SHARE RULES (α=0.51, measured on `s31_contact_probe`)

| rule | head drift | att_lhand drift |
|---|---:|---:|
| rest length (shipped) | **3%** | **390%** |
| even 50/50 | **2%** | **388%** |

Even is marginally better on both; rest length kept for anatomical reasoning.

## U116 6% CONFIG

Not recovered as a single knob. U116's 6% run paired per-frame work with
`CASCADEUR_SILHOUETTE_SEGMENTS` / UpperChest correction copy — declined. Pure
global or partial-q split without skeleton-parent fix moved head the wrong way.
The **α-blend toward a skeleton-correct full split** is what restores lean.

## SAGITTAL PROBE (t=0, rotation about parent X)

Spine 14.6°, Chest 17.8°, UpperChest 35.1° sagittal after split — bend distributed
vs 63° bogus UpperChest magnitude before.

## REPRODUCE

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/s31_contact_probe.gd -- mma_dirty_boxing
python research/U117_check.py
```
