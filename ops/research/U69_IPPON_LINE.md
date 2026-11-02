# U69 — THE IPPON LINE STAYED WHERE IT WAS WHEN THE CATALOGUE MOVED

Research only. Measured on master at `f160fe9` (2026-09-12). No Godot run.

---

## 1. Where 22 came from

**Commit:** `df3d9a3` — *Add Fight Plan v2 Stage A: scoring profiles and a ruleset-aware judge* (2026-09-03).

`ippon_threshold: 22` was introduced in the **same commit** as `RoundScoring.gd`, the judo
`scoring_profile`, and `fight_scoring_test.gd`. There is no earlier value and no separate
digest — the threshold was chosen alongside the test that asserts a clean uchi-mata can
ippon.

**Catalogue calibrated against:** the pre-S1 judo tree in `technique_catalog.json` at
`df3d9a3` — **8** nodes with `match.role == "takedown"`, not the 696-node merge.

| Throw | Magnitude at `df3d9a3` | Crosses 22? |
|---|---:|---|
| `judo_kosotogari` | 12 | no |
| `judo_haraigoshi` | 13 | no |
| `judo_deashi` | 16 | no |
| `judo_taiotoshi` | 16 | no |
| `judo_ogoshi` | 17 | no |
| `judo_osotogari` | 18 | no |
| `judo_seoinage` | 24 | **yes** |
| `judo_uchimata` | 24 | **yes** |

Uchi-mata at calibration: `{takedown: 16, counter_throw: 8}` → magnitude **24**.

**Waza-ari floor in the same profile:** `throw_bands[0].min = 14`. So 22 sits **8 points
above** the waza-ari band — roughly “decisive throw” vs “scored throw” on the old 8-throw
spread (2/8 ippon-capable ≈ 25%).

---

## 2. Two distributions (before / after)

**Method:** Python over JSON, mirroring `FightSimulation._technique_magnitude` — sum of
`|effects[*]|` on each judo node with `match.role == "takedown"`. Discipline inherited from
parent `disciplines[]` entry when the node omits it.

| | **THEN** `df3d9a3` | **NOW** `f160fe9` |
|---|---:|---:|
| Judo takedown nodes | 8 | 78 |
| Min | 12 | 16 |
| Median | 16.5 | 23.0 |
| Max | 24 | 26 |
| Cross ≥ 22 | **2** | **54** |
| `judo_uchimata` magnitude | **24** | **19** |

**Break commit for uchi-mata:** `11cd459` (S1 catalogue merge). Effects changed from
`{takedown: 16, counter_throw: 8}` to `{takedown: 11, throw_setup: 8}`. Role stayed
`takedown`; **`ippon_threshold` was not touched** (still 22 in `combat_rulesets.json`).

The gate kept its copy of the answer. The tree moved; the line did not.

**Smallest takedowns NOW (never ippon at 22):** all tier-1 ash-waza at **16**
(`deashi`, `osotogari`, `ogoshi`, `ukigoshi`, `hizaguruma`, `sasaetsurikomiashi`,
`ouchigari`, `seoinage_twohand`).

**Uchi-mata tier NOW:** tier 2, nikyo — magnitude **19**, solid waza-ari, **not** ippon.

---

## 3. How ippon is priced

**Compared quantity:** `quality_magnitude = magnitude × execution_quality`

- `magnitude` = `_technique_magnitude(technique)` — sum of absolute effect values
  (`FightSimulation.gd:2649-2654`).
- `execution_quality` passed into `_apply_landed_effect` (1.0 in `fight_scoring_test`).

**Takedown arm** (`FightSimulation.gd:2089-2107`):

```gdscript
var throw_result: Dictionary = RoundScoring.throw_class(scoring_profile, magnitude * execution_quality)
```

**Classification** (`RoundScoring.gd:168-177`):

```gdscript
var ippon := threshold > 0.0 and quality_magnitude >= threshold
```

So: **raw catalogue magnitude × execution quality**, not magnitude alone and not
throw_points. At quality 1.0, uchi-mata NOW is 19 vs threshold 22 → waza-ari only.

Separate path: `ippon_by_points: 2.0` — two waza-ari (≥ 14 each) also ends the bout
(`FightSimulation.gd:2104-2107`).

---

## 4. Options

### (a) Re-author judo throw magnitudes — **RECOMMEND**

Restore a **bimodal** spread on the 78-node tree; **keep threshold 22**.

| Band | Target magnitude | Example throws | At thresh 22 |
|---|---|---|---|
| Foundation ash-waza | 14–17 | deashi, osoto, ogoshi | waza-ari only |
| Gokyo core / ippon throws | 22–25 | **uchimata**, seoinage, harai, tai-otoshi | ippon-capable |
| Counters / sacrifice / renraku | 24–26 | ura-nage, makikomi, gaeshi | ippon-capable |

**Concrete:** raise `judo_uchimata` (and peer tier-2 gokyo throws sitting at 19) back to
~**24** — the value that passed the original test against the same threshold.

**Why not only lower the threshold:** see (b).

### (b) Change `ippon_threshold` in `combat_rulesets.json`

| Threshold | Cross NOW | Uchi-mata ippon? | Problem |
|---:|---:|---|---|
| 19 | 71 / 78 | yes | **91%** of takedowns ippon on perfect execution — renraku chains, gaeshi, and makikomi all decisive; sport-wrong |
| 20 | 60 / 78 | yes | still ~77% ippon-capable |
| 21 | 57 / 78 | yes | still ~73% |
| 22 (current) | 54 / 78 | **no** | flagship throw fails; foot sweeps still safe (16) |
| 25 | 24 / 78 | no | ~31% ippon rate but uchi-mata still out |

Lowering the line fixes one assertion and breaks the population.

### (c) Derive threshold from the judo takedown distribution

| Statistic | THEN (`df3d9a3`) | NOW (`f160fe9`) | Uchi-mata ippon? |
|---|---:|---:|---|
| p75 | 19.5 | 25.0 | THEN yes / NOW **no** |
| p90 | 24.0 | 26.0 | THEN yes / NOW **no** |
| median of top quartile | 24.0 | 25.0 | THEN yes / NOW **no** |
| `throw_bands[0].min + 8` | 22.0 | 22.0 | THEN yes / NOW **no** |

A derived line **tracks compression** but does **not** rescue a throw that was re-authored
**downward** while the percentile **shifted upward** (median 16.5 → 23.0). Useful as a
**merge gate**, not as the sole fix:

> After any judo catalogue edit, recompute takedown magnitudes; require
> `count(mag ≥ ippon_threshold) / count(takedowns)` ∈ **[0.15, 0.40]** and require every
> tier-2+ gokyo throw listed in `fight_scoring_test` to cross the threshold.

---

## 5. Recommendation

**Option (a): re-author magnitudes; keep 22.** Optionally add **(c) as a CI gate** on
future merges so the line and tree cannot diverge again.

The test’s **property** is right (clean uchi-mata should ippon). The **number** 22 is still
defensible on the old spread and on foot-sweep safety (min takedown NOW = 16). The defect is
**unchanged threshold × re-authored magnitudes**, not a wrong test target.

**Do not** set threshold to 19 to green the test — that would make deashi-class sweeps at 16
waza-ari-only (good) but also make **71** throws ippon-capable (bad).

---

## 6. Mail line

```
threshold_origin=df3d9a3 judo_takedowns=78 cross22_then=2 cross22_now=54 recommend=a
```
