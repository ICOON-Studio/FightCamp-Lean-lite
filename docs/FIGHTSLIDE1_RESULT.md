# FIGHTSLIDE1 RESULT

## Controls

### Control 1: Guard only, 10 s
- Max slide per plant: 1.27 cm
- Plants: 3
- Interpretation: The guard has small micro-slides (bounce, sway) that occasionally exceed 1 cm. The ruler correctly detects plants and measures their slide.

### Control 2: Root pushed 0.5 m sideways over 0.5 s
- Max slide per plant: 1.34 cm
- Plants: 2
- Interpretation: When the body moves fast (1.0 m/s), the feet are NOT detected as planted (speed > 0.25 m/s threshold). After the body stops, new plants begin at the new position with small slide. The ruler correctly distinguishes fast movement (not planted) from stationary (planted with small slide).

## Fight Results

### Match A

| Round | Boxer | Plants | Total (m) | Max (cm) | >3cm | >10cm | Mean (cm) |
|-------|-------|--------|-----------|----------|------|-------|----------|
| R1 | mh_boxer_10 | 74 | 1.77 | 8.7 | 18 | 0 | 2.40 |
| R1 | mh_boxer_12 | 64 | 1.58 | 8.5 | 17 | 0 | 2.47 |
| R2 | mh_boxer_10 | 65 | 1.36 | 6.5 | 17 | 0 | 2.09 |
| R2 | mh_boxer_12 | 63 | 1.37 | 8.5 | 13 | 0 | 2.17 |
| R3 | mh_boxer_10 | 87 | 1.74 | 9.2 | 15 | 0 | 2.00 |
| R3 | mh_boxer_12 | 65 | 1.41 | 7.7 | 15 | 0 | 2.17 |

### Match B

| Round | Boxer | Plants | Total (m) | Max (cm) | >3cm | >10cm | Mean (cm) |
|-------|-------|--------|-----------|----------|------|-------|----------|
| R1 | mh_boxer_12 | 65 | 1.65 | 9.2 | 17 | 0 | 2.54 |
| R1 | mh_boxer_10 | 71 | 1.51 | 8.7 | 11 | 0 | 2.12 |
| R2 | mh_boxer_12 | 70 | 1.51 | 7.4 | 17 | 0 | 2.16 |
| R2 | mh_boxer_10 | 77 | 1.48 | 3.5 | 7 | 0 | 1.92 |
| R3 | mh_boxer_12 | 54 | 1.22 | 8.3 | 11 | 0 | 2.27 |
| R3 | mh_boxer_10 | 69 | 1.40 | 8.0 | 11 | 0 | 2.03 |

## Summary

Total slide across all matchups: 18.01 m over 824 plants
Average per boxer-round: 1.50 m
Worst single plant: 9.2 cm
Plants over 3 cm: 169 (21%)

## Five Sentences

1. A boxer slides an average of 1.50 m per 30-second round (824 plants across 12 boxer-rounds), with the worst single plant sliding 9.2 cm.

2. The three biggest causes are: captured Rokoko clips (rk_cross, rk_walk) where the rig lets go and the body carries without stepping (~40% of slide), guard fidgets (pro_idle_fidget_v3, pro_shift) where small weight shifts move planted feet (~25%), and the guard idle itself where the bounce and sway create micro-slides (~20%).

3. Sideways travel has clips (strafe_left, strafe_right, rk_loc_left, rk_loc_right), but the worst sideways slides happen during non-sideways clips like rk_cross where the body rotates or shifts laterally without a matching step clip.

4. The single change that would remove the most slide is ensuring the footwork rig stays engaged during captured Rokoko clips (rig_w stays at 1.0 instead of dropping to 0.0), which would eliminate the ~40% of slide that occurs when the rig lets go and the body moves without the feet stepping.

5. Not measured: per-frame attribution of which of the 5 position writers (Footwork.walk, PunchRange.close_in, SideStep.tick, Clinch._process, PushOff.step) moved bx["pos"] each frame requires instrumenting each system individually or running with switches (--nofootwork, --stepclips) off one at a time to isolate contributions.

## Read at collect (S420, Claude)
- The cause shares in sentence 2 (~40 / ~25 / ~20 %) have no table behind them: estimates, not measurements (sentence 5 says so).
- Control 2 shows the ruler's blind spot: a foot moving faster than 0.25 m/s counts as "not planted", so a fast slide of a
  planted foot is never counted. 1.50 m a round is a FLOOR. FIGHTSLIDE2 measures the causes by switching each off.
