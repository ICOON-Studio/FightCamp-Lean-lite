# CAN THE ENGINE PERFORM ALL THE SKILLS IT HAS? MEASURED

Claude, 2026-09-16, answering the operator's question of the same day: *"We need to make the engine being able to
perform all skills and movement right?"* It is checkable rather than arguable, and nobody had checked it.

Instrument: `Godot/tools/probe_technique_coverage.gd`. No production file is touched.

## POPULATION

Two men differentiated INSIDE each ruleset and legal for it, neither missing a technique it permits (operator rules
2026-09-12): **A** 183 cm reach, striker attributes; **B** 176 cm reach, grappler attributes — the same shape
`probe_leg_share.gd` uses. 20 seeds per ruleset, four rulesets, ~44,600 action beats.
Catalogue: `assets/data/technique_catalog.json`, **696 nodes across 15 disciplines**.

## THE HEADLINE: THE PICKER IS FINE. THE PALETTE IS NOT.

| ruleset | discipline nodes | throwable palette | distinct thrown | picker coverage |
|---|---:|---:|---:|---:|
| boxing | 54 | 13 (+1 passive) | 13 | **100.0%** |
| mma | 415 | 51 (+3 passive) | 52 | **102.0%** |
| kickboxing | 79 | 24 (+2 passive) | 24 | **100.0%** |
| muay_thai | 149 | 39 (+1 passive) | 39 | **100.0%** |

**Every technique a fighter is handed, the engine throws.** Not one is unreachable once it is in the palette. (MMA's
52nd is `mma_guard_gnp`, which comes from the separate `grapple_arsenal` — a second palette this probe does not count,
not a defect.)

**A MEASUREMENT THAT WOULD HAVE BEEN WRONG.** The first version of this probe pooled `kind: "skill"` nodes into the
denominator and reported boxing at 92.9% with `boxing_distance_read` "unreachable". A `skill` is PASSIVE — a read, a
sense of distance — and is never meant to appear as an action. Counting passives as throwable makes a working engine
look broken.

## THE REAL DEFECT: FIVE TIER 1-2 BOXING MOVES NEVER REACH ANY PALETTE

Coverage against the palette has a blind spot: a node `move_from_node` refuses is dropped **before any fight starts**,
so it can never show up as "never thrown". Checking the catalogue directly:

| ruleset | tier 1-2 throwable nodes that never reach a palette |
|---|---|
| boxing | **5** — `boxing_double_jab`, `boxing_feint`, `boxing_jab_body`, `boxing_pivot_footwork`, `boxing_rear_uppercut` |
| kickboxing | the same 5, plus `kickboxing_switch_kick` |
| muay_thai | the same 5 |
| mma | the same 5, inside 91 rows that are mostly BJJ ground nodes served by `grapple_arsenal` — **not counted as a finding here** |

**A rear uppercut, a body jab and a double jab are not exotic. They are core boxing, and no fighter in this game has
ever thrown one.**

### THE CAUSE, EXACTLY

`FightMoves.GRAPPLE_EFFECTS` (`FightMoves.gd:114`) contains **`chain_open`** and **`entry_open`**. Four of the five
carry exactly those, and `move_from_node` refuses a standing node whose effects it reads as grappling:

| node | role | effects |
|---|---|---|
| `boxing_rear_uppercut` | damage | `damage`, **`chain_open`** |
| `boxing_double_jab` | setup | `range_control`, `combo_open`, **`entry_open`** |
| `boxing_jab_body` | setup | `body_damage`, `combo_open`, **`entry_open`** |
| `boxing_feint` | setup | **`entry_open`**, `distance_read` |

The control is in the same table: `boxing_lead_uppercut` carries `combo_open` — which is NOT in `GRAPPLE_EFFECTS` — and
is thrown 577 times in kickboxing alone. The only difference between a lead uppercut that works and a rear uppercut
that does not is one word in a list.

**The fifth, `boxing_pivot_footwork`, is NOT explained by this** — its effects are `mobility` and `angle_attack`,
neither of which is in `GRAPPLE_EFFECTS`. Its role is `adaptation`, which no other refused node uses. **Separate
cause, not yet diagnosed.** Same for `kickboxing_switch_kick`.

## WHAT IS AND IS NOT A DEFECT HERE

- **NOT a defect:** palette 13 of 54 in boxing. Tiers and learning gate a fighter's arsenal on purpose, and a man with
  no `technique_progress` record gets his ruleset's tier 1-2 set (`FightMoves.gd:191`). A fighter is not supposed to
  know everything. **But it does mean every measurement this project has ever taken exercised a quarter of the
  catalogue at most** — a trained fighter with a full record has never been simulated.
- **The concentration is healthy:** the top five techniques are 47.6% of boxing throws, 33.1% of kickboxing, 28.5% of
  MMA and **13.6% of muay thai**. A palette that resolves to three moves ninety per cent of the time would be covered
  and still not a fighter; this is not that.

## Open

1. **The one-word fix moves every seeded pin in the project.** Five new techniques entering every striking palette
   changes technique selection, which changes every seeded trajectory. Its own slice, its own switch, its own
   re-baseline — never folded into another stage.
2. `boxing_pivot_footwork` and `kickboxing_switch_kick` have a second, undiagnosed cause.
3. **Nobody has ever simulated a fighter with a full `technique_progress` record.** Whether the engine holds up with a
   40-technique palette instead of 13 is untested, and it is the population the actual game will run.
4. The MMA row's 91 needs the grapple palette counted before any of it is called a finding.

## Re-running it

```
godot --headless --path Godot --script tools/probe_technique_coverage.gd -- seeds=20
```
