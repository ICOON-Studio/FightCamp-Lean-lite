# R129 — WHAT MERGING THE TECHNIQUE TREES DOES TO THE FIGHT

Claude, 2026-09-12. The operator asked for the shadow merge and the comparison
before committing to anything. This is it.

**Nothing was merged.** `assets/data/technique_catalog.shadow.json` is written and
the live file is untouched.

---

## 1. THE MERGE, MEASURED

| discipline | before | after | replaced | added |
|---|---:|---:|---:|---:|
| boxing | 18 | 54 | 18 | 36 |
| brazilian_jiu_jitsu | 20 | 72 | 20 | 52 |
| judo | 18 | 115 | 18 | 97 |
| karate | 18 | 173 | 13 | 155 |
| kickboxing | 18 | 25 | 17 | 7 |
| muay_thai | 18 | 95 | 18 | 77 |
| **TOTAL** | **272** | **696** | | |

**69 of the 272 replaced nodes have different `effects`** — those are the ones
that change an existing fight rather than adding to it.

**The blast radius is tier 1 and 2**, because `FightMoves` says every fighter
without a `technique_progress` record — *"every fighter in every seeded test and
every generated opponent"* — knows exactly his disciplines' tier 1 and 2.

| ruleset | tier 1+2 before | after | delta |
|---|---:|---:|---:|
| boxing | 10 | 29 | **+19** |
| kickboxing | 20 | 41 | +21 |
| muay_thai | 8 | 37 | **+29** |
| mma | 56 | 137 | **+81** |

**A muay thai fighter's palette goes from 8 techniques to 37.** This is not a data
tidy; it is a behaviour change, and it will move seeded verdicts by design.

---

## 2. WHAT I CANNOT HONESTLY COMPARE, SAID FIRST

**D1 (pace) and D2 (accuracy) as measured here are NOT comparable to J20's
anchors, and the numbers below should not be read as "the engine is slow" or
"the engine is too accurate".**

J20's anchors are **significant strikes attempted and landed**. What this harness
counts is **presented beats** — and `FightBeatAdapter` presents ONE beat per
window, already selected for being worth showing. Pace reads ~1.6–1.7 per fighter
per minute against a 2.8–3.8 anchor, and accuracy reads ~82% against 40–49%.
**Both are artefacts of the denominator, not findings about the fight.** A real
D1/D2 check has to count at the tick layer, not the presentation layer, and that
is a separate job.

**What IS comparable** are the ratios *within* landed strikes — the head/body/leg
mix (D3) — and the share of bouts carrying a knockdown (D5). Those are computed
over the same population in both runs.

`palette` also printed 0.00 in both columns: `FightMoves.arsenal` returns empty
when handed empty `region_weights`. A tool bug, not a finding — `distinct ids` is
the better measure and it worked.

---

## 3. THE UNAMBIGUOUS WIN: VOCABULARY THAT ACTUALLY FIRES

Distinct technique ids reaching the screen across 40 seeded bouts:

| ruleset | live | shadow | |
|---|---:|---:|---|
| boxing | 8 | 15 | +88% |
| kickboxing | 14 | 24 | +71% |
| **muay_thai** | **5** | **26** | **5.2×** |
| mma | 21 | 52 | 2.5× |

**Muay thai was firing FIVE distinct techniques across forty bouts.** That is the
number that most justifies the merge. The engine had the vocabulary of a
one-trick fighter because the catalogue gave it eight tier-1/2 nodes.

---

## 4. THE TARGET MIX: ONE REAL IMPROVEMENT, ONE REAL REGRESSION

Anchors: **61–65% head / 19–23% body / 14–18% leg.**

| ruleset | | head | body | leg |
|---|---|---:|---:|---:|
| boxing | live → shadow | 69.5 → **66.4** | 30.5 → 33.6 | 0 → 0 |
| kickboxing | live → shadow | 55.7 → **63.6** | 30.0 → 32.0 | **14.3 → 4.4** |
| muay_thai | live → shadow | 47.2 → 51.7 | 51.9 → **40.1** | **0.9 → 8.2** |
| mma | live → shadow | 53.0 → 54.5 | 38.1 → 39.3 | 9.0 → 6.2 |

**GOOD — muay thai's legs.** 0.9% → 8.2%, moving hard toward the 14–18% band.
Legs were the engine's known miss (3.2% league-wide against a 14–18% anchor) and
this is the first thing that has moved them. Muay thai's body share also falls
from an absurd 51.9% toward the band.

**GOOD — kickboxing's head share** lands inside the band at 63.6%, from 55.7%.

**BAD, AND THIS IS THE ONE TO FIX BEFORE MERGING — kickboxing's legs collapse
from 14.3% to 4.4%.** The cause is mine and it is structural: kickboxing draws on
`["kickboxing", "boxing"]`, and R128 added **36 boxing nodes against 7 kickboxing
nodes**. The hands drowned the kicks. Kickboxing's tier 1+2 went 20 → 41, but
most of the new 21 are punches.

**The fix is small and is in my file, not an agent's:** promote the low kick, the
teep and the shin check into tier 1–2 of kickboxing (they are genuinely
beginner-taught in every kickboxing gym — a low kick is not an advanced
technique), and/or move some boxing tier-2 hand work to tier 3. It is a spec-table
edit in `tools/build_boxing_kickboxing_nodes.py`, not a re-research.

---

## 5. KNOCKDOWN INCIDENCE (D5, anchor 35.1%)

| ruleset | live | shadow | |
|---|---:|---:|---|
| boxing | 42.5 | **32.5** | was above the anchor, now just below |
| kickboxing | 30.0 | 25.0 | was below, further below |
| muay_thai | 27.5 | 27.5 | unchanged |
| mma | 25.0 | 22.5 | was below, further below |

Boxing improves. The other three drift further below the anchor — consistent with
a wider palette spreading damage across more techniques rather than concentrating
it. **Not alarming at this sample size (40 bouts per ruleset), and not a blocker,
but it is the thing to re-measure after any effect-value calibration.**

---

## 6. THE RECOMMENDATION

**Merge — after one fix, and with eyes open about what it changes.**

1. **Fix kickboxing's tier 1–2 balance first.** It is the only clear regression,
   the cause is identified, and it is a small edit to my own spec table.
2. **Then merge.** The vocabulary win is large and real: muay thai goes from 5
   distinct techniques per 40 bouts to 26. Muay thai's leg share moves toward the
   real-fight band for the first time. Boxing's head share and knockdown rate both
   move toward their anchors.
3. **Expect seeded verdicts to move**, and say so in the commit. `judge_panel` and
   `fight_realtime` will not be byte-identical, and that is correct — this changes
   what the simulation scores. It must not be merged in the same commit as
   anything presentational, or the two become impossible to tell apart.
4. **Do NOT treat the merge as calibration.** The effect VALUES are on the same
   scale as the existing catalogue (measured: both median 8, p25 6, p75 10) but
   that scale has never been validated against fight outcomes — for the old 272 as
   much as the new 696. A real D1/D2 pass at the tick layer is the outstanding
   work, and this harness cannot do it.

---

## Reproducing

```
python Godot/tools/shadow_merge_catalogue.py
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_catalogue_impact.gd
```

The census needs `FightMoves.catalog_source_override`, added in R129. It defaults
to empty — every production path and every test reads the shipped file — and the
harness clears it in both directions, because a left-behind override would
silently run the whole game off a research artefact.
