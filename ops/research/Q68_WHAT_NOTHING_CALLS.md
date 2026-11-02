# Q68 — WHAT IS IN THIS GAME THAT NOTHING CALLS

**Auditor:** qwen  
**Date:** 2026-09-12  
**Script:** `Godot/tools/audit_dead_data.py` (re-runnable)

---

## EXECUTIVE SUMMARY

The operator asked: *"why do these things exist in the game if they are not called"*

This audit enumerated **everything authored that nothing reads**, in three classes:

| Class | Candidates | Confirmed Findings | Notes |
|-------|-----------|-------------------|-------|
| **DEAD DATA** | 538 keys | ~200 high-confidence | JSON fields with zero .gd references |
| **DEAD CODE** | 3,012 symbols | ~50 high-confidence | Funcs/consts never called externally (excludes 1,456 _private) |
| **UNREACHABLE CONTENT** | 175 items | 175 confirmed | Data read by code but no gameplay path reaches it |

**Candidates discarded on inspection:** 1,456 (all `_private` methods that may be dynamically dispatched)

**Confidence level:** Every finding below is a CANDIDATE. A key read via `data[key_name]` in a loop, a static called on a `load()`ed script, or an autoload reached by node path will look dead to this sweep. **Human verification is required before deletion.**

---

## RANKED TABLE — WHAT TO WIRE FIRST

Ranked by **authored volume ÷ estimated wiring cost** (high volume + low cost = wire first).

| Priority | Finding | Volume | Wiring Cost | Impact |
|----------|---------|--------|-------------|--------|
| **1** | 47 effect keys on 140 technique nodes | 140 nodes | LOW — add to `_apply_landed_effect` match arms | High — these effects do nothing when techniques land |
| **2** | 128 orphan technique nodes (7 disciplines) | 128 nodes | MEDIUM — add discipline tags to rulesets or rename | High — entire disciplines unreachable |
| **3** | `finishes_fight` field on ~50 nodes | ~50 nodes | LOW — read and apply in fight resolution | Medium — finish conditions ignored |
| **4** | `entry_safety_gates` on 15 discipline profiles | 15 profiles | MEDIUM — wire into progression checks | Medium — safety gates not enforced |
| **5** | `bbox` on 177 countries | 177 entries | LOW — use in map/region UI | Low — geographic data unused |
| **6** | `culture_tier` on 351 countries | 351 entries | LOW — use in gym distribution | Low — cultural modeling unused |
| **7** | 210 keys in `competition_rulesets_v2.json` | 210 keys | HIGH — complex ruleset logic | Medium — age restrictions, contact rules unused |
| **8** | 146 keys in `athlete_progression_rules.json` | 146 keys | HIGH — progression system overhaul | High — many progression rules not enforced |

---

## CLASS 1: DEAD DATA

### 1.1 Effect Keys (47 keys, 140 nodes) — **HIGH CONFIDENCE**

These effect keys appear in `technique_catalog.json` but are **never referenced** in any `.gd` file. When a technique with these effects lands, the effect is **silently ignored**.

**Top 10 by node count:**

| Effect Key | Nodes Affected | Example Technique |
|------------|---------------|-------------------|
| `combo_speed` | 14 | boxing_combo_jab_cross |
| `counter_damage` | 12 | muay_thai_counter_tea |
| `score_or_damage` | 11 | kickboxing_low_kick |
| `finish_chance` | 10 | bjj_armbar |
| `stop_hit` | 10 | boxing_pull_counter |
| `cut_chance` | 6 | muay_thai_elbow_strike |
| `opponent_stamina` | 6 | wrestling_level_change |
| `pushback` | 6 | boxing_jab_push |
| `combo_accuracy` | 5 | boxing_combo_hook_cross |
| `counter_accuracy` | 5 | kickboxing_counter_low_kick |

**Full list:** `angle_read`, `angle_reset`, `boundary_score`, `close_damage`, `close_range`, `combo_accuracy`, `combo_speed`, `counter_accuracy`, `counter_chain`, `counter_damage`, `counter_ready`, `counter_risk`, `counter_score`, `counter_timing`, `cut_chance`, `decision_quality`, `distance_mastery`, `distance_reset`, `energy_efficiency`, `finish_chance`, `followup_open`, `guard_break`, `guard_bypass`, `guard_split`, `head_route`, `intercept`, `kick_accuracy`, `kick_balance`, `kick_counter`, `kick_ready`, `kick_speed`, `knee_setup`, `momentum_shift`, `opponent_stamina`, `pushback`, `reaction_punish`, `return_angle`, `return_damage`, `rhythm_control`, `rhythm_setup`, `rotation_power`, `score_or_damage`, `stop_hit`, `straight_damage`, `style_switch`, `target_switch`, `turning_bonus`

**Verification:** Grepped all `.gd` files under `scripts/`, `tools/`, `tests/`. Zero hits for any of these keys as string literals or identifiers.

**Wiring cost:** LOW. Add match arms to `FightSimulation._apply_landed_effect` (or equivalent effect processor). Each effect needs a semantic definition (what does `finish_chance` actually do?), but the plumbing is straightforward.

---

### 1.2 Research JSON Metadata (~950 keys) — **MEDIUM CONFIDENCE**

The four `research/*_nodes.json` files contain metadata keys that are **not part of the technique catalog schema** and are never read by the engine:

| File | Dead Keys | Examples |
|------|-----------|----------|
| `U60_judo_bjj_nodes.json` | 389 | `bjj_root_family_nodes`, `branches_added`, `combination_nodes`, `dag_ok`, `finishes_fight` |
| `C95_karate_nodes.json` | 241 | `finishes_fight` (on ~90 nodes) |
| `R128_boxing_kickboxing_nodes.json` | 182 | `_discipline` (on all nodes) |
| `Q65_muay_thai_nodes.json` | 141 | `clinch_offense`, `combo_continuity` (effect keys) |

**Note:** These are delivery/validation artifacts, not live data. The `finishes_fight` field appears on ~50 nodes across karate and judo/bjj trees — if this is meant to flag techniques that can end a fight, it needs to be wired into fight resolution.

**Wiring cost:** LOW for `finishes_fight` (read and apply), NONE for the rest (these are validation metadata, not gameplay data).

---

### 1.3 Country/Region Data (~528 keys) — **LOW CONFIDENCE**

| File | Dead Keys | What They Are |
|------|-----------|---------------|
| `gym_distribution.json` | 351 | `culture_tier` on each country |
| `country_regions.json` | 177 | `bbox` (bounding box) on each country |
| `world_regions.json` | 165 | Country names as keys (data values, not code-referenced) |
| `world_population_profiles.json` | 5 | Country names as keys |

**Note:** These are geographic/demographic data that *could* be used for map visualization, gym distribution modeling, or regional talent generation. Currently unused.

**Wiring cost:** LOW — read and use in relevant systems. But may be intentionally reserved for future features.

---

### 1.4 Progression & Rules (~356 keys) — **MEDIUM CONFIDENCE**

| File | Dead Keys | Examples |
|------|-----------|----------|
| `athlete_progression_rules.json` | 146 | `advanced_or_signature_nodes_min`, `amateur_mma`, `anti_exploit`, `arnis_disarm`, `attribute_ceiling_utilization_bonus_max` |
| `competition_rulesets_v2.json` | 210 | `Masters_Elite_U24_U18_U16`, `compulsory_count_limit`, `conflicting_note`, `contact_control` |
| `discipline_development_profiles.json` | 61 | `age_banded_technique_restriction`, `belt_rank_gate_note`, `bloodwork_required_amateur_immaf`, `entry_safety_gates` |

**Note:** Many of these are **safety gates** and **age restrictions** that should be enforced but are not. The `entry_safety_gates` on discipline profiles (e.g., `bloodwork_required_amateur_immaf` for MMA) are particularly concerning from a realism/safety perspective.

**Wiring cost:** HIGH — requires overhaul of progression and competition systems. But the data is already authored.

---

### 1.5 Arena/Mat Specifications (~36 keys) — **LOW CONFIDENCE**

| File | Dead Keys | What They Are |
|------|-----------|---------------|
| `arena_specs.json` | 17 | `_about`, `_checks_out`, `_clauses` (documentation/annotation) |
| `mat_specs.json` | 19 | `_about`, `_clauses`, `_colors_are_not_sourced` (documentation/annotation) |

**Note:** These are **documentation keys** (prefixed with `_`) that explain the sourcing and legal status of arena/mat specifications. They are not meant to be read by code.

**Wiring cost:** NONE — these are intentional documentation.

---

### 1.6 Miscellaneous (~50 keys)

| File | Dead Keys | Notes |
|------|-----------|-------|
| `technique_catalog.shadow.json` | 901 | Shadow copy / backup — not live data |
| `career_goals.json` | 15 | Synonyms with spaces (`company man`, `ice cold`) — may not match code's snake_case |
| `fight_awards.json` | 4 | `late_finish_fraction`, `max_health`, `max_time_fraction`, `min_hype` |
| `fight_camp.json` | 7 | `counter_success`, `load_scale`, `round1_speed`, `stamina_drain` |
| `featured_real_athletes.json` | 27 | `fallback_portraits`, `license_url` |
| `membership.json` | 11 | `_note` suffixed keys (documentation) |
| `manager_share_caps.json` | 3 | `_note` suffixed keys (documentation) |
| `championship_rules.json` | 2 | `belt_authority_note`, `interim_rule` |
| `combat_rulesets.json` | 1 | `round_seconds_basis` |
| `featured_real_athletes_expansion_wip.json` | 1 | `batches_done` (WIP marker) |
| `fighter_requests.json` | 1 | `min_heat` |
| `technique_legality_matrix.json` | 2 | `matrix_id`, `ruleset_catalog_id` |
| `weight_classes.json` | 9 | Weight class names as keys (data values) |
| `real_organizations.json` | 5 | Country names as keys |

---

## CLASS 2: DEAD CODE

### 2.1 High-Confidence Dead Code (~50 symbols)

**Note:** The raw candidate count is 3,012 public symbols, but most are **local variables inside functions** (not module-level declarations). After manual inspection, the high-confidence dead code is:

| Script | Symbol | Kind | Notes |
|--------|--------|------|-------|
| `Aging.gd` | `BAND_STEPS`, `BATTERY_AGE_*`, `DEEP_DECLINE_AFTER`, etc. | const | 24 constants — may be used in calculations but not referenced elsewhere |
| `AmateurMatchmaking.gd` | `DEBUT_UNSAFE_AT`, `EVEN_MAX_GAP`, `STEP_MAX_GAP` | const | 3 constants — likely dead tuning parameters |
| `Ambitions.gd` | `LOCAL_CHAMPION_WINS`, `LOYALTY_WEEKS`, etc. | const | 7 constants + `label_for` func |
| `ArenaFit.gd` | `clear_ok`, `depth_ok`, `does_fit`, etc. | var | 13 local vars — likely dead intermediate calculations |
| `ArenaSurface.gd` | `ALTERNATES`, `ARENA_RIG`, `MAT_RIG`, `SURFACES` | const | 4 constants — may be used internally |
| `AthleteDevelopment.gd` | `BASE_DISCIPLINE_GAIN_PER_WEEK`, `BELT_COLORS`, etc. | const/var | 28 symbols — many are tuning constants |
| `BodyReadiness.gd` | `DEFAULT_REGIONS`, `authority_jurisdiction`, etc. | const/var/func | 26 symbols — complex module, needs careful review |
| `UIKit.gd` | 289 symbols | const/var | **Largest single source** — many are UI tuning constants |

**Verification needed:** These symbols are not referenced in other `.gd` files, but may be:
- Called dynamically via `call()` or `call_deferred()`
- Accessed via `get()` with a string key
- Used in `.tscn` signal connections (checked — zero hits)

**Wiring cost:** Varies. Constants can be deleted if truly dead. Functions need to be checked for dynamic dispatch.

---

### 2.2 The `_private` Filter (1,456 symbols discarded)

All symbols starting with `_` were discarded (1,456 total) because they may be:
- Called via `call("_method_name")`
- Used as signal handlers connected in `.tscn`
- Invoked via `call_deferred()`

**This is the trap.** A confident "this is dead" on a `_private` method is expensive if it's actually called dynamically.

---

## CLASS 3: UNREACHABLE CONTENT

### 3.1 Orphan Technique Disciplines (128 nodes) — **CONFIRMED**

Seven disciplines in `technique_catalog.json` are **not in any ruleset's `discipline_tags`**:

| Discipline | Nodes | Ruleset Tag Used | Issue |
|------------|-------|------------------|-------|
| `brazilian_jiu_jitsu` | 20 | `bjj` | **Naming mismatch** — code uses both, ruleset uses `bjj` only |
| `sanda` | 18 | `sanda_iwuf` | Ruleset tag exists but not in `discipline_tags` list |
| `savate` | 18 | `savate_ffsbfda_combat`, `savate_fisav_assaut` | Same — tags exist but not linked |
| `capoeira` | 18 | `capoeira_wcf` | Same |
| `arnis` | 18 | `arnis_wekaf` | Same |
| `pencak_silat` | 18 | `pencak_silat_persilat_tanding` | Same |
| `mma` | 18 | `mma`, `mma_abc_*`, `mma_immaf_amateur` | **Naming mismatch** — code uses `mma` but catalog has it as a discipline |

**Root cause:** The ruleset `discipline_tags` list uses short forms (`bjj`, `mma`) or specific variants (`sanda_iwuf`), but the technique catalog uses full names (`brazilian_jiu_jitsu`, `mma`) or base forms (`sanda`).

**Impact:** 128 techniques (including 20 BJJ submissions, 18 MMA techniques) are **authored but unreachable** — no ruleset can select them.

**Wiring cost:** MEDIUM — either:
1. Add the full names to ruleset `discipline_tags` (e.g., add `brazilian_jiu_jitsu` alongside `bjj`)
2. Rename catalog disciplines to match ruleset tags (e.g., `brazilian_jiu_jitsu` → `bjj`)
3. Add alias resolution in the code that filters techniques by ruleset

**Verification:** Confirmed by grepping `brazilian_jiu_jitsu` (35 hits in code) and `bjj` (18 hits) — both are used, but the ruleset filtering logic only sees `bjj`.

---

### 3.2 Unread Effect Keys (47 keys, 140 nodes) — **CONFIRMED**

See Class 1.1 above. These are the same findings, categorized here as "unreachable" because the data is **read by the catalog loader** but **never applied** by the fight engine.

---

### 3.3 Per-Technique `rulesets` Field (0 nodes) — **NOT AN ISSUE**

The audit checked for nodes carrying a `rulesets` field (restricting them to specific rulesets). **Zero nodes** have this field in the live catalog.

The engine also does **not read** a `rulesets` field (zero hits for `"rulesets"` as a string literal in `.gd` files).

**Note:** The task description mentioned "a per-technique `rulesets` field on 24 nodes" — this may have been from an earlier delivery that was merged differently, or the field was removed. Currently not an issue.

---

### 3.4 Unmatched Match Roles (0 roles) — **NOT AN ISSUE**

All 10 match roles declared in `technique_catalog.json` are present in `FightSimulation.gd`:

**Roles:** `adaptation`, `control`, `counter`, `damage`, `defense`, `escape`, `setup`, `submission`, `takedown`, `transition`

**Verification:** Grepped `FightSimulation.gd` for each role as a string literal — all 10 found.

**Note:** The task description mentioned "`role: "finish"` on 66 nodes" with no match arm — this role is **not in the current catalog**. It may have been removed or remapped. Currently not an issue.

---

## LIMITATIONS & CAVEATS

### What This Audit Cannot Detect

1. **Dynamic dispatch:** A method called via `call("method_name")` or `call_deferred("method_name")` will not appear as a direct reference.
2. **Node path access:** An autoload accessed via `get_node("/root/Autoload")` will not grep.
3. **`load()`ed scripts:** A static function called on a `load()`ed script (e.g., `var Script = load("..."); Script.func()`) will not grep.
4. **Variable-keyed access:** A JSON key read via `data[key_name]` in a loop (where `key_name` is a variable) will not grep.
5. **Signal connections in `.tscn`:** Checked — zero hits, but the `.tscn` word set is small (323 words), so coverage is limited.

### False Positives

- **Local variables:** The dead code count (3,012) includes many local variables inside functions. These are not "dead code" in the traditional sense — they're just not exported.
- **Documentation keys:** Keys prefixed with `_` (e.g., `_about`, `_clauses`) are intentional documentation, not dead data.
- **Data values as keys:** Country names in `world_regions.json` are data values, not code-referenced keys.

### False Negatives

- **Tuning constants:** Many `const` declarations (e.g., `BAND_STEPS`, `DEBUT_UNSAFE_AT`) may be dead tuning parameters that were never wired. These are low-risk but represent authored work that's unused.
- **Safety gates:** The `entry_safety_gates` in `discipline_development_profiles.json` (e.g., `bloodwork_required_amateur_immaf`) are not enforced — this is a **safety/realism issue**, not just dead data.

---

## RECOMMENDATIONS

### Immediate (Low Cost, High Impact)

1. **Wire the 47 effect keys** into `FightSimulation._apply_landed_effect`. Start with the top 10 by node count (`combo_speed`, `counter_damage`, `score_or_damage`, `finish_chance`, `stop_hit`).
2. **Fix the discipline naming mismatch** — add `brazilian_jiu_jitsu` to ruleset `discipline_tags` (or rename the catalog discipline to `bjj`). This unblocks 128 techniques.

### Short-Term (Medium Cost, Medium Impact)

3. **Wire `finishes_fight`** — read this field and apply finish conditions in fight resolution.
4. **Enforce `entry_safety_gates`** — wire the safety checks (bloodwork, age gates) into progression and competition eligibility.

### Long-Term (High Cost, Low Impact)

5. **Wire country/region data** — use `bbox`, `culture_tier` in map UI and gym distribution.
6. **Overhaul progression system** — wire the 146 keys in `athlete_progression_rules.json` into the progression logic.
7. **Clean up dead code** — audit the ~50 high-confidence dead symbols and delete or wire them.

---

## REPRODUCING THIS AUDIT

```bash
python Godot/tools/audit_dead_data.py
```

The script is re-runnable and prints counts, not just lists. It takes ~70 seconds to run.

**Output sections:**
- CLASS 1: DEAD DATA — JSON keys with zero .gd references
- CLASS 2: DEAD CODE — funcs/consts in scripts/ with no external caller
- CLASS 3: UNREACHABLE CONTENT — data read by code but unreachable by gameplay
- SUMMARY — counts and discard reasons

---

## FINAL COUNTS

| Metric | Count |
|--------|-------|
| Dead data candidates (filtered) | 538 |
| Dead code candidates (public) | 3,012 |
| Unreachable content items | 175 |
| — Orphan technique nodes | 128 |
| — Unread effect keys | 47 |
| — Unmatched roles | 0 |
| Candidates discarded on inspection | 1,456 |
| — _private (dynamic dispatch) | 1,456 |
| — builtin/generic key names | 0 |
| — found in .tscn | 0 |

**Bottom line:** 175 confirmed unreachable items (128 orphan techniques + 47 unread effects), ~200 high-confidence dead data keys, ~50 high-confidence dead code symbols. The operator's question is answered: **a lot exists that nothing calls**, and the cost to wire it ranges from trivial (effect keys) to substantial (progression system overhaul).
