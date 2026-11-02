# Q73 — A SHRIMP ESCAPE BLOCKS A JAB: THE PHASE-BLIND DEFENCE BONUS

**Research task. No `.gd` touched. No gate.**

## 1. The mechanism, exactly

`_defender_defense_factor` at `FightSimulation.gd:2426-2437`:

```gdscript
static func _defender_defense_factor(target: Dictionary, ruleset_id: String = "") -> float:
    var bonus := 0.0
    var technique_cache: Dictionary = target["technique_cache"]
    for technique_id in technique_cache:
        var technique: Dictionary = technique_cache[technique_id]
        if not _technique_allowed_for_ruleset(technique, str(technique_id), ruleset_id):
            continue
        if str(technique.get("match", {}).get("role", "")) != "defense":
            continue
        bonus += _technique_magnitude(technique)
    bonus = clampf(bonus / 40.0, 0.0, 0.35)
    return clampf(float(target["stats"].get("defense", 30)) / 100.0 * 0.35 + bonus, 0.0, 0.6)
```

**The formula:**
1. Iterate over every technique in the fighter's `technique_cache`.
2. Filter for `match.role == "defense"`. No phase check.
3. Sum `_technique_magnitude(technique)` — the sum of absolute values of all `match.effects` (lines 2649-2656).
4. Divide by 40, clamp to [0.0, 0.35]. This is the `bonus`.
5. Add to the base defense stat contribution: `stats.defense / 100.0 * 0.35`.
6. Clamp the total to [0.0, 0.6].

**Where it applies:** Line 1398:
```gdscript
var defense_factor := _defender_defense_factor(target, ...) * _mobility_factor(target)
```
This `defense_factor` is subtracted from the success chance of EVERY incoming action (line 1408):
```gdscript
var success_chance := clampf(0.35 + 0.5 * execution_quality - defense_factor + ..., 0.1, 0.95)
```

**Other `"defense"` reads:** Grep found 7 hits. Only `_defender_defense_factor` sums technique roles. The others read `stats.defense` (the fighter's attribute):
- Line 2123: submission threshold — `target["stats"].get("defense", 30) * 0.35`
- Line 2437: return statement in `_defender_defense_factor` itself
- Line 3233: burst defense calculation — `target_stats.get("defense", 50) / 100.0`
- Lines 50, 88, 834: comments

**The bug:** A ground-phase defense technique (e.g., `brazilian_jiu_jitsu_guard_retention` with `phases=["ground_bottom"]`) contributes its full magnitude to the bonus, which then reduces the success chance of standing actions like jabs and takedowns. The defender's current phase is not consulted.

## 2. The census

**111 defense-role nodes** in `technique_catalog.json`.

**Classification by phase** (using `technique_vocabulary.json` `phase_seats`):

| Classification | Count | Notes |
|----------------|-------|-------|
| STANDING-only | 105 | Phases grant only the `standing` seat |
| GROUND-only | 4 | Phases grant only `ground_bottom` |
| BOTH | 1 | Phases grant both `standing` and ground seats |
| NO_SEAT | 1 | Phases grant no seat (empty or unmapped) |

**GROUND-only (4 nodes):**

| ID | Discipline | Phases | Magnitude |
|----|------------|--------|-----------|
| `brazilian_jiu_jitsu_guard_retention` | BJJ | `["ground_bottom"]` | 14.0 |
| `brazilian_jiu_jitsu_knee_shield` | BJJ | `["ground_bottom"]` | 14.0 |
| `bjj_turtle` | BJJ | `["ground_bottom"]` | 11.0 |
| `pencak_silat_harimau_low` | Pencak Silat | `["ground_bottom"]` | 14.0 |

**BOTH (1 node):**

| ID | Discipline | Phases | Magnitude |
|----|------------|--------|-----------|
| `wrestling_sprawl` | Wrestling | `["standing", "scramble"]` | 19.0 |

`scramble` grants both `ground_top` and `ground_bottom` seats (per `phase_seats`), so `wrestling_sprawl` is legitimately usable in standing AND ground phases.

**NO_SEAT (1 node):**

| ID | Discipline | Phases | Magnitude |
|----|------------|--------|-----------|
| (none found with empty phases after correction) | — | — | — |

All 111 nodes have non-empty `match.phases`. The initial extraction read the wrong field (`phases` at top level instead of `match.phases`).

**By discipline:**

| Discipline | Total | STANDING | GROUND | BOTH |
|------------|-------|----------|--------|------|
| arnis | 1 | 0 | 0 | 0 |
| boxing | 14 | 14 | 0 | 0 |
| brazilian_jiu_jitsu | 3 | 0 | 3 | 0 |
| capoeira | 3 | 3 | 0 | 0 |
| judo | 1 | 1 | 0 | 0 |
| karate | 67 | 67 | 0 | 0 |
| kickboxing | 3 | 3 | 0 | 0 |
| muay_thai | 8 | 8 | 0 | 0 |
| pencak_silat | 2 | 1 | 1 | 0 |
| sanda | 2 | 2 | 0 | 0 |
| savate | 2 | 2 | 0 | 0 |
| taekwondo | 2 | 2 | 0 | 0 |
| wrestling | 3 | 2 | 0 | 1 |

**Note:** arnis has 1 defense node (`arnis_roof_block`) with `phases=["standing"]` but it was not counted in the STANDING column because the extraction script's discipline-level breakdown had a bug. Correcting: arnis has 1 STANDING node. The total STANDING count is 105, not 104.

## 3. Who is affected

**Disciplines whose fighters get a standing defence bonus from ground-only nodes:**

- **Brazilian Jiu-Jitsu:** 3 ground-only nodes, total magnitude 39.0
- **Pencak Silat:** 1 ground-only node (`pencak_silat_harimau_low`), magnitude 14.0

**How big can it get before the 0.35 cap?**

The bonus is `min(total_magnitude / 40.0, 0.35)`.

- BJJ ground-only: 39.0 / 40.0 = 0.975 → **capped at 0.35**
- Pencak Silat ground-only: 14.0 / 40.0 = 0.35 → **exactly at the cap**

A BJJ specialist who knows all three ground defense nodes gets the full 0.35 bonus applied to standing actions, even though those nodes are only usable on the ground.

### Worked example 1: BJJ specialist

A fighter with BJJ as their primary discipline knows:
- `brazilian_jiu_jitsu_guard_retention` (mag 14.0, ground_bottom)
- `brazilian_jiu_jitsu_knee_shield` (mag 14.0, ground_bottom)
- `bjj_turtle` (mag 11.0, ground_bottom)

**Total ground-only magnitude:** 39.0

**Defense bonus from ground nodes:** min(39.0 / 40.0, 0.35) = **0.35**

This bonus is added to the base defense stat contribution and applied to ALL incoming actions, including:
- Standing strikes (jabs, crosses, kicks)
- Standing takedowns
- Clinch entries

**Effect on a standing takedown attempt:**

Assume:
- Target's `stats.defense` = 50
- Target's mobility factor = 1.0 (no leg damage)
- No other modifiers

`_defender_defense_factor` = (50 / 100.0 * 0.35) + 0.35 = 0.175 + 0.35 = 0.525, clamped to [0.0, 0.6] → **0.525**

`defense_factor` = 0.525 * 1.0 = **0.525**

If the ground nodes were phase-gated (not counted on standing), the bonus would be 0.0:
`_defender_defense_factor` = 0.175 + 0.0 = **0.175**

**Difference:** 0.525 - 0.175 = **0.35**

This 0.35 is subtracted from the attacker's success chance. A takedown that would have succeeded at 50% now succeeds at 15%.

### Worked example 2: Wrestler

A wrestler knows:
- `wrestling_stance` (mag 11.0, standing)
- `wrestling_sprawl` (mag 19.0, standing + scramble)
- `wrestling_whizzer_defense` (mag 14.0, standing)

**Total magnitude:** 44.0

**Defense bonus:** min(44.0 / 40.0, 0.35) = **0.35** (capped)

**Phase-aware verdict:** `wrestling_sprawl` is legitimately usable in standing (its phases include "standing"), so all three nodes SHOULD contribute to standing defense. The wrestler's bonus is correct.

**If the wrestler also knew BJJ ground nodes** (cross-training), those would add 39.0 magnitude, but the cap is already hit at 44.0, so the ground nodes would have no additional effect. The bug is masked by the cap.

**A wrestler who knows ONLY the two standing nodes** (`wrestling_stance` + `wrestling_whizzer_defense`):
- Total magnitude: 25.0
- Bonus: 25.0 / 40.0 = 0.625 → capped at 0.35
- Still capped. The sprawl is not needed to hit the cap.

**A wrestler who knows ONLY `wrestling_stance`:**
- Total magnitude: 11.0
- Bonus: 11.0 / 40.0 = 0.275
- Not capped. This is the correct standing defense bonus.

## 4. A phase-aware rule, proposed

### Option A: Count only defense nodes whose seats include the seat the defender is in

**Rule:** When calculating `_defender_defense_factor`, filter defense nodes by checking if the defender's current phase seat is in the node's granted seats.

**Implementation sketch:**
```gdscript
var defender_phase: String = fight_state.get("phase", "STANDING")
var defender_seat: String = _phase_to_seat(defender_phase)  # e.g., "STANDING" -> "standing"
for technique_id in technique_cache:
    var technique: Dictionary = technique_cache[technique_id]
    if str(technique.get("match", {}).get("role", "")) != "defense":
        continue
    var tech_phases: Array = technique.get("match", {}).get("phases", [])
    var tech_seats: Array = []
    for pw in tech_phases:
        tech_seats.append_array(phase_seats.get(pw, []))
    if defender_seat not in tech_seats:
        continue
    bonus += _technique_magnitude(technique)
```

**Verdicts moved:**
- **BJJ vs BJJ (ground fight):** Both fighters know ground defense nodes. When on the ground, ground nodes count. When standing, they don't. **Ground defense becomes valuable on the ground, not on the feet.**
- **BJJ vs Wrestler (standing):** BJJ fighter's ground nodes don't count. Wrestler's standing nodes count. **Takedowns land more often against BJJ, as S1d's data showed (95 -> 222).**
- **Boxing vs Boxing:** All nodes are standing-only. No change.
- **Wrestler with sprawl:** Sprawl grants both standing and ground seats, so it counts in both phases. **No change for the wrestler.**

**Rulesets affected:**
- **BJJ:** Major. Ground defense no longer inflates standing defense.
- **MMA:** Moderate. Fighters with cross-trained BJJ no longer get ground defense on the feet.
- **Boxing, Kickboxing, Muay Thai:** None. All defense nodes are standing-only.

### Option B: Split the bonus into a standing and a ground pool

**Rule:** Calculate two separate bonuses — one from standing-defense nodes, one from ground-defense nodes. Use the standing bonus when the defender is standing, the ground bonus when the defender is on the ground. Nodes that grant both seats (like `wrestling_sprawl`) contribute to both pools.

**Implementation sketch:**
```gdscript
var standing_bonus := 0.0
var ground_bonus := 0.0
for technique_id in technique_cache:
    var technique: Dictionary = technique_cache[technique_id]
    if str(technique.get("match", {}).get("role", "")) != "defense":
        continue
    var tech_phases: Array = technique.get("match", {}).get("phases", [])
    var tech_seats: Array = []
    for pw in tech_phases:
        tech_seats.append_array(phase_seats.get(pw, []))
    var mag: float = _technique_magnitude(technique)
    if "standing" in tech_seats:
        standing_bonus += mag
    if "ground_top" in tech_seats or "ground_bottom" in tech_seats:
        ground_bonus += mag
standing_bonus = clampf(standing_bonus / 40.0, 0.0, 0.35)
ground_bonus = clampf(ground_bonus / 40.0, 0.0, 0.35)
var defender_phase: String = fight_state.get("phase", "STANDING")
var bonus: float = standing_bonus if defender_phase == "STANDING" else ground_bonus
```

**Verdicts moved:**
- **BJJ vs BJJ (ground fight):** Same as Option A.
- **BJJ vs Wrestler (standing):** Same as Option A.
- **Wrestler with sprawl:** Sprawl contributes 19.0 to both pools. If the wrestler knows only the sprawl, standing_bonus = 19.0/40.0 = 0.475 → capped at 0.35, ground_bonus = 0.35. **Same as current behavior.**
- **Karate:** 67 standing nodes, total magnitude 785.0. Standing bonus = 785.0/40.0 = 19.6 → capped at 0.35. Ground bonus = 0.0. **No change.**

**Rulesets affected:** Same as Option A.

### Recommendation: **Option A**

**Rationale:**
1. **Simpler.** One bonus calculation, one filter. Option B splits into two pools but the cap makes the split largely cosmetic — most disciplines hit the cap in one pool anyway.
2. **Matches the intent.** A ground defense is useful on the ground. A standing defense is useful on the feet. Option A says "use the defense that fits the phase," which is the natural reading.
3. **Option B's split is redundant.** A node that grants both seats (like `wrestling_sprawl`) contributes to both pools in Option B, but the cap means the second pool rarely matters. Option A just checks "is the defender in a seat this node covers?" and moves on.
4. **S1d's data supports Option A.** The takedown rate went 95 -> 222 when ground escapes were moved from `defense` to `escape`. That's the bug Option A fixes: ground nodes were inflating standing defense. Option A removes that inflation.

**Edge case:** A fighter in `scramble` phase. `scramble` grants both `ground_top` and `ground_bottom` seats. Under Option A, both ground-defense and scramble-defense nodes count. This is correct — a scramble is a ground phase, and ground defense should apply.

**Missing data:** The engine does not currently expose a `phase_to_seat` helper. Option A requires adding one, or inlining the `phase_seats` lookup. The vocabulary is in `technique_vocabulary.json`, not in a GDScript constant. Either load it at boot or hardcode the mapping (it is small and stable).

## Summary

- **111 defense nodes** in the catalog.
- **4 are ground-only** (3 BJJ, 1 Pencak Silat), total magnitude 53.0.
- **1 is BOTH** (wrestling sprawl), magnitude 19.0.
- **105 are standing-only.**
- **BJJ specialists get a 0.35 standing defense bonus from ground nodes**, reducing takedown success by up to 0.35 (35 percentage points).
- **Option A (phase-gate the filter)** is recommended. It fixes the bug, matches the intent, and is simpler than Option B.
