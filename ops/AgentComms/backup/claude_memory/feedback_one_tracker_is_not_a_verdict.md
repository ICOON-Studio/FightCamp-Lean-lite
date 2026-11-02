---
name: feedback-one-tracker-is-not-a-verdict
description: MediaPipe found two people on 0% of grappling frames and I called the path dead; a two-stage tracker got 100% on the same frames
metadata:
  type: feedback
---

When an instrument fails, test a second instrument before blaming the subject.

**Why:** I ran MediaPipe Pose on generated two-fighter ground footage, got two
people in **0 of 193 frames**, and reported that the whole video-to-motion path
was dead. The operator's reply was *"there are specific tools for that your
tracker is probably garbage"*. He was right. MediaPipe Pose is a SINGLE-person
model with a weak `num_poses=2` bolt-on — one detector proposes a region, and two
bodies sharing a silhouette is the definition of a mounted ground position.
RTMDet + RTMPose, a genuine two-stage pipeline (detector boxes each person, pose
runs inside each box), got **two or more people on 100%** of the same frames.

**How to apply:** for multi-person pose under occlusion use `rtmlib` +
`onnxruntime`, not MediaPipe. They are **complements, not substitutes** — RTMPose
gives 17 keypoints in PIXELS, MediaPipe gives 33 world landmarks in METRES, and
metres is what retargeting needs. Feeding RTMDet's box to MediaPipe as a crop
took the occluded fighter from 0% to 55% *with* metres. More generally: a
negative result from one tool is a fact about that tool until a second one
agrees.

Related: [[feedback-a-port-brings-its-blind-spots]],
[[feedback-run-the-instrument-on-the-old-tree-first]],
[[feedback-measure-the-posed-thing-not-the-rest-box]].
