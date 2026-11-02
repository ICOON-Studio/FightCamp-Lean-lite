# C82 - The strike band costing

## Result

A physically plausible band is expensive against the current fight trajectory.
Across 200 unchanged seeded boxing bouts (seeds 200000-200199), the candidate
`[0.30, 0.95]` band retains 85,485 of 148,232 currently scored strikes, or
**57.6697%**. Requiring the owned clip's approximately 0.747 m reach as a
0.75 m ceiling would place **67.5650%** of currently scored strikes above the
ceiling.

This is a post-hoc measurement, not a simulation of the proposed gate. I could
not model the downstream fight after rejection without editing the engine,
which this costing explicitly forbids. More importantly, every figure below is
a **LOWER BOUND on disruption**: a rejected attempt does not simply vanish. It
changes what both fighters do next, so strikes that would have followed are not
present in this unchanged-run sample.

## Method

`fight_strike_band_test.gd` reuses Q34/Q35's fighters, boxing ruleset, 200
bouts, and seeds 200000-200199. It leaves `FightRealtime.gd` and `RingSpace.gd`
unchanged, records every scored strike's event distance, and classifies the
result post hoc. Concentration rates use the strikes in each group as their
denominator rather than comparing raw group volumes.

For the main `[0.30, 0.95]` band, the test also follows each currently scored
out-of-band strike forward through the unchanged 20 Hz tick stream until the
pair's separation next lies inside the band. That is an observed geometric
refill estimate only; a real rejection would alter that future stream.

## Candidate floor cost

| Floor | Strikes below | All strikes | Share below |
|---:|---:|---:|---:|
| 0.20 m | 2,602 | 148,232 | 1.7554% |
| 0.30 m | 6,173 | 148,232 | 4.1644% |
| 0.45 m | 14,764 | 148,232 | 9.9601% |

The 0.30 m and 0.45 m results agree with Q35's reported 4.16% and 9.96%.

## Candidate ceiling cost

| Ceiling | Strikes above | All strikes | Share above |
|---:|---:|---:|---:|
| 0.75 m | 100,153 | 148,232 | 67.5650% |
| 0.85 m | 82,172 | 148,232 | 55.4347% |
| 0.95 m | 56,574 | 148,232 | 38.1658% |
| 1.05 m | 21,335 | 148,232 | 14.3930% |

The clip-calibrated 0.75 m ceiling would reject more than two thirds of the
existing scored-strike sample. Even the comparatively permissive 1.05 m
ceiling catches 14.3930%.

## Joint band cost

Endpoints are inclusive: a strike survives when `min <= distance <= max`.

| Band | Below | Survives | Above | Survival share |
|---|---:|---:|---:|---:|
| `[0.30, 0.95]` | 6,173 | 85,485 | 56,574 | 57.6697% |
| `[0.30, 1.05]` | 6,173 | 120,724 | 21,335 | 81.4426% |
| `[0.45, 0.95]` | 14,764 | 76,894 | 56,574 | 51.8741% |
| `[0.20, 0.85]` | 2,602 | 63,458 | 82,172 | 42.8099% |

The ceiling dominates the cost in every proposed pair. Of these candidates,
`[0.30, 1.05]` is the only one retaining more than four fifths of the recorded
sample, but 1.05 m is still materially beyond the measured 0.747 m hand travel.

## Who loses under `[0.30, 0.95]`

### Round

| Round | Out of band | All strikes | Rate |
|---:|---:|---:|---:|
| 1 | 24,195 | 58,990 | 41.0154% |
| 2 | 20,515 | 48,079 | 42.6694% |
| 3 | 18,037 | 41,163 | 43.8185% |

The rate rises modestly by round (2.80 percentage points from round 1 to 3),
but is not sharply concentrated in one round.

### Fighter and reach

| Fighter | Reach | Out of band | All strikes | Rate |
|---|---:|---:|---:|---:|
| A | 183 cm | 31,049 | 73,895 | 42.0177% |
| B | 176 cm | 31,698 | 74,337 | 42.6409% |

The two rates differ by only 0.62 percentage points. The longer-reach fighter
does **not** lose more in this pairing; if anything, his rate is slightly lower.
This one fixed reach pairing is evidence against a reach-specific penalty here,
not proof across all archetypes.

### Intent

| Intent | Out of band | All strikes | Rate |
|---|---:|---:|---:|
| `close` | 7,382 | 22,302 | 33.1002% |
| `hold` | 20,334 | 36,194 | **56.1806%** |
| `retreat` | 14,619 | 41,335 | 35.3671% |
| `circle` | 20,412 | 48,401 | 42.1727% |

This is the meaningful concentration: `hold` is 14.01 percentage points above
the overall 42.33% out-of-band rate and 23.08 points above `close`. A band would
systematically remove more strikes from hold-state exchanges in the recorded
sample.

### Ring place

| Place | Out of band | All strikes | Rate |
|---|---:|---:|---:|
| Centre | 40,825 | 96,046 | 42.5057% |
| Ropes | 19,014 | 44,251 | 42.9685% |
| Corner | 2,908 | 7,935 | 36.6478% |

Centre and ropes are effectively even. Corner strikes are less likely to be
out of band by about six percentage points, so the candidate does not
disproportionately punish corner exchanges in this sample.

## What may fill the gap

For `[0.30, 0.95]`, 62,665 out-of-band strike observations reached a later
in-band separation before bout end; 82 did not. The time to the next in-band
tick had a **0.700 s median** and **3.500 s p90**.

The median suggests many geometric gaps refill quickly, but the long tail is
large enough to be visible. This cannot be translated into "the fight loses
0.7 seconds per rejection": overlapping strike observations share future
ticks, and rejection would change movement, intent, RNG consumption, later
attempts, and scoring. The only defensible conclusion is that the unchanged
trajectory often returns to the band within a second, while a material tail
takes several seconds.

## Decision read

Do not treat the narrow clip-calibrated ceiling as a cheap realism correction:
0.75 m excludes 67.5650% of today's scored strikes. The gentlest measured joint
candidate, `[0.30, 1.05]`, retains 81.4426%, while `[0.30, 0.95]` retains only
57.6697% and is selectively harsh on `hold` exchanges. Any live band therefore
needs an integration decision that accounts for trajectory and pinned-scorecard
movement; this post-hoc costing cannot authorize that behavior change.

## Gate

- Parse: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- Focused run: `FIGHT_STRIKE_BAND_TEST PASS (22 checks)`.
- No full suite and no `--only fight` run, per the C82 tier.
