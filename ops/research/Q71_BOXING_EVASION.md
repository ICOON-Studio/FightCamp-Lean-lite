# Q71 — Boxing can slip now: which nodes, and what the test should derive

## 1. How a guard kind is decided

`FightMoves.gd:918` — `guard_from_node(node)` — classifies every catalogue node
into one of three guard kinds, or rejects it:

1. **Role gate.** `match.role` must be in `DEFENSE_ROLES = ["defense", "adaptation"]`.
   Anything else (damage, setup, counter, control) returns `{}` immediately.
2. **Effect scan.** Iterates the keys of `match.effects` with strict precedence
   **EVADE > BLOCK > FOOTWORK**:
   - EVADE effects: `evasion`, `angle_exit`, `distance_read`, `range_control`
   - BLOCK effects: `guard`, `block`, `coverage`, `low_kick_defense`,
     `check_readiness`, `throw_damage_reduction`, `guard_control`,
     `guard_recovery`, `grip_control`
   - FOOTWORK effects: `mobility`, `first_step`, `boundary_control`,
     `opponent_mobility`, `angle_attack`, `angle_entry`
   - An EVADE-match fires immediately (`break`). BLOCK is sticky once set.
     FOOTWORK only fills an empty slot.
3. **Stance gate.** `_stances_for(match.phases)` must be non-empty. `standing`
   maps to STANCE_STANDING; anything ending in `clinch` maps to STANCE_CLINCH;
   `ground*`/`scramble`/`takedown`/`grounded_opponent` map to STANCE_GROUND.
4. **Default arsenal.** `guards_for` (line 949) includes a node only if
   `tier <= DEFAULT_ARSENAL_MAX_TIER` (which is **2**, line 300) when the
   athlete has no `technique_progress` record.

A node that passes all four gates becomes a guard dictionary with keys
`{id, name, role, tier, kind, bands, stances}`. `answering_guards` (line 984)
then strips FOOTWORK guards from the pool that answers blows in flight.

## 2. Every boxing node the engine classifies as a guard

54 nodes in the boxing discipline. 21 carry role `defense` or `adaptation`.
Of those, 19 produce a non-empty guard (two — `boxing_breathing_rhythm` with
effects `{rhythm, timing}` and `boxing_distance_read` with role `setup` — do
not). The full table:

### Tier 1–2 (default arsenal)

| id | name | tier | role | effects | kind |
|---|---|---|---|---|---|
| boxing_stance_guard | Stance and High Guard | 1 | defense | guard, coverage | **block** |
| boxing_parry | Parry | 1 | defense | block, counter_open | **block** |
| boxing_catch | Catch the Jab | 1 | defense | block, guard | **block** |
| **boxing_slip** | **Slip** | **1** | **defense** | **evasion, counter_open** | **evade** |
| boxing_pivot_footwork | Ring Pivot | 2 | adaptation | mobility, angle_attack | footwork |
| boxing_block_elbow | Elbow and Forearm Block | 2 | defense | block, coverage | **block** |
| **boxing_roll** | **Roll Under** | **2** | **defense** | **evasion, angle_exit** | **evade** |
| **boxing_bob_weave** | **Bob and Weave** | **2** | **defense** | **evasion, entry_open** | **evade** |
| **boxing_pull** | **Pull** | **2** | **defense** | **evasion, counter_open** | **evade** |

`boxing_pivot_footwork` is footwork — `answering_guards` filters it out before
the blow is answered. The four **bold** nodes are the new evade-kind guards in
the default arsenal.

### Tier 3+ (trained only)

| id | name | tier | role | effects | kind | stance |
|---|---|---|---|---|---|---|
| boxing_shoulder_roll | Shoulder Roll | 3 | defense | evasion, counter_open | evade | standing |
| boxing_long_guard | Long Guard | 3 | defense | guard, range_control | evade | standing |
| boxing_rope_work | Working Off the Ropes | 3 | defense | evasion, boundary_control, guard | evade | standing |
| boxing_pivot_out | Pivot Out of the Clinch | 3 | defense | angle_exit, clinch_control, mobility | evade | clinch |
| boxing_forearm_frame | Forearm Frame | 3 | defense | clinch_control, block | block | clinch |

Note: `boxing_long_guard` has `guard` (BLOCK) AND `range_control` (EVADE). The
engine's iteration hits `guard` first (kind = block), then `range_control`
fires the EVADE break — **evade wins**. This is correct precedence, not a
misclassification: the Long Guard is a defensive distance tool.

### Not guards (defense/adaptation role but no matching effect)

| id | tier | role | effects | why not |
|---|---|---|---|---|
| boxing_breathing_rhythm | 1 | defense | rhythm, timing | neither word is in any effect list |

### Not guards (role outside DEFENSE_ROLES)

`boxing_slip_counter` (tier 2, role `counter`) — confirmed: a counter is an
attack, not a guard. The test's original comment was right about this node.
Same for `boxing_catch_counter`, `boxing_check_hook`, `boxing_pull_counter`,
`boxing_check_hook_pivot`, `boxing_counter_over_jab` (all role `counter` or
`damage`).

## 3. Are the tier 1–2 evade nodes genuine boxing evasions?

| node | real evasion? | why |
|---|---|---|
| boxing_slip | **yes** | The fundamental boxing head movement — move the head off the centre line to let a straight punch pass. |
| boxing_roll | **yes** | Roll Under — rotate the torso to let a hook pass over the shoulder. Core boxing evasion. |
| boxing_bob_weave | **yes** | Bob and weave — dip under and redirect. One of the first defensive patterns taught. |
| boxing_pull | **yes** | Pull back — step or lean back to take a punch short. Basic distance management. |

**All four are genuine boxing evasions. No node is misclassified.** The
catalogue now carries what a boxer actually does when he defends.

## 4. The assertion S2 should write instead

The two failing assertions pin a DATA FACT that has changed:

- Line 448-449: `_eq_i(boxing_kinds["evade"], 0, "shoulder roll is tier 3")`
- Line 505-506: `_eq_i(kinds["evade"], 0, "shoulder roll is tier 3 and slip_counter is a counter")`

Both are wrong. The catalogue now has four tier 1-2 evade nodes.

### What to assert instead

**Derive the expectation from the catalogue at run time**, so the next
re-authoring cannot strand it:

```
# Pseudo-code (not GDScript):
# "A ruleset produces a named guard kind in bouts if and only if its
#  tier 1-2 default arsenal contains a guard-kind node of that kind."

func expected_guard_kinds(ruleset_id: String) -> Array:
    var arsenal: Array = FightMoves.guard_arsenal({}, ruleset_id)
    var kinds: Dictionary = {}
    for guard in arsenal:
        if guard["kind"] != "footwork":
            kinds[guard["kind"]] = true
    return kinds.keys()
```

Then the test becomes:

```
for id in ["boxing", "mma", "kickboxing", "muay_thai"]:
    var expected_kinds: Array = expected_guard_kinds(id)
    # ... run bouts, collect guard_kinds ...
    for kind in expected_kinds:
        _check(kinds.get(kind, 0) > 0,
            "%s: '%s' is in the default arsenal and actually occurs" % [id, kind])
    # No kind outside the derived set should occur either:
    for kind in kinds:
        _check(expected_kinds.has(kind),
            "%s: '%s' occurred but is NOT in the default arsenal" % [id, kind])
```

This makes the test **derive its own answer from the catalogue** — when a
discipline gains or loses an evade node, the expectation moves with it.

### The other rulesets' pinned expectations

| ruleset | test expects | catalogue actually allows (tier 1-2) | stale? |
|---|---|---|---|
| boxing | ["block"] | block, **evade** | **YES** — the two assertions above |
| mma | ["block", "evade"] | block, evade (from boxing + own disciplines) | no |
| kickboxing | ["block", "evade"] | block, evade (from boxing + kickboxing) | no |
| muay_thai | ["block", "evade"] | block (muay_thai_stance t1), evade (muay_thai_slip t2, muay_thai_pull_back t2) | no |

**Only boxing is stale.** The other three rulesets' expectations match what
their catalogues' own guard nodes allow.

## Summary

- Boxing now has **4 tier 1-2 evade nodes**: slip, roll, bob_weave, pull.
- All four are genuine boxing evasions — no misclassification.
- `boxing_slip_counter` remains a counter (attack), not a guard — the test's
  comment about it was and is correct.
- The two assertions pinning `evade == 0` for boxing are the fixture being
  wrong, not the fight.
- The other three rulesets (mma, kickboxing, muay_thai) still match their
  expectations.
- S2 should replace the hard-coded expectations with a catalogue-derived
  check so re-authoring cannot strand the test again.
