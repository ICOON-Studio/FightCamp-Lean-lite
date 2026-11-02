# S18 — THE TRAINING MODIFIER MAPS DISAGREED, AND ONE TAG TRAINED NOTHING

Claude, 2026-09-19. R147 page-3 item **1**, the top of the list the operator
ordered on 2026-09-19 (*"then the rest as per the pdf"*). Item 6
(durability/chin) shipped ahead of it as S17.

---

## 1. R147 CALLED THIS "2 LINES IN `MODIFIER_TO_STAT`". IT WAS TWO BUGS IN TWO MAPS

`R147_ATTRIBUTES_AND_GAPS.md:151` reads *"`grappling -> grapple`,
`speed -> speed` in `MODIFIER_TO_STAT` — 2 lines"*. Measured on disk, the
vocabulary lived in **two separate hand-maintained copies** that had drifted in
**opposite directions**:

| tag | `GameState.TRAINING_MODIFIER_STAT` (:166, drives the real gain) | `AthleteStatModel.MODIFIER_TO_STAT` (:67, drives the caption) |
|---|---|---|
| `grappling` | present → `grapple` | **absent** |
| `speed` | **absent** | **absent** |

Which is two different defects, and the single-map edit R147 describes fixes
only one of them:

1. **`speed` trained nothing at all — a gameplay defect.**
   `arnis_safety_kit` carries `["technique", "speed", "defense"]`. The literal
   `speed` tag fell through `TRAINING_MODIFIER_STAT.get(tag, "")` and was
   `continue`d at `GameState.gd:4481`. The station advertised a stat it never
   moved.
2. **`grappling` trained correctly and was never captioned — a presentation
   defect.** `modular_combat_mat`, `judo_tatami_area` and `grappling_dummy`
   really do raise `grapple`; `canonical_stats_for_modifiers` (`:270`) could
   not see the tag, so the always-visible caption under-reported all three.

**Both failures were silent.** An unmapped tag resolves to `""` and is skipped,
never reported — which is exactly how a map could drift for as long as this one
did.

## 2. THE FIX IS ONE MAP, NOT FOUR KEYS

The root defect was two copies of one vocabulary, so adding the missing keys to
both would have left the next drift to happen. **`AthleteStatModel.MODIFIER_TO_STAT`
is now the single source and `GameState.TRAINING_MODIFIER_STAT` is an alias of
it:**

```gdscript
const AthleteStatModel := preload("res://scripts/AthleteStatModel.gd")
...
const TRAINING_MODIFIER_STAT := AthleteStatModel.MODIFIER_TO_STAT
```

The merge was clean, and the task file's guess about why was wrong in a way
worth recording: it said *"`GameState.gd` reaches it today — check how before
assuming"*. **It did not reach it at all** — `grep -n 'AthleteStatModel'
Godot/scripts/GameState.gd` returned nothing before this stage. The merge is
safe for a different reason: `AthleteStatModel` is a plain `RefCounted` whose
only dependency is `StatWords.gd`, and **neither file mentions `GameState`**, so
the new `preload` cannot close a cycle. `GameState` already preloads ~40 sibling
scripts this way. (S14's lesson again: check the binding, not the brief.)

Each map now carries a comment naming the other and stating which one to edit.

## 3. WHAT THE `speed` KEY ACTUALLY CHANGES — MEASURED, NOT ASSERTED

`_apply_focus_stat_gains` de-duplicates by **canonical stat**, not by tag
(`"strength"+"power"` must pay out once per session, not twice), so a new key is
inert only when it collides with a stat already trained. **`speed` does not
collide — it is a third stat**, so `arnis_safety_kit`'s payout really moves.

`Godot/tools/probe_arnis_speed_gain.gd`, one starter athlete, one day
(`fraction` 1/7), coach 70, tier 1, condition 100 — both figures off the same
code path and the same athlete:

| stat | base | pre-S18 | now | delta |
|---|---|---|---|---|
| technique | 31.000 | +0.0849 | +0.0849 | +0.0000 |
| speed | 40.000 | **+0.0000** | **+0.0849** | **+0.0849** |
| defense | 33.000 | +0.0849 | +0.0849 | +0.0000 |
| **total** | | **0.1697** | **0.2546** | **+50.0%** |

**And the shape of that table is the point** (S14's relabel lesson, run the
other way): `technique` and `defense` do not move at all, and `speed` moves from
*exactly* zero. That is the signature of a stat that genuinely was not being
trained — not of an accounting change, and not of the de-duplication guard being
tripped into a double payout.

## 4. R147's ITEM 2 DOES NOT REPRODUCE — NO CODE WRITTEN FOR IT

R147 lists *"physical focuses ignore `station_legal_for_discipline` — ~5 lines"*
as item 2. **It is not true of this tree.** `PROGRAM_WORK_FOCUSES` is
`["ring", "bags", "strength", "cardio"]` (`GameState.gd:4513`) — the "physical"
focuses are not a separate path, they go through the same three call sites as
the rest, and every one applies the check:

- `:4609` — an explicitly chosen station, guarded only by `focus != "recovery"`.
- `:4620` — the auto-pick loop, `continue`s on an illegal station.
- `:4694` — the options list, where `legal` is computed with the same
  `category == "recovery"` exemption, surfaced as `illegal_reason`, and legal
  stations are sorted first.

Those are the only three callers of `station_legal_for_discipline` in the tree.
Either R147 meant a path that does not exist, or the defect was fixed between
R147 and today. **Item 2 is closed with no change; the list moves to item 3
(`trains_regions` on equipment).**

## 5. THE ONE THING THAT IS AN ASK, NOT A DECISION

**`balance`** — on `judo_tatami_area`
(`["technique", "balance", "defense", "grappling"]`), one use in the whole
catalogue — is in **neither** map, is covered by **no ruling**, and is not
obviously any of the seven `STAT_KEYS`. It was **not** decided here. It is
carried explicitly in `AWAITING_OPERATOR_RULING` in the test (see §6) so it
neither fails the gate nor gets forgotten, and it is put to the operator with
the two candidates that seem plausible:

- **`defense`** — balance as staying upright and defending a throw. The station
  already lists `defense` separately, so this would collapse into a tag that is
  already there and pay out nothing new.
- **`technique`** — balance as a skill of the discipline. Same collision: the
  station already lists `technique`.

**Which is why it is worth asking rather than guessing.** Under the
de-duplication rule, mapping `balance` to either of those two is *provably
inert* for the only station that carries it — it would change no number
anywhere. The options that would actually do something are `speed` (agility and
footwork, where balance sits in the existing map's company: `agility`, `rhythm`)
or leaving it deliberately unmapped like the recovery family. **There is also a
standing fact that bears on it and is not a ruling about this tag:** *"Balance
is a STATE and it IS directional"* (operator, on disk) — which points away from
balance being a training stat at all.

## 6. THE GUARD IS THE DELIVERABLE

`Godot/tests/training_modifier_map_test.gd`, 5 checks:

1. **The two maps agree, key for key** — and on every value. They are one
   constant today; this is what stops a later session making them two again.
2. Every mapped value is a real `GameState.STAT_KEYS` entry.
3. The two S18 regressions pinned by name: `speed` → `speed`,
   `grappling` → `grapple`.
4. **No catalogue tag falls through both maps.** Every `training_modifiers` tag
   in `equipment_catalog.json` must be a trained stat, a known recovery-family
   word (`AthleteStatModel.RECOVERY_ONLY_MODIFIERS`, absent on purpose — that
   gear cuts fatigue instead of growing a stat), or the one tag awaiting a
   ruling. **A new tag added to the catalogue now fails the suite instead of
   being skipped in silence.**
5. The caption builder itself emits `grapple` for `judo_tatami_area` — checking
   the map is not checking its reader.

**The guard was verified to fail, not just to pass.** Removing
`"grappling": "grapple"` from the one map turned three of the five checks red
and named all three affected stations:

```
FAIL: the `grappling` tag is not captioned - the three ring grapple stations under-report again
FAIL: catalogue tags train nothing and are not recovery gear ...: ["grappling (on modular_combat_mat)", "grappling (on judo_tatami_area)", "grappling (on grappling_dummy)"]
FAIL: judo_tatami_area's modifiers still caption without grapple: ["technique", "defense"]
training_modifier_map_test: 5 checks, 3 failures
```

Catalogue coverage as it stands: 24 distinct tags over 69 uses — 15 train a
stat, 8 are recovery-family, 1 (`balance`) awaits the ruling.

**AND THERE IS NO THIRD COPY — CHECKED, BECAUSE TWO WAS THE WHOLE BUG.**
`grep -rn 'training_modifiers' Godot/scripts Godot/scenes` finds exactly three
readers: `GameState` (the gain, plus the `combinations` combo-tightness check),
`AthleteStatModel` (the caption) and
`TechniqueTrainingCoordinator._item_tags:541`. The third is **not** another map
— it folds the raw tag strings in beside `discipline_tags` as equipment
capability tags for technique requirements, and never consults either map, so
this stage cannot reach it. **It is worth knowing anyway:** a tag added to the
catalogue has a second effect there, independent of whether it trains a stat.

## 7. FILES

- `Godot/scripts/AthleteStatModel.gd` — `MODIFIER_TO_STAT` is now the single
  source (+`speed`, +`grappling`); new `RECOVERY_ONLY_MODIFIERS`.
- `Godot/scripts/GameState.gd` — new `AthleteStatModel` preload;
  `TRAINING_MODIFIER_STAT` is an alias, not a copy.
- `Godot/tests/training_modifier_map_test.gd` — new, the guard.
- `Godot/tools/probe_arnis_speed_gain.gd` — new, the before/after measurement.
- `Godot/assets/data/equipment_catalog.json` — **unchanged**, as the task
  required while `balance` is open.

## 8. TEST COMMAND

```
python Godot/tools/run_tests.py --only training_modifier_map
```
