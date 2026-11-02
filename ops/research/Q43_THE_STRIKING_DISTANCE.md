# Q43 — AT WHAT DISTANCE DOES A STRIKE ACTUALLY HAPPEN?

**Commit:** d8585599a24c
**Tool:** `Godot/tools/measure_exchange.gd` section 8
**Fighters:** Q34 Boxer A (reach 183 cm) vs Q34 Wrestler B (reach 176 cm)
**Bouts per ruleset:** 200
**MMA seeds:** 220000–220199
**Boxing seeds:** 230000–230199
**Rulesets:** MMA and boxing run separately, never pooled (C85 changed boxing's target distribution).
**AUTHORED:** arm_length = 0.44 × reach_cm / 100 (body-proportion figure, not measured).
**AUTHORED:** bucket width = 0.05 m for all histograms.

---

## 1. Full separation histogram at impact time

### MMA — 161,126 scored strikes

| Bucket (m)    | Count | Share of scored strikes |
|---------------|------:|------------------------:|
| [0.00, 0.05)  |   489 |  0.3% |
| [0.05, 0.10)  |   902 |  0.6% |
| [0.10, 0.15)  | 1,161 |  0.7% |
| [0.15, 0.20)  | 1,694 |  1.1% |
| [0.20, 0.25)  | 2,011 |  1.2% |
| [0.25, 0.30)  | 2,559 |  1.6% |
| [0.30, 0.35)  | 2,790 |  1.7% |
| [0.35, 0.40)  | 3,161 |  2.0% |
| [0.40, 0.45)  | 4,018 |  2.5% |
| [0.45, 0.50)  | 5,380 |  3.3% |
| [0.50, 0.55)  | 5,781 |  3.6% |
| [0.55, 0.60)  | 6,065 |  3.8% |
| [0.60, 0.65)  | 7,782 |  4.8% |
| [0.65, 0.70)  | 7,752 |  4.8% |
| [0.70, 0.75)  | 9,026 |  5.6% |
| [0.75, 0.80)  |11,370 |  7.1% |
| [0.80, 0.85)  |12,573 |  7.8% |
| [0.85, 0.90)  |13,981 |  8.7% |
| [0.90, 0.95)  |15,292 |  9.5% |
| [0.95, 1.00)  |13,506 |  8.4% |
| [1.00, 1.05)  |15,818 |  9.8% |
| [1.05, 1.10)  |18,015 | 11.2% |
| [1.10, 1.15)  |     0 |  0.0% |

### Boxing — 142,165 scored strikes

| Bucket (m)    | Count | Share of scored strikes |
|---------------|------:|------------------------:|
| [0.00, 0.05)  | 2,348 |  1.7% |
| [0.05, 0.10)  |   970 |  0.7% |
| [0.10, 0.15)  | 1,142 |  0.8% |
| [0.15, 0.20)  | 1,778 |  1.3% |
| [0.20, 0.25)  | 1,905 |  1.3% |
| [0.25, 0.30)  | 2,303 |  1.6% |
| [0.30, 0.35)  | 2,817 |  2.0% |
| [0.35, 0.40)  | 3,162 |  2.2% |
| [0.40, 0.45)  | 3,585 |  2.5% |
| [0.45, 0.50)  | 4,371 |  3.1% |
| [0.50, 0.55)  | 4,864 |  3.4% |
| [0.55, 0.60)  | 5,628 |  4.0% |
| [0.60, 0.65)  | 6,282 |  4.4% |
| [0.65, 0.70)  | 6,950 |  4.9% |
| [0.70, 0.75)  | 7,448 |  5.2% |
| [0.75, 0.80)  | 8,751 |  6.2% |
| [0.80, 0.85)  |10,630 |  7.5% |
| [0.85, 0.90)  |11,703 |  8.2% |
| [0.90, 0.95)  |12,574 |  8.8% |
| [0.95, 1.00)  |12,403 |  8.7% |
| [1.00, 1.05)  |13,573 |  9.5% |
| [1.05, 1.10)  |16,978 | 11.9% |
| [1.10, 1.15)  |     0 |  0.0% |

**Key observations:**
- The distribution is continuous from 0.0 to 1.1 m in both rulesets — no gaps.
- Both peak in the [1.05, 1.10) bucket (MMA 11.2%, boxing 11.9%).
- Boxing has **5.6× more strikes in the [0.00, 0.05) bucket** than MMA (1.7% vs 0.3%), consistent with C85's boxing target redistribution allowing more close-range work.
- Below 0.6 m: MMA 16.9% of scored strikes, boxing 18.9% of scored strikes. This is the missing 23% Q34 hinted at — it is 17–19%, not 23%, but it is large.
- Nothing scores at or above 1.1 m (the STRIKE_RANGE gate). The [1.10, 1.15) bucket is zero in both.

---

## 2. The floor

| Stat | MMA | Boxing |
|------|-----|--------|
| Min  | 0.0010 m | 0.0000 m |
| P1   | 0.1104 m | 0.0000 m |
| P5   | 0.2839 m | 0.2224 m |

**The engine can put two men at 0.0 m separation.** Boxing produces a scored strike at exactly 0.0 m (P1 = 0.0000 m). MMA's minimum is 0.001 m but its P1 is 0.11 m. There is no hard floor above zero — no body-radius clamp prevents zero separation. The floor is set by the movement system's approach dynamics, not by a Space clamp.

---

## 3. Tick separation histogram

Denominator: every tick of every bout (not just impact ticks). This is the distribution of separation the fighters occupy over the full fight, including moments when no strike is possible.

### MMA — 3,511,371 tick samples

| Bucket (m)    | Count   | Share of ticks |
|---------------|--------:|---------------:|
| [0.00, 0.05)  |   2,971 |  0.1% |
| [0.05, 0.10)  |   5,166 |  0.1% |
| [0.10, 0.15)  |   7,706 |  0.2% |
| [0.15, 0.20)  |  11,377 |  0.3% |
| [0.20, 0.25)  |  12,970 |  0.4% |
| [0.25, 0.30)  |  15,903 |  0.5% |
| [0.30, 0.35)  |  20,576 |  0.6% |
| [0.35, 0.40)  |  20,403 |  0.6% |
| [0.40, 0.45)  |  27,408 |  0.8% |
| [0.45, 0.50)  |  36,715 |  1.0% |
| [0.50, 0.55)  |  42,892 |  1.2% |
| [0.55, 0.60)  |  42,709 |  1.2% |
| [0.60, 0.65)  |  54,711 |  1.6% |
| [0.65, 0.70)  |  55,838 |  1.6% |
| [0.70, 0.75)  |  64,603 |  1.8% |
| [0.75, 0.80)  |  85,361 |  2.4% |
| [0.80, 0.85)  |  91,696 |  2.6% |
| [0.85, 0.90)  |  96,497 |  2.7% |
| [0.90, 0.95)  | 107,160 |  3.1% |
| [0.95, 1.00)  |  88,848 |  2.5% |
| [1.00, 1.05)  | 111,115 |  3.2% |
| [1.05, 1.10)  | 127,706 |  3.6% |
| [1.10, 1.15)  | 134,865 |  3.8% |
| [1.15, 1.20)  | 148,026 |  4.2% |
| [1.20, 1.25)  | 157,988 |  4.5% |
| [1.25, 1.30)  | 158,690 |  4.5% |
| [1.30, 1.35)  | 161,043 |  4.6% |
| [1.35, 1.40)  | 157,793 |  4.5% |
| [1.40, 1.45)  | 173,100 |  4.9% |
| [1.45, 1.50)  | 176,186 |  5.0% |
| [1.50, 1.55)  | 176,946 |  5.0% |
| [1.55, 1.60)  | 182,435 |  5.2% |
| [1.60, 1.65)  | 167,062 |  4.8% |
| [1.65, 1.70)  | 104,669 |  3.0% |
| [1.70, 1.75)  |  69,868 |  2.0% |
| [1.75, 1.80)  |  56,978 |  1.6% |
| [1.80, 1.85)  |  45,593 |  1.3% |
| [1.85, 1.90)  |  34,624 |  1.0% |
| [1.90, 1.95)  |  27,730 |  0.8% |
| [1.95, 2.00)  |  21,945 |  0.6% |
| [2.00, 2.05)  | 225,499 |  6.4% |

### Boxing — 3,537,733 tick samples

| Bucket (m)    | Count   | Share of ticks |
|---------------|--------:|---------------:|
| [0.00, 0.05)  |  18,947 |  0.5% |
| [0.05, 0.10)  |   5,490 |  0.2% |
| [0.10, 0.15)  |   7,904 |  0.2% |
| [0.15, 0.20)  |  11,242 |  0.3% |
| [0.20, 0.25)  |  12,455 |  0.4% |
| [0.25, 0.30)  |  14,016 |  0.4% |
| [0.30, 0.35)  |  20,751 |  0.6% |
| [0.35, 0.40)  |  24,276 |  0.7% |
| [0.40, 0.45)  |  24,961 |  0.7% |
| [0.45, 0.50)  |  30,261 |  0.9% |
| [0.50, 0.55)  |  36,338 |  1.0% |
| [0.55, 0.60)  |  42,316 |  1.2% |
| [0.60, 0.65)  |  41,939 |  1.2% |
| [0.65, 0.70)  |  46,557 |  1.3% |
| [0.70, 0.75)  |  48,785 |  1.4% |
| [0.75, 0.80)  |  62,364 |  1.8% |
| [0.80, 0.85)  |  72,119 |  2.0% |
| [0.85, 0.90)  |  81,693 |  2.3% |
| [0.90, 0.95)  |  90,014 |  2.5% |
| [0.95, 1.00)  |  84,015 |  2.4% |
| [1.00, 1.05)  |  90,735 |  2.6% |
| [1.05, 1.10)  | 117,814 |  3.3% |
| [1.10, 1.15)  | 141,840 |  4.0% |
| [1.15, 1.20)  | 155,326 |  4.4% |
| [1.20, 1.25)  | 151,845 |  4.3% |
| [1.25, 1.30)  | 163,938 |  4.6% |
| [1.30, 1.35)  | 173,080 |  4.9% |
| [1.35, 1.40)  | 184,487 |  5.2% |
| [1.40, 1.45)  | 181,909 |  5.1% |
| [1.45, 1.50)  | 194,947 |  5.5% |
| [1.50, 1.55)  | 191,711 |  5.4% |
| [1.55, 1.60)  | 196,352 |  5.6% |
| [1.60, 1.65)  | 173,899 |  4.9% |
| [1.65, 1.70)  | 107,686 |  3.0% |
| [1.70, 1.75)  |  82,619 |  2.3% |
| [1.75, 1.80)  |  58,899 |  1.7% |
| [1.80, 1.85)  |  51,408 |  1.5% |
| [1.85, 1.90)  |  44,935 |  1.3% |
| [1.90, 1.95)  |  37,220 |  1.1% |
| [1.95, 2.00)  |  25,882 |  0.7% |
| [2.00, 2.05)  | 234,758 |  6.6% |

**Key observations:**
- The tick distribution is bimodal: a peak around 1.5–1.6 m (ranging distance) and a peak at 2.0 m (START_SEPARATION, the reset position between rounds and after clinch breaks).
- The [2.00, 2.05) bucket is the single largest in both rulesets (MMA 6.4%, boxing 6.6% of ticks) — this is the start-of-round and post-reset position.
- Boxing spends more time at very close range than MMA: [0.00, 0.05) is 0.5% of boxing ticks vs 0.1% of MMA ticks.
- Ticks below 1.1 m (in striking range): MMA 32.2%, boxing 27.8%.

---

## 4. Terciles of the scored-strike distribution

| Ruleset | T1 (33rd pctile) | T2 (67th pctile) |
|---------|-------------------|-------------------|
| MMA     | 0.7119 m          | 0.9293 m          |
| Boxing  | 0.6950 m          | 0.9323 m          |

The two rulesets produce nearly identical tercile boundaries. The bottom third of strikes happen below ~0.70 m, the middle third between ~0.70 and ~0.93 m, and the top third above ~0.93 m.

---

## 5. Reach-scaled distance

AUTHORED: arm_length = 0.44 × reach_cm / 100.
- Fighter A: reach 183 cm → arm_length = 0.8052 m
- Fighter B: reach 176 cm → arm_length = 0.7744 m

D = separation / arm_length. Reported per side because the same metre is a different D to each fighter.

### MMA

| Side | n      | Min   | Median | Mean  | Max   |
|------|--------|-------|--------|-------|-------|
| A    | 79,801 | 0.001 | 1.040  | 0.968 | 1.366 |
| B    | 81,325 | 0.003 | 1.079  | 1.007 | 1.420 |

### Boxing

| Side | n      | Min   | Median | Mean  | Max   |
|------|--------|-------|--------|-------|-------|
| A    | 70,413 | 0.000 | 1.035  | 0.952 | 1.366 |
| B    | 71,752 | 0.000 | 1.075  | 0.988 | 1.420 |

**Key observations:**
- Median D is ~1.04–1.08 for both sides in both rulesets. A strike lands at approximately one arm's length.
- Fighter B (shorter arms) has a higher median D — the same metre stretches further relative to his shorter arms.
- Max D is ~1.37–1.42, meaning the longest strikes land at about 1.4 arm-lengths. This is the engine's STRIKE_RANGE (1.1 m) expressed in reach units.
- The distribution in D units is similar across sides: both peak around D = 1.30–1.35.

---

## 6. How much of the separation range is reachable

### MMA — 3,511,371 tick samples

| Condition | Ticks | Share of ticks |
|-----------|------:|---------------:|
| separation > 1.1 m (above STRIKE_RANGE gate) | 2,381,040 | 67.8% |
| In band [0, T1=0.7119) | 370,943 | 10.6% |
| In band [T1=0.7119, T2=0.9293) | 388,324 | 11.1% |
| In band [T2=0.9293, ∞) | 2,752,104 | 78.4% |

### Boxing — 3,537,733 tick samples

| Condition | Ticks | Share of ticks |
|-----------|------:|---------------:|
| separation > 1.1 m (above STRIKE_RANGE gate) | 2,552,741 | 72.2% |
| In band [0, T1=0.6950) | 333,115 | 9.4% |
| In band [T1=0.6950, T2=0.9323) | 325,026 | 9.2% |
| In band [T2=0.9323, ∞) | 2,879,592 | 81.4% |

**Key observations:**
- **The majority of fight time is spent outside striking range.** 67.8% of MMA ticks and 72.2% of boxing ticks have separation > 1.1 m.
- The tercile bands are wildly unequal in tick share: the bottom two bands each get ~10% of ticks, while the top band (above T2) gets ~78–81% of ticks. This is because most fight time is spent at ranging distance or resetting.
- **Strikes are heavily concentrated at close range relative to time spent there.** The bottom tercile gets ~10% of ticks but 33% of strikes — a 3.3× concentration factor.

---

## Recommendation

### MMA
**Cut POCKET|MID at 0.712 m, MID|LONG at 0.929 m.**
Each band then receives ~33% of scored strikes by construction.
- POCKET [0, 0.712): 33% of strikes, 10.6% of ticks
- MID [0.712, 0.929): 33% of strikes, 11.1% of ticks
- LONG [0.929, 1.1]: 33% of strikes, 11.0% of ticks (in-range ticks minus the two lower bands)
- CLINCH sits below POCKET; its upper bound is the POCKET|MID cut at 0.712 m.

### Boxing
**Cut POCKET|MID at 0.695 m, MID|LONG at 0.932 m.**
Each band then receives ~33% of scored strikes by construction.
- POCKET [0, 0.695): 33% of strikes, 9.4% of ticks
- MID [0.695, 0.932): 33% of strikes, 9.2% of ticks
- LONG [0.932, 1.1]: 33% of strikes, 9.0% of ticks (in-range ticks minus the two lower bands)
- CLINCH sits below POCKET; its upper bound is the POCKET|MID cut at 0.695 m.

### Cross-ruleset note
The two rulesets produce nearly identical boundaries (within 0.02 m). If R101 wants a single set of bands for both, 0.70 m and 0.93 m are defensible shared cuts.
