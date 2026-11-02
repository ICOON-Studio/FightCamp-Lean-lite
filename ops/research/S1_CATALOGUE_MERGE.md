# S1 — THE CATALOGUE MERGE: 272 NODES TO 696

Claude, 2026-09-12. R129 measured the merge in a shadow harness and
recommended it. This is the merge itself, promoted to live, plus the four
things the shadow harness could not have found.

---

## 1. WHAT SHIPPED

`technique_catalog.json` v5 → **v6**, 272 nodes → **696**, across the same 15
disciplines. The four researched trees (karate 168 / C95, judo+BJJ 187 / U60B,
muay thai 95 / Q65, boxing+kickboxing 78 / R128) replace the 18-node stubs for
six disciplines; the other nine are untouched.

| discipline | before | after | replaced | added |
|---|---:|---:|---:|---:|
| karate | 18 | 173 | 13 | 155 |
| judo | 18 | 115 | 18 | 97 |
| muay_thai | 18 | 95 | 18 | 77 |
| brazilian_jiu_jitsu | 20 | 72 | 20 | 52 |
| boxing | 18 | 54 | 18 | 36 |
| kickboxing | 18 | 25 | 17 | 7 |
| **TOTAL** | **272** | **696** | | |

**69 of the 272 replaced nodes have different `effects`.** Those are the ones
that change an existing fight rather than adding to it, and they are why
seeded verdicts moved.

---

## 2. THE VOCABULARY WIN, WHICH IS THE POINT OF THE STAGE

Distinct technique ids reaching the screen across 40 seeded bouts per ruleset:

| ruleset | live | merged | |
|---|---:|---:|---|
| boxing | 8 | 15 | +88% |
| kickboxing | 14 | 27 | +93% |
| **muay_thai** | **13** | **41** | **3.2×** |
| mma | 19 | 53 | 2.8× |

Muay thai was firing thirteen distinct techniques across forty bouts. It now
fires forty-one.

**Target mix**, against J20's 61-65 head / 19-23 body / 14-18 leg:

| ruleset | | head | body | leg | KD % |
|---|---|---:|---:|---:|---:|
| boxing | live → merged | 69.5 → **66.4** | 30.5 → 33.6 | 0 → 0 | 42.5 → 32.5 |
| kickboxing | live → merged | 55.7 → **67.3** | 30.0 → 28.6 | **14.3 → 4.1** | 30.0 → 32.5 |
| muay_thai | live → merged | 60.9 → 57.3 | 38.7 → 38.3 | **0.4 → 4.4** | 27.5 → 27.5 |
| mma | live → merged | 55.3 → 57.0 | 35.5 → 37.6 | 9.2 → 5.4 | 25.0 → **40.0** |

Boxing's head share moves 3 points TOWARD the band (69.5 -> 66.4, still just
above 65; kickboxing overshoots it, 55.7 -> 67.3). MMA's knockdown rate lands on
the anchor, 25.0 -> 40.0 against 35.1. Muay thai's legs come off zero for the
first time.

**Kickboxing's legs collapse 14.3% → 4.1%, and that was expected and
accepted before the merge.** R129 attributed it to R128 adding 36 boxing nodes
against 7 kickboxing ones. Q66 tried the obvious repair — promoting four kicks
into tier 2 — and moved the number by 0.03pp (4.41 → 4.38), which is how we
know the tiering was never the cause. R137 found the real one: `kick_damage`
carries no locational substring and the damage/counter fallback has no leg
branch, so 70 of 107 kicks cannot be COUNTED as leg strikes. **That is S2, not
this stage**, and the roadmap gate said to expect ~4% until it lands.

---

## 3. FOUR THINGS THE SHADOW HARNESS COULD NOT HAVE FOUND

R129 measured the merge through `FightMoves.catalog_source_override`. That
path does not boot `CompetitionData`, so none of the following was visible
until the file was actually promoted. **This is the finding worth keeping: a
harness that reads the artefact is not the same as the game loading it.**

### 3.1 424 techniques have no legality research — and it failed all 267 tests

`CompetitionData` requires every technique in `technique_catalog.json` to
carry at least one entry in `technique_legality_matrix.json`. The matrix
researches exactly the original 272. So the merge made
`push_error("Competition research validation failed")` fire at boot and
**every one of the 267 tests failed on the same line.**

Downgraded to a counted warning, not a silent pass:

```
424 of 696 techniques have no researched legality entry (first: bjj_5050)
```

Safe because the schema already anticipated it — `unknown` is in the file's
own `allowed_status_values`; `get_technique_legality` already returns
`status: "unknown"` with a note saying exactly that; and the one consumer that
gates behaviour, `FightSimulation.gd:2513`, bars a technique only when the
status is `illegal`. `is_technique_unconditionally_legal` stays false for
unknown, so nothing can read unresearched as cleared.

**The 424 is now PINNED in `smoke_test`** alongside the 696. Pinning only the
696 would have hidden the gap. If that number ever goes UP, something shipped
unresearched.

### 3.2 The tree validator cannot fail

`validate_technique_nodes.py` builds its allowed vocabulary **by scanning the
catalogue it is about to validate** (`_vocabularies()`, line 66): it seeds
roles from the catalogue's declared `match_roles` and then adds every kind and
role it actually finds. So "all four trees validate clean — validator=OK",
reported by U60B, C95 and Q65 alike, was never evidence of anything. A new
`kind` or `role` cannot fail a gate that learns the vocabulary from the file.

Measured against `TECHNIQUE_CATALOGUE_CONTRACT.md` section 3 instead, which
says `kind` is `move` or `skill` and `match.role` is one of five:

| | pre-merge | merged | rate |
|---|---:|---:|---|
| bad `kind` (all `sequence`) | 39 / 272 | 84 / 696 | 14% → 12% |
| bad `role` | 133 / 272 | 145 / 696 | 49% → **21%** |

Absolute counts rose because the trees are 3-10× bigger; every merged
discipline improved proportionally, and **boxing and muay thai are now at zero
bad roles** (7 → 0 and 5 → 0). The remaining bad roles are `submission` 56,
`counter` 34, `takedown` 29, `adaptation` 19, `escape` 4, `transition` 3.

**Not fixed in this commit, deliberately.** R129 point 3: the merge must not
share a commit with anything else or the two become impossible to tell apart.
The vocabulary remap is its own pass.

### 3.3 The merged BJJ nodes were reachable by nothing

The stage's own summary says "the new judo/BJJ nodes become visible the moment
they land". They were not. The catalogue discipline is `brazilian_jiu_jitsu`
and every ruleset tagged it `bjj`, so R141's 20 orphaned nodes became **72**
the moment the merge landed. Same shape one row along: the `mma` discipline's
18 nodes were unreachable because the mma ruleset tags its seven COMPONENT
disciplines and never `mma` itself.

Fixed additively — `brazilian_jiu_jitsu` added to the `bjj` and `mma`
rulesets, `mma` added to the `mma` ruleset — rather than by renaming the
discipline, which would churn 72 node ids.

**Unreachable nodes: 128 → 90.** The 90 that remain are sanda, savate,
capoeira, arnis and pencak_silat: five disciplines with no ruleset authored at
all. Inert by design, not a defect, and R141 says so.

### 3.4 Two muay thai chains travel the whole range ladder

`muay_thai_teep_knee_chain` (LONG → CLINCH) and `muay_thai_full_spectacle`
(LONG → MID → CLINCH) both failed a rule capping range_band spread at two
ladder steps. The data is right and the rule was too narrow: a teep at long
range into a clinch knee is one muay thai technique.

The exemption is **derived, not whitelisted** — it keys off the `phase_transition`
effect the nodes already declare. Measured over the merged 696: 10 nodes
declare that effect, exactly 2 exceed the spread, and both are in the 10. No
wide node lacks it, so this admits 2 of 696 and cannot silently widen — a node
that wants the exemption has to declare the effect that earns it.

---

## 4. WHAT IS STILL WRONG, NAMED

- **84 `sequence` nodes** should be `kind: move` per contract section 3.
- **145 nodes** carry a role outside the contract five.
- **14 prerequisite cycles**, all in disciplines the merge did not touch
  (wrestling, sanda and friends) plus kickboxing. Pre-merge was 16.
- **424 techniques have no legality research.** Pinned, warned, visible.
- **`brazilian_jiu_jitsu` still has no discipline PROFILE match** — a separate
  index from the ruleset tags, and still warned about at boot.
- **9 cross-discipline prerequisites** (kickboxing requiring boxing) are legal
  and now counted rather than failed.

## 5. THE GATE THAT CAUGHT MOST OF THIS

U64, Cursor's blind contract test, written from the contract while the merge
was being built and run for the first time on both sides of it. Two of its
assertions were stricter than the contract and **both faults were mine** —
they came from the task spec I wrote. It still found 3.1, 3.2 and 3.3.

## Reproducing

```
python Godot/tools/shadow_merge_catalogue.py
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_catalogue_impact.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/technique_catalogue_contract_test.gd
python Godot/tools/check_orphan_disciplines.py
```
