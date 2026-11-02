# Q197 DIGEST - Where does a thrown man land, and does footwork economy move it?

**Owner:** qwen | **Assigned:** 2026-09-27 (S96) | **Branch:** `qwen/q197-throw-landings`
**Tools:** `Godot/tools/q197a_pop_a.gd`, `Godot/tools/q197b_pop_b.gd` (also `q197_throw_landing_census.gd` combined)
**Gate:** parse clean on all three tool files. No script edited (research tier).

## Populations

### Pop A: matched judoka (different styles, legal for judo)
| Fighter | power | technique | speed | defense | conditioning | fight_iq | grapple |
|---------|-------|-----------|-------|---------|--------------|----------|---------|
| Thrower | 80 | 55 | 65 | 55 | 80 | 50 | 90 |
| GripFtr | 55 | 85 | 65 | 75 | 80 | 80 | 75 |

Ruleset: `judo` (id=judo). Stats key: `"stats"`.

### Pop B: legacy grappler-v-fish (Q196)
| Fighter | power | technique | speed | defense | conditioning | fight_iq | grapple |
|---------|-------|-----------|-------|---------|--------------|----------|---------|
| Grappler | 60 | 80 | 70 | 60 | 85 | 80 | 95 |
| Fish | 50 | 40 | 50 | 20 | 45 | 20 | 15 |

Ruleset: `judo` (id=judo).

## Results (600 bouts per arm; 100 scoring throws not reached in any arm)

### Pop A: thrower vs grip-fighter

| Metric | economy OFF | economy ON |
|--------|-------------|------------|
| bouts | 600 | 600 |
| clinches | 900 | 879 |
| throw attempts/bout | 0.45 [0.41, 0.49] | 0.44 [0.40, 0.48] |
| throws landed/bout | 0.23 [0.20, 0.27] | 0.23 [0.20, 0.27] |
| SCORING throws/bout | 0.08 [0.06, 0.10] | 0.09 [0.07, 0.11] |
| scoring (raw) | 47 | 52 |

**Landing seats (of landed throws):**

| Seat | OFF (n=138) | ON (n=138) |
|------|-------------|------------|
| side | 47 (34.1%) [26.7, 42.3] | 52 (37.7%) [30.0, 46.0] |
| half | 43 (31.2%) [24.0, 39.3] | 48 (34.8%) [27.3, 43.0] |
| guard | 48 (34.8%) [27.3, 43.0] | 38 (27.5%) [20.8, 35.5] |

**IJF bands:**

| Band | OFF (n=138) | ON (n=138) |
|------|-------------|------------|
| yuko | 47 (34.1%) | 52 (37.7%) |
| not_scored | 91 (65.9%) | 86 (62.3%) |

**Verdict: STILL UNDERPOWERED** - 47 and 52 scoring throws per arm (target: 100). Side-landing CIs overlap.

### Pop B: grappler vs fish (legacy)

| Metric | economy OFF | economy ON |
|--------|-------------|------------|
| bouts | 600 | 600 |
| clinches | 383 | 356 |
| throw attempts/bout | 0.17 [0.15, 0.21] | 0.18 [0.15, 0.22] |
| throws landed/bout | 0.13 [0.10, 0.16] | 0.12 [0.10, 0.15] |
| SCORING throws/bout | 0.06 [0.04, 0.08] | 0.06 [0.04, 0.08] |
| scoring (raw) | 34 | 33 |

**Landing seats (of landed throws):**

| Seat | OFF (n=77) | ON (n=73) |
|------|-------------|------------|
| side | 34 (44.2%) [33.6, 55.3] | 33 (45.2%) [34.3, 56.6] |
| half | 42 (54.5%) [43.5, 65.2] | 40 (54.8%) [43.4, 65.7] |
| guard | 1 (1.3%) [0.2, 7.0] | 0 |

**IJF bands:**

| Band | OFF (n=77) | ON (n=73) |
|------|-------------|------------|
| yuko | 34 (44.2%) | 33 (45.2%) |
| not_scored | 43 (55.8%) | 40 (54.8%) |

**Verdict: STILL UNDERPOWERED** - 34 and 33 scoring throws per arm (target: 100). Side-landing CIs overlap.

## Code path: landing seat determination

The landing seat is picked in `GrappleResolve.gd:107-112` by the takedown grade:

```
match grade:
    4: to_seat = "side"   → IJF: yuko
    3: to_seat = "half"   → IJF: not_scored
    _: to_seat = "guard"  → IJF: not_scored
```

The grade is split into thirds of the success probability range (`_takedown_grade`, line 236):
- Grade 4: roll >= p × 2/3 (cleanest throws)
- Grade 3: roll >= p × 1/3, OR power >= defense + 15 (power advantage lifts one grade)
- Grade 2: remainder

`footwork_economy` does NOT enter this code path. It only throttles movement speed (lines 1331, 3157, 3238, 3287 in FightRealtime.gd). Any effect on landings would be indirect: economy → less movement → less fatigue → different success probability → different grade distribution. The data shows this indirect effect is negligible (CIs overlap in both fixtures).

## G131 comparison (ours vs real elite judo)

| Metric | Pop A OFF | Pop A ON | Pop B OFF | Pop B ON | G131 real |
|--------|-----------|----------|-----------|----------|-----------|
| attempts/bout | 0.45 | 0.44 | 0.17 | 0.18 | 11-12/match |
| score rate | 17.4% | 19.7% | 32.4% | 30.0% | ~10% |
| scoring/bout | 0.08 | 0.09 | 0.06 | 0.06 | ~1/match |

**Key gaps:**
- **Attempt rate:** 24-65× fewer throw attempts than real elite judo. This is the root cause of the underpowered sample.
- **Score rate:** 2-3× higher than real (~10%). Our throws score more often when attempted, but there are so few attempts that the absolute scoring rate is still 11-17× below real.
- **Scoring/bout:** 11-17× fewer scoring throws than real. At this rate, reaching 100 scoring throws per arm requires 1,200-2,000 bouts, which is at or beyond the task's cap.

## Summary verdicts

| Fixture | Verdict | Reason |
|---------|---------|--------|
| Pop A (matched judoka) | **STILL UNDERPOWERED** | 47/52 scoring throws (target 100); side CIs overlap |
| Pop B (grappler-v-fish) | **STILL UNDERPOWERED** | 34/33 scoring throws (target 100); side CIs overlap |

**Bottom line:** Footwork economy does NOT move the landing split in either fixture, but neither fixture has enough scoring throws to say so with confidence. The engine's throw attempt rate (0.17-0.45/bout) is 24-65× below real elite judo (11-12/match), which is the root cause. No tuning was done per task instructions.
