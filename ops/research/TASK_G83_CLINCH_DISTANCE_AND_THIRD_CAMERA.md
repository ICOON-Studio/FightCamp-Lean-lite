# TASK_G83 - two numbers S63 needs: the hips distance of each standing clinch seat, and the camera that sees a wrapped guard's hips (Grok)

Model: Grok, Research mode, Expert. NEVER Build. Owner: grok. Assigned S62, 2026-09-24, after G82.

## Part A - the clinch floor per seat
S62 gave the engine ONE clinch floor: 0.28 m hips-to-hips (your G79 lower band edge, "clinch lock
0.28-0.40 m COM"), scaled by mean arm. The engine knows WHICH clinch it is in (seats: over_under,
collar tie / plum, body lock / double underhooks, single collar, front headlock standing, cage
pressure). One number for all of them is the same error as one metre for every weight. For each
seat: the centre-of-mass (or hips) distance band, MEASURED where any study, mocap set or broadcast
tracking gives it (N and marker set), DERIVED from anthropometry where it can be (two half-torso
depths + arm geometry, show the sum), JUDGEMENT otherwise; and the closing speed into that seat
(the pummel is slow, the body-lock entry is a pulse). One table, one row per seat, labels on every
cell, and the two seats the engine should treat as the SAME distance if you find they are.

## Part B - the third camera
Our two-camera generated clips (1x2, opposite side views) track both men on 100% of frames, but in a
wrapped closed guard the TOP man's hips and thighs hide behind the bottom man's wrapped legs from
both sides. Overhead (straight down) and end-on views were useless to the tracker (9.8% and 3.6% on
a mount). Codex asked for "a third oblique-high camera". Which angle - elevation and azimuth relative
to the two men's line - sees the top man's hips in a closed guard, a half guard and a mount, from what
broadcast and mocap practice (UFC's cage cameras, judo's IJF camera plan, lab mocap rigs for ground
grappling) actually does? Give the angle with its source and label; if nothing measured exists, give
the geometry (where the occluding legs are relative to the hips) and the JUDGEMENT.

Deliver ONE document `G83_CLINCH_DISTANCE_AND_THIRD_CAMERA.md`. Labels on every row. Argue against
yourself at the end: which seat's number will be wrong first, and why a third camera might still
not see the hips. No code.
