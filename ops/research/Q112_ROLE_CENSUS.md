# Q112 ROLE CENSUS — WHAT ROLE IS EVERY STRIKE THE ENGINE THROWS?

**Agent:** Qwen · **Date:** 2026-09-20
**Tool:** `Godot/tools/q112_role_census.gd`
**Check:** `research/Q112_check.py` (exits 0)
**JSON:** `research/Q112_census.json`

---

## Population

8 pairings across 4 disciplines, 15 bouts per pairing, 3 rounds, 120 bouts total.
Every fighter is legal for his ruleset; no fighter has `technique_progress`, so all
receive the full tier 1-2 palette of their ruleset's disciplines. No two fighters
share a stat block, a fight plan, or a reach/height pair.

| Discipline | Pairing | Red plan | Blue plan |
|---|---|---|---|
| boxing | out_boxer vs pressure | boxing_out_boxer | boxing_pressure |
| boxing | boxer_puncher vs counter | boxing_boxer_puncher | boxing_counter_puncher |
| kickboxing | dutch vs thai_kicker | kickboxing_dutch_pressure | kickboxing_thai_kicker |
| kickboxing | kb_counter vs kb_pressure | kickboxing_counter_striker | kickboxing_dutch_pressure |
| muay_thai | khao vs tae | muay_thai_khao | muay_thai_tae |
| muay_thai | femur vs mat | muay_thai_femur | muay_thai_mat |
| mma | wrestler vs out_striker | mma_wrestle_gnp | mma_sprawl_and_brawl |
| mma | sub_grappler vs clinch_boxer | mma_submission_grappler | mma_clinch_boxer |

**Catalogue:** `assets/data/technique_catalog.json` at head.
**Rulesets:** `assets/data/combat_rulesets.json`.

---

## Role split — ATTEMPTS (all action events, type=="action")

| Discipline | setup | damage | counter | empty | total n |
|---|---|---|---|---|---|
| boxing | 7369 (34.8%) | 11542 (54.5%) | 2272 (10.7%) | 0 (0.0%) | 21183 |
| kickboxing | 4667 (23.7%) | 14050 (71.2%) | 1009 (5.1%) | 0 (0.0%) | 19726 |
| muay_thai | 5722 (23.4%) | 14118 (57.6%) | 458 (1.9%) | 4198 (17.1%) | 24496 |
| mma | 7108 (23.1%) | 22748 (73.9%) | 916 (3.0%) | 0 (0.0%) | 30772 |

## Role split — LANDED (contact clean or glancing)

| Discipline | setup | damage | counter | empty | total n |
|---|---|---|---|---|---|
| boxing | 3574 (34.7%) | 5562 (54.0%) | 1171 (11.4%) | 0 (0.0%) | 10307 |
| kickboxing | 2347 (23.7%) | 7004 (70.7%) | 549 (5.5%) | 0 (0.0%) | 9900 |
| muay_thai | 2897 (23.5%) | 7067 (57.4%) | 225 (1.8%) | 2131 (17.3%) | 12320 |
| mma | 3619 (23.4%) | 11395 (73.7%) | 449 (2.9%) | 0 (0.0%) | 15463 |

## POWER_ROLES share (damage + counter)

| Discipline | att POWER% | n | land POWER% | n |
|---|---|---|---|---|
| boxing | 65.2% | 13814/21183 | 65.3% | 6733/10307 |
| kickboxing | 76.3% | 15059/19726 | 76.3% | 7553/9900 |
| muay_thai | 59.5% | 14576/24496 | 59.2% | 7292/12320 |
| mma | 76.9% | 23664/30772 | 76.6% | 11844/15463 |

## THE KEY FINDING — LANDED DISTANCE HEAD STRIKES IN POWER ROLE

This is the 83.2% figure's definition: of all landed standing (distance) head
strikes, what share are in a POWER role (damage or counter)?

| Discipline | POWER% | n (POWER/total) |
|---|---|---|
| boxing | 64.9% | 4346/6692 |
| kickboxing | 79.2% | 3963/5003 |
| muay_thai | 77.2% | 3400/4402 |
| mma | 76.6% | 4344/5668 |
| **pooled** | **73.8%** | **16053/21765** |

**J20's anchor implies about 26%.** The derivation: J20 section A gives 71.3
combined significant landed per fight, section B gives 63% head → ~44.9 landed
head strikes per fight. Section F's knockdown rate is 3.9% per landed distance
power-head strike (Reed Kuhn / Fightnomics), and section F's own knockdown count
is 0.41–0.52 per fight → implied 10.5–13.3 landed distance power-head strikes
per fight, about 26% of head strikes. **26% is an INFERENCE, not a published
table.** What J20 documents is the 3.9% and the 0.41–0.52.

**The engine's pooled 73.8% is roughly 3x the anchor's 26%.** The engine throws
far too few jabs (a setup role, not power) relative to power strikes at the
head. This is the finding; fixing it is Claude's.

## JAB count (technique id contains "jab")

| Discipline | att jab | att% | land jab | land% |
|---|---|---|---|---|
| boxing | 3790 | 17.9% | 1806 | 17.5% |
| kickboxing | 3083 | 15.6% | 1503 | 15.2% |
| muay_thai | 1810 | 7.4% | 895 | 7.3% |
| mma | 2263 | 7.4% | 1113 | 7.2% |

MMA has no standalone jab technique in the catalogue (`mma_jab_levelchange` is a
grapple entry, not a strike). MMA's jab-counting techniques come from its
cross-discipline boxing nodes.

## Position split — ATTEMPTS

| Discipline | distance | clinch | ground |
|---|---|---|---|
| boxing | 21183 | 0 | 0 |
| kickboxing | 19726 | 0 | 0 |
| muay_thai | 20298 | 1694 | 2504 |
| mma | 24407 | 2227 | 4138 |

## Region split — LANDED

| Discipline | head_neck | torso_core | left_leg | right_leg |
|---|---|---|---|---|
| boxing | 6692 | 3615 | 0 | 0 |
| kickboxing | 5003 | 3827 | 541 | 529 |
| muay_thai | 5663 | 5753 | 465 | 439 |
| mma | 7866 | 6746 | 401 | 450 |

---

## Anomalies for Claude

1. **Boxing and kickboxing have ZERO clinch and ZERO ground strikes.** All their
   action events are at position=distance. Muay thai and MMA do reach clinch and
   ground. This suggests the boxing/kickboxing ruleset configurations or fight
   plans never transition to clinch/ground positions, or the engine's position
   assignment for those rulesets is wrong.

2. **Muay thai has 17.1% empty-role strikes** (4198 of 24496 attempts). The
   empty role means `technique`, `technique_name` and `role` are all empty — the
   fallback path where no legal technique was found. This is a large share and
   suggests the muay thai pairing's fighters are frequently hitting the fallback.

3. **The jab is underthrown in every discipline** relative to what real fighting
   looks like (jabs are typically 40-60% of punches in boxing). The engine's
   7.4-17.9% is well below that.
