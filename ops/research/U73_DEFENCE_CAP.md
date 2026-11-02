# U73 — Defence bonus saturation in the generated-opponent population

## What was measured

S1e caps the technique defence bonus at `min(sum_of_counted_magnitude / 40, 0.35)`. Defence node magnitudes run 9–20 (median 13), so **one relevant node is worth about +0.33** and **two median nodes hit the cap**. The bonus subtracts from `0.35 + 0.5 * execution_quality` in the land-rate formula (`FightSimulation.gd` `_defender_defense_factor`).

The two-fight S1e fixtures (MMA striker vs jiu-jitsu man) showed ~62.8% vs ~25.4% strike land — but those are hand-picked opponents. U73 asks what **FightOpponentGenerator** actually produces: a tier-then-name **prefix** of each discipline tree, longer with rating, not the full defence catalogue.

## Census method

For every discipline in `technique_catalog.json` and ratings **30, 50, 70, 90**:

1. Sort nodes tier-then-name (same as `CompetitionData.get_techniques_for_discipline`).
2. Learned count = `max(2, round(clamp((rating−20)/60, 0.15, 0.85) × tree_size))` using GDScript half-away-from-zero rounding.
3. Defence nodes = prefix entries with `role == "defense"`.
4. Bonus per seat/class = sum of magnitudes of prefix defences whose phases seat the defender and whose effect keys answer the incoming class (`technique_vocabulary.json`), divided by 40, capped at 0.35.

**Trap honoured:** a defence outside the prefix is unknown. Karate has dozens of defence nodes in the tree; a rating-30 karateka may know eighteen prefix defences (enough to saturate standing strike) or a grappling discipline may know zero.

Full per-cell numbers live in `U73_defence_cap_census.json`.

## Where the population saturates

Fifteen catalogue disciplines × four ratings = **60 standing-strike cells**.

| Standing strike bonus | Cells | Share |
| --- | ---: | ---: |
| **0.35 (cap)** | 28 | 47% |
| **0.30 (one node)** | 8 | 13% |
| **0.00 (no prefix defence)** | 24 | 40% |

Saturation clusters in **striking-heavy trees** whose early tiers pack many small-magnitude defences: boxing (all four ratings), kickboxing, muay thai, karate (all four — karate saturates even at rating 30 with eighteen prefix nodes), capoeira, taekwondo/sanda/savate at mid-high ratings. **Grappling-first prefixes** (Brazilian jiu-jitsu, wrestling, judo, sambo, pankration, pencak silat at low ratings) often have **zero** standing-strike bonus because their early nodes are offence or ground control, not standing parries.

There is almost no middle ground under the current divisor: besides the cap and zero, only eight cells sit at exactly **0.30** (pencak silat at most ratings; taekwondo/sanda/savate at rating 30).

## Implied land rate at execution quality 0.8, defence attribute 60

With `_defender_defense_factor` returning `clamp(defense/100 × 0.35 + bonus, 0, 0.6)` and land chance `0.35 + 0.5 × 0.8 − factor`:

| Prefix standing-strike bonus | Implied land rate |
| ---: | ---: |
| 0.00 | **54%** |
| 0.30 | **24%** |
| 0.35 | **19%** |

Across all 60 cells the population mean is **33.7%**, with a **bimodal** distribution: 28 cells at 19%, 24 at 54%, 8 at 24%. No cell lands in the 35–50% band.

### Anchors on disk

**UFC significant-strike accuracy (section A, J20 line 97):** division range **~43–49%**, lightweight and women's flyweight lows at **43.2%**, heavyweight high at **48.6%** (8,375 fights, 1993–2025).

**CompuBox male pro sample (section G, J20 line 202):** **34.6%** overall connect; power punches **42.4%**; jabs **27.29%** (322 boxers, 320 fights).

The generated population's **54%** ceiling overshoots both anchors; its **19%** floor undershoots them. The engine currently offers defenders mostly "elite wall" or "no technique defence" — not the mid-40s band real cards occupy.

## Options (do not build here)

All bands below reuse the same census magnitudes and the same eq=0.8 / defence=60 reference point, recomputing only the bonus curve.

### (a) Keep the hard cap at divisor 40

- **Behaviour:** unchanged — one strong node ≈ full bonus, cap at 0.35.
- **Population band:** 19% / 24% / 54% only; mean **33.7%**; **0** of 60 cells in 35–50%.
- **vs anchors:** below UFC division accuracy (~43–49%) and below CompuBox power connect (42.4%) for most saturated cells; above CompuBox only for the zero-defence tail.
- **Verdict:** simple, already shipped, but the generated-opponent population is unrealistically polarised.

### (b) Larger linear divisor (recommend constant **120**)

Replace `/ 40` with `/ 120`; keep `min(..., 0.35)`.

- **One median node:** bonus ≈ **0.11** → land **~43.7%** (inside UFC band).
- **Population:** mean **39.0%**; **15** cells still hit cap; **9** cells in 35–50%; saturation drops from 28 → 15 cells.
- **vs anchors:** mean aligns with J20's "~40% career accuracy" figure; mid-tree opponents spread across 35–50%; cap still bites for karate/boxing long prefixes.
- **Verdict:** minimal code change (one constant), restores a gradient, but linear cap still collapses deep prefixes.

### (c) Diminishing returns `0.35 × (1 − exp(−sum / k))` (recommend **k = 60**)

- **One median node (sum≈13):** bonus ≈ **0.073** → land **~46.7%**.
- **Population:** mean **43.4%**; **3** cells hit cap; **24** cells in 35–50%; range **19%–54%** (floor unchanged — attribute + cap still bind).
- **vs anchors:** population mean sits inside the UFC division-accuracy band (43.2–48.6%); CompuBox overall (34.6%) remains a lower bound for punch-only sport; power connect (42.4%) is matched by the bulk of cells.
- **Verdict:** best fit to real strike-accuracy anchors while preserving S1e's phase/class gating; extra node still helps but cannot instantly brick the attacker.

## Recommendation

**Option (c) with k = 60.** It lifts the generated-opponent mean from 33.7% to **43.4%** (UFC division meta centre), puts **40%** of cells in the 35–50% band instead of zero, and cuts cap-saturated cells from **28 to 3** without touching vocabulary or prefix logic. Option (b) at divisor 120 is the fallback if Claude wants a one-line constant change only.

Implementation note for Claude: swap the `bonus / 40.0` clamp in `_defender_defense_factor` for the chosen curve; re-run seeded bout fixtures after.
