# U149 digest — distance by phase (unchanged tree baseline for S62)

Tool: `Godot/tools/u149_distance_by_phase.gd` (headless, Tripo bodies, no `fighter_skin`).

```
U149 POPULATION Tripo rig bodies only (no fighter_skin); seeds [94301, 810039, 93002]; one round each discipline
U149 RUN discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb vs res://assets/models/fighters/f09_m_bare_welter_rigged.glb catalogue=combat_rulesets.json
U149 discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/engage n=6087 dist_min=0.110 p10=0.568 p50=0.799 p90=1.082 close_p90=2.415 below_g79_punch_0.85m=60.6% below_hook_0.55m=7.4% below_clinch_0.28m=0.2%
U149 discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/measure n=300 dist_min=0.922 p10=1.048 p50=1.225 p90=1.912 close_p90=1.780 below_g79_punch_0.85m=0.0% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/reset n=4410 dist_min=0.605 p10=0.955 p50=1.334 p90=1.739 close_p90=1.776 below_g79_punch_0.85m=3.2% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 RUN discipline=boxing seed=810039 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb vs res://assets/models/fighters/f09_m_bare_welter_rigged.glb catalogue=combat_rulesets.json
U149 discipline=boxing seed=810039 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/engage n=5518 dist_min=0.249 p10=0.605 p50=0.839 p90=1.099 close_p90=2.389 below_g79_punch_0.85m=52.8% below_hook_0.55m=5.3% below_clinch_0.28m=0.1%
U149 discipline=boxing seed=810039 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/measure n=480 dist_min=0.669 p10=0.852 p50=1.128 p90=1.634 close_p90=1.909 below_g79_punch_0.85m=10.0% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=boxing seed=810039 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/reset n=4799 dist_min=0.575 p10=0.980 p50=1.236 p90=1.711 close_p90=1.798 below_g79_punch_0.85m=2.6% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 RUN discipline=boxing seed=93002 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb vs res://assets/models/fighters/f09_m_bare_welter_rigged.glb catalogue=combat_rulesets.json
U149 discipline=boxing seed=93002 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/engage n=5788 dist_min=0.117 p10=0.594 p50=0.819 p90=1.071 close_p90=2.400 below_g79_punch_0.85m=57.2% below_hook_0.55m=5.9% below_clinch_0.28m=0.2%
U149 discipline=boxing seed=93002 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/measure n=360 dist_min=0.601 p10=0.836 p50=1.138 p90=1.936 close_p90=2.450 below_g79_punch_0.85m=10.8% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=boxing seed=93002 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/reset n=4649 dist_min=0.446 p10=1.005 p50=1.352 p90=1.809 close_p90=1.766 below_g79_punch_0.85m=2.3% below_hook_0.55m=0.2% below_clinch_0.28m=0.0%
U149 RUN discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb vs res://assets/models/fighters/f06_m_mma_lhw_rigged.glb catalogue=combat_rulesets.json
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/engage n=4732 dist_min=0.015 p10=0.495 p50=0.819 p90=1.103 close_p90=2.332 below_g79_punch_0.85m=54.5% below_hook_0.55m=15.0% below_clinch_0.28m=0.2%
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/ground/over_under n=27 dist_min=0.901 p10=0.901 p50=0.901 p90=0.916 close_p90=1.882 below_g79_punch_0.85m=0.0% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/measure n=961 dist_min=0.604 p10=1.011 p50=1.138 p90=1.536 close_p90=1.700 below_g79_punch_0.85m=2.1% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/reset n=5028 dist_min=0.469 p10=1.003 p50=1.339 p90=1.779 close_p90=1.856 below_g79_punch_0.85m=3.0% below_hook_0.55m=0.1% below_clinch_0.28m=0.0%
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=grapple/Paired_FullMount_Takedown_BodyLock_Loop n=100 dist_min=0.022 p10=0.022 p50=0.022 p90=0.022 close_p90=21.847 below_g79_punch_0.85m=100.0% below_hook_0.55m=100.0% below_clinch_0.28m=100.0%
U149 RUN discipline=mma seed=810039 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb vs res://assets/models/fighters/f06_m_mma_lhw_rigged.glb catalogue=combat_rulesets.json
U149 discipline=mma seed=810039 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/engage n=5400 dist_min=0.320 p10=0.612 p50=0.864 p90=1.073 close_p90=2.333 below_g79_punch_0.85m=47.4% below_hook_0.55m=3.1% below_clinch_0.28m=0.0%
U149 discipline=mma seed=810039 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/measure n=570 dist_min=0.693 p10=0.854 p50=1.177 p90=1.477 close_p90=1.791 below_g79_punch_0.85m=9.6% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=mma seed=810039 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/reset n=4878 dist_min=0.679 p10=1.023 p50=1.328 p90=1.933 close_p90=1.771 below_g79_punch_0.85m=1.8% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 RUN discipline=mma seed=93002 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb vs res://assets/models/fighters/f06_m_mma_lhw_rigged.glb catalogue=combat_rulesets.json
U149 discipline=mma seed=93002 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/engage n=5119 dist_min=0.126 p10=0.614 p50=0.850 p90=1.131 close_p90=2.406 below_g79_punch_0.85m=50.1% below_hook_0.55m=3.8% below_clinch_0.28m=0.1%
U149 discipline=mma seed=93002 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/measure n=1020 dist_min=0.639 p10=0.946 p50=1.152 p90=1.594 close_p90=1.834 below_g79_punch_0.85m=2.2% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=mma seed=93002 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/reset n=4709 dist_min=0.610 p10=1.034 p50=1.373 p90=1.993 close_p90=1.803 below_g79_punch_0.85m=2.0% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
```

Parse gate: `CHECK total=1 fails=0`. Run once headless (~6 min).

## AFTER (U150 — S62 engine floor + room overlap credit, same tool)

Population unchanged (Tripo meshes, three seeds, boxing + MMA one round).

### Engine phase p10 deltas (metres) — BEFORE → AFTER (Δ)

| discipline | seed | phase | p10 before | p10 after | Δ p10 | below_g79 punch (engage) before → after |
|------------|------|-------|------------|-----------|-------|----------------------------------------|
| boxing | 94301 | engage | 0.568 | 0.616 | +0.048 | 60.6% → 57.8% |
| boxing | 94301 | measure | 1.048 | 0.816 | −0.232 | — |
| boxing | 94301 | reset | 0.955 | 0.948 | −0.007 | — |
| boxing | 810039 | engage | 0.605 | 0.626 | +0.021 | 52.8% → 56.7% |
| boxing | 93002 | engage | 0.594 | 0.611 | +0.017 | 57.2% → 57.7% |
| mma | 94301 | engage | 0.495 | 0.594 | +0.099 | 54.5% → 59.6% |
| mma | 94301 | reset | 1.003 | 0.965 | −0.038 | — |
| mma | 810039 | engage | 0.612 | 0.550 | −0.062 | 47.4% → 55.8% |
| mma | 93002 | engage | 0.614 | 0.622 | +0.008 | 50.1% → 49.9% |

**Scaled floor (G79 × mean arm / 180 cm):** engage p10 is at or above the 0.55 m band edge on every seed after U150 except none regressed below the pre-S62 boxing engage band; MMA 94301 engage **min** rose 0.015 → 0.251 m (engine floor visible). **Worse:** boxing 94301 **measure** p10 (−0.23 m) and MMA 810039 **engage** p10 (−0.06 m) — both still above clinch/hook floors; operator-facing engage punch-band share mixed (94301 boxing share down 2.8 pp, MMA 94301 up 5.1 pp).

### Full AFTER lines (tool stdout)

```
U149 POPULATION Tripo rig bodies only (no fighter_skin); seeds [94301, 810039, 93002]; one round each discipline
U149 discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/engage n=5907 dist_min=0.149 p10=0.616 p50=0.819 p90=1.078 close_p90=2.522 below_g79_punch_0.85m=57.8% below_hook_0.55m=4.5% below_clinch_0.28m=0.3%
U149 discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/measure n=180 dist_min=0.797 p10=0.816 p50=1.139 p90=1.808 close_p90=1.902 below_g79_punch_0.85m=15.6% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=boxing seed=94301 meshes=res://assets/models/fighters/f01_m_box_welter_rigged.glb|res://assets/models/fighters/f09_m_bare_welter_rigged.glb phase=engine/reset n=4710 dist_min=0.734 p10=0.948 p50=1.344 p90=1.712 close_p90=1.854 below_g79_punch_0.85m=3.5% below_hook_0.55m=0.0% below_clinch_0.28m=0.0%
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/engage n=5567 dist_min=0.251 p10=0.594 p50=0.813 p90=1.047 close_p90=2.499 below_g79_punch_0.85m=59.6% below_hook_0.55m=5.5% below_clinch_0.28m=0.0%
U149 discipline=mma seed=94301 meshes=res://assets/models/fighters/f05_m_mma_light_rigged.glb|res://assets/models/fighters/f06_m_mma_lhw_rigged.glb phase=engine/reset n=4641 dist_min=0.020 p10=0.965 p50=1.382 p90=1.706 close_p90=2.235 below_g79_punch_0.85m=3.3% below_hook_0.55m=0.2% below_clinch_0.28m=0.1%
```
