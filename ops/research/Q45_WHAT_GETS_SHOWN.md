# Q45 — Which techniques actually get shown

**Measured at:** `49d3cbd`
**Harness:** `Godot/tools/measure_shown_techniques.gd`
**Method:** 40 bouts per ruleset through `FightBeatAdapter` (begin / advance_beat /
is_fight_over), same two welterweights as R102, seeds 45000–45039. Real rulesets
loaded from `combat_rulesets.json`, never bare `{"id": "..."}`.

## The headline number: the 272 was never the denominator

| ruleset | distinct techniques THROWN | distinct techniques SHOWN | catalogue nodes |
|---|---|---|---|
| boxing | **8** | **8** | ~30 |
| mma | **21** | **21** | ~80 |
| kickboxing | **14** | **14** | ~50 |
| muay thai | **5** (+ unnamed) | **5** (+ unnamed) | ~40 |
| **pooled** | — | **21** (+ 145 unnamed) | 272 |

The engine never reaches most of the catalogue. Boxing uses 8 techniques out
of ~30 nodes. Muay thai uses 5 named techniques out of ~40 nodes. The 272 was
never the relevant number — the relevant number is **21 distinct techniques
across all four rulesets, plus 145 unnamed muay thai impacts**.

## Part 1 — the two denominators, side by side

### Boxing (40 bouts)

| | THROWN | SHOWN |
|---|---|---|
| total impacts | 48,831 | 3,970 |
| distinct named techniques | 8 | 8 |
| unnamed | 0 (0.0%) | 0 (0.0%) |
| drop rate | — | 91.9% (44,861 of 48,831 dropped) |

Beats: 4,937 total, 3,970 action, 967 no_action.

### MMA (40 bouts)

| | THROWN | SHOWN |
|---|---|---|
| total impacts | 31,204 | 2,246 |
| distinct named techniques | 21 | 21 |
| unnamed | 0 (0.0%) | 0 (0.0%) |
| drop rate | — | 92.8% (28,958 of 31,204 dropped) |

Beats: 2,477 total, 2,246 action, 231 no_action.

### Kickboxing (40 bouts)

| | THROWN | SHOWN |
|---|---|---|
| total impacts | 20,852 | 1,569 |
| distinct named techniques | 14 | 14 |
| unnamed | 0 (0.0%) | 0 (0.0%) |
| drop rate | — | 92.5% (19,283 of 20,852 dropped) |

Beats: 1,900 total, 1,569 action, 331 no_action.

### Muay Thai (40 bouts)

| | THROWN | SHOWN |
|---|---|---|
| total impacts | 35,539 | 2,352 |
| distinct named techniques | 5 | 5 |
| unnamed | 5,355 (15.1%) | 145 (6.2%) |
| drop rate | — | 93.4% (33,187 of 35,539 dropped) |

Beats: 3,428 total, 2,352 action, 1,076 no_action.

**The unnamed share drops from 15.1% of thrown to 6.2% of shown.** The
FightBeatAdapter's choosing rule (knockdown > shocked > highest wear) does not
preferentially select unnamed impacts, so named techniques survive the drop at
a higher rate than unnamed ones. The adapter partially corrects R101's unnamed
problem without intending to.

## Part 2 — the purchase curve (the deliverable)

### Cumulative coverage: what share of SHOWN throws does the top-N cover?

| top-N | boxing | mma | kickboxing | muay thai | pooled |
|---|---|---|---|---|---|
| 1 | 17.6% | 7.2% | 10.6% | 31.3% | 9.6% |
| 3 | 48.5% | 20.7% | 31.1% | 70.2% | 27.4% |
| **5** | **74.3%** | **33.3%** | **49.3%** | **100.0%** | **44.1%** |
| 10 | 100.0% | 61.6% | 84.3% | 100.0% | 76.7% |
| **14** | **100.0%** | **79.6%** | **100.0%** | **100.0%** | **90.3%** |
| 20 | 100.0% | 97.4% | 100.0% | 100.0% | 99.4% |
| 30 | 100.0% | 100.0% | 100.0% | 100.0% | 100.0% |

**Denominators:** boxing=3,970, mma=2,246, kickboxing=1,569, muay thai=2,352,
pooled=9,992 (all named). Unnamed are excluded from the coverage curve because
an unnamed throw can never have a clip.

### What this says about the purchase list

- **Boxing**: 8 clips cover 100% of shown throws. 5 clips cover 74.3%.
- **MMA**: 21 clips cover 100%. 14 clips cover 79.6%. 20 clips cover 97.4%.
- **Kickboxing**: 14 clips cover 100%. 10 clips cover 84.3%.
- **Muay thai**: 5 named clips cover 100% of named shown throws. Plus the
  unnamed 6.2% that can never be covered.
- **Pooled**: 14 clips cover 90.3%. 21 clips cover 100% of named shown throws.

The M19 estimate of ~13–14 clips was in the right ballpark for pooled coverage
at ~90%, but for the wrong reason. It was not "13–14 out of 272 is enough
because most techniques are rare" — it is "there are only 21 distinct
techniques that ever appear on screen, and 14 of them cover 90%".

## Part 3 — the unnamed share

| ruleset | unnamed THROWN | unnamed SHOWN | unnamed share of thrown | unnamed share of shown |
|---|---|---|---|---|
| boxing | 0 | 0 | 0.0% | 0.0% |
| mma | 0 | 0 | 0.0% | 0.0% |
| kickboxing | 0 | 0 | 0.0% | 0.0% |
| muay thai | 5,355 | 145 | 15.1% | **6.2%** |

Muay thai is the only ruleset with unnamed impacts. R101 found 19.4% unnamed
of thrown; Q45 measures 15.1% of thrown (different seed/fighter pair) and
finds the shown share is **6.2%** — the adapter's choosing rule preferentially
picks named techniques because they tend to carry more wear (named techniques
have explicit force profiles; unnamed fallbacks use the generic region table).

An unnamed throw **can never have a clip**. The 145 unnamed shown impacts in
muay thai (6.2% of its shown beats) are permanently un-clipable without naming
the technique in the catalogue.

## SHOWN top-15 per ruleset

### Boxing (denominator=3,970)

| rank | technique | count | % of shown |
|---|---|---|---|
| 1 | boxing_jab | 699 | 17.6% |
| 2 | boxing_double_jab | 677 | 17.1% |
| 3 | boxing_overhand | 551 | 13.9% |
| 4 | boxing_rear_uppercut | 514 | 12.9% |
| 5 | boxing_lead_hook | 507 | 12.8% |
| 6 | boxing_lead_uppercut | 474 | 11.9% |
| 7 | boxing_cross | 279 | 7.0% |
| 8 | boxing_slip_counter | 269 | 6.8% |

### MMA (denominator=2,246)

| rank | technique | count | % of shown |
|---|---|---|---|
| 1 | boxing_lead_hook | 162 | 7.2% |
| 2 | boxing_lead_uppercut | 160 | 7.1% |
| 3 | muay_thai_horizontal_elbow | 144 | 6.4% |
| 4 | boxing_overhand | 143 | 6.4% |
| 5 | muay_thai_straight_knee | 138 | 6.1% |
| 6 | boxing_rear_uppercut | 137 | 6.1% |
| 7 | boxing_double_jab | 132 | 5.9% |
| 8 | boxing_jab | 125 | 5.6% |
| 9 | muay_thai_teep | 123 | 5.5% |
| 10 | kickboxing_front_kick | 120 | 5.3% |
| 11 | muay_thai_round_kick | 116 | 5.2% |
| 12 | kickboxing_roundhouse | 107 | 4.8% |
| 13 | mma_guard_gnp | 100 | 4.5% |
| 14 | kickboxing_jab_lowkick | 81 | 3.6% |
| 15 | muay_thai_switch_kick_body | 76 | 3.4% |

### Kickboxing (denominator=1,569)

| rank | technique | count | % of shown |
|---|---|---|---|
| 1 | boxing_lead_uppercut | 167 | 10.6% |
| 2 | boxing_lead_hook | 161 | 10.3% |
| 3 | boxing_rear_uppercut | 160 | 10.2% |
| 4 | boxing_overhand | 151 | 9.6% |
| 5 | kickboxing_front_kick | 134 | 8.5% |
| 6 | kickboxing_roundhouse | 133 | 8.5% |
| 7 | boxing_jab | 132 | 8.4% |
| 8 | boxing_double_jab | 130 | 8.3% |
| 9 | kickboxing_jab_cross_lowkick | 86 | 5.5% |
| 10 | kickboxing_low_kick | 69 | 4.4% |
| 11 | boxing_slip_counter | 68 | 4.3% |
| 12 | kickboxing_body_kick | 65 | 4.1% |
| 13 | kickboxing_jab_lowkick | 58 | 3.7% |
| 14 | boxing_cross | 55 | 3.5% |

### Muay Thai (denominator=2,352, plus 145 unnamed)

| rank | technique | count | % of shown |
|---|---|---|---|
| 1 | muay_thai_horizontal_elbow | 691 | 29.4% |
| 2 | muay_thai_teep | 445 | 18.9% |
| 3 | muay_thai_round_kick | 413 | 17.6% |
| 4 | muay_thai_straight_knee | 411 | 17.5% |
| 5 | muay_thai_switch_kick_body | 247 | 10.5% |
| — | *(unnamed)* | 145 | 6.2% |

### Pooled (denominator=9,992 named, plus 145 unnamed)

| rank | technique | count | % of pooled shown |
|---|---|---|---|
| 1 | boxing_jab | 956 | 9.6% |
| 2 | boxing_double_jab | 939 | 9.4% |
| 3 | boxing_overhand | 845 | 8.5% |
| 4 | muay_thai_horizontal_elbow | 835 | 8.4% |
| 5 | boxing_lead_hook | 830 | 8.3% |
| 6 | boxing_rear_uppercut | 811 | 8.1% |
| 7 | boxing_lead_uppercut | 801 | 8.0% |
| 8 | muay_thai_teep | 568 | 5.7% |
| 9 | muay_thai_straight_knee | 549 | 5.5% |
| 10 | muay_thai_round_kick | 529 | 5.3% |
| 11 | boxing_slip_counter | 395 | 4.0% |
| 12 | boxing_cross | 392 | 3.9% |
| 13 | muay_thai_switch_kick_body | 323 | 3.2% |
| 14 | kickboxing_front_kick | 254 | 2.5% |
| 15 | kickboxing_roundhouse | 240 | 2.4% |
| 16 | kickboxing_jab_cross_lowkick | 154 | 1.5% |
| 17 | kickboxing_low_kick | 141 | 1.4% |
| 18 | kickboxing_jab_lowkick | 139 | 1.4% |
| 19 | kickboxing_body_kick | 128 | 1.3% |
| 20 | mma_guard_gnp | 100 | 1.0% |
| 21 | mma_dirty_boxing | 65 | 0.7% |
