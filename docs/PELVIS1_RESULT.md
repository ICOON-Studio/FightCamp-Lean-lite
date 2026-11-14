# PELVIS1 — the rig's hips against the source take (measure only, no fix)

Same six numbers, same frame of reference (front = the lead foot's toe line, flattened horizontal).
Source take: `tools/stance_raw.py` on `Box1_M3_Idle.fbx` frame 30+, 20 frames, lead = left.
Rig: `tools/pelvis_probe.gd`, two boxers in the guard idle, settled 0.5 s, 121–131 frames averaged.

| number | take | boxer 0 (red orthodox) | boxer 1 (blue southpaw) |
|---|---|---|---|
| ball_to_ball along (m) | 0.460 | 0.506 | 0.503 |
| ball_to_ball across (m) | 0.387 | 0.366 | 0.370 |
| rear_toe_yaw_vs_lead (deg) | −45.4 | −33.0 | +34.1 |
| hips_above_balls (m) | 0.957 | 0.816 | 0.793 |
| pelvis_line_vs_front (deg) | +68.6 | +76.3 | −82.5 |
| rear_ankle_vs_hip_across (m) | −0.110 | +0.056 | −0.077 |

Boxer 0 and the take are both orthodox with the left foot leading, so they read in the same sign convention.
Boxer 1 is southpaw (right foot leads, mirror image): his pelvis_line_vs_front is negative where the take's is positive,
and his rear_ankle_vs_hip_across flips sign for the same reason — comparing magnitudes, not signs, is fairer there.

## The biggest difference

The rig's pelvis line sits 7.7 deg more open (turned away from the lead foot's direction) than the source take:
76.3 deg off the front where the take stands at 68.6 deg. The rig's hips are also 14 cm lower above the balls
(0.816 m v 0.957 m), and the rear ankle tells a different story altogether — the rig places it 5.6 cm outward
from the rear hip on the across axis while the take tucks it 11.0 cm inward, a 16.6 cm gap that crosses zero.
The stance is longer (0.506 m v 0.460 m) and narrower (0.366 m v 0.387 m), and the rear foot yaws 12.4 deg less
inward than the take (−33.0 deg v −45.4 deg). Three of the six numbers — pelvis angle, hips height, and the
rear ankle's side — are not small calibration gaps; they are the shape of a different stance, and any fix that
chases the knee through the hips alone will have to move all three at once.

## S473 (Claude): body size and knee bend, and what DROP does
Added to both tools: leg length (hip-knee + knee-ankle) and leg_straight (hip-ankle / leg length, 1 = straight).
| number | take | boxer 0 | boxer 1 |
|---|---|---|---|
| leg_len (m) | 0.873 | 0.837 | 0.832 |
| leg_straight lead / rear | 0.974 / 0.959 | 0.892 / 0.900 | 0.882 / 0.894 |
Only ~4 cm of the 14 cm hips gap is body size: the rig crouches deeper (knees ~54 deg against the take's ~26 deg;
BoxerFootworkRig DROP's own comment wants ~30). But straightening it does NOT help guard_knee - it moves away:
DROP 0.04 -> rear mean -0.031; 0.0 -> -0.040 (straight 0.94); -0.03 -> -0.044 (straight 0.97). DROP left at 0.04.
So the crouch is not the knee's cause. Left: the rear ankle sits OUTSIDE the rear hip (+0.056 v the take's -0.110) and
the pelvis 7.7 deg squarer - next: shift the hips across toward the rear foot / turn the pelvis, one probe a side.
Hips shifted sideways (skeleton x, temporary `hipx=` arg, reverted): +0.05 -> rear -0.045, lead +0.006; -0.05 -> rear
-0.036, lead -0.042. Neither direction helps the rear knee. With the crouch, the stance (S472) and the hips' side all
ruled out, the rear knee's last 0.06 is in the knee solve itself (the pole/band choice, KneeTrack), not the body above it.
