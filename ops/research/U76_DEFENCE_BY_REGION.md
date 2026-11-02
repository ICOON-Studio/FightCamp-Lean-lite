# U76 — Which regions each striking defence answers

Adjudication of 103 catalogue defence nodes whose effect keys answer `strike`
(S1e class filter). Each row names the target regions the technique physically
answers — never inferred from the effect key alone (`block` on `boxing_parry`
is head; on `kickboxing_kick_check` is leg).

## Per-discipline coverage

| Discipline | Nodes | Head | Body | Leg | All three |
|------------|------:|-----:|-----:|----:|----------:|
| arnis | 1 | 1 | 0 | 0 | 0 |
| boxing | 14 | 12 | 10 | 2 | 1 |
| capoeira | 3 | 3 | 3 | 1 | 1 |
| karate | 62 | 24 | 40 | 38 | 32 |
| kickboxing | 3 | 1 | 3 | 2 | 1 |
| muay_thai | 8 | 4 | 6 | 3 | 1 |
| pencak_silat | 1 | 1 | 1 | 1 | 1 |
| sanda | 2 | 1 | 1 | 1 | 1 |
| savate | 2 | 1 | 1 | 1 | 1 |
| taekwondo | 2 | 0 | 1 | 1 | 1 |
| **Total** | **103** | **79** | **83** | **52** | **42** |

Head-only defences (slips, parries, jodan blocks) dominate boxing and muay
thai evasion. Karate contributes the bulk of stance/`distance_read` nodes that
answer all three regions. Leg-specific nodes are kick checks, gedan blocks,
`savate_lowline_read` and `karate_sukuiuke`.

## CONSUMERS

### FightSimulation — `_defender_defense_factor` (lines 2602–2618)

Today sums every defence node in `technique_cache` whose phases match the
defender's seat and whose effect keys answer the incoming `role` class via
`_defense_answers` (lines 2624–2629). It receives `target`, `ruleset_id`,
`seat_phases` and `incoming_role` — **not** the strike's target region.

To consume per-node `answers`, the call at line 1440 would need the incoming
strike's target region passed in, and the loop at 2605–2616 would filter:
`if not region in node_answers: continue`. The region must be known before
this factor is applied.

### FightMoves — `guard_arsenal` / `answering_guards` (lines 968–996)

`guard_arsenal` builds guard dicts from catalogue nodes via `guard_from_node`
(kind: block/evade/footwork; bands; stances). `answering_guards` drops
footwork guards from the in-flight pool. Neither function receives a target
region today.

FightRealtime picks a guard at lines 1637–1639:

```gdscript
var guard: Dictionary = Moves.guard_select(
    Moves.answering_guards(
        Moves.live_set(target.get("guards", []), guard_band, stance)), guard_roll)
```

The incoming blow's `region` is already chosen at line 1561 (from the
attacker's technique). To consume `answers`, `answering_guards` (or a wrapper)
would need `(live, region)` and filter guards whose catalogue node lists that
region. `guard_from_node` would need to carry an `answers` array (or read it
from the catalogue at selection time).

## ORDER OF OPERATIONS

### FightSimulation

Defence factor is taken **before** the target region is chosen:

```gdscript
# line 1440 — defence factor (region-blind today)
var defense_factor := _defender_defense_factor(target, str(fight_state.get("ruleset_id", "")), _allowed_catalog_phases(fight_state, target), role) * _mobility_factor(target)
# ...
# line 1476 — target region chosen AFTER the landed roll
target_region = _technique_target_region(technique, role, rng, actor.get("plan_bundle", {}))
```

A defence cannot answer a region that has not been chosen yet. **Fix:** move
`_technique_target_region` (and its rng draw) to before line 1440, pass
`target_region` into `_defender_defense_factor`, and filter nodes by `answers`.
The region roll already happens before the landed roll (comment at 1469–1472
says it is picked upfront for analytics); only its *position in the function*
needs to move. **Random draws:** if `_technique_target_region` uses the same
`rng` sequence, moving it earlier consumes the same draws in a different order
relative to `execution_roll` (line 1456) — the bout would diverge unless the
region draw is split to a dedicated stream or re-seeded. Safer path: choose
region first with a draw taken before `execution_roll`, then apply defence
filter, then land roll — net +0 draws if region currently shares the main rng
after execution_roll (it does not today; region is after). Moving region
before execution_roll adds zero draws; reordering relative to execution_roll
changes determinism and needs a migration note.

### FightRealtime

Region is chosen at line 1561 (`region = str(chosen["region"])`) inside the
attacker's technique pick, **before** the defender's guard draw at lines
1636–1639. Order is already correct: region exists when guards are filtered.
Only the filter is missing — `answering_guards` does not receive `region`.
**Random draws:** adding a region filter to the guard pool changes which guard
`guard_select` returns but does not add draws.

## OPTIONS

### (a) Per-node `answers` list in the catalogue

Add an `answers: ["head", ...]` field to each defence node's `match` block
(or a sibling key). Pros: respects the trap — `boxing_parry` and
`kickboxing_kick_check` share `block` but answer different regions. Cons:
103 nodes to author and keep in sync; duplicates the adjudication in
`U76_defence_regions.json` until merged.

### (b) Per-key region list in `technique_vocabulary.json`

Add `defense_regions: {block: [head, body], evasion: [head], ...}` beside
`defense_answers`. Pros: one edit per effect key. Cons: **fails the trap** —
`block` cannot mean head on a parry and leg on a shin check from a single key
mapping. Would force splitting keys or accepting wrong cross-region answers.

### (c) Leave defence region-blind

Keep `_defense_answers` class-only (strike vs takedown). Pros: no schema or
ordering change; deterministic bouts unchanged. Cons: a slip continues to
discount leg kicks; kick checks discount jabs — the defect S2's explicit
targets were meant to expose. Defensible only as a holding position until
region data ships.

### Recommendation: **(a)**

Region is a property of the **node**, not the effect key. Option (a) matches
how S1e fixed action-class blindness per node. Ship `answers` on each
catalogue defence node (this research file is the draft), wire
`_defender_defense_factor` and `answering_guards` to filter on it, and move
`_technique_target_region` before the defence roll in FightSimulation.
