# C180 digest — per-segment suit tracker

The Python-only gate passed on `closed_guard_segment_suits_1x2_4s.mp4` with
`panels=2`: 97 frames × 2 panels, 24 segment records per entry. The tracker
learns its legend from `closed_guard_segment_suits_single.png` with seeded
k-means in circular HSV space, so red/coral/salmon use wrapped hue distance.

| Segment group | Visible | Mean confidence | Mean grid roll |
|---|---:|---:|---:|
| A torso | 100.0% | 1.00 | -0.2° |
| A cap | 89.2% | 0.81 | -1.4° |
| A upper arm L | 50.0% | 0.50 | 0.0° |
| A forearm L/R | 100.0% / 100.0% | 0.74 / 1.00 | -1.6° / -8.9° |
| A upper arm R | 100.0% | 1.00 | -22.6° |
| A thighs and shins | 100.0% each | 1.00 each | -10.5°, 3.7°, -1.1°, -3.5° |
| B torso / cap | 100.0% / 100.0% | 0.53 / 1.00 | -6.6° / -0.8° |
| B arms | 100.0% each | 1.00 each | -2.8°, 7.2°, -1.2°, -1.8° |
| B thighs and shins | 100.0% each | 0.52, 1.00, 1.00, 1.00 | 0.0°, -0.8°, -25.1°, 7.2° |

The intentional losses are the four black-glove hand entries (not suit hue,
therefore 0% and excluded from contact inference), A's left upper arm in the
right panel during frames 0–96, and A's cap in the left panel at frames
22–34, 74–75, and 83–89. The top fighter's hips/thighs are the expected
occlusion behind the wrapped legs; the colored thigh masks remain visible but
their confidence is not a reliable joint/occlusion solve. Visible segments
still produce grid-roll readings, with the largest stable readings on A's
right upper arm (-22.6°) and B's right thigh (-25.1°).

The six-frame review sheet is
`research/_captures/ground_video/closed_guard_segment_suits_1x2_4s_segments_sheet.png`.
The per-frame output is
`research/_captures/ground_video/closed_guard_segment_suits_1x2_4s_segments.json`;
the learned legend is next to it as `closed_guard_segment_suits_legend.json`.
Every frame has contacts between differently prefixed masks; the hands are
not falsely inferred from black gloves.

The earlier two-colour tracker reported both bodies found on 100% of frames in
both panels. C180 preserves that identity result while adding segment geometry,
roll, confidence, and contact records; it is not a 3D solve.

Next clip: add a third oblique-high camera and joint marker dots. Keep the
side views for segment colour continuity, but use the high oblique view to
resolve the top fighter's hips behind the wrapped legs and to make hand/joint
contacts explicit.
