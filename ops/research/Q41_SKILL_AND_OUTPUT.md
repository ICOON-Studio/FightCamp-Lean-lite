# Q41 — Skill and Output: Can the Engine Distinguish a Better Striker?

**measured-at=0afc40dfbe26**
**Harness:** `Godot/tools/measure_exchange.gd` (section 6, extended in this task)
**Ruleset:** MMA (C85 is changing boxing weights; MMA's are a ruling)
**Bouts:** 210, seeds 210000–210209
**Attribute varied:** Fighter A's power, technique and speed — all set to the same
value, called `strike_composite`. This is the composite Q40 used
(`mean(power, technique, speed)`), chosen because it is the attribute cluster
that most directly drives striking output.
**Range:** strike_composite 40 to 80, step 2 (21 levels), 10 bouts per level.
**Fighter B:** fixed at Q34 Wrestler B (strike_composite = 55.0).
**Seeds NOT comparable to Q40 bout-for-bout.** Q40 used seeds 200000–200199 with
a fixed fighter pair. Q41 uses seeds 210000–210209 with a different fighter A
at every level. What carries over is the method, not the values.

---

## NUMBERS

### Pearson r

Denominator: **210 bouts.**

| Quantity | Value |
|---|---|
| r(strike_composite_gap, volume_diff) | **−0.1248** |
| n | 210 |
| Mean skill gap (A − B) | +5.0 |
| x-axis variance | **Non-zero** (range −15 to +25, 21 distinct values) |

**The x-axis now has variance.** This is the whole difference from Q40, where
Pearson r was undefined (0/0) because both fighters were fixed. Here, fighter A's
strike_composite ranges from 40 to 80 against a fixed B at 55, giving a skill gap
from −15 to +25 with 21 distinct values. The x-axis is not degenerate.

**r = −0.1248 is approximately zero.** Under a fair coin, r should be zero with
real x-axis variance. The measured value is slightly negative — meaning the
higher-skill fighter throws *very slightly less* — but the effect is small enough
to be seed noise at n=210. **Skill does not buy output in this engine.**

### Binned by skill gap

Denominator: **210 bouts** (10 per skill level, binned into 8 ranges).

| Skill gap (A−B) | n  | mean vol_diff | mean bout length | mean total impacts |
|---|---|---|---|---|
| [−20, −10) | 30 | −0.0082 | 17554 ticks (878 s) | 1755 |
| [−10, −5)  | 20 | +0.0134 | 17108 ticks (855 s) | 1711 |
| [−5, 0)    | 30 | −0.0082 | 17811 ticks (891 s) | 1781 |
| [0, +5)    | 20 | −0.0318 | 18673 ticks (934 s) | 1867 |
| [+5, +10)  | 30 | +0.0033 | 18193 ticks (910 s) | 1819 |
| [+10, +15) | 20 | −0.0203 | 17081 ticks (854 s) | 1708 |
| [+15, +20) | 30 | −0.0272 | 17399 ticks (870 s) | 1740 |
| [+20, +30) | 30 | −0.0161 | 18402 ticks (920 s) | 1840 |

vol_diff = vol_A − vol_B. Positive means fighter A (the varied fighter) throws
more. **No bin shows a systematic trend.** The volume difference hovers around
zero regardless of whether A is the weaker or the stronger striker. The largest
magnitude is −0.0318 at [0, +5) — meaning A throws 3.2% *less* when slightly
better — which is the wrong direction for a skill effect.

### Output asymmetry vs skill gap

Does the volume split widen as the skill gap widens? Under a fair coin it cannot.

Denominator: **210 bouts**, binned as above.

| Skill gap (A−B) | n  | mean \|vol_diff\| |
|---|---|---|
| [−20, −10) | 30 | 0.0358 |
| [−10, −5)  | 20 | 0.0297 |
| [−5, 0)    | 30 | 0.0345 |
| [0, +5)    | 20 | 0.0532 |
| [+5, +10)  | 30 | 0.0269 |
| [+10, +15) | 20 | 0.0263 |
| [+15, +20) | 30 | 0.0318 |
| [+20, +30) | 30 | 0.0268 |

**No monotonic increase.** The mean absolute volume difference stays between
0.026 and 0.053 across all bins — a range of less than 3 percentage points —
with no trend as the skill gap widens from 15 to 25. The highest value (0.0532
at [0, +5)) is at the smallest positive gap, not the largest. **The volume split
does not widen with the skill gap.**

For comparison: Q40 reported that 98.5% of bouts (197 of 200) had volume share
≤ 55% under fixed fighters. The per-bout asymmetry here is in the same range
(mean |vol_diff| ≈ 0.03 overall) — the sweep has not moved the needle.

### Bout length vs skill gap

If wider skill gaps cause early stoppages, impact counts fall — which is a
change in the denominator, not in the correlation. Watch for it.

Denominator: **210 bouts**, binned as above.

| Skill gap (A−B) | n  | mean ticks (seconds) |
|---|---|---|
| [−20, −10) | 30 | 17554 (878 s) |
| [−10, −5)  | 20 | 17108 (855 s) |
| [−5, 0)    | 30 | 17811 (891 s) |
| [0, +5)    | 20 | 18673 (934 s) |
| [+5, +10)  | 30 | 18193 (910 s) |
| [+10, +15) | 20 | 17081 (854 s) |
| [+15, +20) | 30 | 17399 (870 s) |
| [+20, +30) | 30 | 18402 (920 s) |

**No systematic shortening.** Bout lengths range from 17081 to 18673 ticks
(854–934 s) with no trend as the skill gap widens. The shortest mean is at
[+10, +15) at 854 s; the longest is at [0, +5) at 934 s. The range is ~80 s
across bins, which is less than one round — well within normal seed-to-seed
variation. **No denominator collapse.** The 2026-09-10 lesson (240 bouts at
70-vs-55 produced zero splits) does not apply here: even at the widest gap
(strike_composite 80 vs 55, a 25-point gap), bouts run to similar length.

---

## PROSE

### What these numbers say

**Skill does not buy output.** Across a 40-point sweep of strike_composite
(40 to 80), against a fixed opponent at 55, the Pearson correlation between
skill gap and volume difference is −0.1248 — essentially zero, and in the wrong
direction. A fighter with strike_composite 80 throws no more than a fighter with
strike_composite 40. The engine cannot distinguish a better striker from a worse
one by how often they throw.

This is the before-picture for R101, now with a real x-axis. Q40 could not
measure skill-vs-output because both fighters were fixed (zero variance in the
attribute difference). Q41 fixes that by sweeping fighter A's attributes across
21 levels. The result: **r ≈ 0 with real variance**, which is the fair-coin
prediction confirmed.

### What the numbers do NOT say

- **This is not bout-for-bout comparable to Q40.** Different seeds (210000–210209
  vs 200000–200199), different fighters (sweep vs fixed pair). What carries over
  is the method, not the values.
- **The sweep only varies strike_composite.** Other attributes (defense,
  conditioning, fight_iq, grapple, power/technique/speed balance) are held
  constant. A different attribute sweep might produce a different r. But the
  task asks about striking output, and strike_composite is the attribute cluster
  that most directly drives it.
- **The range was chosen, not derived.** 40–80 is wide enough to resolve a real
  effect (a 40-point gap is enormous) but not so wide that every bout at the
  extremes ends in early stoppage. The bout-length data confirms no denominator
  collapse. The range is AUTHORED.

### Implications for R101

The before-picture, in one line:

> **r(strike_composite_gap, volume_diff) = −0.1248 at n=210 with real x-axis
> variance. The volume split does not widen with the skill gap. Bout length is
> stable across all bins. The engine produces a fair coin regardless of how much
> better one striker is than the other.**

The after-picture needs to move r away from zero — ideally to a positive value
where the better striker throws meaningfully more. If R101 moves r from −0.12
to +0.3 or higher, with a visible trend in the binned table and a widening
asymmetry, the baseline above is what it moves from.

---

## NOT DERIVABLE

1. **Which specific attribute drives output.** The sweep varies all three
   striking attributes (power, technique, speed) together. Untangling which one
   matters — or whether one dominates — requires separate sweeps, one attribute
   at a time.
2. **Non-linear effects.** The sweep tests a linear range. If skill only matters
   above a threshold (e.g. only when strike_composite > 70), this measurement
   would miss it — the binned table would need a discontinuity, and none is
   visible at n=210.
3. **Style interaction.** Fighter B is fixed (Q34 Wrestler B). A different
   opponent — say a boxer vs a boxer — might produce a different r. The sweep
   measures one matchup shape.
4. **Strike type (jab/cross/hook/kick).** Engine has no punch type field.
5. **Significant vs total strikes.** No significance filter exists.
