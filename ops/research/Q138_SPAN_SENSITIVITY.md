# Q138 SPAN SENSITIVITY

## Method

For each capsule on each rig, sweep L from measured to 3x in 1 mm steps,
holding r fixed. Find the smallest L where r/L < 0.50 (STOUT or better).

## Roll-up

| capsule | n | med L_meas | med L_exit | med ratio | never_exit |
|---------|---|------------|------------|-----------|------------|
| femur_l | 12 | 419.0 | 419.0 | 1.00x | 0 |
| femur_r | 12 | 419.0 | 419.0 | 1.00x | 0 |
| foot_l | 12 | 161.5 | 167.0 | 1.07x | 0 |
| foot_r | 12 | 161.5 | 161.5 | 1.00x | 0 |
| forearm_l | 12 | 246.5 | 246.5 | 1.00x | 0 |
| forearm_r | 12 | 246.5 | 246.5 | 1.00x | 0 |
| head | 12 | 110.5 | 257.0 | 2.32x | 3 |
| neck | 12 | 58.5 | 111.0 | 1.90x | 0 |
| pelvis | 12 | 214.5 | 349.5 | 1.66x | 0 |
| shin_l | 12 | 401.5 | 401.5 | 1.00x | 0 |
| shin_r | 12 | 401.5 | 401.5 | 1.00x | 0 |
| shoulder_span | 12 | 362.0 | 362.0 | 1.00x | 0 |
| thorax | 12 | 278.0 | 278.0 | 1.00x | 0 |
| upper_arm_l | 12 | 242.5 | 242.5 | 1.00x | 0 |
| upper_arm_r | 12 | 242.5 | 242.5 | 1.00x | 0 |

## Neck vs ANSUR

J42 ANSUR Neck Link = 107.8 mm.
(Source file research/CLAUDE_LAND_NOTE_J42.md not found; value from task file.)

| rig | L_exit_mm | verdict |
|-----|-----------|---------|
| f01_m_box_welter | 111 | ABOVE - still NEEDLE |
| f02_m_box_heavy | 111 | ABOVE - still NEEDLE |
| f03_f_box_fly | 111 | ABOVE - still NEEDLE |
| f04_f_box_middle | 111 | ABOVE - still NEEDLE |
| f05_m_mma_light | 111 | ABOVE - still NEEDLE |
| f06_m_mma_lhw | 111 | ABOVE - still NEEDLE |
| f07_f_mma_straw | 111 | ABOVE - still NEEDLE |
| f08_f_mma_bantam | 111 | ABOVE - still NEEDLE |
| f09_m_bare_welter | 111 | ABOVE - still NEEDLE |
| f10_m_bare_heavy | 111 | ABOVE - still NEEDLE |
| f11_f_bare_feather | 111 | ABOVE - still NEEDLE |
| f12_f_bare_welter | 111 | ABOVE - still NEEDLE |

## Verdict

A span correction is NOT worth doing on its own terms.
The neck median exit (111.0 mm) exceeds the real ANSUR neck
(107.8 mm), so even a correct span leaves the neck a NEEDLE.
The pelvis needs 1.66x its measured span to exit NEEDLE,
which is anatomically implausible for a structural ring.
The capsule abstraction fails on the trunk because the trunk is not
capsule-shaped - no span correction fixes that.
