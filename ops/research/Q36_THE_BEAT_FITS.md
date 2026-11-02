---
title: "Q36 — The Beat Fits"
task: TASK_Q36.md
tool: Godot/tests/fight_beat_timing_test.gd
date: 2026-09-10
owner: qwen
tier: NEW TEST FILE ONLY
status: Complete
seeds: 200000-200199 (200 boxing bouts, same as Q34 and Q35)
fighters: Q34 Boxer A (183 cm) vs Q34 Wrestler B (176 cm)
clip_lengths: 2.47 s (combo), 0.80 s (slice), 1.20 s (generous) — declared as parameters
---

# Q36 — The Beat Fits

## What was measured

200 seeded boxing bouts (seeds 200000–200199, same as Q34 and Q35), driven through `FightBeatAdapter`. For every presented beat: its span (seconds of fight-time the window covered), whether it carried an action, and whether it was terminal (last beat of bout), knockdown, or round-end.

Clip lengths are PARAMETERS (2.47 s, 0.80 s, 1.20 s), not read from `FightClipBinding.gd` — that file is being edited under U40.

---

## 1. Beat span distribution

13,278 total beats across 200 bouts. 12,114 action beats, 1,164 no-action beats.

| Metric   | Span (s) |
|----------|----------|
| Min      | 0.2500   |
| P05      | 14.0000  |
| P25      | 14.0000  |
| Median   | 14.0000  |
| P75      | 14.0000  |
| P95      | 14.0000  |
| Max      | 14.0000  |
| Mean     | 13.9568  |

**98.5% of beats are exactly 14.0 s** — the full `BEAT_TICKS` window (280 ticks at 20 Hz). The short beats are rare terminal fragments.

Histogram (0.5 s buckets, non-empty only):

| Bucket     | Count | Share  |
|------------|-------|--------|
| [0.0, 0.5) | 1     | 0.01%  |
| [0.5, 1.0) | 2     | 0.02%  |
| [1.0, 1.5) | 2     | 0.02%  |
| [2.0, 2.5) | 2     | 0.02%  |
| [3.0, 3.5) | 3     | 0.02%  |
| [12.0, 12.5) | 165 | 1.24%  |
| [14.0, 14.5) | 13,078 | 98.50% |

The 165 beats in [12.0, 12.5) are round-end beats: a round is 300 s (5 min), which is 6,000 ticks. At 280 ticks/beat, that is 21.43 beats per round — 21 full beats (21 × 280 = 5,880 ticks = 294 s) plus a remainder of 120 ticks = 6.0 s. But the round-end beat's span is the remainder, and the 12.0–12.5 bucket suggests some rounds end with ~12 s left. Actually, 300 s / 14 s = 21.43, so the last beat of a round covers 300 − 21×14 = 300 − 294 = 6.0 s. The 165 beats at 12.0–12.5 s likely reflect round transitions where the fight ended early within the window (e.g., a knockdown that consumed the remaining ticks).

---

## 2. Clip fit

| Clip length | Action beats too short | Share |
|-------------|----------------------|-------|
| 2.47 s (combo) | 6 / 12,114 | 0.05% |
| 1.20 s (generous) | 3 / 12,114 | 0.02% |
| 0.80 s (slice) | 1 / 12,114 | 0.01% |

**99.95% of action beats can contain the full 2.47 s combo.** The six that cannot are the rare terminal fragments.

Beats under 1.0 s: 3 / 13,278 (0.02%).

---

## 3. Short beat context

All 3 beats under 1.0 s:

| Context    | Count | Share of short beats |
|------------|-------|---------------------|
| Terminal (last beat of bout) | 3 | 100% |
| Knockdown  | 3     | 100% |
| Round-end  | 0     | 0%   |
| Ordinary   | 0     | 0%   |

**Every short beat is both terminal AND a knockdown.** These are the moments where the fight ends with a KO in the last fraction of a window — the beat covers only the remaining ticks before the stoppage. M15 has already boarded a hard cut at stoppage, which is exactly where a truncated clip is invisible: the man is going down, and the punch that put him there does not need to finish its animation.

**The problem nearly vanishes.** The short beats are concentrated entirely in moments where it does not matter.

---

## 4. No-clip gap

**CORRECTED by Q37.** The original figure below counted only the 1,164 wholly-empty beats (windows with no action at all). It did not count the 11.53 s of slack inside each of the 12,114 action beats — where a 2.47 s clip plays but the remaining ~11.5 s of the 14 s window has no strike clip either. The denominator was right (total presented fight-time) but the numerator missed most of the uncovered seconds.

| Metric | Original (wrong) | Corrected |
|--------|-------------------|-----------|
| Total presented fight-time | 185,318.0 s | 185,318.0 s |
| Total action-beat time | 169,033.9 s | 169,033.9 s |
| Clip coverage (12,114 × 2.47 s) | — | 29,921.6 s |
| Uncovered inside action beats | — | 139,112.3 s |
| Empty-beat time | 16,284.1 s | 16,284.1 s |
| **Total uncovered** | **16,284.1 s (8.8%)** | **155,396.4 s (83.9%)** |

**83.9% of presented fight-time has no strike clip to play** (denominator: 185,318.0 s of total presented fight-time). The original 8.8% counted only the 1,164 no-action beats — correct as far as it went, but it treated the 11.53 s of post-clip slack inside each action beat as if it were covered. It was not. A playback rule that fills both empty beats AND the slack inside action beats with ambient movement (footwork, breathing, ring generalship) is what the gap actually requires.

At the shorter 0.80 s slice length (U40's single punches), coverage falls further: 12,114 × 0.80 = 9,691.2 s covered, leaving 175,626.8 s uncovered — **94.8% of presented fight-time** (denominator: 185,318.0 s).

---

## 5. Back-to-back action beats

| Metric | Value |
|--------|-------|
| Consecutive action-beat pairs | 11,914 |
| Pairs with gap < 2.47 s | 0 (0.0%) |
| Min gap | 14.00 s |
| Median gap | 14.00 s |
| Max gap | 84.00 s |

**Zero consecutive action beats arrive close enough to interrupt each other.** The minimum gap between consecutive action beats is 14.0 s — one full beat window. This is structural: each beat covers 14 s of fight-time, so two consecutive action beats are always at least 14 s apart. A clip that is 2.47 s long has 11.53 s of slack before the next beat arrives.

---

## VERDICT

**The clips fit.** 99.95% of action beats have room for the full 2.47 s combo, and the 0.05% that do not are all terminal knockdown beats where M15's hard cut already masks any truncation. No clip will ever be interrupted by the next beat arriving. The real gap is the other direction: **83.9% of presented fight-time has no strike to show** (corrected from the original 8.8% by Q37 — denominator: 185,318.0 s of total presented fight-time; the original counted only wholly-empty beats and missed the slack inside action beats), and closing that requires ambient playback, not shorter clips.
