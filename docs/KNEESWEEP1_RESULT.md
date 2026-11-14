# KNEESWEEP1 - which knee-solve setting moves the rear knee onto the take?

Status: DONE (S473, Qwen). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Method
For each setting, changed ONE constant, ran `tests/guard_knee_test.gd` and `tests/boxer_footwork_test.gd`, recorded the lines, then put the constant back. All runs headless through `godot_slot.py`.

## Results

| Setting | Value | b0 rear | b1 rear | b0 lead | b1 lead | guard_knee failures | footwork failures |
|---------|-------|---------|---------|---------|---------|--------------------|--------------------|
| KNEE_TURN_DEG | 15 | -0.0064 | -0.0081 | -0.0178 | -0.0297 | 2 | 2 |
| KNEE_TURN_DEG | 30 | -0.0267 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KNEE_TURN_DEG | 45 (main) | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KNEE_TURN_DEG | 60 | -0.0312 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| REAR_BAND_DEG | 10 | -0.0491 | -0.0366 | -0.0178 | -0.0297 | 2 | 0 |
| REAR_BAND_DEG | 18 (main) | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| REAR_BAND_DEG | 26 | -0.0188 | -0.0057 | -0.0178 | -0.0297 | 2 | 2 |
| KneeTrack ALLOW_DEG | 10 | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KneeTrack ALLOW_DEG | 20 (main) | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KneeTrack ALLOW_DEG | 35 | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KneeTrack BENT_DEG | 10 | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KneeTrack BENT_DEG | 15 (main) | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |
| KneeTrack BENT_DEG | 25 | -0.0311 | -0.0172 | -0.0178 | -0.0297 | 2 | 0 |

Source take: lead -0.0065, rear +0.0291. Bar: mean within 0.03 of source.

## Conclusion
None of the four knee-solve settings moves the rear knee toward +0.029 WITHOUT turning boxer_footwork red.

REAR_BAND_DEG=26 moves the rear knee closest to the target (b0: -0.0188, +0.0123 toward target; b1: -0.0057, +0.0115 toward target), but breaks footwork (2 failures: rear valgus bar 20 exceeded at 24.3 deg on mh_boxer_10 and 23.9 deg on mh_boxer_01).

KNEE_TURN_DEG=15 also moves the rear knee toward the target (b0: -0.0064, +0.0247 toward target; b1: -0.0081, +0.0091 toward target), but also breaks footwork (2 failures: same rear valgus bar).

KneeTrack ALLOW_DEG and BENT_DEG have no effect on guard_knee across their ranges - the values are identical to main at every setting tested.

The knee-solve settings are ruled out as the fix for the rear knee gap. The fix belongs elsewhere (foot placement, hip position, or a different parameter not swept here).
