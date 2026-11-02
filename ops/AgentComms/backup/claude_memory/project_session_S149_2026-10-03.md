---
name: project-session-s149
description: S149 2026-10-03 - U215 merged, LADDER1 on Cline, office v2 verdict (front ropes missing, composite doubled), J60 video-generator survey
metadata:
  type: project
---

S149 (2026-10-03, short stage, context budget): U215 merged da105db8; LADDER1 briefed + launched on Cline;
operator on office v2: "kind of ok the ropes of the ring should be covering the boxer inside"; a Dola redraw got "nope"
(doubled corner pads). Root cause: ring_full_00.png has no near-side ropes + the composite shows the still's own ring
under the video. Plan = paint ropes deterministically, not regenerate.

**Why:** two Dola edits failed (camera moved / unchanged) - generators cannot do a "keep exact, add one thing" edit reliably.
**How to apply:** for a small fix to a generated still or clip, composite it in code (cinemagraph.py) before spending
generations; record cinemagraph args in PIPELINE.md. Operator asked about free generators + text-to-video: we use
image-to-video only; J60 (John) surveys Oct 2026 free tiers + commercial licence. Related [[project-session-s148]].
