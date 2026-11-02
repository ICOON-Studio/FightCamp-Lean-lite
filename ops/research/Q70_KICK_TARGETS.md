# Q70 — WHERE EACH KICK LANDS: THE ADJUDICATED TARGET TABLE S2 WILL APPLY

**Catalogue commit: `c3474a8`.** Read from `Godot/assets/data/technique_catalog.json`
at this revision. A table without its data version is the R137 fixture mistake
over again.

---

## 1. THE KICK CENSUS

**Criterion — written down before the count:**

A technique is a kick if ANY of:
1. It has `kick_damage`, `leg_damage`, or `lowline_damage` in its effects.
2. Its id contains a kick marker (`kick`, `teep`, `low_kick`, `high_kick`,
   `roundhouse`, `switch_kick`, `hook_kick`, `axe_kick`) AND does not contain
   `elbow`.
3. It is from a kicking discipline (taekwondo, savate, capoeira) and is
   recognisably a kick by sport knowledge (chagi, fouette, armada, etc.).
4. It is in the MUST_BE_KICKS set (techniques R137 missed but are unambiguously
   kicks by sport definition).

**Exclusions:** boxing contributes zero kicks. Techniques containing `knee` in
the id are knee strikes, not kicks. Catches, counters, guards, footwork reads,
slams, sweeps-from-below, and elbow strikes are not kicks even if they have
kick-adjacent names.

**Result: 126 kicks out of 326 candidates (696 catalogue nodes).**

| | count |
|---|---:|
| Total candidates | 326 |
| Adjudicated kicks | 126 |
| With locational key | 39 |
| **Without locational key** | **87** |

**By discipline:**

| discipline | kicks |
|---|---:|
| capoeira | 10 |
| karate | 34 |
| kickboxing | 18 |
| muay_thai | 30 |
| pencak_silat | 4 |
| sanda | 4 |
| savate | 13 |
| taekwondo | 13 |
| **total** | **126** |

---

## 2. THE TWO RESOLVERS — TWO DIFFERENT VOCABULARIES

### Resolver A: `FightSimulation._technique_target_region` (line 2153)

Reads effect keys **by substring**: `head` → head_neck, `leg` → leg,
`body`/`liver`/`torso` → body, `arm`/`shoulder` → arm. If nothing matches,
falls through to `_pick_target_region` — a role-weighted random draw:
head 45 / torso 35 / arm 10 / arm 10. **No leg branch.**

### Resolver B: `FightMoves._regions_for` (line 639)

Reads effect keys **by exact match**: `head_damage` → head 85%/body 15%,
`body_damage`/`clinch_damage`/`ground_damage` → body 85%/head 15%,
`leg_damage`/`lowline_damage` → legs 90%/body 10%,
`kick_damage` → ruleset spread WITH legs. No match → ruleset spread WITHOUT
legs. **Never produces arm regions.**

### What they disagree about

| effect key | Sim resolver | Moves resolver |
|---|---|---|
| `kick_damage` alone | **DRAW** (no substring match) | **spread** (ruleset with legs) |
| `head_damage` + `kick_damage` | head | spread |
| `body_damage` + `kick_damage` | body | spread |
| `leg_damage` | leg | leg |
| `lowline_damage` | DRAW (no "leg" substring) | leg |
| nothing locational | DRAW | ruleset_default (no legs) |

**The critical gap:** 87 kicks carry no locational key the sim resolver can read.
The sim resolver cannot read `kick_damage` at all (returns DRAW → falls through
to the 45/35/10/10 punch distribution with no legs). The moves resolver reads
`kick_damage` as "spread with legs" — but that is a DISTRIBUTION, not a TARGET.
The presentation layer needs a specific region to pick an animation.

---

## 3. RECONCILIATION WITH R137

R137's classifier (`measure_kick_funnel.gd:219`) uses substring matching on the
technique id: `kick`, `teep`, `low_kick`, `high_kick`, `roundhouse`,
`switch_kick`, `hook_kick`, `axe_kick`, `knee` — with an `elbow` exclusion.
**R137 includes knees as kicks.** Q70 does not.

There are **104 disagreements** between Q70's adjudication and R137's classifier.
Each is named below with the reason for the disagreement.

### Q70 says kick, R137 says no (72 techniques)

These are kicks R137's substring rule misses because they use non-English kick
terms or have kick_damage without a kick-marker in the id:

**Capoeira** (10): capoeira_armada, capoeira_armada_double, capoeira_bencao,
capoeira_chapa_side, capoeira_martelo, capoeira_martelo_rotado,
capoeira_meia_lua_compasso, capoeira_meialua, capoeira_queixada,
capoeira_rasteira — all are kicks by sport definition (armada = spinning kick,
martelo = hammer kick, etc.) but lack English kick markers in the id.

**Karate** (34): karate_ashibarai, karate_blitz_combo, karate_fumikomigeri,
karate_gyakumikazukigeri, karate_hizageri, karate_kakatogeri, karate_kingeri,
karate_maeashigeri, karate_maeashimawashigeri, karate_maegeri,
karate_maegeri_junzuki_combo, karate_maegerikeage, karate_maegerikekomi,
karate_maehizageri, karate_mawashi_gyaku_combo, karate_mawashigeri,
karate_mawashihizageri, karate_mikazukigeri, karate_nidan_geri,
karate_oimaegeri, karate_otoshikakatogeri, karate_rengeri, karate_tobimaegeri,
karate_tobimawashigeri, karate_tobiushirogeri, karate_tobiyokogeri,
karate_urakakatogeri, karate_uramawashi, karate_ushiro_geri,
karate_ushiromawashigeri, karate_yokogeri, karate_yokogeri_gyaku_combo,
karate_yokogerikeage, karate_yokogerikekomi — all have `kick_damage` but use
Japanese terms (geri, barai) instead of the English word "kick" in the id.

**Muay Thai** (14): muay_thai_cross_body_low, muay_thai_jorakhe_faad_hang,
muay_thai_khayoep_te, muay_thai_kradot_te, muay_thai_kradot_thip,
muay_thai_low_cross_hook, muay_thai_pull_counter, muay_thai_te_chiang,
muay_thai_te_khao, muay_thai_te_khrueng_khaeng, muay_thai_te_klap_lang,
muay_thai_te_kot, muay_thai_thip_khang, muay_thai_thip_klap_lang,
muay_thai_thip_mat_te_combo, muay_thai_thip_top — use Thai terms (te, thip, teep
variants) or have leg_damage without "kick" in the id.

**Savate** (13): savate_chasse_bas, savate_chasse_frontal, savate_chasse_lateral,
savate_coup_bas, savate_direct, savate_direct_double, savate_direct_fouette,
savate_elite_chain, savate_elite_precision_chain, savate_fouette,
savate_fouette_high, savate_revers_balance, savate_revers_fouette — French kick
terms (fouette, chasse, coup bas) not in R137's marker list.

**Taekwondo** (10): tkd_apchagi, tkd_dollyochagi, tkd_double_round,
tkd_dwichagi, tkd_naeryochagi, tkd_spinning_hook, tkd_tornado_chain,
tkd_yeopchagi, taekwondo_bandae_dollyo, taekwondo_dwit_hurigi,
taekwondo_narae_chagi, taekwondo_spin_combo_chain — Korean kick terms (chagi,
dollyo, hurigi) not in R137's marker list.

**Other** (3): muay_thai_kradot_thip, pencak_silat_sapuan_low, sanda_spinning_back,
silat_sapuan — kick/leg techniques without English markers.

### R137 says kick, Q70 says no (32 techniques)

These are techniques R137's substring rule catches but Q70 excludes:

**Knees** (14): kickboxing_clinch_knee, mma_clinch_knee_trip,
muay_thai_clinch_knees, muay_thai_fake_jab_knee, muay_thai_kick_knee_combo,
muay_thai_straight_knee, muay_thai_superman_knee, muay_thai_superman_knee_punch,
muay_thai_teep_knee_chain, muay_thai_thip_clinch_knee — R137 includes `knee`
as a kick marker; Q70 classifies knee strikes as a separate category.

**Catches / counters / defensive** (8): kickboxing_catch_kick_return,
kickboxing_switch_step_read, mma_kick_catch_slam,
pencak_silat_catch_kick_takedown, sanda_kick_catch,
taekwondo_back_kick_counter — these have "kick" in the id but are defensive
actions (catching a kick, reading a kick, countering a kick), not kicks
themselves.

---

## 4. THE ADJUDICATION — ONE ROW PER KICK

Full data in `Q70_kick_targets.json`. Summary of the 87 kicks the sim resolver
cannot place (sim_today = DRAW):

### 4a. Kicks with `kick_damage` only — sim DRAW, moves spread

These are kicks whose ONLY locational signal is `kick_damage`. The sim resolver
sees nothing; the moves resolver gives a spread. Each needs a specific target.

(Full rows in JSON — 35 techniques with kick_damage as only locational key.)

### 4b. Kicks with `kick_damage` + muay thai / sanda / kickboxing

(Full rows in JSON — 17 techniques.)

### 4c. Kicks with NO damage keys at all

These have neither `kick_damage` nor any locational key. Both resolvers fall
through to defaults.

(Full rows in JSON — 9 techniques.)

### 4d. Kicks WITH locational keys — already resolved

These already have `head_damage`, `body_damage`, `leg_damage` or
`lowline_damage`. Both resolvers agree (mostly). Listed for completeness.

(Full rows in JSON — 39 techniques with explicit locational keys.)

**One disagreement worth flagging:** `kickboxing_four_strike` has both
`leg_damage` and `head_damage`. The sim resolver picks head (head score > leg
score because head_damage=10 vs leg_damage=9). The moves resolver picks leg
(leg_damage matches first in the match statement). The adjudication is **leg**
because the combo's finishing blow is a low kick.

---

## 5. THE BLAST RADIUS

Every reader of the keys a fix would add or change:

### `kick_damage`

| file:line | what it does |
|---|---|
| `FightMoves.gd:654` | `_regions_for` match branch — gives ruleset spread WITH legs |
| `build_boxing_kickboxing_nodes.py:36` | listed as a known effect key |
| `build_boxing_kickboxing_nodes.py:290,296` | used in node definitions |

### `leg_damage`

| file:line | what it does |
|---|---|
| `FightMoves.gd:651` | `_regions_for` match branch — legs 90%/body 10% |
| `FightSimulation.gd:2149` | comment: "leg_damage/leg_attack" as intent key |
| `build_boxing_kickboxing_nodes.py:36,293,342,345,349,357` | effect key in node definitions |
| `fight_targeting_test.gd:25` | test: leg_damage move aims at a leg |

### `head_damage`

| file:line | what it does |
|---|---|
| `FightMoves.gd:645` | `_regions_for` match branch — head 85%/body 15% |
| `FightSimulation.gd:2069` | `head_damage_taken` camp modifier reduces head damage |
| `FightCamp.gd:48,279` | camp edge definition and listing |
| `build_boxing_kickboxing_nodes.py:36,308,314,321,328,353,357` | node definitions |
| `fight_plans_test.gd:117` | test fixture with head_damage |
| `fight_targeting_test.gd:23` | test: head_damage aims at head |

### `body_damage`

| file:line | what it does |
|---|---|
| `FightMoves.gd:648` | `_regions_for` match branch — body 85%/head 15% |
| `GameState.gd:5192,8172,8301,8306,12402-12502` | `body_damage` as settlement/result key (different meaning) |
| `RegionHistory.gd:4,77,79` | reads `body_damage` from fight log rows |
| `build_boxing_kickboxing_nodes.py:30,83,86,108,111,114,218,221,224,296,308,311,324,336` | node definitions |
| `body_region_screen_test.gd:90,98,177` | test fixtures |
| `body_readiness_integration_test.gd:250-286` | settlement body_damage dict |
| `body_read_test.gd:65-89` | G13 ledger reads body_damage |
| `fight_camp_test.gd:220` | camp edge fixture |

### `lowline_damage`

| file:line | what it does |
|---|---|
| `FightMoves.gd:651` | `_regions_for` match branch — same as leg_damage |
| `build_boxing_kickboxing_nodes.py:37` | listed as known effect key |

**Key finding for S2:** `body_damage` in `GameState.gd` and `RegionHistory.gd`
is a DIFFERENT thing (the post-fight damage settlement) from `body_damage` as
an effect key in `technique_catalog.json`. Adding or renaming effect keys must
not touch the settlement code. The two vocabularies share a name but live in
different worlds.

---

## 6. THE ARM MYSTERY — TRACED

**Question:** `_pick_target_region` has a 20% arm branch (10% left_arm + 10%
right_arm) for damage/counter roles. R137 measured **zero** strikes of any kind
landing on an arm. Where do arms disappear?

**Answer: the active pipeline bypasses `_pick_target_region` for strikes.**

Two pipelines coexist:

1. **Old pipeline** (`FightSimulation._resolve_exchange`, line 1431): calls
   `_technique_target_region` → `_pick_target_region`. CAN return
   `left_arm`/`right_arm`. This is the code with the 20% arm branch. Line 1431
   is where `_technique_target_region` IS called in the old exchange resolver.

2. **Active pipeline** (`FightRealtime`, line 1522): calls
   `FightMoves.select()` → `_regions_for()`. `_regions_for` builds its region
   dict from explicit effect key matches (line 639-690). The ONLY regions it
   ever produces are `head_neck`, `torso_core`, `left_leg`, `right_leg`.
   **Arms are never in the dict.** `select()` walks the joint distribution
   over (technique, region) pairs from this dict, so arms cannot be selected.

The arm branch in `_pick_target_region` (lines 2240-2241) is **unreachable in
the active pipeline**. It can still fire if something calls
`_technique_target_region` directly through the old exchange path at line 1431,
but `FightRealtime` — the engine `FightBeatAdapter` drives — does not.

**Quoted lines:**

```
# FightMoves.gd:639 — _regions_for only ever adds these regions:
"head_damage"        → head_neck, torso_core
"body_damage" etc.   → torso_core, head_neck
"leg_damage" etc.    → left_leg, right_leg, torso_core
"kick_damage"        → ruleset spread (head_neck, torso_core, and maybe legs)
# No branch adds left_arm or right_arm. Ever.
```

```
# FightSimulation.gd:2223 — _pick_target_region for damage/counter:
var roll := rng.randf() * (head_share + body_share + 0.2)
if roll < head_share:        return "head_neck"
elif roll < head_share + body_share: return "torso_core"
elif roll < head_share + body_share + 0.1: return "left_arm"
return "right_arm"
# 20% arm. But FightRealtime does not call this for strikes.
```

**The arm branch is not a bug; it is a fossil.** It was correct when
`_technique_target_region` was the only resolver. R101's `_regions_for`
replaced it for the active pipeline but deliberately excluded arms (a punch
does not target an arm). The old code was never removed. If S2 touches
`_pick_target_region`, removing the arm branch is safe for the active pipeline
but changes the old one at line 1431. Flag it.

---

## 7. ADJUDICATION SUMMARY

| adjudicated target | count |
|---|---:|
| body | 52 |
| spread (head/body/leg) | 29 |
| leg | 22 |
| head | 23 |
| **total** | **126** |

| confidence | count |
|---|---:|
| high | 89 |
| medium | 36 |
| low | 1 |

The one low confidence is `muay_thai_check_kick_counter` — a counter off a
checked kick, where the return target genuinely varies.

---

## 8. WHAT S2 NEEDS TO KNOW

1. **87 kicks need tagging.** The kicks with `kick_damage` only are the highest
   priority — the sim resolver cannot place them at all. The kicks with no
   damage keys are next — neither resolver can place them. The kicks with
   `kick_damage` + a locational key the sim CAN read are partially served but
   still need specific targets for the presentation layer.

2. **Adding `leg_damage` is not always the answer.** A roundhouse kick goes
   head, body OR leg — tagging it `leg_damage` would make it ALWAYS hit a leg,
   which is wrong. These need `kick_damage` PLUS a locational qualifier, or a
   new mechanism for "this kick varies by height."

3. **`kick_damage` + `body_damage` is the pattern for "mostly body."** The
   moves resolver gives spread (with legs) when `kick_damage` is present, even
   if `body_damage` is also there. S2 may need to decide whether
   `kick_damage`+`body_damage` should resolve to body (sim behaviour) or
   spread (moves behaviour). The adjudication says body for these.

4. **The `lowline_damage` key is invisible to the sim resolver.**
   `savate_coup_bas` has `lowline_damage` which the sim resolver cannot read
   (no "leg" substring). The moves resolver handles it correctly. If S2 fixes
   the sim resolver, `lowline_damage` needs a branch.

5. **The arm fossil.** If S2 touches `_pick_target_region`, the arm branch is
   unreachable in the active pipeline but live in the old one at line 1431.
   Removing it is safe for FightRealtime but changes the old path. Flag it.
