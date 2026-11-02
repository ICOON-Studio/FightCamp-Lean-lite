# Q32 — Beat Stream Measurement

**Task:** TASK_Q32.md
**Tool:** `Godot/tools/measure_beats.gd`
**Date:** 2026-09-10
**Bouts:** 200 seeded boxing bouts, seeds 100000–100199
**Fighters:** Q32 Boxer A (reach 183 cm, power 60 / technique 62 / speed 58 / defense 55 / conditioning 60 / fight_iq 50 / grapple 40) vs Q32 Wrestler B (reach 176 cm, power 55 / technique 48 / speed 62 / defense 58 / conditioning 70 / fight_iq 55 / grapple 70)
**Options:** `{"seed": <varied>, "rounds": 3, "ruleset": "boxing"}`
**Reproduce:** run `Godot/tools/measure_beats.gd` headless.

---

## 1. Action beats per fight

| Metric   | Total beats | Action beats | No-action beats |
|----------|-------------|--------------|-----------------|
| Min      | 2           | 2            | 0               |
| Median   | 73          | 66           | 6               |
| Mean     | 66.5        | 60.6         | 6.0             |
| Max      | 73          | 67           | 9               |

**Total action beats across 200 bouts: 12,110.**
**Total no-action beats across 200 bouts: 1,191.**

A no-action beat is a body standing there. The ratio is roughly **10 action beats for every 1 no-action beat** (60.6 : 6.0). Idle/stance footage is needed at about 10 % of the volume of strike footage.

The min of 2 total beats (and 2 action beats) is a bout that ended extremely quickly — likely a stoppage inside the first beat window.

---

## 2. Region distribution of the presented strike

Across all 12,110 action beats:

| Region       | Count | Percentage |
|--------------|-------|------------|
| head_neck    | 7,910 | 65.3 %     |
| torso_core   | 3,419 | 28.2 %     |
| left_leg     | 401   | 3.3 %      |
| right_leg    | 380   | 3.1 %      |
| left_arm     | 0     | 0.0 %      |
| right_arm    | 0     | 0.0 %      |

**Arms at zero confirms R84's ruling** (arm probability set to 0.00 deliberately). **Legs at ~3 % each under boxing** is a fact about boxing — low kicks are rare in the ruleset. The head dominates at two-thirds of all presented strikes; the torso is the remaining third.

---

## 3. Contact distribution of the presented strike

| Contact   | Count | Percentage |
|-----------|-------|------------|
| clean     | 11,224| 92.7 %     |
| glancing  | 677   | 5.6 %      |
| absorbed  | 97    | 0.8 %      |
| blocked   | 30    | 0.2 %      |
| slipped   | 17    | 0.1 %      |
| missed    | 65    | 0.5 %      |

Clean hits dominate overwhelmingly. Block and slip footage is needed at well under 1 % of the volume of react footage. This is the first time this distribution has been measured across a population.

---

## 4. Knockdown, flash_knockdown, and shocked

| Flag              | Total beats | Fights with ≥ 1 | Share of fights |
|-------------------|-------------|-----------------|-----------------|
| knockdown         | 100         | 83 / 200        | 41.5 %          |
| flash_knockdown   | 75          | 65 / 200        | 32.5 %          |
| shocked           | 922         | 200 / 200       | 100.0 %         |

**Knockdown footage is needed in about 4 in 10 bouts.** Flash knockdowns in about 1 in 3. Shocked fires in every single bout — it is universal and should be treated as a baseline animation layer, not a rare event.

---

## 5. Drop rate

| Metric          | Value       |
|-----------------|-------------|
| Total impacts   | 149,412     |
| Shown           | 12,110      |
| Dropped         | 137,302     |
| Drop rate       | 91.9 %      |

Per-fight distribution:

| Metric   | Shown | Dropped |
|----------|-------|---------|
| Min      | 2     | 16      |
| Median   | 66    | 738     |
| Mean     | 60.6  | 686.5   |
| Max      | 67    | 840     |

**R97 measured 92.6 % on one bout; 200 bouts measure 91.9 %.** The difference is small (0.7 pp) and in the expected direction — a single bout happened to drop slightly more than the population average. The rate is confirmed: roughly 92 % of impacts are dropped by the beat window.

---

## 6. Beat span

| Metric   | Span (s) |
|----------|----------|
| Min      | 0.2500   |
| Median   | 14.0000  |
| Mean     | 13.9566  |
| Max      | 14.0000  |

**The span VARIES.** Most beats are the full 14.0 s (280 ticks at 20 Hz), but the last beat of a fight — or the last beat of a round when the fight ends mid-window — comes up short. The minimum observed is 0.25 s (5 ticks).

**A clip must fit inside a beat, and some beats are very short.** The stage must handle beats as short as 0.25 s without clipping or stuttering. If clips are cut to a fixed 14.0 s length, they will not fit in the terminal beat of a bout.

---

## 7. Separation at the moment of the strike

On action beats (n = 12,110):

| Metric   | Distance (m) |
|----------|-------------|
| Min      | 0.0045      |
| Median   | 0.8926      |
| Mean     | 0.8244      |
| Max      | 1.0999      |

**No action beats are missing the distance field** (0 missing out of 12,110).

The median separation is ~0.89 m. The range is 0.005 m (essentially touching) to 1.1 m (at the edge of punching range). A fixed stance distance of ~0.9 m would place the median correctly, but the 0.005 m minimum shows that bodies can be essentially on top of each other when a punch lands — a fixed distance would look wrong in those cases. The bodies must be able to slide.

---

## Missing fields

No fields are missing from the beat stream for the seven questions asked. Every action beat carries `target_region`, `contact`, `knockdown`, `flash_knockdown`, `shocked`, `span`, and `distance`. The `shown` and `dropped` counters on state are present and consistent.
