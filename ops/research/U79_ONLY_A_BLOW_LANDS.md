# U79 — Only a blow lands: footwork the realtime engine throws as a strike

S2's ruleset sweep (`tools/measure_ruleset_sweep.gd --detail`, commit `acfa4a8`) logged
catalogue nodes as **landed strikes** when they are reads, steps and circles. This census
covers every node `FightMoves.move_from_node` admits for the four realtime rulesets
(boxing, kickboxing, muay thai, MMA): **121 admitted**, **113 deliver a blow**, **8 do
not**. Zero rows overrule Q70 or Q77 — their verdicts stand on every node they judged.

## THE ADMISSION RULE

`FightMoves.move_from_node` (`Godot/scripts/FightMoves.gd:568-592`) admits a catalogue
node as a throwable strike when **all** of the following hold:

1. `match.role` is in `STRIKE_ROLES` — `["setup", "damage", "counter"]` (`:87`).
2. **None** of `match.effects` keys appear in `GRAPPLE_EFFECTS` (`:109-123`).
3. `match.phases` is non-empty and not weapon-only (`:577-579`, `_stances_for`).
4. At least one legal target region resolves (`:580-582`, `_regions_for`).

```gdscript
# FightMoves.gd:568-582 (abridged)
static func move_from_node(node: Dictionary, region_weights: Dictionary) -> Dictionary:
    var match_data: Dictionary = node.get("match", {})
    var role: String = str(match_data.get("role", ""))
    if not STRIKE_ROLES.has(role):
        return {}
    var effects: Dictionary = match_data.get("effects", {})
    for effect_value in effects:
        if GRAPPLE_EFFECTS.has(str(effect_value)):
            return {}
    # ... stances and regions must resolve ...
```

The comment above `GRAPPLE_EFFECTS` (`:96-108`) records the same class of defect caught
once for duck-unders and sprawls: **role alone is not enough**. Footwork was never caught
because its effect keys (`distance_read`, `mobility`, `range_control`, `first_step`) are
not in `GRAPPLE_EFFECTS` — and **cannot be added there without collateral damage**:

| Effect key on a non-blow | Real strikes that carry the same key |
|---|---|
| `range_control` | `boxing_jab`, `kickboxing_teep`, `muay_thai_teep`, +8 more kicks/pushes |
| `mobility` | `boxing_check_hook_pivot` (a hook that lands) |
| `distance_read` | `boxing_drawing` is a non-blow, but `counter_open` + `timing` blows also use reads |
| `angle_attack` | `boxing_lead_hook`, `boxing_overhand`, `kickboxing_hook_kick`, +2 |
| `counter_open` | seven counters that deliver contact (`boxing_slip_counter`, etc.) |

**An effect key is not a verdict.** `range_control` sits on `boxing_jab` (a punch) and on
`boxing_distance_read` (a read); `mobility` sits on `boxing_check_hook_pivot` (a hook) and
on `boxing_circle_lead` (a step). A key-based refusal list is exactly what let footwork
through.

## DEFAULT ARSENAL

`DEFAULT_ARSENAL_MAX_TIER := 2` (`FightMoves.gd:312`). Fighters with no
`technique_progress` — every generated opponent and every seeded test fighter — know every
admitted tier 1–2 node. **Five of those are non-blows** and enter the realtime palette on
every bout:

| id | tier | rulesets that draw it |
|---|---|---|
| `boxing_distance_read` | 1 | boxing, kickboxing, muay thai, MMA |
| `boxing_step_in_out` | 1 | boxing, kickboxing, muay thai, MMA |
| `boxing_circle_lead` | 2 | boxing, kickboxing, muay thai, MMA |
| `boxing_circle_rear` | 2 | boxing, kickboxing, muay thai, MMA |
| `kickboxing_switch_step_read` | 2 | kickboxing, muay thai, MMA |

Three more non-blows sit at tier 3–4 (`boxing_angle_step`, `boxing_drawing`,
`boxing_switch_stance`) and only appear when a fighter has explicit progress — but the
five above are universal.

## WHAT CHANGES

*Inference only — no bouts were run in U79. S2 landed counts are from
`measure_ruleset_sweep.gd --detail`.*

### Non-blow share by realtime ruleset

| ruleset | admitted nodes | non-blows | share |
|---|---:|---:|---:|
| boxing | 31 | 7 | 22.6% |
| kickboxing | 48 | 8 | 16.7% |
| muay thai | 101 | 7 | 6.9% |
| mma | 121 | 8 | 6.6% |

Kickboxing and MMA inherit boxing footwork through shared `discipline_tags`; muay thai
inherits boxing but not kickboxing's switch-step read.

### S2 phantom landings (boxing sample, 24 bouts)

| id | S2 landed count |
|---|---:|
| `boxing_distance_read` | 877 |
| `boxing_step_in_out` | 369 |
| `boxing_circle_rear` | 365 |
| `boxing_circle_lead` | 336 |
| `kickboxing_switch_step_read` | 404 (kickboxing sample) |

These four boxing footwork nodes alone account for **~one fifth** of boxing's landed-strike
total in S2's sample — invisible to a green suite because the engine records them as
head/body landings like punches.

### Pace (J20 D1)

J20 anchors combined significant-strike pace at **~6–8 landed per fight-minute** (D1);
the engine was recently measured at **2.26× real pace**. Removing the ~20% phantom
landings from boxing footwork would cut boxing's landed tally by roughly that fraction
(**INFERENCE: ~15–20% of boxing landed events**). That moves D1 in the right direction
but does not close the full 2.26× gap — other inflation sources remain.

### Target mix

S2 logged footwork landings on **heads and bodies** as if they were punches. Removing the
eight non-blows would **raise the share of genuine strikes** in the head/torso buckets and
slightly **depress the apparent accuracy** of real punches (fewer phantom "hits" mixed
in). Leg-share is unaffected — none of the eight non-blows target legs.

### Scorecards

Realtime judging credits landed strikes. Phantom footwork landings inflate effective-strike
counts and round margins for fighters who spam tier-1 reads and steps — especially
`boxing_distance_read`, which S2 logged 877 times in 24 boxing bouts.

## OPTIONS

Three repair paths, none built here:

### (a) Authored `delivers_blow` on `match`, read by `move_from_node`

Add a boolean (default `true` for backward compatibility) that `move_from_node` checks
before emitting a move. Each of the eight non-blows is flagged `false`; every real strike
stays admitted. **Pros:** precise, no collateral; catalogue authors see the verdict beside
the node. **Cons:** 121 nodes need auditing once; new nodes must set the field. Seeded
tests that count landed events (`measure_ruleset_sweep`, pace harnesses) would drop
footwork from strike totals; palette-size tests unchanged.

### (b) Second refusal list beside `GRAPPLE_EFFECTS` for footwork keys

Refuse nodes whose effects match footwork patterns (e.g. `distance_read` without damage
keys, or `mobility` without damage keys). **Would get wrong:**

| candidate rule | non-blows caught | real blows wrongly refused |
|---|---:|---:|
| `distance_read` without damage keys | 3/8 | 0 |
| `mobility` without damage keys | 5/8 | 1 (`boxing_check_hook_pivot`) |
| `range_control` without damage keys | 2/8 | 9 (`boxing_jab`, all teeps, …) |

No single key rule reproduces all eight verdicts; a compound rule still misclassifies at
least one hook and nine range-setting kicks/pushes.

### (c) Change non-blow nodes' roles to `defense` / non-strike roles

Footwork nodes would leave `STRIKE_ROLES` and never enter `move_from_node`. **Pros:** no
new field. **Cons:** role is read elsewhere — `POWER_ROLES` (`:94`), FightMetric
significance, AI move selection weights, and any UI that groups by role. Changing
`boxing_distance_read` from `setup` to `defense` may silence it from strike pickers but
also from legitimate setup sequencing if other systems key off role. Seeded tests that
assert palette membership by role would move.

### Recommendation: **(a)**

Only an explicit per-node `delivers_blow` flag reproduces all 121 verdicts with zero false
positives. Effect keys cannot serve as a proxy (the trap above); role changes have wider
blast radius than (a).

## Q70 / Q77 overrulings

**None.** All 74 Q77 rows and 45 Q70 kick rows are accepted as-is. The two U79-authored
rows (`mma_guard_gnp`, `mma_elbow_gnp`) were outside Q77's standing-strike census; both
deliver ground contact blows.
