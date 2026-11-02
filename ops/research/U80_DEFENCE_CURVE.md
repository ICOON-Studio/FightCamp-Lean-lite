# U80 — Defence cap replaced with diminishing-returns curve

## What changed

`_defender_defense_factor` in `FightSimulation.gd` now applies

```
bonus = 0.35 × (1 − exp(−sum / DEFENCE_CURVE_SCALE))
```

instead of `clampf(sum / 40, 0, 0.35)`. `DEFENCE_CURVE_SCALE := 60.0` sits beside
`SUBMISSION_BASE_THRESHOLD` with U73's census numbers in the comment.

## Saturated-cell definition (from U73)

Fifteen catalogue disciplines × four generated-opponent ratings (30, 50, 70, 90) =
**60 standing-strike cells**. For each cell, sum the magnitudes of prefix defence
nodes whose phases seat the defender standing and whose effect keys answer an
incoming strike (`U73_DEFENCE_CAP.md` census method). A cell is **saturated** when
that bonus equals **0.35** (the ceiling). Implied land rate uses eq=0.8 and
defence attribute 60: `0.75 − (0.21 + bonus)`.

## Scale sweep (census recomputed from catalogue; k=0 is the shipped ÷40 cap)

| DEFENCE_CURVE_SCALE | Saturated cells | Mean land rate |
| ---: | ---: | ---: |
| 0 (÷40 cap, unchanged) | 28 / 60 | 33.7% |
| 30 | 5 / 60 | 39.9% |
| 45 | 3 / 60 | 42.0% |
| **60 (shipped)** | **3 / 60** | **43.4%** |
| 90 | 2 / 60 | 45.3% |

**60 stays the choice.** k=45 matches saturated count but mean sits at 42.0%,
below the UFC division-accuracy band (43.2–48.6%). k=90 drops saturation to 2
but pushes mean to 45.3% without a measured anchor gain. k=60 is U73 option (c).

## Five named pairs (`measure_ground_seats.gd`, catalogue md5=875094aa, 40 bouts, seed 910000)

Standing strike land rates are the defence-sensitive rows; BJJ/judo/sambo pairs
have no standing strikes under their rulesets.

### Before (÷40 cap)

| Pair | Standing strikes landed |
| --- | --- |
| BJJ Guard Player vs Pressure Passer | A=0/0 B=0/0 |
| MMA Grappler vs MMA Striker | A=89/153 (58.2%) B=324/523 (62.0%) |
| MMA Muay Thai Striker vs MMA Jiu-jitsu Fighter | A=267/444 (60.1%) B=41/180 (22.8%) |
| Judo Thrower vs Newaza Specialist | A=0/0 B=0/0 |
| Sambo Thrower vs Sambo Leglocker | A=0/0 B=0/0 |

### After (k=60)

| Pair | Standing strikes landed |
| --- | --- |
| BJJ Guard Player vs Pressure Passer | A=0/0 B=0/0 |
| MMA Grappler vs MMA Striker | A=69/115 (60.0%) B=228/391 (58.3%) |
| MMA Muay Thai Striker vs MMA Jiu-jitsu Fighter | A=151/257 (58.8%) B=47/108 (43.5%) |
| Judo Thrower vs Newaza Specialist | A=0/0 B=0/0 |
| Sambo Thrower vs Sambo Leglocker | A=0/0 B=0/0 |

The S1e defence pair moves from a 60%/23% split to 59%/44% — the jiu-jitsu
fighter's standing offence is no longer brick-walled by a single saturated node.

## Tests

- `fight_beat_defence`: passes.
- `technique_defence_answers`: **fails** (2 cases pin the old ÷40 factor values:
  sprawl 0.525→0.270, guard retention 0.525→0.248). Test not edited per task;
  needs re-pin against the curve.
- Subsets: grapple/judge/smoke/fight_simulation/fight_stamina/fight_log all
  `fails=0`. `ring` fails=1 (`fight_scoring_test`, pre-existing). `technique`
  fails=2 (`fight_stage_technique_fidelity_test` pre-existing +
  `technique_defence_answers_test` new).
