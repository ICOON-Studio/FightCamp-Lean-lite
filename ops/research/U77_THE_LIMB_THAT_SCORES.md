Catalogue read at commit `7c158c9` (`technique_catalog.json`, `FightSimulation.gd`, `FightRange.gd`, `RealtimeRoundStats.gd`, `FightRealtime.gd`, Q70/Q77 census files).

# U77 — The limb that scores

326 standing-strike candidates from Q70 census. Adjudicated limb/kind from Q70 (`is_kick`) and Q77 (`strike_kind`). Both engine classifiers transcribed verbatim below — mistakes included.

## Classifiers (transcribed, not fixed)

**FightSimulation** (`Godot/scripts/FightSimulation.gd:2094-2104`):

```gdscript
const KICK_MARKERS := ["kick", "geri", "chagi", "teep", "knee", "chasse", "fouette", "revers", "martelo", "armada", "meia_lua", "meialua", "queixada", "bencao", "chapa", "tornado", "roundhouse", "spin", "dollyo", "hurigi", "mawashi", "coup"]

static func _is_kick(technique: Dictionary) -> bool:
	var probe := (str(technique.get("id", "")) + " " + str(technique.get("name", ""))).to_lower()
	if probe.find("elbow") != -1:
		return false
	for marker in KICK_MARKERS:
		if probe.find(marker) != -1:
			return true
	return false
```

**FightRange** (`Godot/scripts/FightRange.gd:110,476-483`) — comment at `:108-109` claims verbatim reuse from FightSimulation but **`knee` is omitted** from the marker list:

```gdscript
const KICK_MARKERS := ["kick", "geri", "chagi", "teep", "chasse", "fouette", "revers", "martelo", "armada", "meia_lua", "meialua", "queixada", "bencao", "chapa", "tornado", "roundhouse", "spin", "dollyo", "hurigi", "mawashi", "coup"]

static func _is_kick(technique: Dictionary) -> bool:
	var probe := (str(technique.get("id", "")) + " " + str(technique.get("name", ""))).to_lower()
	if probe.find("elbow") != -1 or probe.find("knee") != -1:
		return false
	for marker in KICK_MARKERS:
		if probe.find(marker) != -1:
			return true
	return false
```

**Zone filing when `_credit_zone_hit` runs** (`:2081-2091`): `region` containing `"leg"` → `legs`; `torso_core` → `body_foot` if `_is_kick` else `body_hand`; all other regions (head) → `head_foot` if kick else `head_hand`.

Summary: `sim_wrong=40`, `range_wrong=21`.

---

## FightSimulation._is_kick disagreements (40 strikes)

Grouped by discipline. “Zone effect” is what `_credit_zone_hit` does on a head or torso land given the mislabel (leg-target lands always file `legs` regardless of classifier).

### capoeira (2)

| id | adjudicated | sim | zone effect |
|---|---|---|---|
| `capoeira_ginga_flow_chain` | kick | false | head/torso → `head_hand` / `body_hand` instead of `head_foot` / `body_foot` |
| `capoeira_rasteira` | kick | false | same |

### karate (5)

| id | adjudicated | sim | zone effect |
|---|---|---|---|
| `karate_ashibarai` | kick | false | foot zones never credited |
| `karate_maemawashiempiuchi` | punch | true | `head_foot` (×3 profile) instead of `head_hand` (×1) |
| `karate_mawashiempiuchi` | punch | true | same |
| `karate_uke_counter` | punch | true | same |
| `karate_urakenmawashiuchi` | punch | true | same (`mawashi` marker) |

### kickboxing (1)

| id | adjudicated | sim | zone effect |
|---|---|---|---|
| `kickboxing_clinch_knee` | knee | true | `body_foot` / `head_foot` instead of hand zones; knee is not adjudicated `kick` |

### muay_thai (29)

| id | adjudicated | sim | zone effect |
|---|---|---|---|
| `muay_thai_clinch_knees` | knee | true | foot zones on torso/head land |
| `muay_thai_fake_jab_knee` | knee | true | same |
| `muay_thai_jorakhe_faad_hang` | kick | false | hand zones on head/torso kick |
| `muay_thai_khao_chiang` | knee | true | foot zones |
| `muay_thai_khao_clinch_entry` | knee | true | foot zones |
| `muay_thai_khao_counter` | knee | true | foot zones |
| `muay_thai_khao_dot` | knee | true | foot zones |
| `muay_thai_khao_khong` | knee | true | foot zones |
| `muay_thai_khao_loi` | knee | true | foot zones |
| `muay_thai_khao_tat` | knee | true | foot zones |
| `muay_thai_khao_thon` | knee | true | foot zones |
| `muay_thai_khao_ti` | knee | true | foot zones |
| `muay_thai_khao_yao` | knee | true | foot zones |
| `muay_thai_khao_yiap` | knee | true | foot zones |
| `muay_thai_kick_knee_combo` | mixed | true | foot zones (`knee` marker in id) |
| `muay_thai_kradot_thip` | kick | false | hand zones |
| `muay_thai_mat_wiang_klap` | punch | true | `head_foot` instead of `head_hand` (`spin` marker) |
| `muay_thai_pull_counter` | kick | false | hand zones |
| `muay_thai_straight_knee` | knee | true | foot zones |
| `muay_thai_superman_knee` | knee | true | foot zones |
| `muay_thai_superman_knee_punch` | mixed | true | foot zones |
| `muay_thai_switch_cross` | mixed | true | foot zones (`kick` in id) |
| `muay_thai_teep_knee_chain` | mixed | true | foot zones |
| `muay_thai_thip_clinch_knee` | mixed | true | foot zones |
| `muay_thai_thip_khang` | kick | false | hand zones |
| `muay_thai_thip_mat_te_combo` | kick | false | hand zones |
| `muay_thai_thip_top` | kick | false | hand zones |

### pencak_silat (2)

| id | adjudicated | sim | zone effect |
|---|---|---|---|
| `pencak_silat_sapuan_low` | kick | false | hand zones |
| `silat_sapuan` | kick | false | hand zones |

### savate (3)

| id | adjudicated | sim | zone effect |
|---|---|---|---|
| `savate_direct` | kick | false | hand zones (Savate “Direct” has no marker substring) |
| `savate_direct_double` | kick | false | same |
| `savate_revers_counter` | punch | true | `head_foot` instead of `head_hand` (`revers` marker) |

---

## FightRange._is_kick disagreements (21 strikes)

Grouped by discipline. “Range effect” is `_derived_bands` (`:450-451`): kick → `[LONG, MID]`; non-kick damage role → discipline-dependent, usually `[MID, POCKET]`.

### capoeira (2)

| id | adjudicated | range | range effect |
|---|---|---|---|
| `capoeira_ginga_flow_chain` | kick | false | `[MID, POCKET]` not `[LONG, MID]` |
| `capoeira_rasteira` | kick | false | same |

### karate (5)

| id | adjudicated | range | range effect |
|---|---|---|---|
| `karate_ashibarai` | kick | false | short band |
| `karate_maemawashiempiuchi` | punch | true | long band (`mawashi`) |
| `karate_mawashiempiuchi` | punch | true | same |
| `karate_uke_counter` | punch | true | same |
| `karate_urakenmawashiuchi` | punch | true | same |

### muay_thai (9)

| id | adjudicated | range | range effect |
|---|---|---|---|
| `muay_thai_jorakhe_faad_hang` | kick | false | short band |
| `muay_thai_kradot_thip` | kick | false | short band |
| `muay_thai_mat_wiang_klap` | punch | true | long band (`spin`) |
| `muay_thai_pull_counter` | kick | false | short band |
| `muay_thai_switch_cross` | mixed | true | long band (`kick` in id) |
| `muay_thai_te_khrueng_khaeng` | kick | false | short band (`knee` in id excluded) |
| `muay_thai_thip_khang` | kick | false | short band |
| `muay_thai_thip_mat_te_combo` | kick | false | short band |
| `muay_thai_thip_top` | kick | false | short band |

### pencak_silat (2)

| id | adjudicated | range | range effect |
|---|---|---|---|
| `pencak_silat_sapuan_low` | kick | false | short band |
| `silat_sapuan` | kick | false | short band |

### savate (3)

| id | adjudicated | range | range effect |
|---|---|---|---|
| `savate_direct` | kick | false | short band |
| `savate_direct_double` | kick | false | short band |
| `savate_revers_counter` | punch | true | long band (`revers`) |

Note: all 19 muay_thai knee ids sim-wrong but range-correct (Range excludes `knee`); only `muay_thai_te_khrueng_khaeng` is range-wrong among kicks.

---

## CONSUMERS

Every site that reads a substring kick classifier and what number it moves:

| Site | Lines | Classifier | What moves |
|---|---|---|---|
| `FightSimulation._credit_zone_hit` | `:2081-2091` | `_is_kick` `:2097-2104` | `actor["hits_round"]` zone bucket (`head_hand`, `head_foot`, `body_hand`, `body_foot`, `legs`) — weighted by ruleset zone profile (karate `head_foot`×3 vs `head_hand`×1; taekwondo `head_foot`×3, `body_foot`×2; kickboxing `body_foot`×0.3, `legs`×0.5; muay thai `body_foot`×0.5, `legs`×0.6) |
| `FightSimulation._stance_family` | `:3369-3383` | `_is_kick` `:3377` | Returns `"body_kick"` stance family when kick + body/liver/torso effect keys — feeds initiative / plan bias downstream |
| `FightRange._derived_bands` | `:450-451` | `_is_kick` `:476-483` | `[LONG, MID]` vs `[MID, POCKET]` (or discipline long-game bands) — which separation bands a standing damage technique can be thrown from |
| `RealtimeRoundStats.fold` | `:137-139` | **none** — `REGION_TO_ZONE` only `:61-68` | Always `head_neck`→`head_hand`, `torso_core`→`body_hand`; never reads technique |

Callers of `_credit_zone_hit`: landed strike paths at `:2121` and `:2190`.

---

## THE REALTIME RECORD

**Write path — `FightRealtime.gd` (`:1842-1876`).** A landed strike event carries the technique id:

```gdscript
"region": region,
"contact": contact,
...
"technique": technique_id,
"technique_name": technique_name,
"role": technique_role,
```

(`technique_id` populated at `:1558-1560` from the chosen move before the event dict is built.)

**Read path — `RealtimeRoundStats.gd` (`:131-139`).** On `contact in LANDS`, fold increments `hits_round` using region alone:

```gdscript
var zone: String = str(REGION_TO_ZONE.get(str(event.get("region", "")), ""))
if zone != "":
    hits[zone] = int(hits.get(zone, 0)) + 1
```

The file’s own comment (`:54-60`) states limb is not recoverable: head kicks count as `head_hand`, body kicks as `body_hand`. **`event.get("technique")` is never read.**

**Realtime limb verdict: available at write, absent at fold.** The id is on the log line; `RealtimeRoundStats` ignores it.

**Kickboxing zones never credited on the realtime path** (profile weights from `combat_rulesets.json`):

| Zone | kickboxing weight | muay thai weight | Realtime producible? |
|---|---|---|---|
| `head_hand` | 0.0 | 0.0 | yes (`head_neck`) |
| `head_foot` | 0.0 | 0.0 | **never** — no limb split |
| `body_hand` | 0.1 | 0.2 | yes (`torso_core`) |
| `body_foot` | 0.3 | 0.5 | **never** — torso always `body_hand` |
| `legs` | 0.5 | 0.6 | yes (`left_leg`, `right_leg`, arms mapped to `legs`) |

**Dead weights:** kickboxing `body_foot` (0.3) and muay thai `body_foot` (0.5) are unreachable in realtime scoring. `head_foot` weights are 0.0 in both profiles anyway. Body kicks therefore score at the **`body_hand`** rate (0.1 / 0.2) no matter how hard the profile tries to privilege kicks. Leg kicks can still reach the `legs` bucket when `region` is a leg.

FightRealtime `:302-305` documents the leg-region bug fix (leg targets now populate `legs`); the limb split bug on head/torso remains.

---

## OPTIONS

**(a) Authored limb on each striking node (from Q70/Q77 adjudication), read by all three sites.** Single source of truth: `limb: hand|foot|knee|elbow|…` on catalog nodes or a sidecar keyed by id. `_credit_zone_hit`, `FightRange._derived_bands`, and `RealtimeRoundStats.fold` all consult it. S2 can land per-discipline target regions without re-deriving limb from substrings. One data pass, three consumer edits, checker can assert limb matches census.

**(b) Keep substring classifiers; fix marker lists.** Low touch on consumers, high ongoing drift risk (FightRange comment already falsely claims parity with FightSimulation). Does not fix realtime. Every new technique id/name becomes a whack-a-mole test. S2 commits still cannot trust scorecard zones for kickboxing/muay thai until realtime is also fixed.

**(c) Carry technique id into realtime fold; classify there.** Fixes broadcast/realtime path only; leaves `FightSimulation` and `FightRange` disagreeing with each other and with Q70/Q77. Duplicate classifier logic in a fourth place unless (a) is also done.

**Recommend: (a).** Q70/Q77 already adjudicated every standing strike; the census proves substring classifiers disagree with that ground truth on 40 (sim) and 21 (range) rows today, and realtime ignores limb entirely while kickboxing/muay thai profiles weight `body_foot` above `body_hand`. One authored field is the only fix that aligns Stage A judge, range bands, stance family, and realtime fold for S2’s per-discipline work — without building it here.
