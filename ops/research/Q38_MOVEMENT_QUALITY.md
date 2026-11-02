# Q38 — Movement Quality: Are Our Men Moving Like Boxers, or Jittering?

**Model:** qwen | **Seeds:** 200000–200199 (200 boxing bouts, 3×300s rounds, 60s rest) | **Same harness as Q37**

---

## Part 1 — Speed: Two Denominators, One Defect

| Metric | Denominator | Value |
|--------|-------------|-------|
| Movement-tick mean speed | 6,350,220 fighter-ticks where displacement > 0 | **1.558 m/s** (median 1.600) |
| Whole-bout speed incl. rest | 182,030 s clock time (active + rest), both fighters | **1.359 m/s per fighter** |
| Whole-bout speed excl. rest | 160,250 s active round time, both fighters | **1.543 m/s per fighter** |
| Thomson GPS reference | Whole bout including rest | **0.6 m/s** |

**The movement-tick speed (Q37's denominator) is 1.558 m/s — essentially the hardcoded 1.6 m/s in `_run_movement`.** Every non-grappling tick moves every fighter at exactly `1.6 / hz` metres. The narrow P05–P95 band (1.38–1.61) comes from ring-boundary clamping, not from speed variation.

**The GPS-comparable number is 1.359 m/s (whole-bout including rest).** Our fighters are **2.26× a real boxer's speed** by the only denominator that matches Thomson's measurement.

### Distance per round

| Round | Fighter A | Fighter B |
|-------|-----------|-----------|
| 1 | 451.3 m/bout | 452.2 m/bout |
| 2 | 419.5 m/bout | 420.1 m/bout |
| 3 | 364.9 m/bout | 365.1 m/bout |

Declining with fatigue (stamina drain reduces CLOSE weight, shifting to HOLD which still drifts at full speed but with random direction — so distance drops from boundary interactions, not speed reduction). Average active time per bout: 801.2 s. Average clock time: 910.1 s.

**A real boxer covers ~100–200 m per 3-minute round.** Our fighters cover 451 m per 5-minute round (90 m/min vs a real boxer's ~36 m/min). The ratio is consistent with the 2.26× whole-bout figure.

### Verdict on speed

**Confirmed engine defect.** The movement speed is 2.26× a real boxer's once denominators match. The defect is structural: `_run_movement` hardcodes `metres_per_tick = 1.6 / hz` with no speed variation by intent, fatigue, or situation. HOLD drifts at the same speed as CLOSE. There is no slow approach, no cautious advance, no moment of stillness.

---

## Part 2 — Direction Changes: Not Jitter, But Oscillation

### Reversal magnitudes

| Statistic | Value |
|-----------|-------|
| Total reversals (both fighters) | 1,339,284 |
| Median | 0.080 m (8 cm — exactly one tick's movement) |
| P95 | 0.080 m |
| Max | 0.081 m |
| Below 1 cm | 0.1% |
| Below 5 cm | 1.2% |
| Above 20 cm | 0.0% |

**Almost every reversal is ~8 cm** — one tick of movement in one direction followed by one tick back. These are NOT sub-millimetre numerical jitter (which a deadband would eliminate). They are full-tick oscillations: the fighter moves 8 cm one way, then 8 cm the other way.

### Direction change rates

| Metric | Count | Per 10 s |
|--------|-------|----------|
| Raw displacement reversals | 1,339,284 | **83.6** |
| Deadband 1 cm | 1,341,067 | **83.7** |
| Deadband 5 cm | 1,329,184 | **82.9** |
| Intent flips (decision ticks) | 467,651 / 640,962 opportunities | **29.2** |

**The deadbands barely change the count.** This confirms the oscillations are ~8 cm, well above both thresholds. Filtering sub-cm or sub-5cm displacements does nothing because the oscillations are full-tick.

**Displacement reversals (83.6/10s) are 2.9× the intent flips (29.2/10s).** The extra reversals come from geometry: when two fighters circle, the line between them rotates, and a stable "close" intent produces a rotating displacement vector that can reverse even without an intent change. The brain is more stable than the body.

### Verdict on direction changes

**Not numerical jitter — genuine oscillation.** The 29.2/10s intent flips from Q37 are real decision-level changes. The 83.6/10s displacement reversals are mostly geometric artefacts of circling, not additional brain-level decisions. A deadband does not help because the oscillations are ~8 cm (one full tick), not sub-cm noise.

---

## Part 3 — Direction Stability: The Locomotion-Clip Number

A locomotion clip needs ~0.25 s to read. The question: what fraction of moving ticks are in a directionally stable run of at least that duration?

### Run-length histogram

| Run length | Runs | % of runs | Moving ticks | % of ticks |
|------------|------|-----------|--------------|------------|
| 1 tick (0.05 s) | 567,838 | 42.1% | 567,838 | 8.9% |
| 2 ticks (0.10 s) | 267,329 | 19.8% | 534,658 | 8.4% |
| 3 ticks (0.15 s) | 125,953 | 9.3% | 377,859 | 6.0% |
| 4 ticks (0.20 s) | 58,810 | 4.4% | 235,240 | 3.7% |
| 5–9 ticks (0.25–0.45 s) | 52,537 | 3.9% | 307,626 | 4.8% |
| 10–19 ticks (0.50–0.95 s) | 194,911 | 14.5% | 2,120,096 | 33.4% |
| 20+ ticks (1.00+ s) | 80,060 | 5.9% | 2,206,903 | 34.8% |

**Most runs are short (42% are 1 tick), but most TICKS are in long runs** — the distribution is heavily right-weighted by tick count.

### Key stability numbers

| Stable for at least | Moving ticks | Fraction |
|---------------------|--------------|----------|
| **0.25 s (5 ticks)** | 4,634,625 / 6,350,220 | **73.0%** |
| **0.50 s (10 ticks)** | 4,326,999 / 6,350,220 | **68.1%** |
| **1.00 s (20 ticks)** | 2,206,903 / 6,350,220 | **34.8%** |

### Verdict on locomotion clips

**Partially buyable, with caveats.** 73% of moving ticks have direction stable for at least 0.25 s — enough for a locomotion clip to read. 68% stable for 0.5 s is comfortable for a blended transition. But only 35% stable for a full second means a locomotion cycle will be interrupted ~65% of the time before it completes.

**Four locomotion clips (forward, backward, left circle, right circle) are worth buying** — they will be used 73% of the time for at least a quarter-second reads. But the animation system will need frequent blending/interruption, and the clips will not play to completion most of the time.

---

## VERDICT

**Speed: confirmed defect.** Whole-bout mean speed is 1.36 m/s (denominator: total clock seconds including rest, per fighter), which is **2.26× Thomson's 0.6 m/s for real boxers.** The movement-tick speed of 1.56 m/s (denominator: only ticks where displacement > 0) is not comparable to Thomson and was the Q36-style denominator error wearing new clothes. The defect is structural: `_run_movement` hardcodes 1.6 m/s for every intent including HOLD, with no speed variation.

**Direction stability: buyable.** 73% of moving ticks are directionally stable for ≥0.25 s (denominator: 6,350,220 moving ticks across 200 bouts). Four locomotion clips will be used, but the animation system must handle frequent interruption — only 35% of ticks are stable for a full second. The direction changes are genuine oscillations (~8 cm per reversal, not sub-cm jitter), so the clips will need to blend rather than play to completion.
