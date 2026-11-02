# S1c — ONE VOCABULARY: THE CONTRACT WAS THE THING THAT WAS WRONG

Claude, 2026-09-12. Branch `claude/s1-catalogue-merge`.

S1c was scoped as *"fold six legacy roles into the contract five, expect a full
fight rebaseline, re-pin every seeded card."* **That was the wrong job.** The
measurement below says the contract's five-role vocabulary cannot express what
the engine does, and that authoring against it had already deleted judo.

---

## 1. THE FINDING

**`match.role` is not a label. It is the physics selector.**
`FightSimulation._apply_landed_effect` (`:2062`) is a `match` on `role` with no
default arm:

| role | what landing it does |
|---|---|
| `damage` / `counter` | subtracts health, credits the zone, sets first initiative |
| `takedown` | **sets `phase = "GROUND"`**, records `top_side`, counts the throw, prices its class against the ruleset's scoring profile, and **can declare an IPPON that ends the bout** |
| `control` | control score, stamina drain, position points from the top |
| `submission` | accumulates a submission attempt against the technique id |

A role with no arm applies **nothing** on land. So a role is a behaviour, and
`takedown` → `damage` is not a rename — it is the removal of every ground
transition and every ippon the technique could produce.

### What the merge actually did

|  | master | S1 branch |
|---|---:|---:|
| nodes | 272 | 696 |
| judo `takedown` | 8 | **0** |
| muay thai `takedown` | 2 | **0** |
| nodes carrying a `takedown` EFFECT whose role is not `takedown` | 4 | **87** |

**Judo ended with zero takedowns.** `judo_osotogari`, `judo_uchimata`,
`judo_seoinage` — each authored `"effects": {"takedown": N, "throw_setup": M}`
with `"role": "damage"`. An uchi-mata did health damage and left both men
standing. Eight of those nodes **were** `role: takedown` on master and were
regressed by the merge; the other 75 were newly authored that way.

### Why no gate caught it

`validate_technique_nodes.py` derived its allowed vocabulary **from the
catalogue it validates** (R136). Every role a delivery invented became legal the
moment it was merged. The contract test carried a five-role list the catalogue
had never obeyed, so its role and kind checks had been softened to **rate
ceilings of 21% and 13%** — a gate that permits a fifth of the catalogue to be
invisible to the fight.

This is the repo's own most expensive lesson, twice in one file: a hardcoded
vocabulary goes stale and agents edit good data to satisfy it; a derived one
agrees with whatever it is shown and can never say no.

---

## 2. THE RULING

**ROLES — ten, and `finish` is deleted.**

```
damage  setup  defense  control  counter
takedown  submission  transition  escape  adaptation
```

These are the words the engine dispatches on. `finish` was in the contract, in
zero nodes, and in zero code sites (U65: `roles_never_read=finish`) — and because
the `match` has no default arm, a `finish` technique would have landed and
applied nothing. The corner emphasis `"finish"` at `FightSimulation.gd:718` is a
pace call, not a role.

**KINDS — three. `sequence` is real.**

```
move  skill  sequence
```

The contract test's own comment read *"`sequence` stays a violation: 84 of them,
and they want remapping."* The engine fires a chain **only** on
`kind == "sequence"`, at seven sites. Remapping those 82 nodes to `move` would
have stopped every combination in the game from firing. **A sequence is the
chain; its links are `move`**, which is what `FightSimulation.gd:1561` and
`combo_chains_test` already require. Contract §10's worked example, which gave a
combination `"kind": "move"`, is corrected.

**There is no fight rebaseline**, because the vocabulary did not move — it was
restored to what the engine always implemented.

---

## 3. THE REPAIR DERIVES

`Godot/tools/derive_technique_roles.py`. A node's role becomes `takedown` when,
and only when:

1. its `effects` contain the literal key `takedown`, **and**
2. `takedown` is its single strongest effect by absolute value — no tie, **and**
3. its `kind` is not `skill` (a skill is a capability, never thrown).

Every input is read off the node itself. **No list of which techniques are
throws exists anywhere** — a hand-typed list is what drifts when the next
delivery lands.

**80 nodes repaired**: 77 judo throws, `muay_thai_chapko_sweep_throw`,
`bjj_ankle_pick`, `mma_clinch_knee_trip`.

**Seven left alone on purpose**, because the author weighted something else
higher and that judgement is theirs: `bjj_arm_drag` (back_control 8 > takedown
5), `karate_komanage` and `karate_udewa` (arm_isolation 12 > takedown 10),
`sanda_full_chain`, `sambo_strike_bodylock`, `silat_offbalance_chain` (phase
transitions), and `muay_thai_chapko_lang` (`kind: skill`).

**The rule is ONE-DIRECTIONAL and must stay that way.** A `takedown` effect
implies the role; the converse does not. Seven nodes carry role `takedown` with
no `takedown` effect — savate's `coup_bas`, capoeira's `rasteira`, silat's
`sapuan` — because a sweep is authored with `sweep` and `balance_break`.
Symmetry would strip the role off seven legitimate takedowns.

**Known debt not repaired here:** `judo_uranage_counter` carries `counter_throw`
and `throw_damage` but no literal `takedown`, so it stays `damage`. Widening the
rule to the other throw keys is a second rule with its own adjudication.

---

## 4. THE GATES THAT REPLACE THE CEILINGS

**The 21% and 13% rate ceilings are gone. `bad_roles` and `bad_kinds` are hard
zeros**, and the catalogue passes at zero.

**The chain-integrity check now runs.** It was gated on `kind == "combination"`
— a kind **no node has ever carried** — so the one check that validates a
chain's links had never executed once. It fires on `sequence` now: 82 chains,
`bad_combos=0`.

**The vocabulary is authored, in `assets/data/technique_vocabulary.json`**, and
the validator reads that instead of its own subject. Proven to reject: a
delivery carrying `role: finish` and `kind: combination` now exits 1 naming both,
where before it would have passed and taught the gate two new words.

**Three places hold the vocabulary, and any single edit goes red:**

| # | where | checked against |
|---|---|---|
| 1 | `assets/data/technique_vocabulary.json` | read by the delivery validator |
| 2 | `VALID_ROLES` / `VALID_KINDS` literals in `technique_catalogue_contract_test.gd` | asserted against (3) |
| 3 | `match_roles` inside `technique_catalog.json` | the catalogue's own declaration |

Changing the vocabulary deliberately means changing all three, on purpose.

---

## Reproducing

```
python Godot/tools/derive_technique_roles.py          # report only, exits 1 if dirty
python Godot/tools/derive_technique_roles.py --apply
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_catalogue_contract_test.gd
python Godot/tools/run_tests.py
```

---

## 5. THE SAME DEFECT IS IN A THIRD FIELD, AND IT IS BIGGER THAN BOTH — `phases`

**NOT FIXED HERE. Deliberately.** Found while triaging the suite, recorded with
its evidence so the next stage starts from a measurement.

`FightSimulation.gd:82-83`:

```gdscript
const GROUND_TOP_CATALOG_PHASES := ["ground_top", "scramble"]
const GROUND_BOTTOM_CATALOG_PHASES := ["ground_bottom", "scramble"]
```

What the catalogue actually carries:

| phase | nodes |
|---|---:|
| `ground` | **128** |
| `scramble` | 13 |
| `ground_top` | **12** |
| `ground_bottom` | **2** |

So on the ground, the eligible set is 25 nodes out of 140+. **All 70 of BJJ's
ground techniques are tagged plain `ground` and are therefore invisible from both
top and bottom** — present in the cache, valid against every gate, and never
thrown. That is precisely the `IGNORED` class U65's census named as the dangerous
one, and it is why `fight_plan_explainer_test` reports a learned Armbar with
`excluded_phase: 4` and an empty move list.

**Two other consumers already read it correctly**, which is what makes this a
defect rather than a design choice:

- `FightRange.gd:70` — `GROUND_PHASES` includes `"ground"`.
- `FightMoves.gd:601` — `phase.begins_with("ground")`.

Only `FightSimulation`'s two constants keep their own narrower copy.

**The fix is almost certainly to add `"ground"` to both constants** — a node
tagged plain `ground` is unspecified as to top or bottom, so it belongs in both,
the way an armbar is legal from mount and from guard.

**Why it is not in this commit.** It makes 128 nodes eligible where they were
not, across every grappling tree at once, and that moves seeded verdicts
substantially. The operator ruled on 2026-09-12 that catalogue changes go in PER
DISCIPLINE so a red suite names the tree that caused it; landing this as a
one-line sweep at the end of a vocabulary stage would break that ruling on the
day it was made. It needs its own stage, its own measurement, and BJJ first.
