---
title: "Q37 — The Movement"
task: TASK_Q37.md
tool: Godot/tests/fight_locomotion_test.gd
date: 2026-09-10
owner: qwen
tier: ONE CORRECTED FILE + ONE NEW TEST FILE
status: Complete
seeds: 200000-200199 (200 boxing bouts, same as Q34/Q35/Q36)
fighters: Q34 Boxer A (183 cm) vs Q34 Wrestler B (176 cm)
also_corrects: Q36_THE_BEAT_FITS.md §4 and VERDICT (8.8% → 83.9%)
---

# Q37 — The Movement

## What was measured

200 seeded boxing bouts (seeds 200000–200199, same as Q34/Q35/Q36), driven through `FightRealtime` tick by tick. For every movement tick (20 Hz): each fighter's displacement, speed, direction relative to the opponent, and whether both men moved. For every decision tick (2 Hz): each fighter's intent from `FightIntent.decide()`. Round-by-round breakdown for fatigue comparison.

This also corrects Q36 §4. The original "8.8% no-clip gap" counted only the 1,164 wholly-empty beats. It missed the 11.53 s of post-clip slack inside each of the 12,114 action beats. The true no-clip share is **83.9% of presented fight-time** (denominator: 185,318.0 s), not 8.8%. Q36's file is corrected in place.

---

## 1. The intent stream

640,962 intent observations (denominator: 2 fighters × 320,481 decision ticks across 200 bouts).

| Intent | Count | Share of intent observations |
|--------|-------|------------------------------|
| close | 101,129 | 15.8% |
| hold | 224,250 | 35.0% |
| retreat | 114,318 | 17.8% |
| circle | 201,265 | 31.4% |

**Hold is the single most common intent at 35.0% of decision-tick observations.** Circle is close behind at 31.4%. Close and retreat — the intents that produce forward/back locomotion toward or away from the opponent — combine to only 33.6%. The locomotion shopping list is: hold (in-place drift), circle (side-step), then close/retreat (forward/back) roughly equally.

---

## 2. Speed distribution

6,349,504 movement-tick fighter samples where displacement > 0 (denominator: both fighters across all active ticks in 200 bouts).

| Metric | Speed (m/s) |
|--------|-------------|
| Min | 0.0200 |
| P05 | 1.3800 |
| P25 | 1.5942 |
| Median | 1.6001 |
| P75 | 1.6031 |
| P95 | 1.6091 |
| Max | 1.6132 |

**The speed is essentially a single value: 1.60 m/s.** The engine's `metres_per_tick = 1.6 / hz = 0.08 m` at every movement tick, giving `0.08 / 0.05 = 1.60 m/s` regardless of intent or fatigue. The P05–P95 spread is only 1.38–1.61 m/s. The min (0.02 m/s) is the hold drift — a small random nudge when the fighter is "holding" position.

**A single in-place locomotion cycle speed-matched to ~1.6 m/s covers 95% of movement ticks.** The narrow spread means one cycle will not look wrong across the band. The 5% tail below 1.38 m/s is hold drift, which an idle or breathing animation covers.

---

## 3. Direction changes

640,562 decision-to-decision opportunities (denominator: total decision ticks minus the first per fighter per bout, where there is no previous intent to compare).

| Metric | Value |
|--------|-------|
| Total intent changes | 467,651 (73.0% of opportunities) |
| Changes per 10 s of fight-time | 29.2 |
| Changes per beat (14 s window) | 40.9 |

**Intents change on nearly three out of every four decision ticks.** At 29.2 changes per 10 seconds, a fighter reverses or switches between circling and approaching roughly three times a second. A directional clip set will be cross-faded constantly — blend quality matters more than clip variety.

---

## 4. Lateral versus forward

554,292.3 m of total displacement magnitude (denominator: sum of per-fighter displacement magnitudes across all movement ticks, both fighters, 200 bouts).

| Component | Distance | Share of total displacement |
|-----------|----------|----------------------------|
| Forward (close/retreat) | 281,898.5 m | 50.9% |
| Lateral (circle) | 272,393.8 m | 49.1% |

**Movement is split almost exactly 50/50 between forward/back and lateral.** Side-step cycles are not optional — they are needed as much as forward/back cycles. A clip set with only forward and back movement would miss half the locomotion.

---

## 5. Both men moving

3,202,710 movement ticks where at least one fighter displaced > 0 (denominator: all active movement ticks across 200 bouts).

| Pattern | Count | Share of movement ticks |
|---------|-------|------------------------|
| Both moving | 3,146,794 | 98.3% |
| One moving | 55,916 | 1.7% |

**Both fighters are displacing on 98.3% of movement ticks.** The "one presses while the other holds" pattern is rare. A locomotion system can assume both men are always in motion and does not need to special-case one-man-moves scenarios.

---

## 6. Fatigue: round 1 vs last round

Round 1: 233,636 intent observations. Last round (round 3 in all 200 bouts): 205,740 intent observations.

| Intent | Round 1 | Last round | Shift |
|--------|---------|------------|-------|
| close | 17.0% | 14.8% | −2.2 pp |
| hold | 33.6% | 36.1% | +2.5 pp |
| retreat | 18.9% | 17.0% | −1.9 pp |
| circle | 30.5% | 32.1% | +1.6 pp |

Speed median: round 1 = 1.6001 m/s (230,769 samples). The engine does not reduce per-tick speed with fatigue — `metres_per_tick` is a constant. Fatigue works through `FightIntent.decide()` only: as stamina drops, the close-weight reduction in `FightIntent` shifts the distribution toward hold (+2.5 pp) and circle (+1.6 pp), and away from close (−2.2 pp) and retreat (−1.9 pp).

**The fatigue effect is real but modest.** A single-speed locomotion set will not look wrong late-fight because the speed does not change. What changes is the intent mix: tired men circle and hold more, press less. The same cycle library covers both rounds; only the intent router's weighting shifts.

---

## VERDICT

**The locomotion shopping list, in priority order:**

1. **Hold / in-place drift** — 35.0% of intent observations. An idle or breathing animation. The speed is ~0.02 m/s, effectively stationary.
2. **Circle / side-step** — 31.4% of intent observations. Lateral displacement at 1.60 m/s. Needed as much as forward/back (49.1% of total displacement is lateral).
3. **Close / forward** — 15.8% of intent observations. Forward displacement at 1.60 m/s.
4. **Retreat / backward** — 17.8% of intent observations. Backward displacement at 1.60 m/s.

**The speed is one number.** 1.60 m/s covers 95% of movement ticks (P05–P95: 1.38–1.61 m/s). One in-place locomotion cycle, speed-matched to 1.6 m/s, covers the whole intentional movement band. The hold drift is slow enough that an idle covers it.

**Blends matter more than clips.** Intents change 29 times per 10 seconds of fight-time. A directional clip set is being cross-faded roughly three times a second.

**Both men are always moving.** 98.3% of movement ticks displace both fighters. The system can assume continuous motion.

**Fatigue shifts intent, not speed.** The engine's `metres_per_tick` is constant. Stamina drains through `FightIntent.decide()`, nudging the distribution toward hold and circle. A single locomotion set covers all rounds.

**The gap Q36 corrected is the whole problem.** 83.9% of presented fight-time has no strike clip to play (denominator: 185,318.0 s of total presented fight-time). This movement data is what fills it.
