---
name: feedback_bucket_defect_by_clip
description: "Before fixing a visual defect in the live room, split the measured frames by WHICH CLIP is playing - a code-reading diagnosis ranked the wrong cause first (S131)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5812acc7-b375-4080-9320-a46dffa31a68
  modified: 2026-09-30T00:55:56.572Z
---

S131: the operator saw "the rotation of the body is not aligned with the feet". A read-only helper agent ranked cause #1
"the foot lock pins position but ignores the root's yaw" with file:line evidence; I built a pivot step for it and the
twist instrument read IDENTICAL numbers (it fired twice in 30 s). One extra column - bad frames grouped by the playing
clip - showed 60-80% of the WALK/STRAFE clips' frames twisted >35 deg vs 9 of 310 idle frames: the cause was the
locomotion clips, not the lock. The fix (shuffle from the bell) then cut p95 110 -> 42 deg.

**Why:** code reading finds mechanisms that COULD cause a picture; only a per-clip / per-state split of the measured
quantity says which one DOES. [[feedback_measure_one_body_first]] [[feedback_open_the_output_before_the_gate]]
**How to apply:** every live-room defect instrument prints its bad frames grouped by current_animation (and the legs'
layered walk) and by state (whole strike / shuffle / other) BEFORE any fix is written. Also: headless `--script`
probes never enter the tree - compose transforms by hand (FightStagePlayer.skeleton_world/_pose_global).
