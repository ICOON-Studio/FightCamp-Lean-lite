# U108 - what every owned clip does

## DECISIONS

- `static_hold`: 3 clips (mesh/T-pose only).
- `bounce`: 63 — unarmed e.g. `magicpot_fm1/idle_A.fbx`, `magicpot_fm1/idle_Tiramis.fbx`, `ramsterz_h2h/H2H_Idle.FBX`, `ramsterz_h2h/H2H_WalkForward.FBX`.
- `foot_lift`: 134.
- `in_place_steps`: 62 — unarmed e.g. `ramsterz_h2h/H2H_WalkForward.FBX`, `ramsterz_h2h/H2H_WalkBack.FBX`, `ramsterz_h2h/H2H_RunForward.FBX`.
- `steps_travel`: 85.
- `turn`: 10.
- `level_change`: 27.
- `stance_switch`: 109 — unarmed e.g. `ramsterz_h2h/H2H_WalkForward.FBX`, `ramsterz_h2h/H2H_WalkForward_RootMotion.fbx`.
- `strike_hand`: 110.
- `strike_foot`: 91.
- `idle_A` and `idle_Tiramis`: **different motion** (distinct motion digests; same bounce rate ~147/min and pelvis range ~0.049 m).
- Motifect guards: `muay_thai_guard_stance` pelvis range 0.0021 m, `wrestling_guard_position` 0.0043 m (near-static).

## Bins

Claude's census bins (not realism bounds): `static_hold` range/path/moved thresholds; `bounce` p5–p95 ≥ 0.02 m, ≥ 60/min, net < 0.25 m; `foot_lift` ≥ 0.06 m lift and ≥ 30 lifts/min; `in_place_steps` foot_lift + net < 0.25 m; `steps_travel` net ≥ 0.25 m; `turn` |turn| ≥ 45°; `level_change` drop ≥ 0.4×T_m; `stance_switch` ≥ 1 lead swap + foot_lift; `strike_hand` ≥ 5 m/s; `strike_foot` ≥ 6 m/s.

## Surprises

- Ramsterz `Walk*`/`Run*` in-place variants travel < 0.01 m despite names — root-motion siblings carry displacement.
- `Standing_Idle.FBX` has no bounce label; `H2H_Idle.FBX` bounces (~0.031 m pelvis range).
- `H2H_BackflipKick_InPlace.FBX` pelvis apex 2.90 m (acrobatic outlier).
- Motifect `muay_thai_guard_stance` reads near-static (0.002 m) though named a stance.

## Population

Three packs (ramsterz_h2h, magicpot_fm1, motifect): 207 FBX files found, 207 measured, 0 excluded.
