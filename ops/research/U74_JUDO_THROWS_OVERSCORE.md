# U74 — A landed judo throw is nearly always a score

Research only. Census from `technique_catalog.json` and judo's live `scoring_profile`
in `combat_rulesets.json` (`ippon_threshold` 22.0, `throw_bands[0].min` 14.0 — read at
run time, not from U69's memo). No Godot run.

---

## 1. The mechanism

When a judo takedown lands, `FightSimulation._apply_landed_effect` (`2138:2157`) sets
phase to ground and calls `RoundScoring.throw_class(scoring_profile, magnitude *
execution_quality)`. `throw_class` (`RoundScoring.gd:175-184`) compares that product to
the profile: at or above `ippon_threshold` → ippon; else if it clears the highest
`throw_bands` entry → waza-ari (1 point under current judo profile); else nothing.

`magnitude` is the sum of absolute effect values on the catalogue node (e.g. uchi-mata
tier 2: `{takedown: 11, throw_setup: 8}` → 19). `execution_quality` is `0.6 + 0.4 *
combined_mastery` (`FightSimulation.gd:1400`), so trained fighters sit near 0.9. There
is no roll, no referee read, and no partial-credit band below waza-ari in the current
profile — a landed throw either scores decisively, scores once, or (only for the
weakest throws at low quality) scores nothing.

---

## 2. The census (78 judo takedowns)

| Execution quality | none | waza-ari | ippon |
|---:|---:|---:|---:|
| 0.7 | 0.231 | 0.769 | 0.000 |
| 0.8 | 0.103 | 0.897 | 0.000 |
| 0.9 | 0.000 | 0.526 | 0.474 |
| 1.0 | 0.000 | 0.308 | 0.692 |

At quality **0.9** — where a competent judoka lives — **every throw in the tree scores**:
52.6% waza-ari and 47.4% ippon. Only the eight tier-1 ash-waza at magnitude 16 stay
below ippon at 0.9 (they clear 14 at 0.9 exactly: `16 × 0.9 = 14.4`). At quality 1.0,
**69.2%** of the catalogue is ippon-capable on a clean landing (37 of 78 throws with
magnitude ≥ 22).

Magnitude spread after the S1 merge: min 16, median 23, max 26 (`U69_IPPON_LINE.md:46-51`).
Fifty-four of 78 throws cross ippon at quality 1.0 against the unchanged threshold 22 —
up from 2 of 8 at catalogue calibration (`U69_IPPON_LINE.md:19-28`). The flagship
uchi-mata dropped from 24 to 19 and no longer ippons at any realistic quality.

---

## 3. Why this over-scores — and what J26 says a throw should be worth

S1e seated judo's ground and added matte. In that measurement **27 of 40 bouts ended in
ippon** (`TASK_U74.md`) against J26's senior-Worlds anchor of **46.2% ippon any method**
(`J26_IJF_MATTE_AND_ENDINGS.md:58-62`). The bout rate is high but not yet at field level;
the throw layer is one of two drivers (the other is osaekomi without matte). J26 also
records **22.6% single waza-ari at time** and **17.7% waza-ari-awasete-ippon** — so a
large share of real contests end on **one** scored throw or two moderate ones, not on
every clean foot sweep becoming a bout-ending amplitude read.

In the engine, **any** landed takedown with `quality_magnitude ≥ 14` awards a full
waza-ari point immediately, and `ippon_by_points: 2.0` means **two** such throws end the
bout even when neither crossed 22. A thrower who lands two deashi-class sweeps at 0.9
(16 × 0.9 = 14.4 each) accumulates an ippon without ever producing a "big" throw. That
is structurally generous compared to IJF scoring, where marginal throws earn yuko (2025-28
cycle) or nothing, and two waza-ari require actual waza-ari throws — not every touch-down.

After S1d seated the ground, judo ippons in the ground-seat harness fell **31 → 11** in
40 bouts (`S1D_GROUND_SEATS.md:74`) — matte and ukemi changed outcomes, but the throw
classifier itself was untouched. The remaining ippon pressure is still throw-amplitude
driven.

---

## 4. Per-technique effectiveness on disk

**Catalogue magnitudes per throw** are on disk in `U69_IPPON_LINE.md:19-28` (8-throw
calibration table) and `U69_IPPON_LINE.md:59-63` (current minima and uchi-mata tier).
The full 78-row census is in `U74_judo_throw_scores.json`.

**Per-throw landing rates or throw-success percentages for judo** are **not on disk** in
`research/`. J20/J21 corpus figures are UFC/MMA takedown accuracy (~35-40%), not
IJF throw landing. No file quotes "uchi-mata lands X% of attempts" for this catalogue.

---

## 5. Options (shares at execution quality 0.9)

### (a) Re-author judo throw magnitudes — U69 §4a

Keep `ippon_threshold` 22 and `waza_ari_min` 14. Re-map magnitudes to U69's bimodal
spread: foundation ash-waza **14-17** (assign 15), gokyo core / ippon throws **22-25**
(raise today's 18-21 nodes to 24), counters / sacrifice **24-26** (unchanged).

| none | waza-ari | ippon |
|---:|---:|---:|
| 0.103 | 0.423 | 0.474 |

Ten percent of takedowns (the eight foundation sweeps at magnitude 15) score **none** at
0.9; ippon share stays 47.4% because the 25-26 cluster is unchanged. At quality 1.0 this
map yields **89.7% ippon** — selective on foot sweeps, decisive on re-raised core throws
(uchi-mata at 24 ippons again, matching the original `fight_scoring_test` intent per U69).

### (b) Add a yuko band and/or raise the waza-ari floor — J26 2025-28 cycle

Model the returning yuko tier as a third throw band: yuko at `quality_magnitude ≥ 10`,
waza-ari at **16** (raised from 14), ippon stays 22. No catalogue edit.

| none | yuko | waza-ari | ippon |
|---:|---:|---:|---:|
| 0.000 | 0.103 | 0.423 | 0.474 |

The eight magnitude-16 throws drop from waza-ari to **yuko** at 0.9 (14.4 < 16). Everyone
else is unchanged. This spreads the score ladder without fixing the 47% ippon tail, and
still awards a full waza-ari point to 42% of the tree on one landing. Raising **ippon** to
24 instead (keeping waza-ari at 14) would zero out all ippons at 0.9 (100% waza-ari) —
too blunt, and it breaks the flagship-throw property U69 documented.

### (c) Score by roll rising with quality, not a hard line

Replace the deterministic `throw_class` step with: on a landed takedown, draw against a
quality-scaled probability of scoring at all, then a second draw for ippon vs waza-ari
weighted by `quality_magnitude`. Illustrative calibration at 0.9:

| none | waza-ari | ippon |
|---:|---:|---:|
| 0.055 | 0.775 | 0.170 |

Marginal throws sometimes score nothing; big throws are less than half ippon at 0.9. This
tracks J26's "not every touch scores" better, but needs new simulation code, a seed policy,
and tuning against Dopico-Calvo outcome shares — research cannot ship it here.

---

## 6. Recommendation

**Option (a).** The defect is **unchanged thresholds × re-authored magnitudes** (U69's
finding): the S1 merge compressed the tree upward (median 16.5 → 23) while leaving
threshold 22, so most throws ippon on a good day and the flagship throw no longer does.
Re-authoring magnitudes restores the intended bimodal spread without lowering the ippon
line to 19 (which U69 showed would make 71/78 throws ippon-capable). Option (b) is a
useful **companion** once yuko exists for osaekomi (J26 §Q4) but does not fix the
catalogue/threshold mismatch alone. Option (c) is the right long-term shape for referee
judgement, but it is a build task, not a data fix.

`U74_judo_throw_scores.json` records `recommend: "a"`.

---

## 7. Mail line

```
takedowns=78 scoring_at_0.9=1.000 ippon_at_0.9=0.474 recommend=a check=exit0
```
