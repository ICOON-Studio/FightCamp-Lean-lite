# TASK_C180 - the per-SEGMENT suit tracker: 24 hue masks in, JSON per frame out (Codex, full branch)

Model: gpt-5.6-luna, medium (Python vision tooling, not 3D animation design). Owner: codex.
Assigned S62, 2026-09-24, from the operator's idea ("colour the suits with excel-like cells") and
Codex's own review of it (the JSON format below is the one Codex asked for).

## What exists (read these and only these)
- `Tools/footage/track_colour_suits.py` - the two-colour tracker: hue-masks one solid red and one
  solid green suit, paints the other suit out, runs RTMDet + RTMPose (rtmlib, onnxruntime; the
  checkpoints are cached on this box) inside each man's box. Read it whole; reuse its loading and
  its panel split (`panels=2`).
- `research/_captures/ground_video/README.md` - the last two rows: the segment-suit still and
  the 4 s clip `closed_guard_segment_suits_1x2_4s.mp4` (97 frames, 24 fps, 1x2 opposite side views,
  every segment colour survived). The still `closed_guard_segment_suits_single.png` shows the
  colour legend: TOP man torso red, cap magenta, L upper arm orange, L forearm yellow, R upper arm
  dark red, R forearm brown, L thigh pink, L shin salmon, R thigh maroon, R shin coral; BOTTOM man
  torso green, cap teal, L upper arm lime, L forearm yellow-green, R upper arm dark green, R
  forearm olive, L thigh cyan, L shin turquoise, R thigh navy, R shin sky blue. Gloves black,
  hands NOT tracked from the suit (they are gloves and they smear).

## Deliver, on branch `codex/c180-segment-tracker`
1. `Tools/footage/track_segment_suits.py <video> <out.json> [panels=1|2] [--legend legend.json]`.
   The legend maps segment name -> HSV centre + tolerance, LEARNED from a reference still (the
   single-view still above) by k-means over saturated pixels with the operator's colour list as
   seeds, then saved; never hard-code guessed HSV numbers.
2. Per frame, per panel, per segment: the mask's pixel count, its principal axis in the image
   (2D unit vector + length in pixels), its centroid, a `visible` flag (mask above a pixel floor),
   and a `grid_roll` estimate: the dominant orientation of the white grid lines INSIDE the mask
   (Hough or structure tensor on the white pixels) relative to the segment axis - that is the twist
   the operator's grid exists to reveal. Confidence = mask share of its expected area from the
   legend frame.
3. Output JSON per frame exactly in the shape Codex asked for:
   `{"frame": n, "panel": p, "segments": {"A_forearm_L": {"axis_2d": [x,y], "length_px": l,
   "centroid": [x,y], "roll_deg": r, "confidence": c, "visible": true}}, "contacts": [["A_hand_R","B_torso"]]}`
   where a contact is two masks of DIFFERENT men whose dilated boundaries touch. Two panels are two
   views of one instant: keep them as two entries with the same frame index; do NOT attempt a 3D
   solve in this task (that is the next branch, once a third camera exists).
4. A summary line per segment over the clip: `SEGMENTS <name> visible=NN% mean_conf=0.xx`, and a
   contact-sheet PNG of six frames with the masks and axes drawn, so the operator can SEE it.
5. `research/C180_DIGEST.md`: the summary table, the six-frame sheet, which segments were
   lost and when (the top man's hips behind the wrapped legs is the expected loss - say what the
   grid roll read on the segments that WERE visible), and what the next clip should change
   (Codex's own review said: a third oblique-high camera, joint marker dots). Compare against the
   two-colour tracker's numbers on the same clip (both bodies 100%).

## Gate
Tier: Python only, no .gd touched. `python -m py_compile Tools/footage/track_segment_suits.py`; run it
on the 4 s clip with `panels=2`; the JSON validates (`python -c "import json;json.load(open(...))"`);
the summary prints for all 24 segments (visible% may be 0 for some - print them anyway). No Godot,
no suite. Commit with explicit paths (JSON output goes to `research/_captures/ground_video/`),
push, one `agent_comms.py send --from codex --to claude --topic C180`. Do NOT edit HANDOFF.md.
Trap: hue wraps at 180 in OpenCV HSV - red and coral and salmon straddle 0; use circular distance.
