# Q116 — A clinch is not a statue: how much does it move, and how fast?

**Agent:** Qwen · **Date:** 2026-09-21
**Method:** `Tools/footage/pair_world.py` (PAIR_WORLD v1) on raw `track/*.npz`
**Clips:** same 3 clean side-on clips as Q115
**Threshold:** ≤ 0.80 m hip-to-hip 3D (Q115's derived value, not re-derived here)
**FPS:** 50.0 (source footage, not 30)
**Min run length:** 3 frames (0.060 s) — stated, with discarded count reported

---

## **THE SAMPLE IS SMALL: 3 USABLE RUNS AT 0.80 m**

**Before any statistic, the run count.** At the 0.80 m threshold, 57 clinch
frames segment into **5 runs**. Two are single- or two-frame contacts (discarded
by the 3-frame minimum). **Three runs remain.** Every figure below is a
3-run statistic. That is not a population; it is a case series.

All figures are reported as ranges, not points.

---

## HEADLINE TABLE — CLINCH vs RANGE

| Metric | CLINCH (≤ 0.80 m) | RANGE (> 0.80 m) | Ratio |
|---|---:|---:|---:|
| Runs (total / kept ≥ 3 f) | 5 / **3** | 5 / 5 | — |
| Runs discarded | 2 | 0 | — |
| Hip-sep excursion p50 | **0.023–0.062 m** | **0.451 m** | 7–20× |
| Vertical bob p50 (both f.) | **0.032 m** | **0.406 m** | 13× |
| Lateral sway p50 | **< 0.001 m** | **0.001 m** | ~1× |
| Run duration p50 | **0.100 s** | 29.4 s | — |
| Run duration mean | **0.353 s** | 53.9 s | — |
| Run duration range | **0.08–0.88 s** | 0.4–182 s | — |

**The clinch moves, but ~10× less than range.** Hip-separation excursion in a
clinch is 0.02–0.06 m (breathing distance). At range it is 0.45 m (approach/
retreat). The difference is real and large.

---

## 1. HIP-SEPARATION EXCURSION (the breathing number)

Per run: `max(hip_sep) − min(hip_sep)` within the run, then pooled p50/p10/p90.

| | Clinch (3 runs) | Range (5 runs) |
|---|---:|---:|
| p10 | 0.023 m | 0.269 m |
| **p50** | **0.046 m** | **0.451 m** |
| p90 | 0.062 m | 0.962 m |
| mean | 0.043 m | 0.584 m |

The three clinch runs individually: 0.018 m, 0.046 m, 0.065 m. The 0.065 m
run is the longest (44 frames, 0.88 s); the 0.018 m run is the shortest
(4 frames, 0.08 s). **Author against 0.02–0.07 m of hip-separation breathing
within a held clinch.**

---

## 2. VERTICAL EXCURSION (the bob)

`max(hip_mid_y) − min(hip_mid_y)` per fighter per run.

| | Clinch p50 | Clinch p90 | Range p50 | Range p90 |
|---|---:|---:|---:|---:|
| Fighter 0 | 0.032 m | 0.038 m | 0.406 m | 0.731 m |
| Fighter 1 | 0.032 m | 0.038 m | 0.406 m | 0.732 m |

Both fighters bob the same amount (symmetric). **~3 cm of vertical motion in
a clinch** — knee flexion/extension, weight settling. At range it is 40 cm
(level changes, sprawls, stance switches).

---

## 3. LATERAL EXCURSION (weight shifting)

Displacement perpendicular to the line joining the two hip midpoints,
projected in the XZ (horizontal) plane. Uses the **mean** facing direction
per run (stable), not per-frame (noisy when dx >> dz in side-on camera).

| | Clinch p50 | Clinch p90 | Range p50 | Range p90 |
|---|---:|---:|---:|---:|
| Fighter 0 | 0.0001 m | 0.0002 m | 0.0005 m | 0.0007 m |
| Fighter 1 | 0.0002 m | 0.0002 m | 0.0007 m | 0.0008 m |

**This metric is unmeasurable from a side-on camera.** The lateral direction
is mostly depth (Z), and pair_world's depth error is ±0.35 m (p90). The
values are at the noise floor for both clinch and range. **Do not author
lateral weight-shift from these numbers.** A front-on or 45° camera would be
needed.

---

## 4. RATE (dominant period of hip-separation signal)

Method: zero-crossings of the mean-removed hip-separation signal within each
run. Half-period = median interval between crossings; full period = 2× half.

**The runs are too short to resolve a period.**

- At 0.80 m: only 2 of 3 runs have ≥ 2 zero-crossings. The ZC median is
  0.040 s (2 frames — one oscillation cycle, not a period estimate). FFT on
  the one run long enough (44 frames) gives 0.44 s.
- At 0.90 m (44 runs): 31 runs resolvable by ZC, median 0.060 s; 26 by FFT,
  median 0.380 s. The ZC median is still at the 2-frame resolution limit.

**The FFT peak at ~0.4 s from the 0.90 m band is the best available estimate.**
It is driven by one long run (189 frames, 3.78 s) whose FFT peak is at 3.78 s
(the run's own duration — a trend, not an oscillation). Excluding that run,
the FFT median drops to ~0.3 s.

**Honest answer: the hip-separation signal in a clinch has no resolved
oscillation period in this sample. The motion is a slow drift (breathing,
pressure adjustment), not a rhythmic oscillation. If a period must be
authored, 0.3–0.5 s is the order of magnitude, but it is not measured.**

---

## 5. RUN DURATION (how long does a clinch contact last)

| | Clinch (0.80 m) | Clinch (0.90 m) | Range (0.80 m) |
|---|---:|---:|---:|
| Runs kept | 3 | 44 | 5 |
| p50 | 0.100 s | 0.200 s | 29.4 s |
| p10 | 0.084 s | 0.060 s | 4.0 s |
| p90 | 0.724 s | 1.092 s | 128.7 s |
| max | 0.880 s | 3.780 s | 182.2 s |
| mean | 0.353 s | 0.433 s | 53.9 s |

**Comparison to J32's boxing inference.** Davis et al. (Olympic 2012) report
5.0–6.0 s mean per clinch episode (total clinch time ÷ frequency). Our
measured numbers are **an order of magnitude shorter**: p50 = 0.1–0.2 s,
mean = 0.35–0.43 s, max = 0.88–3.78 s.

**This is not a disagreement; it is a different phenomenon.** The boxing
number measures held clinches in competitive bouts (referee breaks them on
a timer). Our footage is sparring — brief close approaches, not held grips.
The 44-frame run (0.88 s) is the longest sustained contact in 13,542 frames.
**These clips do not contain the phenomenon that J32's number describes.**

**Label:** this is a measured number from 3 clips of tracked video, not a
published study. It describes passing contact duration in sparring, not
sustained clinch duration in competition.

---

## WIDENING TO 0.90 m — DOES IT HELP?

| | 0.80 m | 0.90 m |
|---|---:|---:|
| Clinch frames | 57 | 1,016 |
| Runs (total / kept) | 5 / 3 | 92 / 44 |
| Hip excursion p50 | 0.046 m | 0.024 m |
| Vert bob p50 | 0.032 m | 0.027 m |
| Duration p50 | 0.100 s | 0.200 s |

Widening buys **44 runs instead of 3** — a 15× increase in sample. But the
excursion p50 **drops** from 0.046 to 0.024 m. The reason: the 0.90 m band
fills with 48 short runs (3 frames, 0.06 s) that are near-threshold noise —
fighters approaching or leaving, not held clinches. Their excursion is tiny
(they barely cross the line).

**The 0.80 m band is the better authoring target** despite its small sample.
It captures committed close contact. The 0.90 m band captures the approach
zone, where the men are close but not yet engaged.

**If more data were available, the right threshold would be data-driven
(bimodal separation of "engaged" vs "approaching" run durations). With 3
clips, 0.80 m is the best available line.**

---

## POPULATION

| | |
|---|---|
| Clips | `-vPZqptk8jo` (5,861 f), `HL261oRyURE` (5,242 f), `FCM7m6TJWUQ` (2,439 f) |
| Total valid frames | 13,542 |
| Clinch frames (≤ 0.80 m) | 57 (0.4% of corpus) |
| Clinch runs (≥ 3 frames) | 3 |
| FPS | 50.0 |
| Threshold | 0.80 m (Q115's data-derived value) |
| Error bound (horizontal p90) | ±0.15 m |
| Lateral error (depth p90) | ±0.35 m — lateral metric is unmeasurable |

---

## WHAT THE AUTHOR NEEDS TO KNOW

1. **A clinch breathes.** Hip separation varies by 0.02–0.07 m within a hold.
   Author a ±3 cm oscillation around the mean clinch distance.

2. **A clinch bobs.** ~3 cm of vertical motion per fighter, symmetric.

3. **A clinch does NOT sway laterally** (in this sample). The number is at
   the noise floor. This may be a camera limitation, not a real absence.

4. **A clinch is brief in sparring.** 0.1–0.9 s per contact. The 5–6 s
   competitive clinch is a different phenomenon not present in this footage.

5. **The oscillation period is not resolved.** Motion is a slow drift, not
   rhythmic. If a period is needed for animation, 0.3–0.5 s is the order of
   magnitude but is not measured.

6. **The statue problem is real but small.** The clinch is not frozen — it
   moves ~5 cm — but 5 cm of breathing is barely visible. The author should
   add torso rotation, head movement, and arm pressure changes on top of the
   hip breathing, because those are the visible clinch dynamics and this
   instrument cannot measure them.

---

## FILES

- `Q116_CLINCH_MOTION.md` — this digest
- `Q116_analyse.py` — analysis script (recomputes from raw tracks)
- `Q116_check.py` — independent gate (recomputes, asserts pinned literals)
- `Q116_motion.json` — all numbers as data
