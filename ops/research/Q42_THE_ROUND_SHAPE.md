# Q42 — The Round Shape at the PI Grain

**measured-at=0de86f03cb13**
**Harness:** `Godot/tools/measure_exchange.gd` (section 7, extended in this task)
**Ruleset:** MMA (3 × 300 s rounds, 20 Hz tick)
**Bouts:** 200, seeds 200000–200199 (same pair as Q40–Q41)
**Fighters:** Q34 Boxer A vs Q34 Wrestler B
**Rounds in denominator:** 537 (not all bouts go the distance — stoppages shorten some)
**Grade target:** G52 (`G52_THE_SHAPE_OF_A_ROUND.md`), the UFC Performance Institute block

---

## AUTHORED CHOICES

| Parameter | Value | Justification |
|-----------|-------|---------------|
| Window size | 2.0 s (40 ticks) | Resolves the start/end of exchanges without smoothing them into oblivion. AUTHORED. |
| HI threshold | ≥ 6 events per 2 s window (3.0/s) | Matches the engine's own median inter-impact cadence of 0.3 s (Q40 §4). Below this is ranging/recovery; at or above is a real exchange. AUTHORED. |
| Activity definition | action + grapple events | Both are high-intensity activity in MMA. AUTHORED. |

These are NOT the Q40 burst threshold (40 ticks / 2.0 s gap between impacts). That separates in-combination cadence from between-exchange resets at the *impact* grain. The PI block is an *activity* grain lasting tens of seconds. **The two must not be conflated** (G52 explicit).

---

## NUMBERS — GRADED AGAINST G52

### 1. HI blocks per round

| Statistic | Value |
|-----------|-------|
| Min | 0 |
| Median | 6 |
| Mean | 6.6 |
| Max | 38 |

**G52 target: 6–10 HI blocks per 5-min round.**
**PASS (CEILING):** 287 of 537 rounds (53.4%) sit in [6..10]. The median hits the band at exactly 6. The mean (6.6) is inside. The max (38) is an outlier — a round that never settled into a rhythm.

### 2. HI block duration

| Statistic | Value |
|-----------|-------|
| Min | 2.0 s |
| P10 | 2.0 s |
| Median | 2.0 s |
| Mean | 3.9 s |
| P90 | 8.0 s |
| Max | 82.0 s |

**G52 target: 6–36 s per HI block.**
**OUTSIDE BAND (FLOOR):** only 456 of 3,562 HI blocks (12.8%) reach 6 s. The median block is a single 2-second window — a brief flurry, not a sustained high-intensity period. The P90 (8.0 s) clears the floor but the distribution is heavily right-skewed toward the minimum. **The engine produces the right NUMBER of active periods but they are too brief.**

### 3. LO stretch duration

| Statistic | Value |
|-----------|-------|
| Min | 2.0 s |
| Median | 20.0 s |
| Mean | 31.7 s |
| Max | 256.0 s |

**G52 target: LO stretch = 2–3× the HI duration.**
With median HI at 2.0 s, the expected LO would be 4–6 s. The measured median LO is 20.0 s — **10× the HI median, far above the 2–3× target.** The gaps between active periods are too long.

### 4. HI:LO ratio (inverted: LO/HI per round)

| Statistic | Value |
|-----------|-------|
| Min | 0.744 |
| Median | 15.667 |
| Max | 999.000 (rounds with zero HI windows) |

**G52 target: HI:(LO+pause) = 1:2 to 1:4 of in-round time → LO/HI = 2.0 to 4.0.**
**OUTSIDE BAND (FLOOR):** only 42 of 537 rounds (7.8%) sit in [2.0..4.0]. The median LO/HI ratio is 15.7 — the engine spends **15.7 times as long in LO as in HI**, where G52 says it should be 2–4 times. **The engine is a drizzle: brief sparks of activity separated by long stretches of nothing.**

### 5. HI time share

| Metric | Value |
|--------|-------|
| Total HI windows | 6,967 / 80,550 (8.6%) |
| Total LO windows | 73,583 / 80,550 (91.4%) |

**G52 implies HI should be 20–33% of in-round time** (from the 1:2 to 1:4 ratio). Measured: 8.6%. **OUTSIDE BAND (FLOOR).**

---

## SUMMARY VERDICT

| Metric | G52 Target | Measured | Verdict |
|--------|-----------|----------|---------|
| HI blocks per round | 6–10 | median 6, 53.4% in band | **PASS** |
| HI block duration | 6–36 s | median 2.0 s, 12.8% in band | **OUTSIDE BAND** — too short |
| LO stretch vs HI | 2–3× HI duration | median 10× HI duration | **OUTSIDE BAND** — too long |
| HI:(LO+pause) ratio | 1:2 to 1:4 | 1:15.7 (median) | **OUTSIDE BAND** — too little HI |
| HI time share | 20–33% | 8.6% | **OUTSIDE BAND** — too little |

**One of five metrics passes.** The engine produces the right number of active periods per round, but each period is a 2-second spark followed by 20 seconds of nothing. The temporal shape is a drizzle, not the UFC PI's cycle of sustained high-intensity blocks separated by moderate recovery.

**This is a finding for R101, not a defect to tune away.** The coin flip at FightRealtime.gd:1287 produces impacts at a rate that matches SLpM totals (Q40 confirmed) but distributes them as isolated events rather than sustained exchanges. R101 must make the active periods longer and the gaps shorter — not by changing the threshold above, but by changing how the engine generates activity within a round.

---

## PROSE

### What the numbers say

The engine's round shape has the right skeleton but the wrong flesh. It produces ~7 active periods per round (matching G52's 6–10), which means the engine "knows" when to be active and when to rest at a macro level. But each active period is a single 2-second window of 6+ events, not a 6–36 second sustained exchange. The result is a fight that looks busy on a totals spreadsheet but feels empty to watch: spark, wait, spark, wait.

The LO stretches (median 20 s) are not recovery periods — they are voids. In a real MMA round, the low-intensity periods involve circling, feinting, distance management and the occasional clinch. Our engine has none of that: the LO windows are empty because the engine only logs impacts and grapples, and between them there is nothing.

### What the numbers do NOT say

- **This is not a threshold artefact.** Raising the threshold from 3 to 6 moved the block count from 29/round (too many) to 6/round (right). But the duration and ratio metrics moved in the wrong direction: fewer blocks, each shorter, with longer gaps. The problem is structural, not parametric.

- **The 35% metre gate (Q40) is NOT a validation of this.** Our engine measures 35% of ticks inside the 1.1 m gate. Pro boxing notational work reports 35.6% direct contact time. **These are NOT the same quantity** — contact-time is not a metre gate — and the near-match is a coincidence. G52 flags this explicitly. Citing one against the other would repeat the 2026-09-10 error of comparing hand travel with centre-to-centre separation.

- **The three G52 prohibitions are observed:**
  1. **No time-in-range grading.** Our 35% metre gate is NOT the published 35.6% contact-time. Different constructs, coincidental numbers.
  2. **No last-10-s output grading.** NOT PUBLISHED for any sport. Broadcast lore.
  3. **No boxing 18:1 carried to MMA.** Different denominators, different constructs.

### Implications for R101

R101 replaces the coin flip. The before-picture for round shape, in one line:

> **The engine produces 6–7 active periods per round (matching G52) but each is a 2-second spark in a 20-second void. HI time share is 8.6% where G52 expects 20–33%. The round is a drizzle.**

The after-picture needs to move at least three numbers: HI block duration (from median 2 s toward 6+ s), LO stretch duration (from median 20 s toward 4–12 s), and HI time share (from 8.6% toward 20–33%). If R101 moves all three while keeping the block count in [6..10], the round shape will match the UFC PI block.

---

## NOT DERIVABLE

1. **Minute-by-minute output within a round.** NOT PUBLISHED for any sport. CompuBox and academic TMA report per-round totals, not minute splits.
2. **Last-10-s flurry rate.** NOT PUBLISHED. Broadcast lore only.
3. **Time both men inside striking distance (≤ 1.1 m).** No published figure exists at any metre gate. Our 35% is a metre gate, not a contact-time measure.
4. **Exchange-ending event distribution** (counter / exit / clinch / ref / gassing). Not published for MMA. Partial for Olympic boxing as pause type only.
5. **Strike type breakdown within HI blocks** (jab vs cross vs hook vs kick). Engine has no punch type field.
6. **Significant vs total strikes within HI blocks.** No significance filter exists in the engine.
7. **Ground vs standing HI block separation.** The engine logs grapple events but does not distinguish standing grappling from ground work in the log fields available to this harness.
