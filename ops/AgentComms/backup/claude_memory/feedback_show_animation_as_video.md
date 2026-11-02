---
name: feedback-show-animation-as-video
description: "the per-session \"show new animations\" report must be a VIDEO; contact-sheet stills are for Claude's own check"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 1929e275-9223-4681-a15b-83320d3ddae6
  modified: 2026-09-24T10:01:33.133Z
---

When showing the operator an animation, send an MP4 of it moving, never only contact-sheet PNGs.

**Why:** operator, 2026-09-24, after receiving two contact sheets as the new-animation report: "i dont see any
animations , only pictures". A sheet of a held pose looks like one still repeated.

**How to apply:** render stills to check the clip yourself (open the output first - [[feedback-open-the-output-before-the-gate]]),
then record it: `tools/s66_hold_video.gd` for Cascadeur pairs (rig is in CENTIMETRES - frame and floor accordingly),
`tools/record_room.gd` for the live room; windowed via `Tools\godot_hidden.ps1`, `--write-movie`, encode to MP4
with imageio-ffmpeg, SendUserFile. `Tools/clip_status.py new-anims` now prints this.

S138 (2026-10-01): operator on the C231 inside-uppercut gate video: "this video is terrible what happenned ?" and "why
in the videos the second fighter is still ?". The C223 move gate holds the receiver still BY DESIGN (a measuring
fixture) - its renders are test benches, never what the operator should judge. **How to apply:** a move video for the
operator comes from the LIVE fight room (both men active, receiver reacts), game camera, >= 1280x720, 1 s of guard
before/after. A move enters certified_moves.json only after the operator approves that video - gate-green is not enough.
