# U48 / U49 — What the Broadcast Refuses

**Addressed to the operator.** Numbers only; `_choose` was not changed.

**Measured at:** `67b073b` (U49 re-measure; U48 counts for the original four
rules are unchanged on the same seeds)
**Harness:** `Godot/tools/measure_choose_rules.gd`
**Method:** Same 40 bouts × 4 rulesets as Q46 (seeds 46000–46039, same pair).
One fight run per seed. After each `advance_beat`, candidates are recovered from
`fight.log` by `tick_from`..`tick_to` (the adapter exposes only the count). All
**six** rules re-rank those same windows. **No extra RNG draws.** Seam assert,
fight-identity assert, and U49 occurrence asserts all passed. Shown-beat counts
are identical across rules on every ruleset.

**`current` reproduces Q46** (within rounding — exact counts): pooled 9,715 shown
beats, block+slip 29 (0.3% of those 9,715), clean 9,035 (93.0%), knockdown 107
(1.1%). Per-ruleset receiver and contact tables match Q46 line-for-line.

**Identity (byte-identical across all six rules on one seed):** one fight run per
seed; harness draws no RNG; outcomes / scorecards / method of victory are the
same fight under every rule. Printed samples include
`fp=|DECISION||37200` (boxing seed 46000) and matching fingerprints per ruleset.

---

## Seam note

`FightBeatAdapter.advance_beat` returns `candidates: int` (size), not the array.
The IMPACT path appends the same action dicts to `fight["log"]`, so recovery is
exact: `recovered.size() == beat["candidates"]`, and `BA._choose(recovered)`
matches the presented beat. That is reading the adapter's window, not a second
filter.

---

## Pooled summary (denominator = 9,715 shown beats under each named rule)

Every percentage below names its denominator in the same sentence. Loss counts
compare against **`current`'s picks in the same 9,715 windows**.

| rule | block+slip | % of that rule's shown | clean_lost vs current | kd_lost (of 107) | sig_lost (of 9,490) |
|---|---:|---:|---:|---:|---:|
| **current** | 29 | 0.3% of 9,715 under current | — | — | — |
| **defence_eligible** | 7,041 | 72.5% of 9,715 under defence_eligible | **6,670** (73.8% of 9,035 current cleans) | **80** | 6,797 |
| **alternating_2** | 3,487 | 35.9% of 9,715 under alternating_2 | 3,302 (36.5% of 9,035) | 40 | 3,351 |
| **alternating_4** | 1,717 | 17.7% of 9,715 under alternating_4 | 1,605 (17.8% of 9,035) | 26 | 1,635 |
| **wear_blind** | 1,012 | 10.4% of 9,715 under wear_blind | 7,497 (83.0% of 9,035) | **0** | 7,802 |
| **promote_in_remainder** | 6,440 | 66.3% of 9,715 under promote_in_remainder | **6,069** (67.2% of 9,035) | **0** | 6,248 |
| **promote_in_remainder_4** | 1,579 | 16.3% of 9,715 under promote_in_remainder_4 | 1,468 (16.2% of 9,035) | **0** | 1,514 |

Shown beats per bout are unchanged under every rule (only which impact is
presented). Bout length is therefore unchanged.

---

## Contact tables (pooled)

### current — denominator = 9,715 shown beats under current

| contact | count | % of 9,715 under current |
|---|---:|---:|
| clean | 9,035 | 93.0% |
| glancing | 505 | 5.2% |
| absorbed | 71 | 0.7% |
| missed | 75 | 0.8% |
| slipped | 16 | 0.2% |
| blocked | 13 | 0.1% |

### defence_eligible — denominator = 9,715 shown beats under defence_eligible

| contact | count | % of 9,715 under defence_eligible |
|---|---:|---:|
| slipped | 4,062 | 41.8% |
| blocked | 2,979 | 30.7% |
| clean | 2,365 | 24.3% |
| glancing | 211 | 2.2% |
| missed | 56 | 0.6% |
| absorbed | 42 | 0.4% |

### alternating_4 — denominator = 9,715 shown beats under alternating_4

| contact | count | % of 9,715 under alternating_4 |
|---|---:|---:|
| clean | 7,430 | 76.5% |
| slipped | 994 | 10.2% |
| blocked | 723 | 7.4% |
| glancing | 435 | 4.5% |
| missed | 71 | 0.7% |
| absorbed | 62 | 0.6% |

### wear_blind — denominator = 9,715 shown beats under wear_blind

| contact | count | % of 9,715 under wear_blind |
|---|---:|---:|
| missed | 3,101 | **31.9%** |
| clean | 2,948 | 30.3% |
| glancing | 1,919 | 19.8% |
| absorbed | 735 | 7.6% |
| slipped | 655 | 6.7% |
| blocked | 357 | 3.7% |

### promote_in_remainder — denominator = 9,715 shown beats under promote_in_remainder

| contact | count | % of 9,715 under promote_in_remainder |
|---|---:|---:|
| slipped | 3,734 | 38.4% |
| clean | 2,966 | 30.5% |
| blocked | 2,706 | 27.9% |
| glancing | 211 | 2.2% |
| missed | 56 | 0.6% |
| absorbed | 42 | 0.4% |

### promote_in_remainder_4 — denominator = 9,715 shown beats under promote_in_remainder_4

| contact | count | % of 9,715 under promote_in_remainder_4 |
|---|---:|---:|
| clean | 7,567 | 77.9% |
| slipped | 914 | 9.4% |
| blocked | 665 | 6.8% |
| glancing | 435 | 4.5% |
| missed | 70 | 0.7% |
| absorbed | 64 | 0.7% |

`wear_blind` is the control: drop the wear tiebreak, keep `knockdown > shocked`,
take the first candidate. Knockdowns are preserved (0 lost). What floods the
broadcast is **misses**, not slips. So the current mix is not "anti-defence" in
isolation — the wear rule is what keeps the camera on blows that cost something.
Removing it without a defence preference still only reaches 10.4% block+slip of
its own 9,715, while losing 83% of current's cleans.

---

## Receiver roles (pooled) — Q46 columns

| role | current (of 9,715) | defence_eligible (of 9,715) | alternating_4 (of 9,715) | wear_blind (of 9,715) | promote_in_remainder (of 9,715) | promote_in_remainder_4 (of 9,715) |
|---|---:|---:|---:|---:|---:|---:|
| react_head | 5,525 (56.9%) | 1,547 (15.9%) | 4,568 (47.0%) | 3,169 (32.6%) | 1,995 (20.5%) | 4,674 (48.1%) |
| react_body | 3,609 (37.1%) | 940 (9.7%) | 2,982 (30.7%) | 1,956 (20.1%) | 1,013 (10.4%) | 2,986 (30.7%) |
| react_leg | 370 (3.8%) | 104 (1.1%) | 296 (3.0%) | 370 (3.8%) | 104 (1.1%) | 299 (3.1%) |
| slip | 16 (0.2%) | 4,062 (41.8%) | 994 (10.2%) | 655 (6.7%) | 3,734 (38.4%) | 914 (9.4%) |
| block | 13 (0.1%) | 2,979 (30.7%) | 723 (7.4%) | 357 (3.7%) | 2,706 (27.9%) | 665 (6.8%) |
| idle | 75 (0.8%) | 56 (0.6%) | 71 (0.7%) | 3,101 (31.9%) | 56 (0.6%) | 70 (0.7%) |
| knockdown | 107 (1.1%) | 27 (0.3%) | 81 (0.8%) | 107 (1.1%) | 107 (1.1%) | 107 (1.1%) |

---

## Per ruleset — block+slip and the loss column

Denominator for each share = that ruleset's shown beats under that rule
(boxing 3,549 / mma 2,350 / kickboxing 1,476 / muay_thai 2,340). Loss counts
are versus `current` in the same windows.

| ruleset | rule | block+slip | % of that rule's shown | clean_lost | kd_lost |
|---|---|---:|---:|---:|---:|
| boxing | current | 11 | 0.3% of 3,549 | — | — |
| boxing | defence_eligible | 2,196 | 61.9% of 3,549 | 2,075 | 34/54 |
| boxing | alternating_4 | 542 | 15.3% of 3,549 | 504 | 10/54 |
| boxing | wear_blind | 290 | 8.2% of 3,549 | 2,654 | 0/54 |
| boxing | promote_in_remainder | 1,980 | 55.8% of 3,549 | 1,859 | 0/54 |
| boxing | promote_in_remainder_4 | 490 | 13.8% of 3,549 | 453 | 0/54 |
| mma | current | 6 | 0.3% of 2,350 | — | — |
| mma | defence_eligible | 1,794 | 76.3% of 2,350 | 1,678 | 15/17 |
| mma | alternating_4 | 437 | 18.6% of 2,350 | 405 | 7/17 |
| mma | wear_blind | 265 | 11.3% of 2,350 | 1,833 | 0/17 |
| mma | promote_in_remainder | 1,673 | 71.2% of 2,350 | 1,557 | 0/17 |
| mma | promote_in_remainder_4 | 408 | 17.4% of 2,350 | 372 | 0/17 |
| kickboxing | current | 3 | 0.2% of 1,476 | — | — |
| kickboxing | defence_eligible | 1,142 | 77.4% of 1,476 | 1,085 | 9/13 |
| kickboxing | alternating_4 | 271 | 18.4% of 1,476 | 256 | 5/13 |
| kickboxing | wear_blind | 171 | 11.6% of 1,476 | 1,169 | 0/13 |
| kickboxing | promote_in_remainder | 1,054 | 71.4% of 1,476 | 997 | 0/13 |
| kickboxing | promote_in_remainder_4 | 253 | 17.1% of 1,476 | 242 | 0/13 |
| muay_thai | current | 9 | 0.4% of 2,340 | — | — |
| muay_thai | defence_eligible | 1,909 | 81.6% of 2,340 | 1,832 | **22/23** |
| muay_thai | alternating_4 | 467 | 20.0% of 2,340 | 440 | 4/23 |
| muay_thai | wear_blind | 286 | 12.2% of 2,340 | 1,841 | 0/23 |
| muay_thai | promote_in_remainder | 1,733 | 74.1% of 2,340 | 1,656 | 0/23 |
| muay_thai | promote_in_remainder_4 | 428 | 18.3% of 2,340 | 401 | 0/23 |

Muay thai under `defence_eligible` is the clearest cost: **22 of 23 current
knockdowns stop being shown**, and slips alone become 70.3% of that ruleset's
2,340 shown beats under defence_eligible. R102's built-impact slip rate was
11.1%; forcing every defensive window onto the broadcast overshoots past that
and past any readable fight.

---

## Recommendation (with reason) — U48, unchanged on its four rules

**Keep `current` (`knockdown > shocked > highest wear`). Do not ship
`defence_eligible`.**

Reason, from the loss column rather than the defence share:

1. **`defence_eligible` costs 80 of 107 knockdowns** across the pooled 9,715
   windows, and 6,670 of 9,035 cleans. The adapter's own comment says a
   knockdown the player did not see is the drop that reads as a bug. A rule
   that hides three-quarters of them to show slips is worse than the status
   quo Q46 named.
2. **`wear_blind` proves the wear tiebreak is doing real work.** Without it,
   31.9% of shown beats under wear_blind are `missed` / idle. Defence only
   rises to 10.4% of that population. The camera problem is not "wear hates
   blocks"; it is "without wear, the first event in a 14-second window is often
   a miss."
3. **`alternating_4` is the least-bad of the measured alternatives** if the
   operator insists on some defence on screen: 17.7% block+slip of its 9,715,
   26 knockdowns lost, 1,605 cleans lost. That is still a real tax on the
   moments the broadcast was built to protect. It is reported here as the
   ceiling of what these four rules can buy — not as an endorsement.

---

## U49 — the fifth rule (and its every-4th variant)

U48 named the gap: a rule that never overrides knockdown/shocked and only
promotes blocked/slipped among the wear remainder. That is now measured.

**Occurrence (so `kd_lost=0` is not vacuous):** pooled
`remainder_reached=8,934`, `remainder_with_defence=6,440`,
`promote_in_remainder` promotions=`6,440`,
`promote_in_remainder_4` promotions=`1,556`. Both rules reached the promotion
branch thousands of times; `kd_lost=0` is by construction and by count.

**The remainder is not thin.** Of 8,934 windows with neither knockdown nor
shocked, **6,440 already contain a blocked/slipped candidate**. Promoting every
one of them buys **66.3% block+slip** of that rule's 9,715 — almost
`defence_eligible`'s 72.5% — while keeping all 107 knockdowns. The price is
**6,069 cleans lost** (67.2% of current's 9,035). Preserving knockdowns does not
preserve the clean broadcast; the wear remainder is where most cleans live, and
defence wins almost every time it is offered there.

**`promote_in_remainder_4`** (every 4th eligible remainder window): **16.3%**
block+slip of its 9,715, **1,468** cleans lost, **0** knockdowns lost. Against
`alternating_4`'s 17.7% / 1,605 / **26 kd lost**, the every-4th remainder rule
buys a similar defence share for a similar clean tax **without** spending
knockdowns. That is the useful comparison on the price list — not an endorsement
to ship.

**This task does not ship anything.** Whether defence belongs on screen at all
remains the operator's call. The price list is now complete: if the goal is
defence without dropping knockdowns, `promote_in_remainder` shows that goal is
expensive in cleans; `promote_in_remainder_4` shows the throttled version of the
same idea.

---

## Mail line (block+slip% / clean_lost / kd_lost)

- current: 0.3% of 9715 / clean_lost=0 / kd_lost=—
- defence_eligible: 72.5% of 9715 / clean_lost=6670 / kd_lost=80
- alternating_2: 35.9% of 9715 / clean_lost=3302 / kd_lost=40
- alternating_4: 17.7% of 9715 / clean_lost=1605 / kd_lost=26
- wear_blind: 10.4% of 9715 / clean_lost=7497 / kd_lost=0
- promote_in_remainder: 66.3% of 9715 / clean_lost=6069 / kd_lost=0
- promote_in_remainder_4: 16.3% of 9715 / clean_lost=1468 / kd_lost=0
