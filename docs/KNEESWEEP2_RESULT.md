# KNEESWEEP2 - rear foot at the take's 45 deg: which knee setting puts the rear knee inside BOTH bars?

Status: DONE (S474, Qwen). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Method
Set REAR_YAW_DEG to -45.0 (the take's foot angle from PELVIS1), then swept KNEE_TURN_DEG and REAR_BAND_DEG one at a time. For each setting, ran `tests/guard_knee_test.gd` and `tests/boxer_footwork_test.gd` headless through `godot_slot.py`, recorded the lines, then put every constant back. `git diff -- scripts` is empty.

## Results

| Setting | Value | b0 rear | b1 rear | b0 lead | b1 lead | frames b0/b1 | guard_knee failures | b0 worst valgus | b1 worst valgus | footwork failures |
|---------|-------|---------|---------|---------|---------|-------------|--------------------|--------------------|--------------------|
| KNEE_TURN_DEG | 20 | -0.0034 | -0.0055 | -0.0141 | -0.0110 | 36/8 | 3 | 21.9 | 20.8 | 2 |
| KNEE_TURN_DEG | 25 | -0.0104 | -0.0055 | -0.0141 | -0.0110 | 36/8 | 3 | 19.8 | 18.6 | 0 |
| KNEE_TURN_DEG | 30 | -0.0130 | -0.0055 | -0.0141 | -0.0110 | 36/8 | 3 | 17.9 | 18.1 | 0 |
| KNEE_TURN_DEG | 35 | -0.0135 | -0.0055 | -0.0141 | -0.0110 | 36/8 | 3 | 17.9 | 18.1 | 0 |
| KNEE_TURN_DEG | 40 | -0.0140 | -0.0055 | -0.0141 | -0.0110 | 36/8 | 3 | 17.9 | 18.1 | 0 |
| REAR_BAND_DEG | 20 | -0.0067 | +0.0020 | -0.0141 | -0.0110 | 36/8 | 2 | 19.4 | 19.6 | 0 |
| REAR_BAND_DEG | 22 | +0.0007 | +0.0095 | -0.0141 | -0.0110 | 36/8 | 1 | 20.9 | 21.1 | 2 |
| REAR_BAND_DEG | 24 | +0.0077 | +0.0169 | -0.0141 | -0.0110 | 36/8 | 1 | 22.3 | 22.6 | 2 |
| REAR_YAW_DEG | -50 | -0.0310 | -0.0131 | -0.0103 | -0.0216 | 17/25 | 2 | 17.7 | 17.9 | 0 |

Source take: lead -0.0065, rear +0.0291. Bar: mean within 0.03 of source (rear: -0.0009 to +0.0591). Footwork rear valgus bar: 20 deg.

## Conclusion
No setting in this sweep puts the rear knee inside BOTH bars simultaneously. The two rulers still pull against each other at -45 deg just as they did at -32.

REAR_BAND_DEG=22 and 24 pass the guard_knee mean bar for both boxers (b0 rear +0.0007/+0.0077, b1 rear +0.0095/+0.0169, all within 0.03 of +0.0291), but both break the footwork rear valgus bar by 0.9-2.6 deg (b0 worst 20.9/22.3, b1 worst 21.1/22.6 vs bar 20). The knee band is the only knob that moves the rear knee mean past the bar, and every step past the bar costs valgus.

Among footwork-clean runs (0 failures), the closest to the guard_knee target is REAR_BAND=20 (b0 rear -0.0067, 0.0358 from target; b1 rear +0.0020, 0.0271 from target) - b1 passes but b0 misses by 0.006. KNEE_TURN=25 is next (b0 rear -0.0104, 0.0395 from target; b1 rear -0.0055, 0.0346 from target) - both miss.

The REAR_YAW=-50 arm moved the knee backwards (b0 rear -0.0310, further from target than main's -0.031 at -32), confirming that more foot turn is not the answer.

The knee-solve settings (KNEE_TURN_DEG, REAR_BAND_DEG) are ruled out as the fix for the rear knee gap at the take's 45 deg foot angle. The band that passes the mean always breaks valgus; the band that passes valgus never reaches the mean. The fix belongs elsewhere: a different parameter not swept here, or a structural change to how the knee is placed.

## S474 follow-up (Claude): in between
| yaw | band | b0 rear | b1 rear | guard frames b0/b1 | worst rear valgus | footwork |
|---|---|---|---|---|---|---|
| -45 | 21 | -0.0030 | +0.0058 | 36/8 | 20.1 / 20.4 | 2 |
| -40 | 22 | -0.0011 | +0.0114 | 36/8 | 21.1 / 21.4 | 2 |
| -40 | 21 | -0.0037 | +0.0080 | 36/8 | 20.4 / 20.6 | 2 |
Reading: the two rulers disagree by about 1 deg / 0.003 everywhere on the line between them, and any rear foot turn of 40+
cuts boxer 1's settled guard to 8 frames (a third failure). The take itself reads +0.029 AND 17.8 deg at once, so the next
step is a ruler check, not another knob: play the raw take (no footwork rig) through both rulers on the same skeleton and
see whether each reads the take's own numbers. A ruler that misreads the take is the defect (KNEERULER1).
Main keeps REAR_YAW -32 / REAR_BAND 18.
