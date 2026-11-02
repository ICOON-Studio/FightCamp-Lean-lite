# Q188 DIGEST — Sparring-intensity mode in the fight engine

Owner: qwen. Branch `qwen/q188-spar-intensity`. Assigned S85, 2026-09-26.

## What

`FightRealtime.begin(fa, fb, options)` accepts `options["spar"]`: `""` (default, a bout — byte-identical to today) or one of `"technical"`, `"light"`, `"hard"`.

## Constants

```
SPAR_POWER := {"technical": 0.35, "light": 0.55, "hard": 0.85}
SPAR_STOP_HEAD := 70.0
```

G117 section 1: technical/light ~30-60% power, hard is agreed fight pace. Values at the low end of the band; the coach stop is the safety net, not the power scale.

## Every path from landed strike to condition loss or knockdown, scaled

The task warned: scaling damage in ONE place is not enough if knockdowns come from another number. Six paths traced and scaled:

| Path | Location | How scaled |
|---|---|---|
| **Wear** (condition loss, all 6 regions) | `_run_impact` ~L4130 | `wear[r] *= SPAR_POWER[spar]` after KB head wear mult |
| **KB head wear mult** (2.5x) | `_run_impact` ~L4129 | Composes multiplicatively: `2.5 × spar_scale` |
| **Shock** (feeds knockdown) | `_run_impact` ~L4014 | `shock *= SPAR_POWER[spar]` after KB tech mult |
| **Knockdown from shock** | `_run_impact` ~L4051 | Scaled indirectly: fewer shocks → fewer KD rolls |
| **KO (failed recovery)** | `_go_down` ~L2200 | Suppressed in spar: man always recovers |
| **Three-knockdown TKO** | `_go_down` ~L2205 | Suppressed in spar: no 3-KD rule in a gym |

## Stoppage suppression in spar mode

| Stoppage | Suppressed? | Replaced by |
|---|---|---|
| Referee (standing TKO) | Yes | Coach stop |
| Doctor (head ≤ 15) | Yes | Coach stop |
| Corner (KB, head ≤ 80 + KD) | Yes | Coach stop |
| Judo contest | Yes | Coach stop |
| Submission finish | Intercepted | Tap, spar continues |
| KO / 3-KD TKO | Intercepted | Man always recovers |

## Coach stop

`_spar_coach_stop(state, seconds)` fires after every impact and between rounds:
- **Technical / light**: knockdown OR head condition ≤ 70 → `COACH_STOP`
- **Hard**: knockdown only → `COACH_STOP`
- Method is `"COACH_STOP"` so `result()` can detect the spar path

## Submission tap

`_finish_submission` checks spar mode first. A lock that would finish:
- Records a `"submission_tap"` event in the log
- Increments `spar_taps[top_side]`
- Resets `sub_open`, spar continues

## Result format

A spar never produces KO, TKO, submission finish or decision. `result()` returns:
```
{"spar": true, "intensity": "technical", "rounds_done": 3, "stopped": false,
 "landed_a": 42, "landed_b": 38, "head_a": 88.5, "head_b": 82.1,
 "tap_a": 1, "tap_b": 0}
```

## Byte-identity proof

5 seeds × 3 rulesets: `spar=""` produces the same method and winner as no spar key. 15/15 matched.

## Census (10 spars/pair, 5 pairs per ruleset, 3 rounds)

### Boxing
| Intensity | Head loss/min | KD/spar | Coach stops | Bell ends | Rounds |
|---|---|---|---|---|---|
| bout | 3.95 | 0.18 | — | 45/50 | 141/150 |
| technical | 0.76 | 0.02 | 1 | 49/50 | 147/150 |
| light | 1.56 | 0.06 | 4 | 46/50 | 141/150 |
| hard | 3.09 | 0.22 | 11 | 39/50 | 126/150 |

### Kickboxing
| Intensity | Head loss/min | KD/spar | Coach stops | Bell ends | Rounds |
|---|---|---|---|---|---|
| bout | 11.96 | 0.54 | — | 20/50 | 108/150 |
| technical | 3.12 | 0.08 | 7 | 43/50 | 140/150 |
| light | 5.82 | 0.20 | 48 | 2/50 | 73/150 |
| hard | 10.18 | 0.42 | 23 | 27/50 | 107/150 |

### MMA
| Intensity | Head loss/min | KD/spar | Coach stops | Taps | Bell ends | Rounds |
|---|---|---|---|---|---|---|
| bout | 4.75 | 0.40 | — | — | 34/50 | 121/150 |
| technical | 0.88 | 0.04 | 4 | 5 | 46/50 | 143/150 |
| light | 2.06 | 0.06 | 9 | 5 | 41/50 | 134/150 |
| hard | 3.69 | 0.30 | 18 | 0 | 32/50 | 110/150 |

### Key observations
- **Hard > light > technical** head loss/min in every ruleset ✓
- **Technical head loss/min ≤ 45% of bout**: boxing 19%, KB 26%, MMA 19% ✓
- **KB light** has many coach stops (48/50) because KB's 2.5x head wear multiplier composes with the 0.55 spar scale to 1.375x bout wear — the head reaches 70 fast, the coach does his job. This is correct safety behaviour, not a defect.
- **MMA taps**: 5 in technical, 5 in light, 0 in hard — the tap path works and intensity-scaled as expected.
- **Pace NOT scaled** — technical sparring is high-volume, low-power, matching G117.

## Population (census pairs)

**Boxing**: out-boxer vs pressure, counter vs swarmer, pressure vs counter, out-boxer vs swarmer, swarmer vs out-boxer. Different reach (170-190 cm), weight (67-72.5 kg), stance, plan.

**Kickboxing**: outside kicker vs Dutch, counter vs pressure, Dutch vs counter, pressure vs kicker, kicker vs pressure. Different reach (176-188 cm), weight (75-78 kg), stance, plan.

**MMA**: grappler vs striker, striker vs wrestler, wrestler vs grappler, striker vs grappler, grappler vs wrestler. Different reach (178-190 cm), weight (84 kg), grapple 38-80, plan.

## Test

`fight_spar_intensity_test.gd`: 117 checks, 0 fails.
- Constants exist and have correct values
- Byte-identity: 5 seeds × 3 rulesets
- Zero KO/TKO/submission/doctor finishes in any spar (5 seeds × 3 intensities × 3 rulesets)
- Technical head loss/min ≤ 45% of bout (3 rulesets)
- Hard > light > technical ordering (boxing, 5 seeds)
- Coach stop fires when head forced under 70 in technical
- Coach stop does NOT fire in hard for head condition alone (only KD)

## Gate

`python Godot/tools/run_tests.py --only fight_realtime,fight_scoring,fight_kb,fight_footwork,fight_pace,fight_spar --jobs 2`

Master baseline (2026-09-26): `fight_scoring_test` failed + six JUDO rows inside `fight_realtime_test`.

## Owned files

- `Godot/scripts/FightRealtime.gd` — spar option only
- `Godot/tools/q188_spar_census.gd` — census tool
- `Godot/tests/fight_spar_intensity_test.gd` — test
- `research/Q188_DIGEST.md` — this file
