# U56 — TECHNIQUE DEMAND (what reaches a presented beat)

Measurement tool: `Godot/tools/measure_technique_demand.gd`.
Harness: FightBeatAdapter.begin / advance_beat, same fighter
shape as `fight_beat_timing_test.gd` (empty learned → tier-1/2 arsenal).

| | |
|---|---|
| Bouts per ruleset | 100 |
| Rounds | 3 |
| Seed bases | boxing `560000`, then +1000 per found ruleset |
| Rulesets found | boxing, kickboxing, muay_thai, mma |
| Rulesets looked for and missing | (none) |
| Inventory | `Q47_INVENTORY.csv` (156 animated rows used) |

## The three numbers

1. **Coverage today** — **48.4%** of presented action beats already resolve to a clip (raw `has_clip` or a `TECHNIQUE_CLIP_ALIASES` row, 20 of them).
2. **Coverage after the top 20** — **71.3%** if the twenty highest-demand unbound ids that already have an owned clip were bound.
3. **The ceiling** — **71.3%** if every fired named id that matches an owned clip were bound.

Pooled action beats: **15812**. Unnamed (`<unnamed>`): **425** (2.7%) — binding cannot fix these.
Distinct named ids fired: **55**. Of those, resolve today: **31**.

Raw id samples (eye-check — these are the binding keys, not pretty names):
- `boxing_lead_hook`
- `boxing_jab`
- `boxing_rear_hook`
- `boxing_cross`
- `boxing_circle_rear`
- `boxing_catch_counter`
- `boxing_step_in_out`
- `boxing_one_two`
- `boxing_circle_lead`
- `mma_guard_gnp`
- `boxing_slip_counter`
- `boxing_cross_body`

## Top 20 bind list (highest-demand unbound + owned clip)

| rank | technique id | pooled times | owned clip |
|---:|---|---:|---|
| 1 | `boxing_rear_hook` | 788 | `H2H_HookPunch_InPlace.FBX` |
| 2 | `boxing_circle_lead` | 503 | `H2H_LeadingUppercut_InPlace.FBX` |
| 3 | `boxing_cross_body` | 312 | `H2H_StraightPunchInPlace.FBX` |
| 4 | `boxing_one_two_hook` | 302 | `H2H_HookPunch_InPlace.FBX` |
| 5 | `boxing_jab_body` | 301 | `H2H_JabInPlace.FBX` |
| 6 | `muay_thai_horizontal_elbow` | 288 | `H2H_SpinningElbow_Forward.FBX` |
| 7 | `boxing_rear_uppercut` | 235 | `H2H_LeadingUppercut_InPlace.FBX` |
| 8 | `kickboxing_front_kick` | 218 | `H2H_HighSideKick_InPlace.FBX` |
| 9 | `kickboxing_teep` | 204 | `H2H_HighSideKick_InPlace.FBX` |
| 10 | `kickboxing_hook_kick` | 184 | `H2H_HookPunch_InPlace.FBX` |
| 11 | `muay_thai_teep` | 159 | `H2H_HighSideKick_InPlace.FBX` |
| 12 | `boxing_lead_uppercut` | 135 | `H2H_LeadingUppercut_InPlace.FBX` |

Bind candidates beyond top 20: **0**.

## Purchase list — fired, unbound, NOTHING OWNED

| rank | technique id | pooled times |
|---:|---|---:|
| 1 | `boxing_circle_rear` | 555 |
| 2 | `boxing_catch_counter` | 541 |
| 3 | `boxing_step_in_out` | 538 |
| 4 | `boxing_one_two` | 520 |
| 5 | `mma_guard_gnp` | 402 |
| 6 | `boxing_slip_counter` | 323 |
| 7 | `muay_thai_sok_phung` | 245 |
| 8 | `muay_thai_khao_tat` | 235 |
| 9 | `muay_thai_mat_soei` | 210 |
| 10 | `mma_dirty_boxing` | 202 |
| 11 | `muay_thai_khao_khong` | 193 |
| 12 | `muay_thai_thip_top` | 148 |

## Ruleset `boxing`

- seeds `560000` .. `560099` (100 bouts × 3 rounds)
- action beats **3599**; unnamed **0** (0.0%); coverage now **41.8%**
- raw id samples: `boxing_cross`, `boxing_double_jab`, `boxing_circle_rear`, `boxing_lead_hook`, `boxing_cross_body`, `boxing_circle_lead`, `boxing_slip_counter`, `boxing_one_two`

| technique id | times presented | % of action beats | bound today? (raw `has_clip`) | has_clip (resolves) | owned clip that could serve it |
|---|---:|---:|---|---|---|
| `boxing_lead_hook` | 690 | 19.17% | no | yes | `H2H_HookPunch_InPlace.FBX` |
| `boxing_jab` | 440 | 12.23% | no | yes | `H2H_JabInPlace.FBX` |
| `boxing_rear_hook` | 329 | 9.14% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `boxing_cross` | 277 | 7.70% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `boxing_circle_rear` | 237 | 6.59% | no | no | `NONE OWNED` |
| `boxing_catch_counter` | 224 | 6.22% | no | no | `NONE OWNED` |
| `boxing_step_in_out` | 221 | 6.14% | no | no | `NONE OWNED` |
| `boxing_one_two` | 213 | 5.92% | no | no | `NONE OWNED` |
| `boxing_circle_lead` | 191 | 5.31% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `boxing_slip_counter` | 134 | 3.72% | no | no | `NONE OWNED` |
| `boxing_one_two_hook` | 132 | 3.67% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `boxing_jab_body` | 126 | 3.50% | no | no | `H2H_JabInPlace.FBX` |
| `boxing_cross_body` | 125 | 3.47% | no | no | `H2H_StraightPunchInPlace.FBX` |
| `boxing_rear_uppercut` | 101 | 2.81% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `boxing_double_jab` | 96 | 2.67% | yes | yes | `H2H_JabInPlace.FBX` |
| `boxing_lead_uppercut` | 63 | 1.75% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |

## Ruleset `kickboxing`

- seeds `561000` .. `561099` (100 bouts × 3 rounds)
- action beats **3646**; unnamed **0** (0.0%); coverage now **46.6%**
- raw id samples: `boxing_cross`, `boxing_jab_body`, `kickboxing_high_kick`, `boxing_circle_lead`, `boxing_lead_hook`, `boxing_circle_rear`, `boxing_jab`, `boxing_slip_counter`

| technique id | times presented | % of action beats | bound today? (raw `has_clip`) | has_clip (resolves) | owned clip that could serve it |
|---|---:|---:|---|---|---|
| `boxing_lead_hook` | 546 | 14.98% | no | yes | `H2H_HookPunch_InPlace.FBX` |
| `boxing_jab` | 322 | 8.83% | no | yes | `H2H_JabInPlace.FBX` |
| `boxing_rear_hook` | 271 | 7.43% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `boxing_catch_counter` | 173 | 4.74% | no | no | `NONE OWNED` |
| `boxing_circle_lead` | 164 | 4.50% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `boxing_circle_rear` | 164 | 4.50% | no | no | `NONE OWNED` |
| `boxing_step_in_out` | 160 | 4.39% | no | no | `NONE OWNED` |
| `boxing_cross` | 156 | 4.28% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `boxing_one_two` | 154 | 4.22% | no | no | `NONE OWNED` |
| `kickboxing_front_kick` | 140 | 3.84% | no | no | `H2H_HighSideKick_InPlace.FBX` |
| `kickboxing_roundhouse` | 133 | 3.65% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `kickboxing_teep` | 115 | 3.15% | no | no | `H2H_HighSideKick_InPlace.FBX` |
| `kickboxing_hook_kick` | 113 | 3.10% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `boxing_slip_counter` | 107 | 2.93% | no | no | `NONE OWNED` |
| `kickboxing_body_kick` | 100 | 2.74% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `kickboxing_high_kick` | 94 | 2.58% | yes | yes | `H2H_HighSideKick_InPlace.FBX` |
| `boxing_one_two_hook` | 91 | 2.50% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `boxing_jab_body` | 88 | 2.41% | no | no | `H2H_JabInPlace.FBX` |
| `boxing_cross_body` | 86 | 2.36% | no | no | `H2H_StraightPunchInPlace.FBX` |
| `boxing_rear_uppercut` | 77 | 2.11% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `kickboxing_axe_kick` | 77 | 2.11% | yes | yes | `H2H_AxeKick_InPlace.FBX` |
| `boxing_double_jab` | 71 | 1.95% | yes | yes | `H2H_JabInPlace.FBX` |
| `kickboxing_side_kick` | 62 | 1.70% | yes | yes | `H2H_HighSideKick_InPlace.FBX` |
| `kickboxing_jab_cross_lowkick` | 47 | 1.29% | yes | yes | `H2H_StraightPunchInPlace.FBX` |
| `kickboxing_jab_lowkick` | 46 | 1.26% | yes | yes | `H2H_JabInPlace.FBX` |
| `boxing_lead_uppercut` | 45 | 1.23% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `kickboxing_low_kick` | 44 | 1.21% | yes | yes | `H2H_LowSideKick_InPlace.FBX` |

## Ruleset `muay_thai`

- seeds `562000` .. `562099` (100 bouts × 3 rounds)
- action beats **3432**; unnamed **425** (12.4%); coverage now **51.5%**
- raw id samples: `muay_thai_khao_tat`, `muay_thai_mat_wiang_yao`, `boxing_one_two_hook`, `muay_thai_mat_wiang_san`, `muay_thai_straight_knee`, `muay_thai_mat_yaep`, `muay_thai_khao_khong`, `boxing_catch_counter`

| technique id | times presented | % of action beats | bound today? (raw `has_clip`) | has_clip (resolves) | owned clip that could serve it |
|---|---:|---:|---|---|---|
| `<unnamed>` | 425 | 12.38% | no | no | — |
| `boxing_lead_hook` | 167 | 4.87% | no | yes | `H2H_HookPunch_InPlace.FBX` |
| `boxing_jab` | 137 | 3.99% | no | yes | `H2H_JabInPlace.FBX` |
| `muay_thai_horizontal_elbow` | 128 | 3.73% | no | no | `H2H_SpinningElbow_Forward.FBX` |
| `muay_thai_te_khao` | 122 | 3.55% | no | yes | `NONE OWNED` |
| `muay_thai_khao_tat` | 118 | 3.44% | no | no | `NONE OWNED` |
| `muay_thai_mat_wiang_yao` | 114 | 3.32% | no | yes | `NONE OWNED` |
| `muay_thai_sok_phung` | 112 | 3.26% | no | no | `NONE OWNED` |
| `muay_thai_mat_trong` | 102 | 2.97% | no | yes | `NONE OWNED` |
| `muay_thai_khao_chiang` | 98 | 2.86% | no | yes | `NONE OWNED` |
| `muay_thai_khao_ti` | 91 | 2.65% | no | yes | `NONE OWNED` |
| `muay_thai_mat_wiang_san` | 86 | 2.51% | no | yes | `NONE OWNED` |
| `muay_thai_mat_soei` | 83 | 2.42% | no | no | `NONE OWNED` |
| `boxing_rear_hook` | 80 | 2.33% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `muay_thai_mat_yaep` | 80 | 2.33% | no | yes | `NONE OWNED` |
| `boxing_cross` | 79 | 2.30% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `muay_thai_khao_khong` | 79 | 2.30% | no | no | `NONE OWNED` |
| `muay_thai_teep` | 76 | 2.21% | no | no | `H2H_HighSideKick_InPlace.FBX` |
| `muay_thai_switch_cross` | 70 | 2.04% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `muay_thai_straight_knee` | 68 | 1.98% | yes | yes | `H2H_KneeStrike_Forward.FBX` |
| `muay_thai_jab_teep_switch` | 67 | 1.95% | no | yes | `H2H_HighSideKick_InPlace.FBX` |
| `muay_thai_body_kick` | 66 | 1.92% | no | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `boxing_one_two` | 65 | 1.89% | no | no | `NONE OWNED` |
| `boxing_catch_counter` | 64 | 1.86% | no | no | `NONE OWNED` |
| `boxing_circle_rear` | 64 | 1.86% | no | no | `NONE OWNED` |
| `muay_thai_te_chiang` | 64 | 1.86% | no | yes | `NONE OWNED` |
| `boxing_circle_lead` | 63 | 1.84% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `muay_thai_switch_kick` | 63 | 1.84% | no | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `muay_thai_round_kick` | 62 | 1.81% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `muay_thai_thip_top` | 61 | 1.78% | no | no | `NONE OWNED` |
| `muay_thai_thip_khang` | 59 | 1.72% | yes | yes | `NONE OWNED` |
| `boxing_step_in_out` | 54 | 1.57% | no | no | `NONE OWNED` |
| `boxing_jab_body` | 44 | 1.28% | no | no | `H2H_JabInPlace.FBX` |
| `boxing_cross_body` | 40 | 1.17% | no | no | `H2H_StraightPunchInPlace.FBX` |
| `muay_thai_low_kick` | 39 | 1.14% | no | yes | `H2H_LowSideKick_InPlace.FBX` |
| `muay_thai_switch_kick_body` | 38 | 1.11% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `boxing_one_two_hook` | 36 | 1.05% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `muay_thai_te_kot` | 36 | 1.05% | no | yes | `NONE OWNED` |
| `boxing_double_jab` | 35 | 1.02% | yes | yes | `H2H_JabInPlace.FBX` |
| `boxing_slip_counter` | 34 | 0.99% | no | no | `NONE OWNED` |
| `muay_thai_low_cross_hook` | 25 | 0.73% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `boxing_rear_uppercut` | 24 | 0.70% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `boxing_lead_uppercut` | 14 | 0.41% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |

## Ruleset `mma`

- seeds `563000` .. `563099` (100 bouts × 3 rounds)
- action beats **5135**; unnamed **0** (0.0%); coverage now **52.1%**
- raw id samples: `boxing_lead_hook`, `muay_thai_straight_knee`, `muay_thai_mat_soei`, `muay_thai_mat_trong`, `muay_thai_mat_wiang_san`, `boxing_catch_counter`, `mma_guard_gnp`, `kickboxing_high_kick`

| technique id | times presented | % of action beats | bound today? (raw `has_clip`) | has_clip (resolves) | owned clip that could serve it |
|---|---:|---:|---|---|---|
| `mma_guard_gnp` | 402 | 7.83% | no | no | `NONE OWNED` |
| `boxing_lead_hook` | 210 | 4.09% | no | yes | `H2H_HookPunch_InPlace.FBX` |
| `mma_dirty_boxing` | 202 | 3.93% | no | no | `NONE OWNED` |
| `boxing_jab` | 199 | 3.88% | no | yes | `H2H_JabInPlace.FBX` |
| `muay_thai_horizontal_elbow` | 160 | 3.12% | no | no | `H2H_SpinningElbow_Forward.FBX` |
| `muay_thai_mat_trong` | 156 | 3.04% | no | yes | `NONE OWNED` |
| `muay_thai_te_khao` | 143 | 2.78% | no | yes | `NONE OWNED` |
| `muay_thai_khao_chiang` | 140 | 2.73% | no | yes | `NONE OWNED` |
| `muay_thai_khao_ti` | 134 | 2.61% | no | yes | `NONE OWNED` |
| `muay_thai_sok_phung` | 133 | 2.59% | no | no | `NONE OWNED` |
| `muay_thai_mat_wiang_yao` | 132 | 2.57% | no | yes | `NONE OWNED` |
| `muay_thai_mat_soei` | 127 | 2.47% | no | no | `NONE OWNED` |
| `muay_thai_khao_tat` | 117 | 2.28% | no | no | `NONE OWNED` |
| `muay_thai_khao_khong` | 114 | 2.22% | no | no | `NONE OWNED` |
| `muay_thai_mat_wiang_san` | 109 | 2.12% | no | yes | `NONE OWNED` |
| `boxing_rear_hook` | 108 | 2.10% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `boxing_step_in_out` | 103 | 2.01% | no | no | `NONE OWNED` |
| `boxing_cross` | 97 | 1.89% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `muay_thai_mat_yaep` | 95 | 1.85% | no | yes | `NONE OWNED` |
| `muay_thai_switch_cross` | 94 | 1.83% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `muay_thai_body_kick` | 92 | 1.79% | no | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `boxing_circle_rear` | 90 | 1.75% | no | no | `NONE OWNED` |
| `kickboxing_teep` | 89 | 1.73% | no | no | `H2H_HighSideKick_InPlace.FBX` |
| `boxing_one_two` | 88 | 1.71% | no | no | `NONE OWNED` |
| `muay_thai_straight_knee` | 87 | 1.69% | yes | yes | `H2H_KneeStrike_Forward.FBX` |
| `muay_thai_thip_top` | 87 | 1.69% | no | no | `NONE OWNED` |
| `muay_thai_round_kick` | 86 | 1.67% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `boxing_circle_lead` | 85 | 1.66% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `muay_thai_jab_teep_switch` | 83 | 1.62% | no | yes | `H2H_HighSideKick_InPlace.FBX` |
| `muay_thai_teep` | 83 | 1.62% | no | no | `H2H_HighSideKick_InPlace.FBX` |
| `boxing_catch_counter` | 80 | 1.56% | no | no | `NONE OWNED` |
| `kickboxing_roundhouse` | 80 | 1.56% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `kickboxing_front_kick` | 78 | 1.52% | no | no | `H2H_HighSideKick_InPlace.FBX` |
| `muay_thai_switch_kick` | 74 | 1.44% | no | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `kickboxing_high_kick` | 71 | 1.38% | yes | yes | `H2H_HighSideKick_InPlace.FBX` |
| `kickboxing_hook_kick` | 71 | 1.38% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `muay_thai_te_chiang` | 70 | 1.36% | no | yes | `NONE OWNED` |
| `muay_thai_thip_khang` | 66 | 1.29% | yes | yes | `NONE OWNED` |
| `boxing_cross_body` | 61 | 1.19% | no | no | `H2H_StraightPunchInPlace.FBX` |
| `kickboxing_axe_kick` | 58 | 1.13% | yes | yes | `H2H_AxeKick_InPlace.FBX` |
| `boxing_double_jab` | 54 | 1.05% | yes | yes | `H2H_JabInPlace.FBX` |
| `kickboxing_body_kick` | 54 | 1.05% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `muay_thai_low_kick` | 51 | 0.99% | no | yes | `H2H_LowSideKick_InPlace.FBX` |
| `boxing_slip_counter` | 48 | 0.93% | no | no | `NONE OWNED` |
| `muay_thai_low_cross_hook` | 47 | 0.92% | no | yes | `H2H_StraightPunchInPlace.FBX` |
| `muay_thai_te_kot` | 46 | 0.90% | no | yes | `NONE OWNED` |
| `boxing_jab_body` | 43 | 0.84% | no | no | `H2H_JabInPlace.FBX` |
| `boxing_one_two_hook` | 43 | 0.84% | no | no | `H2H_HookPunch_InPlace.FBX` |
| `muay_thai_switch_kick_body` | 41 | 0.80% | yes | yes | `H2H_RoundhouseKick_InPlace.FBX` |
| `boxing_rear_uppercut` | 33 | 0.64% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |
| `kickboxing_jab_cross_lowkick` | 31 | 0.60% | yes | yes | `H2H_StraightPunchInPlace.FBX` |
| `kickboxing_side_kick` | 29 | 0.56% | yes | yes | `H2H_HighSideKick_InPlace.FBX` |
| `kickboxing_low_kick` | 26 | 0.51% | yes | yes | `H2H_LowSideKick_InPlace.FBX` |
| `kickboxing_jab_lowkick` | 22 | 0.43% | yes | yes | `H2H_JabInPlace.FBX` |
| `boxing_lead_uppercut` | 13 | 0.25% | no | no | `H2H_LeadingUppercut_InPlace.FBX` |

## Method notes

- Counted `beat["technique"]` on `type == "action"` only — the id `_clip_role_for` keys by, never `technique_name`.
- Empty technique → row `<unnamed>`.
- `bound today?` = `FightClipBinding.has_clip(raw_id)`.
- `has_clip (resolves)` = raw bind OR alias (`boxing_jab`→`jab`, `boxing_cross`→`cross`, `boxing_lead_hook`→`hook_lead`).
- Owned-clip column reads filenames from `Q47_INVENTORY.csv` only (no asset-folder walk). Matching is stem/hint/token — where nothing fits, `NONE OWNED`.
- This task does not edit `FightClipBinding.gd`.
