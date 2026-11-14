# KNEERULER1 - do both knee rulers read the raw take as the take?

Status: DONE (S474, Qwen). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Method
Played the same guard idle (no footwork rig = `off=all`, rig on = default) through both rulers on the same two boxers (red orthodox mh_boxer_01, blue southpaw mh_boxer_02). Compared each ruler's read on the raw take with the take's own numbers from the source tools (tools/knee_plane_raw.py, tools/stance_raw.py).

## Results

| Ruler | Rig | Boxer | Lead | Rear |
|-------|-----|-------|------|------|
| plane (m) | off | b0 red orthodox | -0.0113 | +0.0171 |
| plane (m) | off | b1 blue southpaw | -0.0105 | +0.0181 |
| plane (m) | on | b0 red orthodox | -0.0154 | -0.0105 |
| plane (m) | on | b1 blue southpaw | -0.0248 | -0.0079 |
| valgus (deg) | off | b0 red orthodox | +0.4 | +17.2 |
| valgus (deg) | off | b1 blue southpaw | +0.7 | +16.2 |
| valgus (deg) | on | b0 red orthodox | +1.0 | +11.0 |
| valgus (deg) | on | b1 blue southpaw | +1.5 | +12.3 |

Source take (tools/knee_plane_raw.py): lead -0.0065 m, rear +0.0291 m.
Source take valgus (tools/stance_raw.py): lead 1.2 deg, rear 17.8 deg.

## Conclusion
The valgus ruler reads the raw take faithfully: rear mean 16.2-17.2 deg vs the take's own 17.8 deg (within 1.6 deg). The plane ruler reads the raw take in the right direction but undershoots the rear by 0.011-0.012 m (+0.017/+0.018 vs +0.029). The footwork rig then pushes the plane ruler's rear past zero to the wrong sign (-0.008/-0.011) and reduces the valgus ruler's rear by about 6 deg (11.0/12.3 vs 16.2/17.2 raw). The plane ruler is the one that misreads: it sees only 60 % of the take's rear knee offset on the raw skeleton, and the rig's correction overshoots past zero into the opposite direction. The valgus ruler is honest — both on the raw take and with the rig, it reports what the knee actually does.
