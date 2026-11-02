# G139 - The Fence Clinch

**Owner:** Grok (Expert, grok.com/c/8d8d8462-c88b-4f51-b2dc-246c8e394470, 114 sources) | collected by Claude S102,
2026-09-27. Grok delivered a 15 KB document; its tables are rebuilt here with every figure and grade kept, prose condensed.
Grades: S sourced · P proxy · J judgement/charting prior. **No public dataset splits fence from open clinch** - most
precise-looking numbers are P/J priors built to reproduce the published aggregates (clinch clock, TD counts).

## Prefab datasets
| Dataset | Has | Fence split? | Licence / public? |
|---|---|---|---|
| FightMetric / UFC Stats | distance/clinch/ground strikes, control time, TD att/land | No | UFC proprietary; box scores public, TIP not |
| Sportradar UFC API | clinchTime, distanceTime, controlTime, position enum | No | Commercial; field names public, values not |
| Fightnomics (Kuhn, FightMetric 2002-13) | time-in-position, clinch targets, TD types shoot / clinch-lower / clinch-upper | No | Book; excerpts public |
| Gift 2015 (Bloody Elbow) | cage size vs FightMetric | Implicit: extra small-cage clinch is "virtually all" fence | Journalism, public |
| James 2019, Holmes 2022, Miarka time-motion | longitudinal metrics, Markov forecast, bout-phase clocks | No | Academic |

## 1. Duration and referee breaks
| Figure | Value | Grade |
|---|---|---|
| Clinch share of UFC clock | 18% (2013); 15-18% modern | S |
| Of clinch, pinned on the cage | ~70-85% | P/J |
| Established-pin episode | median 12-25 s, IQR 8-40 s (stuffed-shot pins 4-12 s; body-lock pins 15-40 s; wall-and-stall 60-90 s) | J |
| Inactivity rule | no fixed seconds - "real, significant and/or sustained effort" (Unified Rules / CSAC 2024) | S |
| Practical warning -> break | ~8-20 s with no level change, power strike or turn | J |
| Episodes ending in a ref break | 15-25% | J |

Coach read: a 15-minute fight that "lives on the cage" is 6-10 pins of 15-25 s, not one long hug.

## 2. Positions on the fence (share of fence time, J)
| Position | Share | Attacker wants it? |
|---|---|---|
| Over-under | 35-45% | fallback after a stuffed shot / lost pummel; weakest ride, free dirty-boxing hand |
| Double underhooks / body lock | 20-25% | YES - primary; feeds dump, outside trip, mat return |
| Head-and-arm / collar + underhook | 10-15% | situational; breaks posture for knees/elbows |
| Single-leg / high-crotch on the fence | 15-20% | yes if the shot is already there - most stuffed shots die here |
| Wrist ride / chest pin (wall-and-stall) | 5-10% | only to rest; modern cards punish it |
| Double collar / plum on fence | <5% | rare |

Defender craft: win the underhook, two-on-one the wrist, frame the hip, circle the head off, turn. Wall-walk is the ground cousin.

## 3. Output
| Figure | Value | Grade |
|---|---|---|
| Power strikes landed in-position, fence | ~8-12 / 5 min typical; elite dirty boxers 25-33 | P |
| WW clinch power attempts | 23.0 / 5 min, 61% land | S (Gift 2019) |
| Usman clinch power | 32.7 / 5 min, 87% land, 66% to body | S |
| Clinch target mix | head 53% (distance ~80%) | S (Fightnomics) |
| Knees to body/thigh | primary fence weapon, many not "significant" | J |
| Clinch KDs vs distance KDs | fewer than 1/5 as many | S |
| League share of sig. strikes from clinch | ~13-14% (distance ~73%, ground ~14%) | S/P |

Fence = control + short strikes + takedown entry, not a knockout factory.

## 4. How a fence pin ends (per established episode, P/J)
| Exit | Share |
|---|---|
| Takedown by the pin-holder | 25-35% |
| Defender separates (frame / circle / underhook turn) | 30-40% |
| Reversal (defender becomes pinner, sticks > ~3 s) | 5-10% |
| Referee break (resets to centre distance) | 15-25% |
| Finish from the standing pin | 1-3% |
| Round/fight ends pinned | 5-8% |

Fence TD types (J): double-leg off the cage 30-35%, single/high-crotch finish 25-30%, body-lock dump / outside trip 25-30%, other 5-10%.
S anchors: UFC TD success 39% since 2008, 1.5 att / 5 min; shooting ~50% of attempts, upper-body clinch <10%; **clinch TDs
succeed more than shots** (Sterling: distance TD 17% vs clinch 50%; O'Malley TD-def 83% at distance vs 21% in clinch).

## 5. Fence vs open takedowns; wall-walk
| Figure | Value | Grade |
|---|---|---|
| UFC TDs that start/finish on the fence | 45-60% | P/J |
| True open-space shots | 40-55% | P/J |
| Defender starts a wall-walk after a non-finishing fence TD | ~80%+ | J |
| Wall-walk back up within 30 s | ~50-70% unless the attacker has a ride | J |
| Open-space stand-up within 30 s after a centre TD | lower (no wall) | J |

**Engine warning:** if "takedown landed" means 90 s of ground control, the engine over-counts every fence TD the defender walks up in 12 s.

## 6. Weight and sex
Men's weight: modest - heavier = less circling room, more body-lock dumps, fewer wall-walk successes; fly/bantam circle off more (P).
Women: not a different machine - clinch share of strikes ~14% both (W 14.1 / M 13.8%, S); slightly lower TD volume (1.53 vs 1.86 att/15), P. Do not invent a women's fence clock; change rates, not topology.

## 7. Smallest state machine
States: `DISTANCE`, `OPEN_CLINCH` (centre), `FENCE_PIN(att)`, `GROUND_FENCE(att)`, `GROUND_OPEN(att)`. Single-leg = a flag on FENCE_PIN.
Rates per second in state (J/P), tuned so a 15-min fight spends ~12-16% of clock in FENCE_PIN and ~30% of pins convert:

| From -> To | lambda (1/s) | Mean wait |
|---|---|---|
| DISTANCE -> FENCE_PIN | 0.008-0.014 (P) | a pin every 70-125 s of distance |
| DISTANCE -> OPEN_CLINCH | 0.003-0.005 | rare vs fence |
| OPEN_CLINCH -> FENCE_PIN | 0.06 | ~17 s |
| FENCE_PIN -> GROUND_FENCE (TD) | 0.014-0.020 | competing exits cut to 25-35% of episodes |
| FENCE_PIN -> DISTANCE (defender off) | 0.018-0.025 | |
| FENCE_PIN -> FENCE_PIN swap (reversal) | 0.004-0.007 | |
| FENCE_PIN -> DISTANCE (ref break) | 0.008-0.012 after 8 s of low activity; 0 while output/ride live | |
| FENCE_PIN -> finish | 0.0004-0.0008 (P) | 1-3% of episodes |
| GROUND_FENCE -> DISTANCE (wall-walk) | 0.025-0.040 no ride; 0.008-0.015 with ride | 25-40 s vs 60-120 s |
| GROUND_FENCE -> GROUND_OPEN | 0.01 | |
| GROUND_OPEN -> GROUND_FENCE | 0.015 | bottom scoots to the wall |

Activity modifier: a power strike or level change by the pin-holder in the last 3 s zeroes the ref-break hazard for 8-12 s.
Defer: grip layer, FENCE_SINGLE state, sex/weight topology, stomps/fence-grab fouls, control-without-damage scoring.
Retune the J rates against fight-clock clinch share + TD count, never against an invented median.
