# Q123 — Clinch Arm Geometry from the Paired Corpus

## POPULATION

Three clean side-on clips: `-vPZqptk8jo`, `HL261oRyURE`, `FCM7m6TJWUQ`.
57 clinch frames (hip-midpoint 3D separation in [0.40, 0.80] m):
-vPZqptk8jo = 0, HL261oRyURE = 5, FCM7m6TJWUQ = 52.
Small sample of side-on boxing/sparring footage, not Muay Thai.

## RESULTS

Neck is the **shoulder midpoint** — MediaPipe has no neck landmark.
Y runs DOWN in this frame (pair_world.py:41 docstring says "y — up" which is
wrong: nose y = -1.272, ankle y = +0.042). Positive `wrist_y - neck_y` means
the hand is BELOW the neck.

| quantity | p10 | p50 | p90 |
|---|---|---|---|
| hand_to_opp_neck_m | 0.657 | 0.782 | 1.094 |
| nearest_hand_to_opp_neck_m | 0.589 | 0.721 | 0.789 |
| hand_minus_neck_height_m | 0.128 | 0.443 | 0.481 |
| hip_sep_m | 0.709 | 0.719 | 0.777 |
| stature_m | 1.307 | 1.350 | 1.372 |
| hand_to_opp_hand_m | 0.357 | 0.747 | 1.110 |

## WHAT THIS SAYS ABOUT AN AUTHORED CLINCH

The authored clinch asserts hands finish 0.10–0.30 m apart. The corpus says
**no**: hand_to_opp_hand_m p50 = 0.747 m, p10 = 0.357 m. Even the closest
pairing at p10 is above 0.30 m. The nearest hand to the opponent's neck
(nearest_hand_to_opp_neck_m) sits at 0.721 m — the hands do not reach the
opponent's neck at all in a standing clinch; they control the upper arm or
shoulder from outside. Hands sit 0.443 m below the neck (hand_minus_neck_height_m
p50), meaning at roughly chest/upper-arm height, not at the neck or head.

## CAVEATS

- **Scale under-read:** stature_m p50 = 1.350 m where a 1.80 m man should
  read ~1.61 m (nose-to-ankle). The reconstruction under-reads metric scale
  by roughly 15–20%, and every metre figure above — including Q115's published
  0.719 m hip separation — inherits that.
- **Horizontal error:** ±0.15 m (p90) per Q115.
- **Sample:** 57 frames from three clips is small; FCM7m6TJWUQ dominates (52).
- **Neck proxy:** shoulder midpoint, not a real neck joint.
