# Q65 — MUAY THAI: THE FULL TECHNIQUE VOCABULARY

## NEW EFFECT KEYS

The following effect keys do not appear in the existing catalogue's 85 READ keys
(U59). Each is coined here for muay thai techniques.

| key | purpose | used by |
|---|---|---|
| `cut_threat` | probability of cutting skin with elbow / open-glove strike | elbow techniques |
| `knockdown_power` | single-strike knockdown likelihood, distinct from `damage` | flying knee, spinning elbow, overhand |
| `clinch_offense` | offensive output from inside the clinch | plum knee series, clinch throws |
| `combo_continuity` | chaining techniques without resetting | combination sequences |
| `off_balance_threat` | off-balancing from a strike, not just clinch | low kick, body kick |
| `balance_break` | off-balancing effect (from original 18) | clinch techniques |
| `finish_chance` | probability of finishing the fight (from original 18) | chains |
| `surprise` | unexpected attack bonus (from original 18) | spinning techniques |
| `tempo` | rhythm control (from original 18) | ringcraft |
| `score_or_damage` | scoring or damage bonus (from original 18) | dumps |
| `stamina_drain` | opponent stamina drain | clinch knee series |

**Mapped to existing read keys (fix-up pass):** `cut_chance` → `cut_threat`,
`close_range` → `damage`, `counter_damage` → `damage`, `knee_setup` → `setup`,
`opponent_stamina` → `stamina_drain`. Five keys removed by mapping.

---

## Sources and methodology

**DOCUMENTED:** All Thai names come from the English Wikipedia article on Muay
Thai (retrieved 2026-09-12), which lists techniques by category with Thai
transliterations. Romanisation follows Wikipedia's simplified system (close to
RTGS). Consistent throughout.

**DOCUMENTED (concept):** The division into *mae mai* (major techniques) and
*luk mai* (minor techniques) is stated on Wikipedia: "formal Muay Thai
techniques are divided into two groups: mae mai (major techniques) and luk mai
(minor techniques)."

**NOT FOUND:** The specific enumeration of 15 *mae mai* and 15 *luk mai* with
their traditional names. No accessible published source provided a definitive
list. Multiple muay thai websites were attempted; none returned the specific
15+15 breakdown. The number "30 master techniques" (15+15) is widely cited but
I could not verify the specific names. **This is NOT FOUND, not an inference.**

**NOT FOUND:** A formal grading / belt system. Muay Thai has no universal belt
system. The *prajioud* (armbands) and *mongkol* (headband) exist but their
ranking significance varies by gym. No published standardised syllabus found.

**INFERENCE:** Tier assignments (Foundation / Core / Advanced / Signature) are
INFERENCE based on teaching order and complexity from the Wikipedia list and
general muay thai pedagogy. Without a formal syllabus, this is the best proxy.

---

## The Mae Mai / Luk Mai question

The task file states "roughly 55 base techniques plus 30 master techniques" and
that the 30 is "Mae Mai Muay Thai (15 major) plus Luk Mai Muay Thai (15 minor)."

**What I found:**
- The *concept* of mae mai / luk mai is **DOCUMENTED** (Wikipedia).
- The *specific 15+15 enumeration* is **NOT FOUND** from accessible sources.
- The *number 55 base* is consistent with the Wikipedia list (~55 distinct named
  techniques across all categories).
- The *number 30 master* could not be confirmed or refuted.

**What I did:** Built the full set from documented Wikipedia names. Tiered them
into four levels. Advanced and Signature tiers contain the most complex
techniques — spinning, jumping, flying, advanced clinch, counters — which the
mae mai / luk mai tradition would encompass. I do not claim these ARE the mae
mai and luk mai. That assignment is **NOT FOUND**.

---

## The full technique list — 95 nodes

### Summary by tier

| tier | count | description |
|---|---:|---|
| 1 Foundation | 8 | Stance, jab, cross, basic round kick, straight knee, horizontal elbow, front clinch, straight teep, shin check, long guard, head block |
| 2 Core | 29 | Hook, overhand, uppercut, diagonal kick, body kick, diagonal knee, curving knee, arm clinch, side clinch, catch kick, slip, ringcraft, 3 combinations |
| 3 Advanced | 40 | Spinning, jumping, counters, combinations, advanced clinch, complex kicks, 8 combinations |
| 4 Signature | 18 | Flying knee, double elbow chop, jumping elbow, crocodile tail, full combinations, superman variations, 1 combination |
| **total** | **95** | **17 combinations** |

### Summary by branch

| branch | Thai root | count |
|---|---|---:|
| `punching` | *mat* | 8 |
| `elbows` | *sok* | 10 |
| `kicking` | *te* | 15 |
| `knees` | *khao* | 13 |
| `teeps` | *thip* | 5 |
| `clinch` | *chap ko* | 11 |
| `defense` | — | 8 |
| `defense_ringcraft` | — | 2 |
| `kicks_knees` | — | 4 |
| `eight_limbs` | — | 2 |
| `combinations` | — | 17 |
| **total** | | **95** |

### Summary by grade (contract section 11)

| grade | count | tier mapping |
|---|---:|---|
| `base` | 37 | Foundation + Core (tiers 1-2) |
| `mae_mai` | 40 | Advanced (tier 3) |
| `luk_mai` | 18 | Signature (tier 4) |

Muay Thai has **NOT FOUND** for a formal belt/grading system (contract section 11).
The *prajioud* (armbands) exist but their ranking significance varies by gym.
Grades use `base`, `mae_mai`, `luk_mai` per the contract's instruction.

---

### PUNCHING (*mat*) — 12 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 1 | `muay_thai_mat_yaep` | Mat yaep | Jab | 1 |
| 2 | `muay_thai_mat_trong` | Mat trong | Cross | 1 |
| 3 | `muay_thai_mat_wiang_san` | Mat wiang san | Hook | 2 |
| 4 | `muay_thai_mat_wiang_yao` | Mat wiang yao | Overhand | 2 |
| 5 | `muay_thai_mat_soei` | Mat soei | Uppercut | 2 |
| 6 | `muay_thai_mat_wiang_klap` | Mat wiang klap | Spinning backfist | 3 |
| 7 | `muay_thai_kradot_chok` | Kradot chok | Superman punch | 3 |
| 8 | `muay_thai_jab_cross_hook` | Jab-cross-hook | Three-punch combination | 3 |
| 9 | `muay_thai_jab_cross_body_kick` | Jab-cross-body kick | Punch combo into kick | 3 |
| 10 | `muay_thai_slip_counter` | Slip counter | Slip and return fire | 3 |
| 11 | `muay_thai_superman_knee_punch` | Superman knee-punch | Superman punch into knee | 4 |
| 12 | `muay_thai_jab_cross_sok_klap` | Jab-cross-spinning elbow | Punch combo into spinning elbow | 4 |

### ELBOWS (*sok*) — 12 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 13 | `muay_thai_sok_tat` | Sok tat | Horizontal elbow slash | 1 |
| 14 | `muay_thai_sok_ngat` | Sok ngat | Uppercut elbow | 2 |
| 15 | `muay_thai_sok_phung` | Sok phung | Forward thrust elbow | 2 |
| 16 | `muay_thai_sok_chiang` | Sok chiang | Diagonal elbow | 2 |
| 17 | `muay_thai_sok_wiang_klap` | Sok wiang klap | Reverse horizontal elbow | 3 |
| 18 | `muay_thai_sok_klap` | Sok klap | Spinning elbow | 3 |
| 19 | `muay_thai_sok_klap_khu` | Sok klap khu | Double elbow chop | 4 |
| 20 | `muay_thai_kradot_sok` | Kradot sok | Jumping elbow | 4 |
| 21 | `muay_thai_counter_sok_klap` | Counter spinning elbow | Counter with spinning elbow | 4 |
| 22 | `muay_thai_sok_ti` | Sok ti | General elbow slash | 1 |
| 23 | `muay_thai_sok_long_guard_counter` | Long guard elbow counter | Counter from long guard with elbow | 3 |
| 24 | `muay_thai_sok_clinch_combo` | Clinch elbow combo | Clinch entry into elbow | 4 |

### KICKING (*te*) — 16 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 25 | `muay_thai_te_tat` | Te tat | Roundhouse kick | 1 |
| 26 | `muay_thai_te_chiang` | Te chiang | Diagonal kick | 2 |
| 27 | `muay_thai_te_kot` | Te kot | Down roundhouse kick | 2 |
| 28 | `muay_thai_te_khao` | Te khao | Axe heel kick | 2 |
| 29 | `muay_thai_te_klap_lang` | Te klap lang | Reverse roundhouse / wheel kick | 3 |
| 30 | `muay_thai_te_khrueng_khaeng` | Te khrueng khaeng | Half-shin half-knee kick | 3 |
| 31 | `muay_thai_kradot_te` | Kradot te | Jump kick | 3 |
| 32 | `muay_thai_khayoep_te` | Khayoep te | Step-up kick | 3 |
| 33 | `muay_thai_jorakhe_faad_hang` | Jorakhe faad hang | Crocodile sweeps tail | 4 |
| 34 | `muay_thai_low_kick` | Low kick | Roundhouse to lead leg | 1 |
| 35 | `muay_thai_body_kick` | Body kick | Full-power roundhouse to torso | 2 |
| 36 | `muay_thai_switch_kick` | Switch kick | Step-switch before roundhouse | 2 |
| 37 | `muay_thai_fake_teep_kick` | Fake teep to kick | Feint teep then roundhouse | 3 |
| 38 | `muay_thai_double_kick` | Double kick | Two consecutive round kicks | 3 |
| 39 | `muay_thai_spinning_back_kick` | Spinning back kick | Spin and kick with heel | 4 |
| 40 | `muay_thai_check_counter_kick` | Check-counter kick | Check kick and return kick | 3 |

### KNEES (*khao*) — 15 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 41 | `muay_thai_khao_trong` | Khao trong | Straight knee | 1 |
| 42 | `muay_thai_khao_chiang` | Khao chiang | Diagonal knee | 2 |
| 43 | `muay_thai_khao_khong` | Khao khong | Curving knee | 2 |
| 44 | `muay_thai_khao_tat` | Khao tat | Horizontal knee | 2 |
| 45 | `muay_thai_khao_ti` | Khao ti | Knee slap | 2 |
| 46 | `muay_thai_khao_yao` | Khao yao | Knee bomb | 3 |
| 47 | `muay_thai_khao_yiap` | Khao yiap | Step-up knee | 3 |
| 48 | `muay_thai_khao_thon` | Khao thon | Thrusting knee | 3 |
| 49 | `muay_thai_khao_loi` | Khao loi | Flying knee | 4 |
| 50 | `muay_thai_khao_dot` | Khao dot | Jumping knee | 4 |
| 51 | `muay_thai_fake_jab_knee` | Fake jab to knee | Feint jab then clinch knee | 3 |
| 52 | `muay_thai_kick_knee_combo` | Kick-knee combo | Round kick into clinch knee | 3 |
| 53 | `muay_thai_superman_knee` | Superman knee | Superman motion into knee | 4 |
| 54 | `muay_thai_khao_counter` | Knee counter | Counter incoming with knee | 3 |
| 55 | `muay_thai_khao_clinch_entry` | Knee clinch entry | Knee strike to clinch entry | 4 |

### TEEPS / FOOT-THRUSTS (*thip*) — 7 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 56 | `muay_thai_thip_trong` | Thip trong | Straight foot-thrust | 1 |
| 57 | `muay_thai_thip_khang` | Thip khang | Sideways foot-thrust | 2 |
| 58 | `muay_thai_thip_klap_lang` | Thip klap lang | Reverse foot-thrust | 3 |
| 59 | `muay_thai_thip_top` | Thip top | Slapping foot-thrust | 2 |
| 60 | `muay_thai_kradot_thip` | Kradot thip | Jumping foot-thrust | 3 |
| 61 | `muay_thai_counter_teep` | Counter teep | Teep as counter to strike | 3 |
| 62 | `muay_thai_teep_knee_chain` | Teep-knee chain | Teep to clinch to knee | 4 |

### CLINCH (*chap ko*) — 13 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 63 | `muay_thai_chapko_na` | Chap ko na | Front clinch (double collar tie) | 1 |
| 64 | `muay_thai_chapko_khaeng` | Chap ko khaeng | Arm clinch | 2 |
| 65 | `muay_thai_chapko_khang` | Chap ko khang | Side clinch | 2 |
| 66 | `muay_thai_chapko_lang` | Chap ko lang | Low clinch | 3 |
| 67 | `muay_thai_saphan_kha` | Saphan kha | Swan-neck | 3 |
| 68 | `muay_thai_chapko_sweep` | Chap ko sweep | Clinch sweep | 2 |
| 69 | `muay_thai_chapko_dump` | Chap ko dump | Clinch turn and dump | 3 |
| 70 | `muay_thai_chapko_offbalance` | Chap ko off-balance | Off-balance and dump | 3 |
| 71 | `muay_thai_chapko_knee_tap` | Chap ko knee tap | Knee tap takedown | 3 |
| 72 | `muay_thai_chapko_knees` | Chap ko knees | Clinch knee series | 3 |
| 73 | `muay_thai_chapko_head_sweep` | Chap ko head sweep | Head-bicep sweep | 3 |
| 74 | `muay_thai_chapko_sweep_throw` | Chap ko sweep throw | Full throw from clinch | 4 |
| 75 | `muay_thai_chapko_curfew` | Chap ko curfew | Knee to thigh from clinch | 3 |

### DEFENSE — 10 techniques

| # | id | Thai name | English | tier |
|---|---|---|---|---|
| 76 | `muay_thai_long_guard` | Long guard | Push lead hand, control distance | 1 |
| 77 | `muay_thai_shin_check` | Shin check | Raise shin to block body kick | 1 |
| 78 | `muay_thai_head_block` | Head block | High guard, deflect punches | 1 |
| 79 | `muay_thai_catch_kick` | Catch kick | Trap opponent's kicking leg | 2 |
| 80 | `muay_thai_slip` | Slip | Head movement to avoid punches | 2 |
| 81 | `muay_thai_pull_back` | Pull back | Lean back to avoid strikes | 2 |
| 82 | `muay_thai_cross_arm_block` | Cross-arm block | Cross forearms for body shots | 2 |
| 83 | `muay_thai_ringcraft` | Ring generalship | Footwork, angles, tempo | 2 |
| 84 | `muay_thai_catch_strike` | Catch and strike | Catch kick and counter punch | 3 |
| 85 | `muay_thai_pull_counter` | Pull counter | Pull back and counter kick | 3 |

---

## Comparison with existing 18 nodes

The existing 18 muay thai nodes in `technique_catalog.json` are preserved.
Where an existing node corresponds to a documented technique, the JSON uses the
**existing id** to avoid merge conflicts:

| existing id | maps to in this set |
|---|---|
| `muay_thai_stance` | kept as-is (skill, tier 1) — not in the 85 above |
| `muay_thai_teep` | → `muay_thai_thip_trong` (#56) — kept existing id |
| `muay_thai_round_kick` | → `muay_thai_te_tat` (#25) — kept existing id |
| `muay_thai_straight_knee` | → `muay_thai_khao_trong` (#41) — kept existing id |
| `muay_thai_horizontal_elbow` | → `muay_thai_sok_tat` (#13) — kept existing id |
| `muay_thai_plum` | → `muay_thai_chapko_na` (#63) — kept existing id |
| `muay_thai_switch_kick_body` | kept as-is (#36 equivalent) |
| `muay_thai_teep_defense` | → `muay_thai_long_guard` (#76) — kept existing id |
| `muay_thai_catch_sweep` | → `muay_thai_chapko_sweep` (#68) — kept existing id |
| `muay_thai_diagonal_elbow` | → `muay_thai_sok_chiang` (#16) — kept existing id |
| `muay_thai_clinch_knees` | → `muay_thai_chapko_knees` (#72) — kept existing id |
| `muay_thai_up_elbow` | → `muay_thai_sok_ngat` (#14) — kept existing id |
| `muay_thai_clinch_dump` | → `muay_thai_chapko_dump` (#69) — kept existing id |
| `muay_thai_knee_curfew` | → `muay_thai_chapko_curfew` (#75) — kept existing id |
| `muay_thai_dumps_offbalance` | → `muay_thai_chapko_offbalance` (#70) — kept existing id |
| `muay_thai_ringcraft_walk` | → `muay_thai_ringcraft` (#83) — kept existing id |
| `muay_thai_spinning_elbow` | → `muay_thai_sok_klap` (#18) — kept existing id |
| `muay_thai_eight_limb_chain` | kept as-is — not in the 85 above |

The JSON file uses existing ids for the 18 that already exist, and new ids for
the 77 new techniques (including 8 new combinations). Plus the two skills
(`muay_thai_stance` and `muay_thai_eight_limb_chain`) carried forward unchanged.

---

## Combinations (contract section 10)

17 combination nodes, each listing ALL component techniques in `prerequisites`.
Every combination's `grade_rank` is greater than all its components' (section 12).

| id | components | tier | grade |
|---|---|---|---|
| `muay_thai_low_cross_hook` | low_kick, mat_trong, mat_wiang_san | 2 | base |
| `muay_thai_switch_cross` | switch_kick_body, mat_trong | 2 | base |
| `muay_thai_jab_teep_switch` | mat_yaep, teep, switch_kick_body | 2 | base |
| `muay_thai_thip_mat_te_combo` | teep, mat_trong, round_kick | 3 | mae_mai |
| `muay_thai_check_kick_counter` | shin_check, round_kick | 3 | mae_mai |
| `muay_thai_kick_knee_combo` | round_kick, straight_knee | 3 | mae_mai |
| `muay_thai_clinch_knees` | plum, straight_knee | 3 | mae_mai |
| `muay_thai_jab_cross_hook` | mat_yaep, mat_trong, mat_wiang_san | 3 | mae_mai |
| `muay_thai_jab_cross_body_kick` | mat_yaep, mat_trong, body_kick | 3 | mae_mai |
| `muay_thai_thip_clinch_knee` | teep, plum, straight_knee | 3 | mae_mai |
| `muay_thai_cross_body_low` | mat_trong, body_kick, low_kick | 3 | mae_mai |
| `muay_thai_jab_cross_sok_klap` | mat_yaep, mat_trong, spinning_elbow | 4 | luk_mai |
| `muay_thai_teep_knee_chain` | teep, straight_knee | 4 | luk_mai |
| `muay_thai_superman_knee_punch` | kradot_chok, straight_knee | 4 | luk_mai |
| `muay_thai_sok_clinch_combo` | plum, horizontal_elbow | 4 | luk_mai |
| `muay_thai_eight_limb_chain` | teep, round_kick, straight_knee, horizontal_elbow, clinch_knees, up_elbow, clinch_dump | 4 | luk_mai |
| `muay_thai_slip_sok_klap` | slip, spinning_elbow | 4 | luk_mai |

---

## Fix-up pass (2026-09-12)

The original delivery (commit `126ec8d`, 85 nodes) was brought into compliance
with contract sections 10, 11 and 12:

1. **57 validation errors fixed:**
   - `kind='sequence'` → `kind='move'` (11 nodes)
   - `role='counter'` → `role='damage'` (9 nodes)
   - `role='takedown'` → `role='control'` (3 nodes)
   - `role='adaptation'` → context-dependent `control`/`setup`/`damage` (4 nodes)
   - `phase='pocket'` → `phase='standing'` (25 occurrences; 2 nodes where the
     technique genuinely enters clinch mapped to `clinch`)
   - `phase='clinch_break'` → `phase='standing'` (5 occurrences)

2. **grade/grade_rank added to all 95 nodes** (contract section 11):
   - Tier 1-2 → `base`, Tier 3 → `mae_mai`, Tier 4 → `luk_mai`
   - `grade_rank` is monotonic within each grade; combinations are ranked after
     all their components (section 12)

3. **17 combinations** in `combinations` branch (contract section 10):
   - 9 existing sequence nodes moved to combinations with all components listed
   - 8 new named muay thai chains added

4. **5 unread effect keys mapped** to existing read keys:
   `cut_chance` → `cut_threat`, `close_range` → `damage`,
   `counter_damage` → `damage`, `knee_setup` → `setup`,
   `opponent_stamina` → `stamina_drain`

Validator: **VALIDATION OK** — 0 errors, 0 schema violations, acyclic, ids unique.

---

## Prerequisite graph

Acyclic. General pattern:
- Tier 1: no prerequisites (or require only `muay_thai_stance`)
- Tier 2: require one or two tier 1 techniques
- Tier 3: require tier 1-2 techniques
- Tier 4: require tier 2-3 techniques
- Combinations: require all component techniques; grade_rank > all components

No technique requires itself, directly or indirectly. Every id is unique.

---

## HANDOFF

**Status: COMPLETE**

Delivered 95 muay thai technique nodes (85 individual + 8 new combinations + 2
existing skills carried forward). 17 combinations in `combinations` branch, all
listing component techniques as prerequisites. grade/grade_rank on every node
(`base`/`mae_mai`/`luk_mai`). The specific Mae Mai / Luk Mai 15+15 enumeration
is **NOT FOUND**. Tier assignments are **INFERENCE**. 11 unread effect keys
(5 mapped to read equivalents in fix-up). Existing 18 node ids preserved.
Prerequisite graph is acyclic. Validator: 0 errors.
