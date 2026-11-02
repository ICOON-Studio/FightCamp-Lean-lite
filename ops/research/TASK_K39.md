# TASK K39 — KALLI — CAN A 2D POSE TRACKER MEASURE HOW FAST A FIGHTER'S JOINTS TURN?

Model: Grok Bot (Kalli), research. Owner: kalli. Stage: S4a (the joins, R5) - forecast research for a capture.

**Research only.** No code, no downloads. Prose, numbers, citations. One pass. Reply in this chat.

## Why this exists

We plan to film a shipped fighting game (Absolver, offline play) and our own 3D fight at 60 frames per second, run
Google's MediaPipe Pose Landmarker on every frame, and compare how fast the joints turn at the moment one animation
hands over to the next (upper arm, forearm, torso, thigh, shin angles in 2D, and their angular speed). Before we trust
those numbers we need to know how accurate such a tracker is on fast combat motion.

## What we already hold - do NOT re-research

- Our capture rig: 60 fps screen capture, MediaPipe PoseLandmarker (full model, VIDEO mode), 2D segment angles.
- Absolver's published frame data (your K37).

## What to find - one table row per finding

1. **Accuracy of MediaPipe Pose / BlazePose (and, for comparison, OpenPose, MoveNet, RTMPose, ViTPose)** against a
   marker-based motion-capture reference: joint-position error (pixels or mm) and JOINT-ANGLE error (degrees, mean
   +- SD) - with the movement, the camera frame rate and the sample.
2. **Fast movements**: studies of these trackers on punches, kicks, martial arts, sprinting, throwing or other
   high-velocity motion - angular VELOCITY error or peak-velocity underestimation, and the effect of motion blur and
   of 30 vs 60 vs 120+ fps.
3. **Filtering**: what smoothing (e.g. One Euro filter, Butterworth cut-off) such studies used before
   differentiating angles into speeds, and how much it lowered peaks.
4. **Rendered or stylised humans**: any evaluation of pose trackers on video-game footage, CGI or synthetic humans,
   masked or costumed performers - detection rate and error versus real video.
5. **Side-on 2D vs 3D**: how much a 2D angle measured from one camera differs from the true 3D joint angle when the
   limb moves out of the image plane (the foreshortening error), with numbers.

## Rules

- Label every row: **DOCUMENTED** (read in the primary paper), **SECONDARY** (quoted elsewhere), or **NOT FOUND**.
  Never fill a cell with a guess.
- Every row: the finding, the number with its SD and sample, the source (authors, year, venue, DOI or URL).

## Deliverable

One markdown table per section (1-5), columns: Tracker | Finding | Number (mean +- SD, sample) | Label | Source. Then
a short **GAPS** list, and one closing paragraph: the smallest difference in peak joint speed (as a ratio, e.g.
1.2x) that such a capture could reliably detect, and what the capture must do (fps, camera angle, filtering) to get
there.

## Owned files

- `research/K39_POSE_TRACKER_ACCURACY.md` - Claude writes it from the reply; Kalli pushes nothing.
