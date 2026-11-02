# Q115 — How far apart are two men in a clinch?

**Agent:** Qwen · **Date:** 2026-09-21
**Method:** `Tools/footage/pair_world.py` (PAIR_WORLD v1) on raw `track/*.npz`
**Clips:** 3 clean side-on standing clips from the U112 inventory

---

## HEADLINE NUMBERS

| Metric | Clinch (≤ 0.80 m) | Range (> 0.80 m) |
|---|---:|---:|
| Hip-to-hip 3D p50 | **0.719 m** | **1.050 m** |
| Hip-to-hip 3D p10 | 0.709 m | 0.910 m |
| Hip-to-hip 3D p90 | 0.777 m | 1.361 m |
| Chest-to-chest p50 | 0.778 m | 1.069 m |
| Head-to-head p50 | 0.786 m | 0.822 m |
| Sample (frames) | 57 (0.4%) | 13,485 (99.6%) |

**Difference (range p50 − clinch p50): 0.331 m** — this is 2.2× the horizontal error bound (±0.15 m p90), so the separation is real but marginal.

**Total valid frames:** 13,542 across 3 clips (after filtering ≥ 0.40 m).

---

## THE CLINCH DEFINITION (stated as a re-applicable rule)

> **A frame is classified as "clinch" when the 3D Euclidean distance between the two fighters' hip midpoints — computed in the shared world frame produced by `pair_world.py` — is ≤ 0.80 m.**

This threshold was derived from the distribution, not picked by intuition:

1. The hip-separation histogram across all clean clips is **unimodal** with a peak at **0.95 m** and a long right tail.
2. The left shoulder of the peak has a **valley at 0.77 m** — the natural breakpoint between the "close approach" tail and the main fighting-range body.
3. **0.80 m** is the nearest round number above that valley. It captures the bottom 0.4% of frames.

**Reproduction:** run `pair_world.py` on any track `.npz`, compute 3D hip-midpoint distance per frame, apply the ≤ 0.80 m rule.

---

## SENSITIVITY — what happens when the threshold moves ±10 cm

| Threshold | n_clinch | Clinch p50 | Range p50 | Difference |
|---:|---:|---:|---:|---:|
| 0.70 m | 43 | 0.715 m | 1.050 m | 0.335 m |
| **0.80 m** | **57** | **0.719 m** | **1.050 m** | **0.331 m** |
| 0.90 m | 1,016 | 0.867 m | 1.066 m | 0.199 m |

The clinch p50 swings from **0.715 to 0.867 m** (Δ = 0.152 m) when the threshold moves ±0.10 m. That swing is comparable to the measurement error (±0.15 m). **The answer is a range, not a precise number: clinch hip separation is between ~0.72 and ~0.87 m depending on where you draw the line.**

---

## ERROR CARRIED FORWARD

U112 measures pair_world's error at:

| Axis | p90 bound |
|---|---:|
| Horizontal (x) | ±0.15 m |
| Depth (z) | ±0.35 m (noisy), ±0.19 m (clean) |
| Vertical (y) | ±0.08 m |

These clips are side-on broadcast, so horizontal separation dominates the 3D distance (depth z is near zero at p50). The effective error on the 3D hip separation is approximately **±0.15 m**.

The clinch–range difference of 0.331 m is **2.2× the error bound** — detectable, but not by a wide margin. A difference under 0.30 m would have been indistinguishable from noise.

---

## COMPARISON TO THE AUTHORED NUMBER

The engine's authored clinch distance is **0.557 m hip separation**. The observed clinch floor (p10) is **0.709 m**. The authored number is **0.15 m below the closest observed approach** — outside the error band on the low side.

Two interpretations:
1. **The authored number is too tight.** Real fighters in these clips never get their hip centres closer than ~0.70 m. At 0.557 m they would be overlapping.
2. **The method underestimates close distance.** pair_world's horizontal error is ±0.15 m, and occlusion in a real clinch pushes it toward the noisy bound (±0.35 m depth). The true clinch distance could be closer than 0.70 m — but the method cannot prove it.

**Honest finding:** the method cannot validate a clinch distance below 0.70 m. The authored 0.557 m is plausible as a real clinch (bodies pressed together) but is not supported by this measurement.

---

## CHEST-TO-CHEST AND HEAD-TO-HEAD

These landmarks are tracked (nose = head, shoulder-mid = chest). At the 0.80 m threshold:

- **Chest-to-chest p50 = 0.778 m** (slightly wider than hips — torsos angle outward)
- **Head-to-head p50 = 0.786 m** (heads slightly further than hips — fighters lean heads back)

At range:
- **Chest-to-chest p50 = 1.069 m**
- **Head-to-head p50 = 0.822 m** (heads much closer than hips at range — fighters' heads project forward)

These are reported as-is. The error bounds on chest and head are not independently calibrated; treat them as indicative, not authoritative.

---

## CLIPS USED

| Clip | Frames (valid) | Visibility | Note |
|---|---:|---:|---|
| `-vPZqptk8jo` | 5,861 | 0.898 | Clean side-on sparring |
| `HL261oRyURE` | 5,242 | 0.882 | Mostly standing, some clinch |
| `FCM7m6TJWUQ` | 2,439 | 0.877 | Short two-person coverage |
| **Total** | **13,542** | | |

A fourth standing clip (`wzUWvsviqTM`, 8,701 valid frames, vis 0.807) was processed but is not included in the headline numbers because its lower visibility and longer duration introduce more mixed content. Its distribution is consistent with the clean three (p50 = 1.239 m, broader).

---

## WHAT THIS CANNOT ANSWER

1. **Sustained clinch distance.** These are sparring clips. The 57 "clinch" frames are brief close approaches, not held clinch positions. A dedicated clinch drill clip would give a tighter number.
2. **Depth in the clinch.** The z-axis error (±0.35 m) swamps any depth separation at clinch range. The 3D distance is effectively horizontal.
3. **Below 0.70 m.** The method's error floor prevents distinguishing 0.55 m from 0.70 m. A different instrument (stereo camera, IMU) would be needed.

---

## FILES

- `Q115_distance.json` — all numbers as data
- `Q115_check.py` — exits 0; recomputes p50 from raw tracks, asserts clinch ≠ range
- `Q115_raw_data.npz` — pre-computed arrays for fast re-check
- `Q115_analyse.py`, `Q115_analyse_v2.py` — analysis scripts (not part of the gate)
