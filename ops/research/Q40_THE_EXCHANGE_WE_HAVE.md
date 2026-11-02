# Q40 — The Exchange We Have

**measured-at=69d80b641695**
**Harness:** `Godot/tools/measure_exchange.gd`
**Ruleset:** MMA (C85 is changing boxing weights; MMA's are a ruling)
**Bouts:** 200, seeds 200000–200199
**Fighters:** Q34 Boxer A (fiq=50, strike_composite=60.0) vs Q34 Wrestler B (fiq=55, strike_composite=55.0)
**Harness copied verbatim from:** `fight_ufc_units_test.gd` (Q39), same fighter pair as Q34–Q39

---

## NUMBERS

### 1. Run-length distribution (combination proxy)

Denominator: **78,738 total runs** across 200 bouts.

| Run length | Count  | Share of runs | Geometric prediction (p=0.5) |
|------------|--------|---------------|-------------------------------|
| 1          | 39,454 | 50.1%         | 50.0%                         |
| 2          | 19,768 | 25.1%         | 25.0%                         |
| 3          | 9,807  | 12.5%         | 12.5%                         |
| 4          | 4,837  | 6.1%          | 6.25%                         |
| 5+         | 4,872  | 6.2%          | 6.25%                         |

**Mean run length: 1.993 impacts** (geometric prediction: 2.000).

**The measured distribution matches the geometric prediction to within 0.1 percentage points at every bucket.** The engine's impact stream is, statistically, a fair coin flip. G49's central claim — that the coin flip deletes combinations — is confirmed: combinations exist only at the rate a random sequence produces them, and no faster.

In elite amateur boxing, G49 reports, combinations are roughly **half of offensive actions**. Under a fair coin, only 50% of impacts are part of a run of 2+ (i.e., the second or later impact in a run). That means **half of all impacts are isolated singles** — the same rate a random process produces. There is no combination structure beyond what chance generates.

### 2. Volume share

Denominator: **200 bouts.**

| Statistic | Value |
|-----------|-------|
| Min       | 0.500 |
| Median    | 0.511 |
| P90       | 0.530 |
| Max       | 0.610 |

**197 of 200 bouts (98.5% of bouts) have the busier fighter at ≤ 55% of impacts** — within 5 percentage points of 50/50.

G49: "Real fight volume is emphatically not 50/50; Mayweather–Marquez was 493 v 583 thrown." Our engine produces a volume share that is 50/50 in almost every bout. The better striker throws exactly as often as the man he is beating. **Volume asymmetry does not exist in the output.**

### 3. Skill vs output

**NOT DERIVABLE from this harness.** Both fighters have fixed attributes across all 200 bouts (A: fiq=50, strike_composite=60.0; B: fiq=55, strike_composite=55.0). The attribute difference is constant, so Pearson r has zero variance in the x-axis and is undefined (0/0). The correlation reads 0.0000, which is the correct output for a degenerate input, not a measurement.

A meaningful skill-vs-output correlation requires varying attributes across bouts. This is a harness limitation, not an engine finding. The fair-coin prediction (r ≈ 0) is trivially satisfied because the harness cannot test it.

### 4. Inter-impact interval

Denominator: **156,745 intervals** across 200 bouts.

| Statistic | Ticks | Seconds (at 20 Hz) |
|-----------|-------|---------------------|
| Min       | 2     | 0.100               |
| Median    | 6     | 0.300               |
| P90       | 52    | 2.600               |
| Max       | 1,600 | 80.000              |

**39,317 of 156,745 intervals (25.1% of intervals) exceed 1.0 second.**

The median gap between consecutive impacts is 0.3 s — fast enough that a 4-punch combination at this cadence would run ~0.9 s contact-to-contact, comparable to G49's lab measurement of ~1.05 s. But the tail is long: one in four gaps is over a second, and the maximum is 80 seconds (a full round with no action). The distribution is bimodal: fast intra-exchange gaps and slow between-exchange gaps, with no clear separation at any single threshold.

### 5. Burst structure

**AUTHORED threshold: 40 ticks (2.0 s).** Justification: separates in-combo cadence (median 0.3 s) from between-exchange resets. Labelled AUTHORED — no published MMA study gives a canonical gap threshold at impact grain.

Denominator: **22,456 bursts** across 200 bouts.

| Statistic | Value |
|-----------|-------|
| Min       | 1 impact |
| Median    | 4 impacts |
| Mean      | 7.0 impacts |
| P90       | 13 impacts |
| Max       | 573 impacts |

- **Single-impact bursts:** 2,767 (12.3% of bursts)
- **Multi-impact bursts (≥ 2):** 19,689 (87.7% of bursts)

**Burst ownership** (denominator: 22,456 bursts):

| Owner | Count | Share of bursts |
|-------|-------|-----------------|
| A only | 2,858 | 12.7% |
| B only | 2,976 | 13.3% |
| Shared (both threw) | 16,622 | 74.0% |

Under a fair coin with no burst structure, shared bursts should dominate — and they do at 74%. Neither fighter owns a burst more often than chance. **Burst ownership does not exist in the output.**

The max burst of 573 impacts is notable: it means an entire round (or close to it) passed without a 2-second gap. This is the engine producing a wall of alternating impacts with no pause — the same shape as a real exchange in terms of duration, but with neither man owning it.

---

## PROSE

### What these numbers say

The engine's impact stream is a fair coin. Every measurable G49 predicted the coin flip would erase is confirmed erased:

1. **Combinations exist only at chance rates.** The run-length distribution is geometric(p=0.5) to within measurement noise. A "combination" in this engine is what a coin flip produces — no more, no less.

2. **Volume is 50/50 in 98.5% of bouts.** The busier fighter in our engine throws at most 61% of impacts (in the most lopsided of 200 bouts). Real fights routinely see 55–60% from the busier man. Our engine cannot produce that.

3. **Burst ownership is absent.** 74% of bursts are shared. Neither man "takes" an exchange. In a real fight, one man typically owns a burst — he throws three or four while the other covers. Our engine produces exchanges where both men throw in every burst, because the coin flip gives each man roughly half the impacts regardless of who started it.

### What the numbers do NOT say

- **Momentum is not measured here.** G49 explicitly recommends against modelling "who just landed." This measurement does not test momentum — it tests the coin flip's effect on combination structure, volume asymmetry and burst ownership. Those three are measured; momentum is not.

- **Skill vs output is not tested.** The harness uses fixed fighters. A meaningful test needs varied attributes — that is a separate measurement, not one this harness can produce.

- **The burst threshold is authored.** 2.0 s is a judgment call. Changing it changes the burst count and lengths but not the ownership split (which is dominated by the coin flip regardless of threshold).

### Implications for R101

R101 replaces `rng.randf() < 0.5` at FightRealtime.gd:1287. The before-picture, in one line:

> **The engine produces a geometric(p=0.5) run-length distribution, 50/50 volume in 98.5% of bouts, and zero burst ownership. Every figure matches the fair-coin prediction.**

The after-picture needs to move at least three numbers: the run-length distribution (more 2+ runs), the volume-share distribution (wider, with the median shifting away from 0.500), and burst ownership (fewer shared bursts, more single-fighter bursts). If R101 moves all three, the baseline above is what it moves from.

---

## NOT DERIVABLE

1. **Skill-vs-output correlation.** The harness uses fixed fighters, so attribute differences have zero variance. A meaningful measurement requires varying attributes across bouts (e.g. a seed-scan that swaps fight_iq or the strike composite between bouts).

2. **Strike type (jab/cross/hook/kick/elbow/knee).** The engine has no punch type field. Every impact is the same abstract event with a region and a force.

3. **Significant vs total strikes.** No significance filter exists. Every landed blow counts equally.

4. **P(next strike is also A | A just threw).** Not published externally either. Derivable from the run-length data above: under geometric(p=0.5), P(same | same just threw) = 0.5 by definition. The engine matches this.

5. **Distance at impact.** The log records it (`event["distance"]`) but this measurement did not histogram it. Q32 measured it on a different seed set.

6. **Time of stoppage within a round.** The engine records it but this harness did not extract it.
