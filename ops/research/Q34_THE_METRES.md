# Q34 — The Metres

**Task:** TASK_Q34.md
**Tool:** `Godot/tests/fight_metres_test.gd`
**Date:** 2026-09-10
**Ruleset:** Boxing (primary), MMA (comparison)
**Bouts:** 200 seeded bouts per configuration, seeds 200000–200199
**Fighters (default pair):** Q34 Boxer A (reach 183 cm) vs Q34 Wrestler B (reach 176 cm)
**Reach calibration:** short pair (165/162 cm), default (183/176 cm), tall pair (195/190 cm), 200 bouts each

---

## 1. Separation at the moment a strike is SCORED

Boxing, 200 bouts, 148,232 scored strikes:

| Metric   | Separation (m) |
|----------|---------------|
| Min      | 0.0000        |
| P05      | 0.3290        |
| P25      | 0.6686        |
| Median   | 0.8851        |
| P75      | 1.0103        |
| P95      | 1.0832        |
| Max      | 1.1000        |
| Mean     | 0.8151        |

**The max is exactly 1.1000 m — the flat `STRIKE_RANGE` constant.** No strike was ever scored at a separation above the gate. The distribution is continuous from 0.0 to 1.1 with no gaps.

---

## 2. Separation at the moment the attempt gate is EVALUATED

Boxing, 1,853,276 gate evaluations (standing, impact cadence ticks):

| Metric   | Separation (m) |
|----------|---------------|
| Min      | 0.0000        |
| P05      | 0.5750        |
| P25      | 1.0571        |
| Median   | 1.3185        |
| P75      | 1.5903        |
| P95      | 2.0697        |
| Max      | 3.6944        |
| Mean     | 1.3222        |

**The median gate-evaluation separation is 1.32 m — above the 1.1 m gate.** Most of the fight is spent out of range. The gate rejects the majority of evaluations; only when fighters close to ≤ 1.1 m does an attempt proceed.

---

## 3. Histogram — scored strikes in 0.1 m buckets

Boxing, 148,232 scored strikes:

| Bucket       | Count  | Percentage |
|--------------|--------|------------|
| [0.0, 0.1)  | 779    | 0.5 %      |
| [0.1, 0.2)  | 1,823  | 1.2 %      |
| [0.2, 0.3)  | 3,571  | 2.4 %      |
| [0.3, 0.4)  | 5,185  | 3.5 %      |
| [0.4, 0.5)  | 7,573  | 5.1 %      |
| [0.5, 0.6)  | 10,564 | 7.1 %      |
| [0.6, 0.7)  | 11,421 | 7.7 %      |
| [0.7, 0.8)  | 15,073 | 10.2 %     |
| [0.8, 0.9)  | 21,873 | 14.8 %     |
| [0.9, 1.0)  | 29,585 | 20.0 %     |
| [1.0, 1.1)  | 40,785 | 27.5 %     |
| [1.1, 1.2)  | 0      | 0.0 %      |

**Histogram sum: 148,232 = scored strikes.** The distribution is heavily right-skewed toward the gate: 47.5 % of all scored strikes land in the top two buckets ([0.9, 1.1)). The mode is the [1.0, 1.1) bucket at 27.5 %.

---

## 4. Separation against the thrower's reach_cm

Combined reach calibration: 600 bouts (200 each × 3 reach pairs), 455,999 scored strikes:

| Reach bucket | n       | Median separation (m) |
|--------------|---------|----------------------|
| < 170 cm     | 185,764 | 0.8788               |
| 170–184 cm   | 148,232 | 0.8851               |
| 185–199 cm   | 122,003 | 0.8825               |
| ≥ 200 cm     | 0       | (no data)            |

**Prediction confirmed: the medians are the SAME.** Across a 30 cm spread of reach (162–195 cm), the median scored-strike separation varies by only 0.006 m (less than 1 %). The flat `STRIKE_RANGE` gate is reach-blind, exactly as the code predicts. A 165 cm man and a 195 cm man score their strikes at the same distance.

The reason is structural: `STRIKE_RANGE := 1.1` is a `const` that does not read `reach_cm`. The gate is the same number for every fighter regardless of arm length.

---

## 5. In-range fraction

| Ruleset | Ticks with sep ≤ 1.1 | Total ticks | Fraction |
|---------|---------------------|-------------|----------|
| Boxing  | 1,062,193           | 3,706,360   | 28.7 %   |
| MMA     | 1,157,376           | 3,419,493   | 33.9 %   |

**Roughly 29 % of boxing ticks and 34 % of MMA ticks are inside striking range.** The rest is spent at distance — circling, closing, retreating. MMA's higher fraction is consistent with its shorter preferred ranges (grapple threat pulls men in).

---

## 6. The floor

| Ruleset | Floor (standing) | Floor (overall) |
|---------|-----------------|-----------------|
| Boxing  | 0.0000 m        | 0.0000 m        |
| MMA     | 0.0000 m        | 0.0000 m        |

**The smallest separation the engine ever produces is zero.** Two men can occupy the same point. There is no collision body, no minimum-distance clamp, no pushback. The 779 boxing strikes in the [0.0, 0.1) bucket confirm this is not a rare edge case — it happens in 0.5 % of all scored strikes. `RingSpace.clamp_to_floor` keeps men inside the ring edges but does not keep them apart from each other.

---

## 7. MMA comparison

MMA, 200 bouts, 159,671 scored strikes:

| Metric   | Boxing   | MMA      |
|----------|----------|----------|
| Median   | 0.8851   | 0.8666   |
| P05      | 0.3290   | 0.2674   |
| P95      | 1.0832   | 1.0828   |
| Max      | 1.1000   | 1.1000   |
| Mean     | 0.8151   | 0.7913   |

**The numbers barely move.** MMA's median is 0.019 m lower (1.8 %) and its P05 is 0.062 m lower (fighters get slightly closer in MMA), but the shape is the same: right-skewed, capped at 1.1, with the mode in the [1.0, 1.1) bucket. The same flat `STRIKE_RANGE` gates both rulesets, and the data shows it.

---

## VERDICT

**Yes, `separation` is a physical quantity we can hand to an animator.** It is a Euclidean distance in metres over `pos_x`/`pos_y` fixed-point positions, bounded by the ring dimensions, with a continuous distribution from 0.0 to 1.1 m at the moment of a scored strike. The metres are real.

**The flat `STRIKE_RANGE` shows up in the data as reach-blindness, exactly as predicted.** Three reach pairs spanning 162–195 cm produce median scored-strike separations of 0.879, 0.885, and 0.883 m — the same number within measurement noise. The gate does not read `reach_cm` and the data proves it: a long-armed man and a short-armed man throw their punches at the same distance. If the design intent is for reach to matter, the number that is wrong is `STRIKE_RANGE` — it should be a function of the thrower's reach, not a flat 1.1 m for every man who ever fights.
